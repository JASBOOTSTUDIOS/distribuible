# P2_23_mat3 — notas R

Ejecutar con `.\bin\jb.cmd tests\P2_23_mat3\R\<archivo>.jasb`.

## `r_cu_p23_mat3_identidad_vec3.jasb`

Matriz identidad 3×3 escrita por componentes (`e0`, `e4`, `e8` = 1; resto 0). Con `v = (3, 4, 5)`, `mat3_mul_vec3` debe dejar **`3`**, **`4`**, **`5`** (líneas en blanco entre cada `imprimir` de componente, como en P2_22).

## `r_cu_p23_mat3_mul_y_vec.jasb`

1. **Escala en X**: `S.e0 = 2`, diagonal resto 1, ceros fuera; `v = (1, 1, 0)` → salida **`2`**, **`1`**, **`0`**.
2. **Producto** `P = L * R`: `L` con `L.e1 = 2` (resto como identidad), `R` identidad → `P.e1` debe ser **`2.0000`** (última línea numérica del programa).
