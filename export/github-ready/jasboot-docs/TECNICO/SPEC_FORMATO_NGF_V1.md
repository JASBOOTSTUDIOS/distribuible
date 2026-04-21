# Especificación del formato de archivo .ngf (n_grafo) v1

Formato binario para almacenar grafos de triples (S, P, O). Extensión recomendada: `.ngf` (n_grafo file).

---

## 1. Cabecera (Header)

| Offset | Tamaño | Campo      | Descripción                                   |
|--------|--------|------------|-----------------------------------------------|
| 0      | 4      | magic      | `0x4E 0x47 0x46 0x31` = "NGF1" (N-GraFo v1)   |
| 4      | 1      | version    | Versión del formato (1 = v1)                  |
| 5      | 1      | flags      | Reservado (0)                                 |
| 6      | 2      | reserved   | Reservado (0)                                 |
| 8      | 4      | vocab_off  | Offset de la tabla de vocabulario (bytes)     |
| 12     | 4      | vocab_len  | Tamaño de la tabla de vocabulario (bytes)     |
| 16     | 4      | triples_off| Offset de la tabla de triples (bytes)         |
| 20     | 4      | triples_len| Tamaño de la tabla de triples (bytes)         |
| 24     | 4      | next_id    | Próximo ID libre para conceptos               |

**Tamaño total del header:** 28 bytes.

**Endianness:** Little-endian (compatible con x86/ARM).

---

## 2. Tabla de vocabulario

Cada entrada tiene estructura variable:

| Campo    | Tamaño  | Descripción                              |
|----------|---------|------------------------------------------|
| id       | 4 bytes | ID del concepto (uint32_t)               |
| hash     | 4 bytes | Hash del texto normalizado (uint32_t)    |
| text_len | 2 bytes | Longitud del texto en bytes (uint16_t)   |
| text     | N bytes | Texto normalizado (UTF-8, sin nul final) |

Las entradas se almacenan secuencialmente. El índice por hash se construye en memoria al cargar; no se persiste para facilitar append.

---

## 3. Tabla de triples

Cada entrada fija de 13 bytes:

| Campo | Tamaño  | Descripción                    |
|-------|---------|--------------------------------|
| S     | 4 bytes | ID del sujeto (uint32_t)       |
| P     | 4 bytes | ID del predicado (uint32_t)    |
| O     | 4 bytes | ID del objeto (uint32_t)       |
| peso  | 1 byte  | Peso opcional 0-255 (uint8_t)  |

Orden de almacenamiento: (S, P, O) para permitir búsqueda secuencial eficiente.

---

## 4. Magic y constantes

```c
#define NGF_MAGIC_0 0x4E  // 'N'
#define NGF_MAGIC_1 0x47  // 'G'
#define NGF_MAGIC_2 0x46  // 'F'
#define NGF_MAGIC_3 0x31  // '1'

#define NGF_VERSION_1 1
#define NGF_HEADER_SIZE 28
#define NGF_TRIPLE_SIZE 13
```

---

## 5. Normalización de texto

Antes de insertar en vocabulario:

- Convertir a minúsculas (UTF-8 safe)
- Opcional: eliminar acentos (NFD + strip combining)
- Trim de espacios al inicio/final

---

## 6. Hash

Se usa FNV-1a de 32 bits para búsqueda rápida. El hash se calcula sobre el texto normalizado.

---

## 7. Índices en memoria (Fase 4)

Los índices **no se persisten en disco**; se reconstruyen al abrir el grafo recorriendo la tabla de triples. Esto permite búsquedas en O(1) amortizado.

### 7.1 Estructura elegida: hash map con encadenamiento

Se usa **tabla hash con encadenamiento** (chaining):

- **Buckets:** 8192 (`NGF_INDEX_BUCKETS`)
- **Función hash:** variante de FNV sobre claves de 64 bits
- **Colisiones:** lista enlazada de nodos en cada bucket

### 7.2 Índices implementados

