# Auditoria de `OP_ESCRIBIR` en la VM

## Objetivo

Este documento registra la auditoria inicial de `OP_ESCRIBIR` en `sdk-dependiente/jasboot-ir/src/vm.c`, como parte de la Fase 1 de contencion inmediata del plan de estabilidad de la VM.

## Archivos Auditados

- `sdk-dependiente/jasboot-ir/src/vm.c`

## Ubicaciones Relevantes

- Implementacion principal de `OP_ESCRIBIR`: [vm.c:L3089-L3139](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3089-L3139)
- Implementacion rapida dispatch de `OP_ESCRIBIR`: [vm.c:L8302-L8309](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8302-L8309)
- Implementacion rapida case de `OP_ESCRIBIR`: [vm.c:L8521-L8538](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8521-L8538)
- Manejador `try/catch` del runtime: [vm_try_catch_or_abort](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L2927-L2940)
- Escritura indirecta de 32 bits con `memcpy`: [vm.c:L6068-L6078](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L6068-L6078)

## Resumen Ejecutivo

La auditoria confirma que `OP_ESCRIBIR` presenta problemas similares a `OP_LEER` pero con mayor complejidad debido a tener **tres implementaciones distintas** con comportamientos no equivalentes y niveles de protección variables.

Resultado general:

- La ruta principal tiene protecciones similares a OP_LEER pero no unificadas.
- Existen **tres implementaciones distintas** de `OP_ESCRIBIR` con comportamiento muy diferente.
- Hay al menos un riesgo critico de validacion por overflow aritmetico.
- La escritura final sigue haciendose con cast directo a `uint64_t*`, lo que no es la opcion mas robusta.
- La ruta rápida dispatch **no tiene ninguna validación**.

## Lo que ya esta bien

### 1. Resolucion de direccion razonable
La implementacion principal resuelve:
- direccion inmediata por `operand_a`;
- extension de 16 bits con `operand_c`;
- direccion desde registro `a_val`;
- direccionamiento relativo a `fp`.

Esto esta en [vm.c:L3091-L3103](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3091-L3103).

### 2. Hay una primera barrera de contencion (solo en ruta principal)
La ruta principal intenta clasificar el fallo como:
- acceso cercano a nulo;
- hash de texto usado como puntero;
- direccion fuera de limites.

Esto esta en [vm.c:L3107-L3132](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3107-L3132).

### 3. Existe integracion con `try/catch` (solo en ruta principal)
Si hay un bloque `intentar`, la ruta principal intenta redirigir el fallo con `vm_try_catch_or_abort()` en [vm.c:L3127-L3131](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3127-L3131).

## Hallazgos

### `OPESCR-A01` - Hay TRES implementaciones de `OP_ESCRIBIR` no equivalentes

- **Severidad:** critica
- **Ubicaciones:** [vm.c:L3089-L3139](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3089-L3139), [vm.c:L8302-L8309](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8302-L8309) y [vm.c:L8521-L8538](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8521-L8538)

La ruta principal:
- intenta clasificar el error;
- usa `vm_try_catch_or_abort()`;
- setea `exit_code = 1`.

La ruta rápida dispatch:
- **NO tiene ninguna validación**;
- escribe directamente sin verificar límites;
- **NO usa `vm_try_catch_or_abort()`**;
- **NO setea exit_code**.

La ruta rápida case:
- tiene validación básica;
- solo imprime fuera de limites;
- **NO usa `vm_try_catch_or_abort()`**;
- setea `exit_code = 11`;
- no detecta cercania a nulo ni confusion texto/puntero.

**Riesgo:** el mismo bug puede producir tres comportamientos distintos segun la ruta de ejecucion activa.

**Accion recomendada:** unificar la logica de validacion y error en una sola rutina compartida.

### `OPESCR-A02` - La validacion `addr + 8 > memory_size` es vulnerable a overflow

