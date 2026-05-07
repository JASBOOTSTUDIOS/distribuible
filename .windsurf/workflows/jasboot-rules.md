# JASBOOT RULES - Reglas Críticas para IA

## PRIORIDAD DE REGLAS (ORDEN INTOCABLE)

Orden de importancia (NO VIOLAR):

### FASE 0: INVESTIGACIÓN PROFUNDA (REGLA MÁXIMA)

0. **INVESTIGACIÓN PROFUNDA OBLIGATORIA** - NO ejecutar NINGUNA tarea hasta completar investigación 100%
    - Leer TODO el contexto relevante antes de hacer suposiciones
    - Cuestionar TODAS las suposiciones del usuario, sistema y agente
    - Investigar la CAUSA RAÍZ de cada problema, no solo síntomas
    - Validar con evidencia REAL, no con suposiciones
    - **BUSCAR EN INTERNET** si hace falta para obtener información actualizada
    - Preparar múltiples estrategias antes de ejecutar
    - Obtener confirmación del usuario antes de proceder

### FASE 1: EJECUCIÓN (SOLO DESPUÉS DE FASE 0)

1. **Compilabilidad con jbc** - Si no compila, todo lo demás es irrelevante
2. **Sintaxis válida del lenguaje** - Palabras clave en español, estructura correcta
3. **Reglas de tipado** - Sin mezclar tipos sin conversión explícita
4. **Estructura del programa** - `principal` obligatorio, bloques `fin_*`
5. **Palabras reservadas** - NUNCA usar palabras reservadas del lenguaje como nombres de variables (ej: `resultado`, `si`, `mientras`, `funcion`, etc.). Usar prefijo `_` si es necesario (ej: `_resultado`, `_si`, `_mientras`).
6. **Pruebas** - No crear archivos paralelos para sustituir el viejo por uno nuevo funcional, se debe de corregir el existente no crear uno nuevo.
7. **Validación Real** - NUNCA asumir que algo funciona. Siempre compilar y ejecutar el código para VALIDAR que funciona correctamente. No suponer resultados, probarlos realmente.
8. **Persistencia** - Trabajar en el archivo existente hasta que funcione completamente. No crear alternativas. Corregir errores hasta lograr compilación y ejecución exitosa.
9. **NO CREAR VERSIONES SIMPLIFICADAS** - Si un archivo no funciona, se corrige ESE archivo. NUNCA crear versiones simplificadas como "simple", "basic", "v2", etc. Siempre trabajar en el archivo original hasta que funcione.
10. **SINTAXIS REAL OBLIGATORIA** - SIEMPRE usar la sintaxis real y actualizada de Jasboot según `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md`. NUNCA inventar sintaxis ni usar versiones desactualizadas.
11. **Buenas prácticas** - Modularidad, comentarios, optimización

**Si hay conflicto:**

- FASE 0 > FASE 1 (Investigación > Ejecución)
- SIEMPRE priorizar investigación completa sobre rapidez
- Compilación correcta > código elegante pero roto
- Evidencia real > suposiciones elegantemente incorrectas

---

## Auto-corrección (MODO INTELIGENTE)

### Si detectas un error DURANTE LA INVESTIGACIÓN:

1. **PAUSAR INMEDIATAMENTE** - No continuar con ninguna ejecución
2. **IDENTIFICAR SUPOSICIÓN INCORRECTA** - ¿Qué suposición fue errónea?
3. **INVESTIGAR MÁS PROFUNDO** - Leer más documentación, analizar más contexto
4. **BUSCAR EN INTERNET** si la información local es insuficiente o desactualizada
5. **DOCUMENTAR EL APRENDIZAJE** - Actualizar conocimiento del agente
6. **REVISAR PLAN** - Ajustar estrategia basada en nuevo conocimiento
7. **PRESENTAR AL USUARIO** - Explicar el hallazgo y esperar confirmación

### Si detectas un error DURANTE LA EJECUCIÓN:

1. **NO entregar código incorrecto** - Corregir automáticamente antes de responder
2. **Explicar brevemente** la corrección realizada
3. **TRABAJAR SIEMPRE EN EL ARCHIVO ORIGINAL** - NUNCA crear versiones simplificadas
4. **CONSULTAR SIEMPRE LA REFERENCIA** - Leer `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md` antes de escribir código
5. **USAR SINTAXIS REAL ACTUALIZADA** - NUNCA inventar sintaxis ni usar versiones obsoletas
6. **VALIDAR CON COMPILACIÓN REAL** - Ejecutar `jbc archivo.jasb -o archivo.jbo`
7. **VALIDAR CON EJECUCIÓN REAL** - Ejecutar `jasboot-ir-vm archivo.jbo`
8. **NO ASUMIR RESULTADOS** - Esperar salida real del compilador y VM
9. **PERSISTIR HASTA ÉXITO** - Seguir corrigiendo el mismo archivo hasta que funcione
10. **DOCUMENTAR EL ERROR REAL** - Actualizar `working-context.md` con el error encontrado

