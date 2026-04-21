# `madurez_maxima` — estrés integrado del lenguaje

Suite de **12 archivos `.jasb`** (11 módulos en `libs/` + `madurez_maxima_main.jasb`) pensada para ejercitar en conjunto compilador, enlace de módulos, VM (CPU, FPU, listas/JMN) y patrones ya documentados en el catálogo (P1_14 `usar`/`enviar`, P2_22 mat4, P2_25 bits, P2_27 listas, P1_11 orden superior, P1_19 `intentar`, etc.).

## GPU

**No hay llamadas a API gráfica** (OpenGL/Vulkan/DirectX) desde Jasboot en esta suite. El bloque **mat4 / vec4** en `libs/m04_mat_gpu.jasb` reproduce en **CPU** el mismo estilo de trabajo que escenas 3D documentadas (`mat4_mul`, `mat4_mul_vec4`): es una carga **FPU + IR matricial**, no uso real de GPU.

## Mapa de módulos y variantes de importación

| Archivo | `usar` / `activar_modulo` | Exporta (`enviar`) |
|---------|---------------------------|-------------------|
| `libs/m00_seeds.jasb` | — | Constantes `MAD_*` |
| `libs/m01_lcg.jasb` | `usar todas` → m00 | `mad_lcg` |
| `libs/m02_bits.jasb` | `usar { MAD_SEED }` → m00 | `bit_mix` |
| `libs/m03_lista.jasb` | `usar todas` m01 + `usar { MAD_CAP_LISTA }` m00 | `lista_checksum` |
| `libs/m04_mat_gpu.jasb` | — | `GPU_MAT_ROUNDS`, `mad_gpu_checksum` |
| `libs/m05_texto.jasb` | `usar todo` → m01 | `texto_digest` |
| `libs/m06_ho.jasb` | — | `mad_inc`, `mad_apply_n` |
| `libs/m07_chain.jasb` | `usar todas` m03 + m02 | `mega_mix` |
| `libs/m08_side_a.jasb` | — | `SIDE_A` |
| `libs/m09_side_b.jasb` | — | `SIDE_B` |
| `libs/m10_wrap.jasb` | `usar { mad_lcg }` → m01 | `wrap_lcg` |
| `madurez_maxima_main.jasb` | `usar todas` / `todo` / `{ }` / `activar_modulo todas` | — |

El **main** combina: `usar todas`, `usar todo`, import **nominal** `{ … }`, y **`activar_modulo todas`** (sinónimo operativo de carga de módulo, alineado con P1_14).

## Ejecución

Desde esta carpeta (para que las rutas `libs/...` resuelvan bien):

```powershell
Set-Location tests\estres\madurez_maxima
& .\..\..\..\sdk-dependiente\jas-compiler-c\bin\jbc.exe madurez_maxima_main.jasb -e
```

O compilar y ejecutar la VM por separado.

## Salida esperada (referencia)

Con `MAD_CPU_OUTER = 9000` y toolchain actual, la VM imprime líneas con:

1. Checksum entero muy grande (p. ej. `2415348377698948`).
2. Línea vacía.
3. `300` (tamaño de la lista local de comprobación).
4. Línea vacía.
5. `22` (`GPU_MAT_ROUNDS`).
6. Línea vacía.
7. Un flotante (~`4.3851` con float32).
8. Línea vacía.
9. Texto `ok`.

Si cambias `MAD_CPU_OUTER` o `MAD_CAP_LISTA` en `m00_seeds.jasb`, vuelve a anotar aquí el checksum y el flotante.

## Nota sobre `mem_lista_agregar`

Evita poner una **llamada a función anidada** directamente como segundo argumento de `mem_lista_agregar` en este entorno; asigna antes a una variable temporal (`entero vz = …; mem_lista_agregar(buf_scratch, vz)`). Así el test sigue ejercitando LCG y listas sin depender de un caso límite del codegen.

## Subir la carga

- Sube `MAD_CPU_OUTER` en `libs/m00_seeds.jasb` (bucle principal del main).
- Sube `GPU_MAT_ROUNDS` en `libs/m04_mat_gpu.jasb`.
- Sube `MAD_CAP_LISTA` y el uso en `lista_checksum` vía `mega_mix` (más trabajo en JMN por iteración del bucle externo).
