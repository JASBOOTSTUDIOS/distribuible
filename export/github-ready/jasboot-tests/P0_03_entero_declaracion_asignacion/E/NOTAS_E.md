# E — Errores y límites (`entero`, `=`), **jbc**

## Casos en esta carpeta

| Archivo | Intento | Resultado con **jbc** |
|---------|---------|------------------------|
| `c_asignacion_sin_declaracion_previa.jasb` | `y = 99` sin `entero y` | **Fallo compilación** (exit 1). Mensaje de sintaxis: se esperaba `fin_principal`, se encontró identificador/`y`. |
| `e_asigna_constante.jasb` | Asignar a símbolo declarado con `constante entero` | **Fallo compilación** (codegen). *Error: no se puede asignar a la constante 'C'*. |
| `e_division_cero_en_asignacion.jasb` | `entero x = 1 / 0` | **Compilación OK**; **ejecución falla** (exit VM ≠ 0, p. ej. -1). |
| `e_doble_decl_mismo_nombre.jasb` | Dos `entero x = …` seguidos | **Compila y ejecuta**; `imprimir x` muestra **1**. *Debería* ser error de compilación o validación semántica — hoy la segunda declaración no se refleja. |
| `e_entero_sin_expresion_despues_igual.jasb` | `entero x =` sin valor | **Compila y ejecuta** sin salida. *Debería* ser error de sintaxis. |
| `e_variable_nombre_palabra_reservada.jasb` | `entero mientras = 1` | **Fallo compilación** (desde **jbc** actualizado): *«… es palabra reservada del lenguaje; no puede usarse como nombre de variable…»* con ruta `:línea:columna`. |

## Nota sobre nombres `e_` vs `c_`

El prefijo `e_` reserva el caso para «esperamos fallo». Cuando **jbc** aún no cumple, la tabla documenta el comportamiento real; conviene corregir el compilador y entonces estos archivos pasarán a fallar como **E** «verdadero».
