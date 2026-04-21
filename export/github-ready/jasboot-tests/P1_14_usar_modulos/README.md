# P1_14 — `usar` módulos (`todas` / `{ } de`)

Batería alineada con el ítem **P1 · 14** del [checklist de catálogo](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

El compilador enlaza **módulos** en tiempo de compilación (ruta relativa al `.jasb` que contiene el `usar`) y **fusiona** solo los símbolos **marcados con `enviar`** que correspondan a la forma de importación.

## Formas de `usar`

| Forma | Comportamiento |
|-------|----------------|
| `usar todas de "ruta.jasb"` | Sinónimo de `usar todo de …`. Importa **todo lo marcado con `enviar`** en el módulo. |
| `usar todo de "ruta.jasb"` | Igual que `usar todas de`. |
| `usar { nombre1, nombre2 } de "ruta.jasb"` | Importa solo esos nombres; cada uno debe existir en el módulo y llevar **`enviar`**. |
| `usar "ruta.jasb"` (solo cadena) | **No válido:** error de sintaxis; usar `todas`/`todo de` o lista `{ } de`. |

Sinónimo histórico: **`activar_modulo`** admite las mismas variantes.

## Exportar (`enviar`)

- `enviar funcion nombre( … ) … fin_funcion`
- `enviar` + declaración global con tipo al inicio (p. ej. `enviar entero PI = 314`), vía la misma gramática que una declaración en ámbito de módulo.

Palabras clave en lexer: **`enviar`**, **`todo`**, **`todas`**.

| Ruta | Rol |
|------|-----|
| `R/` | Casos válidos: cadena de módulos, `usar { … } de`, `usar todo`/`todas de`, módulos con `enviar`. |
| `E/` | **Compilación debe fallar**: ruta inexistente, ciclo, nombre no exportado en import nominal, sintaxis `usar "solo cadena"`, etc. |
| `S/` | (vacío en el catálogo.) |

Implementación: `jas-compiler-c` — `parser.c` (`parse_activar_modulo_directive`, `enviar`), `nodes.h` (`USAR_IMPORT_*`, `is_exported`), `main.c` (fusión filtrada), `codegen.c` emite `OP_ACTIVAR_MODULO` sin cambio de contrato IR.
