# Checklist: Conceptos optimizados (grafo de triples) — v1

Ruta de implementación en orden de prioridad. **No se modifican** las funcionalidades existentes (`recordar`, `buscar`, `crear_memoria`, etc.). Todas las nuevas construcciones usan el prefijo `n_` para evitar colisiones con el lenguaje actual.

**Referencia de diseño:** Respuesta sobre almacenamiento optimizado de conceptos (triples, IDs, índices, sin ML).

**Documentación Fase 8:** [`COEXISTENCIA_MEMORIA_N_GRAFO.md`](COEXISTENCIA_MEMORIA_N_GRAFO.md)

**Documentación Fase 9:** [`PREDICADOS_ESTANDAR_N_GRAFO.md`](PREDICADOS_ESTANDAR_N_GRAFO.md)

**Tests:** `run_tests_n_grafo.bat`
- 112 tests robustez (NULL, vacíos, truncado, límites, ciclos, duplicados)
- Test estrés: 1000 conceptos, 5000 triples, persistencia, n_heredar 32 niveles
- Verificación sistema_llamadas (23 funciones n_*)

---

## Fase 1: Modelo de datos e infraestructura base

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 1.1 | Definir formato de archivo `n_grafo` | Especificar formato binario para almacenar grafo de triples (magic, versión, cabecera). Ruta sugerida: `.ngf` (n_grafo file). | ✅ |
| 1.2 | Tabla de vocabulario (string ↔ ID) | Estructura: ID (4B), hash (4B), longitud texto (1-2B), texto normalizado. Hash para búsqueda rápida. | ✅ |
| 1.3 | Tabla de triples | Estructura: S (4B), P (4B), O (4B), peso opcional (1B). Orden sugerido: (S, P, O). | ✅ |
| 1.4 | Función `n_abrir_grafo(ruta)` | Abre/crea archivo de grafo. No interfiere con `crear_memoria`. Devuelve handle. | ✅ |
| 1.5 | Función `n_cerrar_grafo(handle)` | Cierra grafo y persiste cambios. No interfiere con `cerrar_memoria`. | ✅ |
| 1.6 | Normalización de texto | Función interna: minúsculas, forma canónica (opcional: quitar acentos). Usada antes de insertar en vocabulario. | ✅ |

---

## Fase 2: Vocabulario (conceptos como IDs)

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 2.1 | `n_obtener_id(grafo, texto)` | Resuelve texto → ID. Si no existe, lo crea y devuelve nuevo ID. Resultado en `resultado`. | ✅ |
| 2.2 | `n_obtener_texto(grafo, id)` | Resuelve ID → texto. Si no existe, devuelve vacío o error según contrato. Resultado en `resultado`. | ✅ |
| 2.3 | `n_existe_concepto(grafo, texto)` | Comprueba si el concepto existe en vocabulario. Devuelve verdadero/falso. Sin crear. | ✅ |
| 2.4 | Índice hash para vocabulario | Permite búsqueda O(1) o O(log n) por hash del texto normalizado. | ✅ |

---

## Fase 3: Operaciones sobre triples

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 3.1 | `n_recordar(grafo, sujeto, predicado, objeto)` | Inserta triple (S, P, O). S, P, O pueden ser texto (se resuelven a ID) o entero (ID directo). Equivalente conceptual a `recordar` pero para triples. | ✅ |
| 3.2 | `n_recordar_peso(grafo, sujeto, predicado, objeto, peso)` | Igual que `n_recordar` con peso opcional (0-255). | ✅ |
| 3.3 | `n_buscar_objeto(grafo, sujeto, predicado)` | Busca triples (S, P, ?). Devuelve lista de objetos o primer objeto. Resultado en `resultado`. No confunde con `buscar`. | ✅ |
| 3.4 | `n_buscar_sujeto(grafo, predicado, objeto)` | Busca triples (?, P, O). Devuelve lista de sujetos. | ✅ |
| 3.5 | `n_buscar_predicados(grafo, sujeto)` | Lista todos los predicados que tiene un sujeto. Para inspección del grafo. | ✅ |
| 3.6 | `n_olvidar_triple(grafo, sujeto, predicado, objeto)` | Elimina o debilita un triple específico. No interfiere con `olvidar`. | ✅ |

---

## Fase 4: Índices para búsqueda eficiente

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 4.1 | Índice (S, P) → lista de O | Permite `n_buscar_objeto` en O(log n) o O(1). | ✅ |
| 4.2 | Índice (P, O) → lista de S | Permite `n_buscar_sujeto` en O(log n) o O(1). | ✅ |
| 4.3 | Índice (O) → lista de (S, P) | Para consultas inversas: “¿dónde aparece este concepto?”. | ✅ |
| 4.4 | Estructura de índices | Decidir: B-tree, hash map, o bloques ordenados. Documentar elección. | ✅ |

---

