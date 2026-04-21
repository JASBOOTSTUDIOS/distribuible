# P2_26_operadores_asignacion_y_dobles — `+=` `*=` `-=` `/=`, `==` `!=` `<=` `>=`, `<<` `>>`

Ítem de catálogo: **P2 · 26** en [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

- **Asignación compuesta:** el parser descompone `x += e` en `x = x + e` (análogo para `-=` `*=` `/=` `%=`). Solo el **identificador simple** es destino válido (`parser.c`).
- **Operadores dobles en expresiones:** lexer `keywords.c` (`ops_double`); `<<` `>>` en `parse_term`; comparaciones en `parse_comparison`.

| Carpeta | Contenido |
|---------|-----------|
| **R/** | Caso de referencia con salida esperada. Ver `R/NOTAS_R.md`. |
| **E/** | Destino inválido para `+=`. Ver `E/NOTAS_E.md`. |
| **S/** | Bucle con muchos `+=`. Ver `S/NOTAS_S.md`. |

**Nota (VM):** `imprimir` con enteros en el rango típico de timestamp Unix puede mostrar fecha/hora en lugar del dígito; el test **S** mantiene la suma por debajo de `1e9` para una salida numérica estable.
