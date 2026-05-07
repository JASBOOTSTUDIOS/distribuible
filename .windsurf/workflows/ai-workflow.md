# AI WORKFLOW - Jasboot (MEJORADO CON INVESTIGACIÓN PROFUNDA)

## 🔄 Flujo Obligatorio de Tareas

### FASE 0: INVESTIGACIÓN PROFUNDA (OBLIGATORIA - NO EJECUTAR CÓDIGO)

**REGLA DE ORO**: NO ejecutar NINGUNA tarea de código hasta completar 100% la investigación profunda.

1.  **Análisis de Contexto**: Leer completamente `working-context.md` para entender estado actual
2.  **Mapeo de Problemas**: Identificar TODOS los problemas potenciales, no solo el obvio
3.  **Investigación de Dominio**: Leer TODA la documentación relevante al dominio
4.  **Búsqueda en Internet**: Investigar online si la información local es insuficiente o desactualizada
5.  **Análisis de Causa Raíz**: Investigar profundamente POR QUÉ los problemas existen
6.  **Validación de Suposiciones**: Cuestionar TODAS las suposiciones del usuario y del sistema
7.  **Plan de Mitigación**: Preparar múltiples estrategias para cada problema identificado
8.  **Revisión con Usuario**: Presentar hallazgos y esperar confirmación antes de proceder

### FASE 1: EJECUCIÓN (SOLO DESPUÉS DE FASE 0 COMPLETA)

1.  **Identificar Dominio**: Determinar si la tarea es de `[CORE]`, `[LIB]` o `[APP]`.
2.  **Consulta de Patrones**: Leer `.windsurf/workflows/error-patterns.md` para evitar errores conocidos del dominio.
3.  **Consulta de Documentación Específica**:
    - **Si la tarea involucra CLASES**: Leer `docs/LENGUAJE/clases/` ANTES de escribir código
    - **Si la tarea involucra JMN**: Leer `docs/LENGUAJE/jmn/` ANTES de escribir código
    - **Siempre**: Consultar `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md` como referencia principal
4.  **Verificación de Errores**: Si el error actual está documentado, aplicar solución probada inmediatamente.
5.  **Planificación (`plan/plan.md`)**: Crear o actualizar el plan con enfoque en el dominio identificado.
6.  **Validación de Dependencias**: Identificar qué archivos se verán afectados (Mapa de Dependencias).
7.  **Implementación Incremental**: Codificar paso a paso, actualizando `working-context.md`.
8.  **Validación Mecánica**: Compilar con `jbc.exe` y reportar resultados reales.

---

## 🔍 FASE 0: INVESTIGACIÓN PROFUNDA DETALLADA

### 0.1. **Análisis de Contexto Completo**

**OBLIGATORIO**: Leer y analizar:
- `working-context.md` - Estado completo del proyecto
- `jasboot.md` - Visión general del ecosistema
- `JASBOOT-CONTEXT.md` - Contexto del lenguaje
- `jasboot-rules.md` - Reglas críticas
- `contexto-inteligente.md` - Sistema de contexto
- **Búsqueda online** si la información local es insuficiente

**Preguntas a responder**:
- ¿Cuál es el estado REAL del proyecto?
- ¿Qué problemas están ACTIVAMENTE documentados?
- ¿Qué dependencias existen y cuál es su estado?
- ¿Qué errores han ocurrido previamente?

### 0.2. **Mapeo de Problemas Sistemático**

**Identificar TODOS los problemas potenciales**:
- Problemas técnicos (compilación, sintaxis)
- Problemas de arquitectura (diseño, estructura)
- Problemas de dependencias (módulos, versiones)
- Problemas de entorno (herramientas, configuración)
- Problemas de conocimiento (documentación faltante)
- Problemas de proceso (flujo de trabajo)

**Para cada problema**:
- Causa raíz (¿POR QUÉ existe?)
- Síntomas (¿CÓMO se manifiesta?)
- Impacto (¿QUÉ afecta?)
- Urgencia (¿CUÁNDO debe resolverse?)

### 0.3. **Investigación de Dominio Exhaustiva**

**Para el dominio identificado**:
- Leer TODA la documentación del dominio
- Analizar TODOS los ejemplos existentes
- Investigar TODOS los patrones de error conocidos
- Revisar TODAS las dependencias del dominio
- **Buscar en internet** información actualizada si la local es insuficiente

