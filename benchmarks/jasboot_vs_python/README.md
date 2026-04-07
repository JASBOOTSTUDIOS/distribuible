## Jasboot vs Python, TypeScript y C

Benchmarks reproducibles para comparar `jasboot-ir-vm` frente a Python, TypeScript/Node y C nativo.

Casos iniciales:

- `cpu_sum_loop`: bucle entero simple, útil para medir dispatch y operaciones base.
- `mat4_identity`: multiplicación intensiva de `mat4`, útil para flotantes y builtins matemáticas.
- `text_concat_length`: concatenación repetida y medición de longitud.
- `extraer_subtexto_bucle_bench`: estrés de `concatenar + extraer_subtexto`, comparado contra Python y TypeScript.
- `text_search_triple`: `contiene_texto`, `buscar_en_texto` y `termina_con` sobre la misma cadena.
- `function_call_loop`: coste de muchas llamadas a función pequeñas.

Archivos Jasboot usados:

- `cpu_sum_loop.jasb`
- `..\..\tests\P2_22_mat4\S\s_estres_p22_mat4_mul_mil.jasb`
- `text_concat_length.jasb`
- `extraer_subtexto_bucle_bench.jasb`
- `text_search_triple.jasb`
- `function_call_loop.jasb`

Archivos C usados:

- `c_cpu_sum_loop.c`
- `c_mat4_identity.c`
- `c_text_concat_length.c`
- `c_extraer_subtexto_bucle.c`
- `c_text_search_triple.c`
- `c_function_call_loop.c`

Ejecutar:

```powershell
powershell -ExecutionPolicy Bypass -File .\run.ps1
```

Notas:

- El runner compila los casos Jasboot a `build\`.
- También compila TypeScript a `build-ts\`.
- También compila C con `gcc -O3` a `build-c\`.
- Se ejecutan varias repeticiones y se muestra media en ms.
- Valida que la salida de Jasboot, Python, TypeScript y C coincida por caso.
- Al final imprime una tabla por caso y un resumen por categoría.

Resumen reciente de la matriz:

| Categoria | Caso | Jasboot | Python | TypeScript | C | Ganador |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| `float_math` | `mat4_identity` | `18.29 ms` | `281.25 ms` | `68.16 ms` | `11.38 ms` | `c` |
| `function_calls` | `function_call_loop` | `18.96 ms` | `48.6 ms` | `64.64 ms` | `15.99 ms` | `c` |
| `int_cpu` | `cpu_sum_loop` | `11.39 ms` | `420.07 ms` | `58.72 ms` | `10.75 ms` | `c` |
| `text_search` | `text_search_triple` | `17.21 ms` | `40.08 ms` | `61.42 ms` | `10.91 ms` | `c` |
| `text_substring` | `extraer_subtexto_bucle_bench` | `19.31 ms` | `35207.87 ms` | `89.71 ms` | `19.68 ms` | `jasboot` |
| `text_utils` | `text_concat_length` | `35.48 ms` | `34.11 ms` | `56.29 ms` | `10.04 ms` | `c` |

Resultado reciente en `extraer_subtexto_bucle_bench`:

| Runtime | Run 1 | Run 2 | Run 3 |
| --- | ---: | ---: | ---: |
| Jasboot | `50.4 ms` | `46.97 ms` | `54.42 ms` |
| TypeScript/Node | `104.93 ms` | `93.77 ms` | `99.17 ms` |
| Python | `36239.44 ms` | `35154.89 ms` | `34888.79 ms` |

Resumen:

- C nativo lidera en `float_math`, `function_calls`, `int_cpu`, `text_search` y `text_utils`.
- Jasboot lidera en `text_substring` en esta matriz actual.
- Frente a Python y TypeScript, Jasboot sigue muy competitivo y ya gana varias categorias amplias de la suite.
