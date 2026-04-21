# ERROR PATTERNS - Jasboot

## Propósito

Base de conocimiento de errores comunes y sus soluciones. Permite al AI reconocer patrones instantáneamente y aplicar soluciones probadas en lugar de diagnosticar problemas ya resueltos.

## Formato de Entrada

```
### [DOMINIO] Nombre del Error
**Síntoma:** [Mensaje de error exacto]
**Causa:** [Explicación técnica del problema]
**Solución:** [Pasos específicos para resolver]
**Ejemplo:** [Antes/Después del código]
**Archivos afectados:** [Lista de archivos típicos]
**Última actualización:** [Fecha de última verificación]
```

---

## [INVESTIGACIÓN] Errores de Proceso y Suposiciones

### Error: Ejecutar código sin investigación previa
**Síntoma:** El agente comienza a escribir código sin entender completamente el contexto
**Causa:** Omisión de FASE 0 de investigación profunda
**Solución:** Detener inmediatamente y completar investigación completa antes de ejecutar
**Ejemplo:**
```bash
# ANTES (error)
Usuario: "arregla esta función"
Agente: [Escribe código inmediatamente sin leer contexto]

# DESPUÉS (correcto)
Usuario: "arregla esta función"
Agente: [PAUSA] Leyendo working-context.md completo...
Agente: Analizando dependencias y estado actual...
Agente: Identificando causa raíz del problema...
Agente: Presentando hallazgos al usuario y esperando confirmación...
```
**Archivos afectados:** Cualquier tarea de código
**Última actualización:** 2026-04-17

### Error: Suposiciones no validadas del usuario
**Síntoma:** El agente asume que el usuario entiende conceptos técnicos o tiene cierto contexto
**Causa:** No validar explícitamente las suposiciones del usuario
**Solución:** Preguntar explícitamente y validar cada suposición
**Ejemplo:**
```bash
# ANTES (error)
Agente: "Voy a refactorizar la clase usando herencia múltiple"
[El usuario no sabe qué es herencia múltiple]

# DESPUÉS (correcto)
Agente: "Antes de refactorizar, ¿estás familiarizado con el concepto de herencia múltiple en Jasboot?"
Agente: "¿Prefieres que mantenga la estructura actual o que explique los cambios que haré?"
```
**Archivos afectados:** Cualquier interacción con el usuario
**Última actualización:** 2026-04-17

### Error: Confianza en documentación desactualizada
**Síntoma:** El agente usa sintaxis o funciones que ya no existen en la versión actual
**Causa:** Confianza en memoria o documentación antigua sin verificar
**Solución:** Siempre verificar la referencia actualizada y buscar en internet si hay dudas
**Ejemplo:**
```jasb
# ANTES (error)
# Basado en memoria de versión antigua
funcion mi_funcion(parametro1, parametro2)  # Sintaxis obsoleta

# DESPUÉS (correcto)
# Verificando docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md
# Y buscando online si hay dudas sobre sintaxis actual
funcion mi_funcion(texto parametro1, texto parametro2) retorna texto  # Sintaxis actual
```
**Archivos afectados:** Cualquier archivo de código
**Última actualización:** 2026-04-17

### Error: Ignorar el estado real del proyecto
**Síntoma:** El agente propone soluciones que no consideran el estado actual del proyecto
**Causa:** No leer working-context.md o ignorar información crítica
**Solución:** Leer completamente el estado actual antes de proponer soluciones
**Ejemplo:**
```bash
# ANTES (error)
Usuario: "Añade logging a la aplicación"
Agente: [Propone logger complejo sin saber que ya existe uno]

# DESPUÉS (correcto)
Agente: Leyendo working-context.md...
Agente: "Veo que ya tienes logger.jasb implementado. ¿Quieres que lo mejore o crees uno nuevo?"
```
**Archivos afectados:** Cualquier tarea de modificación
**Última actualización:** 2026-04-17

### Error: No preparar estrategias de fallback
**Síntoma:** El agente tiene solo un plan y falla cuando no funciona
**Causa:** No preparar múltiples estrategias antes de ejecutar
**Solución:** Siempre tener Plan A, B, C, D para cada problema
**Ejemplo:**
```bash
# ANTES (error)
Agente: "Voy a usar herencia múltiple para resolver esto"
[Si falla, no tiene alternativa]

# DESPUÉS (correcto)
Agente: "Plan A: Herencia múltiple. Si falla por bugs del compilador:"
Agente: "Plan B: Composición manual. Si eso falla:"
Agente: "Plan C: Estructura plana. Como último recurso:"
Agente: "Plan D: Dividir en módulos separados"
```
**Archivos afectados:** Cualquier tarea compleja
**Última actualización:** 2026-04-17

