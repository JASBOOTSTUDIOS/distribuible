# 📋 PLAN DE ESTABILIZACIÓN - JASBOOT FASE 1

**Versión**: 1.0  
**Fecha**: 25 de Abril de 2026  
**Objetivo**: Llevar Jasboot de 35% a 60% de robustez  
**Timeline**: 2-3 semanas  
**Esfuerzo**: 50-60 horas de desarrollo

---

## 🎯 OBJETIVO GENERAL

Eliminar los **5 hallazgos críticos identificados** que causan crashes, hangs y corrupción de memoria, estableciendo una **base sólida para desarrollo futuro**.

### Métricas de Éxito

```
ANTES                          DESPUÉS (META)
────────────────────────────────────────────
Madurez:      35%         →    60%
Crashes:      Frecuentes  →    Rarísimos
Hangs:        Sí (JMN)    →    Nunca
Tests:        44%         →    65%
Documentación: 50%         →    75%
```

---

## 📅 TIMELINE Y FASES

### FASE 1A: FIXES CRÍTICOS (Semana 1)
**Duración**: 5 días laborales (40 horas)  
**Objetivo**: Eliminar crashes y hangs

```
DÍA 1 (8h):  JMN Saturación + Stack Overflow
DÍA 2 (8h):  Buffer Overflow + .jbo Validation
DÍA 3 (8h):  realloc Fixes + Debugging
DÍA 4 (8h):  Tests críticos + Validación
DÍA 5 (8h):  Documentation + Code Review
```

### FASE 1B: COBERTURA DE TESTS (Semana 2-3)
**Duración**: 10 días laborales (80 horas)  
**Objetivo**: Llevar cobertura a 65%

```
SEMANA 2:  Tests de componentes individuales
SEMANA 3:  Tests de integración + E2E
```

### RESULTADO FINAL
```
Madurez:  60%
Crashes:  Eliminados
Status:   "Production-ready con precaución"
```

---

## 📝 TAREAS DETALLADAS - FASE 1A

### TAREA 1.1: Fix Infinite Loop en JMN (Hallazgo #1)

**Prioridad**: 🔴 CRÍTICA  
**Duración**: 2 horas  
**Complejidad**: ⭐ Fácil

#### Paso 1: Backup y Planificación
```bash
cd c:\src\jasboot\sdk-dependiente\jasboot-jmn-core
git checkout -b fix/jmn-tabla-expansion
```

#### Paso 2: Modificar memoria_neuronal_nodos.c

**Cambios**:
1. Agregar constantes
2. Agregar función `jmn_expandir_tabla()`
3. Modificar `jmn_insertar_nodo()`

**Archivo**: `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_nodos.c`

```c
// Línea ~30 - AGREGAR
#define JMN_INITIAL_CAPACITY 1000
#define JMN_MAX_LOAD_FACTOR 0.75
#define JMN_GROWTH_FACTOR 2

// Línea ~120 - REEMPLAZAR función jmn_insertar_nodo
// (Ver HALLAZGOS_CRITICOS.md para código completo)

// Línea ~180 - AGREGAR nueva función
static int jmn_expandir_tabla(MemoriaNeuronal *mem) {
    // (Ver HALLAZGOS_CRITICOS.md para código completo)
}
```

#### Paso 3: Compilar y Probar

```bash
# Compilar VM
cd sdk-dependiente/jasboot-ir
build_vm.bat

# Ejecutar test de saturación
node .vscode/run-jasb.cjs ..\..\..\test_jmn_saturacion_poc.jasb
```

#### Paso 4: Verificar

```bash
# Debe ejecutarse SIN infinite loop
# Debe mostrar mensajes de expansión de tabla
```

---

### TAREA 1.2: Fix Stack Overflow en Anidamiento (Hallazgo #2)

**Prioridad**: 🔴 CRÍTICA  
**Duración**: 2 horas  
**Complejidad**: ⭐ Fácil

#### Cambios en parser.c

**Archivo**: `sdk-dependiente/jas-compiler-c/src/parser.c`