Si no estás seguro de una función:

- **VOLVER A FASE 0** - Investigar más profundamente
- Generar la versión más segura y simple que compile y luego mejorarla si es necesario
- Usar funciones básicas documentadas en lugar de features experimentales
- **PROBAR REALMENTE** antes de afirmar que funciona

---

## Consulta Obligatoria de Referencia (SINTAXIS REAL)

**ANTES DE ESCRIBIR CUALQUIER CÓDIGO JASBOOT:**

1. **LEER SIEMPRE** `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md`
2. **VERIFICAR SINTAXIS ACTUAL** - No usar versiones desactualizadas
3. **CONSULTAR SECCIÓN ESPECÍFICA** para cada construcción:
   - **Clases**: Sección de Clases y Herencia
   - **Funciones**: Sección de Funciones y Procedimientos
   - **Tipos**: Sección de Tipos de Datos
   - **Control de flujo**: Sección de Estructuras de Control
   - **Módulos**: Sección de Módulos y Exportación
4. **VALIDAR OPCODES** - Usar solo opcodes documentados
5. **SEGUIR EJEMPLOS** - Basarse en ejemplos oficiales de la referencia

**PROHIBIDO:**
- Inventar sintaxis no documentada
- Usar palabras clave obsoletas
- Asumir comportamiento sin verificar en referencia
- Mezclar sintaxis de diferentes versiones

**OBLIGATORIO:**
- Tener la referencia abierta mientras se escribe código
- Verificar cada construcción en la referencia
- Usar la sintaxis más reciente documentada
- Seguir exactamente los ejemplos oficiales

---

## Validación Real (NO SIMULACIÓN)

### Durante la Investigación:

1. **VALIDAR SUPOSICIONES** - No confiar en memoria o intuición
2. **LEER DOCUMENTACIÓN REAL** - No confiar en resúmenes o memoria
3. **VERIFICAR ESTADO ACTUAL** - Leer `working-context.md` completo
4. **CUESTIONAR TODO** - No aceptar nada como verdadero sin evidencia
5. **BUSCAR EVIDENCIA** - Encontrar pruebas reales de cada afirmación

### Durante la Ejecución:

1. **COMPILAR REALMENTE** - Ejecutar `jbc archivo.jasb -o archivo.jbo`
2. **EJECUTAR REALMENTE** - Ejecutar `jasboot-ir-vm archivo.jbo`
3. **VERIFICAR SALIDA REAL** - Leer la salida real del compilador y VM
4. **NO SIMULAR MENTALMENTE** - La simulación no es suficiente
5. **NO ASUMIR RESULTADOS** - Esperar confirmación real

Si hay errores:

- **PAUSAR Y ANALIZAR** - ¿Qué suposición fue incorrecta?
- **CORREGIR ANTES de responder**
- **TRABAJAR SIEMPRE EN EL MISMO ARCHIVO** - NUNCA crear alternativas
- **PROBAR DE NUEVO** después de cada corrección
- **NO ENTREGAR** hasta que compile y ejecute correctamente
- **DOCUMENTAR** los errores reales encontrados
- **ELIMINAR** cualquier archivo paralelo si se creó por error

---

## REGLAS OBLIGATORIAS (NO ROMPER)

### 0. Investigación Profunda (REGLA MÁXIMA)

- **FASE 0 OBLIGATORIA** - NO ejecutar código sin investigación completa
- **LEER TODO** - Contexto completo, no solo partes relevantes
- **CUESTIONAR TODO** - Suposiciones de usuario, sistema y agente
- **INVESTIGAR CAUSA RAÍZ** - 5 porqués para cada problema
- **VALIDAR CON EVIDENCIA** - Probar, no suponer
- **BUSCAR EN INTERNET** si la información local es insuficiente
- **PREPARAR MÚLTIPLES ESTRATEGIAS** - Plan A, B, C, D
- **OBTENER CONFIRMACIÓN** - Presentar hallazgos y esperar aprobación

### 1. Sintaxis en Español y Referencia Obligatoria

- **SIEMPRE** consultar `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md` antes de escribir código
- **USAR EXCLUSIVAMENTE** la sintaxis documentada en la referencia actualizada
- **SIEMPRE** usar palabras clave en español: `cuando`, `si`, `mientras`, `romper`, `continuar`
- Funciones: `funcion` ... `fin_funcion` (según referencia)
- Clases: `clase` ... `fin_clase` (según referencia)
- Registros: `registro` ... `fin_registro` (según referencia)
- Principal: `principal` ... `fin_principal` (según referencia)
- **NUNCA** inventar sintaxis ni usar versiones obsoletas

### 2. Estructura Mínima

- Todo programa **DEBE** tener `principal` como punto de entrada
- Estructura básica:

```jasb
principal
    // código aquí
fin_principal
```

### 3. Tipado Estricto

- **NO** mezclar tipos sin conversión explícita
- Tipos válidos incluyen (no limitado a): `entero`, `texto`, `flotante`, `caracter`, `lista`, `mapa`, `bool`, `decimal`, `u32`, `u64`, `u8`, `byte`, `bytes`, `vec2`, `vec3`, `vec4`, `mat4`, `mat3`, `cualquiera`, `nulo`, `indefinido`
- Declaración: `tipo nombre_variable`
- Conversiones: `convertir_entero()`, `convertir_flotante()`, `str_a_entero()`, `str_a_flotante()`

### 4. Memoria Neuronal (JMN)

- Usar funciones cognitivas correctamente:
  - `recordar(clave, valor)` - almacena
  - `buscar(clave)` - recupera
  - `pensar(pregunta)` - procesa
- **NO** usar sin contexto apropiado

### 5. Clases y Herencia

- Sintaxis: `clase Nombre` ... `fin_clase`
- Herencia: `clase Hijo extiende Padre`
- Métodos privados: `privado funcion metodo()`
- Referencia a instancia: `este.campo`

### 6. Compilabilidad

- El código **DEBE** compilar con `jbc`
- **NO** usar sintaxis inventada
- **NO** omitir `fin_*` correspondiente

### 7. Módulos

- Importar: `usar {funcion} de "modulo.jasb"`
- Exportar: `enviar funcion` o `enviar clase`
- **NO** usar sin declaración previa

### 8. Modo de desarrollo

- **FASE 0 PRIMERO** - Investigación completa antes de cualquier código
- no se hace todo en cada archivo de golpe, se hace de a poco, cada funcion se hace una a una, se prueba, y si pasa se segue a la siguiente siempre y cuando tenga perfecto funcionamiento.
- **PERSISTENCIA OBLIGATORIA** - Trabajar SIEMPRE en el archivo existente hasta que funcione completamente
- **NO CREAR ALTERNATIVAS** - Nunca crear archivos paralelos cuando el original tiene errores
- **CORRECCIÓN ITERATIVA** - Corregir errores uno por uno hasta lograr funcionamiento completo
- **VALIDACIÓN CONTINUA** - Compilar y ejecutar después de cada corrección
- **APRENDIZAJE CONTINUO** - Actualizar conocimiento del agente con cada error

### 10. Persistencia y Archivos Existentes

**REGLA DE ORO:** Si un archivo no funciona, se corrige ESE archivo. NO se crea otro.

- **SIEMPRE** trabajar sobre el archivo existente
- **NUNCA** crear alternativas como `archivo_v2.jasb`, `archivo_simple.jasb`, `archivo_basic.jasb`
- **NUNCA** crear versiones "simplificadas" o "reducidas" - corregir el original
- **CORREGIR** errores uno por uno hasta que el archivo original compile y ejecute
- **ELIMINAR** inmediatamente cualquier archivo paralelo creado
- **DOCUMENTAR** el estado real del archivo (funcional, con errores, etc.)
- **PERSISTIR** hasta que el archivo original esté completamente funcional
- **INVESTIGAR** POR QUÉ el archivo original falló antes de corregir

**PROHIBIDO ABSOLUTAMENTE:**
- Crear `archivo_simple.jasb` cuando `archivo.jasb` tiene errores
- Crear `archivo_v2.jasb` como "versión mejorada"
- Abandonar el archivo original por uno nuevo
- Trabajar en alternativas en lugar del original