### Error: No buscar en internet cuando es necesario
**Síntoma:** El agente limita su investigación a información local obsoleta o insuficiente
**Causa:** No utilizar búsqueda online cuando la información local no es suficiente
**Solución:** Buscar en internet siempre que la información local sea insuficiente o desactualizada
**Ejemplo:**
```bash
# ANTES (error)
Agente: "La documentación local dice que esto funciona así"
[La información está desactualizada y hay mejores prácticas online]

# DESPUÉS (correcto)
Agente: "La documentación local indica X, pero voy a buscar online para verificar"
Agente: [Busca en internet información actualizada]
Agente: "He encontrado que la práctica actual recomendada es Y, voy a usar eso"
```
**Archivos afectados:** Cualquier tarea que requiera información actualizada
**Última actualización:** 2026-04-17

---

## [CORE] Compilador jbc.exe

### Error: Variables locales tratadas como campos de clase
**Síntoma:** `error de seguridad: el campo 'X' debe accederse con 'este.X' dentro de la clase 'Y'`
**Causa:** El compilador confunde variables locales declaradas dentro de funciones con campos de la clase
**Solución:** Renombrar variables locales con sufijos desambiguadores (`_actual`, `_temp`, `_local`, `_valor`)
**Ejemplo:**
```jasb
# ANTES (error)
funcion formatear_mensaje() retorna texto
    texto timestamp = obtener_timestamp()  # Error: 'timestamp' tratado como campo
    retornar "[" + timestamp + "]"
fin_funcion

# DESPUÉS (correcto)
funcion formatear_mensaje() retorna texto
    texto timestamp_actual = obtener_timestamp()  # OK: nombre único
    retornar "[" + timestamp_actual + "]"
fin_funcion
```
**Archivos afectados:** logger.jasb, class_test.jasb, cualquier archivo con clases
**Última actualización:** 2026-04-16

### Error: Funciones anidadas no permitidas
**Síntoma:** `error de sintaxis: función anidada no permitida`
**Causa:** Jasboot no permite declarar funciones dentro de otras funciones
**Solución:** Aplanar todas las funciones al nivel superior de la clase o módulo
**Ejemplo:**
```jasb
# ANTES (error)
funcion procesar_texto()
    funcion aprender_patrones()  # Error: función anidada
        # código aquí
    fin_funcion
fin_funcion

# DESPUÉS (correcto)
funcion procesar_texto()
    # código aquí
fin_funcion

funcion aprender_patrones()  # OK: función a nivel superior
    # código aquí
fin_funcion
```
**Archivos afectados:** generador.jasb, cualquier archivo con funciones complejas
**Última actualización:** 2026-04-16

### Error: Uso incorrecto de recordar() con múltiples parámetros
**Síntoma:** `error de sintaxis: recordar() acepta máximo 2 parámetros`
**Causa:** La función `recordar()` en Jasboot solo acepta clave y valor, no múltiples parámetros
**Solución:** Concatenar valores en un solo string o usar múltiples llamadas
**Ejemplo:**
```jasb
# ANTES (error)
recordar("patron", "tipo", "valor", "contexto")  # Error: demasiados parámetros

# DESPUÉS (correcto)
recordar("patron_tipo_valor_contexto", "tipo|valor|contexto")  # OK: concatenado
# o
recordar("patron_tipo", "tipo")
recordar("patron_valor", "valor")
recordar("patron_contexto", "contexto")
```
**Archivos afectados:** generador.jasb, generador_simple.jasb, cualquier archivo con memoria neuronal
**Última actualización:** 2026-04-16

### Error: Variables no declaradas en bloques atrapar
**Síntoma:** `error: variable 'e' no declarada`
**Causa:** Las variables en bloques `atrapar` deben declararse explícitamente
**Solución:** Declarar variables con tipo antes de usarlas en el bloque
**Ejemplo:**
```jasb
# ANTES (error)
intentar
    # código que puede fallar
atrapar e  # Error: 'e' no declarada
    imprimir("Error: " + e)
fin_intentar

# DESPUÉS (correcto)
intentar
    # código que puede fallar
atrapar error_var  # OK: variable declarada
    imprimir("Error detectado")
fin_intentar
```
**Archivos afectados:** generador.jasb, cualquier archivo con manejo de errores
**Última actualización:** 2026-04-16