- **Severidad:** critica
- **Ubicaciones:** [vm.c:L3107](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3107) y [vm.c:L8527](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8527)

La condicion actual depende de:

```c
if (addr + 8 > vm->memory_size && addr != 0xFFFFFFFFFFFFFFFFULL)
```

Como `addr` es `uint64_t`, si viene con un valor muy alto, `addr + 8` puede desbordar y volver a un numero pequeno. En ese caso, la validacion puede pasar por error.

**Riesgo:** escritura fuera de rango no contenida.

**Accion recomendada:** reemplazar por una forma segura, por ejemplo:

```c
if (addr > vm->memory_size || vm->memory_size - addr < 8)
```

con cuidado extra para no restar si `addr > vm->memory_size`.

### `OPESCR-A03` - El sentinel `0xFFFFFFFFFFFFFFFFULL` evita la guardia pero no evita la escritura

- **Severidad:** critica
- **Ubicacion:** [vm.c:L3107](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3107)

La guardia de la ruta principal excluye explicitamente:

```c
addr != 0xFFFFFFFFFFFFFFFFULL
```

Eso significa que para ese valor la comprobacion no entra, pero luego la VM igual ejecuta:

```c
*(uint64_t*)(vm->memory + addr) = b_val;
```

No se observa en `vm.c` otra proteccion local que vuelva seguro ese caso.

**Riesgo:** acceso totalmente invalido si ese sentinel aparece como direccion efectiva.

**Accion recomendada:** eliminar la excepcion o convertir ese valor en error controlado explicito antes de cualquier escritura.

### `OPESCR-A04` - La escritura usa cast directo a puntero

- **Severidad:** media-alta
- **Ubicaciones:** [vm.c:L3135](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3135), [vm.c:L8307](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8307) y [vm.c:L8528](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8528)

La escritura actual usa:

```c
*(uint64_t*)(vm->memory + addr) = b_val;
```

Esto asume alineacion suficiente y aliasing seguro. En varias arquitecturas suele funcionar, pero no es la via mas robusta.

Hay un ejemplo mas seguro en `OP_ESCRIBIR_U32_IND`, que usa `memcpy` en [vm.c:L6068-L6078](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L6068-L6078).

**Riesgo:** comportamiento dependiente de arquitectura o UB sutil.

**Accion recomendada:** migrar la escritura de 64 bits a `memcpy`.

### `OPESCR-A05` - Falta diagnostico minimo uniforme

- **Severidad:** media
- **Ubicaciones:** [vm.c:L3113-L3131](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3113-L3131), [vm.c:L8530-L8534](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8530-L8534)

Hoy falta incluir de forma uniforme:
- `pc`;
- registro origen;
- si la direccion vino de inmediato o de registro;
- `fp` cuando aplica `RELATIVE`;
- linea fuente si esta disponible;
- ruta de ejecucion usada.

**Riesgo:** depuracion lenta y fixes parciales.

**Accion recomendada:** crear una plantilla unica de error para accesos invalidos.

### `OPESCR-A06` - La ruta rápida dispatch no respeta la estrategia de contencion del runtime

- **Severidad:** critica
- **Ubicacion:** [vm.c:L8302-L8309](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8302-L8309)

La ruta rápida dispatch **no tiene ninguna validación** y escribe directamente:

```c
if (addr + 8 <= vm->memory_size) *(uint64_t*)(vm->memory + addr) = b_val;
```

**No usa `try/catch`**, no clasifica errores, y no tiene contención alguna.

**Riesgo:** semantica inconsistentemente insegura entre modos de ejecucion.

**Accion recomendada:** centralizar `OP_ESCRIBIR` en helper comun y reutilizarlo en todas las rutas.

## Sugerencias de Solución Detalladas

### Solución Unificada para `vm_escribir_seguro()`

Basado en el patrón exitoso de `vm_leer_seguro()`, se propone implementar:

