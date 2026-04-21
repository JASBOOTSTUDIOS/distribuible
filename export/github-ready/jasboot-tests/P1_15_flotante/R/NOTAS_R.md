# `r_flotante_comparaciones.jasb` — salida esperada

En el propio `.jasb`, cada `si` lleva un comentario al final de línea (`# -> 0/1`) con el resultado esperado.

Cada línea de salida es lo que imprime **un** `imprimir` (entero `1` o `0`), en orden de aparición en el programa.

## Resumen por bloque

| Bloque | Líneas | Patrón esperado (sin espacios) | Idea |
|--------|--------|--------------------------------|------|
| 1 Simetría | 12 | `111111000000` | Seis condiciones verdaderas y las mismas seis con rama invertida. |
| 2 Reflexividad | 6 | `100110` | `==`, `<=`, `>=` ciertos; `<`, `>`, `!=` falsos sobre el mismo `u`. |
| 3 Negativos | 6 | `110001` | `-5 < -2`, `>`, `!=` ciertos; `<=` / `>=` cruzados y `==` falsos. |
| 4 Cero | 6 | `111111` | Cero vs copia, epsilon, y signos alrededor de 0. |
| 5 Literales | 4 | `1111` | Literal a la izquierda de `<`, `>`, `==`. |
| 6 Falsos | 6 | `000000` | Comparaciones imposibles con `x`/`flotante_y`/`flotante_z`. |

**Total: 40 líneas** de salida.

## Transcripción completa (40 dígitos)

```
1111110000001001101100011111111111000000
```

## Bloque 3, detalle

- `neg_a < neg_b`, `neg_b > neg_a`, `neg_a != neg_b` → **1**
- `neg_b <= neg_a` → `-2 <= -5` → **0**
- `neg_a >= neg_b` → `-5 >= -2` → **0**
- `neg_a == neg_b` → **0**

## Bloque 6, detalle

- `flotante_z < x` con ambos `1.5` → **falso** → `0`

Si algo difiere, revisar `OP_CMP_*_FLT`, promoción entero→flotante y literales en el compilador.

---

## `usar` módulos (P1_14) + `flotante` y condicionales

Biblioteca compartida: `m_flotante_usar.jasb` (sin `principal`). Exporta con `enviar`:

- `clamp_pos(x)`: si `x < 0.0` retorna `0.0`; si no, `x`.
- `iva_de(base)`: si `base < 0.0` retorna `0.0`; si no, `base * 0.21`.
- `max_fl(u, v)`: si `u >= v` retorna `u`; si no, `v`.

Los parámetros no pueden llamarse `a` ni `b` (reservadas).

| Programa | Qué ejercita | Salida esperada (`jbc -e`, una línea por `imprimir_flotante`) |
|----------|----------------|------------------------------------------------------------------|
| `r_usar_flotante_todas.jasb` | `usar todas de "m_flotante_usar.jasb"`; `si` en main con flotantes | `0.0000`, `12.0000`, `2.5200`, `2.2500` |
| `r_usar_flotante_nominal.jasb` | `usar { clamp_pos, iva_de } de …`; `si` sobre `entero` | `0.0000`, `4.2000`, `0.0000`, `7.0000` |
| `r_usar_flotante_bucle_cond.jasb` | `usar { max_fl } de …`; bucle + `si`/`sino` | `24.5000` |

La VM debe aceptar opcodes `OP_CMP_*_FLT` (`0x36`, `0x37`, `0x3C`–`0x3E`). Si `jbc -e` falla con *Invalid opcode: 0x3D* al validar el `.jbo`, recompilar `jasboot-ir-vm` desde `sdk-dependiente/jasboot-ir` o ejecutar con un `jasboot-ir-vm.exe` actualizado (no una copia antigua de `jasboot-ir-vm-trace` desalineada con `ir_format.h`).

---

## `decimal(flotante, entero)` → `texto`

Formatea un flotante con **N dígitos después del punto** (redondeo como `printf` `%.*f`). El segundo argumento puede ser literal (`decimal(x, 2)`) o expresión entera. Precisión efectiva **0..20** (valores fuera de rango se recortan).

Uso típico: `imprimir "${decimal(num, 1)}"` o `texto s = decimal(num, 2)`.

| Archivo | Salida esperada (`jbc -e`) |
|---------|----------------------------|
| `r_decimal_formato.jasb` | `3.14` / `3.1416` / `Pi~3.1` |

**Nota:** `5.99` con **1** decimal da `6.0` (redondeo estándar), no `5.9`. Para un dígito “tipo truncado” haría falta otra primitiva.
