# E — `imprimir` (errores y límites)

| Archivo | Qué prueba | Resultado **jbc** |
|---------|------------|-------------------|
| `e_literal_sin_cerrar.jasb` | Comilla de cadena sin cerrar | **Fallo** (parser: contexto roto; al cerrar bloque, token inesperado / se esperaba `fin_principal`). |
| `e_expresion_invalida.jasb` | Expresión con `@` | **Fallo** (lexer: carácter no reconocido). |
| `e_imprimir_sin_expresion_lexico_fin.jasb` | Solo `imprimir` antes de `fin_principal` | **Fallo compilación** (mensaje explícito: se esperaba una expresión tras `imprimir`; se muestra el token `fin_principal` y ubicación). |