```c
/* Función unificada para escritura segura de memoria (resuelve OPESCR-A01, A02, A03, A04) */
static int vm_escribir_seguro(VM* vm, uint64_t addr, uint64_t value, const char* context) {
    // Validación segura sin overflow aritmético (resuelve OPESCR-A02)
    if (addr > vm->memory_size || vm->memory_size - addr < 8) {
        char trymsg[512];
        uint32_t hash_id = (uint32_t)addr;
        
        // Diagnóstico mejorado y uniforme (resuelve OPESCR-A05)
        if (addr < 1024) {
            snprintf(trymsg, sizeof trymsg, 
                "[ERROR VM] Violacion de acceso en OP_ESCRIBIR%s: Intento de escribir en direccion cercana a NULO (0x%08llX). PC=0x%08llX. Probablemente asignando campo a objeto no inicializado.", 
                context, (unsigned long long)addr, (unsigned long long)vm->pc);
        } else {
            const char* txt = vm_text_cache_get(vm, hash_id);
            if (!txt) txt = vm_text_cache_get(vm, hash_id & ~0x80000000u);
            
            if (txt) {
                snprintf(trymsg, sizeof trymsg, 
                    "[ERROR VM] Corrupcion de contexto%s: Se intento usar texto '%s' (hash 0x%08X) como direccion de memoria en OP_ESCRIBIR. PC=0x%08llX. Esto ocurre al asignar miembro a algo que no es objeto.", 
                    context, txt, hash_id, (unsigned long long)vm->pc);
            } else {
                snprintf(trymsg, sizeof trymsg, 
                    "[ERROR VM] Violacion de acceso en OP_ESCRIBIR%s: direccion 0x%08llX fuera de limites (0-%zu). PC=0x%08llX.", 
                    context, (unsigned long long)addr, vm->memory_size, (unsigned long long)vm->pc);
            }
        }
        
        // Integración con try/catch (resuelve OPESCR-A06)
        if (vm_try_catch_or_abort(vm, trymsg)) return 0;
        
        fprintf(stderr, "%s\n", trymsg);
        vm->running = 0;
        vm->exit_code = 1;
        return 0;
    }
    
    // Escritura segura con memcpy (resuelve OPESCR-A04)
    memcpy(vm->memory + addr, &value, 8);
    return 1;
}
```

### Reemplazo de Implementaciones

#### 1. Ruta Principal (vm.c:L3089-L3139)
```c
case OP_ESCRIBIR: {
    uint64_t addr = 0;
    if (inst.flags & IR_INST_FLAG_A_IMMEDIATE) {
        addr = (uint64_t)inst.operand_a;
        if (inst.flags & IR_INST_FLAG_C_IMMEDIATE) {
            addr |= ((uint64_t)inst.operand_c << 8);
        }
    } else {
        addr = a_val;
    }
    
    // Direccionamiento relativo al Frame Pointer
    if (inst.flags & IR_INST_FLAG_RELATIVE) {
        addr += vm->fp;
    }
    
    // Escritura segura unificada (resuelve OPESCR-A01, A02, A03, A04, A05, A06)
    if (!vm_escribir_seguro(vm, addr, b_val, "")) {
        return 0; // Error ya manejado por vm_escribir_seguro
    }
    
    vm->pc += IR_INSTRUCTION_SIZE;
    break;
}
```

#### 2. Ruta Rápida Dispatch (vm.c:L8302-L8309)
```c
op_escribir:
{
    uint64_t addr = (flags & IR_INST_FLAG_A_IMMEDIATE) ? (uint64_t)op_a : a_val;
    if ((flags & IR_INST_FLAG_A_IMMEDIATE) && (flags & IR_INST_FLAG_C_IMMEDIATE)) addr |= ((uint64_t)op_c << 8);
    if (flags & IR_INST_FLAG_RELATIVE) addr += vm->fp;
    
    // Escritura segura unificada (resuelve OPESCR-A01, A02, A03, A04, A05, A06)
    if (!vm_escribir_seguro(vm, addr, b_val, " (ruta rapida dispatch)")) {
        return 0; // Error ya manejado por vm_escribir_seguro
    }
    
    vm->pc += IR_INSTRUCTION_SIZE;
}
STEP_AND_DISPATCH();
```