**Documentación obligatoria por dominio**:
- **CORE**: `docs/LENGUAJE/`, `docs/TECNICO/`, `docs/PROYECTO/`
- **LIB**: `stdlib/`, ejemplos de librerías existentes
- **APP**: `apps/`, patrones de aplicaciones existentes

### 0.4. **Análisis de Causa Raíz Profundo**

**Técnica de los 5 Porqués**:
1. ¿Por qué existe este problema?
2. ¿Por qué existe esa causa?
3. ¿Por qué existe esa causa secundaria?
4. ¿Por qué existe esa causa terciaria?
5. ¿Por qué existe esa causa cuaternaria?

**Investigar**:
- ¿Es un problema de conocimiento del lenguaje?
- ¿Es un problema de diseño de la arquitectura?
- ¿Es un problema de implementación del compilador?
- ¿Es un problema de flujo de trabajo?
- ¿Es un problema de expectativas vs realidad?

### 0.5. **Validación de Suposiciones Crítica**

**Cuestionar TODO**:
- ¿Las suposiciones del usuario son correctas?
- ¿Las suposiciones del sistema son correctas?
- ¿Las suposiciones del agente son correctas?
- ¿La documentación está actualizada?
- ¿Los ejemplos son relevantes?

**Validar con evidencia**:
- NO suponer que algo funciona - PROBARLO
- NO confiar en documentación antigua - VERIFICARLA
- NO asumir que el usuario entiende - PREGUNTAR
- NO creer que el código es correcto - COMPILARLO
- **NO limitarse a información local** - BUSCAR EN INTERNET si es necesario

### 0.6. **Plan de Mitigación Múltiple**

**Para cada problema identificado**:
- Estrategia A (enfoque directo)
- Estrategia B (enfoque alternativo)
- Estrategia C (enfoque de contención)
- Estrategia D (enfoque de último recurso)

**Preparar para fallos**:
- ¿Qué pasa si la solución A no funciona?
- ¿Qué pasa si el compilador falla?
- ¿Qué pasa si el usuario cambia los requisitos?
- ¿Qué pasa si la documentación es incorrecta?

### 0.7. **Revisión con Usuario OBLIGATORIA**

**Presentar hallazgos**:
- Resumen de problemas encontrados
- Análisis de causa raíz
- Plan de acción propuesto
- Riesgos y mitigaciones
- Tiempo estimado

**Esperar confirmación**:
- ¿El usuario está de acuerdo con el análisis?
- ¿El usuario quiere modificar el plan?
- ¿El usuario tiene información adicional?
- ¿El usuario confirma que podemos proceder?

---

---

## 1.  **Consulta Obligatoria de Documentación Específica**

**DESPUÉS DE COMPLETAR FASE 0 DE INVESTIGACIÓN:**

**ANTES DE ESCRIBIR CUALQUIER CÓDIGO QUE INVOLUCRE:**

### 1.1. **CLASES**
- **OBLIGATORIO**: Leer `docs/LENGUAJE/clases/` completo
- **Sintaxis**: `clase`, `extends`, `privado`, `este`, `fin_clase`
- **Constructores**: Sintaxis específica para inicialización
- **Herencia**: Reglas y limitaciones
- **Métodos**: Visibilidad y sobrecarga

### 1.2. **JMN (Memoria Neuronal)**
- **OBLIGATORIO**: Leer `docs/LENGUAJE/jmn/` completo
- **Operaciones**: `recordar`, `buscar`, `pensar`, `asociar`
- **Sintaxis**: Uso correcto de `con valor`, `con`, etc.
- **Inicialización**: `crear_memoria`, `cerrar_memoria`
- **Patrones**: `asociar_secuencia`, `propagar_activacion`

### 1.3. **REFERENCIA PRINCIPAL**
- **SIEMPRE**: `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md`
- **Validación**: Verificar cada construcción en la referencia
- **Ejemplos**: Seguir ejemplos oficiales exactamente

**PROHIBIDO:**
- Escribir código de clases sin consultar `docs/LENGUAJE/clases/`
- Escribir código JMN sin consultar `docs/LENGUAJE/jmn/`
- Usar sintaxis basada en suposiciones
- Inventar construcciones del lenguaje

---

## 🔍 Modo Diagnóstico (Si algo falla)

**SI ALGO FALLA DURANTE LA EJECUCIÓN:**

### 1.1. **Pausa Inmediata y Análisis**
- **DETENER** toda ejecución de código
- **VOLVER** a FASE 0 de investigación
- **IDENTIFICAR** qué suposición fue incorrecta
- **DOCUMENTAR** el error real encontrado

