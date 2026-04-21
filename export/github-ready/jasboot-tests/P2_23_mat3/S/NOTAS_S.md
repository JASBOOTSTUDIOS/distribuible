# P2_23_mat3 — notas S

## `s_estres_p23_mat3_mul_mil.jasb`

- Bucle **50 000** iteraciones; en cada una dos `mat3_mul` entre **`ac`**, **`tmp`** y **`mi`**, las tres inicializadas como **identidad 3×3** (solo `e0`, `e4`, `e8` = 1; resto 0). El producto sigue siendo identidad.
- Salida esperada (línea no vacía): **`1.0000`** (`ac.e0`).

Ejecutar: `.\bin\jb.cmd tests\P2_23_mat3\S\s_estres_p23_mat3_mul_mil.jasb`
