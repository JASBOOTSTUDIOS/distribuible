# Preguntas técnicas críticas para implementar MAI de forma realista — respuestas (Jasboot)

Este documento **responde en detalle** cada bloque de preguntas que planteaste, con tres capas explícitas:

1. **En el código hoy** — lo que existe en el repositorio Jasboot (MAI en `mai.c`/`mai.h`, JMN en `jasboot-jmn-core`, VM, journal `.jwl`, etc.).
2. **Diseño / hoja de ruta** — lo descrito en `docs/dev/plan_implementacion_replicante.md`, `docs/dev/vision_ia_humana_mai.md` o `docs/TECNICO/FORMATO_JMN.md` pero **aún no** como motor completo.
3. **Recomendación** — criterio para cerrar la brecha entre “idea” y “sistema” sin confundir prototipo con producto.

**Ley física mínima** (tu recomendación final): en Jasboot, las “leyes” operativas actuales son en la práctica **(1)** estructura `MAIActiveNeuron` + colas + mutex, **(2)** grafo JMN (nodo/conexión/texto) + CRC + journal, **(3)** VM de un hilo para mutaciones JMN coherentes, **(4)** presupuestos (`MAI_Q_CAP`, `MAI_MAX_ACTIVE_NEURONS`, `MAI_LRA_LIMIT_MB`, throttles en reflexión/sueño).

---

# 1. Arquitectura neuronal base

## 1.1 Representación de neurona

### ¿Qué contiene exactamente una neurona?

Hay que separar **dos** entidades que hoy conviven con el nombre “neurona” en el discurso del proyecto:

| Entidad | Rol | Dónde está |
| -------- | --- | ---------- |
| **Nodo JMN (`JMNNodo`)** | Concepto persistente en el grafo: `id` (uint32) + `peso` (`JMNValor`: float o bits u32). | `memoria_neuronal.h` |
| **Neurona activa MAI (`MAIActiveNeuron`)** | Estado de trabajo en RAM para un **id de concepto** (hash de texto u otro id): energía, potencial, refractario, mini-historial de potencial, tasas, umbral, tick de acceso. | `mai.h` |

**En el código hoy**, una `MAIActiveNeuron` contiene:

- `id_hash` — identificador del concepto (coherente con IDs de texto/JMN).
- `energy`, `potential` — estado energético / acumulador de activación.
- `last_update`, `in_refractory`, `refractory_end` — control de refractario (evita re-disparo inmediato).
- `context[MAI_CONTEXT_BUFFER_SIZE]` con `MAI_CONTEXT_BUFFER_SIZE = 10` — **no** es “10 turnos de diálogo”, sino un **buffer numérico** de los últimos valores de `potential` muestreados en `mai_touch` (deslizante).
- `context_idx` — índice circular en ese buffer.
- `decay_rate`, `threshold` — parámetros por neurona (por defecto `MAI_DEFAULT_DECAY` / `MAI_DEFAULT_THRESHOLD` en `mai.c`).
- `access_tick` — marca de “último toque” con `mai->global_tick` para políticas tipo LRA.

**No** están en la struct MAI como campos de primera clase: embeddings vectoriales, emociones etiquetadas, timestamps absolutos de pared, “asociaciones” embebidas (las asociaciones viven en **JMN** como aristas).

### ¿Tamaño exacto en bytes?

- Depende del compilador y del *padding*, pero puedes obtenerlo con `sizeof(MAIActiveNeuron)` en un pequeño programa de prueba. Orden de magnitud: **unas decenas de bytes por neurona activa** (del orden de 80–96 bytes típicos en x64 por alineación de `float` y `uint64_t access_tick`), más la tabla hash global (`uint32_t` por slot × `MAI_HASH_SIZE`).

**Nodo JMN en disco (v1):** 8 bytes por nodo (ver `FORMATO_JMN.md`). **Conexión:** 16 bytes por arista en el layout serializado.

### ¿Cómo evitar que cada neurona pese demasiado?

