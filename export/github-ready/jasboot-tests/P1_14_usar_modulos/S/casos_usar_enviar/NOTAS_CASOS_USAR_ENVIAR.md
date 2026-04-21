# Casos de uso `usar { ... }` y `enviar` (P1_14, carpeta `casos_usar_enviar`)

Ejecutar desde esta carpeta: `jbc cu_XX_....jasb -e`.

La opcion `-e` compila y lanza la VM (`jasboot-ir-vm`). El compilador localiza la VM a partir del directorio de `jbc.exe` (`bin/../sdk-dependiente/jasboot-ir/bin/`), asi que debe imprimirse la salida del programa aunque el cwd este en carpetas profundas bajo `tests/`.

## Modulos de apoyo

| Archivo | Rol |
|---------|-----|
| `m_export_mix.jasb` | `enviar`: `EXP_C`, `exp_fn`, `exp_mac`; internos: `PRIV_C`, `priv_fn`. |
| `m_cadena_wrap.jasb` | `usar { exp_fn }` + `enviar funcion wrap_dup`. |
| `m_side_a.jasb` / `m_side_b.jasb` | Constantes sueltas para dos lineas `usar`. |

## Programas nominales (`cu_*.jasb`)

| Archivo | Cubre |
|---------|--------|
| `cu_01_usar_una_funcion.jasb` | `usar { exp_fn } de` |
| `cu_02_usar_una_constante.jasb` | `usar { EXP_C } de` + `enviar constante` |
| `cu_03_usar_una_macro.jasb` | `usar { exp_mac } de` + `enviar macro` |
| `cu_04_usar_lista_varios.jasb` | Lista con funcion, constante y macro |
| `cu_05_usar_todas.jasb` | `usar todas de` (solo simbolos `enviar`) |
| `cu_06_usar_todo.jasb` | `usar todo de` (alias de `todas` en el compilador) |
| `cu_07_cadena_usar_nominal.jasb` | Import nominal de capa que ya importo otro modulo |
| `cu_08_dos_lineas_usar.jasb` | Dos `usar` a **dos** archivos distintos |
| `cu_09_lista_multilinea.jasb` | Lista nominal en varias lineas |
| `cu_10_una_linea_varios_nombres.jasb` | Varios nombres del mismo modulo en **una** directiva |

## Salidas esperadas (`jbc -e`)

| Archivo | Salida |
|---------|--------|
| cu_01 | `42` |
| cu_02 | `42` |
| cu_03 | `8` |
| cu_04 | `85` |
| cu_05 | `46` |
| cu_06 | `85` |
| cu_07 | `86` |
| cu_08 | `42` |
| cu_09 | `42` |
| cu_10 | `84` |

## Errores y limitaciones (ver tambien `../E/` y `../R/`)

- Pedir en `{ }` un nombre que existe pero **sin** `enviar`: ver `E/e_usar_nombre_no_enviado.jasb`.
- Segundo `usar` al **mismo** `.jasb` no fusiona nombres adicionales: usar una sola lista o modulos distintos (`cu_08` vs `cu_10`).
- Funciones importadas solas no arrastran automaticamente otras globales del modulo; el cuerpo no debe referenciar globales no fusionadas (por eso `exp_fn` usa el literal `42` alineado con `EXP_C`).
