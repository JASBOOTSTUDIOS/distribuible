# P2_25_bits_unsigned — notas R

`.\bin\jb.cmd tests\P2_25_bits_unsigned\R\<archivo>.jasb`

## `r_cu_p25_shift_builtin_y_operadores.jasb`

- `7 << 2` → **28**
- `100 >> 3` → **12**
- `bit_shl(5, 3)` → **40**
- `bit_shr(255, 4)` → **15**

Cada valor seguido de linea vacia (`imprimir ""`).

## `r_cu_p25_u32_comparaciones_unsigned.jasb`

- `u32_a = 0x80000000` y `u32_a > 0` → **1** (con firmado seria falso).
- `0xFFFFFFFF > 1` como `u32` → **1**
- `u32_a > 0` con cero en `entero` (mezcla con `OP_CMP_GT_U` si aplica) → **1**

Tres lineas **1** separadas por vacio (ver `.jasb`).