| Índice | Clave | Valor | Uso |
|--------|-------|-------|-----|
| `sp_index` | (S,P) empaquetado en 64 bits | Lista de O | `n_buscar_objeto`, `n_buscar_objetos` |
| `po_index` | (P,O) empaquetado en 64 bits | Lista de S | `n_buscar_sujeto`, `n_buscar_sujetos` |
| `o_index` | O | Lista de (S,P) empaquetados | `n_buscar_donde_aparece` |

### 7.3 Empaquetado de claves

- `NGF_KEY_SP(s,p) = ((uint64_t)s << 32) | p`
- `NGF_KEY_PO(p,o) = ((uint64_t)p << 32) | o`
- El índice O almacena `NGF_KEY_SP(s,p)` por cada triple donde O es objeto.

### 7.4 Coste de operaciones

| Operación | Sin índices | Con índices |
|-----------|-------------|-------------|
| `n_buscar_objeto` | O(n) | O(1) amortizado |
| `n_buscar_sujeto` | O(n) | O(1) amortizado |
| `n_buscar_donde_aparece` | O(n) | O(1) amortizado |
| `n_recordar` | O(1) | O(1) + actualización índices |
| `n_olvidar_triple` | O(n) | O(n) localización + O(k) actualización índices |

### 7.5 Alternativas consideradas

- **B-tree:** Mejor para rangos ordenados; no necesario para consultas exactas por (S,P) o (P,O).
- **Bloques ordenados:** Requiere mantenimiento costoso en inserciones.
- **Hash map:** Elegido por O(1) para consultas exactas y mantenimiento sencillo.

---

## 8. Fase 6: Persistencia y escalado

### 8.1 Memory-mapped I/O (6.1)

En plataformas POSIX (Linux, macOS), al abrir un archivo existente se usa `mmap()` para:

- **Triples:** Acceso directo al archivo mapeado, sin copiar a RAM. El sistema operativo carga páginas bajo demanda.
- **Vocabulario:** Se parsea desde el mmap; el texto se copia para añadir `\0` (el formato no incluye nul final).

En Windows se usa la carga tradicional (fread). Cuando se añade o elimina un triple, los triples se copian de mmap a `malloc` antes de modificar.

### 8.2 Bloques ordenados (6.2)

Al guardar, los triples se ordenan por `(S, P, O)` antes de escribir. Esto permite:

- Búsqueda secuencial eficiente por (S, P).
- Mejor compresión (valores consecutivos similares).
- Agrupación natural en bloques lógicos por sujeto-predicado.

### 8.3 Compresión opcional (6.3)

El campo `flags` del header reserva el bit 0 para compresión:

| Bit | Nombre | Descripción |
|-----|--------|-------------|
| 0 | `NGF_FLAG_COMPRESSED` | Si 1, la sección de triples está comprimida (LZ4 o Zstd) |

**Estado actual:** El bit no se usa; compresión futura. Para habilitarla se requeriría enlazar LZ4 o Zstd y comprimir/descomprimir la sección de triples.

### 8.4 Particionado (6.4)

Véase [`ESTRATEGIA_PARTICIONADO_N_GRAFO.md`](ESTRATEGIA_PARTICIONADO_N_GRAFO.md).

---

## 9. Fase 7: Caché y optimización

### 9.1 Caché LRU (7.1)

- **API:** `n_configurar_cache_lru(g, tamano)` — tamano 0 desactiva.
- Almacena los conceptos más consultados para acelerar `n_obtener_id` y `n_grafo_resolver_id`.
- Tamaño recomendado: 64–1024 entradas.

### 9.2 Bloom filter (7.2)

- **API:** `n_configurar_bloom(g, num_bits)` — 0 desactiva.
- Respuesta rápida "definitivamente no existe" en `n_existe_concepto` sin recorrer el vocabulario.
- Tamaño sugerido: ~8–10 bits por concepto (~1 % falsos positivos).

### 9.3 Cuantificación de pesos (7.3)

- Pesos en `uint8_t` (0–255). Sin floats.
- Formato de triple: S, P, O (4+4+4 bytes) + peso (1 byte) = 13 bytes.

---

**Última actualización:** 2026-02-18
