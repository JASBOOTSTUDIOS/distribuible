# JASBOOT - Sistema Completo de Desarrollo

## Propósito

Archivo maestro que proporciona una visión completa del ecosistema Jasboot para el AI agent. Sirve como punto de entrada único para entender el sistema, su estado actual y cómo interactuar con él.

---

## Visión General

**Jasboot** es un lenguaje de programación con:
- **Compilador en C** (`jbc.exe`)
- **Máquina virtual** (`jasboot-ir-vm.exe`)
- **Memoria neuronal integrada** (JMN)
- **Capacidades cognitivas nativas**
- **Sistema de IA avanzado**

---

## Estructura del Proyecto

```
jasboot/
+-- bin/                    # Ejecutables (jbc.exe, jasboot-ir-vm.exe)
+-- build/                  # Salida de compilación (.jbo)
+-- docs/                   # Documentación completa
|   +-- dev/               # Sistema de contexto para AI
+-- sdk-dependiente/       # Core del sistema (compilador, VM, runtime)
+-- stdlib/                 # Biblioteca estándar
+-- apps/                   # Aplicaciones (Neurixis IA, Michelle IA)
+-- examples/               # Ejemplos y demos
+-- tests/                  # Suite completa de pruebas
```

---

## Sistema de Contexto para AI

### Archivos Principales (Orden de Prioridad)

1. **`docs/dev/JASBOOT-CONTEXT.md`** - Conocimiento base del lenguaje
   - Sintaxis y características
   - Componentes del sistema
   - Capacidades especiales

2. **`docs/dev/jasboot-rules.md`** - Reglas operativas críticas
   - 8 reglas obligatorias
   - Lista de prohibiciones
   - Identificación automática de tareas
   - Aprendizaje de errores

3. **`docs/dev/ai-workflow.md`** - Flujo de trabajo estandarizado
   - Pasos obligatorios
   - Modo diagnóstico
   - Gestión de contexto
   - Criterios de aceptación

4. **`docs/dev/working-context.md`** - Memoria dinámica del sistema
   - Estado actual de cada dominio
   - Cambios recientes
   - Próximos pasos
   - Logros consolidados

5. **`docs/dev/error-patterns.md`** - Base de conocimientos de errores
   - 17 patrones documentados
   - Soluciones probadas
   - Ejemplos antes/después

6. **`docs/dev/prompt-template.md`** - Plantillas de interacción
   - Templates estandarizados
   - Comandos rápidos
   - Ejemplos de uso

7. **`docs/dev/comandos-rapidos.md`** - Sistema de atajos
   - Formato: `lee completamente: [archivo] + [tarea]`
   - 6 comandos disponibles
   - Flujo automático

8. **`docs/dev/plan/plan.md`** - Planificación de proyectos
   - Objetivos y estrategias
   - Pasos detallados
   - Timeline y riesgos

---

## Estado Actual del Sistema

### Dominios Activos

#### [CORE] Compilador y VM
- **Estado**: Funcional con limitaciones
- **Problema**: Backend de clases tiene bugs semánticos
- **Impacto**: Algunos archivos .jbo se generan vacíos
- **Archivos clave**: `sdk-dependiente/jas-compiler-c/`, `sdk-dependiente/jasboot-ir/`

#### [LIB] Biblioteca Estándar
- **Estado**: En expansión
- **Logro reciente**: Sistema de logging modular completo
- **Problema**: No se puede validar por bugs del compilador
- **Archivos clave**: `stdlib/logging/logger.jasb`

#### [APP] Aplicaciones con IA
- **Estado**: Funcional con fallbacks
- **Logros**: Neurixis IA refactorizado, Michelle IA creada
- **Problema**: Memoria neuronal a veces retorna "indefinido"
- **Archivos clave**: `apps/neurixis_IA/`, `apps/michelle_IA/`

---

## Capacidades del Sistema

### Memoria Neuronal (JMN)
- `recordar(clave, valor)` - Almacenamiento persistente
- `buscar(clave)` - Recuperación de información
- `pensar_respuesta()` - Generación cognitiva
- `asociar()` - Relación de conceptos

