---
name: "VM Memory Safety Rules"
description: "Critical memory safety rules for Jasboot VM development"
activation: "glob"
glob: "sdk-dependiente/jasboot-ir/**/*.c"
priority: 100
---

# VM Memory Safety Rules

This rule file enforces memory safety practices when working on the Jasboot Virtual Machine.

## Memory Access Validation

### ALWAYS Use Safe Wrappers

Never access VM memory directly. Always use the safe wrapper functions:

```c
// ✅ CORRECT - Safe read
uint64_t value;
if (!vm_leer_seguro(vm, addr, &value, "operation_name")) {
    return 0; // Error already handled
}

// ✅ CORRECT - Safe write
if (!vm_escribir_seguro(vm, addr, value, "operation_name")) {
    return 0; // Error already handled
}

// ❌ WRONG - Direct memory access
uint64_t value = *(uint64_t*)(vm->memory + addr);  // NEVER DO THIS
*(uint64_t*)(vm->memory + addr) = value;           // NEVER DO THIS
```

### Integer Overflow Protection

Always validate ranges using overflow-safe arithmetic:

```c
// ✅ CORRECT - Overflow-safe validation
if (addr > vm->memory_size || vm->memory_size - addr < needed_bytes) {
    // Handle error
}

// ❌ WRONG - Vulnerable to overflow
if (addr + needed_bytes > vm->memory_size) {
    // This can overflow when addr + needed_bytes wraps around!
}
```

### Bounds Checking Pattern

Every memory operation must follow this pattern:

```c
// 1. Validate parameters
if (!vm || !vm->memory) {
    return error_code;
}

// 2. Check bounds (overflow-safe)
if (addr > vm->memory_size || vm->memory_size - addr < size) {
    // Log error with context
    fprintf(stderr, "[ERROR VM] Memory bounds violation: addr=0x%llx, size=%zu, limit=%zu\n",
            (unsigned long long)addr, size, vm->memory_size);
    return error_code;
}

// 3. Perform operation using memcpy (avoid aliasing issues)
memcpy(&value, vm->memory + addr, sizeof(value));
```

## Error Handling

### Always Provide Context

Error messages must include operation context:

```c
// ✅ CORRECT - Descriptive error
char msg[512];
snprintf(msg, sizeof msg, 
    "[ERROR VM] OP_LEER failed at PC=0x%llx: address 0x%llx out of bounds (0-%zu)",
    (unsigned long long)vm->pc, (unsigned long long)addr, vm->memory_size);

// ❌ WRONG - Generic error
fprintf(stderr, "Memory error\n");
```

### Try-Catch Integration

When inside VM execution, integrate with try-catch system:

```c
if (error_condition) {
    char msg[512];
    snprintf(msg, sizeof msg, "[ERROR] Description with context");
    
    // Try to handle via try-catch
    if (vm_try_catch_or_abort(vm, msg)) {
        return 0; // Jump to catch block
    }
    
    // No try-catch active, abort execution
    fprintf(stderr, "%s\n", msg);
    vm->running = 0;
    vm->exit_code = 1;
    return 0;
}
```

## JMN Text Synchronization

### Always Sync Text to JMN

When loading string hashes, ensure text is saved to JMN:

```c
case OP_LOAD_STR_HASH: {
    // Load hash
    uint32_t hash = vm_hash_texto(str);
    vm_text_cache_put(vm, hash, str);
    
    // ✅ CRITICAL - Save to JMN for persistence
    #ifdef JASBOOT_LANG_INTEGRATION
    if (vm->mem_neuronal) {
        jmn_guardar_texto(vm->mem_neuronal, hash, str);
    }
    #endif
    
    vm_set_register(vm, inst.operand_a, (uint64_t)hash);
}
```

### Sync Cache Before Associations

Before creating JMN associations, ensure both texts are in JMN:

```c
case OP_MEM_ASOCIAR_CONCEPTOS: {
    uint32_t id1 = (uint32_t)a_val;
    uint32_t id2 = (uint32_t)b_val;
    
    #ifdef JASBOOT_LANG_INTEGRATION
    if (vm->mem_neuronal) {
        // ✅ CRITICAL - Sync text cache to JMN
        const char* t1 = vm_text_cache_get(vm, id1);
        if (t1 && t1[0]) jmn_guardar_texto(vm->mem_neuronal, id1, t1);
        
        const char* t2 = vm_text_cache_get(vm, id2);
        if (t2 && t2[0]) jmn_guardar_texto(vm->mem_neuronal, id2, t2);
        
        // Now create association
        jmn_agregar_conexion(vm->mem_neuronal, id1, id2, peso, tipo);
    }
    #endif
}
```

