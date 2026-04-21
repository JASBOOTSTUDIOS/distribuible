# Contrato de runtime (Nivel 1.1)

Documento que cumple el checklist 1.1: operaciones sobre conceptos (crear/leer/actualizar/olvidar) y tipos de error que puede devolver el runtime. Referencia: `CHECKLIST_PRODUCCION_E_IA.md`, `MODELO_SEMANTICO_V1.0.md`.

---

## 1. Operaciones sobre conceptos: crear, leer, actualizar, olvidar

Todas las operaciones below actúan sobre la **memoria neuronal** asociada al proceso (p. ej. abierta con `crear_memoria` o implícita). Un **concepto** se identifica por nombre (cadena) o por su ID interno (hash).

### 1.1 Crear concepto

| Construcción en lenguaje | Semántica | Comportamiento si ya existe |
|--------------------------|-----------|-----------------------------|
| `recordar "nombre" con valor expresión` | Crea el concepto `"nombre"` con el valor de la expresión (o asocia nombre↔valor en el grafo). | **Actualizar**: se trata como actualización (mismo efecto que actualizar). |
| `aprender "nombre" con valor expresión` | Igual que `recordar` en v1.0: crea o refuerza el concepto con un peso. | Refuerza/actualiza el concepto existente. |

**Nota**: En la implementación actual, `recordar` puede traducirse a asociación entre conceptos (key↔value) o a registro con peso; la memoria neuronal unifica creación y actualización por nombre/ID.

### 1.2 Leer concepto

| Construcción | Semántica | Comportamiento si no existe |
|--------------|-----------|-----------------------------|
| `buscar "nombre"` | Lee el concepto `"nombre"` y escribe su valor (o ID) en `resultado`. | **Definido por el runtime**: puede devolver 0, un valor por defecto, o provocar error. En el catálogo de errores (Nivel 1.5) se fijará mensaje y código. |

### 1.3 Actualizar concepto

| Construcción | Semántica |
|--------------|-----------|
| `recordar "nombre" con valor expresión` | Si el concepto existe, actualiza su valor (o la fuerza del enlace); si no existe, lo crea. |
| `aprender "nombre" con valor expresión` | Refuerza o actualiza el peso del concepto; si no existe, lo crea. |

No hay operación separada “solo actualizar si existe”: crear y actualizar son la misma operación desde el punto de vista del contrato.

### 1.4 Olvidar (debilitar) concepto

| Construcción | Semántica |
|--------------|-----------|
| `olvidar expresión` | Reduce el peso o la presencia del concepto cuyo ID es el valor de la expresión. En la implementación actual se usa una operación de penalización sobre el grafo neuronal; no se garantiza borrado físico inmediato. |

**Nota**: “Olvidar” se documenta como debilitar/penalizar; el borrado total (si se ofrece) será parte del contrato en versiones que lo definan.

### 1.5 Resumen operativo

| Operación   | Lenguaje              | Efecto principal                          |
|------------|------------------------|-------------------------------------------|
| Crear      | `recordar` / `aprender` | Crea concepto o refuerza si ya existe.   |
| Leer       | `buscar`               | Valor/ID del concepto → `resultado`.      |
| Actualizar | `recordar` / `aprender` | Mismo que crear (idempotente por nombre). |
| Olvidar    | `olvidar`              | Debilita/penaliza el concepto por ID.     |

---

## 2. Tipos de error que puede devolver el runtime

El runtime (VM y memoria neuronal) puede dejar de ejecutar el programa y/o escribir en stderr en los siguientes casos. Los mensajes concretos y códigos de salida se irán unificando en el **catálogo de errores del lenguaje** (Nivel 1.5).

### 2.1 Errores de ejecución (VM)

| Tipo de error | Descripción breve | Comportamiento típico actual |
|---------------|-------------------|------------------------------|
| **Stack overflow** | Recursión o profundidad de llamadas supera el límite. | Mensaje en stderr (`[VM ERR] Stack Overflow`), VM deja de ejecutar. |
| **Memory stack exhausted** | Pila de memoria (RESERVAR_PILA) agotada. | Mensaje en stderr, VM deja de ejecutar. |
| **Memoria no se pudo crear/cargar** | Fallo al abrir/crear la memoria neuronal (p. ej. `crear_memoria`). | Mensaje en stderr (`Error: No se pudo crear/cargar memoria '...'`). |
| **Error de validación IR** | El binario IR no pasa la validación (magic, saltos, tamaños, etc.). | Mensaje en stderr (`Error de validación: ...`), no se inicia la ejecución. |
| **Opcode desconocido** | Instrucción con opcode no implementado. | Mensaje en stderr (`ERR: Opcode desconocido 0x...`), VM puede detenerse. |
| **Límite de pasos excedido** | Se supera el número máximo de pasos de ejecución (anti-bucle). | Mensaje en stderr, VM deja de ejecutar. |
| **Hot-Reload fallido** | Fallo al recargar el binario en caliente (si aplica). | Mensaje en stderr (`[VM ERR] Falló Hot-Reload ...`). |

### 2.2 Errores semánticos del lenguaje (a formalizar en Nivel 1.5)

Estos tipos de error son los que el **lenguaje** debe reportar de forma clara y en español; el runtime actual puede aún no distinguirlos con mensajes propios:

| Tipo de error | Descripción |
|---------------|-------------|
| **Concepto inexistente** | Se hace `buscar "nombre"` y el concepto no existe (o no tiene valor accesible). |
| **Tipo incompatible** | Operación o comparación entre tipos no permitidos (p. ej. número vs texto sin conversión). |
| **Pensamiento inválido** | Expresión en `pensar` que no puede evaluarse o no tiene valor usable. |
| **Acceso inválido** | Índice fuera de rango, mapa sin clave, etc. |

En Nivel 1.5 se definirá un **catálogo centralizado** con códigos, mensajes y (donde aplique) código de salida del proceso.

### 2.3 Código de salida y `running`

- La VM mantiene `running` (en ejecución o no) y `exit_code` (código de salida cuando termina).
- `OP_HALT` y ciertos opcodes de salida pueden fijar `exit_code`; los errores anteriores suelen dejar la VM con `running = 0`; el valor de `exit_code` en caso de error depende de la implementación hasta que el catálogo lo fije.

---

**Referencia**: `CHECKLIST_PRODUCCION_E_IA.md` Nivel 1.1, `docs/MODELO_SEMANTICO_V1.0.md`.  
**Última actualización**: 2026-02-18
