# P3_30 — Notas E (errores / aridad)

Cada `e_cu_p30_*.jasb` debe **fallar al compilar** con `jbc` (código de salida ≠ 0): aridad inválida. El mensaje indica **faltan** o **sobran** argumentos, el **ejemplo** usa el mismo nombre que en el `.jasb` cuando hay alias (`longitud`/`longitud_texto`, `dividir`/`dividir_texto`, etc.).

**Regla de `dividir` / `dividir_texto`:** exactamente **dos** argumentos (texto y separador). Ya no se admite la forma de un solo argumento.

| Archivo | Qué prueba |
|---------|------------|
| `e_cu_p30_concatenar_sin_args.jasb` | `concatenar()` |
| `e_cu_p30_concatenar_un_argumento.jasb` | `concatenar("solo")` |
| `e_cu_p30_concatenar_tres_argumentos.jasb` | `concatenar("a","b","c")` — sobran |
| `e_cu_p30_longitud_sin_args.jasb` | `longitud()` |
| `e_cu_p30_longitud_dos_argumentos.jasb` | `longitud("ab","cd")` — sobra |
| `e_cu_p30_longitud_texto_sin_args.jasb` | `longitud_texto()` |
| `e_cu_p30_longitud_texto_dos_argumentos.jasb` | `longitud_texto("ab","cd")` — sobra |
| `e_cu_p30_minusculas_sin_args.jasb` | `minusculas()` |
| `e_cu_p30_minusculas_dos_argumentos.jasb` | `minusculas("A","B")` — sobra |
| `e_cu_p30_str_minusculas_sin_args.jasb` | `str_minusculas()` |
| `e_cu_p30_str_minusculas_dos_argumentos.jasb` | `str_minusculas("X","Y")` — sobra |
| `e_cu_p30_copiar_texto_sin_args.jasb` | `copiar_texto()` |
| `e_cu_p30_copiar_texto_dos_argumentos.jasb` | `copiar_texto("uno","dos")` — sobra |
| `e_cu_p30_str_copiar_sin_args.jasb` | `str_copiar()` |
| `e_cu_p30_str_copiar_dos_argumentos.jasb` | `str_copiar("uno","dos")` — sobra |
| `e_cu_p30_dividir_texto_sin_args.jasb` | `dividir_texto()` |
| `e_cu_p30_dividir_texto_un_argumento.jasb` | `dividir_texto("solo")` — falta separador |
| `e_cu_p30_dividir_texto_tres_argumentos.jasb` | `dividir_texto("a,b",",","extra")` — sobra |
| `e_cu_p30_dividir_un_argumento.jasb` | `dividir("solo")` — alias, falta separador |

Comando típico (desde raíz del monorepo):

```text
bin\jbc.cmd tests\P3_30_cadenas_utilidades\E\<archivo>.jasb -o %TEMP%\t.jbo
```
