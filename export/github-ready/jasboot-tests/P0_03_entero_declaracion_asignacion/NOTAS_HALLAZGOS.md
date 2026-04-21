# Hallazgos — P0 #3 (`entero`, `=`), **jbc**

## Palabras reservadas como nombre

Si un identificador coincide con una entrada de la tabla de palabras clave del lexer (`keywords.c`), **jbc** rechaza su uso como nombre de variable, constante, parámetro, campo de `registro` o nombre de función (mensaje explícito con ruta y columna). Excepciones documentadas por compatibilidad: **`a`**, tipos **`vec2`–`vec4`**, **`mat3`/`mat4`** y nombres de **llamadas sistema** que el parser trata como identificador‑llamada.

## Lo que funciona según lo previsto

- Declaración con inicialización (`entero a = 10`), declaración sin valor y asignación después (`entero b` … `b = 3`), reasignación y expresiones en el lado derecho (`entero c = a + b`, `a = 0 - 1`). Véase `R/r_ok_basico.jasb` (se usa solo `+` para no mezclar con precedencia de `*` reservada a P0 #4).
- Asignación a una **constante** entera se rechaza en codegen con mensaje claro (`E/e_asigna_constante.jasb` → *no se puede asignar a la constante*).
- **División por cero** en una expresión de asignación: el programa **compila**; la VM falla en ejecución (exit ≠ 0 típicamente `-1`). Caso `E/e_division_cero_en_asignacion.jasb`.

## Comportamientos débiles o defectos

1. **`entero` con `=` y sin expresión** (`entero x =` seguido de fin de línea / `fin_principal`): **jbc** compila con éxito y el programa no imprime nada. Lo razonable sería error de parser (igual que falta de expresión tras `imprimir`). Archivo: `E/e_entero_sin_expresion_despues_igual.jasb`.

2. **Doble declaración del mismo nombre** en el mismo bloque: **jbc** **compila** y al ejecutar `imprimir x` muestra el valor de la **primera** declaración (`1`), no `2`. La segunda declaración parece ignorarse en la tabla de símbolos sin diagnóstico. Archivo: `E/e_doble_decl_mismo_nombre.jasb`.

3. **Asignación a identificador sin `entero` previo** al inicio de cuerpo (`y = 99`): no se acepta como sentencia de asignación libre; el parser interpreta el contexto y devuelve error del estilo *Se esperaba fin_principal* al encontrar el identificador. Archivo: `E/c_asignacion_sin_declaracion_previa.jasb`. Si en el futuro se permiten variables implícitas o mejor diagnóstico, este caso habría que revisar.

## Rendimiento

- `R/r_muchos_incrementos.jasb` usa un bucle de **20 000** iteraciones con `x = x + 7` (equilibrio entre estrés y tiempo de `jbc -e` en VM; ver cifras en `RESULTADOS_EJECUCION_jbc.txt`).
