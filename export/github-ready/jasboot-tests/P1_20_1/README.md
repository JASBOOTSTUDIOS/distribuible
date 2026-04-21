# P1_20_1 — Función como valor y orden superior (sin `registro`)

Batería **independiente** de [tests/P2_20_registro/](../P2_20_registro/): no usa `registro`, campos ni volcado de structs. Todo el material gira en torno al tipo **`funcion`**, a los **punteros a código** (globales o lambdas emitidas) y a las **llamadas indirectas** en la VM (`OP_LLAMAR` con destino en registro).

Ítem de catálogo: **P1 · 20.1** en [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

Relación con otras baterías: **P1·11** (funciones nombradas, `retorna` / `retornar`), **P1·12** (flechas `(…) => …`), **P1·13** (`llamar` / convención de llamada). Aquí se asume que la VM ya puede saltar a una dirección tomada de un registro, no solo a etiquetas fijas de globales.

---

## Qué cubre el lenguaje en esta sección

| Funcionalidad | Descripción |
|---------------|-------------|
| **Tipo `funcion`** | Variables locales `funcion nombre` que almacenan una dirección de función (global o lambda). |
| **Parámetros `funcion`** | Firmas del estilo `funcion f(entero v)` o `funcion aplicar(funcion f, entero v)`; el cuerpo puede invocar `f(v)` (llamada indirecta). |
| **Nombre global como valor de tipo `funcion`** | Donde el compilador lo permite (p. ej. argumento que espera `funcion`), se puede pasar una función global por nombre: `aplicar_uno(duplicar, 21)`. |
| **Postfijo `expr(args)`** | Llamada cuando el callee es una expresión que deja la dirección en el registro de llamada indirecta (p. ej. identificador de tipo `funcion` o expresión que lo produce). |
| **Lambda como valor** | Asignación `h = (entero n) => n + 100` a una variable `funcion`; luego `aplicar_fn(h, 5)` o equivalente. |
| **`retornar` con callee indirecto** | Dentro de una función, `retornar g(n)` con `g` parámetro `funcion` emite carga del puntero + `LLAMAR` indirecto + uso del resultado. |
| **Semántica de contexto** | El nombre de una función global **no** es un valor arbitrario: solo es aceptable donde se espera tipo `funcion` (y no, por ejemplo, en un `entero`). |

---

## Carpetas de tests

| Ruta | Rol |
|------|-----|
| **`R/`** | Caso integrado `r_cu_p1201_funcion_orden_superior.jasb` y **cuatro** ejemplos mínimos `r_cu_p1201_R01_…`–`R04_…` (callback, dos estrategias, lambda como argumento, aplicar dos veces). Ver `R/NOTAS_R.md`. |
| **`E/`** | **28** casos de error de compilación (`e_cu_p1201_*.jasb`), cada uno con descripción en comentarios al inicio del archivo. Ver `E/NOTAS_E.md`. |
| **`S/`** | Estrés: miles de indirectas vía parámetro a global, bucle con variable `funcion` apuntando a global, y **una** ráfaga con lambda al final. Demo grande integrada en `tests/estres/P1_20_1_banco_sim_ordensuperior/`. Ver `S/NOTAS_S.md`. |

---

## Implementación de referencia

- **Compilador:** `sdk-dependiente/jas-compiler-c` — sobre todo `parser.c` (incl. `funcion` en bloques y llamadas postfix), `codegen.c` (rama variable/expr `funcion` + `OP_LLAMAR` indirecto), `symbol_table.c` (tamaño y tipo `funcion`).
- **VM:** `sdk-dependiente/jasboot-ir` — `vm.c`, `OP_LLAMAR` con destino en registro; límite de profundidad `VM_MAX_RECURSION`.

---

## Limitaciones y comportamientos conocidos (VM / compilador)

1. **Lambdas en bucles muy largos:** muchas llamadas seguidas a una variable `funcion` que apunta a una **lambda** pueden agotar la pila de retorno (`VM_MAX_RECURSION`). Por eso el **S** concentra el estrés en indirectas hacia **globales** y deja una sola secuencia con lambda.
2. **Persistencia de variables `funcion` tras muchas llamadas:** en escenarios como miles de `aplicar(inc, acc)`, un valor guardado antes en `h` puede verse incorrecto si no se **re-asigna** `h` antes de usarlo de nuevo (posible solapamiento en frame o bug afín); el test **S** hace `h = duplicar` justo antes del segundo bucle. Detalle en `S/NOTAS_S.md`.
3. **Parches de dirección:** los punteros a función pueden depender de parches de tamaño limitado en IR muy grande (orden de decenas de KB de código según el mecanismo concreto); no es el foco de estos `.jasb`, pero afecta programas enormes.

Para ejecutar un **R** desde la raíz del repo:

```powershell
.\bin\jb.cmd tests\P1_20_1\R\r_cu_p1201_funcion_orden_superior.jasb
```

Los **E/** deben fallar al compilar (`.\bin\jbc.cmd …` con código distinto de 0).