### Error: jbc.exe genera archivos .jbo vacíos sin reportar errores
**Síntoma:** Compilación termina sin errores pero el archivo .jbo está vacío o tiene 0 bytes
**Causa:** Backend semántico del compilador tiene problemas con clases o herencia compleja
**Solución:** Simplificar estructura de clases, usar structs temporales, o dividir en módulos más simples
**Ejemplo:**
```jasb
# ANTES (problemático)
clase Logger extends BaseLogger
    # herencia compleja que causa problemas
fin_clase

# DESPUÉS (alternativa)
clase Logger
    # implementación directa sin herencia
fin_clase
# o usar struct mientras se corrige el compilador
```
**Archivos afectados:** logger.jasb, class_test.jasb, cualquier archivo con herencia
**Última actualización:** 2026-04-16

---

## [LIB] Memoria Neuronal (JMN)

### Error: pensar_respuesta() retorna "indefinido"
**Síntoma:** La función cognitiva siempre retorna "indefinido" en lugar de respuestas generadas
**Causa:** Memoria neuronal JMN no inicializada correctamente o vacía, sin datos base para procesamiento
**Solución:** Implementar sistema de fallbacks robustos y diagnóstico de memoria
**Ejemplo:**
```jasb
# ANTES (problemático)
texto respuesta = pensar_respuesta(entrada)  # Retorna "indefinido"

# DESPUÉS (con fallback)
texto respuesta = pensar_respuesta(entrada)
si respuesta == "indefinido" o respuesta == "" entonces
    respuesta = generar_respuesta_fallback(entrada)  # OK: respaldo
fin_si
```
**Archivos afectados:** generador.jasb, generador_simple.jasb, cualquier archivo con funciones cognitivas
**Última actualización:** 2026-04-16

### Error: buscar() retorna nulo o vacío
**Síntoma:** `buscar(clave)` retorna `nulo` o string vacío cuando debería existir
**Causa:** La clave no existe en memoria neuronal o el archivo JMN está corrupto
**Solución:** Verificar inicialización de memoria y usar valores por defecto
**Ejemplo:**
```jasb
# ANTES (problemático)
texto valor = buscar("clave_existente")  # Retorna nulo

# DESPUÉS (seguro)
texto valor = buscar("clave_existente")
si valor == nulo o valor == "" entonces
    valor = "valor_por_defecto"  # OK: fallback
fin_si
```
**Archivos afectados:** Cualquier archivo que use memoria neuronal
**Última actualización:** 2026-04-16

### Error: asociar() con sintaxis incorrecta
**Síntoma:** `error de sintaxis en asociar()`
**Causa:** La función `asociar()` tiene sintaxis específica que varía según la versión
**Solución:** Usar la sintaxis documentada o alternativa `asociar_relacion()`
**Ejemplo:**
```jasb
# ANTES (error)
asociar("concepto1", "concepto2")  # Sintaxis incorrecta

# DESPUÉS (correcto)
asociar "concepto1" con "concepto2"  # OK: sintaxis correcta
# o
asociar_relacion("concepto1", "concepto2")  # OK: alternativa
```
**Archivos afectados:** logger.jasb, cualquier archivo con asociaciones
**Última actualización:** 2026-04-16

---

## [APP] Clases y Herencia

### Error: Constructores de clase no funcionan
**Síntoma:** Las clases no se inicializan correctamente, los campos quedan vacíos
**Causa:** Jasboot no tiene constructores automáticos, debe usarse patrón de inicialización manual
**Solución:** Implementar función `init()` y llamarla explícitamente
**Ejemplo:**
```jasb
# ANTES (problemático)
clase TestClase
    texto campo
    # sin constructor explícito
fin_clase

TestClase objeto = TestClase()  # campo queda vacío

# DESPUÉS (correcto)
clase TestClase
    texto campo
    
    funcion init(texto valor)
        este.campo = valor
    fin_funcion
fin_clase

TestClase objeto = TestClase()
objeto.init("valor")  # OK: inicialización explícita
```
**Archivos afectados:** class_test.jasb, logger.jasb, cualquier archivo con clases
**Última actualización:** 2026-04-16

