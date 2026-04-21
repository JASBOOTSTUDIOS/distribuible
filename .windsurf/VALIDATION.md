# Windsurf Context Validation

This document helps verify that the Windsurf context system is properly configured and working for the Jasboot project.

## ✅ Quick Validation Checklist

### Files Exist
- [ ] `.windsurfrules` in project root
- [ ] `jasboot.md` in project root
- [ ] `docs/dev/ai-workflow.md`
- [ ] `docs/dev/jasboot-rules.md`
- [ ] `docs/dev/error-patterns.md`
- [ ] `docs/dev/working-context.md`
- [ ] `docs/dev/contexto-inteligente.md`
- [ ] `AGENTS.md` in project root
- [ ] `.windsurf/rules/vm-memory-safety.md`
- [ ] `.windsurf/rules/jasboot-language.md`
- [ ] `.windsurf/rules/jmn-memory-system.md`
- [ ] `.windsurf/README.md`

### File Sizes (Approximate)
- [ ] `.windsurfrules`: ~10 KB (320+ lines)
- [ ] `AGENTS.md`: ~14 KB (460+ lines)
- [ ] `vm-memory-safety.md`: ~8 KB (300+ lines)
- [ ] `jasboot-language.md`: ~12 KB (520+ lines)
- [ ] `jmn-memory-system.md`: ~15 KB (570+ lines)

### Git Status
- [ ] All context files are tracked by Git
- [ ] Files are in the working tree (not ignored)
- [ ] Ready to commit

## 🧪 Functional Tests

### Test 1: General Project Context

**Open**: Any file in the project

**Ask Cascade**: "What is Jasboot and what are its main components?"

**Expected Response Should Include**:
- Spanish-language programming language
- Compiler (jas-compiler-c)
- Virtual Machine (jasboot-ir)
- Neural Memory (JMN)
- IR bytecode compilation

**Pass/Fail**: ___________

---

### Test 2: Memory Safety Rules (VM Context)

**Open**: `sdk-dependiente/jasboot-ir/src/vm.c`

**Ask Cascade**: "What are the memory safety rules I must follow in this file?"

**Expected Response Should Include**:
- Use `vm_leer_seguro()` and `vm_escribir_seguro()`
- Avoid direct memory access
- Overflow-safe bounds checking pattern
- Check NULL after malloc
- JMN text synchronization

**Pass/Fail**: ___________

---

### Test 3: Language Keywords

**Open**: Any `.jasb` file or create new `test.jasb`

**Ask Cascade**: "Write a simple if-else statement in Jasboot"

**Expected Response Should Use**:
- `si` (not `if`)
- `entonces` (not `then`)
- `sino` (not `else`)
- `fin_si` (not `endif`)

**Example Correct Response**:
```jasboot
si edad > 18 entonces
    imprimir "Mayor de edad"
sino
    imprimir "Menor de edad"
fin_si
```

**Pass/Fail**: ___________

---

### Test 4: JMN Operations

**Open**: Any `.jasb` file

**Ask Cascade**: "Show me how to use JMN memory to store and retrieve a value"

**Expected Response Should Include**:
- `crear_memoria("file.jmn")`
- `recordar "key" con valor "value"`
- `buscar "key"`
- `texto result = resultado`
- `cerrar_memoria()`

**Pass/Fail**: ___________

---

### Test 5: Variable 'resultado' Type

**Open**: `sdk-dependiente/jas-compiler-c/src/symbol_table.c`

**Ask Cascade**: "What type should the special variable 'resultado' be declared as?"

**Expected Response**: 
- Type should be `"elemento"` (not `"entero"`)
- This was a critical fix for text retrieval from JMN
- Located in `sym_init_global()` function

**Pass/Fail**: ___________

---

### Test 6: Memory Access Pattern

**Open**: `sdk-dependiente/jasboot-ir/src/vm.c`

**Ask Cascade**: "Show me the correct way to read from VM memory at address `addr`"

**Expected Response Should Include**:
```c
uint64_t value;
if (!vm_leer_seguro(vm, addr, &value, "operation_context")) {
    return 0; // Error handled
}
```

**Should NOT Include**:
```c
uint64_t value = *(uint64_t*)(vm->memory + addr);  // WRONG
```

**Pass/Fail**: ___________

---

### Test 7: Bounds Checking Pattern

**Open**: `sdk-dependiente/jasboot-ir/src/vm.c`

**Ask Cascade**: "What's the correct way to validate memory bounds to avoid integer overflow?"

**Expected Response Should Include**:
```c
// Correct (overflow-safe)
if (addr > vm->memory_size || vm->memory_size - addr < needed_bytes) {
    // error
}
```

**Should NOT Include**:
```c
// Wrong (overflow vulnerable)
if (addr + needed_bytes > vm->memory_size) {
    // error
}
```

**Pass/Fail**: ___________

---

### Test 8: JMN Text Persistence

**Open**: `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_core.c`

**Ask Cascade**: "What's the critical step when storing text in JMN?"

**Expected Response Should Include**:
- Always call `jmn_guardar_texto()`
- Sync text cache to JMN
- Text must be saved when loading string hashes
- Critical for persistence across sessions