**En el código hoy:**

- Cota de **capacidad** de neuronas activas: `mai_init(capacity, ...)` y `MAI_MAX_ACTIVE_NEURONS` como referencia de escala; si `count >= capacity`, `mai_get_or_create_neuron` **deja de crear** (fallo silencioso: retorna NULL).
- **LRA suave** (`mai_maybe_lra` / `mai_lra_soft_batch`): cuando la estimación de RAM supera `lra_limit_bytes` (por defecto 2048 MiB, configurable con `MAI_LRA_LIMIT_MB`), se “suaviza” un subconjunto de neuronas de baja energía y se **vuelca un registro mínimo** a un archivo temporal (`mai_lra_path`) — no es un swap completo de grafo JMN.
- El **peso** del grafo pesado sigue siendo **JMN** (mmap/huge alloc en el core), no el vector `neurons[]` de MAI.

**Recomendación:** fijar política explícita “¿qué pasa si MAI está lleno?” (rechazo vs eviction LRU de **slots** en `neurons[]`, no solo LRA suave). Documentar el NULL de `mai_get_or_create_neuron` para callers futuros.

---

## 1.2 Activación neuronal

### ¿Qué fórmula activa una neurona?

**En el código hoy (córtex, mensaje `MAI_MSG_ACTIVATION` / inhibición):**

1. Se obtiene o crea `MAIActiveNeuron` para `target_id`.
2. Si **no** está en refractario (`!in_refractory`): `potential += value` (valor del mensaje, típicamente escalado desde la VM).
3. Si `potential > threshold`: se considera “disparo”: `energy = 1.0f`, `potential = 0`, `in_refractory = 1`.
4. Siempre se llama `mai_touch` (actualiza `access_tick` y escribe una muestra de `potential` en el buffer circular).

Esto es una mezcla **energética + umbral**, **no** una sigmoide clásica ni una probabilidad bayesiana explícita.

### ¿Cómo evitar explosiones asociativas?

**En el código hoy:**

- **Refractario** tras cruce de umbral (evita oscilación infinita en el mismo nodo MAI).
- **Decay de energía** en `mai_process_cycle` (proporcional a `decay_rate` y `delta_ms`).
- **Reflexión desde JMN** (`mai_reflect_from_jmn`): *throttle* estático (`throttle % 3`), **presupuesto** de aristas examinadas (`budget`, `jmn_budget`), y envío de activaciones con prioridad acotada — no recorre el grafo completo.
- **Sueño MAI** (`MAI_MSG_SUEÑO` en worker subconsciente): multiplica `potential` y `energy` por factores < 1 (suavizado global en el subconjunto en mutex).

**No** hay aún un “inhibidor global” tipo normalización softmax sobre todas las neuronas activas.

**Recomendación:** si quieres la forma \(A_{n+1} = A_n e^{-\lambda t}\), hoy la más cercana es **combinar** decay en `mai_process_cycle` + mensaje sueño; habría que **formalizar** una ecuación única y unidades de tiempo compartidas entre VM tick y MAI `delta_ms`.

---

## 1.3 Propagación

### ¿Cuántos saltos máximos puede hacer una activación?

- **En JMN**, la propagación tipo BFS/asociaciones está en funciones como `jmn_buscar_asociaciones` con **profundidad** y umbral (la VM pasa parámetros en opcodes concretos; ver usos en `vm.c` / pensar / propagar).
- **En MAI**, la “propagación” no es un recorrido libre de grafo en RAM: es **mensajes** a destinos ya conocidos (p. ej. reflexión elige vecinos desde JMN y encola activaciones).

### ¿Cómo decides qué conexiones seguir?

**Hoy:** criterios en JMN (tipo de relación, fuerza, umbral, profundidad) + **muestreo** de semillas desde neuronas MAI activas con energía suficiente en `mai_reflect_from_jmn`.

### ¿Qué pasa si millones de neuronas se activan a la vez?