### 1.2. **Diagnóstico Sistemático**

Si el sistema compila pero tiene errores lógicos (ej: JMN devuelve "indefinido"):

1.  **Consultar Patrones**: Revisar `.windsurf/workflows/error-patterns.md` para errores conocidos del dominio.
2.  **Consultar Documentación Específica**:
    - **Errores de CLASES**: Revisar `docs/LENGUAJE/clases/` para sintaxis correcta
    - **Errores de JMN**: Revisar `docs/LENGUAJE/jmn/` para operaciones correctas
3.  **Aislar el Problema**: Crear un archivo `test_*.jasb` mínimo que reproduzca el error.
4.  **Verificar Entorno**: ¿Está la memoria inicializada? ¿Los archivos existen?
5.  **Logs Cognitivos**: Insertar `imprimir "mensaje"` en puntos clave para rastrear el flujo de datos.
6.  **Consultar Reglas**: Re-mapear el problema contra `jasboot-rules.md`.

### 1.3. **Análisis de Fallo Profundo**

**Para cada error**:
- ¿Qué suposición del agente fue incorrecta?
- ¿Qué parte de la documentación es ambigua?
- ¿Qué comportamiento del compilador es inesperado?
- ¿Qué requisito del usuario no fue claro?

**Actualizar conocimiento**:
- Documentar el error real en `working-context.md`
- Actualizar `error-patterns.md` si es un nuevo patrón
- Revisar y actualizar suposiciones del agente

---

## 1.  **Manejo de Problemas de Herramientas**

Si alguna herramienta del sistema falla o entra en bucle:

### 1.1. **Problemas Comunes de Herramientas**
- **Edit Tool Loop**: `edit` muestra "no changed lines" repetidamente
- **Read Tool Errors**: Fallos al leer archivos
- **Command Tool Failures**: Comandos que no ejecutan
- **Memory System Issues**: Problemas con contexto o memoria

### 1.2. **Protocolo de Recuperación**
1. **Identificar el Patrón**: Reconocer si es un bucle o error sistemático
2. **Detener Inmediatamente**: No continuar con la herramienta problemática
3. **Alternar Estrategia**: Usar otro tool o enfoque diferente
4. **Documentar el Problema**: Registrar en `working-context.md` el error técnico
5. **Comunicar al Usuario**: Explicar el problema y la solución alternativa

### 1.3. **Estrategias Alternativas**
- **Para Edit Loop**: Usar `multi_edit` o `write_to_file` para cambios grandes
- **Para Read Errors**: Verificar rutas y permisos, usar `list_dir` para explorar
- **Para Command Failures**: Verificar sintaxis, usar comandos más simples
- **Para Memory Issues**: Reiniciar contexto, usar `create_memory` para estado

### 1.4. **Prevención**
- **Validar antes de ejecutar**: Verificar que los cambios sean reales
- **Usar diffs específicos**: Evitar cambios redundantes
- **Monitorear respuestas**: Prestar atención a mensajes de error del sistema
- **Tener planes B**: Siempre considerar enfoques alternativos

---

## 📝 Gestión de Contexto Inteligente

### Durante la Tarea:

- **Usar sistema de contexto inteligente**: Ver `.windsurf/workflows/contexto-inteligente.md`
- **Actualizar `working-context.md`** con mapa estructurado, no texto completo
- **Mapear archivos por función**: Ubicación exacta con líneas específicas
- **Actualizar incrementalmente**: Solo lo que cambia, sin duplicación
- **Debug automático**: Al detectar problemas, leer archivos involucrados usando mapa

### Al Finalizar:

- **Compactar**: Resumir en `historial_tareas` del mapa
- **Limpiar secciones temporales**: `debug_activo`, cambios recientes
- **Actualizar `mapa_archivos`**: Reflejar estado final de todos los archivos
- **Preparar Siguiente**: En `proximos_pasos` del proyecto activo

### Principios de Actualización:

1. **No duplicar estado** - Usar mapa en lugar de texto completo
2. **Trazabilidad exacta** - Referenciar líneas específicas, no "en el archivo"
3. **Actualización focalizada** - Modificar solo función afectada
4. **Debug por dependencias** - Leer archivos relacionados automáticamente
5. **Historial organizado** - Por fecha y tarea, no por orden cronológico
6. **Sin versiones duplicadas** - Siempre trabajar sobre existentes

---