Las palabras reservadas del lenguaje NO se deben usar como nombres de variables o funciones:

  **Estructura de programa:** `principal`, `fin_principal`, `funcion`, `fin_funcion`, `registro`, `fin_registro`, `clase`, `fin_clase`, `constante`, `biblioteca`, `usar`, `enviar`, `privado`, `extiende`, `este`

  **Control de flujo:** `cuando`, `fin_cuando`, `si`, `sino`, `fin_si`, `mientras`, `fin_mientras`, `romper`, `continuar`, `hacer`, `fin_hacer`, `retornar`, `retorna`, `seleccionar`, `caso`, `defecto`, `fin_seleccionar`, `para_cada`, `fin_para_cada`, `sobre`, `intentar`, `atrapar`, `fin_intentar`, `lanzar`

  **Tipos de datos:** `entero`, `texto`, `flotante`, `caracter`, `bool`, `lista`, `mapa`, `concepto`, `u32`, `u64`, `u8`, `byte`, `bytes`, `vec2`, `vec3`, `vec4`, `mat4`, `mat3`, `decimal`, `cualquiera`, `nulo`, `indefinido`, `NeN`

  **Valores booleanos:** `verdadero`, `falso`

  **Operadores lógicos:** `y`, `o`, `no`

  **Comparación:** `mayor`, `menor`, `distinto`, `igual`, `que`, `de`, `a`, `es`, `como`

  **Entrada/Salida:** `imprimir`, `imprimir_sin_salto`, `imprimir_texto`, `imprimir_flotante`, `imprimir_id` `ingresar_texto`, `ingreso_inmediato`, `entrada_flotante`, `limpiar_consola`, `pausa`

  **Memoria Neuronal:** `recordar`, `buscar`, `pensar`, `pensar_respuesta`, `aprender`, `reforzar`, `penalizar`, `olvidar`, `crear_memoria`, `abrir_memoria`, `cerrar_memoria`, `consolidar_memoria`, `recordar`, `buscar_peso`, `asociar`, `asociar_relacion`, `asociar_pesos_conceptos`, `aprender_peso`, `registrar_patron`, `asociar_secuencia`, `corregir_secuencia`, `comparar_patrones`, `asociar_similitud`, `asociar_diferencia`, `buscar_asociados`, `asociados_de`, `buscar_asociados_lista`, `asociados_lista_de`, `decae_conexiones`, `decaer_conexiones`, `ventana_percepcion`, `flujo_temporal`, `percepcion_limpiar`, `percepcion_tamano`, `percepcion_anterior`, `percepcion_recientes`, `percepcion`, `ventana_rastro_activacion`, `rastro_activacion_ventana`, `rastro_activacion_limpiar`, `rastro_activacion_tamano`, `rastro_activacion_obtener`, `rastro_activacion_peso`, `rastro_activacion_lista`, `rastro_activacion_recientes`, `propagar_activacion`, `propagar_activacion_de`, `elegir_por_peso`, `elegir_por_peso_segun`, `elegir_por_peso_id`, `elegir_por_peso_semilla`, `elegir_por_peso_seed`, `resolver_conflictos`, `resolver_conflictos_de`

  **Manejo de texto:** `longitud_texto`, `copiar_texto`, `str_minusculas`, `str_copiar`, `str_a_entero`, `str_a_flotante`, `str_extraer_caracter`, `str_desde_numero`, `segmentar_palabras`, `palabras_de`, `dividir_texto`, `minusculas`, `extraer_subtexto`, `extraer_antes_de`, `extraer_despues_de`, `contiene_texto`, `termina_con`, `ultima_palabra`, `codigo_caracter`, `caracter_a_texto`, `byte_a_caracter`, `caracter_a_byte`

  **Listas y Mapas:** `lista_agregar`, `crear_lista`, `lista_crear`, `lista_limpiar`, `lista_liberar`, `lista_mapear`, `lista_filtrar`, `lista_tamano`, `lista_obtener`, `mapa_crear`, `mapa_poner`, `mapa_obtener`, `mem_lista_crear`, `mem_lista_agregar`, `mem_lista_obtener`, `mem_lista_tamano`, `mem_lista_limpiar`, `mem_lista_liberar`, `mem_lista_mapear`, `mem_lista_filtrar`

  **Archivos:** `abrir_archivo`, `cerrar_archivo`, `escribir_archivo`, `leer_linea_archivo`, `fin_archivo`, `existe_archivo`, `listar_archivos`, `fs_listar`, `fs_abrir`, `fs_cerrar`, `fs_escribir`, `fs_leer_linea`, `fs_leer_byte`, `fs_escribir_byte`, `fs_escribir_byte`

  **Conceptos:** `define_concepto`, `crear_concepto`, `propiedad_concepto`, `fin_concepto`, `obtener_todos_conceptos`, `obtener_relacionados`, `obtener_nombre_concepto`, `tiene_asociacion`, `mem_crear`, `mem_cerrar`, `mem_asociar`, `mem_poner_u32_ind`, `mem_obtener_u32_ind`, `mem_aprender_peso_reg`

  **Sistema:** `sistema_ejecutar`, `sys_argc`, `sys_argv`, `obtener_timestamp`, `obtener_campo`, `es_variable_sistema`, `pausa_milisegundos`, `esperar_milisegundos`, `dormir`, `finalizar`, `imprimir_auditoria`, `imprimir_id`

  **Red:** `socket`, `tls`, `http_solicitud`, `http_respuesta`, `http_servidor`, `tcp_conectar`, `tcp_escuchar`, `tcp_aceptar`, `tcp_enviar`, `tcp_recibir`, `tcp_cerrar`, `tls_cliente`, `tls_servidor`, `tls_enviar`, `tls_recibir`, `tls_cerrar`, `dns_resolver`

  **JSON:** `json`, `objeto`, `json_parse`, `json_stringify`, `json_objeto_obtener`, `json_lista_obtener`, `json_lista_tamano`, `json_a_texto`, `json_a_entero`, `json_a_flotante`, `json_a_bool`, `json_tipo`

  **Bytes:** `bytes_crear`, `bytes_tamano`, `bytes_obtener`, `bytes_poner`, `bytes_anexar`, `bytes_subbytes`, `bytes_desde_texto`, `bytes_a_texto`

  **Manejo de memoria:** `reservar`, `liberar`, `ir_escribir`

  **Control de errores:** `intentar`, `atrapar`, `final`, `fin_intentar`, `lanzar`

  **Asíncrono:** `asincrono`, `esperar`, `tarea`

  **Macros:** `macro`, `llamar`

  **Otros:** `activar_modulo`, `responder`, `con`, `valor`, `peso`, `entrada`, `entonces`, `retorna`, `todo`, `todas`, `bit_shl`, `bit_shr`, `comparar_gt_flt`, `pensar_siguiente`, `pensar_anterior`, `olvidar_debiles`

