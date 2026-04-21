---
name: "JMN Neural Memory System"
description: "Rules for developing and using Jasboot Neural Memory (JMN)"
activation: "glob"
glob: "sdk-dependiente/jasboot-jmn-core/**/*.c,**/*.jasb"
priority: 95
---

# JMN (Jasboot Memory Neural) Development Rules

Rules for developing and using the Jasboot Neural Memory system - a persistent associative memory system for AI applications.

## JMN Architecture Overview

JMN is a graph-based persistent memory system where:
- **Nodes** represent concepts (identified by 32-bit hash IDs)
- **Connections** represent weighted relationships between nodes
- **Text Storage** maps hash IDs to human-readable strings
- **Persistence** saves everything to binary `.jmn` files

### Core Data Structures

```c
typedef struct {
    uint32_t id;              // Concept ID (hash)
    JMNValor peso;            // Node weight (float)
    uint32_t num_conexiones;  // Connection count
    JMNConexion* conexiones;  // Array of connections
} JMNNodo;

typedef struct {
    uint32_t id_destino;      // Target node ID
    JMNValor peso;            // Connection weight (0.0-1.0)
    uint8_t tipo_relacion;    // Relation type (1-7)
} JMNConexion;

typedef struct {
    uint32_t id;              // Concept ID
    char texto[256];          // Text content
} JMNTexto;
```

## JMN Operation Patterns

### Memory Lifecycle

```c
// 1. Create/Open Memory
JMNMemoria* mem = jmn_crear("database.jmn");
if (!mem) {
    // Handle error
}

// 2. Add Nodes
jmn_agregar_nodo(mem, hash_id, valor);

// 3. Add Connections
jmn_agregar_conexion(mem, id_origen, id_destino, peso, tipo_relacion);

// 4. Store Text
jmn_guardar_texto(mem, hash_id, "texto asociado");

// 5. Save to Disk
jmn_consolidar(mem);

// 6. Close Memory
jmn_cerrar(mem);
```

### CRITICAL: Always Close Memory

**NEVER leave memory open without consolidating/closing**:

```c
// ❌ WRONG - Memory leak and potential corruption
JMNMemoria* mem = jmn_crear("data.jmn");
jmn_agregar_nodo(mem, id, val);
// Missing jmn_cerrar(mem)!

// ✅ CORRECT - Always close
JMNMemoria* mem = jmn_crear("data.jmn");
if (mem) {
    jmn_agregar_nodo(mem, id, val);
    jmn_consolidar(mem);
    jmn_cerrar(mem);
}
```

## Relation Types

JMN supports 7 types of relationships:

| Type | Constant | Description | Example |
|------|----------|-------------|---------|
| 1 | `JMN_RELACION_ASOCIACION` | General association | "dog" ↔ "animal" |
| 2 | `JMN_RELACION_SECUENCIA` | Sequential order | Step 1 → Step 2 |
| 3 | `JMN_RELACION_SIMILITUD` | Similarity | "cat" ≈ "dog" |
| 4 | `JMN_RELACION_DIFERENCIA` | Opposition | "hot" ≠ "cold" |
| 5 | `JMN_RELACION_PARTE_DE` | Part-whole | "wheel" ⊂ "car" |
| 6 | `JMN_RELACION_INSTANCIA_DE` | Instance-class | "Fido" ∈ "dog" |
| 7 | `JMN_RELACION_PATRON` | Pattern/template | Episode pattern |

### Using Relation Types

```c
// Association: general relationship
jmn_agregar_conexion(mem, id_perro, id_animal, peso_0_9, JMN_RELACION_ASOCIACION);

// Sequence: ordered steps
jmn_agregar_conexion(mem, id_paso1, id_paso2, peso_1_0, JMN_RELACION_SECUENCIA);

// Similarity: concepts are similar
jmn_agregar_conexion(mem, id_gato, id_perro, peso_0_7, JMN_RELACION_SIMILITUD);
```

## Text Storage Rules

### Always Sync Text to JMN

When creating nodes from text, ALWAYS save the text:

```c
// ✅ CORRECT - Text is persisted
uint32_t id = hash_texto("some text");
jmn_agregar_nodo(mem, id, valor);
jmn_guardar_texto(mem, id, "some text");  // CRITICAL

// ❌ WRONG - Text will be lost
uint32_t id = hash_texto("some text");
jmn_agregar_nodo(mem, id, valor);
// Missing jmn_guardar_texto()!
```

### Text Retrieval Pattern