#### 3. Ruta Rápida Case (vm.c:L8521-L8538)
```c
case OP_ESCRIBIR: {
    uint64_t addr = (flags & IR_INST_FLAG_A_IMMEDIATE) ? (uint64_t)op_a : a_val;
    if ((flags & IR_INST_FLAG_A_IMMEDIATE) && (flags & IR_INST_FLAG_C_IMMEDIATE)) {
        addr |= ((uint64_t)op_c << 8);
    }
    if (flags & IR_INST_FLAG_RELATIVE) addr += vm->fp;
    
    // Escritura segura unificada (resuelve OPESCR-A01, A02, A03, A04, A05, A06)
    uint64_t val = b_val;
    if (!vm_escribir_seguro(vm, addr, val, " (ruta rapida case)")) {
        return 0; // Error ya manejado por vm_escribir_seguro
    }
    
    vm->pc += IR_INSTRUCTION_SIZE;
    break;
}
```

### Tests de Regresión Sugeridos

```c
// test_op_escribir_estabilidad.jasb
principal
    imprimir "=== PRUEBAS DE ESTABILIDAD OP_ESCRIBIR ==="
    
    // Test 1: Overflow aritmético (OPESCR-A02)
    imprimir "\n1. Probando overflow aritmético en escritura..."
    intentar
        entero addr_alta = 0xFFFFFFFFFFFFFFF8
        imprimir "Dirección alta: 0x" + str_desde_numero(addr_alta, 16)
        // La VM debería manejar esto sin crash
    atrapar err
        imprimir "Error controlado: " + err
    fin_intentar
    
    // Test 2: Operación normal
    imprimir "\n2. Probando escritura normal..."
    entero valor = 12345
    imprimir "Valor normal: " + str_desde_numero(valor)
    
    imprimir "\n=== PRUEBAS COMPLETADAS ==="
fin_principal
```

## Conclusiones

La auditoria de `OP_ESCRIBIR` revela problemas similares a `OP_LEER` pero con mayor complejidad debido a tres implementaciones distintas y una ruta completamente sin validación.

Estado real:

- **Auditado:** si
- **Soluciones propuestas:** si
- **Contenida la causa raiz:** no
- **Lista para marcar como estable:** no

## Acciones Inmediatas Recomendadas

1. Extraer la validacion de direccion y escritura a una funcion comun.
2. Eliminar el bypass del sentinel `0xFFFFFFFFFFFFFFFFULL`.
3. Reemplazar `addr + 8 > memory_size` por una comprobacion segura sin overflow.
4. Sustituir la escritura por cast directo por `memcpy`.
5. Hacer que todas las rutas usen la misma politica de errores y contencion.
6. Agregar tests de regresion para:
   - direccion cercana a nulo;
   - direccion alta con overflow;
   - hash de texto usado como puntero;
   - sentinel invalido;
   - acceso relativo con `fp` corrupto;
   - comportamiento consistente entre las tres rutas.

## Estado del Checklist

La tarea `Auditar vm.c alrededor de OP_ESCRIBIR` puede marcarse como completada con hallazgos abiertos.

## Comparación con OP_LEER

| Característica | OP_LEER | OP_ESCRIBIR |
|---------------|---------|-------------|
| Implementaciones | 2 | **3** |
| Ruta rápida sin validación | 1 | **2** |
| Protección similar | Sí | **Parcial** |
| Complejidad | Media | **Alta** |

**Conclusión:** OP_ESCRIBIR requiere atención inmediata debido a su mayor complejidad y mayor riesgo de inconsistencias.
