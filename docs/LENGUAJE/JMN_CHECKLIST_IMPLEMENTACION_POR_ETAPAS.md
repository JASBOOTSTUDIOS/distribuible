# Checklist de implementación por etapas (JMN / conversación / cognición simbólica)

**Relacionado:** [ASOCIACIONES_JMN_VIDA_REAL_BUSQUEDA_Y_RESPUESTA.md](./ASOCIACIONES_JMN_VIDA_REAL_BUSQUEDA_Y_RESPUESTA.md), [TIPOS_RELACION_JMN.md](./TIPOS_RELACION_JMN.md), [JMN_PLAN_CAPA_FONETICA_FUTURO.md](./JMN_PLAN_CAPA_FONETICA_FUTURO.md).  
**Última revisión:** 2026-05-14.

---

## Cómo leer este documento

### Orden global (prioridad + dependencia)

Las **etapas** van de **E0 → E6** (bloques lógicos). Dentro de cada etapa, los ítems van **numerados**; conviene completarlos en ese orden **en la misma etapa**.

### “Independencia” del test

Cada ítem incluye un **test autocontenido**: no exige que etapas **posteriores** estén implementadas para poder ejecutarlo y obtener un veredicto claro.  
Lo que sí puede pedir es:

- toolchain ya compilable (`jbc`, VM),
- **fixtures** locales (`.jmn` de prueba en `build/` o `tests/tmp/`, borrables),
- **dobles** o capas en blanco si aún no existe el módulo final.

Si un ítem reutiliza utilidades de otro ítem **de la misma etapa**, el orden dentro de la etapa lo resuelve.

### Convención por ítem

| Campo        | Significado                                                   |
| ------------ | ------------------------------------------------------------- |
| **Tarea**    | Qué implementar.                                              |
| **Test**     | Cómo medir (comando, script o checklist manual reproducible). |
| **Esperado** | Criterio de aceptación al marcar hecho.                       |

Marca cada casilla cuando **Tarea + Test verde + Esperado** cumplan.

---

## E0 — Medición, trazas y contratos (sin lógica “cognitiva” nueva)

> Base para saber si lo demás mejora o solo se complica. **Ningún** ítem de E1+ debería mezclarse aquí sin tests.

### E0.1 — Contrato de métricas mínimas

**Implementado (2026-05-14):** carpeta [`tests/baseline/e0_1_jmn_metricas/`](../../tests/baseline/e0_1_jmn_metricas/) — contrato en `METRICAS_E0_1.md`, fixture `fixture_e0_1.jasb`, script `run_baseline.cjs`, valores en `baseline_e0_1.json`.

- [x] **Tarea:** Definir y documentar 3–5 **métricas** concretas (ej.: longitud de respuesta en tokens/caracteres, número de aristas recorridas en una consulta, tiempo de expansión, tasa de “contra-pregunta” vs respuesta directa, errores de activación nula). _Incluye M1–M7 activas + M8–M10 reservadas (E0.2 / E4+)._
- [x] **Test:** `node tests/baseline/e0_1_jmn_metricas/run_baseline.cjs` (JSON en stdout); `node tests/baseline/e0_1_jmn_metricas/run_baseline.cjs --compare` (regresión estricta, sin comparar `wall_ms_*`).
- [x] **Esperado:** `baseline_e0_1.json` versionado; regenerar con `node tests/baseline/e0_1_jmn_metricas/run_baseline.cjs --write-baseline` tras cambios intencionados en salida o tamaño `.jmn` del fixture.

### E0.2 — Trazabilidad de expansión (debug opt-in)

- [ ] **Tarea:** Añadir modo debug (env o flag) que liste **tipo de arista + origen/destino + peso** recorridos en una búsqueda (VM o capa intermedia), sin volcar todo el grafo por defecto.
- [ ] **Test:** Ejecutar una búsqueda con fixture pequeño (≤10 nodos) y comprobar que el log contiene **exactamente** las aristas esperadas en un caso oro.
- [ ] **Esperado:** Con debug activado, salida estable entre ejecuciones (mismo grafo, mismo orden o orden documentado).

### E0.3 — Política de archivos de prueba JMN

