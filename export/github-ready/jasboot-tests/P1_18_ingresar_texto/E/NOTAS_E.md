# P1 · 18 — Notas de errores y limites (E)

## Sintaxis

- `ingresar_texto` exige un **identificador** válido; ver `e_cu_p18_ingresar_texto_sin_variable.jasb` y `e_cu_p18_ingresar_texto_destino_reservado.jasb`.

## EOF (entrada estándar)

- Implementación: `OP_IO_INPUT_REG` en `sdk-dependiente/jasboot-ir/src/vm.c` (`fgets` sobre buffer de 256 bytes).
- **Sin** flag `--continuo` en `jasboot-ir-vm`: si `fgets` falla (EOF), `vm->running = 0` y el programa **deja de ejecutarse** (puede no llegar a sentencias posteriores).
- **Con** `--continuo`: se asigna cadena vacía (id de texto vacío) y la VM sigue. Prueba: `R/r_cu_p18_eof_cadena_vacia.jasb`.

## Líneas largas

- Una sola llamada a `fgets` lee **como mucho 255 caracteres** (más el `\0`). El resto de la línea queda en el buffer del stream para la **siguiente** lectura.
- Prueba: `R/r_cu_p18_linea_larga_dos_lecturas.jasb` con entrada de 300 caracteres `x` seguidos de `\n` → salidas `255` y `45` en `longitud(parte1)` y `longitud(parte2)`.

## Entrada solo numérica

- Con la VM actual, `OP_IO_INPUT_REG` guarda la línea **siempre como cadena** (id en caché de texto), incluso si es un entero decimal puro (`"0"`, `"42"`), para alinear con el tipo `texto` y comparaciones como `linea == "0"`. Prueba: `R/r_cu_p18_ctrl_digitos_son_texto.jasb`.

## `str_a_entero` / `str_a_flotante` con texto no numérico

- Si el texto **no** es un entero decimal válido (toda la línea tras espacios, sin basura) o no es un flotante válido, la VM lanza un error **capturable** con `intentar` … `atrapar` (mensaje en la variable del `atrapar`, registro de texto como con `mapa_obtener` o índice de lista inválido).
- Sin `intentar`, la ejecución termina con código distinto de cero y mensaje en stderr. Pruebas: `R/r_cu_p18_ctrl_str_a_entero_invalido_intentar.jasb`, `E/e_ej_p18_str_a_entero_no_numerico_sin_intentar.jasb`.
