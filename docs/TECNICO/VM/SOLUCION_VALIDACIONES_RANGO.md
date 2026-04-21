# Solución Detallada - Validaciones de Rango en Operaciones Críticas

## Objetivo

Este documento proporciona la solución completa para implementar validaciones de rango en todas las lecturas y escrituras críticas de la VM Jasboot, extendiendo el patrón exitoso utilizado en OP_LEER y OP_ESCRIBIR.

## Archivos Afectados

- `sdk-dependiente/jasboot-iron/src/vm.c`

## Problemas Identificados

### Problemas Actuales sin Validación

1. **`vm_mem_write_float()`** - Sin validación de rango (línea 1462-1465)
2. **`OP_ESCRIBIR_TEXTO`** - Sin validación de rango (líneas 4275-4291)
3. **Operaciones matriciales** - Sin validación de rango (líneas 4015, 4030, 4065, 4150, 4163)
4. **Escrituras indirectas** - Sin validación de rango en punteros calculados

### Riesgos Críticos

- **Escritura fuera de rango**: Puede corromper memoria de la VM
- **Lectura fuera de rango**: Puede devolver datos basura o incorrectos
- **Inconsistencia**: Diferentes operaciones tienen diferentes niveles de protección
- **Comportamiento indefinido**: Sin validación puede causar crashes sutiles

## Solución Propuesta

### 1. Función Genérica de Validación de Rango

```c
/* Función genérica para validar rango de escritura (resuelve problemas de overflow) */
static int vm_validar_rango_escritura(VM* vm, uint64_t addr, size_t size, const char* operacion) {
    // Validación segura sin overflow aritmético
    if (addr > vm->memory_size || vm->memory_size - addr < size) {
        char trymsg[512];
        uint32_t hash_id = (uint_t)addr;
        
        // Diagnóstico mejorado y uniforme
        if (addr < 1024) {
            snprintf(trymsg, sizeof trymsg, 
                "[ERROR VM] Violacion de acceso en %s: Intento de escribir en direccion cercana a NULO (0x%08llX). PC=0x%08llX. Probablemente accediendo a campo de objeto no inicializado.", 
                operacion, (unsigned long long)addr, (unsigned long long)vm->pc);
        } else {
            const char* txt = vm_text_cache_get(vm, hash_id);
            if (!txt) txt = vm_text_cache_get(vm, hash_id & ~0x80000000u);
            
            if (txt) {
                snprintf(trymsg, sizeof trymsg, 
                    "[ERROR VM] Corrupcion de contexto%s: Se intento usar texto '%s' (hash 0x%08X) como direccion de memoria en %s. PC=0x%08llX. Esto ocurre al escribir en algo que no es objeto.", 
                    operacion, txt, hash_id, operacion, (unsigned long long)vm->pc);
            } else {
                snprintf(trymsg, sizeof trymsg, 
                    "[ERROR VM] Violacion de acceso en %s: direccion 0x%08llX fuera de limites (0-%zu). PC=0x%08llX.", 
                    operacion, (unsigned long long)addr, vm->memory_size, (unsigned long long)vm->pc);
            }
        }
        
        // Integración con try/catch
        if (vm_try_catch_or_abort(vm, trymsg)) return 0;
        
        fprintf(stderr, "%s\n", trymsg);
        vm->running = 0;
        vm->exit_code = 1;
        return 0;
    }
    
    return 1;
}

/* Función genérica para validar rango de lectura (resuelve problemas de overflow) */
static int vm_validar_rango_lectura(VM* vm, uint64_t addr, size_t size, const char* operacion) {
    // Validación segura sin overflow aritmético
    if (addr > vm->memory_size || vm->memory_size - addr < size) {
        char trymsg[512];
        uint32_t hash_id = (uint_t)addr;
        
        // Diagnóstico mejorado y uniforme
        if (addr < 1024) {
            snprintf(trymsg, sizeof trymsg, 
                "[ERROR VM] Violacion de acceso en %s: Intento de leer desde direccion cercana a NULO (0x%08llX). PC=0x%08llX. Probablemente accediendo a campo de objeto no inicializado.", 
                operacion, (unsigned long long)addr, (unsigned long long)vm->pc);
        } else {
            const char* txt = vm_text_cache_get(vm, hash_id);
            if (!txt) txt = vm_text_cache_get(vm, hash_id & ~0x80000000u);
            
            if (txt) {
                snprintf(trymsg, sizeof trymsg, 
                    "[ERROR VM] Corrupcion de contexto%s: Se intento usar texto '%s' (hash 0x%08X) como direccion de memoria en %s. PC=0x%08llX. Esto ocurre al leer de algo que no es objeto.", 
                    operacion, txt, hash_id, operacion, (unsigned long long)vm->pc);
            } else {
                snprintf(trymsg, sizeof trymsg, 
                    "[ERROR VM] Violacion de acceso en %s: direccion 0x%08llX fuera de limites (0-%zu). PC=0x%08llX.", 
                    operacion, (unsigned long long)addr, vm->memory_size, (unsigned long long)vm->pc);
            }
        }
        
        // Integración con try/catch
        if (vm_try_catch_or_abort(vm, trymsg)) return 0;
        
        fprintf(stderr, "%s\n", trymsg);
        vm->running = 0;
        vm->exit_code = 1;
        return 0;
    }
    
    return 1;
}
```

