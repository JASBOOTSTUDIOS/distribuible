# Sistema Interactivo de Búsqueda Cognitiva

## Descripción

Este sistema interactivo permite probar todas las funcionalidades del Cerebro JMN con una base de conocimientos extensa. Puedes realizar búsquedas profundas, análisis semánticos y aprendizaje interactivo.

## Archivos

### 1. `base_conocimientos_extensa.jasb`
Base de datos con **100+ conceptos** detallados organizados en categorías:

- **Ciencias y Tecnología** (20 conceptos)
  - Inteligencia artificial, aprendizaje automático, redes neuronales
  - Blockchain, IoT, computación en la nube, ciberseguridad

- **Lenguajes de Programación** (8 conceptos)
  - Python, JavaScript, Java, C++, Rust, Go, Swift, Kotlin

- **Desarrollo Web** (10 conceptos)
  - HTML, CSS, React, Angular, Vue, Node.js, Express, MongoDB, PostgreSQL

- **Ciencias Naturales** (6 conceptos)
  - Física, química, biología, genética, evolución, ecología

- **Matemáticas** (4 conceptos)
  - Álgebra, cálculo, estadística, geometría

- **Historia y Cultura** (4 conceptos)
  - Filosofía, historia, arte, música, literatura

- **Economía y Negocios** (4 conceptos)
  - Economía, marketing, finanzas, emprendimiento

- **Psicología y Sociología** (3 conceptos)
  - Psicología, sociología, antropología

- **Tecnologías Emergentes** (8 conceptos)
  - Realidad virtual/aumentada, impresión 3D, robótica, biotecnología, nanotecnología

- **Energía y Medio Ambiente** (4 conceptos)
  - Energías renovables, cambio climático, sostenibilidad, reciclaje

- **Salud y Medicina** (5 conceptos)
  - Medicina, vacunas, genómica, telemedicina

- **Educación** (3 conceptos)
  - Educación, aprendizaje, pedagogía

- **Transporte** (3 conceptos)
  - Automóvil, aviación, ferrocarril

- **Agricultura y Alimentos** (2 conceptos)
  - Agricultura, alimentación

- **Arte y Diseño** (2 conceptos)
  - Arquitectura, diseño

- **Deportes** (2 conceptos)
  - Deporte, fútbol

- **Medios y Comunicación** (2 conceptos)
  - Periodismo, redes sociales

### 2. `buscador_interactivo.jasb`
Programa principal con menú interactivo que ofrece:

#### **Opciones del Menú:**

1. **Búsqueda Profunda** - Busca términos en todos los conceptos
2. **Análisis Semántico** - Analiza consultas y encuentra relaciones
3. **Búsqueda por Palabras Clave** - Extrae palabras y busca conceptos
4. **Procesamiento Inteligente** - Usa múltiples estrategias cognitivas
5. **Aprendizaje** - Enseña nuevos conceptos al sistema
6. **Búsqueda de Aprendidos** - Busca en conceptos enseñados
7. **Diagnóstico** - Reporte completo del sistema
8. **Pruebas Automáticas** - Suite de pruebas predefinidas
9. **Estadísticas** - Información detallada de uso
10. **Salir** - Cierra el sistema

## Cómo Usar

### **Ejecución:**
```bash
node 'c:\src\jasboot\.vscode\run-jasb.cjs' 'c:\src\jasboot\examples\ai_asistente\tests\buscador_interactivo.jasb'
```

### **Ejemplos de Búsqueda:**

#### **Búsqueda Profunda:**
```
> 1
> Ingrese término a buscar: python
Resultado: He encontrado 'python' en mi concepto 'python': Python es un lenguaje de programación...
```

#### **Análisis Semántico:**
```
> 2
> Ingrese consulta a analizar: qué es la inteligencia artificial
Resultado: He analizado tu consulta y encontré 3 conceptos relacionados: 'inteligencia artificial', 'aprendizaje automático', 'red neuronal'
```