```c
// Línea ~30 - AGREGAR constantes
#define MAX_NESTING_DEPTH 100

// Línea ~50 - MODIFICAR struct Parser
typedef struct {
    // ... campos existentes ...
    int current_depth;      // ← AGREGAR
    int max_depth_seen;     // ← AGREGAR
} Parser;

// Línea ~150 - MODIFICAR parser_init
void parser_init(Parser *p, Token *tokens) {
    // ... código existente ...
    p->current_depth = 0;          // ← AGREGAR
    p->max_depth_seen = 0;         // ← AGREGAR
}

// Línea ~300 - MODIFICAR parse_bloque
void parse_bloque(Parser *p) {
    if (p->current_depth >= MAX_NESTING_DEPTH) {
        parser_error(p, "Profundidad de anidamiento excede %d", 
                    MAX_NESTING_DEPTH);
        return;
    }
    
    p->current_depth++;
    if (p->current_depth > p->max_depth_seen) {
        p->max_depth_seen = p->current_depth;
    }
    
    // ... resto de código ...
    
    p->current_depth--;
}

// Línea ~450 - MODIFICAR parse_si, parse_mientras, etc
// (Similar - agregar validación de profundidad)
```

#### Compilar y Probar

```bash
cd sdk-dependiente\jas-compiler-c
build.bat

# Test profundidad válida (debe compilar)
echo 'programa' > test_depth_valid.jasb
for /L %i in (1,1,50) do echo "    si 1 entonces" >> test_depth_valid.jasb
echo "        imprimir \"ok\"" >> test_depth_valid.jasb
for /L %i in (1,1,50) do echo "    fin_si" >> test_depth_valid.jasb
echo 'fin_programa' >> test_depth_valid.jasb
jbc.exe test_depth_valid.jasb  # Debe funcionar

# Test profundidad inválida (debe error)
# (generar test_depth_invalid.jasb con 150+ niveles)
# Debe fallar con mensaje claro
```

---

### TAREA 1.3: Fix Buffer Overflow en Identificadores (Hallazgo #3)

**Prioridad**: 🔴 CRÍTICA  
**Duración**: 1.5 horas  
**Complejidad**: ⭐ Fácil

#### Cambios en lexer.c

**Archivo**: `sdk-dependiente/jas-compiler-c/src/lexer.c`

```c
// Línea ~30 - AGREGAR
#define MAX_IDENTIFIER_LENGTH 255

// Línea ~200 - MODIFICAR lexer_read_identifier
void lexer_read_identifier(Lexer *lex) {
    char buffer[MAX_IDENTIFIER_LENGTH + 1];
    int len = 0;
    
    while ((isalnum(lex->current) || lex->current == '_' || lex->current == '.') &&
           len < MAX_IDENTIFIER_LENGTH) {
        buffer[len++] = lex->current;
        lexer_next(lex);
    }
    
    // Validación de límite
    if (len >= MAX_IDENTIFIER_LENGTH && 
        (isalnum(lex->current) || lex->current == '_' || lex->current == '.')) {
        lexer_error(lex, "Identificador excede %d caracteres", 
                   MAX_IDENTIFIER_LENGTH);
        return;
    }
    
    buffer[len] = '\0';
    
    Token *tok = token_create(TOKEN_IDENTIFIER, buffer);
    lexer_add_token(lex, tok);
}
```

#### Test

```bash
# Generar ID muy largo
python3 -c "
with open('test_long_id.jasb', 'w') as f:
    f.write('variable ')
    f.write('a' * 1000)
    f.write(' = 5\\nfin_programa')
"

# Compilar - debe fallar con mensaje claro
jbc.exe test_long_id.jasb
# Esperado: "Error: Identificador excede 255 caracteres"
```

---

### TAREA 1.4: Fix Validación de .jbo (Hallazgo #4)

**Prioridad**: 🔴 ALTA  
**Duración**: 2 horas  
**Complejidad**: ⭐ Fácil

#### Cambios en ir_vm.c

**Archivo**: `sdk-dependiente/jasboot-ir/src/ir_vm.c`

```c
// Línea ~30 - AGREGAR
#define JASBOOT_MAGIC 0x4A424F42      // "JBOB"
#define JASBOOT_VERSION 1
#define MAX_BYTECODE_SIZE (50 * 1024 * 1024)

// Línea ~300 - REEMPLAZAR ir_read_bytecode
// (Ver HALLAZGOS_CRITICOS.md para código completo)
```

#### Test

```bash
# Crear archivo .jbo corrupto
python3 -c "
with open('test_corrupt.jbo', 'wb') as f:
    f.write(b'XXXX')  # Magic incorrecto
"

# Ejecutar VM - debe dar error claro
jasboot-ir-vm.exe test_corrupt.jbo
# Esperado: "[ERROR] Magic inválido"

# Crear archivo truncado
python3 -c "
with open('test_truncated.jbo', 'wb') as f:
    f.write(b'JBOB')  # Solo magic, nada más
"

jasboot-ir-vm.exe test_truncated.jbo
# Esperado: "[ERROR] Archivo truncado"
```