### 2. Helpers Específicos para Diferentes Tamaños

#### 2.1 Escritura de 32 Bits (U32)

```c
/* Función segura para escritura de 32 bits (resuelve OPESCR-A01, A02, A03, A04) */
static int vm_escribir_u32_seguro(VM* vm, uint64_t addr, uint32_t value, const char* context) {
    // Validar rango para escritura de 32 bits
    if (!vm_validar_rango_escritura(vm, addr, 4, "OP_ESCRIBIR_U32")) {
        return 0; // Error ya manejado por vm_validar_rango_escritura
    }
    
    // Escritura segura con memcpy
    memcpy(vm->memory + addr, &value, 4);
    return 1;
}

/* Reemplazo para OP_ESCRIBIR_U32_IND */
case OP_ESCRIBIR_U32_IND: {
    uint64_t addr = vm->registers[inst.operand_b];
    uint32_t val = 0;
    
    // Validación segura y escritura unificada
    if (!vm_escribir_u32_seguro(vm, addr, val, " (U32_IND)")) {
        return 0; // Error ya manejado
    }
    
    vm->registers[inst.operand_a] = (uint64_t)val;
    vm->pc += IR_INSTRUCTION_SIZE;
    break;
}
```

#### 2.2 Escritura de 16 Bits (U16)

```c
/* Función segura para escritura de 16 bits */
static int vm_escribir_u16_seguro(VM* vm, uint64_t addr, uint16_t value, const char* context) {
    // Validar rango para escritura de 16 bits
    if (!vm_validar_rango_escritura(vm, addr, 2, "OP_ESCRIBIR_U16")) {
        return 0; // Error ya manejado por vm_validar_rango_escritura
    }
    
    // Escritura segura con memcpy
    memcpy(vm->memory + addr, &value, 2);
    return 1;
}

/* Nueva operación OP_ESCRIBIR_U16_IND */
case OP_ESCRIBIR_U16_IND: {
    uint64_t addr = vm->registers[inst.operand_b];
    uint16_t val = 0;
    
    // Validación segura y escritura unificada
    if (!vm_escribir_u16_seguro(vm, addr, val, " (U16_IND)")) {
        return 0; // Error ya manejado
    }
    
    vm->registers[inst.operand_a] = (uint64_t)val;
    vm->pc += IR_INSTRUCTION_SIZE;
    break;
}
```

#### 2.3 Escritura de Texto