---

## PROHIBIDO

### **Errores de Sintaxis**

- Palabras en inglés para estructuras de control (`if`, `else`, `for`, `while`)
- Tipado dinámico sin declaración explícita
- Olvidar bloques de cierre (`fin_*`)
- Sintaxis que no exista en el lenguaje

### **Nombres y Variables**

- Usar palabras reservadas como nombres de variables o funciones
- Nombres de variables en inglés (usar español)
- Nombres que no describan su propósito
- Variables sin inicializar antes de usar

### **Estructura y Organización**

- Múltiples funciones en un solo archivo sin modularizar
- Funciones demasiado largas (más de 50 líneas)
- Código sin comentarios donde sea complejo
- Mezclar lógica de negocio con UI o persistencia

### **Memoria Neurional y IA**

- Almacenar datos temporales en memoria neuronal

### **Rendimiento y Calidad**

- Bucles infinitos sin condición de salida clara
- Recursión sin límite de profundidad
- Crear listas/mapas sin liberar memoria
- Operaciones I/O sin manejo de errores

### **Compilación y Ejecución**

- Código que no compila con `jbc`
- Depender de funciones no implementadas
- Usar tipos no soportados por la VM actual
- Asumir que las funciones cognitivas siempre retornan valores

---

## VALIDACIÓN CHECKLIST (ANTES DE ENTREGAR)

### Compilación

- [ ] ¿Compilaría con `jbc` sin errores?
- [ ] ¿Todas las funciones usadas existen?
- [ ] ¿Sintaxis 100% válida?

### Estructura

- [ ] ¿Tiene `principal` y `fin_principal`?
- [ ] ¿Todos los bloques tienen `fin_*`?
- [ ] ¿Módulos importados correctamente?

### Tipado

- [ ] ¿Tipos declarados correctamente?
- [ ] ¿Conversiones explícitas donde se necesita?
- [ ] ¿Sin palabras reservadas como variables?

### Lógica

- [ ] ¿Bucles tienen condición de salida?
- [ ] ¿Manejo de errores en I/O?
- [ ] ¿Memoria liberada donde aplica?

### Jasboot Específico

- [ ] ¿Se consultó `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md`?
- [ ] ¿Usa la sintaxis ACTUALIZADA según la referencia?
- [ ] ¿Usa sintaxis en español según referencia?
- [ ] ¿Clases/herencia sintaxis correcta según referencia?
- [ ] ¿Memoria neuronal usada apropiadamente según referencia?
- [ ] ¿Se usan solo opcodes documentados?
- [ ] ¿Se siguen ejemplos oficiales de la referencia?

### Persistencia y Archivos

- [ ] ¿Se trabajó siempre en el archivo original?
- [ ] ¿Se creó alguna versión simplificada? (DEBE SER NO)
- [ ] ¿Se eliminaron archivos paralelos si existían?
- [ ] ¿El archivo original está completamente funcional?

### Validación de Referencia

- [ ] ¿Se verificó cada construcción en la referencia?
- [ ] ¿Se usó la sintaxis más reciente documentada?
- [ ] ¿Se evitaron versiones obsoletas?
- [ ] ¿Se siguió exactamente la sintaxis oficial?

**Si cualquier casilla está vacía: CORREGIR ANTES DE ENTREGAR.**

---

## Planificación Obligatoria (MODO SENIOR)

Antes de generar cualquier código, el AI DEBE:

1. **Usar SIEMPRE el archivo `.windsurf/workflows/plan/plan.md`** - NO crear nuevas versiones
2. **Actualizar el plan.md existente** con:
   - Análisis del problema
   - Estrategia de implementación
   - Pasos ordenados
   - Posibles riesgos

3. **Hacer un cuestionario al usuario** si hay ambigüedad:
   - Preguntas claras y concretas
   - Enfocadas en elegir la mejor arquitectura o enfoque

4. **NO generar código hasta que:**
   - El plan esté claro
   - Las dudas estén resueltas

**EXCEPCIÓN:**

- Si el usuario pide explícitamente código directo

**IMPORTANTE:**

