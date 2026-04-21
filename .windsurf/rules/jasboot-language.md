---
name: "Jasboot Language Development"
description: "Rules for developing Jasboot language code and compiler features"
activation: "glob"
glob: "**/*.jasb,sdk-dependiente/jas-compiler-c/**/*.c"
priority: 90
---

# Jasboot Language Development Rules

Rules for writing Jasboot code and developing compiler features for the Jasboot programming language.

## Language Overview

Jasboot is a **Spanish-language programming language** with:
- Spanish keywords for all control structures
- Dynamic typing at runtime
- Integrated neural memory (JMN) for AI applications
- Compiled to IR bytecode, executed by custom VM

## Core Syntax Rules

### Keywords MUST Be in Spanish

**NEVER use English keywords in Jasboot code**:

```jasboot
# ✅ CORRECT - Spanish keywords
principal
    entero edad = 25
    si edad >= 18 entonces
        imprimir "Mayor de edad"
    fin_si
fin_principal

# ❌ WRONG - English keywords not allowed
main
    int age = 25
    if age >= 18 then
        print "Adult"
    end if
end main
```

### Data Types

| Jasboot Type | Description | C Equivalent |
|--------------|-------------|--------------|
| `entero` | 64-bit integer | `int64_t` |
| `texto` | UTF-8 string | `char*` |
| `flotante` | Floating point | `double` |
| `bool` | Boolean | `bool` |
| `caracter` | Single character | `char` |
| `elemento` | Dynamic/any type | `void*` (tagged) |
| `lista` | Dynamic array | Custom type |
| `mapa` | Hash map | Custom type |

### Control Structures

#### Conditional (if/else)

```jasboot
si condicion entonces
    # código
sino si otra_condicion entonces
    # código
sino
    # código
fin_si
```

#### Loops

```jasboot
# While loop
mientras condicion hacer
    # código
fin_mientras

# For-each loop
para_cada elemento sobre coleccion hacer
    # código
fin_para_cada
```

#### Functions

```jasboot
funcion nombre_funcion(tipo param1, tipo param2) retorna tipo
    # código
    retornar valor
fin_funcion
```

#### Classes

```jasboot
clase NombreClase
    # Atributos
    entero atributo_publico
    privado texto atributo_privado
    
    # Constructor implícito
    
    # Métodos
    funcion metodo_publico() retorna texto
        retornar "resultado"
    fin_funcion
    
    privado funcion metodo_privado()
        # código
    fin_funcion
fin_clase
```

## Neural Memory (JMN) Operations

### Memory Lifecycle

```jasboot
# 1. Create/open memory file
crear_memoria("database.jmn")

# 2. Store data
recordar "key" con valor "value"

# 3. Retrieve data
buscar "key"
texto result = resultado  # Special variable 'resultado'

# 4. Associate concepts
asociar "concept1" con "concept2" con fuerza 0.85

# 5. Close memory
cerrar_memoria()
```

### JMN Functions Reference

| Function | Purpose | Example |
|----------|---------|---------|
| `crear_memoria(path)` | Create/open JMN file | `crear_memoria("data.jmn")` |
| `recordar key con valor val` | Store key-value pair | `recordar "name" con valor "Juan"` |
| `buscar key` | Retrieve value → `resultado` | `buscar "name"` |
| `asociar a con b con fuerza w` | Associate concepts | `asociar "dog" con "animal" con fuerza 0.9` |
| `cerrar_memoria()` | Close and save | `cerrar_memoria()` |
| `consolidar_memoria()` | Force save without closing | `consolidar_memoria()` |

### Special Variable: `resultado`

**CRITICAL**: The variable `resultado` is **type `elemento`** (dynamic), not `entero`:

```jasboot
# ✅ CORRECT - resultado is elemento (dynamic type)
buscar "user_name"
texto name = resultado  # Automatic conversion

buscar "user_age"
entero age = resultado  # Automatic conversion

# Common pattern: assign to typed variable
buscar "some_key"
texto value = resultado
imprimir "Value: " + value
```

## Standard Library Functions

### Console I/O

```jasboot
# Print with newline
imprimir "mensaje"

# Print without newline
imprimir_sin_salto "mensaje"

# Read user input
texto input = ingresar_texto()
entero number = entrada_flotante()
```

### String Operations

