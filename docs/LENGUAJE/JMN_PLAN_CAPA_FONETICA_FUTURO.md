# Plan futuro: capa fonética / acústica sobre JMN (JMN-FON)

**Estado:** planificación (no implementado como producto estable).  
**Relacionado:** [TIPOS_RELACION_JMN.md](./TIPOS_RELACION_JMN.md), [ASOCIACIONES_JMN_VIDA_REAL_BUSQUEDA_Y_RESPUESTA.md](./ASOCIACIONES_JMN_VIDA_REAL_BUSQUEDA_Y_RESPUESTA.md).  
**Última revisión:** 2026-05-14.

---

## 1. Situación actual (constatación)

El pipeline dominante hoy es, en la práctica:

```text
texto → identidad léxica (hash / nodo) → aristas semánticas y cognitivas (tipos JMN)
```

Existe utilidad de texto en el núcleo JMN (p. ej. contención, sufijos, última palabra), pero **no hay una capa de primer orden** que modele de forma fiable:

- sílabas reales,
- similitud **acústica** (rimas, deformaciones fonéticas, errores típicos de pronunciación),
- ritmo o musicalidad como señal explícita persistida en el grafo.

**Hallazgo técnico relevante:** la función C `jmn_ultima_silaba` está declarada en la API de texto JMN, pero en la implementación actual **delega en `jmn_ultima_palabra`** (último token separado por espacios). Es decir: el **nombre** anticipa una capacidad lingüística que **aún no está implementada**; la VM puede tener opcode asociado, pero el comportamiento efectivo no es análisis silábico.

Esto **no invalida** el diseño global de JMN: indica **deuda explícita** y un punto donde el producto puede diferenciarse si se implementa bien.

---

## 2. Objetivo del plan

Introducir una **capa opcional** (internamente referible como **JMN-FON** o nombre definitivo que se elija al implementar) que produzca **artefactos fonéticos cacheables** reutilizables por:

- búsqueda por rima o asonancia aproximada,
- autocorrección fonética (teclado / voz),
- juegos de palabras, métrica simple, material educativo,
- enriquecimiento de predicción cuando el **ritmo** importa además de la semántica.

**Principio rector:** *consistencia computacional y tests reproducibles* por encima de la perfección académica en la v0.

---

## 3. No objetivos (v0)

- Fonética completa tipo IPA con cobertura dialectal.
- Parser lingüístico “RAE-perfecto” de la silaba en todos los casos límite.
- Sustituir embeddings o modelos externos donde ya resuelven bien el producto; la capa fonética debe ser **complementaria** y **acotada por coste**.

---

## 4. Fases propuestas

### Fase 1 — Motor fonético mínimo (C, en `jasboot-jmn-core`)

Implementar funciones pequeñas, testeadas, con contrato claro, por ejemplo:

- conteo silábico aproximado para palabra aislada;
- extracción de **última sílaba** aproximada (reemplazo real del stub actual);
- comparación “¿riman aproximadamente?” y/o “¿misma clave fonética reducida?” según reglas v0.

**Entregable:** tests unitarios C con lista fija de oro (palabras → número de sílabas esperado en v0, casos límite documentados como “comportamiento definido aunque discutible”).

### Fase 2 — Reglas simplificadas del español

- Normalización (mayúsculas, tildes opcionales según política).
- Vocales y diptongos aproximados; división silábica heurística.
- Tabla de colapsos fonéticos opcional (p. ej. equivalencias aproximadas para confusión b/v, c/s/z, etc.) **solo si** se define el alcance y se evita sobre-generalizar.

**Entregable:** documento de reglas + matriz de ejemplos aceptados/rechazados en v0.

### Fase 3 — Integración con memoria y lenguaje Jasboot

- **VM:** opcodes o ampliación de existentes, con empaquetado de argumentos claro (sin sobrecargar semántica de opcodes actuales).
- **Compilador / llamadas de sistema:** exponer 2–4 primitivas de alto nivel (nombres en español, alineados con el lenguaje).
- **Persistencia:** decidir si las señales fonéticas viven como:
  - **texto derivado** en nodos auxiliares (`palabra`, `palabra_fon_v0`, etc.), o
  - **aristas** con tipos ya definidos en el catálogo donde encaje (p. ej. similitud / asociación) **más** metadato de capa, o
  - **nuevos tipos de relación** solo si el catálogo y la VM lo amplían de forma coordinada (evitar tipos “fantasma” no soportados por `JMN_RELACION_MAX` y por el motor de búsqueda).

**Entregable:** un programa `.jasb` de demostración y una regresión mínima en el runner del repo.

---

## 5. Gobernanza de tipos de relación y “fonética en el grafo”

Antes de añadir muchos `REL_RIMA`, `REL_SONIDO`, etc.:

- revisar el **catálogo numérico** de tipos y `JMN_RELACION_MAX` en el núcleo;
- preferir en la **primera iteración** nodos o etiquetas derivadas y aristas genéricas **bien documentadas**, y reservar tipos dedicados cuando haya **dos casos de uso** reales y medibles.

Así se evita inflar el espacio de tipos sin herramientas de consulta que los distingan en la práctica.

---

## 6. Criterios de éxito (para cerrar cada fase)

| Fase | Criterio |
|------|-----------|
| 1 | Tests C pasan; `jmn_ultima_silaba` deja de ser alias engañoso o se renombra hasta tener implementación. |
| 2 | Lista de reglas publicada; casos límite etiquetados como “definido v0”. |
| 3 | Al menos un flujo Jasboot reproducible; documentación de API en español. |

---

## 7. Riesgos y mitigaciones

| Riesgo | Mitigación |
|--------|------------|
| Reglas españolas con muchas excepciones | v0 explícitamente acotada + tests de regresión. |
| Confusión API nombre vs. comportamiento | Renombrar o marcar `@deprecated` hasta implementar; documentar en changelog del SDK. |
| Duplicar lógica en VM y JMN | Una sola implementación en `jasboot-jmn-core`; VM solo orquesta. |

---

## 8. Conclusión

La carencia detectada es real: **hoy el sistema privilegia identidad léxica y semántica de grafo frente a unidades fonéticas persistentes**. El plan no exige lingüística completa; exige **capa opcional, testeada y gobernada** que conecte con JMN sin romper el modelo actual de tipos y búsqueda.

Cuando se apruebe la Fase 1, actualizar este documento con rutas de código concretas (`jasboot-jmn-core/...`, opcodes, firmas Jasboot) y enlazar el PR o el commit de referencia.