## Fase 5: API de alto nivel (comodidades)

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 5.1 | `n_recordar_triple_texto(grafo, s_texto, p_texto, o_texto)` | Variante que acepta tres textos. Traduce a IDs internamente y llama a `n_recordar`. | ✅ |
| 5.2 | `n_buscar_objeto_texto(grafo, s_texto, p_texto)` | Devuelve objeto(s) como texto (resuelve ID→texto). | ✅ |
| 5.3 | `n_lista_triples(grafo, sujeto)` | Devuelve todos los (P, O) para un sujeto. Útil para inspección. | ✅ |
| 5.4 | `n_tamano_grafo(grafo)` | Devuelve número de triples (y opcionalmente de conceptos). Para estadísticas. | ✅ |

---

## Fase 6: Persistencia y escalado

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 6.1 | Memory-mapped I/O | Usar `mmap` (o equivalente) para acceso bajo demanda. No cargar todo en RAM. | ✅ |
| 6.2 | Bloques ordenados | Almacenar triples en bloques ordenados por (S, P) para compresión y búsqueda secuencial. | ✅ |
| 6.3 | Compresión opcional | Soporte para bloques comprimidos (LZ4/Zstd) con flag en cabecera. Desactivable. | ✅ |
| 6.4 | Particionado (futuro) | Documentar estrategia de partición por dominio (geografía, biología, etc.) para datasets grandes. | ✅ |

---

## Fase 7: Caché y optimización

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 7.1 | Caché LRU para vocabulario | Conceptos más usados en RAM. Tamaño configurable. | ✅ |
| 7.2 | Bloom filter | Para “¿existe concepto X?” sin acceder a disco cuando no está. Reducir I/O. | ✅ |
| 7.3 | Cuantificación de pesos | Usar `uint8` (0-255) para pesos. Sin floats. | ✅ |

---

## Fase 8: Integración con el lenguaje (sin romper existente)

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 8.1 | Registrar `n_*` como funciones de sistema | Añadir al compilador/VM sin tocar `recordar`, `buscar`, `crear_memoria`, etc. | ✅ |
| 8.2 | Documentar coexistencia | El programa puede usar `crear_memoria` + `recordar` y además `n_abrir_grafo` + `n_recordar`. Son independientes. | ✅ |
| 8.3 | Módulo opcional `n_grafo.jasb` | Wrapper en Jasboot que expone las funciones `n_*` si no están en el núcleo. | ✅ |

---

## Fase 9: Herencia y razonamiento (opcional)

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 9.1 | Predicado reservado `n_es_un` | Convención: (X, n_es_un, Y) significa X es tipo de Y. | ✅ |
| 9.2 | `n_heredar(grafo, sujeto, predicado)` | Si (S, n_es_un, T) y (T, P, O), devuelve O. Búsqueda transitiva. | ✅ |
| 9.3 | Documentar predicados estándar | `n_es_un`, `n_tipo_de`, `n_tiene`, etc. Como convención, no keywords. | ✅ |

---

## Glosario de nombres nuevos (prefijo `n_`)

| Nombre nuevo | Evita conflicto con | Descripción |
|--------------|---------------------|-------------|
| `n_abrir_grafo` | `crear_memoria` | Abre archivo de grafo de triples |
| `n_cerrar_grafo` | `cerrar_memoria` | Cierra y persiste grafo |
| `n_recordar` | `recordar` | Inserta triple (S, P, O) |
| `n_recordar_triple_texto` | *(alias)* | Variante de n_recordar con tres textos |
| `n_buscar_objeto` | `buscar` | Busca objeto(s) dado S y P |
| `n_buscar_objeto_texto` | *(nuevo)* | Busca objeto y devuelve como texto |
| `n_buscar_sujeto` | `buscar` | Busca sujeto(s) dado P y O |
| `n_olvidar_triple` | `olvidar` | Elimina/debilita triple |
| `n_obtener_id` | *(nuevo)* | Texto → ID de concepto |
| `n_obtener_texto` | `obtener_nombre_concepto` | ID → texto |
| `n_existe_concepto` | *(nuevo)* | ¿Existe concepto en vocabulario? |
| `n_recordar_peso` | `aprender`, `aprender_peso` | Triple con peso |
| `n_buscar_predicados` | *(nuevo)* | Lista predicados de un sujeto |
| `n_buscar_donde_aparece` | *(nuevo)* | ¿Dónde aparece concepto como objeto? Consulta inversa O→(S,P) |
| `n_lista_triples` | `obtener_relacionados` | Lista (P,O) de un sujeto |
| `n_tamano_grafo` | *(nuevo)* | Estadísticas del grafo |
| `n_heredar` | *(nuevo)* | Razonamiento transitivo vía n_es_un. Devuelve ID. |
| `n_heredar_texto` | *(nuevo)* | Igual que n_heredar, devuelve objeto como texto |

---

## Regla de oro

**Ninguna tarea de este checklist debe alterar el comportamiento de:**

- `recordar`, `buscar`, `aprender`, `olvidar`, `pensar`
- `crear_memoria`, `cerrar_memoria`
- `mem_crear`, `mem_cerrar`, `mem_asociar`
- `crear_concepto`, `propiedad_concepto`, `define_concepto`
- `obtener_todos_conceptos`, `obtener_relacionados`
- Cualquier otra construcción existente del lenguaje

El sistema `n_*` es **adicional** y **paralelo** al sistema actual.

---

**Última actualización:** 2026-02-18
