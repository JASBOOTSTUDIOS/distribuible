# AGENTS.md - Jasboot Programming Language

> **Project**: Jasboot - Lenguaje de programación en español con memoria neuronal integrada  
> **Type**: Programming Language Implementation (Compiler + VM + Neural Memory)  
> **Language**: Spanish (language keywords) + C (implementation)  
> **Architecture**: Compiler → IR Bytecode → Virtual Machine + Neural Memory System

---

## 🎯 Project Mission

Jasboot is a Spanish-language programming language with integrated neural memory (JMN - Jasboot Memory Neural). The project aims to create an accessible programming environment for Spanish speakers while providing advanced AI capabilities through associative memory persistence.

---

## 📊 Technical Stack

### Core Components

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Compiler** | C11 (GCC/MinGW) | Jasboot source → IR bytecode |
| **Virtual Machine** | C11 | Execute IR bytecode |
| **Neural Memory** | C11 | Persistent associative memory (JMN) |
| **Build System** | Make/Batch | Cross-platform compilation |
| **Testing** | Node.js scripts | Test execution and validation |

### Dependencies

- **GCC/MinGW**: C11 compiler (minimum version 5.0)
- **Node.js**: For test runner scripts (v14+)
- **Git**: Version control
- **Windows SDK**: For Windows builds (optional)

---

## 🏗️ Architecture Overview

### Pipeline Flow

```
┌─────────────┐     ┌──────────┐     ┌──────────┐     ┌─────────┐
│ Jasboot     │────>│  Lexer   │────>│  Parser  │────>│   AST   │
│ Source Code │     │ (tokens) │     │          │     │         │
└─────────────┘     └──────────┘     └──────────┘     └─────────┘
                                                             │
                                                             ▼
┌─────────────┐     ┌──────────┐     ┌──────────┐     ┌─────────┐
│   Execution │<────│  VM      │<────│ IR Code  │<────│ Codegen │
│  + JMN      │     │          │     │ (.jbo)   │     │         │
└─────────────┘     └──────────┘     └──────────┘     └─────────┘
```

### Directory Structure

```
jasboot/
├── sdk-dependiente/              # Native dependencies SDK
│   ├── jas-compiler-c/           # Compiler: Jasboot → IR
│   │   ├── src/                  # Compiler source (lexer, parser, codegen)
│   │   ├── include/              # Public headers
│   │   └── bin/jbc.exe           # Compiled compiler binary
│   │
│   ├── jasboot-ir/               # Virtual Machine
│   │   ├── src/vm.c              # VM core execution engine
│   │   ├── src/ir_vm.c           # IR loader and validator
│   │   └── bin/jasboot-ir-vm.exe # VM binary
│   │
│   ├── jasboot-jmn-core/         # Neural Memory System
│   │   └── src/memoria_neuronal/ # JMN implementation
│   │       ├── memoria_neuronal_core.c
│   │       ├── memoria_neuronal_nodos.c
│   │       ├── memoria_neuronal_conexiones.c
│   │       └── memoria_neuronal_io.c
│   │
│   └── bin/                      # Consolidated binaries
│
├── apps/                         # Example applications
│   ├── aurora_ia/                # Conversational AI system
│   ├── michelle_IA/              # Virtual assistant
│   └── neurixis/                 # Neural network framework
│
├── stdlib/                       # Standard library (Jasboot)
├── tests/                        # Language tests
├── examples/                     # Code examples
└── docs/                         # Documentation

```

---

## 🔧 Core Concepts

### 1. Jasboot Language Syntax

Jasboot uses **Spanish keywords** for accessibility:

```jasboot
principal
    entero edad = 25
    texto nombre = "María"
    
    si edad > 18 entonces
        imprimir "Mayor de edad"
    sino
        imprimir "Menor de edad"
    fin_si
    
    mientras edad < 30 hacer
        edad = edad + 1
    fin_mientras
fin_principal
```

**Key Keywords**:
- `principal` / `fin_principal` = main function
- `funcion` / `fin_funcion` = function definition
- `si` / `sino` / `fin_si` = if/else/endif
- `mientras` / `fin_mientras` = while loop
- `entero` / `texto` / `flotante` / `bool` = data types
- `imprimir` = print
- `retornar` = return

### 2. Neural Memory (JMN) System

The JMN system provides **persistent associative memory** for AI applications:

```jasboot
# Create/open memory file
crear_memoria("database.jmn")

# Store key-value association
recordar "user_name" con valor "Juan Pérez"

# Retrieve value
buscar "user_name"
texto result = resultado  # Special variable 'resultado'

# Associate concepts with strength
asociar "perro" con "animal" con fuerza 0.9

# Close memory
cerrar_memoria()
```

