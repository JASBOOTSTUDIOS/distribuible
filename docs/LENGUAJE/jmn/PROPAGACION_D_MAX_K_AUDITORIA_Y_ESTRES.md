# Propagación de activación: `d_max`, `K`, auditoría y pruebas de estrés

Este documento describe el **uso en Jasboot**, el **alcance** en VM/JMN, los **límites** y la **auditoría** asociados a `propagar_activacion`, `propagar_activacion_de` y las pruebas de estrés. Complementa el modelo conceptual de profundidad en [`flujo_model_IA/02_d_max.md`](../../../flujo_model_IA/02_d_max.md) y la visión por capas en [`CAPAS_JMN_MAI_VM_Y_USO.md`](../CAPAS_JMN_MAI_VM_Y_USO.md).

---

## 1. Objetivo y audiencia

- **Objetivo:** que un desarrollador o integrador pueda configurar la propagación (radio en saltos y tamaño de salida), interpretar resultados y depurar el flujo interno sin adivinar el comportamiento del bytecode.
- **Audiencia:** autores de `.jasb`, mantenedores del SDK (compiler/VM/JMN) y quienes ejecuten regresiones o estrés en CI o localmente.

---

## 2. Alcance: qué está cubierto y qué queda fuera

### Cubierto por la implementación actual

| Área | Descripción |
|------|-------------|
| **Lenguaje** | `propagar_activacion(… [, flags])`, `propagar_activacion_de(… [, flags])`, `propagar_activacion_semillas(lista, d_max, K [, flags])` (§2.3); `flags` opcional literal **entero** (byte IR: bit0 DFS, bit1 suma). |
| **VM** | Decodificación de `C` (incl. octeto alto), semillas desde lista (**`IR_INST_FLAG_SAFE`**), `JASBOOT_PROPAGAR_SEMILLAS`, rastro, auditoría opcional. |
| **JMN** | **BFS o DFS** (pila), modo **suma** o legacy, **`g(τ)`** por tipo (`JASBOOT_PROPAGAR_G` / `JMNPropagarExtra`), **`h(d_v)`**, **`d_max`**, **`K`**, **`jmn_propagar_activacion_semillas`**. |
| **Pruebas** | `tests/test_propagar_d_max.jasb`, `tests/test_propagar_extras.jasb`, estrés `tests/stress_propagar_d_max.jasb` + `tests/run_stress_propagar_d_max.cjs`; matriz **400** casos `tests/test_propagar_400.jasb` + `tests/run_propagar_400.cjs` (auditoría Jasboot opcional por archivo, §10–11). |

### Fuera de alcance (no implementado)

| Tema | Nota |
|------|------|
| **`g(τ)` como tabla distinta por programa sin C ni entorno** | Se configura con **`JASBOOT_PROPAGAR_G`** o `JMNPropagarExtra` desde C; no hay literal de mapa en Jasboot. |
| **Suma multi-ruta exhaustiva (todas las rutas del grafo)** | La suma acumula aportes **`na`** en aristas **exploradas** en el recorrido (sin re-expansión ilimitada por ciclos). |
| **`d_max` como función de contexto desde el lenguaje** | Sin API dedicada; el programa puede calcular `d_max` y pasarlo como argumento. |
| **Umbral / `factor` por parámetros Jasboot** | Siguen fijados en la llamada desde la VM (`0.8`, `0.1`). |
| **Garantía de monotonía del ganador por ID** | El ID ganador no tiene por qué ser monótono al subir `d_max`; el estrés valida la monotonía del **tamaño del rastro** bajo las condiciones del test. |

---

## 2.1 `h(d)` — atenuación por profundidad del destino

Implementado en `jmn_propagar_activacion_semillas` / `jmn_propagar_activacion` según [`flujo_model_IA/04_h_d.md`](../../../flujo_model_IA/04_h_d.md): se **precomputa** `H[0..d_max]` y, al relajar un vecino con profundidad **`d_v`**, la contribución se multiplica por **`H[d_v]`** (convención: profundidad del **destino**).

| `JASBOOT_PROPAGAR_H_MODE` | Comportamiento |
|---------------------------|----------------|
| **0** / ausente | `H[d]=1` para todo `d` dentro del tope (comportamiento histórico salvo el factor por arista `fac`). |
| **1** | Exponencial: `H[d] = λ^d` con `JASBOOT_PROPAGAR_H_LAMBDA` (default `0.7`; debe estar en `(0,1]`). |
| **2** | Inversa: `H[d] = 1/(1+κ·d)` con `JASBOOT_PROPAGAR_H_KAPPA` (default `0.15`). |
| **3** | Lineal: `H[d] = max(0, 1 - d/(d_max+1))` con el **`d_max`** efectivo de la propagación. |

