# Capacidades del lenguaje (jbc) para drivers y motores 3D

Evaluación basada en el compilador **jbc** (`sdk-dependiente/jas-compiler-c`) y la VM (`jasboot-ir`).  
**Fecha:** 2026-03-24 (alineado con [CHECKLIST_ESTABILIDAD_DRIVERS_3D.md](CHECKLIST_ESTABILIDAD_DRIVERS_3D.md))

---

## 1. Resumen ejecutivo

| Área | ¿Suficiente hoy? | Comentario |
|------|-------------------|------------|
| **Drivers (kernel/hardware)** | **No** | Sigue faltando punteros tipados, MMIO/port I/O, interrupciones y target kernel/bare-metal (sección D del checklist). |
| **Motor 3D (alto nivel)** | **Casi** | Heap, trigonometría, `mat4`/`mat3`, vectores y **FFI** (cargar lib, símbolo, llamar) están implementados; falta sobre todo ejemplo end-to-end (p. ej. ventana + clear vía FFI) y documentar límites del IR/VM. |

---

## 2. Lo que el lenguaje ya tiene (jbc + VM)

### 2.1 Tipos de datos
- **Escalares:** `entero`, `flotante`, `texto`, `caracter`, `bool`, `u8`, `u32`, `u64`, `byte`
- **Estructuras:** `struct` definidos por el usuario
- **Vectores matemáticos:** `vec2`, `vec3`, `vec4` (campos `x,y` / `x,y,z` / `x,y,z,w` tipo `flotante`)
- **Matrices:** `mat4` (128 bytes, row-major), `mat3` (72 bytes); identidad, transpuesta, inversa (`mat4`), multiplicación y `mat4_mul_vec4`, `mat3_mul_vec3`, etc.

### 2.2 Memoria
- **Pila:** variables locales y `RESERVAR_PILA` (frame por función)
- **Memoria lineal:** `OP_LEER` / `OP_ESCRIBIR` (carga/almacenamiento por dirección en la memoria de la VM)
- **Heap:** `reservar(n)` / `liberar(ptr)` en fuente → `OP_HEAP_RESERVAR` / `OP_HEAP_LIBERAR` en jbc; detalle en [HEAP_MEMORIA.md](HEAP_MEMORIA.md)

### 2.3 Matemáticas
- Aritmética entera y flotante: `+`, `-`, `*`, `/`, `%`
- Flotante: conversiones `entero↔flotante`, `OP_RAIZ` (sqrt)
- **Trigonometría (radianes):** `sin`, `cos`, `tan`, `atan2` / `arcotangente2`
- **Opcional en VM:** `exp`, `log`, `log10` (útiles para iluminación/tonemapping)
- **Vectores:** longitud, normalizar, dot, `vec3_cross`, etc.
- **Matrices:** ver §2.1

### 2.4 E/S y sistema
- Archivos: `fs_abrir`, `fs_cerrar`, `fs_escribir`, `fs_leer_byte`, etc.
- Sistema: `sys_argc`, `sys_argv`, `sistema_ejecutar`
- Listas/mapas en memoria: `mem_lista_crear`, `mem_lista_agregar`, etc.

### 2.5 FFI / bibliotecas
- **`ffi_cargar("lib")`**, **`ffi_simbolo(h, "nombre")`**, **`ffi_llamar(fn, a0, …)`** en jbc; VM: `OP_CARGAR_BIBLIOTECA`, `OP_FFI_OBTENER_SIMBOLO`, `OP_FFI_LLAMAR`
- Convención de registros, hasta 4 argumentos, retorno **entero o puntero (64b)**; **retorno flotante** como extensión futura (ver [FFI_CONVENCION_LLAMADA.md](FFI_CONVENCION_LLAMADA.md))
- Test de referencia: `sdk-dependiente/jas-compiler-c/tests/test_ffi.jasb` y `run_test_ffi.bat`

---

## 3. Qué falta para drivers

Los drivers (kernel o usuario con acceso real a hardware) suelen necesitar:

| Necesidad | Estado actual |
|-----------|----------------|
| Acceso a memoria cruda / MMIO (direcciones de dispositivo) | Solo memoria lineal **interna** de la VM; sin modelo de puntero/MMIO documentado para hardware. |
| Punteros como tipo (`puntero a entero`, etc.) | Pendiente (checklist D.1–D.2). |
| `inb`/`outb`, `readl`/`writel` o equivalentes | No. |
| Interrupciones, DMA, timers de kernel | No. |
| Atómicos / lock-free | No (D.7 opcional). |

**Conclusión:** para drivers reales hace falta completar la **sección D** del checklist (punteros, MMIO, posible target kernel/bare-metal).

---

## 4. Qué falta para un motor 3D “cerrado”

Para un motor 3D típico (usuario, OpenGL/Vulkan/DirectX):

| Necesidad | Estado actual |
|-----------|----------------|
| Vec2/3/4 y operaciones básicas | Sí |
| Matrices 4×4 y 3×3 y operaciones principales | Sí (`mat4`, `mat3`) |
| Trigonometría | Sí (`sin`, `cos`, `tan`, `atan2`; opcional `exp`/`log`/`log10`) |
| FFI a API C gráfica | Sí (cargar DLL/SO, resolver símbolo, llamar) |
| Buffers dinámicos (vértices, índices) | Sí vía heap + estructuras; la integración con la API es responsabilidad del programa + FFI |
| Retorno flotante desde FFI | Pendiente si la API exige muchas funciones que devuelven `double` sin wrapper C |
| Ejemplo mínimo documentado (“hola OpenGL”) | Pendiente (checklist E.4) |
| Límites del IR documentados (pila, heap máx., FFI) | Pendiente (checklist E.3) |
| Shaders | Otro lenguaje (GLSL/HLSL) o código generado; el IR no es target de shader |

**Conclusión:** la base de **lenguaje + VM** para lógica 3D y enlace con librerías nativas está en gran parte lista; el siguiente salto es **práctica y documentación** (ejemplo gráfico mínimo, límites explícitos) y, si hace falta, **FFI flotante**.

---

## 5. Recomendaciones prioritarias (actualizadas)

1. **Drivers:** completar D.1–D.4 del checklist si el objetivo es hardware/kernel.
2. **Motor 3D:** ejemplo mínimo con FFI + doc de límites (E.3–E.4); valorar retorno flotante en FFI si simplifica bindings.
3. **Mantenimiento:** mantener [CHECKLIST_ESTABILIDAD_DRIVERS_3D.md](CHECKLIST_ESTABILIDAD_DRIVERS_3D.md) como fuente de verdad de ítems [x]/[ ].

---

## 6. Checklist de tareas

→ **[CHECKLIST_ESTABILIDAD_DRIVERS_3D.md](CHECKLIST_ESTABILIDAD_DRIVERS_3D.md)**  
(FFI, matemáticas 3D, heap, drivers, calidad y orden sugerido de implementación)
