# Hallazgos — P0 #2 (`imprimir`), **jbc**

## Sintaxis

- Tras la palabra `imprimir` / `imprimir_texto` **no hace falta** `(`: la forma habitual es `imprimir` *expresión*. Los paréntesis alrededor de la expresión son opcionales (subexpresión): `imprimir (99)`.
- Dos sentencias seguidas en la misma línea funcionan: tras evaluar la primera expresión, el parser continúa con la siguiente sentencia (véase `R/r_dos_imprimir_misma_linea.jasb`).

## `imprimir` sin expresión

A partir de la mejora de diagnósticos en **jbc** (`parser.c`), `E/e_imprimir_sin_expresion_lexico_fin.jasb` produce **error de compilación** con ruta `archivo:línea:columna` y texto del token siguiente (`fin_principal`). Antes el programa compilaba con cuerpo vacío (comportamiento silencioso).

## Interpolación

Las cadenas con `${ expresión }` se evalúan correctamente en el ejemplo `R/r_ok_literal_expresion_interpolacion.jasb` (p. ej. `suma 42`).

## Texto + número con `+`

Si algún operando de `+` se tipa como **texto** (o caracter/concepto en la misma rama del compilador), **jbc** emite **concatenación**: los enteros o flotantes se convierten a texto (`OP_STR_DESDE_NUMERO`). Ejemplo: `imprimir "30" + 10` imprime `3010`, no `40`. El orden importa: `10 + "30"` → `1030`. Caso en `R/r_concat_texto_mas_entero.jasb`.

## Rendimiento

`R/r_muchos_imprimir.jasb` (8000 llamadas a `imprimir "."`) sirve como **R** del catálogo; orden de magnitud en una máquina de prueba: ~150 ms para `jbc -e` completo (ver `RESULTADOS_EJECUCION_jbc.txt`).
