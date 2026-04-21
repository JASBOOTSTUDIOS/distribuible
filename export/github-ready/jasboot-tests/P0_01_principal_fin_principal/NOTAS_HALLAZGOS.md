# Hallazgos — P0 #1 (`principal` / `fin_principal`), toolchain **jbc**

Fecha de captura: 2026-03-25. Binario: `c:\src\jasboot\bin\jbc.exe` (compilador C estable vía CLI `jbc`).

## Resumen

1. **`principal` obligatorio en el estilo “blog de libro” no lo es en el parser**: un archivo puede consistir solo en sentencias al nivel superior (sin `principal`…`fin_principal`) y **compila y ejecuta**; esas sentencias forman el mismo `main` que si estuvieran dentro de `principal` (ver `e_sin_principal_solo_sentencia.jasb`).
2. **Varios bloques `principal`…`fin_principal` en secuencia son válidos**: las sentencias de cada bloque se **encadenan en orden** en el cuerpo principal (ver `e_doble_bloque_principal.jasb`: imprime `A` y luego `B`).
3. **`fin_principal` sin `principal` previo es error**: el compilador rechaza un `fin_principal` suelto al nivel del archivo (`e_solo_fin_principal.jasb`). Antes el token quedaba sin consumir y se generaba un programa vacío.
4. **Dos `fin_principal` seguidos sin `principal`**: el primero ya provoca error (`e_doble_fin_principal.jasb`).
5. **Errores esperados capturados**:
   - Sin cerrar con `fin_principal` → error de parser (*Se esperaba fin_principal*, `e_sin_fin_principal.jasb`).
   - Cierre con palabra clave incorrecta (`fin_funcion`) → error (`e_cierre_incorrecto.jasb`).
   - `fin_principal` sin `principal` previo en el archivo → error (`e_solo_fin_principal.jasb`).
6. **Rendimiento (orden de magnitud)**: bucle `mientras` con 50 000 iteraciones vacías dentro de `principal`, medido con `Measure-Command` sobre `jbc -e`, ~ **112 ms** en esta máquina (`R/NOTAS_R.md`); el límite superior del bucle es ajustable para pruebas más pesadas.
7. **Estrés**: el script `S/s_repeticion_compile_run.ps1` repite compilación + ejecución del mínimo `R/r_baseline_minimo.jasb` usando siempre **jbc**.

## Implicaciones para el estándar / documentación de lenguaje

- La guía de estilo puede recomendar **siempre** usar `principal`…`fin_principal` por claridad, aunque **jbc** acepte programas sin ese envoltorio.
- Los tests de “error E” del checklist distinguen errores de compilación frente a programas vacíos aceptados (archivo sin texto puede mostrar aviso; `fin_principal` sin `principal` es error).