**Hoy:** no hay millones de hilos disparando; hay **2 workers** y colas acotadas (`MAI_Q_CAP = 8192`). Si la cola está llena, `mai_priq_push` **no siempre descarta**: si el mensaje nuevo tiene **mayor prioridad** que el peor ya en cola, **expulsa** el de menor prioridad e inserta el nuevo; si la prioridad no justifica expulsar, retorna **-1**. `mai_send_message_ex` propaga ese código, incrementa `enqueue_failures` y, con `JASBOOT_DEBUG`, escribe una línea en stderr.

### ¿Existe prioridad contextual?

**Sí, parcialmente:** cola por prioridad (`priority` en `MAIMessage`), distinto enrutamiento córtex vs subconsciente. El “contexto” semántico largo del diálogo **no** está modelado como embedding; el buffer `context[]` es **histórico de potencial**, no de tokens.

---

## 1.4 Inhibición

### ¿Cómo se desactivan neuronas?

- **Mensaje `MAI_MSG_INHIBITION`** resta activación vía el mismo camino que suma con signo (`mai_activate_neuron` con valor negativo en córtex).
- **Decay** en `mai_process_cycle` reduce `energy`.
- **Sueño** reduce `potential`/`energy` en bloque.
- **LRA suave** pone a cero contextos locales y reduce `potential` en neuronas muy frías.

### ¿Habrá neuronas inhibitorias dedicadas?

**No como tipo separado** en `MAIMessageType` más allá de `INHIBITION`. En JMN sí hay relaciones de oposición/similitud como **tipos de arista**, no “neuronas I/E” biológicas explícitas.

### ¿Cómo evitar loops infinitos?

- **Refractario** post-disparo.
- **Profundidad y presupuesto** en búsquedas JMN.
- **Throttling** de reflexión y de sueño JMN (`MAI_SUEÑO_JMN_WAVE_EVERY`, etc., ver `mai.c` y `docs/LENGUAJE/jmn/JMN_JOURNAL_Y_CONSOLIDACION.md`).

**Riesgo residual:** cualquier bucle **a nivel Jasboot** (while mal escrito) sigue siendo posible; MAI no lo sustituye.

---

# 2. Memoria y almacenamiento

## 2.1 Formato JMN

### ¿Cómo se serializa una neurona (nodo)?

**Binario fijo por registro** en archivo: bloque de **8 bytes** `id` + `peso.u` (ver `FORMATO_JMN.md`).

### ¿Cómo versionarás el formato?

**Hoy:** cabecera `version` 1 o 2; v2 añade listas/mapas antes del CRC. Migración documentada en el mismo archivo técnico.

### ¿Cómo manejarás corrupción parcial?

**Hoy:**

- **CRC32** al final del payload en archivos nuevos.
- **Journal `.jwl`** append-only + opción de **replay** al abrir si el `.jmn` no es legible (`JASBOOT_JWL_REPLAY`, etc.).
- Variable **`JASBOOT_JMN_NO_FINAL_SAVE`** para no pisar `.jmn` en cierre durante pruebas de corrupción.

**Recomendación:** corrupción “a mitad de registro” en `.jwl` requiere política explícita (truncar al último commit `0xFF`, checksum por entrada, etc.) — parte del “2.2 masivo” pendiente.

---

## 2.2 Índices

### ¿Cómo localizar neuronas/conceptos rápidamente?

- **JMN:** hashes de texto → id; tablas internas en el core (ver implementación en `memoria_neuronal_*`).
- **MAI:** tabla hash abierta `mai->hash_table` → índice en `neurons[]` (linear probing circular).

### ¿Hash maps, B-trees, LSM, índices semánticos?

**Hoy:** predominan **hash** y estructuras del propio core JMN. **No** hay LSM ni índice semántico vectorial en el motor base.

---

## 2.3 SSD

### Lecturas aleatorias, write amplification, desgaste

