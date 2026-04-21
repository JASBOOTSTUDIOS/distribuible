# Checklist: tests de producción para el lenguaje Jasboot

Este documento plasmar la hoja de ruta para validar el lenguaje de forma **sistemática**: VM/IR, compilador, combinaciones y integración. Cada fase tiene **criterio de salida** explícito.

**Uso:** marcar ítems al cerrarlos; mantener CI verde por bloque antes de avanzar. Útil para epic/issues en el tracker.

---

## Fase 0 — Cimientos

- [ ] **Definir tiers de producto**
  - **Tier 1:** núcleo ejecutable (pila, llamadas, memoria base, strings básicos, flujo).
  - **Tier 2:** extensiones usadas por sistemas reales (p. ej. JMN, listas, patrones, tuberías según el SDK).
  - **Tier 3:** capacidades opcionales (drivers, red, etc., si aplica).

- [ ] **Inventario de opcodes IR**
  - Tabla: `opcode`, nombre simbólico, flags, operandos, precondiciones, postcondiciones, efectos colaterales (percepción, rastro, etc.).

- [ ] **Inventario de keywords JASB**
  - Cada keyword enlazada a la ruta de codegen y, cuando aplique, a opcodes concretos.

- [ ] **Comando único de pruebas en CI**
  - Un script o target (`ctest`, `ninja test`, script propio) que ejecute: tests de VM, compilador y goldens acordados.

- [ ] **Versión y formato IR visibles en fallos**
  - Tests que impriman o asocien `IR_VERSION`, magic y tamaños esperados al fallar.

**Criterio de salida:** existe documentación viva (epic/wiki) con tiers + tablas; CI corre al menos un **smoke** en cada cambio relevante.

---

## Fase 1 — Tests de VM / IR (por instrucción)

- [ ] **Harness data-driven**
  - Casos definidos en tablas/structs (CSV embebido, JSON o generación en build), no solo pruebas dispersas.

- [ ] **Cobertura Tier 1 por opcode**
  - Estado inicial mínimo → ejecución → aserciones en registros, memoria afectada, `pc`, y flags donde aplique.

- [ ] **Variantes de flags**
  - Para cada opcode usado en producción con `RELATIVE`, inmediato vs registro, etc.: al menos un caso por variante.

- [ ] **Errores y límites**
  - División por cero, desbordamiento de pila, memoria agotada: comportamiento documentado (código de salida, `vm->running`, etc.) y aserción en test.

- [ ] **Debug vs release**
  - Los casos **Tier 1 críticos** pasan en ambas configuraciones, o las diferencias están documentadas y excluidas explícitamente.

- [ ] **Cobertura de código**
  - Objetivo cuantificado sobre handlers de opcodes en la VM (p. ej. cobertura de líneas/ramas en Tier 1).

**Criterio de salida:** todos los opcodes **Tier 1** tienen entrada en el inventario **y** caso automatizado; CI falla si se añade opcode sin fila + test (regla de contribución).

---

## Fase 2 — Contratos de combinación (pares y triples)

- [ ] **Pila y marco**
  - `RESERVAR_PILA` + `LEER` / `ESCRIBIR` + `RELATIVE` con distintos tamaños de frame y offsets.

- [ ] **Llamadas**
  - `LLAMAR` + pase de argumentos en registros + `RETORNAR`; anidación 2–3 niveles; consistencia de `fp` / `sp`.

- [ ] **Control de flujo**
  - Bucles anidados con `break` y `continue` en al menos tres configuraciones distintas.

- [ ] **Cadenas**
  - Literales, `LOAD_STR_HASH`, concatenación, división, normalización (`minusculas`, etc.): misma semántica por dos caminos cuando el lenguaje lo garantiza (o documentar excepciones por identidad de ids).

- [ ] **Memoria asociativa mínima (Tier 2)**
  - `recordar` / asociación ↔ `buscar` / `OBTENER_VALOR`: primero literales; luego variables y llamadas a función.

- [ ] **Listas (Tier 2)**
  - Crear, tamaño, agregar, obtener; secuencias típicas incluyendo listas vacías y un elemento.

**Criterio de salida:** matriz “par/triple → archivos de test” completa para Tier 1 y para los subsistemas Tier 2 que declaréis obligatorios.

---

## Fase 3 — Tests del compilador (JASB → IR)

- [ ] **Por keyword**
  - Uno o tres `.jasb` mínimos por construcción que aíslen solo esa característica.

- [ ] **Snapshots de IR (recomendado)**
  - Bytecode esperado o secuencia de opcodes normalizada; diff en CI ante regresiones de lowering.

- [ ] **Equivalencias de lowering**
  - Dos programas que deban comportarse igual (p. ej. literal vs variable intermedia) y misma observable.