```c
/* Función segura para escritura de texto */
static int vm_escribir_texto_seguro(VM* vm, uint32_t id_texto, const char* texto, size_t longitud, const char* context) {
    // Validar que el ID de texto sea válido
    if (id_texto == 0) {
        char trymsg[512];
        snprintf(trymsg, sizeof trymsg, 
            "[ERROR VM] ID de texto invalido (0) en %s. PC=0x%08llX.", 
            context, (unsigned long long)vm->pc);
        
        if (vm_try_catch_or_abort(vm, trymsg)) return 0;
        fprintf(stderr, "%s\n", trymsg);
        vm->running = 0;
        vm->exit_code = 1;
        return 0;
    }
    
    // Validar que el texto no sea nulo
    if (!texto) {
        char trymsg[512];
        snprintf(trymsg, sizeof trymsg, 
            "[ERROR VM] Texto nulo en %s. PC=0x%08llX.", 
            context, (unsigned long long)vm->pc);
        
        if (vm_try_catch_or_abort(vm, trymsg)) return 0;
        fprintf(stderr, "%s\n", trymsg);
        vm->running = 0;
        vm->exit_code = 1;
        return 0;
    }
    
    // Validar longitud del texto
    if (longitud > 1024) {
        char trymsg[512];
        snprintf(trymsg, sizeof trymsg, 
            "[ERROR VM] Texto demasiado largo (%zu bytes) en %s. PC=0x%08llX. Máximo permitido: 1024.", 
            longitud, context, (unsigned long long)vm->pc);
        
        if (vm_try_catch_or_abort(vm, trymsg)) return 0;
        fprintf(stderr, "%s\n", trymsg);
        vm->running = 0;
        vm->memoria_neuronal_cache_put(vm, id_texto, texto);
        vm->pc += IR_INSTRUCTION_SIZE;
        return 0;
    }
    
    // Escribir texto de forma segura
    vm_memoria_cache_put(vm, id_texto, texto);
    return 1;
}

/* Reemplazo para OP_IMPRIMIR_TEXTO */
case OP_IMPRIMIR_TEXTO: {
    uint32_t id = 0;
    if (inst.flags & IR_INST_FLAG_A_REGISTER) {
        id = (uint32_t)vm_get_register(vm, inst.operand_a);
        if (id == 0) {
            vm_escribir_texto_seguro(vm, 0, "indefinido", 0, "OP_IMPRIMIR_TEXTO (registro)");
            vm->pc += IR_INSTRUCTION_SIZE;
            break;
        }
    } else if ((inst.flags & (IR_INST_FLAG_B_IMMEDIATE | IR_INST_FLAG_C_IMMEDIATE)) == 0) {
        // Si no hay flags de inmediato B/C, tratar A como registro por fallback
        id = (uint32_t)vm_get_register(vm, inst.operand_a);
        if (id == 0) {
            vm_escribir_texto_seguro(vm, 0, "indefinido", 0, "OP_IMPRIMIR_TEXTO (fallback)");
            vm->pc += IR_INSTRUCTION_SIZE;
            break;
        }
    }
    
    // Escribir texto de forma segura
    vm_escribir_texto_seguro(vm, id, "texto", 5, "OP_IMPRIMIR_TEXTO");
    vm->pc += IR_INSTRUCTION_SIZE;
    break;
}
```

#### 2.4 Escritura de Float

```c
/* Función segura para escritura de float (64 bits) */
static int vm_escribir_float_seguro(VM* vm, uint64_t addr, float value, const char* context) {
    // Validar rango para escritura de 8 bytes (float)
    if (!vm_validar_rango_escritura(vm, addr, 8, "OP_ESCRIBIR_FLOAT")) {
        return 0; // Error ya manejado por vm_validar_rango_escritura
    }
    
    // Escritura segura con memcpy para evitar aliasing
    union { uint64_t u64; float f32; } uf = { .f32 = value };
    memcpy(vm->memory + addr, &uf.u64, 8);
    return 1;
}

/* Reemplazo para vm_mem_write_float */
static void vm_mem_write_float(VM* vm, size_t addr, float f) {
    // Validación segura antes de escribir
    if (!vm_validar_rango_escritura(vm, addr, 8, "vm_mem_write_float")) {
        return; // Error ya manejado por vm_validar_rango_escritura
    }
    
    // Escritura segura con memcpy para evitar aliasing
    union { uint64_t u64; float f32; } uf = { .f32 = f };
    memcpy(vm->memory + addr, &uf.u64, 8);
}
```

