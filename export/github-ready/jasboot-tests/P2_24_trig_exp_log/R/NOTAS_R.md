# P2_24_trig_exp_log — notas R

Ejecutar: `.\bin\jb.cmd tests\P2_24_trig_exp_log\R\<archivo>.jasb`

## `r_cu_p24_tabla_valores.jasb`

Salida en orden (cada valor seguido de linea vacia por `imprimir ""`), float32 típico:

`0`, `1`, `0`, `1`, `-0` (o `-0.0000`), `1`, `0`, `2`, `0`, `1.5708` — es decir  
`sin(0)`, `cos(0)`, `tan(0)`, `sin(pi/2)`, `cos(pi/2)`, `exp(0)`, `log(1)`, `log10(100)`, `atan2(0,1)`, `atan2(1,0)`.

Recalibrar con `jb.cmd` si el runtime cambia.

## `r_cu_p24_arcotangente2_alias.jasb`

`atan2(y,x)` y `arcotangente2(y,x)` con los mismos argumentos deben dar **la misma** secuencia de dos flotantes (dos bloques idénticos separados por lineas vacias).
