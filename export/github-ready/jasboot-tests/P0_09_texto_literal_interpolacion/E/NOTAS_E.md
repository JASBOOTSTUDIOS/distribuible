# E — `texto`, literales e interpolación (errores y límites)

| Archivo | Qué prueba | Resultado **jbc** (revisado) |
|---------|------------|------------------------------|
| `e_interp_sin_cierre_llave.jasb` | `"… ${ expr` sin `}` antes de `"` | **Fallo compilación** — error léxico: cadena no cerrada. |
| `e_literal_texto_no_cerrada.jasb` | Literal `"` sin cerrar en declaración `texto` | **Fallo compilación** — mismo error léxico. |
| `e_interp_vacia.jasb` | `"${}"` (expresión vacía) | **Compila y ejecuta**; en tiempo de ejecución se imprime `${` (comportamiento actual; convendría error en codegen o en parse de la subexpresión). |
| `e_interp_expresion_invalida.jasb` | `"x${@}y"` — `@` no es token en sub-parser | **Compila**; salida anómala `x${y` (subexpresión falla y `emit_print_interpolated` emite literal parcial). Catálogo **E** documenta el hallazgo para endurecer el compilador. |
