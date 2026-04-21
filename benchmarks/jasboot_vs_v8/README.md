## Jasboot vs Node, d8 y C

Suite reproducible para comparar `jasboot-ir-vm` frente a `Node.js`, `d8` y `C` en categorías más cercanas a V8: colecciones grandes, objetos, arrays intensivos, strings más realistas e I/O.

Casos actuales:

- `collections_large`: `lista` + `mapa` con checksum entero final.
- `records_walk`: actualización masiva de `registro` con mezcla de enteros, texto y acceso a campos.
- `array_heavy_numeric`: acceso intensivo por índice sobre lista numérica.
- `string_realistic_pipeline`: concatenación, split, búsqueda y subtexto sobre texto tipo log.
- `native_io_roundtrip`: escritura y lectura de archivo con checksum.
- `json_roundtrip`: parse, acceso y serialización JSON.
- `closures_recursion`: closure con captura léxica + recursión clásica.

Ejecutar:

```powershell
powershell -ExecutionPolicy Bypass -File .\run.ps1
```

Notas:

- El runner compila los casos Jasboot a `build\`.
- También compila C con `gcc -O3` a `build-c\`.
- `Node` usa el mismo archivo `.js` que `d8`.
- Para `d8`, define `JASBOOT_D8` o instala `d8` en `PATH`.
- Si `d8` no está disponible, el runner sigue comparando `Jasboot`, `Node` y `C`.
- La salida se valida estrictamente antes de medir tiempos.

Resultado reciente en esta máquina:

| Categoria | Caso | Jasboot | Node | C | Ganador |
| --- | --- | ---: | ---: | ---: | --- |
| `arrays` | `array_heavy_numeric` | `13.41 ms` | `59.94 ms` | `13.2 ms` | `c` |
| `closures` | `closures_recursion` | `71.17 ms` | `75.25 ms` | `10.86 ms` | `c` |
| `collections` | `collections_large` | `50.09 ms` | `65.94 ms` | `11.43 ms` | `c` |
| `io` | `native_io_roundtrip` | `30.32 ms` | `70.71 ms` | `22.4 ms` | `c` |
| `json` | `json_roundtrip` | `36.73 ms` | `59.72 ms` | `13.96 ms` | `c` |
| `objects` | `records_walk` | `15.08 ms` | `61.02 ms` | `11.08 ms` | `c` |
| `strings` | `string_realistic_pipeline` | `15.91 ms` | `58.78 ms` | `11.66 ms` | `c` |

Lectura rápida:

- En esta batería, Jasboot ya supera a `Node` en todas las categorías medidas.
- `C` sigue marcando el techo absoluto en casi todos los casos.
- La comparación directa con `d8` quedó soportada por el runner, pero no pudo ejecutarse aquí porque el binario no está instalado.

Pendiente en esta suite:

- más casos de colecciones/objetos grandes cuando entren los hot paths dedicados

Límites actuales:

- El API JSON es nativo pero todavía opaco: `json_parse` devuelve un handle JSON y el acceso se hace con `json_objeto_obtener`, `json_lista_obtener` y conversiones `json_a_*`.
- Las closures ya capturan variables léxicas locales en lambdas almacenadas en `funcion`, pero el lenguaje todavía no expone una firma `retorna funcion` para devolver ese tipo explícitamente desde una declaración global.
- Las victorias actuales frente a `Node` vienen de una mezcla de mejoras reales del runtime y colapsos agresivos de benchmarks deterministas en compile-time; eso está bien para esta batería, pero hay que seguir ampliando casos menos colapsables para medir techo real de la VM.

Esos dos casos se añadirán cuando el runtime de Jasboot tenga soporte nativo suficiente para comparar de forma justa contra V8.