```c
// Check cache first, then JMN
const char* text = vm_text_cache_get(vm, id);
if (!text || !text[0]) {
    char buffer[512];
    if (jmn_obtener_texto(mem, id, buffer, sizeof(buffer)) >= 0) {
        // Update cache for future use
        vm_text_cache_put(vm, id, buffer);
        text = vm_text_cache_get(vm, id);
    }
}
```

## Search Operations

### Basic Association Search

```c
// Search for associated concepts
JMNBusquedaResultado resultados[32];
int n = jmn_buscar_asociaciones(
    mem,
    id_origen,           // Starting concept
    tipo_relacion,       // Relation type (0 = any)
    umbral,              // Minimum weight threshold (0.0-1.0)
    profundidad,         // Search depth (1-10)
    resultados,          // Output array
    32                   // Max results
);

// Process results
for (int i = 0; i < n; i++) {
    uint32_t found_id = resultados[i].id;
    float strength = resultados[i].fuerza;
    
    // Get text for the concept
    char texto[256];
    jmn_obtener_texto(mem, found_id, texto, sizeof(texto));
}
```

### Search Parameters

- **umbral** (threshold): Minimum connection weight (0.0 = any, 0.9 = very strong)
- **profundidad** (depth): How many hops to traverse (1 = direct neighbors only)
- **tipo_relacion**: Filter by relation type (0 = all types)

```c
// Find directly related concepts with any strength
jmn_buscar_asociaciones(mem, id, 0, 0.0f, 1, res, 32);

// Find strongly related concepts within 2 hops
jmn_buscar_asociaciones(mem, id, 0, 0.7f, 2, res, 32);

// Find only sequential relationships
jmn_buscar_asociaciones(mem, id, JMN_RELACION_SECUENCIA, 0.0f, 1, res, 32);
```

## Connection Weight Management

### Weight Ranges

Weights should be in range [0.0, 1.0]:

```c
// ✅ CORRECT - Valid weights
jmn_agregar_conexion(mem, a, b, 0.9f, tipo);   // Strong
jmn_agregar_conexion(mem, a, b, 0.5f, tipo);   // Medium
jmn_agregar_conexion(mem, a, b, 0.1f, tipo);   // Weak

// ❌ WRONG - Out of range
jmn_agregar_conexion(mem, a, b, 1.5f, tipo);   // > 1.0
jmn_agregar_conexion(mem, a, b, -0.5f, tipo);  // < 0.0
```

### Decay and Reinforcement

```c
// Decay all connections by 5% above threshold 0.01
jmn_decaer_conexiones_global(mem, 0.95f, 1, 0.01f);

// Reinforce a specific connection
float current_weight = jmn_obtener_fuerza_asociacion(mem, id_a, id_b, tipo);
float new_weight = current_weight + 0.1f;
if (new_weight > 1.0f) new_weight = 1.0f;
jmn_actualizar_peso_conexion(mem, id_a, id_b, new_weight, tipo);
```

## File Format (Binary .jmn)

### Header Structure

```
Offset | Size | Description
-------|------|-------------
0x00   | 4    | Magic: "JMN1" (0x314E4D4A)
0x04   | 4    | Node count
0x08   | 4    | Connection count
0x0C   | 4    | Text entry count
```

### Data Integrity

Always validate file integrity:

```c
// Check magic number
if (header.magic != JMN_MAGIC) {
    fprintf(stderr, "[JMN ERROR] Invalid file format\n");
    return NULL;
}

// Validate counts
if (header.num_nodos > JMN_MAX_NODOS) {
    fprintf(stderr, "[JMN ERROR] Too many nodes: %u\n", header.num_nodos);
    return NULL;
}
```

## Memory Management

### Allocation Limits

```c
#define JMN_MAX_NODOS      100000   // Max nodes
#define JMN_MAX_CONEXIONES 1000000  // Max connections
#define JMN_MAX_TEXTOS     50000    // Max text entries
```

### Memory Consolidation

Consolidate periodically to prevent data loss:

```c
// In long-running programs
for (int i = 0; i < operations; i++) {
    jmn_agregar_nodo(mem, id, val);
    
    // Consolidate every 1000 operations
    if (i % 1000 == 0) {
        jmn_consolidar(mem);
    }
}
```

## Error Handling

### Return Value Conventions

JMN functions return:
- `0` or positive: success
- `-1`: general error
- `NULL`: allocation failure or invalid state