**En el código hoy:** el core JMN usa **archivos grandes** y **huge alloc** / swap temporal según plataforma; la política agresiva de optimización SSD (colas de escritura, batching wear-leveling) **no está encapsulada** como subsistema documentado en C.

**Recomendación:** tratar SSD como requisito de **sistema operativo** + tamaño de página + `fsync` estratégico; medir con benchmarks reales (`benchmarks/` en el repo cuando apliquen).

---

## 2.4 mmap

### ¿Cuándo usar mmap? ¿Qué permanece cargado? ¿Page faults?

**Hoy:** JMN usa mapeo/memoria virtual a través del **core** (mensajes de log tipo “Huge alloc … swap”). No hay un “modo mmap” documentado como API separada para el programador Jasboot.

**Recomendación:** cuando el archivo supere un umbral (p. ej. decenas de GB), definir **regiones calientes** (cabecera + tabla de nodos recientes) vs **frías** (textos largos), y medir fallos de página con herramientas del SO.

---

## 2.5 Compresión

**Hoy:** textos en JMN con longitud acotada por slots; **no** hay compresión generalizada transparente en el path crítico.

**Recomendación:** comprimir solo **textos fríos** o dumps archivados; mantener RAM con representación sin comprimir para latencia.

---

# 3. Memoria activa (RAM)

## 3.1 LRA

### ¿Qué define “Least Recently Activated”?

**En el código hoy** el LRA es **heurístico**, no un LRU estricto con lista enlazada:

- `mai_touch` actualiza `access_tick` con `++mai->global_tick`.
- `mai_lra_soft_batch` elige candidatos pseudoaleatorios con baja `energy`, les reduce `potential`, resetea contexto local y **append** a un archivo de volcado ligero.

**No** es “emocional” ni “frecuencia histórica” explícita; la emoción no es un campo.

---

## 3.2 Cache neuronal

### ¿Qué mantener en RAM?

**Hoy:** lo que cabe en `capacity` de MAI + política de no crecer más allá del límite; JMN mantiene su propia memoria de trabajo.

### ¿Predicción contextual / frecuencia / recencia?

**Recencia:** `access_tick`. **Frecuencia:** implícita en reactivaciones. **Predicción:** no hay modelo predictivo dedicado en MAI.

---

## 3.3 Fragmentación

**En el código hoy:** `neurons[]` es un **array** creciente; la fragmentación de **heap** del proceso depende del `malloc` del sistema. **No** hay pool/arena/slab específico para `MAIActiveNeuron` en `mai.c`.

**Recomendación:** si el churn es alto, **arena** por generación o slab por página para neuronas MAI + freelist de índices.

---

# 4. Sistema de aprendizaje

## 4.1 Aprendizaje incremental

### ¿Qué cambia tras cada interacción?

**Hoy (típico flujo Jasboot + JMN):**

- Nuevos o actualizados **nodos** y **conexiones** en JMN (`recordar`, `asociar_relacion`, etc.).
- Posibles entradas en **`.jwl`** para recuperación.
- **MAI** puede recibir mensajes de activación desde la VM cuando hay `mai_system` y opcodes que lo disparan; además el **anillo de contexto** en la VM (`mai_ctx_ring`) se actualiza en rutas de memoria (`vm_mai_note_context`).

**Embeddings:** no en el núcleo descrito aquí.

---

## 4.2 Consolidación

### ¿Cuándo lo temporal se vuelve permanente?

**Hoy:**

- **Explícito en lenguaje:** `consolidar_memoria`, `dormir`, `consolidar`, `consolidar_sueno` → `jmn_consolidar_memoria_sueno` / `jmn_finalizar_escritura` en rutas VM.
- **En segundo plano (MAI):** si `MAI_SUEÑO_JMN=1`, el scheduler aplica consolidación suave con cadencia configurable (`MAI_SUEÑO_JMN_WAVE_EVERY`, factores `MAI_SUEÑO_JMN_*`).

**No** hay hoy un bit “episódico vs semántico” por arista que automatice promoción.

---

## 4.3 Olvido

