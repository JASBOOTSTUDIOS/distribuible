# PROMPT TEMPLATE - Jasboot

## Template base (copiar y pegar siempre)

```
LEE COMPLETAMENTE Y USA (obligatorio):
- .windsurf/workflows/jasboot.md (archivo maestro)
-  .windsurf/workflows/jasboot-context.md
- .windsurf/workflows/jasboot-rules.md
- .windsurf/workflows/ai-workflow.md
- .windsurf/workflows/working-context.md
- .windsurf/workflows/contexto-inteligente.md

tarea:
[describe aquí lo que quieres implementar]

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
```

---

## Ejemplos de uso

### Para nueva funcionalidad:

```
LEE COMPLETAMENTE Y USA (obligatorio):
- .windsurf/workflows/jasboot.md (archivo maestro)
- .windsurf/workflows/jasboot-context.md
- .windsurf/workflows/jasboot-rules.md
- .windsurf/workflows/ai-workflow.md
- .windsurf/workflows/working-context.md
- .windsurf/workflows/contexto-inteligente.md

tarea:
quiero crear un sistema de autenticación con memoria neuronal

recuerda:
- LEE COMPLETAMENTE todos los archivos relevantes ANTES de empezar a trabajar
- USAR SISTEMA DE CONTEXTO INTELIGENTE (.windsurf/workflows/contexto-inteligente.md)
- analizar archivos relevantes primero
- ACTUALIZAR working-context.md con MAPA ESTRUCTURADO
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
```

### Para corregir errores:

```
LEE COMPLETAMENTE Y USA (obligatorio):
- .windsurf/workflows/jasboot.md (archivo maestro)
- .windsurf/workflows/jasboot-context.md
- .windsurf/workflows/jasboot-rules.md
- .windsurf/workflows/ai-workflow.md
- .windsurf/workflows/working-context.md
- .windsurf/workflows/contexto-inteligente.md
- .windsurf/workflows/error-patterns.md

tarea:
necesito corregir el error de compilación en archivo.jasb

recuerda:
- LEE COMPLETAMENTE todos los archivos relevantes ANTES de empezar a trabajar
- USAR SISTEMA DE CONTEXTO INTELIGENTE (.windsurf/workflows/contexto-inteligente.md)
- CONSULTAR PATRONES DE ERRORES (.windsurf/workflows/error-patterns.md)
- analizar archivos relevantes primero
- ACTIVAR debug_activo en working-context.md
- leer archivos involucrados usando mapa
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
```

### Para refactorización:

```
LEE COMPLETAMENTE Y USA (obligatorio):
- .windsurf/workflows/jasboot.md (archivo maestro)
- .windsurf/workflows/jasboot-context.md
- .windsurf/workflows/jasboot-rules.md
- .windsurf/workflows/ai-workflow.md
- .windsurf/workflows/working-context.md
- .windsurf/workflows/contexto-inteligente.md

tarea:
quiero refactorizar el módulo de estadística para hacerlo más eficiente

recuerda:
- LEE COMPLETAMENTE todos los archivos relevantes ANTES de empezar a trabajar
- USAR SISTEMA DE CONTEXTO INTELIGENTE (.windsurf/workflows/contexto-inteligente.md)
- analizar archivos relevantes primero
- ACTUALIZAR working-context.md con MAPA ESTRUCTURADO
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
```

### Trabajar sobre archivos existentes (NO duplicar):

```
LEE COMPLETAMENTE Y USA (obligatorio):
- .windsurf/workflows/jasboot.md (archivo maestro)
- .windsurf/workflows/jasboot-context.md
- .windsurf/workflows/jasboot-rules.md
- .windsurf/workflows/ai-workflow.md
- .windsurf/workflows/working-context.md
- .windsurf/workflows/contexto-inteligente.md

tarea:
necesito corregir/mejorar el archivo [nombre_archivo.jasb]

recuerda:
- LEE COMPLETAMENTE todos los archivos relevantes ANTES de empezar a trabajar
- USAR SISTEMA DE CONTEXTO INTELIGENTE (.windsurf/workflows/contexto-inteligente.md)
- NO crear archivos duplicados ([nombre]-simple.jasb, [nombre]-v2.jasb)
- TRABAJAR sobre el archivo original
- PROBAR y CORREGIR el archivo existente
- ACTUALIZAR working-context.md con MAPA ESTRUCTURADO

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

si el archivo no se puede corregir:
solicita permiso para crear alternativa y explica por qué es necesario
```

