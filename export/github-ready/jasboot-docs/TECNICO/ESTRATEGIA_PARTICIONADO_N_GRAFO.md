# Estrategia de particionado para n_grafo (Fase 6.4)

Documento de diseño para particionar grafos de triples por dominio en datasets grandes.

---

## 1. Objetivo

Cuando el grafo crece (millones de triples, varios dominios: geografía, biología, ontologías, etc.), cargar todo en RAM resulta inviable. El particionado permite:

- Cargar solo las particiones necesarias
- Consultas más rápidas dentro de un dominio
- Escalado horizontal (particiones en distintos archivos/nodos)

---

## 2. Estrategias de partición

### 2.1 Por dominio / namespace (recomendado)

Asignar un prefijo o namespace a cada dominio:

| Dominio   | Ejemplo de predicados        | Archivo partición   |
|-----------|------------------------------|---------------------|
| geografía | `capital`, `poblacion`, `area` | `grafo.geo.ngf`    |
| biología  | `especie`, `habitat`, `taxonomia` | `grafo.bio.ngf`  |
| ontología | `n_es_un`, `n_tipo_de`, `rdfs:subClassOf` | `grafo.ont.ngf` |

**Implementación:** Cada partición es un archivo `.ngf` independiente. La aplicación decide qué partición(es) abrir según la consulta.

### 2.2 Por sujeto (hash o rango)

Particionar por hash del sujeto:

```
partición = hash(sujeto_id) % num_particiones
```

- **Ventaja:** Distribución uniforme.
- **Desventaja:** Triples del mismo sujeto pueden acabar en particiones distintas si se usa solo sujeto.

### 2.3 Por (S, P) — bloques de sujeto-predicado

Agrupar por el par (S, P). Los triples con mismo sujeto y predicado están juntos.

- Ya soportado parcialmente por el formato con triples ordenados por (S, P).
- Para particionado: `partición = hash(NGF_KEY_SP(s,p)) % N`.

### 2.4 Por tipo de triple (metadatos vs datos)

Separar:

- **Partición de esquema:** (X, n_es_un, Tipo), (Tipo, n_tiene, Prop)
- **Partición de instancias:** datos concretos

Útil cuando el esquema se consulta con mucha menos frecuencia que los datos.

---

## 3. Formato multi-partición (futuro)

### 3.1 Archivo índice de particiones

```
particiones.ngfi  (NGF Index)
- Lista de particiones: ruta, dominio, estadísticas
- Permite enrutar consultas sin abrir todas las particiones
```

### 3.2 Consultas federadas

Para consultas que cruzan particiones (ej. geografía + biología):

1. Ejecutar en cada partición relevante.
2. Unir resultados en memoria (o con iterador lazy).
3. Considerar caché para consultas frecuentes.

---

## 4. Recomendaciones prácticas

1. **Empezar simple:** Un archivo `.ngf` por dominio o por proyecto.
2. **Naming:** `{proyecto}.{dominio}.ngf` (ej. `wikidata.geo.ngf`).
3. **Límite por partición:** 1–10M triples por archivo para balancear I/O y RAM.
4. **Índices:** Cada partición mantiene sus propios índices en memoria al abrirse.
5. **Compresión:** Considerar compresión por partición para particiones frías (6.3).

---

## 5. API implementada (Fase B)

```c
/* core/src/n_grafo/n_grafo_particionado.h */
NGrafoParticionado* n_abrir_grafo_particionado(const char** rutas, const char** dominios, size_t n);
void n_cerrar_grafo_particionado(NGrafoParticionado* gp);
int n_recordar_en(NGrafoParticionado* gp, const char* dominio, const char* s, const char* p, const char* o);
uint32_t n_buscar_objeto_en(NGrafoParticionado* gp, const char* dominio, const char* sujeto, const char* predicado);
```

Dominios predefinidos: `geo`, `bio`, `ont`, `gen`.

---

## 6. Módulos Fase B adicionales

- **n_grafo_indice_texto**: Índice invertido para búsqueda de texto completo
- **n_grafo_compresion**: Compresión en bloques (Zstd con `-DNGF_USE_ZSTD -lzstd`)
- **n_grafo_cache**: Caché local LRU / stub Redis

---

**Última actualización:** 2026-02-18