**Hoy:** `jmn_decaer_conexiones_global`, `jmn_olvidar_conexiones_debiles`, penalización, consolidación sueño — mezcla de **decaimiento multiplicativo** y **poda por umbral**.

Un modelo \(w_t = w_0 e^{-\lambda t}\) puede **aproximarse** por pasadas discretas; la implementación concreta está en el core JMN (revisar `memoria_neuronal_core.c` / funciones citadas en headers).

---

## 4.4 Sobreaprendizaje

**Hoy:** parcialmente mitigado por **decaimiento**, **olvidar débiles** y **límites** de cola MAI; **no** hay “regularización bayesiana” explícita ni separación train/validation en memoria.

**Recomendación:** tasa de aprendizaje por tipo de relación + “ventana de plasticidad” temporal por arista (campos extra en `JMNConexion` en futuras versiones de formato).

---

# 5. Cognición y razonamiento

## 5.1 Contexto

### ¿Qué define el “contexto activo”?

**Tres capas distintas hoy:**

1. **Ring VM** `mai_ctx_ring` (10 ids) + API `mai_contexto_recientes` — foco reciente de **conceptos** tocados por ciertos opcodes.
2. **Buffer `context[]` en MAI** — últimas muestras de **potencial**, no texto.
3. **Percepción / rastro** en VM — otras colas opcodes (`percepcion_*`, `rastro_activacion_*`).

### ¿10 estados son suficientes?

Para **IDs de foco** en diálogo corto, 10 es un **orden de magnitud razonable** para pruebas; para conversaciones largas **no** sustituye a un resumen semántico.

### ¿Cómo resumir conversaciones largas?

**Hoy:** no hay resumen automático en el motor; habría que **programarlo en Jasboot** (chunking + `recordar` jerárquico) o añadir subsistema.

---

## 5.2 Intuición

**Técnicamente hoy:** “asociación rápida” ≈ **búsqueda en grafo JMN** con umbral + activación MAI por mensaje cuando la VM lo dispara.

---

## 5.3 Reflexión

**Hilo subconsciente hoy:** procesa `REFUERSO` y `SUEÑO` (ajuste de potencial/energía), **no** reescribe el grafo JMN directamente. La escritura JMN “reflexiva” coordinada va por **`mai_reflect_from_jmn`** en el hilo que llama a `mai_process_cycle` (coherente con el diseño documentado: JMN no mutado desde workers).

---

## 5.4 Objetivos internos y planeación

**Hoy:** **no** hay representación de metas persistentes ni simulación explícita de futuros en MAI.

**Recomendación:** metas como **subgrafos** JMN (nodos “meta-*” con relaciones de coste) + planificador que consuma presupuesto de CPU.

---

# 6. Lenguaje y comprensión

## 6.1 Representación semántica

**Hoy:** un **concepto** ≈ **nodo** (id) + **texto** opcional + **conexiones tipadas**. No es un embedding denso en el núcleo.

---

## 6.2 Ambigüedad

**Hoy:** múltiples nodos pueden compartir literal; la VM tiene **`vm_jmn_ids_para_literal`** y heurísticas en opcodes tipo `OP_MEM_OBTENER_VALOR` para elegir candidato con texto válido.

---

## 6.3 Relaciones (causalidad, temporalidad, pertenencia, intención, emociones)

**Hoy:** tipos de relación numéricos (`JMN_RELACION_*` hasta un máximo). La **semántica** causal/emocional es **responsabilidad del modelo de datos** que construyas encima (convenciones de nombres y tipos), no del motor únicamente.

---

## 6.4 Tokenización

**Hoy:** el lenguaje Jasboot opera sobre **texto** y **conceptos**; no hay un tokenizer BPE integrado al VM. Los “tokens” son, en la práctica, **cadenas** y **ids** de concepto.

---

# 7. Energía y rendimiento

## 7.1 Sistema energético

