# P2_22_mat4 — notas R

Ejecutar con `.\bin\jb.cmd tests\P2_22_mat4\R\<archivo>.jasb`.

## `r_cu_p22_mat4_basico.jasb`

Tres bloques de cuatro líneas numéricas (separadas por líneas en blanco por cada `imprimir ""`):

1. `mat4_mul_vec4` con identidad y `v = (3,4,5,1)` → `3`, `4`, `5`, `1`.
2. Tras `mat4_transpuesta` de la identidad, mismo resultado.
3. `mat4_mul(mi, inv)` con inversa de la identidad y de nuevo `mat4_mul_vec4` → otra vez `3`, `4`, `5`, `1`.

## `r_cu_p22_mat4_trasl_mul_vec4.jasb`

Traslación en la **columna derecha** del layout fila×columna de la VM (`e3`, `e7`, `e11`): con `t.e3 = 2`, `t.e7 = 1` e `v = (1,0,0,1)`, la salida es **`3`**, **`1`**, **`0`**, **`1`** (mismo formato de líneas en blanco que el básico).

## `r_cu_p22_mat4_transpuesta_valores.jasb`

`M` identidad con `M.e1 = 7` y `M.e4 = 3`; tras `mat4_transpuesta(T, M)` debe cumplirse **`T.e1 = 3`** y **`T.e4 = 7`** (líneas separadas por `imprimir ""`).
