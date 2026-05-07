# SISTEMA DE CONTEXTO INTELIGENTE - Jasboot AI Agent

## Propósito

Sistema avanzado de gestión de contexto que evita duplicación, proporciona trazabilidad exacta y mantiene el estado organizado por proyecto y tarea.

---

## 🧠 Principios Fundamentales

### 1. No Duplicación de Estado
- **Usar mapa de contexto** en lugar de texto completo
- **Actualizar incrementalmente** - Solo lo que cambia
- **Mantener historial** - Por fecha y tarea

### 2. Trazabilidad Exacta
- **Mapear archivos por función** - Ubicación precisa
- **Referenciar líneas específicas** - No "en el archivo"
- **Ubicación por dominio** - [CORE]/[LIB]/[APP]

### 3. Actualización Inteligente
- **Detectar cambios automáticamente**
- **Actualizar solo lo afectado**
- **Mantener coherencia** entre secciones

### 4. Debug Automático
- **Leer archivos involucrados** en problemas
- **No asumir ubicaciones** - Verificar existencia
- **Análisis de raíz** - Seguir dependencias

### 5. Sin Versiones Duplicadas
- **Trabajar sobre existentes**
- **No crear v2, simple, etc.**
- **Mejorar incrementalmente**

---

## 📋 Estructura de working-context.md

### Formato de Mapa Principal
```yaml
contexto_principal:
  proyecto_actual: [nombre del proyecto activo]
  dominio: [CORE]/[LIB]/[APP]
  estado_general: [descripción del estado actual]
  
proyectos_activos:
  [nombre_proyecto]:
    dominio: [tipo]
    estado: [descripción]
    archivos_trabajando: [lista]
    funciones_en_progreso: [mapa]
    problemas_detectados: [lista]
    proximos_pasos: [lista]
    ultima_actualizacion: [timestamp]
    
historial_tareas:
  [YYYY-MM-DD]:
    tarea: [descripción]
    estado: [completada/en_progreso/pausada]
    archivos_modificados: [lista]
    impacto: [descripción]
    problemas_resueltos: [lista]
    
mapa_archivos:
  [ruta_archivo]:
    dominio: [CORE]/[LIB]/[APP]
    proposito: [descripción]
    estado: [activo/en_pausa/completado]
    funciones_mapeadas:
      [nombre_funcion]:
        linea_inicio: [número]
        linea_fin: [número]
        descripcion: [breve]
        dependencias: [lista de archivos]
    ultima_modificacion: [timestamp]
    
debug_activo:
  problema_actual: [descripción]
  archivos_involucrados: [lista]
  analisis_raiz: [conclusiones]
  soluciones_intentadas: [lista]
```

---

## 🔧 Mecanismos de Actualización

### 1. Actualización de Proyecto Activo
```yaml
# Al cambiar de proyecto o iniciar nueva tarea
proyectos_activos.[nuevo_proyecto]:
  dominio: [identificado automáticamente]
  estado: "en_progreso"
  archivos_trabajando: [lista inicial]
  funciones_en_progreso: {}
  problemas_detectados: []
  proximos_pasos: [primeros pasos]
  ultima_actualizacion: [timestamp_actual]
```

### 2. Actualización de Funciones Específicas
```yaml
# Al trabajar en una función específica
mapa_archivos.[ruta_archivo].funciones_mapeadas.[nombre_funcion]:
  linea_inicio: [número_exacto]
  linea_fin: [número_exacto]
  descripcion: [actualización]
  ultima_modificacion: [timestamp_actual]
```

### 3. Actualización de Problemas
```yaml
# Al detectar un problema
debug_activo:
  problema_actual: [descripción detallada]
  archivos_involucrados: [lista de rutas verificadas]
  analisis_raiz: [conclusiones del análisis]
  soluciones_intentadas: [lista con lo probado]
```

### 4. Actualización de Historial
```yaml
# Al completar una tarea
historial_tareas.[YYYY-MM-DD]:
  tarea: [descripción]
  estado: "completada"
  archivos_modificados: [lista final]
  impacto: [resultado obtenido]
  problemas_resueltos: [lista de problemas resueltos]
```

---

## 🗂️ Flujo de Trabajo

### Al Iniciar Nueva Tarea
1. **Identificar proyecto** - Determinar si es nueva o continuación
2. **Crear/actualizar entrada** - En `proyectos_activos`
3. **Mapear archivos iniciales** - En `mapa_archivos`
4. **Establecer primeros pasos** - En `proximos_pasos`

### Durante Implementación
1. **Antes de modificar** - Leer ubicación exacta en `mapa_archivos`
2. **Actualizar función específica** - Modificar solo lo relevante
3. **Registrar cambios** - Actualizar líneas y descripción
4. **Detectar problemas** - Agregar a `debug_activo` si es necesario

### Al Encontrar Problema
1. **Activar debug** - Crear entrada en `debug_activo`
2. **Leer archivos involucrados** - Usar mapa para ubicar
3. **Analizar raíz** - Seguir dependencias automáticamente
4. **Documentar soluciones** - Registrar intentos y resultados

