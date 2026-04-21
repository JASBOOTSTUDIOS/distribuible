# P1_13 — `llamar` explícita (OP `LLAMAR`, marco `RESERVAR_PILA`)

Batería alineada con el ítem **P1 · 13** del [checklist de catálogo](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

La palabra clave **`llamar`** fuerza una **llamada a función** con la misma emisión que `nombre(args)` (opcode `LLAMAR`, frame local con `RESERVAR_PILA` en la función destino). Es opcional: sirve para dejar explícito en el código fuente que se invoca rutina con convención de pila.

| Ruta | Rol |
|------|-----|
| `R/` | Casos válidos: sentencia, expresión, `retornar llamar …`. |
| `E/` | Tras `llamar` debe seguir una forma `nombre( … )`. |
| `S/` | Muchas invocaciones `llamar` en bucle (presión ligera). |

Implementación: `keywords.c` (`llamar`), `parser.c` (`parse_unary` + `retornar` + sincronización). Codegen no cambia: sigue siendo `NODE_CALL`.