**JMN Architecture**:
- **Nodes**: Concepts with unique ID (text hash)
- **Connections**: Weighted relationships (0.0-1.0)
- **Relation Types**: Association (1), Sequence (2), Similarity (3)
- **Persistence**: Binary `.jmn` file format

### 3. Type System

- **Dynamic typing** at runtime
- Special variable `resultado`: type `elemento` (dynamic/any)
- Automatic conversion when safe
- Hash-based text ID system (IDs start at 0x80000000)

---

## 🚨 Critical Rules for AI Agents

### Memory Safety (PARAMOUNT)

**ALWAYS validate memory bounds before access**:

```c
// ✅ CORRECT - Safe validation without overflow
if (addr > vm->memory_size || vm->memory_size - addr < 8) {
    // Handle error
}

// ❌ WRONG - Vulnerable to integer overflow
if (addr + 8 > vm->memory_size) {
    // This can overflow!
}
```

**Use safe wrapper functions**:
```c
// Read memory safely
if (!vm_leer_seguro(vm, addr, &value, "operation_context")) {
    return 0; // Error handled by wrapper
}

// Write memory safely
if (!vm_escribir_seguro(vm, addr, value, "operation_context")) {
    return 0; // Error handled by wrapper
}
```

### Naming Conventions

| Component | Convention | Example |
|-----------|-----------|---------|
| VM functions | `vm_*` | `vm_step`, `vm_leer_seguro` |
| JMN functions | `jmn_*` | `jmn_buscar_asociaciones` |
| IR functions | `ir_*` | `ir_read_instruction` |
| Variables/functions | `snake_case` | `memory_size`, `read_value` |
| Structs/Types | `PascalCase` | `VM`, `SymbolTable` |
| Constants/Macros | `SCREAMING_SNAKE` | `MAX_MEMORY_SIZE` |

### Code Generation Rules

1. **Never use English keywords in Jasboot code** - Spanish only
2. **Always sync text cache with JMN** when creating associations
3. **Variable `resultado` is type `elemento`**, not `entero`
4. **Free resources in reverse allocation order**
5. **Check NULL after malloc/calloc**

---

## 🐛 Common Issues & Solutions

### Issue 1: `buscar` returns number instead of text

**Symptom**: 
```jasboot
buscar "name"
imprimir resultado  # Prints: 2147483648
```

**Root Cause**: Variable `resultado` declared as `entero` instead of `elemento`

**Solution**: In `symbol_table.c` line 35:
```c
// Change from:
sym_declare(st, "resultado", "entero", 8, 0, 0, NULL);

// To:
sym_declare(st, "resultado", "elemento", 8, 0, 0, NULL);
```

### Issue 2: Memory access violation in OP_LEER/OP_ESCRIBIR

**Symptom**: `Violacion de acceso en OP_LEER: direccion 0xXXXXXXXX fuera de limites`

**Root Cause**: Direct memory access without bounds validation

**Solution**: Replace direct access with safe wrappers:
```c
// Instead of:
uint64_t value = *(uint64_t*)(vm->memory + addr);

// Use:
uint64_t value;
if (!vm_leer_seguro(vm, addr, &value, "OP_LEER")) return 0;
```

### Issue 3: Text not persisting in JMN after `recordar`

**Symptom**: `buscar` returns ID but `OP_ID_A_TEXTO` fails to find text

**Root Cause**: Text not saved to JMN during `OP_LOAD_STR_HASH`

**Solution**: In `vm.c`, ensure text is saved when hash is loaded:
```c
case OP_LOAD_STR_HASH: {
    // ... load hash ...
    #ifdef JASBOOT_LANG_INTEGRATION
    if (vm->mem_neuronal) {
        jmn_guardar_texto(vm->mem_neuronal, hash, str);
    }
    #endif
}
```

### Issue 4: JMN file corruption

**Symptom**: Cannot load `.jmn` file after program termination

**Root Cause**: Memory not consolidated/closed before exit

**Solution**: Always call cleanup:
```jasboot
# At end of program
consolidar_memoria()
cerrar_memoria()
```

---

## 🔨 Build & Test Commands

### Compile Everything (Windows)

```bash
cd sdk-dependiente
scripts\build-all.bat
```

### Compile VM Only

```bash
cd sdk-dependiente/jasboot-ir
build_vm.bat  # Windows
make          # Linux
```

### Compile Compiler Only

```bash
cd sdk-dependiente/jas-compiler-c
build.bat     # Windows
make          # Linux
```

### Run Jasboot Program

```bash
# Compile and run
node .vscode/run-jasb.cjs path/to/program.jasb

# Run with debug output
JASBOOT_DEBUG=1 sdk-dependiente/jasboot-ir/bin/jasboot-ir-vm.exe program.jbo
```

