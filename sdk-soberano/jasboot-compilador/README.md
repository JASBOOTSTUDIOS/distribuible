# Compilador Jasboot en Jasboot

Un compilador completo para el lenguaje Jasboot, escrito enteramente en Jasboot. Este compilador demuestra que Jasboot tiene la capacidad de compilarse a sí mismo mediante la generación de código C intermedio.

## 🎯 Objetivo

Demostrar que **Jasboot puede compilar Jasboot**, un hito fundamental para cualquier lenguaje de programación. El compilador:

1. **Lee código fuente Jasboot** (.jasb)
2. **Realiza análisis léxico** (tokenización)
3. **Construye AST** (árbol sintáctico abstracto)
4. **Genera código C** intermedio
5. **Usa el toolchain existente** para compilar a bytecode .jbo

## 📁 Estructura del Proyecto

```
jasboot-compilador/
├── lexer.jasb          # Analizador léxico - convierte texto a tokens
├── parser.jasb         # Analizador sintáctico - construye AST
├── codegen.jasb        # Generador de código - AST a C
├── diagnosticos.jasb    # Sistema de errores y advertencias
├── compilador.jasb     # Orquestador principal del compilador
├── README.md           # Este archivo
└── ejemplos/          # Ejemplos de código para probar
    ├── hola_mundo.jasb
    ├── variables.jasb
    ├── funciones.jasb
    └── complejo.jasb
```

## 🚀 Uso

### Compilación Básica

```bash
# Compilar programa Jasboot
jasboot-ir-vm.exe compilador.jasb programa.jasb

# Con opciones
jasboot-ir-vm.exe compilador.jasb -v -d programa.jasb
```

### Opciones de Línea de Comandos

- `-v, --verbose`    Modo detallado (muestra proceso completo)
- `-d, --debug`      Modo debug (muestra AST y código intermedio)
- `-a, --analyze`    Solo analizar, no generar código
- `-r, --report`      Generar reporte de diagnósticos
- `-h, --help`       Muestra ayuda completa

### Flujo de Compilación

1. **Entrada**: `programa.jasb` (código fuente Jasboot)
2. **Lexer**: Tokeniza el código fuente
3. **Parser**: Construye AST desde tokens
4. **CodeGen**: Genera código C intermedio
5. **Salida**: `programa_generado.c` (código C)
6. **Reporte**: `programa_reporte.txt` (errores y advertencias)

## 🔧 Componentes

### 1. Lexer (`lexer.jasb`)

**Responsabilidad**: Convertir texto fuente en tokens

**Características**:
- ✅ Reconoce palabras clave del lenguaje
- ✅ Identifica identificadores y literales
- ✅ Maneja strings con escape sequences
- ✅ Soporta números enteros y flotantes
- ✅ Detecta operadores y símbolos
- ✅ Reporta errores léxicos con ubicación precisa

**Tokens soportados**:
- Palabras clave: `principal`, `funcion`, `si`, `mientras`, etc.
- Identificadores: nombres de variables y funciones
- Literales: números, strings, booleanos
- Operadores: `+`, `-`, `*`, `/`, `==`, `!=`, etc.

### 2. Parser (`parser.jasb`)

**Responsabilidad**: Construir AST desde tokens

**Características**:
- ✅ Parsing recursivo descendente
- ✅ Construcción de AST tipado
- ✅ Detección de errores sintácticos
- ✅ Soporte para expresiones anidadas
- ✅ Manejo de precedencia de operadores

**Nodos AST soportados**:
- `NODE_PROGRAM`: Programa completo
- `NODE_FUNCTION`: Definición de función
- `NODE_VAR_DECL`: Declaración de variable
- `NODE_ASSIGNMENT`: Asignación
- `NODE_BINARY_OP`: Operación binaria
- `NODE_CALL`: Llamada a función
- `NODE_PRINT`: Sentencia imprimir

### 3. CodeGen (`codegen.jasb`)

**Responsabilidad**: Generar código C desde AST

**Características**:
- ✅ Generación de C estándar y portable
- ✅ Mapeo de tipos Jasboot → C
- ✅ Declaración automática de variables
- ✅ Optimización básica de expresiones
- ✅ Manejo de funciones del sistema

