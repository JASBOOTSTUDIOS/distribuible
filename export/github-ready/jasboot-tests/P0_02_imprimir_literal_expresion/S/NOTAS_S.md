# S — `imprimir` (estrés)

En el catálogo, la fila P0 #2 **no** marca columna **S**. Aquí hay un script **opcional** por paralelismo con P0 #1:

- **`s_repeticion_compile_run.ps1`**: N ciclos de `jbc -e` sobre `R/r_ok_literal_expresion_interpolacion.jasb` (120 por defecto).

Sirve para ejercitar compilación + VM + salida por `imprimir` repetidas veces, no para nuevos opcodes.

## Producción (carga pesada)

- **`s_produccion_tormenta_imprimir.jasb`**: miles de `imprimir "${idx}"` seguidos (estrés de I/O). Suite global: `tests/P0_estres_produccion_P01_P09_integracion/S/s_repeticion_todas_producciones_P01_P09.ps1`.