- **NO crear** plan-v2.md, plan_simple.md, o cualquier otra versión
- **SIEMPRE** usar `.windsurf/workflows/plan/plan.md`
- **ACTUALIZAR** el archivo existente con cada nueva tarea

---

## Gestión de Contexto Dinámico (MODO AGENTE)

Antes de implementar cualquier cambio:

1. **Identificar archivos relevantes** para el problema actual
2. **Analizarlos antes de escribir código** - Entender su estructura y propósito
3. **Actualizar `working-context.md` con:**
   - Lo aprendido de cada archivo
   - Relaciones detectadas entre componentes
   - Problemas encontrados y soluciones

Después de cada cambio:

4. **Registrar en `working-context.md`:**
   - Qué se hizo y por qué
   - Impacto en el sistema completo
   - Nuevas dependencias creadas

5. **Usar siempre `working-context.md` como referencia activa**
   - El AI debe tratar este archivo como su memoria de trabajo
   - Todas las decisiones deben basarse en este contexto

**ACTUALIZACIÓN CONSTANTE:**

- **Después de CADA paso** implementado, actualizar `working-context.md`
- **Después de CADA error** corregido, registrar en `working-context.md`
- **Después de CADA prueba** ejecutada, actualizar resultado en `working-context.md`
- **Después de CADA decisión** importante, registrar justificación en `working-context.md`
- **Al FINALIZAR cada sesión**, actualizar estado actual en `working-context.md`

---

## Identificación Automática de Tareas (MODO CONTINUO)

**Cuando el usuario dice "continúa" o similar:**

### 1. **Leer estado actual**

- Leer `working-context.md` completo
- Identificar sección "Próximo Paso Inmediato"
- Revisar sección "Cambios Recientes"
- Analizar sección "Estado Actual"

### 2. **Identificar tareas pendientes**

- Buscar en `.windsurf/workflows/plan/plan.md` los pasos no completados
- Revisar `working-context.md` para ver qué quedó pendiente
- Identificar archivos que necesitan atención según el contexto
- Detectar errores o problemas no resueltos

### 3. **Determinar siguiente acción**

- **Si hay un paso explícito** en "Próximo Paso Inmediato" → Ejecutarlo
- **Si hay errores pendientes** → Corregirlos primero
- **Si hay archivos rotos** → Repararlos antes de continuar
- **Si el plan tiene pasos sin completar** → Continuar con el siguiente
- **Si no hay nada claro** → Preguntar al usuario

### 4. **Verificar archivos relevantes**

- Identificar archivos mencionados en el contexto
- Leer los archivos que necesitan trabajo
- Verificar estado actual de compilación
- Detectar dependencias entre archivos

### 5. **Ejecutar y actualizar**

- Realizar la siguiente tarea identificada
- Actualizar `working-context.md` con lo realizado
- Marcar progreso en el plan si aplica
- Preparar siguiente paso para futuras continuaciones

**Prioridad de acciones automáticas:**

1. **Errores de compilación** (máxima prioridad)
2. **Pasos explícitos** en working-context.md
3. **Tareas del plan.md** no completadas
4. **Archivos rotos** o con problemas
5. **Mejoras identificadas** en el análisis

**Excepción:** Si el usuario especifica una tarea diferente, priorizar esa sobre las automáticas.

**Prioridad del contexto:**

1. `working-context.md` (memoria activa)
2. `jasboot-context.md` (conocimiento base)
3. `jasboot-rules.md` (reglas fijas)

---

## Gestión de Archivos (MODO EFICIENTE)

### Regla de NO DUPLICACIÓN

**Si un archivo ya existe (ej: jsd.jasb):**

- **NO crear** jsd-simple.jasb o jsd-v2.jasb
- **TRABAJAR sobre el archivo original** jsd.jasb
- **PROBAR y CORREGIR** el archivo existente
- **CREAR archivos NUEVOS solo si:**
  - Es absolutamente necesario
  - El archivo original no puede ser modificado
  - Se necesita una versión completamente diferente

### Flujo de trabajo sobre archivos existentes:

1. **Identificar archivo existente** - Buscar en el proyecto
2. **Analizarlo completamente** - Entender su estructura y propósito
3. **Probarlo** - Compilar y ejecutar para detectar errores
4. **Corregir en el lugar** - Modificar el archivo original
5. **Validar corrección** - Asegurar que compila y funciona
6. **Actualizar working-context.md** - Registrar cambios y estado

### Excepciones permitidas:

- **Archivos temporales** - Solo para pruebas o desarrollo
- **Versiones oficiales** - Con nombre claro (v2, v3, etc.)
- **Refactorización** - Si se reestructura completamente
- **Módulos alternativos** - Si se necesita enfoque diferente

### Prohibido:

- Crear archivos duplicados con nombres similares
- Abandonar archivos originales por errores temporales
- Tener múltiples versiones sin control
- No documentar por qué se creó nuevo archivo

---

## Formato de Respuesta Estructurado