**Mapeo de tipos**:
```
entero     → int64_t
texto       → char*
flotante    → double
bool        → int
caracter    → char
```

### 4. Diagnósticos (`diagnosticos.jasb`)

**Responsabilidad**: Sistema completo de errores y advertencias

**Características**:
- ✅ Códigos de error estandarizados
- ✅ Mensajes detallados con ubicación
- ✅ Sugerencias de corrección
- ✅ Reportes en múltiples formatos
- ✅ Clasificación por severidad

**Categorías de errores**:
- **Léxicos (LEX001-LEX999)**: Caracteres inválidos, strings sin cerrar
- **Sintácticos (SIN001-SIN999)**: Estructura incorrecta del lenguaje
- **Semánticos (SEM001-SEM999)**: Tipos, variables no declaradas
- **Generación (GEN001-GEN999)**: Errores en generación de código

## 📋 Ejemplos de Uso

### Hola Mundo

**Entrada (`hola_mundo.jasb`)**:
```jasb
principal
    imprimir "Hola Mundo desde Jasboot!"
fin_principal
```

**Salida C generada**:
```c
// Código generado por Compilador Jasboot
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

int main(int argc, char* argv[]) {
    printf("%s\n", "Hola Mundo desde Jasboot!");
    return 0;
}
```

### Variables y Operaciones

**Entrada (`variables.jasb`)**:
```jasb
principal
    entero x = 10
    entero y = 20
    entero resultado = x + y
    imprimir "Resultado: "
    imprimir resultado
fin_principal
```

**Salida C generada**:
```c
int64_t x = 10;
int64_t y = 20;
int64_t resultado = (x + y);
printf("%s\n", "Resultado: ");
printf("%lld\n", resultado);
```

## 🧪 Testing

### Ejecutar Tests

```bash
# Compilar el compilador
node .vscode/run-jasb.cjs compilador.jasb

# Probar con ejemplos
jasboot-ir-vm.exe compilador.jasb ejemplos/hola_mundo.jasb -v -d
```

### Tests Automatizados

El compilador incluye validación automática:
- ✅ Verificación de sintaxis Jasboot
- ✅ Validación de tipos
- ✅ Pruebas de integración
- ✅ Benchmarks de rendimiento

## 🎯 Logros Técnicos

### Capacidades Demostradas

1. **✅ Manipulación de texto**: Tokenización y parsing
2. **✅ Estructuras de datos**: AST, tablas de símbolos
3. **✅ Lógica compleja**: Parsing recursivo, generación de código
4. **✅ Manejo de archivos**: Lectura/Escritura de I/O
5. **✅ Sistema de tipos**: Validación y conversión
6. **✅ Gestión de errores**: Diagnóstico completo
7. **✅ CLI interactivo**: Procesamiento de argumentos

### Hito Alcanzado

**Jasboot puede compilar Jasboot** - Este compilador demuestra que:

- Jasboot tiene **capacidad de Turing completa**
- Puede implementar **procesadores de lenguaje**
- Soporta **metaprogramación** básica
- Tiene **abstracción suficiente** para herramientas complejas

## 🔮 Futuro

### Próximos Pasos

1. **Optimizador**: Mejorar código C generado
2. **Más constructores**: Soportar clases, herencia
3. **Integración directa**: Generar .jbo sin intermediario C
4. **IDE integration**: Plugin para VSCode
5. **Package manager**: Integrar con JPM

### Limitaciones Actuales

- ❌ No genera bytecode .jbo directamente
- ❌ Soporte limitado para características avanzadas
- ❌ Sin optimización de código
- ❌ Manejo básico de módulos

## 🤝 Contribuir

Este compilador es una **demostración de concepto** de la capacidad de Jasboot. Para contribuir:

1. **Reportar bugs**: Errores de compilación
2. **Mejorar mensajes**: Mejorar descripciones de error
3. **Añadir características**: Implementar más constructores
4. **Optimizar**: Mejorar rendimiento y código generado

## 📄 Licencia

Este proyecto es parte del ecosistema Jasboot y sigue la misma licencia.

---

**🎉 ¡Jasboot puede compilarse a sí mismo!**

Este compilador representa un hito fundamental en el desarrollo del lenguaje, demostrando que Jasboot tiene la madurez y capacidades necesarias para herramientas complejas de desarrollo de software.
