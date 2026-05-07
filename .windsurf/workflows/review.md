---
auto_execution_mode: 3
description: Realizar primero de manera obligatoria las tareas descritas en este archivo.
---
LEE COMPLETAMENTE Y USA (obligatorio):
- jasboot.md (archivo maestro)
- jasboot-context.md
- jasboot-rules.md
- ai-workflow.md
- working-context.md
- .windsurf/workflows/contexto-inteligente.md

recuerda:
- LEE COMPLETAMENTE todos los archivos relevantes ANTES de empezar a trabajar
- USAR SISTEMA DE CONTEXTO INTELIGENTE (.windsurf/workflows/contexto-inteligente.md)
- analizar archivos relevantes primero
- **REALIZAR PRUEBAS DE DIAGNÓSTICO** para identificar el problema puntual exacto
- ACTUALIZAR working-context.md con MAPA ESTRUCTURADO (no texto completo)
- luego generar plan.md si aplica
- hacer preguntas si aplica
- luego implementación paso a paso
- asegurar compilación con jbc

**SISTEMA DE CONTEXTO INTELIGENTE:**
- Usar MAPA de archivos con funciones mapeadas por líneas
- Actualizar incrementalmente solo lo que cambia
- NO duplicar información en múltiples secciones
- Trazabilidad exacta: ubicación precisa de cada función
- Debug automático: leer archivos involucrados en problemas

**ACTUALIZACIÓN CONSTANTE DEL CONTEXTO:**
- Después de CADA paso implementado, actualiza working-context.md con mapa
- Después de CADA error corregido, registra en debug_activo
- Después de CADA prueba ejecutada, actualiza resultado en mapa
- Después de CADA decisión importante, registra justificación en mapa
- Al FINALIZAR, compacta contexto_principal y limpia temporales