---

### TAREA 1.5: Fix realloc Safety (Hallazgo #5 - Bonus)

**Prioridad**: 🟠 ALTA  
**Duración**: 1 hora  
**Complejidad**: ⭐ Fácil

#### Cambios en symbol_table.c

**Archivo**: `sdk-dependiente/jas-compiler-c/src/symbol_table.c`

```c
// Línea ~X - MODIFICAR symbol_table_add
void symbol_table_add(SymbolTable *st, Symbol *sym) {
    if (st->count >= st->capacity) {
        size_t new_capacity = st->capacity * 2;
        Symbol *temp = realloc(st->symbols, new_capacity * sizeof(Symbol));
        
        if (!temp) {
            // realloc falló - dejar estado consistente
            fprintf(stderr, "ERROR: No se pudo expandir tabla de símbolos\n");
            return;  // NO asignar st->symbols = NULL
        }
        
        st->symbols = temp;
        st->capacity = new_capacity;
    }
    
    st->symbols[st->count++] = *sym;
}
```

---

## ✅ TESTING - FASE 1A

### Tests Críticos a Crear

#### 1. test_jmn_saturacion.jasb
```jasboot
programa
    crear_memoria("test_saturacion.jmn")
    
    variable contador = 0
    mientras contador < 1100 hacer
        texto concepto = concatenar("concepto_", convertir_texto(contador))
        recordar concepto con valor "dummy"
        contador = contador + 1
    fin_mientras
    
    cerrar_memoria()
    imprimir "✅ Test JMN saturación: PASSED"
fin_programa
```

#### 2. test_deep_nesting.jasb
```jasboot
programa
    variable x = 0
    si x == 0 entonces
        si x == 0 entonces
            si x == 0 entonces
                si x == 0 entonces
                    si x == 0 entonces
                        # ... repetir 100 veces ...
                        imprimir "ok"
                    fin_si
                fin_si
            fin_si
        fin_si
    fin_si
    
    imprimir "✅ Test anidamiento profundo: PASSED"
fin_programa
```

#### 3. test_invalid_bytecode.bash
```bash
#!/bin/bash
# Test: .jbo corrupto debe fallar gracefully

# Crear .jbo con magic incorrecto
python3 -c "import sys; sys.stdout.buffer.write(b'BADX' + b'\\x00'*100)" > bad_magic.jbo
jasboot-ir-vm.exe bad_magic.jbo 2>&1 | grep -q "Magic inválido" || exit 1

# Crear .jbo truncado
echo -n "JBOB" > truncated.jbo
jasboot-ir-vm.exe truncated.jbo 2>&1 | grep -q "truncado" || exit 1

echo "✅ Test bytecode inválido: PASSED"
```

### Matriz de Tests

| Test | Componente | Resultado Esperado | Status |
|------|-----------|-------------------|--------|
| test_jmn_saturacion | JMN | ✅ PASSED (sin hang) | ⏳ Pendiente |
| test_deep_nesting | Parser | ✅ PASSED (sin crash) | ⏳ Pendiente |
| test_long_identifier | Lexer | ❌ ERROR (mensaje claro) | ⏳ Pendiente |
| test_invalid_bytecode | VM | ❌ ERROR (validación) | ⏳ Pendiente |
| test_basic_math | VM | ✅ PASSED (baseline) | ⏳ Pendiente |

---

## 📊 PROGRESS TRACKING

### Checklist de Implementación

**Semana 1** (40 horas):

- [ ] **Lunes AM** (4h): JMN expandir tabla + compilación
  - [ ] Agregar función `jmn_expandir_tabla()`
  - [ ] Modificar `jmn_insertar_nodo()`
  - [ ] Compilar VM sin errores
  
- [ ] **Lunes PM** (4h): Stack overflow fix + testing
  - [ ] Modificar `parse_bloque()` con depth tracking
  - [ ] Agregar validaciones en parser.c
  - [ ] Compilar compilador sin errores

- [ ] **Martes AM** (4h): Buffer overflow + .jbo validation
  - [ ] Fix `lexer_read_identifier()`
  - [ ] Fix `ir_read_bytecode()`
  - [ ] Compilar todo

- [ ] **Martes PM** (4h): realloc + debugging
  - [ ] Fix `symbol_table_add()`
  - [ ] Fix otros realloc en codebase
  - [ ] Pruebas de comprobación