- [ ] **Tarea:** Convención de rutas (`build/test_*.jmn`, `JASBOOT_JMN_NO_FINAL_SAVE` en CI si aplica) y limpieza post-test.
- [ ] **Test:** Correr la suite de prueba que toca JMN dos veces seguidas sin intervención manual; no quedan archivos bloqueados ni `.jmn` corruptos.
- [ ] **Esperado:** Documentado en el mismo doc o en `AGENTS.md` / tests README un párrafo **copy-paste** para nuevos tests.

---

## E1 — Grafo y tipos: invariantes y regresión (sin “IA conversacional” aún)

> Valida que el motor respeta tipos, pesos y búsqueda por tipo. **Tests solo Jasboot + JMN + VM.**

### E1.1 — Regresión `asociar_relacion` + `buscar_asociados` por tipo

- [x] **Tarea:** Mantener/ ampliar `sdk-dependiente/jas-compiler-c/tests/test_escalado_tipos_jmn.jasb` (o equivalente) con **un tipo por caso** y asserts de salida textuales estables.
- [x] **Test:** `node .vscode/run-jasb.cjs sdk-dependiente/jas-compiler-c/tests/test_escalado_tipos_jmn.jasb` (o ruta acordada).
- [x] **Esperado:** Exit code 0; salida contiene los vecinos esperados por **cada** tipo probado.

### E1.2 — Límite de tipos (`JMN_RELACION_MAX`)

- [ ] **Tarea:** Test que intenta `asociar_relacion(..., tipo_invalido, ...)` con tipo **fuera de rango**; documentar comportamiento (rechazo silencioso vs error).
- [ ] **Test:** `.jasb` o test C que invoque la misma ruta de código.
- [ ] **Esperado:** Comportamiento **documentado** y estable; no escribe aristas corruptas.

### E1.3 — Múltiples aristas mismo par (origen, destino) distinto `tipo`

- [ ] **Tarea:** Fixture con `A→B` tipo 1 y `A→B` tipo 2; `buscar_asociados(A,1)` y `buscar_asociados(A,2)` deben distinguir.
- [ ] **Test:** `.jasb` con `imprimir`/`assert` manual revisado o script que compare salida.
- [ ] **Esperado:** Los dos vecinos resolubles sin colisión de tipo en el modelo actual.

---

## E2 — Presupuesto de expansión (anti-explosión)

> **Independiente** de modos conversacionales: se prueba con grafo **toy** y función de expansión acotada.

### E2.1 — Parámetros K (profundidad / vecinos) y corte duro

- [x] **Tarea:** Implementar en la capa que recorre el grafo un **tope** `K_max` y `profundidad_max` (pueden mapear a opcodes existentes o wrapper en Jasboot).
- [x] **Test:** Grafo en cadena `n1→n2→…→n20` mismo tipo; expansión con `K=3` no visita más de 3 saltos **o** documenta el corte exacto según API actual.
- [x] **Esperado:** Nunca se excede el tope en el trace E0.2; tiempo acotado en fixture fijo.

### E2.2 — Presupuesto por “coste” (opcional: peso acumulado)

- [ ] **Tarea:** Sumar coste `−log(peso)` o `1−peso` y cortar al superar umbral `C_max`.
- [ ] **Test:** Dos ramas: una con aristas fuertes cortas vs débiles largas; la barata gana con mismo `K`.
- [ ] **Esperado:** Orden de visita acorde a la política documentada; sin ciclos infinitos.

---

## E3 — Estado discursivo del turno (efímero, ≠ JMN persistente)

> Memoria de trabajo: foco, repeticiones, tema del mensaje. **Test sin** depender de E4–E6: entrada sintética en una sola sesión.

### E3.1 — Estructura `EstadoTurno` (o equivalente)

- [ ] **Tarea:** Contador/frecuencia de lemas en el turno actual; lista de “tema activo” (último N lemas repetidos o anotación manual en prueba).
- [ ] **Test:** Unidad en C **o** script Node que alimente 3 frases y verifique conteos (sin VM completa si la lógica vive en módulo puro).
- [ ] **Esperado:** Tras reset de turno, contadores en cero; misma entrada produce mismos conteos.