---

## Atajos rápidos

### Código directo (excepción):

```
usar jasboot.md y jasboot-rules.md

dame código directo para: [tarea específica]
```

### Análisis de archivos:

```
LEE COMPLETAMENTE Y USA (obligatorio):
- .windsurf/workflows/jasboot.md (archivo maestro)
- .windsurf/workflows/jasboot-context.md
- .windsurf/workflows/jasboot-rules.md
- .windsurf/workflows/ai-workflow.md
- .windsurf/workflows/working-context.md
- .windsurf/workflows/contexto-inteligente.md

analiza los archivos relacionados con este problema
LEE COMPLETAMENTE todos los archivos relevantes ANTES de empezar a trabajar
USAR SISTEMA DE CONTEXTO INTELIGENTE (.windsurf/workflows/contexto-inteligente.md)
actualiza working-context.md con MAPA ESTRUCTURADO
luego propone solución

**SISTEMA DE CONTEXTO INTELIGENTE:**
- Usar MAPA de archivos con funciones mapeadas por líneas
- Actualizar incrementalmente solo lo que cambia
- NO duplicar información en múltiples secciones
- Trazabilidad exacta: ubicación precisa de cada función
- Debug automático: leer archivos involucrados en problemas

**ACTUALIZACIÓN CONSTANTE DEL CONTEXTO:**
- Después de CADA archivo analizado, actualiza working-context.md con mapa
- Después de CADA descubrimiento importante, registra en working-context.md
- Después de CADA decisión de análisis, registra justificación en working-context.md
- Al FINALIZAR, compacta contexto_principal y limpia temporales
```

### Solo plan:

```
usar ai-workflow.md y .windsurf/workflows/contexto-inteligente.md

solo quiero el plan.md para: [tarea]
```

### Continuar trabajo automáticamente:

```
LEE COMPLETAMENTE Y USA (obligatorio):
- .windsurf/workflows/jasboot.md (archivo maestro)
- .windsurf/workflows/jasboot-context.md
- .windsurf/workflows/jasboot-rules.md
- .windsurf/workflows/ai-workflow.md
- .windsurf/workflows/working-context.md
- .windsurf/workflows/contexto-inteligente.md
- .windsurf/workflows/plan/plan.md

tarea:
continúa automáticamente desde donde te quedaste

recuerda:
- USAR SISTEMA DE CONTEXTO INTELIGENTE (.windsurf/workflows/contexto-inteligente.md)
- IDENTIFICAR automáticamente la siguiente tarea pendiente
- LEER working-context.md con MAPA para ver el estado actual
- REVISAR .windsurf/workflows/plan/plan.md para pasos no completados
- DETECTAR errores o archivos que necesitan atención
- EJECUTAR la siguiente acción identificada automáticamente
- ACTUALIZAR working-context.md con MAPA ESTRUCTURADO

**SISTEMA DE CONTEXTO INTELIGENTE:**
- Usar MAPA de archivos con funciones mapeadas por líneas
- Actualizar incrementalmente solo lo que cambia
- NO duplicar información en múltiples secciones
- Trazabilidad exacta: ubicación precisa de cada función
- Debug automático: leer archivos involucrados en problemas

**IDENTIFICACIÓN AUTOMÁTICA DE TAREAS:**
1. Buscar "Próximo Paso Inmediato" en working-context.md
2. Revisar "Cambios Recientes" para ver qué quedó pendiente
3. Analizar "Estado Actual" para detectar problemas
4. Verificar pasos no completados en plan.md
5. Priorizar: errores > pasos explícitos > tareas del plan > mejoras

**ACTUALIZACIÓN CONSTANTE DEL CONTEXTO:**
- Después de CADA acción automática, actualiza working-context.md con mapa
- Después de CADA error corregido, registra en debug_activo
- Después de CADA archivo verificado, actualiza estado en mapa
- Después de CADA decisión tomada, registra justificación en mapa
- Al FINALIZAR, compacta contexto_principal y limpia temporales
```