## 🔄 Gestión de Contexto Continuo en Conversaciones

### Propósito
Mantener un flujo de contexto continuo entre sesiones del IDE para que el AI responda y actúe según el último diálogo.

### Archivo de Contexto Principal
- **Ubicación**: `.windsurf/chats/Conversacion-actual.md`
- **Propósito**: Almacenar respuestas del IDE y mantener contexto continuo
- **Contenido**: Respuestas estructuradas del IDE, no el chat completo

### Flujo de Contexto Continuo

#### 1. **Antes de Responder (OBLIGATORIO)**
```bash
# Leer contexto de conversación anterior
LEER: .windsurf/chats/Conversacion-actual.md
ANALIZAR: Últimas respuestas y decisiones tomadas
IDENTIFICAR: Estado actual del proyecto según contexto
```

#### 2. **Durante la Respuesta**
- **Basar respuesta** en el contexto de `Conversacion-actual.md`
- **Referenciar decisiones** anteriores para mantener coherencia
- **Continuar trabajo** desde donde se quedó la última vez
- **Mantener coherencia** con soluciones y enfoques previos

#### 3. **Después de Responder (OBLIGATORIO)**
```bash
# Actualizar contexto con nueva respuesta
ACTUALIZAR: .windsurf/chats/Conversacion-actual.md
AGREGAR: Respuesta actual con timestamp
REGISTRAR: Decisiones tomadas y próximos pasos
SINCRONIZAR: Con working-context.md si es necesario
```

### Estructura de Conversacion-actual.md
```markdown
# CONVERSACIÓN ACTUAL - Contexto Continuo

## Última Sesión: [YYYY-MM-DD HH:MM:SS]

### Respuesta del IDE
[Contenido completo de la última respuesta]

### Decisiones Tomadas
- [Decisión 1]
- [Decisión 2]

### Próximos Pasos Identificados
1. [Paso 1]
2. [Paso 2]

### Estado del Proyecto
- **Dominio Activo**: [CORE/LIB/APP]
- **Archivos Modificados**: [lista]
- **Problemas Resueltos**: [lista]
- **Problemas Pendientes**: [lista]

### Contexto Técnico Relevante
[Información técnica importante para mantener continuidad]

---

## Historial de Sesiones

### [YYYY-MM-DD HH:MM:SS]
[Resumen de la sesión anterior]

### [YYYY-MM-DD HH:MM:SS]
[Resumen de la sesión anterior]
```

### Integración con Flujo de Trabajo

#### Antes de FASE 0 (Investigación)
1. **Leer `Conversacion-actual.md`** para entender estado actual
2. **Identificar si el problema es continuación** de trabajo anterior
3. **Determinar si se necesita retomar** desde punto específico

#### Durante FASE 0 (Investigación)
- **Considerar contexto anterior** al analizar problemas
- **No repetir investigación** ya realizada
- **Construir sobre conocimiento** previo del proyecto

#### Durante FASE 1 (Ejecución)
- **Continuar desde donde se quedó** según contexto
- **Mantener coherencia** con soluciones previas
- **Referenciar decisiones** anteriores en nuevas soluciones

#### Al Finalizar
1. **Actualizar `Conversacion-actual.md`** con resumen completo
2. **Documentar estado final** del trabajo realizado
3. **Preparar próximos pasos** para próxima sesión
4. **Sincronizar con `working-context.md`** si hay cambios relevantes

### Reglas de Contexto Continuo

#### OBLIGATORIO
- **SIEMPRE leer** `Conversacion-actual.md` antes de responder
- **SIEMPRE actualizar** `Conversacion-actual.md` después de responder
- **MANTENER coherencia** con sesiones anteriores
- **CONSTRUIR sobre** conocimiento previo, no repetir

#### PROHIBIDO
- **Ignorar contexto** de sesiones anteriores
- **Repetir investigación** ya realizada
- **Contradecir decisiones** previas sin justificación
- **Empezar de cero** cuando hay contexto disponible

#### BUENAS PRÁCTICAS
- **Referenciar explícitamente** trabajo anterior
- **Explicar cambios** de enfoque si son necesarios
- **Mantener continuidad** en soluciones y patrones
- **Documentar evolución** del pensamiento y decisiones

### Manejo de Conflictos de Contexto

#### Si el contexto anterior es incorrecto:
1. **Identificar el error** en el contexto previo
2. **Explicar por qué** se necesita cambiar de enfoque
3. **Documentar la corrección** en `Conversacion-actual.md`
4. **Justificar el cambio** con evidencia técnica

