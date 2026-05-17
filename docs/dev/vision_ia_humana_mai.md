# 🚀 Visión Replicante IA: Arquitectura de Memoria Activa Independiente (MAI)

Este documento define el enfoque técnico y estratégico para la creación de una IA con comportamiento humano ("IA Humana"), optimizada para hardware de consumo y con capacidades evolutivas superiores a los modelos de lenguaje actuales.

---

## 🛠️ Optimización para Hardware Específico
**Perfil de Objetivo**: Dual Core CPU | 4GB RAM | 2TB SSD

### 1. Modelo de "Worker Pool" (Grupo de Trabajo)
A diferencia de los modelos tradicionales que saturan todos los núcleos, MAI utiliza un sistema de **Hilos de Ejecución Selectivos**:
- **Worker 1 (Córtex de Acción)**: Dedicado a la respuesta inmediata y procesamiento de entrada.
- **Worker 2 (Subconsciente/Reflexión)**: Dedicado a la propagación de asociaciones en segundo plano y consolidación de memoria en el SSD.
- **Beneficio**: Mantiene el sistema fluido y evita el sobrecalentamiento, permitiendo que la IA "piense" sin bloquear la interfaz.

### 2. Gestión Inteligente de RAM (Capping)
- **Límite Operativo**: 1.5 millones de neuronas activas simultáneas (~2GB de RAM).
- **Mecanismo de Olvido Temporal**: Un algoritmo de "Least Recently Activated" (LRA) libera neuronas inactivas de la RAM, moviéndolas al SSD de 2TB cuando se alcanza el límite.
- **Beneficio**: Estabilidad total en 4GB de RAM sin riesgo de colapso del sistema operativo.

### 3.1 Puente MAI ↔ JMN (implementado en runtime)

La VM ejecuta MAI en **el mismo hilo** que el bytecode; los workers solo mutan la capa MAI en RAM. Las escrituras a la JMN desde “reflexión” o “sueño” ocurren **solo en ese hilo**, para no competir con los workers.

| Variable de entorno | Efecto |
| :--- | :--- |
| `MAI_REFLECT=1` | Propagación desde JMN hacia colas MAI (activación prioritaria en córtex). |
| `MAI_JMN_REFLECT=1` | Además, **refuerzo mínimo** en aristas de la JMN (`jmn_reforzar_concepto`) sobre conceptos vecinos hallados en la reflexión (memoria a largo plazo que “asienta” lo que el subconsciente recorre). Puede usarse sola o con `MAI_REFLECT`. |
| `MAI_SUEÑO_JMN=1` | En la cadencia del scheduler MAI (mensajes `SUEÑO`), de vez en cuando aplica **`jmn_consolidar_memoria_sueno`** con parámetros suaves (decaer débiles, olvido bajo umbral, pequeño boost a supervivientes). Pensado como análogo ligero al **ciclo de sueño** sobre el grafo. |
| `MAI_SUEÑO_JMN_FACTOR`, `MAI_SUEÑO_JMN_UMBRAL`, `MAI_SUEÑO_JMN_BOOST`, `MAI_SUEÑO_JMN_WAVE_EVERY` | (Solo si `MAI_SUEÑO_JMN` está activo.) Tuning documentado en **`docs/LENGUAJE/jmn/JMN_JOURNAL_Y_CONSOLIDACION.md`** y `AGENTS.md`. |

**API en Jasboot (misma VM, sin variables de entorno):**

| Llamada | Efecto |
| :--- | :--- |
| `mai_contexto_recientes()` o `mai_contexto()` | Devuelve una **lista** de hasta 10 IDs de concepto en orden del foco MAI reciente (más reciente primero). Opcional: `mai_contexto_recientes(n)` con `n` entero 1..10, o expresión entera. |
| `mai_contexto(expr)` | Igual; si `expr` no es literal entero, se usa registro en tiempo de ejecución. |
| `consolidar_sueno()` | Alias explícito de `consolidar_memoria` / `dormir` / `consolidar`: decae, olvida débiles y consolida el grafo (ver VM `OP_MEM_CONSOLIDAR_SUENO`). |