```jasboot
# String length
entero len = longitud_texto("hola")

# Extract substring
texto sub = extraer_subtexto("hello world", 0, 5)

# Convert case
texto lower = minusculas("HELLO")

# Extract before/after
texto before = extraer_antes_de("hello:world", ":")
texto after = extraer_despues_de("hello:world", ":")

# Contains check
bool has = contiene_texto("hello world", "world")
```

### Type Conversions

```jasboot
# Number to string
texto str = str_desde_numero(42)

# String to number
entero num = str_a_entero("42")
flotante f = str_a_flotante("3.14")

# Character operations
entero code = codigo_caracter('A')  # 65
texto char_str = caracter_a_texto('A')
```

## Compiler Development Rules

### Adding New Keywords

When adding keywords to `keywords.c`:

1. **Add to KEYWORDS array** (alphabetically within category)
2. **Add to FORBIDDEN_ENGLISH** if preventing English equivalent
3. **Update parser** in `parser.c` to handle new syntax
4. **Update codegen** in `codegen.c` to emit correct IR
5. **Document** in language specification

```c
// keywords.c - Add to KEYWORDS array
const char *const KEYWORDS[] = {
    // ... existing keywords ...
    "nueva_palabra_clave",
    // ...
};
```

### Opcode Design Principles

When adding new VM opcodes:

1. **Name clearly**: Use Spanish or descriptive English
2. **Document parameters**: What goes in operand_a, operand_b, operand_c
3. **Validate inputs**: Check bounds, NULL pointers
4. **Handle errors**: Integrate with try-catch system
5. **Add debug logging**: Use `JASBOOT_DEBUG` environment variable

```c
// vm.c - Example new opcode
case OP_NUEVA_OPERACION: {
    // 1. Get operands
    uint64_t a_val = vm_get_register(vm, inst.operand_a);
    uint64_t b_val = vm_get_register(vm, inst.operand_b);
    
    // 2. Validate
    if (!validate_something(a_val)) {
        char msg[512];
        snprintf(msg, sizeof msg, "[ERROR] Validation failed in OP_NUEVA_OPERACION");
        if (vm_try_catch_or_abort(vm, msg)) return 0;
        // ... error handling ...
    }
    
    // 3. Execute operation
    uint64_t result = perform_operation(a_val, b_val);
    
    // 4. Store result
    vm_set_register(vm, inst.operand_a, result);
    
    // 5. Debug log
    if (getenv("JASBOOT_DEBUG")) {
        printf("[VM OP_NUEVA_OPERACION] a=0x%llx, b=0x%llx -> result=0x%llx\n",
               (unsigned long long)a_val,
               (unsigned long long)b_val,
               (unsigned long long)result);
    }
    
    // 6. Advance program counter
    vm->pc += IR_INSTRUCTION_SIZE;
    break;
}
```

## Common Patterns

### Error Handling with Try-Catch

```jasboot
intentar
    # Code that might fail
    buscar "nonexistent_key"
atrapar error
    imprimir "Error occurred: " + error
final
    # Always executed (like finally)
    imprimir "Cleanup"
fin_intentar
```

### Working with Collections

```jasboot
# Lists
lista nombres = mem_lista_crear()
mem_lista_agregar(nombres, "Juan")
mem_lista_agregar(nombres, "María")
entero tam = mem_lista_tamano(nombres)

# Maps
mapa datos = mapa_crear()
mapa_poner(datos, "nombre", "Juan")
texto valor = mapa_obtener(datos, "nombre")
```

### Class Instantiation

```jasboot
clase Persona
    texto nombre
    entero edad
    
    funcion saludar() retorna texto
        retornar "Hola, soy " + nombre
    fin_funcion
fin_clase

# Usage
Persona p
p.nombre = "Juan"
p.edad = 30
texto saludo = p.saludar()
```

## Code Style Guidelines

### Variable Naming

```jasboot
# ✅ Prefer snake_case for variables
entero numero_usuarios = 10
texto nombre_completo = "Juan Pérez"

# ✅ camelCase is acceptable
entero numeroUsuarios = 10
texto nombreCompleto = "Juan Pérez"

# ❌ Avoid single-letter variables (except loops)
entero x = 10  # Bad
entero edad = 10  # Good
```

### Function Naming

```jasboot
# ✅ Use descriptive verb-noun combinations
funcion calcular_promedio(lista valores) retorna flotante
funcion obtener_usuario(entero id) retorna texto
funcion validar_entrada(texto input) retorna bool

# ❌ Avoid vague names
funcion procesar()  # Bad - process what?
funcion calc()      # Bad - too abbreviated
```