#### Si hay múltiples enfoques previos:
1. **Analizar todos los enfoques** documentados
2. **Elegir el mejor** basado en evidencia actual
3. **Explicar la decisión** y por qué es superior
4. **Integrar lo útil** de enfoques anteriores

### Sincronización con Otros Archivos de Contexto

#### Con working-context.md:
- **Mantener coherencia** entre ambos archivos
- **Sincronizar estado** del proyecto cuando cambie
- **Evitar duplicación** de información

#### Con jasboot-rules.md:
- **Aplicar reglas consistentemente** across sesiones
- **Actualizar reglas** si se aprenden nuevas lecciones
- **Mantener coherencia** en la aplicación de principios

---

## 🔄 Gestión de Contexto Continuo en Conversaciones

### Propósito
Mantener un flujo de contexto continuo entre sesiones del IDE para que el AI responda y actúe según el último diálogo.

### Archivo de Contexto Principal
- **Ubicación**: `.windsurf/chats/Conversacion-actual.md`
- **Propósito**: Almacenar respuestas del IDE y mantener contexto continuo
- **Contenido**: Respuestas estructuradas del IDE, no el chat completo

### Flujo de Contexto Continuo

#### 1. **Antes de Responder (OBLIGATORIO)**
```bash
# Leer contexto de conversación anterior
LEER: .windsurf/chats/Conversacion-actual.md
ANALIZAR: Últimas respuestas y decisiones tomadas
IDENTIFICAR: Estado actual del proyecto según contexto
```

#### 2. **Durante la Respuesta**
- **Basar respuesta** en el contexto de `Conversacion-actual.md`
- **Referenciar decisiones** anteriores para mantener coherencia
- **Continuar trabajo** desde donde se quedó la última vez
- **Mantener coherencia** con soluciones y enfoques previos

#### 3. **Después de Responder (OBLIGATORIO)**
```bash
# Actualizar contexto con nueva respuesta
ACTUALIZAR: .windsurf/chats/Conversacion-actual.md
AGREGAR: Respuesta actual con timestamp
REGISTRAR: Decisiones tomadas y próximos pasos
SINCRONIZAR: Con working-context.md si es necesario
```

### Estructura de Conversacion-actual.md
```markdown
# CONVERSACIÓN ACTUAL - Contexto Continuo

## Última Sesión: [YYYY-MM-DD HH:MM:SS]

### Respuesta del IDE
[Contenido completo de la última respuesta]

### Decisiones Tomadas
- [Decisión 1]
- [Decisión 2]

### Próximos Pasos Identificados
1. [Paso 1]
2. [Paso 2]

### Estado del Proyecto
- **Dominio Activo**: [CORE/LIB/APP]
- **Archivos Modificados**: [lista]
- **Problemas Resueltos**: [lista]
- **Problemas Pendientes**: [lista]

### Contexto Técnico Relevante
[Información técnica importante para mantener continuidad]

---

## Historial de Sesiones

### [YYYY-MM-DD HH:MM:SS]
[Resumen de la sesión anterior]

### [YYYY-MM-DD HH:MM:SS]
[Resumen de la sesión anterior]
```

### Integración con Flujo de Trabajo

#### Antes de FASE 0 (Investigación)
1. **Leer `Conversacion-actual.md`** para entender estado actual
2. **Identificar si el problema es continuación** de trabajo anterior
3. **Determinar si se necesita retomar** desde punto específico

#### Durante FASE 0 (Investigación)
- **Considerar contexto anterior** al analizar problemas
- **No repetir investigación** ya realizada
- **Construir sobre conocimiento** previo del proyecto

#### Durante FASE 1 (Ejecución)
- **Continuar desde donde se quedó** según contexto
- **Mantener coherencia** con soluciones previas
- **Referenciar decisiones** anteriores en nuevas soluciones

#### Al Finalizar
1. **Actualizar `Conversacion-actual.md`** con resumen completo
2. **Documentar estado final** del trabajo realizado
3. **Preparar próximos pasos** para próxima sesión
4. **Sincronizar con `working-context.md`** si hay cambios relevantes

### Reglas de Contexto Continuo

#### OBLIGATORIO
- **SIEMPRE leer** `Conversacion-actual.md` antes de responder
- **SIEMPRE actualizar** `Conversacion-actual.md` después de responder
- **MANTENER coherencia** con sesiones anteriores
- **CONSTRUIR sobre** conocimiento previo, no repetir

