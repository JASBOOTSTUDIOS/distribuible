# S — estrés P1_16 (`jbc -e`)

Integración **P0–P1_16**: bucles, condicionales, funciones, macros (P1_12), `str_desde_numero`, `decimal`, conversiones implícitas donde apliquen, y **`convertir_entero` / `convertir_flotante`**.

| # | Archivo | Idea | Salida esperada |
|---|---------|------|-----------------|
| 1 | `s_estres_p16_suma_grande_str_desde_numero.jasb` | 500× `str_desde_numero` + `convertir_entero` | `124750` |
| 2 | `s_estres_p16_doble_bucle_convertir.jasb` | Doble `mientras` 25×25, suma constante | `625` |
| 3 | `s_estres_p16_acumula_flotante_cadenas.jasb` | 300× sumar `convertir_flotante("0.25")` | `75.00` |
| 4 | `s_estres_p16_funcion_en_bucle_digitos.jasb` | Función + `%` + `str_desde_numero`, 400 iteraciones | `1800` |
| 5 | `s_estres_p16_macro_y_conversiones_implicitas.jasb` | Macro `dup` + `convertir_entero`, 150× | `900` |