**Pass/Fail**: ___________

---

### Test 9: Rule Activation by Glob

**Open**: `sdk-dependiente/jasboot-ir/src/vm.c`

**Ask Cascade**: "What specific rules are active for this file?"

**Expected Response Should Mention**:
- VM Memory Safety rules
- Activated by glob pattern
- Priority 100

**Open**: `test.jasb` (any Jasboot file)

**Ask Cascade**: "What rules are active now?"

**Expected Response Should Mention**:
- Jasboot Language rules
- JMN Memory System rules (if using JMN functions)

**Pass/Fail**: ___________

---

### Test 10: Code Generation Request

**Open**: New file `test_validation.jasb`

**Ask Cascade**: "Create a Jasboot program that creates a JMN memory, stores a user's name and age, retrieves them, and prints them"

**Expected Code Should**:
- Use Spanish keywords exclusively
- Use `crear_memoria()`, `recordar`, `buscar`, `cerrar_memoria()`
- Assign `resultado` to typed variables
- Use `texto` and `entero` types
- Include `principal`/`fin_principal`

**Pass/Fail**: ___________

---

## 📊 Validation Summary

Total Tests: 10
Passed: _____
Failed: _____
Success Rate: _____% 

**Minimum Passing Score**: 8/10 (80%)

## 🔧 Troubleshooting

### Issue: Cascade doesn't know about project structure

**Check**:
1. `.windsurfrules` exists in project root
2. `AGENTS.md` exists in project root
3. Reload Windsurf window (Ctrl+Shift+P → "Reload Window")

**Fix**: Create missing files using the templates in this directory

---

### Issue: Memory safety rules not applying

**Check**:
1. Open a file in `sdk-dependiente/jasboot-ir/`
2. Check glob pattern in `rules/vm-memory-safety.md` frontmatter
3. Pattern: `glob: "sdk-dependiente/jasboot-ir/**/*.c"`

**Fix**: Verify file path matches glob pattern

---

### Issue: Spanish keywords not enforced

**Check**:
1. Open a `.jasb` file
2. Check if `rules/jasboot-language.md` exists
3. Check glob: `glob: "**/*.jasb,sdk-dependiente/jas-compiler-c/**/*.c"`

**Fix**: Ensure glob pattern matches your file path

---

### Issue: Cascade gives generic responses

**Check**:
1. Context files might not be loaded
2. Global rules might be overriding project rules
3. Memories might be outdated

**Fix**:
1. Ask Cascade: "What files are currently in your context?"
2. Clear memories if needed (Customizations → Memories → Delete outdated)
3. Restart Windsurf

---

### Issue: Conflicting rules

**Check**:
1. Multiple rules might contradict each other
2. Global rules vs. project rules conflict

**Fix**:
1. Check priority values in frontmatter
2. Higher priority takes precedence
3. Review global rules (Settings → AI → Rules)

---

## 🎓 Advanced Validation

### Memory Safety Deep Dive

**Test**: Ask Cascade to review this code and identify issues:

```c
// In vm.c
uint64_t addr = calculate_address();
uint64_t value = *(uint64_t*)(vm->memory + addr);
if (addr + 8 > vm->memory_size) {
    return -1;
}
```

**Expected Response Should Identify**:
1. Direct memory access without validation (line 2)
2. Validation AFTER access (should be before)
3. Overflow-vulnerable bounds check (line 3)
4. Should use `vm_leer_seguro()` instead

**Pass/Fail**: ___________

---

### JMN Pattern Recognition

**Test**: Ask Cascade to complete this code:

```jasboot
principal
    crear_memoria("users.jmn")
    
    recordar "user_name" con valor "Juan Pérez"
    
    # TODO: Retrieve and print the user's name
```

**Expected Completion Should Include**:
```jasboot
buscar "user_name"
texto nombre = resultado
imprimir "Nombre: " + nombre

cerrar_memoria()
```

**Pass/Fail**: ___________

---

## 📝 Notes

### Things to Remember

1. **Spanish Keywords**: Jasboot uses Spanish, not English
2. **resultado Type**: Always `elemento`, never `entero`
3. **Memory Safety**: Use safe wrappers, not direct access
4. **JMN Persistence**: Always consolidate/close memory
5. **Text Sync**: Save text to JMN when loading hashes

### Context Update Triggers

Update context files when:
- [ ] New language features added
- [ ] New bug patterns discovered
- [ ] Architecture changes
- [ ] New APIs or opcodes
- [ ] Team conventions change

### Validation Frequency

Run this validation:
- [ ] When setting up new development environment
- [ ] After updating Windsurf
- [ ] After modifying context files
- [ ] Monthly (routine check)
- [ ] Before major releases

---

## ✅ Certification

**Validated By**: _______________________

**Date**: _______________________

**Version**: Jasboot 0.0.1 Beta

**Windsurf Version**: _______________________

**All Tests Passed**: ☐ Yes  ☐ No

**Issues Found**: 

_________________________________________________________________

_________________________________________________________________

**Resolution**: 

_________________________________________________________________

_________________________________________________________________

---

**Signature**: _______________________

This validation certifies that the Windsurf context system for Jasboot is properly configured and functioning as expected.