Cuando generes código Jasboot:

1. **Análisis breve** - Explicar la solución técnica
2. **Código completo** - Todo el programa, no fragmentos
3. **Validación incluida** - Demostrar que compila
4. **Ejemplo de uso** - Mostrar cómo ejecutarlo
5. **Errores comunes** - Advertir sobre problemas típicos

**Ejemplo de respuesta:**

```jasb
# Solución: [breve explicación]

principal
    # [código completo y funcional]
fin_principal

# Compilar: jbc programa.jasb -o programa.jbo
# Ejecutar: jasboot-ir-vm.exe programa.jbo
```

---

## Contexto Inteligente (SISTEMA AVANZADO)

### Uso Obligatorio del Sistema de Contexto Inteligente

**El AI DEBE usar `.windsurf/workflows/contexto-inteligente.md` para:**

1. **Estructura de mapa** - No texto completo, sino datos estructurados
2. **Trazabilidad exacta** - Ubicación por función con líneas específicas
3. **Actualización incremental** - Solo lo que cambia, sin duplicación
4. **Debug automático** - Leer archivos involucrados en problemas
5. **Historial organizado** - Por fecha y tarea, no acumulación lineal

### Formato de working-context.md con Contexto Inteligente

```yaml
contexto_principal:
  proyecto_actual: [nombre]
  dominio: [CORE]/[LIB]/[APP]
  estado_general: [descripción]
  
proyectos_activos:
  [proyecto]:
    dominio: [tipo]
    estado: [descripción]
    archivos_trabajando: [lista]
    funciones_en_progreso: [mapa]
    proximos_pasos: [lista]
    ultima_actualizacion: [timestamp]
    
mapa_archivos:
  [ruta]:
    dominio: [tipo]
    funciones_mapeadas:
      [funcion]:
        linea_inicio: [número]
        linea_fin: [número]
        descripcion: [breve]
        dependencias: [lista]
    ultima_modificacion: [timestamp]
    
historial_tareas:
  [YYYY-MM-DD]:
    tarea: [descripción]
    estado: [completada/en_progreso/pausada]
    archivos_modificados: [lista]
    impacto: [descripción]
    problemas_resueltos: [lista]
    
debug_activo:
  problema_actual: [descripción]
  archivos_involucrados: [lista]
  analisis_raiz: [conclusiones]
  soluciones_intentadas: [lista]
```

### Actualización Inteligente

**Al modificar cualquier archivo:**
1. **Consultar mapa_archivos** para ubicación exacta
2. **Actualizar solo función afectada** - No reescribir todo el archivo
3. **Registrar en funciones_mapeadas** - Líneas y descripción
4. **Sincronizar timestamp** - En todas las actualizaciones

**Al detectar problemas:**
1. **Activar debug_activo** - Documentar análisis completo
2. **Leer archivos_involucrados** - Usar mapa para ubicar
3. **Analizar dependencias** - Seguir relaciones automáticamente
4. **Registrar soluciones_intentadas** - Con resultados

**Al completar tareas:**
1. **Mover a historial_tareas** - Con estado final
2. **Limpiar secciones temporales** - debug_activo, etc.
3. **Actualizar mapa_archivos** - Estado final de todos los archivos
4. **Compactar contexto_principal** - Solo información relevante

### Prohibiciones con Contexto Inteligente

- **NO duplicar información** - No repetir estado en múltiples secciones
- **NO crear versiones** - Siempre trabajar sobre archivos existentes
- **NO asumir ubicaciones** - Usar mapa para verificar
- **NO actualizar linealmente** - Solo cambios relevantes

---

## PRINCIPIOS FUNDAMENTALES DE TRABAJO

### 1. Validación Real > Suposición
- **NUNCA** asumir que algo funciona
- **SIEMPRE** compilar y ejecutar para confirmar
- **DOCUMENTAR** resultados reales, no imaginados
- **ESPERAR** salida real del compilador y VM
- **CONSULTAR SIEMPRE** la referencia de sintaxis actualizada

### 2. Persistencia > Alternativas
- **SIEMPRE** corregir el archivo existente
- **NUNCA** crear archivos paralelos o versiones simplificadas
- **TRABAJAR** hasta que el original funcione completamente
- **ELIMINAR** inmediatamente cualquier alternativa creada
- **ABANDONAR** la tentación de empezar de cero

### 3. Precisión > Rapidez
- **TOMAR** el tiempo necesario para validar
- **NO** entregar código sin confirmación real
- **SER** persistente hasta lograr funcionamiento completo
- **CORREGIR** iterativamente hasta éxito

### 4. Sintaxis Real > Inventada
- **LEER SIEMPRE** la referencia oficial antes de escribir
- **USAR EXCLUSIVAMENTE** sintaxis documentada
- **NUNCA** inventar construcciones del lenguaje
- **VERIFICAR** cada palabra clave en la referencia
- **ACTUALIZAR** conocimiento con la versión más reciente

