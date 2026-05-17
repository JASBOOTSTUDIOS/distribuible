# Requisitos — Ontología de semilla y terminal asíncrona

Documento de referencia para implementación futura. Resume la dirección acordada: evolucionar la semilla hacia un **grafo cognitivo jerárquico** y, en paralelo, definir **E/S y diálogo proactivo** en terminal sin mezclar con la semilla actual hasta que el motor lo soporte.

**Estado:** requisitos / diseño. Parte de **percepción en vivo** (borrador + propagación entre palabras) está en `apps/neurixis/`; ver `apps/neurixis/docs/REQUISITOS_FUTUROS_SEMILLA_MAI_TERMINAL.md` §7.0.

---

## 1. Objetivo de la semilla (MAI / Neurixis)

La semilla no debe optimizarse solo por **tamaño** sino por:

- Mayor **estructura** (capas y roles claros de nodos y aristas).
- Mayor **diferenciación** (no todo al mismo nivel semántico).
- Mayor **abstracción** (conceptos reutilizables, no solo frases).
- Mayor **composicionalidad** (unir piezas del grafo en inferencia y generación).
- Mayor **dinámica** (políticas de aprendizaje, consolidación, turnos).

**Meta:** pasar de *texto conectado* a *mundo conceptual conectado* (ontología neuronal viva), manteniendo la ventaja diferencial: memoria persistente, trazabilidad, aprendizaje incremental, razonamiento explícito cuando el motor lo permita.

---

## 2. Separación conceptual obligatoria

### 2.1 Conocimiento vs lenguaje

| Dominio | Contenido típico | Rol |
|--------|-------------------|-----|
| **Conocimiento** | Clases, causalidad, tiempo, intención, valor/prioridad | Núcleo cognitivo |
| **Lenguaje** | Secuencias léxicas, plantillas superficiales | Superficie de expresión |

**Requisito:** el diseño debe permitir **particiones o namespaces** (o dos grafos enlazados) para no mezclar aristas de “qué es el mundo” con aristas de “cómo se dice en español”.

### 2.2 Jerarquía conceptual

**Requisito:** modelar explícitamente cadenas del tipo:

`perro → mamífero → animal → ser_vivo → organismo` (ejemplo ilustrativo).

Propósito: abstracción, generalización e inferencia por subida/bajada en la jerarquía.

---

## 3. Capas cognitivas de la semilla (referencia)

Numeración de **tipos de arista** en los ejemplos del análisis original (6–10) es **orientativa**; la implementación debe mapear a tipos **definidos en VM/JMN** y documentados en un solo lugar (no duplicar semántica solo en el archivo de semilla).

### 3.1 Capa léxica (átomos)

- Símbolos, palabras, categorías primitivas con confianza.
- Objetivo: anclar texto a **entidades semánticas**, no solo cadenas.

### 3.2 Capa conceptual

- Relaciones de mundo: pertenencia / clase (ej. `manzana → fruta`).
- **Sin** frases completas como núcleo.

### 3.3 Capa causal

- Causa → efecto (inferencia, simulación, predicción).
- Prioridad alta frente a asociación genérica.

### 3.4 Capa temporal

- Pasado / futuro / duración / orden de eventos.
- Requisito: sin temporalidad explícita, el razonamiento conversacional queda limitado.

### 3.5 Capa intencional

- Objetivos, necesidades, preguntas como acciones hacia estados (ej. `preguntar → obtener_información`).
- Objetivo: modelar **por qué** ocurre un acto lingüístico.

### 3.6 Capa emocional / valorativa (no “magia humana”)

- Prioridad, urgencia, amenaza, recompensa, corrección.
- Uso: atención, consolidación, qué recordar o resaltar.

### 3.7 Capa lingüística

- Secuencias y co-ocurrencias léxicas.
- **Superficie**, no núcleo cognitivo.

---

## 4. Tipos relacionales enriquecidos (motor)

Hoy el ecosistema documenta tipos como asociación, secuencia, similitud, oposición (y variantes según versión). **Requisito de producto:** extender o formalizar tipos que el **algoritmo** distinga, por ejemplo:

