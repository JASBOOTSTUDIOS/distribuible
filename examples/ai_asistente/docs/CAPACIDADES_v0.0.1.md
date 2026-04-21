```# Documentación del Asistente Virtual Jasbot (v0.0.1)

Este documento detalla las capacidades técnicas y operativas del asistente cognitivo implementado en `asistente.jasb`. La versión **0.0.1** se centra en la robustez de la búsqueda semántica, la atomización de conocimientos y la flexibilidad de entrada para el usuario.

## 1. Núcleo de Memoria Neuronal (JMN)
El asistente utiliza el motor nativo de **Jasboot Memory Network (JMN)** para almacenar información no como texto plano, sino como una red de grafos con pesos y conexiones.

- **Persistencia:** Guarda todo el aprendizaje en `data/asistente.jmn`.
- **Refuerzo:** Los conceptos utilizados frecuentemente aumentan su "fuerza" en la red, facilitando su recuperación.

## 2. Entrada Inteligente (Multilínea por Tiempo)
Para solucionar problemas con textos largos o fragmentados por saltos de línea (como los que ocurren al pegar desde el portapapeles), el asistente implementa un sistema de escucha activa:

- **Detección de Enter:** Al presionar Enter, la IA no responde de inmediato.
- **Ventana de Silencio (2s):** La IA espera 2 segundos de inactividad total antes de procesar. Si durante ese tiempo entra más texto (un pegado masivo), el temporizador se reinicia.
- **Eco en Tiempo Real:** Mientras la IA espera, muestra en pantalla los caracteres que van llegando para asegurar al usuario que el sistema no está bloqueado.

## 3. Capacidades de Aprendizaje
El asistente puede expandir su base de conocimientos en tiempo real durante una conversación:

- **Aprendizaje Directo (X es Y):** Al detectar el patrón "objeto es descripción", la IA registra el vínculo.
- **Filtro de Preguntas (v0.0.1 Rev E):** El sistema ignora el patrón de aprendizaje si la frase contiene palabras interrogativas (qué, cuál, quién, cómo), evitando que las preguntas se guarden como definiciones.
- **Atomización (v0.0.1):** Al aprender una frase, el asistente desglosa las palabras significativas (longitud > 3 caracteres) y las asocia individualmente al concepto principal.
- **Prioridad de Raíz:** El sistema protege los conceptos principales para que las palabras contenidas en una descripción no "secuestren" el significado de un término raíz.

## 4. Estrategias de Búsqueda Semántica
La versión 0.0.1 implementa tres niveles de búsqueda:

1.  **Hit Directo:** Busca el término exacto en la memoria neuronal.
2.  **Búsqueda por Atomización:** Si el mensaje es una frase, busca si alguna de sus palabras clave ya tiene un significado asociado.
3.  **Búsqueda Profunda (Deep Search):** Escanea el contenido de los conocimientos raíz para ver si el término aparece dentro de sus descripciones.

## 5. Historial de Desarrollo (Etapas)

### Etapa 1: Núcleo Semántico
- **Implementación:** Motor JMN para persistencia y atomización básica.
- **Error Solucionado:** La IA no encontraba palabras contenidas dentro de sus descripciones.
- **Solución:** Implementación de desglosado de palabras clave asociadas al concepto raíz.

### Etapa 2: Entrada Flexible (Revisión A y B)
- **Implementación:** Comandos de pegado y temporizadores iniciales.
- **Error Solucionado:** Los saltos de línea del portapapeles disparaban ejecuciones parciales.
- **Solución:** Introducción de la espera de 2 segundos tras el último carácter recibido.

### Etapa 3: Estabilidad y Salida (Revisión C y D)
- **Implementación:** Optimización de buffer (50ms) y prioridad de conceptos raíz.
- **Error Solucionado:** La terminal se sentía "congelada" durante la espera y el comando `salir` fallaba con errores de la VM.
- **Solución:** Eco en tiempo real habilitado y priorización del bloque de comandos de salida antes del procesamiento semántico.

### Etapa 4: Aprendizaje Selectivo (Revisión E)
- **Implementación:** Filtro semántico de interrogativas y limpieza de sujetos.
- **Error Solucionado:** La IA "aprendía" preguntas (ej: "¿cuál es el nombre?" se guardaba como definición).
- **Solución:** Se añadió lógica para detectar pronombres interrogativos y derivar a búsqueda en lugar de aprendizaje. Se mejoró la limpieza de sujetos (mi, el, la) para normalizar el conocimiento.

---
**Versión:** 0.0.1 (Revisión E)
**Estado:** Estable / Salida garantizada / Aprendizaje selectivo activo.