### E3.2 — Sesgo de activación intra-turno (sin persistir en `.jmn`)

- [ ] **Tarea:** Multiplicador temporal que **prioriza** nodos mencionados 2+ veces en el turno (no escribe arista tipo 1 permanente por eso solo).
- [ ] **Test:** Fixture: mencionar `X` dos veces; la expansión desde semilla debe subir `X` en ranking vs control sin repetición.
- [ ] **Esperado:** Efecto **reversible** al cerrar turno; `.jmn` no crece por la repetición sola (salvo política explícita distinta).

---

## E4 — Modos conversacionales (clasificación de acto)

> Clasificador **ligero** (reglas + lista de patrones). Test con **dataset oro mínimo** en archivos de texto (sin backend).

### E4.1 — Taxonomía cerrada de modos

- [x] **Tarea:** Enum/cadenas: `pregunta`, `consulta`, `ensenanza`, `relato`, `social`, `mixto` (definir `mixto`).
- [x] **Test:** Archivo `tests/fixtures/modos_oro.txt` (una línea = un turno + etiqueta esperada); script que compare salida del clasificador.
- [x] **Esperado:** ≥ acuerdo acordado (ej. **85%** en oro ≥ 40 ejemplos) o lista de fallos priorizada.

### E4.2 — Señales léxicas y de puntuación

- [x] **Tarea:** Reglas: `?`, imperativos (`explica`), marcadores temporales pasado (`ayer`), verbos de sistema (`muéstrame`).
- [x] **Test:** Mismo formato oro; subconjunto que aisla **una** familia de señales por archivo.
- [x] **Esperado:** No regresión en subconjuntos al añadir reglas nuevas (tests separados por archivo).

---

## E5 — Política “modo → prioridad de tipos JMN”

> Matriz estática versionada. **Independiente** si E4 devuelve solo etiqueta string.

### E5.1 — Tabla `modo × orden_de_tipos`

- [x] **Tarea:** Estructura datos (JSON o tabla en C/Jasboot) que ordene tipos para expansión (ej. en `consulta` priorizar evidencia/ubicación; en `social` priorizar asociación/patrón bajo).
- [x] **Test:** Para cada modo, grafo **aislado** con **una** arista de cada tipo candidato desde la semilla; verificar orden de visita en trace E0.2.
- [x] **Esperado:** Orden de visita acorde a la política de `mask(C, tau)` y `g(tau)`.

### E5.2 — Fallback cuando modo = `mixto`

- [ ] **Tarea:** Política: pesos por sub-modo detectados o default “pregunta corta”.
- [ ] **Test:** Entradas etiquetadas `mixto` en oro con resultado esperado de **orden** o de longitud de salida simulada.
- [ ] **Esperado:** Sin crash; comportamiento documentado.

---

## E6 — Longitud de respuesta (presupuesto de salida)

> Conecta modo + presupuesto expansión + política de tono. Tests con **generador mock** (no hace falta LLM).

### E6.1 — Mapeo modo → `L_max` (tokens/caracteres)

- [ ] **Tarea:** Tabla `modo → L_max` y reglas de “ofrecer ampliar”.
- [ ] **Test:** Misma plantilla de respuesta candidata; forzar modo `social` vs `ensenanza` y medir truncado.
- [ ] **Esperado:** `social` más corto que `ensenanza` en mediana sobre batería fija (N≥10 casos).

### E6.2 — Anti-ensayo en pregunta cerrada

- [ ] **Tarea:** Detección pregunta cerrada (sí/no, cuál, cuántos) + `L_max` estricto.
- [ ] **Test:** Oro con 20 preguntas cerradas; medir longitud salida mock.
- [ ] **Esperado:** ≥95% dentro de `L_max` estricto sin perder respuesta correcta binaria.

---

## E7 — Escalado débil → fuerte (aprendizaje incremental en grafo)

> **Depende de E1** para aristas; **independiente** de E3–E6 si el test solo mira pesos en fixture.

### E7.1 — Política de refuerzo por evidencia usuario