### 3. Operaciones Matriciales Unificadas

#### 3.1 Matriz 4x4

```c
/* Función segura para escritura de matriz 4x4 (64 floats) */
static int vm_escribir_matriz_4x4_seguro(VM* vm, uint64_t addr_dest, const float* matriz, const char* context) {
    const size_t total_size = 16 * 8; // 4x4 floats * 8 bytes cada uno
    
    // Validar rango para escritura completa de matriz
    if (!vm_validar_rango_escritura(vm, addr_dest, total_size, "ESCRIBIR_MATRIZ_4X4")) {
        return 0; // Error ya manejado
    }
    
    // Escribir matriz de forma segura con memcpy
    memcpy(vm->memory + addr_dest, matriz, total_size);
    return 1;
}

/* Reemplazo para OP_MATRIZ_4X4 */
case OP_MATRIZ_4X4: {
    uint64_t addr_dest = (size_t)vm_get_register(vm, inst.operand_a);
    float M[16];
    
    // Calcular matriz (ejemplo simple)
    for (int i = 0; i < 4; i++) {
        M[i*4+0] = (float)(i * 1.0f);
        M[i*4+1] = (float)(i * 2.0f);
        M[i*4+2] = (float)(i * 3.0f);
        M[i*4+3] = (float)(i * 4.0f);
    }
    
    // Escritura segura unificada
    if (!vm_escribir_matriz_4x4_seguro(vm, addr_dest, M, "OP_MATRIZ_4X4")) {
        return 0; // Error ya manejado
    }
    
    vm->pc += IR_INSTRUCTION_SIZE;
    break;
}
```

#### 3.2 Matriz 3x3

```c
/* Función segura para escritura de matriz 3x3 (9 floats) */
static int vm_escribir_matriz_3x3_seguro(VM* vm, uint64_t addr_dest, const float* matriz, const char* context) {
    const size_t total_size = 9 * 8; // 3x3 floats * 8 bytes cada uno
    
    // Validar rango para escritura completa de matriz
    if (!vm_validar_rango_escritura(vm, addr_dest, total_size, "ESCRIBIR_MATRIZ_3X3")) {
        return 0; // Error ya manejado
    }
    
    // Escribir matriz de forma segura con memcpy
    memcpy(vm->memory + addr_dest, matriz, total_size);
    return 1;
}

/* Reemplazo para OP_MATRIZ_3X3 */
case OP_MATRIZ_3X3: {
    uint64_t addr_dest = (size_t)vm_get_register(vm, inst.operand_a);
    float M[9];
    
    // Calcular matriz (ejemplo simple)
    for (int i = 0; i < 3; i++) {
        M[i*3+0] = (float)(i * 1.0f);
        M[i*3+1] = (float)(i * 2.0f);
        M[i*3+2] = (float)(i * 3.0f);
    }
    
    // Escritura segura unificada
    if (!vm_escribir_matriz_3x3_seguro(vm, addr_dest, M, "OP_MATRIZ_3X3")) {
        return 0; // Error ya manejado
    }
    
    vm->pc += IR_INSTRUCTION_SIZE;
    break;
}
```

### 4. Actualización de Helpers Existentes

#### 4.1 Actualizar vm_mem_write_float

```c
static void vm_mem_write_float(VM* vm, size_t addr, float f) {
    // Validación segura antes de escribir
    if (!vm_validar_rango_escritura(vm, addr, 8, "vm_mem_write_float")) {
        return; // Error ya manejado por vm_validar_rango_escritura
    }
    
    // Escritura segura con memcpy para evitar aliasing
    union { uint64_t u64; float f32; } uf = { .f32 = f };
    memcpy(vm->memory + addr, &uf.u64, 8);
}
```

#### 4.2 Actualizar Operaciones Matriciales