#### PROHIBIDO
- **Ignorar contexto** de sesiones anteriores
- **Repetir investigación** ya realizada
- **Contradecir decisiones** previas sin justificación
- **Empezar de cero** cuando hay contexto disponible

#### BUENAS PRÁCTICAS
- **Referenciar explícitamente** trabajo anterior
- **Explicar cambios** de enfoque si son necesarios
- **Mantener continuidad** en soluciones y patrones
- **Documentar evolución** del pensamiento y decisiones

### Manejo de Conflictos de Contexto

#### Si el contexto anterior es incorrecto:
1. **Identificar el error** en el contexto previo
2. **Explicar por qué** se necesita cambiar de enfoque
3. **Documentar la corrección** en `Conversacion-actual.md`
4. **Justificar el cambio** con evidencia técnica

#### Si hay múltiples enfoques previos:
1. **Analizar todos los enfoques** documentados
2. **Elegir el mejor** basado en evidencia actual
3. **Explicar la decisión** y por qué es superior
4. **Integrar lo útil** de enfoques anteriores

### Sincronización con Otros Archivos de Contexto

#### Con working-context.md:
- **Mantener coherencia** entre ambos archivos
- **Sincronizar estado** del proyecto cuando cambie
- **Evitar duplicación** de información

#### Con jasboot-rules.md:
- **Aplicar reglas consistentemente** across sesiones
- **Actualizar reglas** si se aprenden nuevas lecciones
- **Mantener coherencia** en la aplicación de principios

### Beneficios del Contexto Continuo
1. **Coherencia** en respuestas y soluciones
2. **Eficiencia** al evitar repetir investigación
3. **Continuidad** en el desarrollo del proyecto
4. **Aprendizaje** acumulativo del AI sobre el proyecto
5. **Trazabilidad** completa de decisiones y evolución

---

## ⚠️ Protocolo de Reanudación

Si se alcanza el límite de tiempo:

1.  **Snapshot**: Escribir el estado exacto del cursor y la última prueba ejecutada en `working-context.md`.
2.  **Continuidad**: Al reanudar, el primer paso es **LEER** `working-context.md` y el **ÚLTIMO ERROR** registrado.
3.  **Evitar Bucle**: No repetir una solución que ya falló anteriormente.
4.  **Re-iniciar FASE 0**: Volver a investigación profunda antes de continuar.
5.  **Validar Suposiciones**: Cuestionar todo lo que se asumía antes.
6.  **Actualizar Plan**: Ajustar el plan basado en nuevos hallazgos.

---

## ✅ Criterios de Aceptación (Definición de "Terminado")

### FASE 0: Investigación Profunda
- [ ] **Análisis completo**: Se leyó y analizó TODO el contexto relevante
- [ ] **Problemas mapeados**: Se identificaron TODOS los problemas potenciales
- [ ] **Causa raíz**: Se investigó el POR QUÉ de cada problema
- [ ] **Suposiciones validadas**: Se cuestionaron y validaron todas las suposiciones
- [ ] **Plan múltiple**: Se prepararon múltiples estrategias de mitigación
- [ ] **Revisión usuario**: Se presentaron hallazgos y se obtuvo confirmación

### FASE 1: Ejecución
- [ ] Código compila sin advertencias con `jbc.exe`.
- [ ] La lógica responde al [DOMINIO] correcto.
- [ ] No se han creado archivos duplicados.
- [ ] `working-context.md` está compactado y listo para la siguiente sesión.
- [ ] (Si aplica) Se ha actualizado `error-patterns.md` con nuevos hallazgos.
- [ ] (Si se resolvió error) El patrón está documentado con ejemplo antes/después.
- [ ] **Validación de Documentación**: Se consultó la documentación específica ANTES de codificar:
  - [ ] Si involucra CLASES: Se leyó `docs/LENGUAJE/clases/`
  - [ ] Si involucra JMN: Se leyó `docs/LENGUAJE/jmn/`
  - [ ] Siempre: Se consultó `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md`
- [ ] **Manejo de Herramientas**: Se gestionaron correctamente problemas técnicos:
  - [ ] Se identificaron patrones de error de herramientas
  - [ ] Se aplicaron estrategias alternativas cuando fue necesario
  - [ ] Se documentaron problemas técnicos en `working-context.md`
- [ ] **Aprendizaje del Agente**: Se actualizó el conocimiento basado en experiencia real
