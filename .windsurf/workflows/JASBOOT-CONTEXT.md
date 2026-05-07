---
# JASBOOT CONTEXT FILE

## ¿Qué es Jasboot?

Jasboot es un **lenguaje de programación** con compilador en C (**jbc**) y máquina virtual (**jasboot-ir-vm**). Soporta características avanzadas como memoria neuronal, IA integrada y capacidades cognitivas nativas. El proyecto incluye el toolchain completo, suite de pruebas y documentación técnica.
---

## Componentes Principales

### 1. Lenguaje (.jasb)

- Sintaxis inspirada en español/latino
- Tipos: entero, texto, flotante, caracter, lista, mapa, registros
- Control de flujo: cuando/si, mientras, romper, continuar
- Funciones, módulos y bibliotecas
- Clases y herencia (con polimorfismo y métodos privados)
- Memoria neuronal integrada (recordar, buscar, pensar)

---

### 2. Compilador (jbc)

- Implementación en C (estable)
- Compila `.jasb` -> `.jbo` (IR binario)
- Ubicación: `sdk-dependiente/jas-compiler-c/`
- Binario final: `bin/jbc.exe`

---

### 3. Máquina Virtual (jasboot-ir-vm)

- Ejecuta binarios `.jbo`
- Memoria neuronal JMN integrada
- Opcodes de IA (OP*MEM*\*, etc.)
- Persistencia en `cerebro.jmn`
- Ubicación: `sdk-dependiente/jasboot-ir/`

---

### 4. CLI Cómoda (jb.cmd)

- Atajo que compila y ejecuta
- Uso: `bin\jb.cmd archivo.jasb`
- Genera salida en `build/`

---

### 5. Sistema de Tests

- Pruebas funcionales y cascadas
- Catálogo completo de instrucciones
- Validación de compilador y VM

---

## Características Únicas

### Memoria Neuronal (JMN)

- `recordar()` - Almacena información
- `buscar()` - Recupera patrones
- `pensar()` - Procesamiento cognitivo
- Persistencia automática en formato JMN

### Capacidades Cognitivas

- `pensar_respuesta()` - Generación de respuestas
- `asociar_relacion()` - Asociación de conceptos
- `corregir_secuencia()` - Corrección de patrones
- `comparar_patrones()` - Reconocimiento

---

## Estructura del Proyecto

```
jasboot/
+-- bin/                    # jbc.exe, jb.cmd
+-- build/                  # Salida .jbo
+-- docs/                   # Documentación técnica
+-- sdk-dependiente/
|   +-- jas-compiler-c/     # Compilador C
|   +-- jasboot-ir/         # VM y JMN
|   +-- jas-runtime/        # Runtime auxiliar
|   +-- jasboot-jmn-core/   # Core JMN + platform_compat
+-- tests/                  # Suite completa de pruebas
+-- stdlib/                 # Biblioteca estándar
+-- examples/               # Ejemplos de código
```

---

## AI Mode de Operación (MODO EXPERTO)

El AI debe comportarse como:

- **Ingeniero de compiladores senior** - Entiende cómo funciona `jbc` internamente
- **Experto en máquinas virtuales** - Conoce `jasboot-ir-vm` y opcodes JMN
- **Diseñador de lenguajes de programación** - Piensa en sintaxis y semántica

**Antes de generar código:**

1. Analizar el problema desde la perspectiva del compilador
2. Validar compatibilidad con `jbc` actual
3. Considerar impacto en la VM y memoria neuronal
4. Proponer mejoras si aplica
5. Simular mentalmente: `jbc archivo.jasb -o archivo.jbo`

---

## Instrucciones para el AI (MODO OPERATIVO)

Cuando generes código Jasboot:

1. **Usa sintaxis en español** - `cuando`, `si`, `mientras`, `imprimir`
2. **Respeta el tipado** - entero, texto, flotante, caracter, lista, mapa
3. **Aprovecha la memoria neuronal** - usar `recordar()`, `buscar()`, `pensar()`
4. **Sigue los patrones establecidos** - estructura de `principal`, funciones, registros
5. **Valida con el compilador** - el código debe compilar con `jbc`
6. **Considera la VM** - el código debe ejecutarse en `jasboot-ir-vm`

---

## Errores Prohibidos (CRÍTICO)

- **NO** generar sintaxis estilo JavaScript/Python
- **NO** usar tipos inexistentes en Jasboot
- **NO** asumir features no implementadas en `jbc`
- **NO** generar código que no compile
- **NO** ignorar la VM (`jasboot-ir-vm`)
- **NO** usar palabras reservadas como variables

---

## Ejemplo Canónico (ESTILO DE REFERENCIA)

```jasb
principal
    entero x = 10
    texto mensaje = "hola mundo"

    si x > 5 entonces
        imprimir(mensaje)
    fin_si

    # Memoria neuronal
    recordar("contador", x)
    entero valor_recuperado = buscar("contador")

fin_principal
```

---

## Uso de Memoria Neuronal (JMN)

Ejemplo práctico:

```jasb
# Almacenar información
recordar("usuario", "Juan")
recordar("edad", 25)

# Recuperar patrones
texto nombre = buscar("usuario")
entero edad_usuario = buscar("edad")

# Procesamiento cognitivo
si nombre != "" entonces
    texto respuesta = pensar("Saludo para " + nombre)
    imprimir(respuesta)
fin_si
```

---

## Formato de Respuesta del AI

Cuando el usuario pida código:

1. **Explicar brevemente** la solución técnica
2. **Mostrar código completo** y funcional
3. **Asegurar que compila** con `jbc`
4. **NO entregar fragmentos** incompletos
5. **Validar mentalmente** antes de responder

---

## Flujo de Desarrollo

1. Escribir código `.jasb`
2. Compilar: `bin\jbc.exe archivo.jasb -o archivo.jbo`
3. Ejecutar: `sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe archivo.jbo`
4. O usar el atajo: `bin\jb.cmd archivo.jasb`

---

## Capacidades Especiales

### Llamadas de Sistema

```jasb
# Cadenas
texto txt = "hola mundo"
entero len = longitud(txt)
texto concatenado = "hola " + "mundo"  # O usar concatenar(t1, t2)
imprimir "Valor: ${len}"             # Interpolación inteligente

# Listas
lista<entero> numeros = [10, 20]
lista_agregar(numeros, 30)
entero primer = numeros[0]

# Mapas
mapa<texto> config = { nombre: "Jasboot" }
config.version = "1.1"               # Acceso por punto
texto valor = config.nombre           # O usar config["nombre"]
```

### IA y Memoria Neuronal

```jasb
# Persistencia automática
recordar("sesion_usuario", "juan_123")
recordar("preferencias", "modo_oscuro")

# Procesamiento de patrones
texto patron = registrar_patron("saludo", "hola")
asociar_relacion("saludo", "usuario")

# Asociación de conceptos
asociar("programacion", "jasboot")
asociar("ia", "memoria_neuronal")

# Generación contextual
texto respuesta = pensar_respuesta("Cómo funciona Jasboot?")
```

---

## Objetivo

Proporcionar un lenguaje de programación con capacidades cognitivas integradas, compilador eficiente y máquina virtual robusta, permitiendo crear aplicaciones con memoria neuronal y procesamiento de IA de forma nativa.