### 5. Transparencia > Opacidad
- **DOCUMENTAR** errores reales encontrados
- **REPORTAR** estado real del proyecto
- **NO OCULTAR** problemas o limitaciones
- **SER** honesto sobre lo que funciona y lo que no

---

## 🔄 Contexto Continuo en Conversaciones (REGLA MÁXIMA)

### Prioridad Absoluta
El contexto continuo es **REGLA MÁXIMA** junto con FASE 0. Sin contexto continuo, el AI opera sin memoria del trabajo anterior.

### OBLIGATORIO ANTES DE CUALQUIER RESPUESTA

1. **LEER SIEMPRE** `.windsurf/chats/Conversacion-actual.md`
   - Analizar última respuesta del IDE
   - Identificar decisiones tomadas
   - Determinar estado actual del proyecto
   - Entender próximos pasos pendientes

2. **CONSTRUIR SOBRE CONTEXTO EXISTENTE**
   - Nunca empezar de cero si hay contexto disponible
   - Mantener coherencia con soluciones previas
   - Referenciar trabajo anterior explícitamente
   - Continuar desde donde se quedó la última vez

3. **SINCRONIZAR CON WORKING-CONTEXT**
   - Mantener coherencia entre ambos archivos
   - Actualizar working-context.md si el proyecto cambió
   - Evitar contradicciones entre contextos

### OBLIGATORIO DESPUÉS DE CUALQUIER RESPUESTA

1. **ACTUALIZAR SIEMPRE** `.windsurf/chats/Conversacion-actual.md`
   - Agregar respuesta actual con timestamp
   - Documentar decisiones tomadas
   - Registrar próximos pasos identificados
   - Incluir estado técnico relevante

2. **MANTENER ESTRUCTURA ESTÁNDAR**
   ```markdown
   # CONVERSACIÓN ACTUAL - Contexto Continuo
   
   ## Última Sesión: [YYYY-MM-DD HH:MM:SS]
   
   ### Respuesta del IDE
   [Contenido completo]
   
   ### Decisiones Tomadas
   - [Lista de decisiones]
   
   ### Próximos Pasos Identificados
   1. [Paso 1]
   2. [Paso 2]
   ```

### PROHIBICIONES ABSOLUTAS

- **PROHIBIDO** Ignorar contexto de sesiones anteriores
- **PROHIBIDO** Repetir investigación ya realizada
- **PROHIBIDO** Contradecir decisiones previas sin justificación
- **PROHIBIDO** Empezar de cero cuando hay contexto disponible
- **PROHIBIDO** Responder sin leer `Conversacion-actual.md`
- **PROHIBIDO** Terminar sin actualizar `Conversacion-actual.md`

### MANEJO DE CONFLICTOS DE CONTEXTO

#### Si el contexto anterior es incorrecto:
1. **Identificar el error** específico en el contexto previo
2. **Explicar por qué** se necesita cambiar de enfoque
3. **Documentar la corrección** en `Conversacion-actual.md`
4. **Justificar el cambio** con evidencia técnica sólida

#### Si hay múltiples enfoques previos:
1. **Analizar todos los enfoques** documentados
2. **Elegir el mejor** basado en evidencia actual
3. **Explicar la decisión** y por qué es superior
4. **Integrar lo útil** de enfoques anteriores

### BUENAS PRÁCTICAS DE CONTEXTO

- **Referenciar explícitamente** trabajo anterior
- **Explicar cambios** de enfoque si son necesarios
- **Mantener continuidad** en soluciones y patrones
- **Documentar evolución** del pensamiento y decisiones
- **Ser transparente** sobre incertidumbres o cambios de dirección

### INTEGRACIÓN CON FLUJO DE TRABAJO

#### Antes de FASE 0:
1. Leer `Conversacion-actual.md`
2. Identificar si es continuación de trabajo anterior
3. Determinar punto de retomada específico

#### Durante FASE 0:
- Considerar contexto anterior al analizar problemas
- No repetir investigación ya realizada
- Construir sobre conocimiento previo

#### Durante FASE 1:
- Continuar desde donde se quedó según contexto
- Mantener coherencia con soluciones previas
- Referenciar decisiones anteriores

#### Al Finalizar:
1. Actualizar `Conversacion-actual.md` completamente
2. Documentar estado final del trabajo
3. Preparar próximos pasos para próxima sesión
4. Sincronizar con `working-context.md`

---

**ESTAS REGLAS SON OBLIGATORIAS, INNEGOCIABLES Y FUNDAMENTALES PARA EL TRABAJO EFECTIVO.**

**REGLA DE ORO: FASE 0 > FASE 1 - Investigación profunda antes de cualquier ejecución.**
**REGLA DE PLATA: CONTEXTO CONTINUO > RESPUESTA AISLADA - Siempre construir sobre contexto existente.**