### Reanudar trabajo (si se detiene por tiempo):

```
LEE COMPLETAMENTE Y USA (obligatorio):
- .windsurf/workflows/jasboot.md (archivo maestro)
- .windsurf/workflows/jasboot-context.md
- .windsurf/workflows/jasboot-rules.md
- .windsurf/workflows/ai-workflow.md
- .windsurf/workflows/working-context.md
- .windsurf/workflows/contexto-inteligente.md

continúa automáticamente desde el estado actual en working-context.md
no necesitas especificar manualmente el estado
el agente leerá working-context.md con MAPA y continuará desde allí

LEE COMPLETAMENTE todos los archivos relevantes ANTES de continuar el trabajo
USAR SISTEMA DE CONTEXTO INTELIGENTE (.windsurf/workflows/contexto-inteligente.md)
actualiza working-context.md con MAPA ESTRUCTURADO de la reanudación

**SISTEMA DE CONTEXTO INTELIGENTE:**
- Usar MAPA de archivos con funciones mapeadas por líneas
- Actualizar incrementalmente solo lo que cambia
- NO duplicar información en múltiples secciones
- Trazabilidad exacta: ubicación precisa de cada función
- Debug automático: leer archivos involucrados en problemas

**ACTUALIZACIÓN CONSTANTE DEL CONTEXTO:**
- Después de CADA paso reanudado, actualiza working-context.md con mapa
- Después de CADA error corregido en reanudación, registra en debug_activo
- Después de CADA prueba ejecutada, actualiza resultado en mapa
- Después de CADA decisión importante, registra justificación en mapa
- Al FINALIZAR, compacta contexto_principal y limpia temporales

si quieres especificar un estado diferente:
estaba trabajando en: [describir lo que se estaba haciendo]
el último estado era: [describir último progreso]

continúa desde donde te quedaste usando working-context.md como referencia
no repitas lo ya hecho
continúa con el siguiente paso pendiente
```

---

## Comandos Rápidos con Contexto Inteligente

### Diagnóstico completo:

```
lee completamente: jasboot.md + analiza
```

### Corrección automática:

```
lee completamente: jasboot.md + corrige
```

### Mejora del sistema:

```
lee completamente: jasboot.md + mejora
```

### Estado actual del proyecto:

```
lee completamente: jasboot.md + estado
```

### Planificación estratégica:

```
lee completamente: jasboot.md + planifica
```

---

## Integración con Comandos Rápidos

Los comandos rápidos están diseñados para usar `jasboot.md` como punto de entrada único:

- **`jasboot.md`** contiene todo el contexto del sistema
- **`.windsurf/workflows/comandos-rapidos.md`** tiene los comandos específicos
- **`.windsurf/workflows/contexto-inteligente.md`** proporciona el sistema de gestión
- **`working-context.md`** mantiene el estado dinámico

### Ejemplo completo:

```
LEE COMPLETAMENTE Y USA (obligatorio):
- .windsurf/workflows/jasboot.md
- .windsurf/workflows/jasboot-context.md
- .windsurf/workflows/jasboot-rules.md
- .windsurf/workflows/ai-workflow.md
- .windsurf/workflows/working-context.md
- .windsurf/workflows/contexto-inteligente.md

tarea:
quiero crear un sistema de logging que escriba en archivos y también guarde en memoria neuronal para análisis posterior. Debe soportar diferentes niveles (debug, info, error) y ser configurable.

archivos involucrados:
- stdlib/logging/logger.jasb (nuevo)
- examples/demo_logging.jasb (nuevo)

prioridades:
- rendimiento primero
- modularidad
- fácil configuración

recuerda:
- LEE COMPLETAMENTE todos los archivos relevantes ANTES de empezar a trabajar
- USAR SISTEMA DE CONTEXTO INTELIGENTE (.windsurf/workflows/contexto-inteligente.md)
- analizar archivos relevantes primero
- ACTUALIZAR working-context.md con MAPA ESTRUCTURADO
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
```