| Tipo (nombre lógico) | Uso |
|----------------------|-----|
| Pertenencia / clase | Jerarquía |
| Causalidad | Predicción y explicación |
| Temporalidad | Orden y tiempo |
| Intención | Metas y diálogo |
| Ubicación | Espacio (si aplica) |
| Propiedad | Atributos |
| `parte_de` | Meronimia |
| Consecuencia / condición | Reglas débiles |

**Dependencias técnicas (no solo semilla):**

- Definición en **IR/VM** (carga, validación, búsqueda).
- Uso en **`pensar_siguiente`**, `buscar_asociados_*`, generador Neurixis, y si aplica **journal MAI**.
- Políticas distintas por tipo (peso, decaimiento, conflicto).

---

## 5. Aprendizaje en niveles (pipeline cognitivo)

Referencia para políticas futuras de ingesta:

1. Texto superficial  
2. Conceptos  
3. Relaciones  
4. Causalidad  
5. Patrones recurrentes  
6. Abstracciones  

**Requisito:** el código de aprendizaje debe poder **etiquetar** o **rutar** entradas hacia la capa correspondiente cuando el motor lo soporte (no asumir que todo es arista tipo secuencia conversacional).

---

## 6. Generación e inferencia

**Requisito:** el generador no debe depender exclusivamente del paseo de **secuencias tipo 3** si el grafo incorpora capas 2–6.

- Operaciones deseables (a definir en API): subir/bajar jerarquía, expandir por tipo de arista, combinar evidencia de varios tipos, proyección concepto → superficie lingüística.

---

## 7. Terminal asíncrona y diálogo proactivo

### 7.1 Objetivo de UX

- La IA **no** debe limitarse a “usuario pregunta → IA responde”.
- Mientras el **usuario escribe**, la IA debe poder **pausarse** (no competir por atención).
- Tras **inactividad**, si el modelo tiene **dudas o metas abiertas**, puede **preguntar**.
- Si el usuario **no responde**, política de **re-intento** con variación (mensajes preferiblemente **generados** desde grafo/plantillas, no listas fijas largas en código).

### 7.2 Restricciones de plataforma

- Consola clásica suele ser **línea completa**; pulsación a pulsación requiere **modo raw de teclado** o **host** (Node/Electron/TUI) que envíe eventos.
- **Concurrencia:** si la IA “piensa” mientras se lee teclado, hace falta **hilo/proceso separado** o scheduler integrado (p. ej. MAI a nivel VM) y **canales seguros** de mensajes.

### 7.3 Estado de diálogo (requisito funcional)

- Turno: `usuario` | `sistema` | `espera`.
- Timers: actividad reciente de entrada, cooldown entre preguntas proactivas, máximo de re-intentos.
- Evitar tono **intrusivo** o repetitivo (reglas de prioridad y silencio respetuoso).

### 7.4 No hardcodear personalidad de “regaño”

- Variaciones y **plantillas** en grafo o motor de plantillas; contadores en **estado de sesión** (no solo JMN).

---

## 8. Criterios de aceptación (futuros)

- [ ] Tipos nuevos de relación **documentados** y **usados** en al menos un flujo de búsqueda y uno de generación.
- [ ] Semilla (o export) separable en bloques **conocimiento** vs **lenguaje** sin duplicar aristas contradictorias.
- [ ] Ejemplo mínimo de **jerarquía** consultable desde Jasboot o tests.
- [ ] Especificación de **eventos de entrada** y **política de turnos** para terminal/TUI (aunque la primera implementación sea en host externo).
- [ ] Pruebas de no regresión en Neurixis / JMN según el alcance tocado.

---

## 9. Referencias en repo (contexto)

- Semilla actual: `apps/neurixis/datos/semilla_conocimiento.txt`
- Entrenamiento / carga: `apps/neurixis/modulos/entrenamiento.jasb`
- Generación: `apps/neurixis/modulos/generador.jasb`
- VM / JMN / tipos de relación: `sdk-dependiente/jasboot-ir`, `jasboot-jmn-core`, documentación en `AGENTS.md` y docs de lenguaje.

---

*Última actualización: documento creado para planificación; contenido alineado con conversación sobre ontología de semilla y terminal asíncrona.*