### Error: Métodos privados no accesibles
**Síntoma:** `error: método privado no accesible desde fuera`
**Causa:** Métodos marcados como `privado` solo pueden ser llamados desde dentro de la clase
**Solución:** Hacer métodos públicos o crear métodos públicos que llamen a los privados
**Ejemplo:**
```jasb
# ANTES (error)
clase Logger
    privado funcion metodo_privado()
        # código
    fin_funcion
fin_clase

Logger logger = Logger()
logger.metodo_privado()  # Error: no accesible

# DESPUÉS (correcto)
clase Logger
    privado funcion metodo_privado()
        # código
    fin_funcion
    
    funcion metodo_publico()  # OK: método público
        retornar este.metodo_privado()
    fin_funcion
fin_clase
```
**Archivos afectados:** logger.jasb, cualquier archivo con métodos privados
**Última actualización:** 2026-04-16

---

## [SINTAXIS] Errores Comunes

### Error: Olvidar bloques fin_*
**Síntoma:** `error: bloque sin cerrar` o `error: fin_* esperado`
**Causa:** Olvidar cerrar bloques con `fin_funcion`, `fin_si`, `fin_mientras`, etc.
**Solución:** Verificar que cada bloque de apertura tenga su correspondiente cierre
**Ejemplo:**
```jasb
# ANTES (error)
si condicion entonces
    imprimir("hola")
# falta fin_si

# DESPUÉS (correcto)
si condicion entonces
    imprimir("hola")
fin_si  # OK: bloque cerrado
```
**Archivos afectados:** Cualquier archivo Jasboot
**Última actualización:** 2026-04-16

### Error: Usar palabras reservadas como nombres
**Síntoma:** `error: palabra reservada usada como identificador`
**Causa:** Usar palabras clave del lenguaje como nombres de variables o funciones
**Solución:** Elegir nombres que no sean palabras reservadas
**Ejemplo:**
```jasb
# ANTES (error)
funcion si()  # Error: 'si' es palabra reservada
    entero mientras = 5  # Error: 'mientras' es palabra reservada
fin_funcion

# DESPUÉS (correcto)
funcion verificar_condicion()  # OK: nombre no reservado
    entero contador = 5  # OK: nombre no reservado
fin_funcion
```
**Archivos afectados:** Cualquier archivo Jasboot
**Última actualización:** 2026-04-16

### Error: Tipado dinámico sin declaración
**Síntoma:** `error: tipo no especificado` o `error: conversión implícita no permitida`
**Causa:** No declarar el tipo de variables o parámetros
**Solución:** Declarar siempre tipos explícitamente
**Ejemplo:**
```jasb
# ANTES (error)
variable = "hola"  # Error: tipo no especificado
funcion procesar(valor)  # Error: parámetro sin tipo

# DESPUÉS (correcto)
texto variable = "hola"  # OK: tipo explícito
funcion procesar(texto valor) retorna texto  # OK: tipos explícitos
```
**Archivos afectados:** Cualquier archivo Jasboot
**Última actualización:** 2026-04-16

---

## [RENDIMIENTO] Problemas de Rendimiento

### Error: Bucles infinitos sin condición de salida
**Síntoma:** Programa se queda ejecutando indefinidamente
**Causa:** Bucles `mientras` o `para_cada` sin condición de salida válida
**Solución:** Asegurar que toda condición de bucle eventualmente sea falsa
**Ejemplo:**
```jasb
# ANTES (error)
entero i = 0
mientras i < 10 hacer
    # código que no modifica i
    # bucle infinito
fin_mientras

# DESPUÉS (correcto)
entero i = 0
mientras i < 10 hacer
    # código aquí
    i = i + 1  # OK: condición de salida
fin_mientras
```
**Archivos afectados:** Cualquier archivo con bucles
**Última actualización:** 2026-04-16

### Error: Fugas de memoria en listas/mapas
**Síntoma:** Consumo excesivo de memoria, programa se ralentiza
**Causa:** Crear listas/mapas sin liberar memoria cuando ya no se necesitan
**Solución:** Llamar a funciones de liberación explícitas
**Ejemplo:**
```jasb
# ANTES (problemático)
lista datos = crear_lista()
# usar datos...
# nunca se libera

# DESPUÉS (correcto)
lista datos = crear_lista()
# usar datos...
lista_liberar(datos)  # OK: memoria liberada
```
**Archivos afectados:** Cualquier archivo con estructuras de datos dinámicas
**Última actualización:** 2026-04-16