**Sí hay costo implícito:** cada activación consume ciclos de mutex/cola; cada mensaje ocupa espacio finito en `MAI_Q_CAP`.

---

## 7.2 Scheduler cognitivo

**Prioridad hoy:** usuario (VM principal) > workers que drenan colas; reflexión/sueño JMN **throttled**; consolidación explícita en lenguaje tiene prioridad de “usuario pidió”.

---

## 7.3 Throttling y CPU al 100%

**Hoy:** backpressure principal = **cola llena** (descarte) + throttles numéricos. **No** hay integración directa con `% CPU` del SO.

---

## 7.4 Límites duros

| Situación | Comportamiento típico hoy |
| --------- | ------------------------- |
| RAM llena / presión MAI | LRA suave + dejar de crear neuronas si `capacity` |
| SSD lento | latencia alta; no hay QoS integrado |
| Journal gigante | replay más lento; checkpoint opcional trunca tras guardado |
| Corrupción | CRC / replay / mensajes de error en carga |

---

# 8. Concurrencia y threading

## 8.1 Sincronización

**Mutex** central en `MAISystem` para colas y neuronas; workers duermen en `pthread_cond_wait`.

---

## 8.2 Deadlocks

**Diseño explícito:** workers **no** llaman a APIs que bloqueen esperando a la VM si la VM espera a workers (riesgo teórico si se cruza mal). La VM no debería tomar `mai->mutex` mientras otros hilos… — cualquier nueva llamada cruzada debe revisarse con un grafo de bloqueos.

---

## 8.3 Prioridades

Colas separadas + `priority` en mensaje; subconsciente no “interrumpe” al córtex a nivel de SO, pero **sí** compite por CPU; el scheduling lo decide el kernel.

---

# 9. Persistencia e identidad

## 9.1 Identidad persistente

**Hoy:** “personalidad” = **contenido del `.jmn`** (grafos + textos) + eventual estado MAI **no persistido** salvo lo que vuelques a JMN/LRA file.

---

## 9.2 Consistencia (contradicciones)

**Hoy:** no hay resolvedor global de contradicciones; existe infraestructura de **conflictos** en headers JMN (`JMNConflictoResultado`) para rutas específicas.

---

## 9.3 Evolución (“¿mejoró?”)

**Hoy:** métricas de mejora **no** están unificadas; se puede medir offline (tamaño grafo, fuerza media, tests de tarea).

---

# 10. Seguridad y estabilidad

## 10.1 Corrupción / apagones / journal incompleto

**Hoy:** `.jwl` + replay + `JASBOOT_JMN_NO_FINAL_SAVE` para pruebas; CRC en `.jmn`.

---

## 10.2 Integridad

CRC32 en snapshot; commits en journal; **rollback completo** multi-sesión no documentado como producto único.

---

## 10.3 Límites cognitivos (delirios, loops)

**Mitigación parcial:** umbrales, profundidad, refractario, colas acotadas.

**Recomendación:** capa de “coherencia” en Jasboot que penalice aristas que generan contradicción detectable por plantillas.

---

# 11. Multimodal

**Hoy en núcleo:** no implementado el “hash multimedia” como pipeline de archivos vinculados a nodos.

**Recomendación:** id de nodo + tabla auxiliar `id → path` o blob externo; parámetros de audio derivados de **energy/potential** agregados por región emocional **si** defines esa región en el grafo.

---

# 12. Escalabilidad futura

## 12.1 Distribución entre máquinas

**Hoy:** un proceso; **no** hay partición de grafo entre nodos de red.

---

## 12.2 Compatibilidad de formato

**Hoy:** versiones 1/2 documentadas; cambios mayores requieren migración explícita.

---

## 12.3 Hardware (dual core → servidor)

**Hoy:** parámetros `MAI_LRA_LIMIT_MB`, workers fijos, límites de cola.

**Recomendación:** perfilar con `MAI_NUM_WORKERS` configurable solo después de demostrar ausencia de regresiones de mutex.

---

# 13. Filosofía central del sistema