### Class Naming

```jasboot
# ✅ Use PascalCase for class names
clase UsuarioSistema
clase ManejadorArchivos
clase ConexionBaseDatos

# ❌ Avoid lowercase or snake_case
clase usuario_sistema  # Bad
clase manejador_archivos  # Bad
```

## Testing Patterns

### Basic Test Structure

```jasboot
principal
    imprimir "=== Iniciando Tests ==="
    entero tests_pasados = 0
    entero tests_totales = 0
    
    # Test 1
    tests_totales = tests_totales + 1
    si probar_algo() entonces
        imprimir "✅ Test 1 pasó"
        tests_pasados = tests_pasados + 1
    sino
        imprimir "❌ Test 1 falló"
    fin_si
    
    # Summary
    imprimir ""
    imprimir "Tests pasados: " + str_desde_numero(tests_pasados)
    imprimir "Tests totales: " + str_desde_numero(tests_totales)
fin_principal
```

## Debugging

### Debug Prints

```jasboot
# Use descriptive messages
imprimir "[DEBUG] Variable x = " + str_desde_numero(x)
imprimir "[DEBUG] Entrando a funcion_compleja()"
imprimir "[DEBUG] Estado: " + estado

# Print variable types
imprimir_id(variable)  # Prints internal ID/hash
```

### Common Debug Commands

```bash
# Enable VM debug output
JASBOOT_DEBUG=1 jasboot-ir-vm.exe program.jbo

# Check memory file integrity
hexdump -C database.jmn | head -20

# Trace execution
jasboot-ir-vm-trace.exe program.jbo
```

## Compilation Checklist

Before committing language changes:

- [ ] Keywords added to `keywords.c` (if new syntax)
- [ ] Parser handles new syntax in `parser.c`
- [ ] Codegen emits correct IR in `codegen.c`
- [ ] VM executes opcode correctly in `vm.c`
- [ ] Example code added to `examples/`
- [ ] Test added to `tests/`
- [ ] Documentation updated in `docs/`
- [ ] Spanish keywords only (no English)
- [ ] Code compiles without warnings
- [ ] Tests pass

## Common Mistakes to Avoid

### Mistake 1: Using English Keywords

```jasboot
# ❌ WRONG
if (x > 5) {
    return true;
}

# ✅ CORRECT
si x > 5 entonces
    retornar verdadero
fin_si
```

### Mistake 2: Wrong resultado Type

```jasboot
# ❌ WRONG - resultado as entero
buscar "key"
entero val = resultado  # Might lose data

# ✅ CORRECT - resultado as elemento first
buscar "key"
elemento temp = resultado
texto val = temp  # Or assign directly to texto
```

### Mistake 3: Not Closing Memory

```jasboot
# ❌ WRONG - Memory leak/corruption
crear_memoria("data.jmn")
recordar "key" con valor "value"
# Missing cerrar_memoria()

# ✅ CORRECT
crear_memoria("data.jmn")
recordar "key" con valor "value"
cerrar_memoria()
```

### Mistake 4: Forgetting fin_* Keywords

```jasboot
# ❌ WRONG - Missing fin_si
si condicion entonces
    imprimir "true"

# ✅ CORRECT
si condicion entonces
    imprimir "true"
fin_si
```

## Performance Tips

1. **Reuse memory files**: Don't create new `.jmn` files repeatedly
2. **Consolidate periodically**: Call `consolidar_memoria()` for long-running programs
3. **Batch associations**: Group related `recordar` operations together
4. **Use appropriate types**: Don't use `elemento` when specific type is known
5. **Minimize string concatenation**: Pre-allocate when possible

## Language Philosophy

Jasboot aims to be:
- **Accessible**: Spanish keywords lower barrier for Spanish speakers
- **Intelligent**: Built-in neural memory for AI applications
- **Safe**: Strong error handling with try-catch
- **Practical**: Easy integration with C libraries via FFI

When designing features, ask:
1. Does this make the language **more accessible** to Spanish speakers?
2. Does this enable **AI/ML applications** naturally?
3. Is it **safe** and **predictable** for users?
4. Can it **interoperate** with existing C/C++ code?

---

**Remember**: Jasboot is a Spanish-first language. All keywords, documentation, and examples should prioritize Spanish speakers while maintaining technical excellence.