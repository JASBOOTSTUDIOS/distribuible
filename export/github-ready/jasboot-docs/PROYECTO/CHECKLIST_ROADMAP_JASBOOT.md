# Checklist Roadmap Jasboot — Norte claro

Documento maestro de prioridades históricas. **En el árbol actual solo se mantiene el compilador estable `jbc`** (`sdk-dependiente/jas-compiler-c`). Las fases A–C sobre un compilador escrito en `.jasb` quedan como **meta de self-hosting a futuro**, no como segunda implementación en este repositorio.

---

## Visión general

| Fase | Objetivo | Estado |
|------|----------|--------|
| **Fase A** | Compilador en `.jasb` (self-hosting) | ⏸️ Fuera del árbol / no prioritaria |
| **Fase B** | Lenguaje completo (parser, variables, funciones) | ⏸️ Pendiente |
| **Fase C** | Self-hosting (autocompilación) | ⏸️ Pendiente |
| **Fase D** | Bajo nivel (bitwise, I/O binario, sistema) | ⏸️ Pendiente |
| **Fase E** | Kernel y controladores (bare metal, puertos) | ⏸️ Futuro |

---

## Fase A: Compilador en `.jasb` (referencia histórica)

*Pensado como base para self-hosting en la VM; **no** sustituye a `jbc` en el día a día del repo.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| A.1 | Corregir truncado primera letra | Bug en `cg_agregar_string` o `extraer_subtexto`: "Hola" → "ola" | ❌ |
| A.2 | Estabilizar scanner | Normalización CRLF/BOM ya aplicada; validar edge cases | ✅ |
| A.3 | Integrar parser en main | Usar parser como primario, scanner como fallback | ⏸️ |
| A.4 | Mensajes de error útiles | Línea y columna en errores de sintaxis | ❌ |

---

## Fase B: Lenguaje completo

*Expresividad necesaria para programas reales y para el propio compilador.*

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| B.1 | Variables locales | `OP_RESERVAR_PILA`, `OP_LEER`, `OP_ESCRIBIR` para entero, texto, flotante | A.3 | ❌ |
| B.2 | Asignaciones | Codegen para `x = expr` | B.1 | ❌ |
| B.3 | Expresiones aritméticas | `+`, `-`, `*`, `/`, `%` con variables | B.1 | ❌ |
| B.4 | Comparaciones | `==`, `!=`, `<`, `>`, `<=`, `>=` | B.1 | ❌ |
| B.5 | Condicionales | `si/cuando` con `OP_SI`, saltos correctos | B.4 | ❌ |
| B.6 | Bucles | `mientras` con `romper`/`continuar` | B.5 | ❌ |
| B.7 | Funciones | `OP_LLAMAR`, `OP_RETORNAR`, convención de llamada | B.1 | ❌ |
| B.8 | Parámetros y retorno | Slots de pila para args, valor de retorno | B.7 | ❌ |
| B.9 | Operadores bitwise en lenguaje | `&`, `\|`, `^`, `<<`, `>>` en jasb → opcodes existentes | B.1 | ❌ |
| B.10 | Estructuras/registros | Tipo `struct` o `registro` para datos anidados | B.7 | ❌ |

---

## Fase C: Self-hosting

*El compilador se compilaría a sí mismo usando solo la VM (`jbc` solo como bootstrap inicial).*

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| C.1 | Mapas en VM | Tabla de símbolos estable (`mapa_crear`, `mapa_poner`, `mapa_obtener`) | B.1 | ⚠️ |
| C.2 | `__sistema_ejecutar` | Llamar NASM/GCC u otras herramientas desde jasb | B.7 | ❌ |
| C.3 | I/O binario | `fs_abrir` modo binario, `fs_escribir_byte`, `fs_leer_byte` | — | ⚠️ Parcial |
| C.4 | Lexer en jasb | Tokenización completa de `.jasb` en el compilador soberano | B.1–B.6 | ❌ |
| C.5 | Parser en jasb | Construcción de AST desde tokens | C.4, B.10 | ❌ |
| C.6 | Codegen en jasb | Emisión de IR desde AST | C.5, C.1 | ❌ |
| C.7 | Autocompilación | `main.jasb` compila `main.jasb` produciendo `main.jbo` | C.4–C.6 | ❌ |

---

## Fase D: Bajo nivel (producción y generación de código)

*Capacidades para generar binarios, herramientas y programas de sistema.*

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| D.1 | Backend código máquina | Emisión directa a x86-64 (sustituir NASM a largo plazo) | B.9 | ⚠️ Parcial |
| D.2 | Enlace de módulos IR | Importar/enlazar varios `.jbo` con tabla de símbolos | C.1 | ❌ |
| D.3 | Validación IR (JASB-SEC) | CFG, análisis estático, saltos ilegales | B.7 | ❌ |
| D.4 | Depuración | Step-by-step, inspección de registros, profiling | — | ❌ |

---

## Fase E: Kernel y controladores

*Requisitos para bare metal y acceso a hardware. Solo tras Fases A–D.*

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| E.1 | Puertos I/O | Opcodes `OP_IN_PUERTO`, `OP_OUT_PUERTO` (x86: in/out) | D.1 | ❌ |
| E.2 | Acceso a memoria física | `OP_LEER_FISICA`, `OP_ESCRIBIR_FISICA` en direcciones concretas | D.1 | ❌ |
| E.3 | Runtime bare metal | Bootloader + kernel sin libc, heap propio | E.1, E.2 | ❌ |
| E.4 | Memory-mapped I/O | Acceso a rangos de direcciones (PCI BAR, framebuffer) | E.2 | ❌ |
| E.5 | Manejo de interrupciones | IRQ, IDT, callbacks desde hardware | E.3 | ❌ |
| E.6 | Operaciones atómicas | Test-and-set, compare-and-swap para concurrencia | D.1 | ❌ |
| E.7 | DMA (opcional) | Soporte para transferencias DMA | E.4 | ❌ |

---

## Resumen de prioridades inmediatas

**Próximos pasos sugeridos (orden):**

1. **A.1** — Corregir truncado de primera letra (bloquea salida correcta).
2. **A.3** — Integrar parser en main (base para lenguaje completo).
3. **B.1** — Variables locales (prerequisito de casi todo).
4. **B.9** — Operadores bitwise en lenguaje (ya existen opcodes).
5. **C.1** — Mapas estables en VM (tabla de símbolos).
6. **C.2** — `__sistema_ejecutar` (automatizar builds).

---

## Leyenda de estados

| Símbolo | Significado |
|---------|-------------|
| ✅ | Hecho / estable |
| 🔄 | En curso |
| ⚠️ | Parcial o con problemas conocidos |
| ⏸️ | Bloqueado o pausado |
| ❌ | Pendiente |

---

## Referencias

- `docs/PROYECTO/ESTADO_PROYECTO_ACTUAL.md` — Estado del proyecto tras limpieza.
- `docs/TECNICO/SDK/CHECKLIST_COMPILADOR_C.md` — Compilador estable **jbc**.
- `sdk-dependiente/jasboot-ir/FALTANTE.md` — Análisis de lo que falta al IR.
- `docs/PROYECTO/INDEPENDENCIA_HOST_V1.0.md` — Capa de abstracción del host.

---

**Última actualización:** 2026-03-25