- [ ] **Módulos `usar`**
  - Caso mínimo: `principal` + unidades importadas; orden de resolución de símbolos y una aserción de ejecución o de IR.

**Criterio de salida:** romper el compilador o el lowering produce fallo **localizado** (diff o mensaje de test), no solo un fallo en aplicación grande.

---

## Fase 4 — Goldens de integración (end-to-end)

- [ ] **Estructura `tests/golden/` (o equivalente)**
  - Por caso: fuente `.jasb`, salida estándar esperada, y datos auxiliares si hace falta (p. ej. `.jmn` de partida conocida).

- [ ] **Política de actualización**
  - Cambiar goldens solo con variable explícita o PR dedicado (`UPDATE_GOLDEN=1`, etc.).

- [ ] **Escenarios por dominio**
  - Memoria conversacional, E/S, errores de usuario, límites (longitud de cadena, profundidad de llamadas).

- [ ] **Determinismo**
  - Sin reloj ni azar no fijado; semillas fijas donde haya aleatoriedad.

**Criterio de salida:** `jbc` (o pipeline oficial) + ejecución + comparación con golden en CI.

---

## Fase 5 — Property-based testing y fuzzing

- [ ] **Invariantes de VM documentados**
  - Ejemplos: `sp` y `fp` dentro de límites; no escritura fuera del frame sin uso deliberado de direccionamiento absoluto; etc.

- [ ] **Generación legal**
  - Secuencias de opcodes o programas generados que respeten invariantes de pila y llamadas.

- [ ] **Crashes = fallos**
  - Cualquier aborto, timeout o sanitizer report en el runner cuenta como fallo de test.

- [ ] **Sanitizers (opcional pero valioso)**
  - ASan/UBSan en build de test de la VM, donde el toolchain lo permita.

- [ ] **CI**
  - Fuzz o property tests en trabajo nocturno si el tiempo de CI diario es limitado.

**Criterio de salida:** corpus mínimo reproducible y comando documentado para reproducir hallazgos.

---

## Fase 6 — Calidad y mantenimiento

- [ ] **Regla de contribución**
  - Nuevo opcode → fila en inventario + test VM; nuevo keyword → casos compilador + (si aplica) golden.

- [ ] **Tiempo de CI**
  - Smoke rápido en cada PR; suite completa o fuzz en nightly.

- [ ] **Métricas**
  - Cobertura Tier 1, número de goldens, deuda (filas sin test en inventario).

- [ ] **Plantilla postmortem**
  - Cada bug de semántica en producción → nuevo caso en Fase 1 o 2 antes de cerrar el issue.

**Criterio de salida:** checklist de revisión de PR enlazado desde el README o guía de contribución del repo.

---

## Definición de “listo para construir sistemas”

Marcar este bloque solo cuando se cumplan **todas** las condiciones acordadas por el proyecto:

- [ ] **Tier 1:** opcodes y pares críticos con cobertura y CI verde.
- [ ] **Tier 2:** contratos y goldens representativos del dominio objetivo (p. ej. jas-IA) en verde.
- [ ] **Regresión:** periodo acotado sin romper goldens ni inventario (definir ventana: N releases o N semanas).
- [ ] **Semántica oficial:** documento breve enlazado (comportamiento de `buscar`, pila, strings, memoria) coherente con los tests.

---

## Organización sugerida en el repositorio

| Ruta sugerida | Contenido |
|---------------|------------|
| `tests/vm-opcodes/` o dentro del proyecto IR | Tablas + ejecutor Fase 1 |
| `tests/jasb-constructs/` | Fuentes mínimas Fase 3 |
| `tests/golden/` | Salidas esperadas Fase 4 |
| `docs/PROYECTO/CHECKLIST_TESTS_PRODUCCION_JASBOOT.md` | Este checklist (actualizar fechas/versiones al cerrar fases) |

Convención general de paquetes Jasboot (`src/`, `tests/`, `data/`): `docs/LENGUAJE/ESTANDAR_ORGANIZACION_PROYECTOS_JASBOOT.md`.

---

## Referencias internas

- Organización de proyectos Jasboot: `docs/LENGUAJE/ESTANDAR_ORGANIZACION_PROYECTOS_JASBOOT.md`
- VM y estabilidad: `docs/TECNICO/VM/VM_ESTABLE.md`
- Compilador C (SDK): `docs/TECNICO/SDK/CHECKLIST_COMPILADOR_C.md`
- Roadmap general: `docs/PROYECTO/CHECKLIST_ROADMAP_JASBOOT.md`

---

*Última actualización del esquema del documento: al crear el archivo; conviene añadir fecha y versión del IR cuando se complete cada fase.*