Estas respuestas son **definiciones operativas** alineadas con el código; la filosofía “humana” puede enriquecerse, pero el motor **obliga** a estas disciplinas.

## ¿Qué es realmente una neurona MAI?

**Una neurona MAI** es un **registro de estado dinámico** asociado a un `id_hash` de concepto, con acumulador `potential`, nivel `energy`, refractario y un mini-historial de potencial — **no** es el concepto persistente; ese es el **nodo JMN**.

## ¿Qué significa “pensar” en MAI?

**Hoy:** “pensar” en el producto Jasboot incluye opcodes JMN (`pensar`, razonamiento multipath, etc.) **fuera** de la cola MAI estricta. MAI aporta **activación diferida** y **sueño** sobre el grafo cuando se configura el entorno.

## ¿Qué significa “comprender”?

**Operativo hoy:** recuperar y relacionar **texto/conceptos** en JMN con políticas de búsqueda y umbral — no implica “comprensión” en sentido de modelo de lenguaje grande.

## ¿Qué diferencia una memoria de un concepto?

**Memoria** suele referirse al **archivo/estado JMN** + journal; **concepto** es un **nodo** (id) con posible texto y aristas.

## ¿Qué produce una emoción?

**Hoy:** no hay variable “emoción”; podrías **modelarla** como subgrafo o como canal extra (futuro).

## ¿Qué hace que una asociación sea relevante?

**Fuerza** de arista + tipo + algoritmos de búsqueda (`buscar_asociados_lista`, propagación, etc.).

## ¿Qué define conciencia activa?

**En este proyecto:** conciencia activa ≈ **conjunto de políticas de atención**: ring de contexto en VM + estado MAI + lo que el programa Jasboot imprime/consolida. No es metafísica implementada.

## ¿Qué significa “olvidar”?

**Operativo:** reducir o eliminar fuerzas bajo umbral, decaimiento, consolidación — ver JMN.

## ¿Qué hace que una respuesta sea “inteligente”?

**Fuera del motor:** calidad del programa, datos, y límites del razonamiento simbólico; **dentro del motor:** coherencia, recuperación estable y ausencia de corrupción.

---

# Recomendación crítica (formalizar antes de más código)

Define por escrito (y con tests) estos **siete contratos**, ya iniciados en el repo pero no siempre acoplados:

1. **Neurona** — diferenciar `JMNNodo` vs `MAIActiveNeuron` y tamaños/padding.
2. **Activación** — ecuación única (umbral + decay + inhibición) y unidades de tiempo.
3. **Propagación** — profundidad, presupuesto, política cuando la cola está llena.
4. **Memoria** — layout JMN v1/v2, journal, recovery matrix (apagón, crash, replay parcial).
5. **Energía** — qué cuenta como “costo” (CPU, mensajes, bytes LRA).
6. **Consolidación** — cuándo VM vs `MAI_SUEÑO_JMN` y parámetros por defecto seguros.
7. **Contexto** — qué buffer usa el lenguaje (`mai_contexto_recientes`) vs qué buffer usa MAI (`context[]` de potencial) — **unificar nombres en documentación** para no confundir a futuros implementadores.

---

## Referencias internas

- `sdk-dependiente/jasboot-ir/src/mai.h`, `mai.c`
- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal.h`, `memoria_neuronal_journal.c`
- `docs/TECNICO/FORMATO_JMN.md`
- `docs/LENGUAJE/jmn/JMN_JOURNAL_Y_CONSOLIDACION.md`
- `docs/dev/plan_implementacion_replicante.md`, `docs/dev/vision_ia_humana_mai.md`
- `docs/dev/MAI_CRITERIOS_MEDIBLES_Y_CONTRASTE_CODIGO.md` (criterios de producto medibles vs código)
- `AGENTS.md` (variables de entorno y tests)

---

*Documento generado para alinear expectativas de implementación realista con el estado del código Jasboot. Actualizar cuando cambien structs críticos o el formato JMN.*
