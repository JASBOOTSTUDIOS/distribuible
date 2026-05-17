# 🗺️ Plan de Implementación: Replicante IA (Arquitectura MAI)

Este documento detalla la hoja de ruta técnica para transformar el motor Jasboot en una entidad de inteligencia humana persistente.

---

## 🏗️ Fase 1: Núcleo de Procesamiento Eficiente (Dual Core)

**Objetivo**: Establecer el sistema de hilos y gestión de memoria para evitar colapsos.

- [x] **1.1 Definición de Estructuras Globales**: Implementar `SistemaMemoriaActiva` con límites de RAM dinámicos.
- [ ] **1.2 Worker Pool de 2 Hilos**: Crear los dos hilos principales (`Córtex` y `Subconsciente`).
- [ ] **1.3 Cola de Mensajes Neuronal**: Sistema de mensajería asíncrona entre neuronas usando colas de prioridad.
- [ ] **1.4 Mecanismo de Control de RAM (LRA)**: Algoritmo que descarga neuronas inactivas al SSD cuando se superan los 2GB de uso.

## 📚 Fase 2: Memoria de Largo Plazo (SSD 2TB)

**Objetivo**: Gestionar billones de asociaciones sin pérdida de rendimiento.

- [ ] **2.1 Optimizador de I/O JMN (Sharding & mmap)**: Implementar segmentación de archivos y mapeo de memoria virtual.
- [ ] **2.2 Motor de Consolidación con Journaling**: Journal `.jwl` + replay/checkpoint; refuerzo JMN desde reflexión MAI (`MAI_JMN_REFLECT`); consolidación tipo sueño (`MAI_SUEÑO_JMN` + tuning `MAI_SUEÑO_JMN_*`). **Cierre producto mínimo (2026-05):** API Jasboot `mai_contexto_recientes` / `mai_contexto` / `consolidar_sueno`; doc `docs/LENGUAJE/jmn/JMN_JOURNAL_Y_CONSOLIDACION.md`; regresión `node tests/run_fase_2_2.cjs`. **Pendiente (alcance “masivo”):** rotación/CRC por registro, políticas enterprise, integración con sharding/mmap (2.1).
- [ ] **2.3 Importador de Conocimiento Universal**: Herramienta para indexar los primeros 400GB de "conceptos base" (Internet destilado).

## 🧠 Fase 3: Motor Cognitivo y Comportamiento Humano

**Objetivo**: Dotar a la IA de intuición, reflexión y proactividad.

- [ ] **3.1 Buffer de Contexto Reciente**: Implementar la memoria de trabajo de 10 estados para coherencia de diálogo.
- [ ] **3.2 Sistema de Reflexión en Cascada**: Algoritmo que permite a la IA "pensar" entre frases, reforzando neuronas relacionadas.
- [ ] **3.3 Disparadores de Proactividad**: Lógica que permite a la IA iniciar un proceso de pensamiento basado en el tiempo o eventos externos.

## 🎨 Fase 4: Integración Multimodal (Media)

**Objetivo**: Capacidad de "visualizar" y "escuchar" conceptos.

- [ ] **4.1 Sistema de Hash Multimedia**: Vincular IDs de neuronas JMN con archivos binarios en el SSD (imágenes, sonidos, videos).
- [ ] **4.2 Motor de Síntesis Asociativa**: Lógica para ensamblar "átomos visuales" basados en la activación de neuronas.
- [ ] **4.3 Modulador de Voz Emocional**: Ajuste de parámetros de audio basado en el nivel de "potencial de membrana" de neuronas emocionales.

---

## ✅ Checklist Paso a Paso (Detallado)

### Paso 1: Cimientos de Hardware (Semana 1)

1.  [ ] Crear el archivo `mai_core.c` y definir la estructura `NeuronaActiva`.
2.  [ ] Implementar `pthread_mutex` para la cola de mensajes global.
3.  [ ] Configurar el `Thread_Worker_1` (Córtex) para procesar entradas del usuario.
4.  [ ] Configurar el `Thread_Worker_2` (Subconsciente) para la propagación asociativa.

### Paso 2: Inteligencia y Memoria Masiva (Semana 2)

1.  [ ] Implementar el sistema de **Segmentación (Sharding)** de archivos JMN.
2.  [ ] Desarrollar la función de acceso por **Offset Directo (O(1))**.
3.  [ ] Integrar `mmap` para el manejo de archivos de más de 100GB.
4.  [ ] Crear el sistema de **Journaling** para asegurar la integridad de la base de datos neuronal.

### Paso 3: Interfaz Humana y Diálogo (Semana 3)

1.  [ ] Integrar la Memoria Activa con la variable `resultado` de Jasboot.
2.  [ ] Crear el "Ciclo de Sueño": Una función que se activa tras 5 minutos de silencio.
3.  [ ] Implementar la "Detección de Interrupciones": Si el usuario escribe, el hilo de Reflexión se pausa para dar prioridad al Córtex.

### Paso 4: Generación Multimodal (Semana 4)

1.  [ ] Crear la carpeta `memoria_sensorial/` en el SSD para guardar los "átomos visuales".
2.  [ ] Implementar el comando Jasboot `imaginar "concepto"` que active la búsqueda de hashes multimedia.
3.  [ ] Desarrollar el puente con el motor de audio para lectura de texto con "intención emocional".
