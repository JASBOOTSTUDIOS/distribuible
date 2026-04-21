# Checklist: lo que falta para estabilidad Drivers y Motor 3D

Objetivo: que el lenguaje (jbc + VM) tenga el grado de estabilidad y capacidades necesarias para **drivers** y **motores 3D**.  
Completar los ítems según prioridad (P1 = crítico, P2 = importante, P3 = deseable).

---

## A. FFI (llamar a código C / OpenGL / Vulkan)

| # | Tarea | Prioridad | Estado |
|---|--------|-----------|--------|
| A.1 | Definir en la VM una **tabla de handles** para bibliotecas cargadas (liberar en destroy). `OP_CARGAR_BIBLIOTECA` guarda handle en registro A. | P1 | [x] |
| A.2 | Implementar **obtención de símbolo** (GetProcAddress/dlsym) con `OP_FFI_OBTENER_SIMBOLO` (A=resultado, B=handle, C=reg con offset nombre en data). | P1 | [x] |
| A.3 | Opcode **OP_FFI_LLAMAR**: llamar función externa (B=fn, C=num_args 0–4, args en regs 3,4,5,6; resultado en A). | P1 | [x] |
| A.4 | En jbc: **ffi_cargar**, **ffi_simbolo**, **ffi_llamar** en sistema_llamadas y codegen; uso: `ffi_cargar("lib")`, `ffi_simbolo(h,"sym")`, `ffi_llamar(fn, a0, a1, ...)`. | P1 | [x] |
| A.5 | Documentar **convención de llamada** (registros, retorno 64b, límite 4 args). | P2 | [x] |
| A.6 | Soporte para **devolver** `entero` y puntero (64b) desde función externa; flotante como extensión futura. | P1 | [x] |

Ver: [FFI_CONVENCION_LLAMADA.md](FFI_CONVENCION_LLAMADA.md).  
**Test:** `sdk-dependiente/jas-compiler-c/tests/test_ffi.jasb` — compila y ejecuta con `jbc test_ffi.jasb -o test_ffi.jbo -e` o `tests/run_test_ffi.bat` (carga kernel32/libc, GetCurrentProcessId/getpid, imprime PID).

---

## B. Matemáticas 3D (trigonometría y matrices)

| # | Tarea | Prioridad | Estado |
|---|--------|-----------|--------|
| B.1 | Añadir **opcodes o llamadas de sistema** para `sin`, `cos`, `tan` (radianes) en la VM. | P1 | [x] |
| B.2 | Añadir **atan2(y, x)** en la VM y exponer en el lenguaje (jbc: nombre `atan2` o `arcotangente2`). | P1 | [x] |
| B.3 | En jbc: **reconocer** `sin`, `cos`, `tan`, `atan2` en sistema_llamadas y emitir el opcode/llamada correspondiente. | P1 | [x] |
| B.4 | Opcional: **exp**, **log**, **log10** en VM y lenguaje (útiles para iluminación/tonemapping). | P3 | [x] |
| B.5 | Definir tipo **mat4** (4×4 flotantes) en jbc (struct o tipo especial) y tamaño 16×8 = 128 bytes (row-major). | P1 | [x] |
| B.6 | Implementar **mat4 × vec4** en VM (opcode o helper) y exponer en lenguaje (ej. `mat4_mul_vec4`). | P1 | [x] |
| B.7 | Implementar **mat4 × mat4** en VM y en lenguaje (ej. `mat4_mul`). | P1 | [x] |
| B.8 | Opcional: **mat4_inversa**, **mat4_transpuesta**, **mat4_identidad** (o constructores). | P2 | [x] |
| B.9 | Opcional: tipo **mat3** y operaciones básicas (para normales, etc.). | P3 | [x] |

**Nota:** Trig: `sin`, `cos`, `tan`, `atan2`/`arcotangente2`; **exp**, **log**, **log10** (opcodes 0x9D–0x9F). Mat4: tipo `mat4` 128 bytes; `mat4_mul_vec4`, `mat4_mul`, `mat4_identidad(dest)`, `mat4_transpuesta(dest, src)`, `mat4_inversa(dest, src)`. Mat3: tipo `mat3` 72 bytes (9×8); `mat3_mul_vec3(dest, mat, vec)`, `mat3_mul(dest, matL, matR)`.

---

## C. Heap desde el lenguaje (reservar / liberar)