## Memory Alignment

### Use memcpy for Unaligned Access

Avoid undefined behavior from unaligned memory access:

```c
// ✅ CORRECT - Safe with memcpy
uint64_t value;
memcpy(&value, vm->memory + addr, sizeof(value));

// ⚠️ RISKY - May cause unaligned access
uint64_t value = *(uint64_t*)(vm->memory + addr);
```

### Float Conversion

Use union for type punning, not pointer casting:

```c
// ✅ CORRECT - Union for type conversion
union { uint64_t u64; float f32; } uf;
memcpy(&uf.u64, vm->memory + addr, 8);
float result = uf.f32;

// ❌ WRONG - Aliasing violation
float result = *(float*)(vm->memory + addr);
```

## Resource Management

### Allocation Checking

Always check malloc/calloc results:

```c
// ✅ CORRECT
char* buffer = (char*)malloc(size);
if (!buffer) {
    fprintf(stderr, "[ERROR VM] Memory allocation failed: %zu bytes\n", size);
    return NULL;
}
```

### Cleanup Order

Free resources in reverse allocation order:

```c
void cleanup_vm(VM* vm) {
    if (!vm) return;
    
    // Free in reverse order of allocation
    if (vm->text_cache) free_text_cache(vm->text_cache);  // Last allocated
    if (vm->heap_ptrs) free(vm->heap_ptrs);                // ...
    if (vm->memory) free(vm->memory);                      // First allocated
    
    free(vm);
}
```

## NULL Pointer Checks

### Function Entry Points

Always validate pointers at function start:

```c
int vm_some_operation(VM* vm, uint64_t addr) {
    // ✅ CORRECT - Validate parameters first
    if (!vm || !vm->memory || !vm->ir) {
        fprintf(stderr, "[ERROR] Invalid VM state in vm_some_operation\n");
        return -1;
    }
    
    // Now safe to proceed
    // ...
}
```

## Debug Logging

### Conditional Logging

Use environment variables for debug output:

```c
if (getenv("JASBOOT_DEBUG")) {
    printf("[VM DEBUG] Operation: addr=0x%llx, value=0x%llx, PC=0x%llx\n",
           (unsigned long long)addr,
           (unsigned long long)value,
           (unsigned long long)vm->pc);
}
```

## Code Review Checklist

Before committing VM changes, verify:

- [ ] All memory accesses use `vm_leer_seguro()` / `vm_escribir_seguro()`
- [ ] No arithmetic overflow in bounds checks
- [ ] Text synced to JMN when loading string hashes
- [ ] Error messages include operation context
- [ ] NULL checks for all pointer parameters
- [ ] malloc/calloc results checked before use
- [ ] Resources freed in reverse allocation order
- [ ] memcpy used instead of direct pointer casting
- [ ] Integration with try-catch system for errors
- [ ] Debug logging uses JASBOOT_DEBUG environment variable

## Performance vs Safety

When choosing between performance and safety:

**ALWAYS PREFER SAFETY**

A memory corruption bug can:
- Corrupt `.jmn` files permanently
- Cause crashes that lose user data
- Create security vulnerabilities
- Be extremely difficult to debug

A slight performance penalty is acceptable if it prevents memory errors.

## Testing Requirements

Every VM change must be tested with:

1. **Basic functionality test**: Does the feature work?
2. **Bounds test**: Does it handle out-of-bounds addresses?
3. **Null test**: Does it handle NULL pointers gracefully?
4. **Overflow test**: Does it handle integer overflow in address arithmetic?
5. **JMN persistence test**: Does text persist across sessions?

## Emergency Patterns

If you encounter a crash:

1. Enable debug mode: `JASBOOT_DEBUG=1`
2. Check the address in the error message
3. If address is < 1024: NULL pointer dereference
4. If address looks like hash (0x80000000+): Text ID used as pointer
5. If address is very large: Integer overflow in bounds check

---

**Remember**: Memory safety is PARAMOUNT in this project. When in doubt, add more validation, not less.