#### **Búsqueda por Palabras:**
```
> 3
> Ingrese texto con palabras clave: python javascript java
Resultado: He encontrado varias palabras relacionadas: 'python', 'javascript', 'java'. ¿Con cuál te refieres?
```

#### **Aprendizaje:**
```
> 5
> Ingrese nueva asociación: rust es lenguaje de programación seguro y rápido
Resultado: Concepto 'rust' aprendido exitosamente.
Definición: lenguaje de programación seguro y rápido
```

## Características Especiales

### **Búsqueda Dentro de Definiciones:**
El sistema puede encontrar términos que están DENTRO de las definiciones, no solo los conceptos principales:

```
Buscar: "seguridad"
Encontrado en: 'ciberseguridad' - "...salvaguardar la confidencialidad, integridad y disponibilidad de la información..."
Encontrado en: 'rust' - "...ofrece garantías de seguridad de memoria sin necesidad de recolector de basura..."
```

### **Análisis Multinivel:**
El procesamiento inteligente aplica múltiples estrategias:
1. Búsqueda directa
2. Análisis semántico
3. Búsqueda por palabras clave
4. Búsqueda profunda
5. Respuesta de aprendizaje

### **Aprendizaje Continuo:**
Cuando enseñas nuevos conceptos, el sistema los integra inmediatamente y los puede buscar posteriormente.

## Pruebas Sugeridas

### **Prueba 1: Búsqueda de Tecnologías**
```
1. Buscar: "blockchain"
2. Buscar: "iot"
3. Buscar: "energía renovable"
```

### **Prueba 2: Análisis Semántico**
```
1. Analizar: "lenguajes de programación modernos"
2. Analizar: "ciencias de la computación"
3. Analizar: "tecnologías emergentes"
```

### **Prueba 3: Aprendizaje y Verificación**
```
1. Aprender: "quantum computing es computación basada en mecánica cuántica"
2. Buscar: "quantum"
3. Verificar que aparece en resultados
```

### **Prueba 4: Búsqueda por Contexto**
```
1. Buscar: "aprendizaje" (debe encontrar en múltiples conceptos)
2. Buscar: "red" (debe encontrar en redes neuronales, blockchain, IoT)
3. Buscar: "sostenible" (debe encontrar en energía, agricultura, etc.)
```

## Estadísticas y Diagnóstico

El sistema proporciona información detallada sobre:
- Número de conceptos en caché
- Estado del sistema
- Memoria activa
- Tasa de éxito en búsquedas

## Arquitectura

- **Frontend**: Menú interactivo con validación de entrada
- **Procesamiento**: Múltiples estrategias cognitivas
- **Memoria**: JMN (Jasboot Memory Network)
- **Caché**: Conceptos base optimizados
- **Errores**: Manejo robusto con intentar/atrapar

## Extensiones Posibles

1. **Exportación de resultados** a archivos
2. **Búsqueda por categorías** específicas
3. **Comparación entre conceptos**
4. **Visualización de relaciones**
5. **Historial de búsquedas**
6. **Modo batch** para múltiples consultas

## Troubleshooting

### **Si no encuentra conceptos:**
- Verifica que el término esté escrito correctamente
- Intenta con sinónimos o términos relacionados
- Usa la opción 8 para ejecutar pruebas automáticas

### **Si el aprendizaje no funciona:**
- Usa el formato exacto: "concepto es definición"
- Asegúrate que neither concepto ni definición estén vacíos
- Verifica con la opción 6 que el concepto fue aprendido

### **Si el sistema responde lento:**
- Usa la opción 7 para diagnóstico
- Los conceptos están cacheados para optimizar rendimiento
- Las búsquedas complejas pueden tomar más tiempo

Este sistema interactivo demuestra completamente las capacidades del Cerebro JMN con una base de conocimientos realista y extensa.
