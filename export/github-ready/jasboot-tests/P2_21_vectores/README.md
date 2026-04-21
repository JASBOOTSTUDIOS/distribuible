# P2_21_vectores — `vec2` / `vec3` / `vec4`

Ítem de catálogo: **P2 · 21** en [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

Cubre constructores `vecN(...)`, acceso por componente (`.x`, `.y`, `.z`, `.w`; el campo **`.y`** es palabra clave y el analizador lo admite solo como miembro tras `.`), operaciones componente a componente (`+`, `-`, `*` escalar), `vecN_longitud`, `vecN_normalizar(dest, src)`, `vecN_dot`, `vec3_cross(dest, a, b)`.

---

## Carpetas

| Ruta | Rol |
|------|-----|
| **`R/`** | Casos de uso: básico, 2D distancia/movimiento, normal de triángulo, N·L, proyección `vec3`, mezcla `vec4`, **laboratorio interactivo** (`r_cu_p21_lab_interactivo_vectores.jasb`). Ver `R/NOTAS_R.md`. |
| **`E/`** | Errores de compilación: constructores `vecN`, aridad y forma de `vec*_dot`, `vec*_longitud`, `vec*_normalizar`, `vec3_cross`. Ver `E/NOTAS_E.md`. |
| **`S/`** | Estrés: millones de `vec3_normalizar`. Ver `S/NOTAS_S.md`. |

---

## Compilador / VM (referencia)

- Registro de structs `vec2`/`vec3`/`vec4` en la tabla de símbolos del **codegen** (paridad con `resolve.c`), para `sym_get_struct_field` y tipos de miembro.
- `get_expression_type`: `vec*_longitud` y `vec*_dot` como `flotante` (impresión y stores correctos).
- `vec*_dot`: acumulador en registro fijo para no pisar el resultado si `dest_reg` es 1 o 2.
- `vecN_normalizar` y `vec3_cross`: flags de `OP_ESCRIBIR` sin `B_IMMEDIATE` cuando el valor sale del registro (la VM interpretaba el índice de registro como literal).
- Parser: tras `.`, token `y` (keyword) permitido como nombre de campo.
