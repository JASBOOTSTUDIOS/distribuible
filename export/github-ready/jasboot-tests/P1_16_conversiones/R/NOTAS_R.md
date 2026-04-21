# R — conversiones P1_16 (`jbc -e`)

## Catálogo general (I2F / F2I / `retornar`)

| Archivo | Qué ejercita | Salida esperada |
|---------|----------------|-----------------|
| `r_conv_i2f_declaracion.jasb` | `flotante` ← literal y expresión **entero** (I2F implícito) | `3.0000` / `7.0000` |
| `r_conv_f2i_declaracion.jasb` | `entero` ← literal y expresión **flotante** (F2I implícito) | `3` / `8` |
| `r_conv_asignacion.jasb` | Reasignaciones cruzadas | `5` / `4.0000` |
| `r_conv_retornar.jasb` | `retornar` con conversión al tipo declarado de la función | `12` / `9.0000` (texto vía `decimal`) |

## Casos de uso `convertir_entero` / `convertir_flotante` (y `str_a_*`)

| # | Archivo | Qué ejercita | Salida esperada |
|---|---------|----------------|-----------------|
| 1 | `r_cu_p16_01_convertir_literals.jasb` | Literales en declaración | `42` / `3.5000` |
| 2 | `r_cu_p16_02_convertir_desde_variable_texto.jasb` | Variable `texto` → `convertir_entero` | `2026` |
| 3 | `r_cu_p16_03_str_desde_numero_y_convertir.jasb` | `str_desde_numero` + `convertir_entero` | `88` |
| 4 | `r_cu_p16_04_funcion_parametro_texto.jasb` | Función `texto` → `retorna entero` | `55` |
| 5 | `r_cu_p16_05_si_sino_rama_texto.jasb` | `si`/`sino` elige cadena y convierte | `15` |
| 6 | `r_cu_p16_06_entero_por_flotante_implicito.jasb` | `entero * flotante` (I2F implícito) | `10.0000` |
| 7 | `r_cu_p16_07_mientras_acumula_str_desde_numero.jasb` | `mientras` suma 0..19 vía texto | `190` |
| 8 | `r_cu_p16_08_str_a_mas_convertir_flotante.jasb` | `str_a_entero` + `convertir_flotante` | `7` / `2.2500` |
| 9 | `r_cu_p16_09_cadenas_con_signo.jasb` | Cadenas con `-` | `-9` / `-1.2500` |
| 10 | `r_cu_p16_10_funcion_retorna_flotante_convertir.jasb` | `retorna flotante` + `decimal` | `3.1416` |
| 11 | `r_cu_p16_11_conversion_invalida_muestra_nan.jasb` | Texto no numerico → **nan** (`imprimir` / `imprimir_flotante`) | `nan` / `nan` |
