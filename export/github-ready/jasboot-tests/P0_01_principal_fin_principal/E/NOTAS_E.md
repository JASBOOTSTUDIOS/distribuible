# E — Errores y límites (`principal` / `fin_principal`), **jbc**

## Casos en esta carpeta

| Archivo | Intento | Resultado con **jbc** |
|---------|---------|------------------------|
| `e_sin_fin_principal.jasb` | Bloque abierto sin cierre | **Fallo compilación** (exit ≠ 0). Mensaje: *Parser error: … Se esperaba fin_principal*. |
| `e_cierre_incorrecto.jasb` | `fin_funcion` en lugar de `fin_principal` | **Fallo compilación**. *Se esperaba fin_principal (Token: 'fin_funcion')*. |
| `e_solo_fin_principal.jasb` | Solo la palabra `fin_principal` | **Fallo compilación** (desde mejora del parser): `fin_principal` sin `principal` previo. |
| `e_doble_fin_principal.jasb` | Dos líneas `fin_principal` | **Fallo compilación** (el primer `fin_principal` ya es invalido sin `principal`). |
| `e_sin_principal_solo_sentencia.jasb` | Sentencia sin bloque `principal` | **Compila y ejecuta**; imprime el literal. Comportamiento válido en **jbc**. |
| `e_doble_bloque_principal.jasb` | Dos pares `principal`/`fin_principal` | **Compila y ejecuta**; ejecuta ambas partes en orden (A, B). Útil como caso *correcto* aunque el nombre lleve `e_`; documenta semántica, no un fallo. |

## Nota sobre prefijos `e_`

Varios archivos de exploración usan el prefijo `e_` aun cuando **jbc** no los trata como error. La tabla anterior clasifica el resultado real; renombrar a `sintaxis_` o `comportamiento_` es opcional para evitar confusión.