- [ ] **Miércoles AM** (4h): Tests críticos
  - [ ] Crear test_jmn_saturacion.jasb
  - [ ] Crear test_deep_nesting.jasb
  - [ ] Crear test_long_identifier.jasb
  - [ ] Crear test_invalid_bytecode.bash

- [ ] **Miércoles PM** (4h): Validación y debugging
  - [ ] Ejecutar todos los tests
  - [ ] Verificar que reproducen bugs originales
  - [ ] Ejecutar con fixes - deben pasar

- [ ] **Jueves AM** (4h): Documentación
  - [ ] Documentar todos los changes
  - [ ] Actualizar CHANGELOG
  - [ ] Crear issue de PR

- [ ] **Jueves PM** (4h): Code review + refinamiento
  - [ ] Self-review del código
  - [ ] Verificar calidad
  - [ ] Optimizar si es necesario

- [ ] **Viernes** (8h): Integración + Cleanup
  - [ ] Merge a rama principal
  - [ ] Verificar compilación final
  - [ ] Cleanup de archivos temporales
  - [ ] Backup de resultado

### KPIs de Éxito

```
ANTES DE FIXES          DESPUÉS DE FIXES
──────────────────     ──────────────────
Crashes: Frecuentes    Crashes: 0 (en tests)
Hangs: Sí (JMN)       Hangs: 0
Warnings: ~20         Warnings: 0
Test Pass Rate: ~80%  Test Pass Rate: 100%
Madurez: 35%          Madurez: 55-60%
```

---

## 🔧 COMANDOS DE BUILD/TEST

### Build Completo
```bash
cd c:\src\jasboot\sdk-dependiente

# Compilar compilador
cd jas-compiler-c
build.bat

# Compilar VM
cd ..\jasboot-ir
build_vm.bat

# Compilar JMN
cd ..\jasboot-jmn-core
# (si tiene build script)

echo "✅ Build completo exitoso"
```

### Test Rápido
```bash
# Compilar y ejecutar test de basicidad
node .vscode/run-jasb.cjs tests/test_basico.jasb

# Correr test de JMN
node .vscode/run-jasb.cjs build\test_jmn.jbo
```

### Validación de Fixes
```bash
# Test 1: JMN no cuelga
timeout 30 node .vscode/run-jasb.cjs test_jmn_saturacion.jasb

# Test 2: Parser no stack overflow
timeout 30 jbc.exe test_deep_nesting.jasb

# Test 3: Lexer rechaza ID largo
jbc.exe test_long_id.jasb 2>&1 | grep -i "excede"

# Test 4: VM rechaza .jbo corrupto
jasboot-ir-vm.exe bad_magic.jbo 2>&1 | grep -i "inválido"
```

---

## 📈 MÉTRICAS DE ÉXITO

### Antes de Fase 1A
```
Componente          Robustez    Test Pass   Status
──────────────────────────────────────────────────
JMN                 64%         60%         ⚠️  Frágil
Parser              65%         55%         ⚠️  Inestable
Lexer               70%         65%         🟡 Aceptable
VM                  86%         85%         ✅ Buena
PROMEDIO            68%         66%         ⚠️  PREOCUPANTE
```

### Después de Fase 1A (Meta)
```
Componente          Robustez    Test Pass   Status
──────────────────────────────────────────────────
JMN                 82%         85%         ✅ Buena
Parser              78%         80%         ✅ Buena
Lexer               85%         90%         ✅ Excelente
VM                  88%         90%         ✅ Excelente
PROMEDIO            83%         86%         ✅ SOLID
```

---

## 🚀 SIGUIENTE: FASE 1B (Semanas 2-3)

Después de completar Fase 1A:

1. **Expansión de Tests** (80 horas)
   - Tests de componentes individuales
   - Tests de integración
   - Tests E2E completos

2. **Fuzzing** (20 horas)
   - Setup AFL++
   - Fuzzing de compilador
   - Fuzzing de VM

3. **Memory Sanitizers** (15 horas)
   - Valgrind para memory leaks
   - AddressSanitizer (ASan)
   - Verificación de correctness

4. **Performance Baseline** (10 horas)
   - Benchmarks pre/post fix
   - Verificar sin regresiones

---

## 📞 CONTACTOS Y REFERENCIAS

**AGENTS.md**: Guía de arquitectura  
**HALLAZGOS_CRITICOS.md**: Detalles técnicos de cada bug  
**ANALISIS_ROBUSTEZ_COMPLETO.md**: Análisis general  

---

**Documento Creado**: 2026-04-25  
**Versión**: 1.0  
**Próxima Revisión**: Después de Fase 1A