Para `d > d_max`, `H[d]=0` (coherente con no expansión). Con **`d_max=0`**, los vecinos usan `H[1]=0` en modos 1–3, reforzando el corte además del BFS.

---

## 2.2 Multi-semilla (`S₀`)

- **API C:** `jmn_propagar_activacion_semillas(mem, semillas, n_sem, …, extra)` con hasta **16** IDs únicos; el último argumento **`extra`** puede ser `NULL` (entonces DFS/suma/`g` solo por entorno).
- **VM / proceso:** **`JASBOOT_PROPAGAR_SEMILLAS`** añade ids al buffer de semillas (ver §2.3 para lista desde Jasboot).
- **Jasboot:** `propagar_activacion_semillas(lista, d_max, K [, flags])` con **`lista` de `entero`**; ver §2.3.

---

## 2.3 Byte `flags` en el empaquetado IR (octeto alto de `C`)

En `propagar_activacion` / `propagar_activacion_de` / `propagar_activacion_semillas`, el registro **`C`** incluye `(flags << 24)` además de `tipo|K<<8|d_max<<16` (ruta clásica no MAI). Bits definidos:

| Bit | Significado |
|-----|-------------|
| **0** | **1** = orden **DFS** (pila LIFO); **0** = **BFS** (cola). |
| **1** | **1** = acumulación **suma** de aportes `na` en aristas exploradas; **0** = modo **legacy** (mejor `na` por profundidad). |
| 2–7 | Reservado (0). |

**`g(τ)`** multiplicador por tipo de arista: variable **`JASBOOT_PROPAGAR_G`** (lista de floats para tipos JMN **1, 2, 3, …** en orden) o tabla en `JMNPropagarExtra` desde C. Ver `AGENTS.md`.

**`propagar_activacion_semillas(lista, d_max, K [, flags])`**: `lista` es **`lista` de `entero`** (ids de nodo); la VM usa **`IR_INST_FLAG_SAFE`**: el operando **B** es el id de lista JMN; se fusionan ids extra con **`JASBOOT_PROPAGAR_SEMILLAS`** como en la semilla única.

---

## 3. Semántica de `d_max` (profundidad BFS)

Alineado con `02_d_max.md`:

- La **semilla** tiene profundidad **0** respecto a sí misma.
- Un vecino directo tiene profundidad **1**, etc.
- **`d_max = N`** permite expandir mientras la profundidad del nodo actual sea **&lt; N** en el criterio de corte usado en JMN (equivalente a no encolar aristas cuya profundidad resultante superaría el tope deseado para la expansión).

Casos límite importantes:

| `d_max` | Efecto esperado |
|---------|-----------------|
| **0** | Solo la semilla: **no** se expanden aristas; el ganador devuelto suele ser **0** (ningún vecino en el ranking de salida). El rastro puede contener solo la semilla. |
| **1** | Solo vecinos a distancia 1 (salvo efectos de umbral / pesos). |
| **&gt; 32** | En codegen se puede escribir un valor mayor; la **VM lo recorta a 32** antes de llamar a JMN (coherente con el tope interno de `jmn_propagar_activacion`). |

**Compatibilidad hacia atrás:** los binarios antiguos siempre emitían `d_max` explícito (p. ej. 3) en el empaquetado; **ya no** se reinterpreta `0` como “default 3” en la VM. El valor **0** significa literalmente **solo semilla**.

---

## 4. Semántica de `K` (no es “aristas por paso”)

En la implementación JMN actual, el tercer parámetro numérico que la documentación de usuario llama **`K`** corresponde al argumento **`max_out`** de `jmn_propagar_activacion`:

- Limita **cuántos candidatos** entran en el vector de salida **después** de ordenar por activación (mejores primero).
- **No** limita directamente cuántas aristas se exploran por nodo en el BFS (el paso local usa una búsqueda de asociaciones con tope interno alto, p. ej. 64 en el `.c` actual).

Consecuencias:

- Un **`K`** pequeño puede **excluir del resultado** nodos que sí estuvieron en el rastro o en el grafo alcanzable.
- Para auditoría, compare **`rastro_activacion_tamano()`** con el comportamiento esperado; el **ganador** es solo el **top‑1** del vector recortado.

