# R — `imprimir` (rendimiento)

| Archivo | Objetivo |
|---------|----------|
| `r_ok_literal_expresion_interpolacion.jasb` | Regresión funcional: literal, `+`, interpolación `${}`, variable, `imprimir_texto`, paréntesis. |
| `r_literal_vacio.jasb` | `imprimir ""` (salida solo salto de línea). |
| `r_dos_imprimir_misma_linea.jasb` | Dos impresiones en una línea física. |
| `r_muchos_imprimir.jasb` | **Carga:** 8000× `imprimir "."` dentro de `mientras` — medir tiempo de `jbc -e` localmente. |
| `r_concat_texto_mas_entero.jasb` | **`"30" + 10` y `10 + "30"`** — el `+` mezcla **texto** y **entero**; **jbc** concatena tras convertir el número a texto (no suma aritmética 30+10). Salida esperada: `3010` y `1030`. |

Ajustar el tope del `mientras` en `r_muchos_imprimir.jasb` para pruebas más pesadas.
