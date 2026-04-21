# E — conversiones a `entero` / `flotante` (P1_16)

Todos estos `.jasb` deben **fallar en compilación** con `jbc` (sin `-e`). La regla aplicada en `codegen.c` es: hacia **`entero`** o **`flotante`** solo hay conversión implícita **entre** `entero` y `flotante`; desde **`texto`**, **`concepto`**, **`lista`**, **`mapa`**, vectores/matrices, etc., hay que usar APIs explícitas (`str_a_entero`, `str_a_flotante`, …).

Mensaje esperado (o equivalente): en **`retornar`** frente a `retorna entero`/`retorna flotante`, el texto incluye **`La funcion '…' declara retorno tipo`** y **`no puede retornar un valor de tipo`**. En asignaciones y declaraciones locales/globales sigue el mensaje genérico con `No hay conversion implicita de tipo`.

| Archivo | Intento |
|---------|---------|
| `e_conv_decl_entero_literal_texto.jasb` | `entero` ← literal `"…"` |
| `e_conv_decl_flotante_literal_texto.jasb` | `flotante` ← literal `"…"` |
| `e_conv_asign_entero_variable_texto.jasb` | `entero` ← variable `texto` |
| `e_conv_global_entero_desde_texto.jasb` | global `entero` ← `texto` |
| `e_conv_retornar_entero_literal_texto.jasb` | `retornar` cadena en función `retorna entero` |
| `e_conv_retornar_flotante_literal_texto.jasb` | `retornar` cadena en función `retorna flotante` |
| `e_conv_decl_entero_texto_concat.jasb` | `entero` ← expresión `texto + texto` |
| `e_conv_decl_entero_interpolacion.jasb` | `entero` ← literal con interpolación (tipo `texto`) |
| `e_conv_decl_flotante_mapa_literal.jasb` | `flotante` ← literal `mapa` `{ ... }` |
| `e_conv_asign_flotante_caracter.jasb` | `flotante` ← literal `caracter` (concepto de un símbolo) |

## Errores relacionados con `convertir_*` (catálogo numerado)

| # | Archivo | Qué provoca |
|---|---------|-------------|
| 1 | `e_cu_p16_convertir_entero_sin_argumento.jasb` | `convertir_entero()` sin argumento → mensaje: **requiere un argumento** (texto entero) |
| 2 | `e_cu_p16_convertir_flotante_sin_argumento.jasb` | `convertir_flotante()` sin argumento → igual, texto flotante |
| 3 | `e_cu_p16_convertir_typo_nombre.jasb` | Nombre inexistente `convertitr_flotante` |
| 4 | `e_cu_p16_entero_desde_variable_texto.jasb` | `entero` ← variable `texto` sin conversión |
| 5 | `e_cu_p16_concat_texto_a_entero.jasb` | `entero` ← `texto + texto` |

Para **`retornar` cadena vs `retorna entero`**, ver también `e_conv_retornar_entero_literal_texto.jasb` y `e_conv_retornar_flotante_literal_texto.jasb`.

Verificación rápida desde la raíz del repo:

```bat
bin\jbc.cmd tests\P1_16_conversiones\E\e_conv_decl_entero_literal_texto.jasb -o build\t.jbo
echo %ERRORLEVEL%
```

Debe ser distinto de `0` (el lanzador `bin\jbc.cmd` reenvía el código de salida de `jbc.exe`).
