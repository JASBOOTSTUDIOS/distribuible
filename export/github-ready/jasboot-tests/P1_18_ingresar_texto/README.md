# P1 · 18 — `ingresar_texto` y entrada estándar

Cubre el checklist **P1 | 18**. La sentencia `ingresar_texto <variable>` emite `OP_IO_INPUT_REG` y escribe en la variable `texto` (misma ruta que `leer_entrada()` en expresión). La línea leída se guarda siempre como **cadena** (id en caché de texto), incluso si son solo dígitos (`"0"`, `"42"`), para que coincida con el tipo `texto` y comparaciones como `op == "0"`.

- **R/**: eco desde stdin; línea más larga que el buffer interno (256 bytes en `vm.c`, `fgets` → máximo 255 caracteres por lectura).
- **R/** (`r_cu_p18_ctrl_*.jasb`): `ingresar_texto` como **control de flujo** — `si`, `sino si`, `mientras`, `romper`, `seleccionar`/`caso`, `cuando`/`sino`, condiciones con `y`/`o`, `str_a_entero`, `longitud`/`contiene_texto`, comparación entre líneas, ternario con texto, dígitos como texto (`== "0"`), etc.
- **E/**: sintaxis inválida; **E (ejecución)** sin `intentar` cuando `str_a_entero` recibe texto no numérico (`e_ej_p18_str_a_entero_no_numerico_sin_intentar.jasb`); notas sobre **EOF** y `--continuo` en la VM.

**Ejecutar con tubería (PowerShell, desde la raíz del repo):**

```powershell
bin\jbc.cmd tests\P1_18_ingresar_texto\R\r_cu_p18_ingresar_texto_eco.jasb -o $env:TEMP\p18.jbo
"hola stdin" | & "sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe" --continuo $env:TEMP\p18.jbo
```

**EOF con cadena vacía:** misma compilación, stdin vacío inmediato:

```powershell
Get-Content NUL | & "sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe" --continuo $env:TEMP\p18eof.jbo
```

(sustituir por el `.jbo` de `r_cu_p18_eof_cadena_vacia.jasb`; en Windows a veces conviene `cmd /c "type nul | ..."`).

Sin `--continuo`, un **EOF** en la primera lectura hace que la VM **detenga** la ejecución (`vm->running = 0`).

## Batería `r_cu_p18_ctrl_*.jasb` (texto como control)

Compilar un caso y ejecutar con las líneas de entrada del comentario del archivo (PowerShell: `"linea1`nlinea2`n" | … --continuo archivo.jbo`).

| Archivo | Entrada (stdin, líneas) | Salida esperada (resumen) |
|--------|-------------------------|---------------------------|
| `r_cu_p18_ctrl_si_igual_texto.jasb` | `ok` | `1` + línea vacía |
| `r_cu_p18_ctrl_si_no_es_igual.jasb` | `fin` | `2` + línea vacía |
| `r_cu_p18_ctrl_sino_si_encadenado.jasb` | `b` | `20` + línea vacía |
| `r_cu_p18_ctrl_cuando_texto.jasb` | `si` | `100` + línea vacía |
| `r_cu_p18_ctrl_mientras_hasta_palabra.jasb` | `a`, `b`, `salir` | `1`, `1`, `9` + línea vacía |
| `r_cu_p18_ctrl_mientras_romper.jasb` | `uno`, `x` | `1`, `8` + línea vacía |
| `r_cu_p18_ctrl_seleccionar_texto.jasb` | `beta` | `2` + línea vacía |
| `r_cu_p18_ctrl_seleccionar_multicaso_misma_linea.jasb` | `q` | `5` + línea vacía |
| `r_cu_p18_ctrl_longitud_condicion.jasb` | `abc` | `1` + línea vacía |
| `r_cu_p18_ctrl_contiene_texto.jasb` | `abracadabra` | `7` + línea vacía |
| `r_cu_p18_ctrl_y_o_logicos.jasb` | `1x2` | `5` + línea vacía |
| `r_cu_p18_ctrl_condicion_o.jasb` | `a` | `1` + línea vacía |
| `r_cu_p18_ctrl_str_a_entero_tras_leer.jasb` | `15` | `16` + línea vacía |
| `r_cu_p18_ctrl_str_a_entero_invalido_intentar.jasb` | `gg` | `ok`, vacío, mensaje con `str_a_entero`, vacío, `fin`, vacío |
| `r_cu_p18_ctrl_mientras_str_a_entero.jasb` | `3` | `1`, `2`, `3`, `9` + línea vacía |
| `r_cu_p18_ctrl_digitos_son_texto.jasb` | `0` | `88` + línea vacía |
| `r_cu_p18_ctrl_doble_lectura_comparar.jasb` | `mismo`, `mismo` | `1` + línea vacía |
| `r_cu_p18_ctrl_reasignar_y_condicion.jasb` | `uno`, `dos` | `2` + línea vacía |
| `r_cu_p18_ctrl_concatenacion_en_bucle.jasb` | `a`, `b`, `cd` | `4` + línea vacía |
| `r_cu_p18_ctrl_ternario_texto.jasb` | `go` | `SI` + línea vacía |

Ejemplo (`mientras` + `romper`):

```powershell
bin\jbc.cmd tests\P1_18_ingresar_texto\R\r_cu_p18_ctrl_mientras_romper.jasb
"uno`nx`n" | & "sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe" --continuo tests\P1_18_ingresar_texto\R\r_cu_p18_ctrl_mientras_romper.jbo
```
