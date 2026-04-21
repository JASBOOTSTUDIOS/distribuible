# P1_15 — notas de errores y límites

## División flotante por cero

En la VM, `OP_DIVIDIR_FLT` con divisor **0.0f** deja el resultado en **0** (no lanza error y **no** produce IEEE NaN/inf). El caso `R/r_division_cero_flotante.jasb` fija ese contrato (programa válido, salida `0.0000`).

## `módulo` (`%`) con `flotante`

El compilador rechaza `%`, `<<` y `>>` cuando algún operando es flotante (`e_modulo_flotante.jasb`).

## NaN e infinito

No hay literal `nan`/`inf` en el lenguaje. Con la regla anterior, `0.0/0.0` tampoco genera NaN en la VM. Si en el futuro se relaja la división por cero flotante, habría que revisar comparaciones (`OP_CMP_EQ_FLT`, etc.) y tests.