### Al Completar Tarea
1. **Mover a historial** - Archivar en `historial_tareas`
2. **Limpiar activo** - Resetear secciones temporales
3. **Actualizar mapa** - Reflejar estado final de archivos
4. **Preparar siguientes** - Establecer próximos pasos

---

## 🎯 Ejemplos Prácticos

### Ejemplo 1: Iniciar Trabajo en Neurixis IA
```yaml
# Estado inicial
contexto_principal:
  proyecto_actual: "neurixis_mejora"
  dominio: "APP"
  estado_general: "Iniciando refactorización del motor cognitivo"
  
proyectos_activos:
  neurixis_mejora:
    dominio: "APP"
    estado: "en_progreso"
    archivos_trabajando: 
      - "apps/neurixis_IA/cerebro/generador.jasb"
      - "apps/neurixis_IA/cerebro/generador_simple.jasb"
    funciones_en_progreso:
      refacturar_motor:
        descripcion: "Aplanar funciones anidadas y corregir sintaxis"
        linea_inicio: 15
        linea_fin: 200
    proximos_pasos:
      - "Corregir variables locales en clases"
      - "Implementar fallbacks para memoria neuronal"
    ultima_actualizacion: "2026-04-16T10:30:00"
```

### Ejemplo 2: Durante Implementación
```yaml
# Al trabajar en función específica
mapa_archivos:
  "apps/neurixis_IA/cerebro/generador.jasb":
    funciones_mapeadas:
      pensar_respuesta:
        linea_inicio: 45
        linea_fin: 89
        descripcion: "Función cognitiva principal - genera respuestas"
        dependencias: 
          - "apps/neurixis_IA/cerebro/memoria.jasb"
        ultima_modificacion: "2026-04-16T14:22:00"
```

### Ejemplo 3: Debug Activo
```yaml
# Al detectar problema de compilación
debug_activo:
  problema_actual: "Error de seguridad: variables locales tratadas como campos de clase"
  archivos_involucrados:
    - "apps/neurixis_IA/cerebro/generador.jasb"
    - "stdlib/logging/logger.jasb"
  analisis_raiz: "El compilador confunde variables locales con campos de clase en métodos privados"
  soluciones_intentadas:
    - "Renombrar variables con sufijos _actual, _temp"
    - "Mover declaración fuera del método si es posible"
```

---

## 🔄 Comandos de Actualización Automática

### comando: actualizar_contexto
```yaml
# Actualiza el contexto basado en cambios recientes
accion:
  tipo: "actualizacion_contexto"
  archivos_afectados: [lista detectada automáticamente]
  cambios_realizados: [resumen de modificaciones]
```

### comando: cambiar_proyecto
```yaml
# Cambia el proyecto activo
accion:
  tipo: "cambio_proyecto"
  proyecto_anterior: [nombre]
  proyecto_nuevo: [nombre]
  motivo: [descripción del cambio]
```

### comando: completar_tarea
```yaml
# Archiva tarea actual
accion:
  tipo: "completar_tarea"
  tarea_completada: [descripción]
  resultado: [logro obtenido]
  siguientes_pasos: [próximas acciones]
```

---

## 📊 Métricas y Estado

### Indicadores de Progreso
- **Tareas activas**: Número de proyectos en `proyectos_activos`
- **Funciones en progreso**: Total en todos los proyectos
- **Problemas sin resolver**: En `debug_activo`
- **Archivos mapeados**: Total en `mapa_archivos`

### Estado por Dominio
```yaml
estado_dominios:
  CORE:
    proyectos: [lista]
    problemas_criticos: [lista]
    proximas_acciones: [lista]
  LIB:
    proyectos: [lista]
    estado_biblioteca: [descripción]
    dependencias: [lista]
  APP:
    proyectos: [lista]
    aplicaciones_funcionales: [lista]
    problemas_conocidos: [lista]
```

---

## 🚀 Directrices para el AI Agent

### Al Leer working-context.md
1. **Leer solo sección relevante** - No todo el archivo
2. **Usar mapa para ubicar** - No buscar linealmente
3. **Verificar estado actual** - Antes de modificar
4. **Actualizar incrementalmente** - Solo lo necesario

### Al Modificar Archivos
1. **Consultar mapa_archivos** - Para ubicación exacta
2. **Actualizar solo función afectada** - No reescribir todo
3. **Registrar en funciones_mapeadas** - Líneas y descripción
4. **Sincronizar timestamp** - En todas las actualizaciones

### Al Resolver Problemas
1. **Activar debug_activo** - Documentar análisis
2. **Leer archivos_involucrados** - Usar mapa
3. **Seguir dependencias** - Análisis de raíz automático
4. **Probar soluciones incrementalmente** - Una por una

### Al Actualizar Contexto
1. **Compactar historial** - Mover tareas completadas
2. **Limpiar secciones temporales** - debug_activo, etc.
3. **Actualizar mapa_archivos** - Reflejar estado final
4. **Mantener coherencia** - Entre todas las secciones

---

*Este sistema transforma working-context.md de un archivo de texto a una base de datos estructurada que proporciona trazabilidad exacta y evita duplicación.*