---

## Tips para mejores resultados

1. **Ser específico** - Detalla qué quieres lograr
2. **Mencionar archivos** - Si hay archivos existentes involucrados
3. **Indicar prioridades** - Rendimiento, legibilidad, etc.
4. **Restricciones** - Si hay limitaciones técnicas
5. **Usar contexto inteligente** - Siempre usar MAPA ESTRUCTURADO

### Referencias rápidas:

- **`jasboot.md`** - Archivo maestro del sistema
- **`.windsurf/workflows/contexto-inteligente.md`** - Sistema de gestión de contexto
- **`.windsurf/workflows/comandos-rapidos.md`** - Comandos específicos
- **`.windsurf/workflows/error-patterns.md`** - Patrones de errores conocidos

---

_Todos los templates están interconectados para máxima eficiencia con el sistema de contexto inteligente_

- **working-context.md** - Ver estado actual del sistema _aquí_
- **ai-workflow.md** - Flujo completo de trabajo _aquí_
- **jasboot-rules.md** - Reglas de contexto dinámico _aquí_
- **Reanudar trabajo** - Si se detiene por tiempo, ver sección arriba
- **Análisis de archivos** - Ver sección "Análisis de archivos" arriba

### Flujo recomendado:

1. **Análisis primero** → Usa template "Análisis de archivos"
2. **Luego plan** → Usa template "Solo plan"
3. **Implementación** → Usa template base con contexto inteligente
4. **Continuidad** → Usa "Continuar trabajo automáticamente"

### Integración completa:

- **`jasboot.md`** - Punto de entrada único para el AI
- **`.windsurf/workflows/contexto-inteligente.md`** - Sistema de gestión avanzado
- **`.windsurf/workflows/comandos-rapidos.md`** - Comandos específicos y eficientes
- **`working-context.md`** - Memoria dinámica con MAPA
- **`ai-workflow.md`** - Flujo de trabajo estructurado
- **`jasboot-rules.md`** - Reglas con contexto inteligente
- **`.windsurf/workflows/error-patterns.md`** - Patrones de errores conocidos

**Resultado:** Sistema completo de IA con contexto inteligente, trazabilidad exacta y actualización incremental.

### Ejemplo completo:

```
LEE COMPLETAMENTE Y USA:
- jasboot.md (archivo maestro)
- jasboot-context.md
- jasboot-rules.md
- ai-workflow.md
- working-context.md
- .windsurf/workflows/contexto-inteligente.md

tarea:
quiero crear un sistema de logging que escriba en archivos y también guarde en memoria neuronal para análisis posterior. Debe soportar diferentes niveles (debug, info, error) y ser configurable.

archivos involucrados:
- stdlib/logging/logger.jasb (nuevo)
- examples/demo_logging.jasb (nuevo)

prioridades:
- rendimiento primero
- modularidad
- fácil configuración

recuerda:
- LEE COMPLETAMENTE todos los archivos relevantes ANTES de empezar a trabajar
- analizar archivos relevantes primero
- actualizar working-context.md con lo aprendido
- luego generar plan.md
- hacer preguntas si aplica
- luego implementación paso a paso
- asegurar compilación con jbc

**ACTUALIZACIÓN CONSTANTE DEL CONTEXTO:**
- Después de CADA paso implementado, actualiza working-context.md
- Después de CADA error corregido, registra en working-context.md
- Después de CADA prueba ejecutada, actualiza resultado en working-context.md
- Después de CADA decisión importante, registra justificación en working-context.md
- Al FINALIZAR, actualiza estado actual en working-context.md
```

_Ver workflow completo en ai-workflow.md y gestión de contexto en jasboot-rules.md_
