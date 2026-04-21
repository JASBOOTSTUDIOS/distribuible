# Predicados estándar n_grafo (Fase 9)

Convenciones semánticas para el grafo de triples. **No son keywords** del lenguaje; son cadenas que el sistema interpreta de forma especial cuando se usan con `n_heredar` y en patrones de razonamiento.

---

## Predicados principales

| Predicado | Significado | Uso típico |
|-----------|-------------|------------|
| `n_es_un` | Relación de tipo/subclase: (X, n_es_un, Y) → X es instancia/tipo de Y | Herencia: perro n_es_un animal |
| `n_tipo_de` | Inverso de n_es_un: (Y, n_tipo_de, X) → Y es supertipo de X | Jerarquías inversas |
| `n_tiene` | Propiedad/atributo: (X, n_tiene, Y) → X tiene la propiedad/valor Y | Atributos |
| `n_parte_de` | Composición: (X, n_parte_de, Y) → X es parte de Y | Meronimia |
| `n_relacionado_con` | Relación genérica | Enlaces flexibles |

---

## Convención `n_es_un`

- **(X, n_es_un, Y)** significa: *X es un tipo de Y* (o *X es instancia de Y*).
- Usado por `n_heredar(grafo, sujeto, predicado)` para búsqueda transitiva.
- Ejemplo:
  ```
  (perro, n_es_un, animal)
  (animal, patas, cuatro)
  n_heredar(g, "perro", "patas") → "cuatro"
  ```

---

## Convención `n_tipo_de`

- **(Y, n_tipo_de, X)** es el inverso de n_es_un: Y es supertipo de X.
- Útil para consultas “¿qué instancias tiene este tipo?”.

---

## Convención `n_tiene`

- **(X, n_tiene, Y)** indica que X tiene la propiedad o valor Y.
- Semántica flexible; puede usarse con `n_heredar` si se define herencia de propiedades.

---

## Uso como convención, no keywords

Estos predicados son **cadenas normales** en el vocabulario. No forman parte de la sintaxis del lenguaje. El programa debe registrar explícitamente los triples:

```
n_recordar(g, "perro", "n_es_un", "animal")
n_recordar(g, "labrador", "n_es_un", "perro")
```

---

## Referencias

- Checklist: `docs/CHECKLIST_CONCEPTOS_OPTIMIZADOS_V1.md` (Fase 9)
- Coexistencia memoria/grafo: `docs/COEXISTENCIA_MEMORIA_N_GRAFO.md`
- Formato .ngf: `docs/SPEC_FORMATO_NGF_V1.md`