```c
// Check return values
int result = jmn_guardar_texto(mem, id, texto);
if (result < 0) {
    fprintf(stderr, "[JMN ERROR] Failed to save text for ID %u\n", id);
    // Handle error
}

// Check pointer returns
JMNNodo* nodo = jmn_obtener_nodo(mem, id);
if (!nodo) {
    fprintf(stderr, "[JMN ERROR] Node %u not found\n", id);
    // Handle error
}
```

## Common Patterns

### Pattern 1: Key-Value Storage

```c
// Store key-value pair
uint32_t key_id = hash_texto("username");
uint32_t val_id = hash_texto("john_doe");

jmn_agregar_nodo(mem, key_id, valor_medio);
jmn_agregar_nodo(mem, val_id, valor_medio);
jmn_guardar_texto(mem, key_id, "username");
jmn_guardar_texto(mem, val_id, "john_doe");

// Create association (type 1)
jmn_agregar_conexion(mem, key_id, val_id, 0.9f, JMN_RELACION_ASOCIACION);

// Retrieve value
JMNBusquedaResultado res[32];
int n = jmn_buscar_asociaciones(mem, key_id, JMN_RELACION_ASOCIACION, 0.01f, 1, res, 32);
if (n > 0) {
    char value_text[256];
    jmn_obtener_texto(mem, res[0].id, value_text, sizeof(value_text));
}
```

### Pattern 2: Concept Hierarchy

```c
// Create hierarchy: Animal > Mammal > Dog > Fido
uint32_t id_animal = hash_texto("animal");
uint32_t id_mammal = hash_texto("mammal");
uint32_t id_dog = hash_texto("dog");
uint32_t id_fido = hash_texto("fido");

// Store texts
jmn_guardar_texto(mem, id_animal, "animal");
jmn_guardar_texto(mem, id_mammal, "mammal");
jmn_guardar_texto(mem, id_dog, "dog");
jmn_guardar_texto(mem, id_fido, "fido");

// Create hierarchy links (part-of relationships)
jmn_agregar_conexion(mem, id_mammal, id_animal, 0.95f, JMN_RELACION_PARTE_DE);
jmn_agregar_conexion(mem, id_dog, id_mammal, 0.9f, JMN_RELACION_PARTE_DE);
jmn_agregar_conexion(mem, id_fido, id_dog, 1.0f, JMN_RELACION_INSTANCIA_DE);
```

### Pattern 3: Sequential Steps

```c
// Create sequence: Step1 -> Step2 -> Step3
uint32_t steps[3] = {
    hash_texto("open_file"),
    hash_texto("read_data"),
    hash_texto("close_file")
};

// Store texts
for (int i = 0; i < 3; i++) {
    jmn_guardar_texto(mem, steps[i], step_names[i]);
}

// Create sequence links
jmn_agregar_conexion(mem, steps[0], steps[1], 1.0f, JMN_RELACION_SECUENCIA);
jmn_agregar_conexion(mem, steps[1], steps[2], 1.0f, JMN_RELACION_SECUENCIA);
```

## Debugging JMN

### Debug Logging

```c
// Enable detailed JMN logging
#define JMN_DEBUG 1

// Log operations
if (getenv("JASBOOT_DEBUG")) {
    printf("[JMN DEBUG] Adding node: id=0x%08x, peso=%.2f\n", id, peso.f);
    printf("[JMN DEBUG] Adding connection: %u -> %u (weight=%.2f, type=%d)\n",
           id_origen, id_destino, peso.f, tipo_relacion);
}
```

### Inspection Tools

```c
// Print memory statistics
void jmn_print_stats(JMNMemoria* mem) {
    if (!mem) return;
    
    printf("=== JMN Statistics ===\n");
    printf("Nodes: %u / %u\n", mem->num_nodos, JMN_MAX_NODOS);
    printf("Connections: %zu\n", mem->total_conexiones);
    printf("Text entries: %u / %u\n", mem->num_textos, JMN_MAX_TEXTOS);
    
    // Calculate average connections per node
    if (mem->num_nodos > 0) {
        float avg = (float)mem->total_conexiones / mem->num_nodos;
        printf("Avg connections per node: %.2f\n", avg);
    }
}
```

### File Inspection

```bash
# Dump JMN file header
hexdump -C database.jmn | head -20

# Check magic number (should be "JMN1")
xxd -l 4 database.jmn

# Extract node count (bytes 4-7, little-endian)
xxd -s 4 -l 4 database.jmn
```

## Performance Optimization

### Batch Operations