### Regla en VM para `K == 0` en el registro empaquetado

Si el byte de `K` en el empaquetado clásico es **0**, la VM lo sustituye por **8** (valor por defecto histórico). Para forzar un valor concreto, use **1–32** en el empaquetado efectivo.

---

## 5. Uso en Jasboot (firmas y restricciones)

### `propagar_activacion`

```jasboot
entero g = propagar_activacion(concepto)
entero g1 = propagar_activacion(concepto, d_max)
entero g2 = propagar_activacion(concepto, d_max, K)
entero g3 = propagar_activacion(concepto, d_max, K, flags)
```

- **`concepto`:** texto o ID (expresión).
- **`d_max`:** opcional; literal `entero` o expresión; por defecto **3** si se omite.
- **`K`:** opcional; literal `entero` o expresión; por defecto **8** si se omite.
- **`flags`:** opcional; literal `entero` **0–255** (byte alto del pack IR: bit **0** = DFS, bit **1** = suma; ver §2.3).
- **Arity máximo:** 4 argumentos.

### `propagar_activacion_de`

```jasboot
entero g = propagar_activacion_de(concepto, tipo_literal)
entero g1 = propagar_activacion_de(concepto, tipo_literal, d_max)
entero g2 = propagar_activacion_de(concepto, tipo_literal, d_max, K)
entero g3 = propagar_activacion_de(concepto, tipo_literal, d_max, K, flags)
```

- **`tipo_literal`:** debe ser **literal entero** en compilación (típicamente **0–10** para tipo de relación). Si no cumple, el tipo efectivo puede quedar en **0** (todas las relaciones permitidas por la búsqueda local).
- **Arity máximo:** 5 argumentos.

### `propagar_activacion_semillas`

```jasboot
lista sem = []
lista_agregar(sem, id_a)
lista_agregar(sem, id_b)
entero g = propagar_activacion_semillas(sem, d_max, K)
entero g2 = propagar_activacion_semillas(sem, d_max, K, flags)
```

- **`lista`:** `lista` de **`entero`** (ids de nodo JMN), al menos un elemento.
- **`flags`:** igual que en `propagar_activacion` (§2.3).

### `propagar_activacion_mai`

No forma parte del cambio de arity clásico; sigue la semántica documentada en [`CAPAS_JMN_MAI_VM_Y_USO.md`](../CAPAS_JMN_MAI_VM_Y_USO.md) (máscara + `K` + `prof` en el valor `C` con layout MAI).

---

## 6. Empaquetado IR (registro `C`)

### Rama clásica (`OP_MEM_PROPAGAR_ACTIVACION` sin `IR_INST_FLAG_RELATIVE`)

| Bits (conceptual) | Campo |
|-------------------|--------|
| byte bajo | `tipo_rel` (0 = todas las relaciones en la expansión local, según JMN) |
| siguiente byte | `K` (recortado/saneado en VM) |
| tercer byte (bits 16–23) | `d_max` (profundidad máxima; **0** válido) |
| cuarto byte (bits 24–31) | `flags` (bit0 DFS, bit1 suma; §2.3) |

Empaquetado típico: `tipo | (K<<8) | (d_max<<16) | (flags<<24)`.

**Paridad de flags IR (compilador ↔ VM):** los macros **`IR_INST_FLAG_*`** deben coincidir entre **`sdk-dependiente/jas-compiler-c/include/opcodes.h`** y **`sdk-dependiente/jasboot-ir/src/ir_format.h`**. Si el compilador usa otro mapa de bits, instrucciones como **`OP_MEM_PROPAGAR_ACTIVACION`** pueden llevar **`IR_INST_FLAG_RELATIVE`** sin intención y activar la rama MAI con un **`c_pack`** mal decodificado (propagación vacía). Tras alinear headers, hay que **recompilar** los `.jasb` (los `.jbo` antiguos conservan flags incorrectos).

### Rama MAI (mismo opcode con `RELATIVE`)

Layout distinto: máscara en bits bajos, `K` y `d_max` en bytes altos — ver comentarios en `vm.c` y codegen para `propagar_activacion_mai`.

---

## 7. Límites y constantes en JMN (`jmn_propagar_activacion`)

Archivo de referencia: `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_cognitivo.c`.