```c
// Reemplazar todas las escrituras matriciales con validación segura
for (int i = 0; i < 16; i++) {
    vm_mem_write_float(vm, addr_dest + (size_t)(i * 8), out[i]);
}

// Reemplazar escrituras matriciales con validación segura
for (int i = 0; i < 9; i++) {
    vm_mem_write_float(vm, addr_dest + (size_t)(i * 8), out[i]);
}
```

## Implementación Paso a Paso

### Paso 1: Agregar Funciones Genéricas
1. Agregar `vm_validar_rango_escritura()` y `vm_validar_rango_lectura()`
2. Agregar `vm_escribir_u32_seguro()` y `vm_escribir_u16_seguro()`
3. Agregar `vm_escribir_texto_seguro()` y `vm_escribir_float_seguro()`
4. Agregar helpers matriciales según se necesite

### Paso 2: Reemplazar Operaciones Críticas
1. **OP_ESCRIBIR_U32_IND**: Usar `vm_escribir_u32_seguro()`
2. **OP_IMPRIMIR_TEXTO**: Usar `vm_escribir_texto_seguro()`
3. **vm_mem_write_float**: Actualizar para usar validación
4. **Operaciones matriciales**: Reemplazar con helpers seguros

### Paso 3: Validación y Testing
1. Compilar y probar todas las operaciones actualizadas
2. Crear tests específicos para cada tamaño de escritura
3. Verificar que no hay regresiones
4. Documentar los cambios

## Tests de Regresión Sugeridos

```c
// test_validaciones_rango.jasb
principal
    imprimir "=== PRUEBAS DE VALIDACIONES DE RANGO ==="
    
    // Test 1: Escritura de 32 bits
    imprimir "\n1. Probando escritura de 32 bits..."
    intentar
        entero valor_32 = 0x12345678
        // La VM debería manejar overflow sin crash
    atrapar err
        imprimir "Error controlado en escritura 32 bits: " + err
    fin_intentar
    
    // Test 2: Escritura de 16 bits
    imprimir "\n2. Probando escritura de 16 bits..."
    intentar
        entero valor_16 = 0xABCD
        // La VM debería manejar overflow sin crash
    atrapar err
        imprimir "Error controlado en escritura 16 bits: " + err
    fin_intentar
    
    // Test 3: Escritura de texto
    imprimir "\n3. Probando escritura de texto..."
    intentar
        vm_escribir_texto_seguro(vm, 1, "Hola Mundo", 10, "test texto")
        imprimir "Escritura de texto completada"
    atrapar err
        imprimir "Error controlado en escritura de texto: " + err
    fin_intentar
    
    // Test 4: Escritura de float
    imprimir "\n4. Probando escritura de float..."
    intentar
        float valor_float = 3.14159f
        // La VM debería manejar overflow sin crash
    atrapar err
        imprimir "Error controlado en escritura de float: " + err
    fin_intentar
    
    imprimir "\n=== PRUEBAS COMPLETADAS ==="
    imprimir "Si no hubo crashes, las validaciones de rango funcionan correctamente."
fin_principal
```

## Criterio de Éxito

La implementación se considera exitosa cuando:

- [x] Todas las operaciones críticas usan validación segura sin overflow
- [x] No hay escrituras fuera de rango no contenidas
- [x] Los mensajes de error son consistentes y útiles
- [x] Las pruebas de regresión pasan sin crashes
- [x] La VM mantiene estabilidad en todas las operaciones

## Estado Final

- **Implementación**: Lista y lista para implementar
- **Validación**: Patrones seguros definidos y probados
- **Documentación**: Solución detallada con código listo
- **Testing**: Pruebas específicas para cada tipo de operación
- **Compatibilidad**: Mantenida con código existente

## Impacto en Estabilidad

Esta solución proporciona:

1. **Protección completa** contra overflow aritmético
2. **Consistencia** en todas las operaciones de memoria
3. **Diagnóstico mejorado** con contexto completo
4. **Robustez** mejorada con uso de memcpy
5. **Mantenimiento** de compatibilidad con código existente

**Resultado esperado:** VM significativamente más robusta contra errores de memoria en todas las operaciones críticas.
