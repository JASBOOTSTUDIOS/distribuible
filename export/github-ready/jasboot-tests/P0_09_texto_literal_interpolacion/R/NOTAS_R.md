# R — Rendimiento y casos válidos

| Archivo | Qué prueba |
|---------|------------|
| `r_ok_texto_e_interpolacion.jasb` | Variable `texto`, literal e `imprimir` con `${entero}`. |
| `r_ok_literal_vacio.jasb` | `texto = ""` e impresión de cadena vacía (formato «vacío» válido). |
| `r_muchos_imprimir_interp.jasb` | 500 líneas con `imprimir "i=${k}"` (calor para lexer + codegen de interpolación). |

Medir tiempo: `Measure-Command { & bin\jbc.exe R\r_muchos_imprimir_interp.jasb -e }`.