### Compilación y Ejecución
```bash
# Compilar
bin/jbc.exe archivo.jasb -o archivo.jbo

# Ejecutar
sdk-dependiente/jasboot-ir/bin/jasboot-ir-vm.exe archivo.jbo

# Atajo
bin/jb.cmd archivo.jasb
```

### Sintaxis Principal
- **Estructura**: `principal ... fin_principal`
- **Funciones**: `funcion ... fin_funcion`
- **Clases**: `clase ... fin_clase`
- **Control**: `si ... fin_si`, `mientras ... fin_mientras`
- **Tipos**: `entero`, `texto`, `flotante`, `caracter`, `lista`, `mapa`

---

## Interacción con el AI Agent

### Comandos Rápidos (Recomendado)
```
lee completamente: [archivo] + [tarea]
```

**Tareas disponibles:**
- `analiza` - Análisis completo
- `corrige` - Corrección de errores
- `mejora` - Optimización y mejora
- `documenta` - Generación de documentación
- `prueba` - Creación de pruebas
- `integra` - Integración con el sistema

### Ejemplos de Uso
```
lee completamente: stdlib/logging/logger.jasb + corrige
lee completamente: apps/neurixis_IA/generador.jasb + analiza
lee completamente: examples/demo_logging.jasb + documenta
```

### Flujo Automático
1. Leer archivo completamente
2. Identificar dominio [CORE]/[LIB]/[APP]
3. Consultar patrones de errores
4. Revisar contexto actual
5. Ejecutar tarea específica
6. Actualizar contexto con resultados

---

## Problemas Conocidos y Soluciones

### Errores Comunes de Compilación
- **Variables en clases**: Renombrar con sufijos (`_actual`, `_temp`)
- **Funciones anidadas**: Aplanar al nivel superior
- **recordar() con múltiples parámetros**: Concatenar en un string
- **Constructores**: Usar patrón de inicialización manual

### Problemas de Memoria Neuronal
- **"indefinido"**: Implementar fallbacks robustos
- **buscar() retorna nulo**: Usar valores por defecto
- **asociar() sintaxis**: Usar formato `asociar "A" con "B"`

### Issues de Rendimiento
- **Bucles infinitos**: Asegurar condición de salida
- **Fugas de memoria**: Liberar listas/mapas explícitamente
- **I/O síncrono**: Usar buffers para escritura

---

## Desarrollo Activo

### Proyectos en Progreso
1. **Sistema de Logging** - Completado, pendiente validación
2. **Michelle IA** - Chat inteligente funcional
3. **Neurixis IA** - Motor mejorado con fallbacks
4. **Sistema de Contexto** - Completo y operativo

### Próximos Pasos
- Diagnosticar bugs del compilador en clases
- Validar sistema de logging
- Mejorar integración de memoria neuronal
- Expandir biblioteca estándar

---

## Cómo Usar Este Archivo

### Para el AI Agent
1. **Leer este archivo primero** para entender el contexto completo
2. **Consultar los archivos de contexto** según la tarea
3. **Aplicar los patrones de errores** conocidos
4. **Seguir el workflow establecido** en ai-workflow.md
5. **Actualizar working-context.md** con los resultados

### Para Desarrolladores
1. **Usar como referencia rápida** del estado del sistema
2. **Entender la arquitectura** completa del proyecto
3. **Identificar problemas conocidos** y sus soluciones
4. **Seguir los flujos de trabajo** establecidos
5. **Contribuir al sistema de contexto** cuando se resuelvan nuevos problemas

---

## Estadísticas del Sistema

| Componente | Estado | Archivos | Problemas |
|------------|--------|----------|-----------|
| Compilador | Funcional | 50+ | 5 bugs conocidos |
| VM | Estable | 30+ | 2 issues menores |
| Librería | En expansión | 15+ | 3 pendientes |
| Aplicaciones | Funcionales | 10+ | 4 conocidos |
| Contexto AI | Completo | 8 | 0 críticos |

---

*Este archivo es el punto de entrada principal para entender y trabajar con el ecosistema Jasboot. Se mantiene actualizado con el estado más reciente del sistema.*