### Run Tests

```bash
# Basic test
node .vscode/run-jasb.cjs tests/test_basico.jasb

# JMN memory test
node .vscode/run-jasb.cjs apps/aurora_ia/test_jmn.jasb
```

---

## 📝 Important Files for AI Context

When working on specific features, focus on these files:

### Compiler Changes
- `sdk-dependiente/jas-compiler-c/src/lexer.c` - Tokenization
- `sdk-dependiente/jas-compiler-c/src/parser.c` - AST generation
- `sdk-dependiente/jas-compiler-c/src/codegen.c` - IR code emission
- `sdk-dependiente/jas-compiler-c/src/symbol_table.c` - Variable declarations
- `sdk-dependiente/jas-compiler-c/src/keywords.c` - Language keywords

### VM Changes
- `sdk-dependiente/jasboot-ir/src/vm.c` - Main VM execution loop
- `sdk-dependiente/jasboot-ir/src/ir_vm.c` - IR loader/validator
- `sdk-dependiente/jasboot-ir/src/vm.h` - VM structures and constants

### JMN Changes
- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_core.c`
- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_nodos.c`
- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_conexiones.c`
- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_io.c`

---

## 🌲 Git Branches

| Branch | Purpose | Status |
|--------|---------|--------|
| `vm-estabilidad-error-memoria` | **CURRENT** - Memory safety fixes | Active |
| `fix/jmn-correcciones-sdk` | JMN bug fixes | Stable |
| `feature/jmn-solutions` | JMN enhancements | Experimental |
| `main` | Production releases | Stable |

**Default working branch**: `vm-estabilidad-error-memoria`

---

## 🎓 Learning Resources

### For Understanding the Codebase
1. Read `jasboot.md` - Language specification
2. Explore `examples/` - Simple code samples
3. Study `apps/aurora_ia/` - Complete AI application
4. Review `tests/` - Language feature tests

### Key Concepts to Understand
- **IR Bytecode Format**: How Jasboot compiles to intermediate representation
- **Hash-based Text IDs**: How strings are stored and retrieved (0x80000000+)
- **JMN Graph Structure**: Nodes, connections, weights, and relation types
- **VM Register Architecture**: How the virtual machine executes bytecode

---

## 🚫 Forbidden Patterns

**NEVER DO THIS**:

```c
// ❌ Direct memory access without validation
*(uint64_t*)(vm->memory + addr) = value;

// ❌ Overflow-vulnerable arithmetic
if (addr + size > limit) { }

// ❌ Using resultado as entero
sym_declare(st, "resultado", "entero", ...);

// ❌ English keywords in Jasboot code
if (x > 5) { return true; }  // Must be: si, retornar, verdadero
```

**ALWAYS DO THIS**:

```c
// ✅ Safe memory access
if (!vm_escribir_seguro(vm, addr, value, "context")) return 0;

// ✅ Overflow-safe validation
if (addr > size || size - addr < needed) { }

// ✅ Correct resultado type
sym_declare(st, "resultado", "elemento", ...);

// ✅ Spanish keywords
si x > 5 entonces
    retornar verdadero
fin_si
```

---

## 💡 Tips for AI Agents

1. **Always check memory safety first** - This is a systems language project where memory errors corrupt `.jmn` files
2. **Read existing code before creating new functions** - Avoid duplication
3. **Test after every change** - Compile and run tests to verify
4. **Use descriptive error messages** - Include context for debugging
5. **Prefer safety over performance** - Memory corruption is worse than slower code
6. **Maintain Spanish in Jasboot code** - This is a Spanish-language programming language
7. **Document architectural decisions** - Leave comments explaining "why", not just "what"

---

## 📞 Debug Environment Variables

```bash
JASBOOT_DEBUG=1           # Enable verbose VM logging
JASBOOT_JMN_ROOT=<path>   # Custom JMN core location
```

**Important Log Markers**:
- `[VM LOAD HASH]` - Text hash loading
- `[VM OP_MEM_OBTENER_VALOR]` - Memory value retrieval
- `[JMN IO]` - JMN file operations
- `[ERROR VM]` - VM errors (memory violations, etc.)

---

## ✅ Quality Checklist

Before committing changes:

- [ ] Code compiles without warnings
- [ ] Memory validation added for all new memory accesses
- [ ] Tests pass for affected features
- [ ] Error messages are descriptive with context
- [ ] Spanish keywords used in Jasboot examples
- [ ] NULL checks after malloc/calloc
- [ ] Resources freed in reverse allocation order
- [ ] Git commit message is descriptive

---

**Last Updated**: 2026-04-20  
**Project Version**: 0.0.1 (Beta)  
**Maintainer**: Jefry Astacio (@JASBOOTSTUDIOS)