| Recurso | Límite | Efecto |
|---------|--------|--------|
| Nodos distintos en `vid` | **256** | A partir de saturación, nodos nuevos pueden ignorarse. |
| Cola BFS | **`JMN_BFS_Q_CAP` (384)** | Cola llena → no se encolan más estados; el resultado puede ser incompleto en grafos enormes. |
| `d_max` | **32** máximo efectivo | Valores mayores se recortan. |
| Umbral / factor | Fijos en la llamada VM | Nodos con activación por debajo del umbral no se encolan ni actualizan el ranking como se esperaría. |

**Distancia mínima:** si el mismo nodo se alcanza por dos caminos, se prioriza el de **menor profundidad** para reencolar y actualizar evidencia; a igual profundidad se mejora la activación si sube.

---

## 8. Rastro de activación (correlación con la propagación)

Funciones típicas: `rastro_activacion_limpiar`, `ventana_rastro_activacion`, `rastro_activacion_tamano`, `rastro_activacion_obtener`, `rastro_activacion_peso`, `rastro_activacion_lista`.

- La VM **limpia el rastro** al entrar en `OP_MEM_PROPAGAR_ACTIVACION` y luego el callback JMN **empuja** `(id, activación)` conforme avanza la propagación.
- El rastro puede crecer mucho; use una **ventana** adecuada antes de estrés. Si la ventana se llena, el buffer actúa como cola circular (las entradas antiguas se sobrescriben): la **monotonía estricta del contador** puede estabilizarse en el cap — el test de estrés usa ventana grande (4096) para la fase de monotonía.

---

## 9. Auditoría configurable (VM)

### Variable de entorno `JASBOOT_PROPAGAR_AUDIT`

Evaluada en la VM al ejecutar **`OP_MEM_PROPAGAR_ACTIVACION`** (stderr).

| Valor | Salida |
|-------|--------|
| **0** / ausente / cadena vacía | Sin líneas extra. |
| **1** | Una línea por invocación: modo MAI o clásico, `origen`, `d_max`, `K`, tipo o máscara, `n_out`, mejor id y activación. |
| **2** | Nivel 1 + hasta **64** entradas del rastro actual (`id`, `act`). |
| **3** | Nivel 2 + valor **`c_pack`** (registro `C` leído por la VM). |

**Rendimiento y ruido:** con nivel ≥ 1, cada `propagar_*` imprime al menos una línea. En bucles de estrés (cientos de iteraciones) el volumen de stderr es muy alto; use niveles altos solo en reproducciones cortas o baje `ITER_ESTRES` en `tests/stress_propagar_d_max.jasb`.

**Relación con `JASBOOT_DEBUG=1`:** es independiente; `JASBOOT_DEBUG` activa otras trazas generales de la VM (más ruidosas).

---

## 10. Auditoría en Jasboot (estrés y matriz 400)

### Estrés `stress_propagar_d_max.jasb`

La constante **`AUDITORIA_JASB`** (0–3) controla `imprimir` de resúmenes por fase y muestreo ligero en el bucle largo. No sustituye a `JASBOOT_PROPAGAR_AUDIT`; son complementarias (Jasboot → stdout, VM → stderr).

### Matriz `test_propagar_400.jasb` (auditoría por archivo)

Para **400** invocaciones deterministas a `propagar_activacion` sin recompilar, el test lee un archivo opcional en el **cwd del `.jasb`** (al usar `node .vscode/run-jasb.cjs tests/...`, suele ser la carpeta `tests/`):

| Archivo | Contenido |
|---------|-----------|
| **`tests/.propagar_400_auditoria`** | Primera línea: un dígito **`0`**, **`1`** o **`2`**. **`0`** = sin trazas extra (solo inicio y resultado). **`1`** = una línea `[P400]` por caso (`i`, `d_max`, `K`, `flags`, ganador). **`2`** = nivel 1 + `rastro_activacion_tamano()` tras cada propagación principal. |

- **Desde Node:** `node tests/run_propagar_400.cjs --jasboot-audit` o `--jasboot-audit=2` crea ese archivo antes de ejecutar y lo borra al terminar (mejor esfuerzo).
- **Solo Jasboot / IDE:** cree `tests/.propagar_400_auditoria` manualmente (p. ej. contenido `1` + salto de línea) antes de F5 o `run-jasb`; el test lo lee al inicio.
- La **auditoría VM** (`JASBOOT_PROPAGAR_AUDIT` / `--propagar-audit=N`) sigue yendo a **stderr**; con 400 casos el nivel ≥1 es muy ruidoso.

---

## 11. Pruebas y comandos

### Regresión corta

```bash
node .vscode/run-jasb.cjs tests/test_propagar_d_max.jasb
```