| # | Tarea | Prioridad | Estado |
|---|--------|-----------|--------|
| C.1 | En **opcodes.h** (jbc): definir `OP_HEAP_RESERVAR` (0x45) y `OP_HEAP_LIBERAR` (0x46) en paridad con ir_format.h. | P1 | [x] |
| C.2 | En **codegen.c** (jbc): detectar llamadas a **reservar(n)** y emitir `OP_HEAP_RESERVAR` (A = dest, B = n bytes). | P1 | [x] |
| C.3 | En **codegen.c** (jbc): detectar llamadas a **liberar(ptr)** y emitir `OP_HEAP_LIBERAR` (A = ptr). | P1 | [x] |
| C.4 | En la **VM**: asegurar que `OP_HEAP_RESERVAR` / `OP_HEAP_LIBERAR` estén implementados y estables (sin debug fprintf en producción). | P1 | [x] |
| C.5 | Documentar que **reservar** devuelve “handle” (entero/puntero) y que **liberar** recibe ese valor; uso de memoria no inicializada es responsabilidad del programa. | P2 | [x] |

---

## D. Drivers (acceso bajo nivel / kernel-style)

| # | Tarea | Prioridad | Estado |
|---|--------|-----------|--------|
| D.1 | Definir **tipo puntero** (ej. `puntero a entero` o `ptr entero`) y tamaño 8 bytes; representación como dirección en VM. | P1 (si hay objetivo drivers) | [ ] |
| D.2 | Añadir **conversión entero ↔ puntero** (ej. `como_puntero(entero)` / `como_entero(puntero)`) para direcciones MMIO. | P1 | [ ] |
| D.3 | **LEER/ESCRIBIR** por “dirección” que pueda ser memoria VM o (en target futuro) MMIO; documentar semántica. | P1 | [ ] |
| D.4 | Primitivas de **lectura/escritura de dispositivo**: ej. `leer_u8(addr)`, `escribir_u8(addr, v)`, `leer_u32`/`escribir_u32` (o equivalentes inb/outb si es port-mapped). | P1 | [ ] |
| D.5 | Opcional: **target “kernel” o “bare-metal”** (flag de compilación) que deshabilite features no seguros y permita sección/código específico. | P2 | [ ] |
| D.6 | Opcional: **inline asm** (bloque que se copia a salida asm del backend) para arquitectura x86/ARM; solo si se justifica para drivers. | P3 | [ ] |
| D.7 | Opcional: **atómicos** (compare-and-swap, load/store atómico) como opcodes o llamadas; necesario para lock-free en drivers. | P3 | [ ] |

---

## E. Calidad y estabilidad general (jbc + VM)

**Tests:** FFI: `tests/test_ffi.jasb` + `run_test_ffi.bat`. Math 3D: `tests/test_math3d_trig.jasb`, `test_math3d_exp_log.jasb`, `test_math3d_mat4.jasb`, `test_math3d_mat3.jasb`; ejecutar todos con `tests/run_test_math3d.bat`.

| # | Tarea | Prioridad | Estado |
|---|--------|-----------|--------|
| E.1 | **Tests de regresión** para reservar/liberar, vec* y (cuando existan) sin/cos/atan2 y mat4. | P1 | [x] |
| E.2 | **Tests de FFI** (cargar DLL y llamar a una función C simple) cuando FFI esté implementado. | P1 | [x] |
| E.3 | Documentar **límites** del IR/VM (tamaño de pila, heap máximo, número de argumentos en FFI). | P2 | [ ] |
| E.4 | Un **ejemplo mínimo** “hola OpenGL” (ventana + clear) usando FFI a una lib C gráfica. | P2 | [ ] |

---

## Resumen por prioridad

- **P1 (crítico):** A.1–A.4, A.6, B.1–B.3, B.5–B.7, C.1–C.4, E.1–E.2; y si drivers: D.1–D.4.
- **P2 (importante):** A.5, B.8, C.5, D.5, E.3–E.4.
- **P3 (deseable):** B.4, B.9, D.6–D.7.

Orden sugerido para **motor 3D primero**: C (heap) → B (math 3D) → A (FFI) → E (tests y doc).  
Para **drivers primero**: D (punteros y MMIO) → C → E.

---

*Actualizado a partir de `CAPACIDADES_DRIVERS_Y_3D.md`.*