- [ ] **Tarea:** Tras confirmación explícita (“sí”, “correcto”) o uso exitoso, subir peso arista tipo débil o promover a tipo más específico según doc de escalado.
- [ ] **Test:** Script dos pasos: estado inicial `.jmn` copiado; simular confirmación; comparar fuerza o tipo antes/después.
- [ ] **Esperado:** Incremento monotónico acotado (no supera 1.0); journal coherente si aplica.

### E7.2 — Decaimiento / olvido controlado

- [ ] **Tarea:** Usar o envolver `decaer_conexiones` / política documentada para aristas tipo 1 no usadas.
- [ ] **Test:** Fixture con arista débil sin uso N ciclos; verificar caída o umbral a cero según política.
- [ ] **Esperado:** No elimina aristas “ancla” (tipo 19 definido en fixture) en el mismo test.

---

## E8 — Cohesión gramatical (ligero, sin parser universal)

> **Opcional** en roadmap; tests con frases **acotadas**.

### E8.1 — Resolución de anáfora limitada (`eso`, `lo mismo` en ventana de k tokens)

- [ ] **Tarea:** Reglas para 2–3 anáforas en español sobre ventana corta.
- [ ] **Test:** Oro 15 frases con antecedente único.
- [ ] **Esperado:** ≥80% acierto en oro; fallos documentados.

### E8.2 — Marcadores de subordinación (`que` disambigüed básica)

- [ ] **Tarea:** Heurística mínima (interrogativo vs relativo por contexto).
- [ ] **Test:** Oro 20 oraciones.
- [ ] **Esperado:** Mejor que baseline “siempre relativo”; sin reclamar perfección.

---

## E9 — Capa fonética (JMN-FON), **después** de estabilizar E0–E2

> Ver [JMN_PLAN_CAPA_FONETICA_FUTURO.md](./JMN_PLAN_CAPA_FONETICA_FUTURO.md). Cada ítem **test C puro** en `jasboot-jmn-core` sin VM conversacional.

### E9.1 — `contar_silabas_v0` + tests oro

- [ ] **Tarea:** Implementación heurística español + lista palabras oro.
- [ ] **Test:** `make test` o binario de test en el módulo JMN; **sin** red ni Jasboot.
- [ ] **Esperado:** 100% en lista oro v0 (tamaño explícito, p. ej. 50 ítems) o tabla de excepciones aceptadas.

### E9.2 — `ultima_silaba` real (dejar de delegar en última palabra)

- [ ] **Tarea:** Sustituir stub; mantener API o deprecar nombre hasta cumplir.
- [ ] **Test:** Misma lista oro + comparación contra `contar_silabas_v0` invariants.
- [ ] **Esperado:** Comportamiento distinto de `ultima_palabra` en ≥N casos documentados (`N` fijo).

### E9.3 — Clave fonética reducida + igualdad

- [ ] **Tarea:** Colapso configurable (reglas v0); función `clave_fonetica_v0(texto)`.
- [ ] **Test:** Pares (`vaca`,`baca`) o similares según reglas elegidas.
- [ ] **Esperado:** Igualdad acorde a tabla; falsos positivos documentados.

---

## Mapa rápido de dependencias (solo entre etapas)

```text
E0 (medición) ─────────────────────────────────────────┐
E1 (grafo/tipos) ─────────────────────┐                │
                                       v                v
E2 (presupuesto expansión) <── puede usar trace E0     │
E3 (estado turno) <── opcional trace E0                │
E4 (modos) <── sin depender de E3 para test oro      │
E5 (matriz modo→tipos) <── requiere etiqueta E4       │
E6 (longitud salida) <── E4 + E2 (tablas y topes)     │
E7 (escalado grafo) <── E1                             │
E8 (cohesión) <── E3 recomendado, no obligatorio test │
E9 (fonética) <── E0 útil; independiente de E4–E8     │
```

---

## Cierre

Este checklist está pensado para que **cada ítem cierre con un test verificable** sin esperar la “IA completa”. La **prioridad** sugerida es: **E0 → E1 → E2**, luego **E4 → E5 → E6** en paralelo cognitivo con **E3**, después **E7**, **E8** opcional, y **E9** al final con tests C aislados.

Cuando completes una etapa entera, añade en el pie de este archivo la **fecha** y un enlace al PR o commit de referencia.