---

## [MODULOS] Errores de Importación/Exportación

### Error: Función no encontrada al importar
**Síntoma:** `error: función 'X' no encontrada en módulo`
**Causa:** La función no está exportada correctamente o el nombre no coincide
**Solución:** Verificar que la función esté declarada como `enviar` en el módulo origen
**Ejemplo:**
```jasb
# En módulo origen
funcion mi_funcion()  # Sin exportar
fin_funcion

# En archivo que importa
usar {mi_funcion} de "modulo.jasb"  # Error: no exportada

# SOLUCIÓN
# En módulo origen
enviar funcion mi_funcion()  # OK: exportada
fin_funcion
```
**Archivos afectados:** Cualquier archivo con importaciones
**Última actualización:** 2026-04-16

### Error: Importación circular
**Síntoma:** `error: importación circular detectada`
**Causa:** Dos o más módulos se importan mutuamente
**Solución:** Reestructurar para evitar dependencias circulares
**Ejemplo:**
```jasb
# modulo_a.jasb
usar {func_b} de "modulo_b.jasb"  # Importa B

# modulo_b.jasb  
usar {func_a} de "modulo_a.jasb"  # Importa A (circular)

# SOLUCIÓN: Crear modulo_c.jasb con funciones compartidas
```
**Archivos afectados:** Múltiples archivos con importaciones
**Última actualización:** 2026-04-16

---

## Mecanismo de Actualización

### Cuando se resuelva un nuevo error:
1. **Identificar el dominio** ([CORE], [LIB], [APP], [SINTAXIS], [RENDIMIENTO], [MODULOS])
2. **Documentar con formato estándar**
3. **Incluir ejemplo claro de antes/después**
4. **Actualizar fecha de última verificación**
5. **Referenciar en working-context.md**

### Cuando se modifique el compilador:
1. **Verificar si los patrones siguen siendo válidos**
2. **Actualizar soluciones si cambió la sintaxis**
3. **Marcar patrones obsoletos pero mantenerlos para referencia**
4. **Agregar nuevos patrones según aparezcan**

---

## Estadísticas de Errores

| Dominio | Errores Documentados | Última Actualización |
|---------|-------------------|---------------------|
| [INVESTIGACIÓN] | 6           | 2026-04-17          |
| [CORE]  | 5                 | 2026-04-16          |
| [LIB]   | 3                 | 2026-04-16          |
| [APP]   | 2                 | 2026-04-16          |
| [SINTAXIS] | 3              | 2026-04-16          |
| [RENDIMIENTO] | 2           | 2026-04-16          |
| [MODULOS] | 2               | 2026-04-16          |
| **Total** | **23**          | **2026-04-17**      |

---

## Índice Rápido

### Errores de Proceso (Prioridad Máxima)
- **Investigación previa**: Ver [INVESTIGACIÓN] Ejecutar código sin investigación previa
- **Suposiciones**: Ver [INVESTIGACIÓN] Suposiciones no validadas del usuario
- **Documentación**: Ver [INVESTIGACIÓN] Confianza en documentación desactualizada
- **Búsqueda online**: Ver [INVESTIGACIÓN] No buscar en internet cuando la información local es insuficiente
- **Estado del proyecto**: Ver [INVESTIGACIÓN] Ignorar el estado real del proyecto
- **Estrategias**: Ver [INVESTIGACIÓN] No preparar estrategias de fallback

### Errores Técnicos
- **Variables en clases**: Ver [CORE] Variables locales tratadas como campos
- **Funciones anidadas**: Ver [CORE] Funciones anidadas no permitidas  
- **Memoria neuronal**: Ver [LIB] pensar_respuesta() retorna "indefinido"
- **Constructores**: Ver [APP] Constructores de clase no funcionan
- **Importación**: Ver [MODULOS] Función no encontrada al importar

---

*Este archivo debe actualizarse constantemente. Cada error resuelto es conocimiento adquirido para el sistema.*

**NOTA IMPORTANTE:** Los errores de la categoría [INVESTIGACIÓN] tienen máxima prioridad. Si se detecta alguno de estos patrones, se debe detener inmediatamente cualquier ejecución y volver a FASE 0 de investigación.