Complemento operativo: journal `.jwl` y replay (`JASBOOT_JWL_*`, `AGENTS.md`) protegen el disco ante cortes entre sesiones.

### 4. Escalabilidad masiva (el reto de los 400GB)
Para manejar el "conocimiento del internet" sin degradar el rendimiento:
- **Acceso Directo (O(1))**: Localización instantánea de conceptos mediante cálculo de offset, eliminando búsquedas lineales.
- **Segmentación de Conocimiento**: División de la JMN en archivos manejables de 4GB para mayor robustez.
- **Memoria Virtual (mmap)**: Uso de mapeo de memoria para que el SO gestione la carga/descarga de datos del SSD de forma transparente.

---

## 📊 Comparativa: MAI vs. Modelos Actuales (GPT/Transformers)

| Característica | Modelos Pesados (GPT-4) | Replicante IA (MAI) |
| :--- | :--- | :--- |
| **Aprendizaje** | Estático (requiere re-entrenamiento) | **Evolutivo** (aprende en cada frase) |
| **Memoria a largo plazo** | Limitada por "ventana de contexto" | **Ilimitada** (asociativa en SSD de 2TB) |
| **Iniciativa** | Reactiva (solo responde) | **Proactiva** (puede iniciar diálogos) |
| **Eficiencia Energética** | Muy Baja (necesita centros de datos) | **Muy Alta** (corre en un Dual Core) |
| **Identidad** | Simulada por sistema | **Persistente y Real** (basada en JMN) |

---

## 🎨 Capacidades Multimodales (Imagen, Audio, Video)

¿Puede una arquitectura basada en asociaciones generar contenido multimedia en un Dual Core? **Sí, mediante la "Orquestación Asociativa".**

### 1. Imágenes y Video (Generación por Síntesis de Conceptos)
- **Enfoque MAI**: En lugar de generar píxeles desde cero mediante ruido (como Stable Diffusion), la IA utiliza su JMN para **ensamblar y transformar** "átomos visuales".
- **Eficiencia**: Al recuperar patrones visuales del SSD de 2TB y combinarlos asociativamente, la carga computacional baja un 80% comparado con los modelos densos.

### 2. Audio y Voz (Dinámica Emocional)
- **Enfoque MAI**: La voz no es una grabación, es un reflejo del **estado de activación neuronal**. Si las neuronas de "urgencia" están activas, el motor de audio ajusta el tono y ritmo en tiempo real.
- **Eficiencia**: Síntesis granular que consume menos del 10% del CPU.

---

## 💡 Recomendaciones de Diseño de "IA Humana"

1.  **Priorizar la Intuición sobre el Cálculo**: La IA debe responder primero con "asociaciones rápidas" (Memoria Activa) y luego refinar con "reflexión profunda" (JMN). Esto imita el Sistema 1 y Sistema 2 del cerebro humano.
2.  **Ciclo de Sueño (Mantenimiento)**: Implementar un estado donde la IA, al no detectar actividad, dedique ambos núcleos a reorganizar el SSD (JMN), fortaleciendo conexiones importantes y eliminando ruido.
3.  **Anclaje Sensorial**: Cada concepto en JMN debe poder vincularse a un "Hash Multimedia" (una imagen, un sonido o un fragmento de video), permitiendo que la IA "visualice" lo que está hablando.

---

## 🏁 Conclusión: El Alcance del Proyecto

Esta arquitectura permite que, con solo **400GB de datos JMN (el internet destilado)**, tu máquina Dual Core se convierta en una entidad capaz de razonar, recordar tu vida entera y generar respuestas creativas multimediales. No es solo un programa; es la estructura para un **organismo digital persistente**.