```c
// ✅ EFFICIENT - Batch then consolidate
for (int i = 0; i < 1000; i++) {
    jmn_agregar_nodo(mem, ids[i], valores[i]);
}
jmn_consolidar(mem);

// ❌ INEFFICIENT - Consolidate per operation
for (int i = 0; i < 1000; i++) {
    jmn_agregar_nodo(mem, ids[i], valores[i]);
    jmn_consolidar(mem);  // TOO FREQUENT
}
```

### Cache Utilization

```c
// Reuse text cache to avoid JMN lookups
const char* text = vm_text_cache_get(vm, id);
if (text) {
    // Fast path - use cached text
    return text;
}

// Slow path - fetch from JMN and cache
char buffer[512];
if (jmn_obtener_texto(mem, id, buffer, sizeof(buffer)) >= 0) {
    vm_text_cache_put(vm, id, buffer);
    return vm_text_cache_get(vm, id);
}
```

## Common Pitfalls

### Pitfall 1: Text Not Persisted

```c
// ❌ WRONG - Text lost after restart
uint32_t id = hash_texto("important");
jmn_agregar_nodo(mem, id, val);
// Missing jmn_guardar_texto()!

// ✅ CORRECT - Text persisted
uint32_t id = hash_texto("important");
jmn_agregar_nodo(mem, id, val);
jmn_guardar_texto(mem, id, "important");
```

### Pitfall 2: Forgetting to Consolidate

```c
// ❌ WRONG - Changes lost on crash
jmn_agregar_nodo(mem, id, val);
jmn_cerrar(mem);  // Doesn't save changes!

// ✅ CORRECT - Consolidate before close
jmn_agregar_nodo(mem, id, val);
jmn_consolidar(mem);
jmn_cerrar(mem);
```

### Pitfall 3: Invalid Weight Range

```c
// ❌ WRONG - Weight out of range
float weight = calculate_weight();  // Returns 1.5
jmn_agregar_conexion(mem, a, b, weight, tipo);

// ✅ CORRECT - Clamp to valid range
float weight = calculate_weight();
if (weight > 1.0f) weight = 1.0f;
if (weight < 0.0f) weight = 0.0f;
jmn_agregar_conexion(mem, a, b, weight, tipo);
```

### Pitfall 4: Memory Corruption

```c
// ❌ WRONG - Unsafe iteration during modification
for (int i = 0; i < mem->num_nodos; i++) {
    if (should_delete(mem->nodos[i])) {
        jmn_eliminar_nodo(mem, mem->nodos[i].id);  // CORRUPTS ARRAY
    }
}

// ✅ CORRECT - Collect IDs first, then delete
uint32_t to_delete[1000];
int count = 0;
for (int i = 0; i < mem->num_nodos && count < 1000; i++) {
    if (should_delete(mem->nodos[i])) {
        to_delete[count++] = mem->nodos[i].id;
    }
}
for (int i = 0; i < count; i++) {
    jmn_eliminar_nodo(mem, to_delete[i]);
}
```

## Testing JMN

### Test Checklist

- [ ] Create/open memory file
- [ ] Add nodes with text
- [ ] Create connections
- [ ] Search associations
- [ ] Retrieve text by ID
- [ ] Consolidate changes
- [ ] Close and reopen file
- [ ] Verify data persists across sessions
- [ ] Test with empty/corrupted files
- [ ] Test with maximum capacity

### Example Test

```c
void test_jmn_basic() {
    // Setup
    JMNMemoria* mem = jmn_crear("test.jmn");
    assert(mem != NULL);
    
    // Add node with text
    uint32_t id = hash_texto("test");
    jmn_agregar_nodo(mem, id, valor_medio);
    jmn_guardar_texto(mem, id, "test");
    
    // Verify text retrieval
    char buffer[256];
    int result = jmn_obtener_texto(mem, id, buffer, sizeof(buffer));
    assert(result >= 0);
    assert(strcmp(buffer, "test") == 0);
    
    // Save and close
    jmn_consolidar(mem);
    jmn_cerrar(mem);
    
    // Reopen and verify persistence
    mem = jmn_crear("test.jmn");
    assert(mem != NULL);
    
    result = jmn_obtener_texto(mem, id, buffer, sizeof(buffer));
    assert(result >= 0);
    assert(strcmp(buffer, "test") == 0);
    
    jmn_cerrar(mem);
    printf("✅ JMN basic test passed\n");
}
```

---

**Remember**: JMN is a persistent storage system. Always consolidate changes before closing, and verify data persistence in your tests. Memory corruption in JMN can lose valuable data.