Comprueba `d_max = 0`, ganador a un salto, `propagar_activacion_de` con `d_max = 0`, y crecimiento del rastro al subir `d_max`.

### Estrés comprobable

```bash
node .vscode/run-jasb.cjs tests/stress_propagar_d_max.jasb
```

O con el runner (pasa variables de entorno al hijo):

```bash
node tests/run_stress_propagar_d_max.cjs
node tests/run_stress_propagar_d_max.cjs --propagar-audit=2
node tests/run_stress_propagar_d_max.cjs --jasboot-debug=1
```

### Matriz 400 casos (`d_max`, `K`, `flags`, BFS vs DFS)

```bash
node .vscode/run-jasb.cjs tests/test_propagar_400.jasb
node tests/run_propagar_400.cjs
node tests/run_propagar_400.cjs --jasboot-audit=1
node tests/run_propagar_400.cjs --jasboot-audit=2 --propagar-audit=1
```

Comprueba invariantes básicos (`d_max=0` → ganador 0; `d_max≥1` → ganador no nulo en el grafo del test), muestreo BFS vs DFS en índices `i % 77 == 0`, y usa memoria `tests/tmp_propagar_400.jmn` (ignorada en git junto con `.propagar_400_auditoria`). Convención de auditoría Jasboot: §10.

### Invariantes del estrés (`stress_propagar_d_max.jasb`)


- `d_max = 0` → ganador 0 y rastro mínimo coherente.
- Al aumentar `d_max` de 1 a 18, el **tamaño del rastro** no decrece (bajo ventana 4096 y el grafo del test).
- El **nodo final de cadena** aparece en el rastro solo cuando `d_max` alcanza **1 + LARGO_CADENA** (profundidad del nodo final); con `d_max = LARGO_CADENA` no debe aparecer.
- Bucle de iteraciones con `d_max` y `K` variables sin fallos de consistencia básica.
- Smoke de `propagar_activacion_de` y `propagar_activacion_mai`.

**Nota de diseño del grafo de estrés:** las aristas de la cadena usan pesos altos (p. ej. 0.98) para que la activación no caiga por debajo del **umbral fijo** de la propagación en la VM; si se debilitan mucho las aristas o se alarga la cadena sin recalcular, el CHECK‑C puede fallar aunque el algoritmo sea correcto.

---

## 12. Tabla de problemas frecuentes

| Síntoma | Causa probable | Qué revisar |
|---------|----------------|-------------|
| Siempre ganador 0 con `d_max ≥ 1` | Sin aristas útiles, o todo por debajo del umbral | Pesos, `tipo_rel`, memoria vacía |
| CHECK‑C del estrés falla | Cadena demasiado larga o pesos bajos | `LARGO_CADENA` y `asociar_relacion` en el `.jasb` |
| “Monotonía” del rastro falla | Ventana de rastro pequeña o saturación | `ventana_rastro_activacion` y número de nodos tocados |
| Mucho stderr | `JASBOOT_PROPAGAR_AUDIT` alto en bucle largo | Bajar nivel o iteraciones; en 400 casos preferir auditoría Jasboot (`tests/.propagar_400_auditoria`, §10) |
| `tipo` en `_de` no filtra | Literal no válido en compilación | Segundo argumento literal 0–10 |

---

## 13. Referencias de código (SDK canónico)

| Componente | Ruta |
|------------|------|
| Codegen propagación clásica / MAI | `sdk-dependiente/jas-compiler-c/src/codegen.c` |
| Opcode VM, auditoría y `JASBOOT_PROPAGAR_SEMILLAS` | `sdk-dependiente/jasboot-ir/src/vm.c` (`OP_MEM_PROPAGAR_ACTIVACION`, `vm_propagar_audit_maybe`, `vm_propagar_semillas_desde_env`) |
| BFS JMN, `h(d)`, multi-semilla | `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_cognitivo.c` (`jmn_propagar_activacion`, `jmn_propagar_activacion_semillas`) |
| Modelo `d_max` | `flujo_model_IA/02_d_max.md` |
| Modelo `h(d)` | `flujo_model_IA/04_h_d.md` |
| Variables de depuración (lista breve) | `AGENTS.md` (sección Debug) |

---

## 14. Mantenimiento del documento

Al cambiar límites (`vid`, cola, umbral en VM, defaults de `K`), actualizar las **tablas de límites** y los **tests** asociados para que este archivo siga siendo la fuente de verdad operativa.
