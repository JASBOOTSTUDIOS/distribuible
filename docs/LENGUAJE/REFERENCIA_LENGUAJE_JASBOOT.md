# Referencia Completa del Lenguaje Jasboot

Documento de sintaxis, funcionalidades y semántica del lenguaje de programación Jasboot. Paradigma 100% español.

---

## Índice

1. [Introducción](#1-introducción)
2. [Estructura del programa](#2-estructura-del-programa)
3. [Tipos de datos](#3-tipos-de-datos)
4. [Variables y declaraciones](#4-variables-y-declaraciones)
5. [Literales](#5-literales)
6. [Operadores](#6-operadores)
7. [Sentencias de control](#7-sentencias-de-control)
8. [Manejo de excepciones](#8-manejo-de-excepciones)
9. [Bucles y repetición](#9-bucles-y-repetición)
10. [Funciones](#10-funciones)
11. [Registros (estructuras)](#11-registros-estructuras)
12. [Clases y Herencia](#12-clases-y-herencia)
13. [Entrada y salida](#13-entrada-y-salida)
14. [Memoria neuronal (JMN)](#14-memoria-neuronal-jmn)
15. [Llamadas de sistema](#15-llamadas-de-sistema)
16. [Módulos y bibliotecas](#16-módulos-y-bibliotecas)
17. [Gestor de Paquetes (jbc)](#17-gestor-de-paquetes-jbc)

---

## 1. Introducción

Jasboot es un lenguaje de programación que sigue el paradigma de pensamiento humano: usa **conceptos** en lugar de variables, **cuando** en lugar de if, **mientras** en lugar de while, etc. La indentación define bloques; no se usan llaves.

### Palabras prohibidas (inglés)

El lexer rechaza: `if`, `else`, `for`, `while`, `function`, `return`, `true`, `false`, `null`, `var`, `let`, `const`, `class`, `import`, `export`. Use los equivalentes en español.

### Implementación de referencia (compilador jbc)

La **fuente de verdad** práctica del lenguaje que compila a `.jbo` es el compilador C **jbc** en `sdk-dependiente/jas-compiler-c/`:

- **Palabras clave y tokens:** `src/keywords.c`
- **Nombres aceptados como llamada predefinida** `nombre(...)` (además de funciones usuario): `src/sistema_llamadas.c`
- **Qué genera bytecode:** `src/codegen.c` (función `visit_call_sistema`): _no_ todo lo listado en `sistema_llamadas.c` tiene necesariamente codegen; si algo no compila o no hace nada útil, busque el nombre ahí.

---

## 2. Estructura del programa

Un programa Jasboot tiene tres secciones principales, en cualquier orden:

- **Registros** (`registro` … `fin_registro`)
- **Clases** (`clase` … `fin_clase`)
- **Variables globales** (declaraciones en el nivel raíz)
- **Funciones** (`funcion` … `fin_funcion`)
- **Bloque principal** (`principal` … `fin_principal`)

```jasb
clase Persona
    texto nombre
    entero edad

    funcion inicializar(texto n, entero e)
        este.nombre = n
        este.edad = e
    fin_funcion
fin_clase

texto saludo = "Hola"

funcion saludar(Persona p) retorna
    imprimir saludo + ", " + p.nombre
fin_funcion

principal
    Persona juan = Persona("Juan", 30)
    saludar(juan)
fin_principal
```

---

## 3. Tipos de datos

| Tipo         | Descripción                                          | Ejemplo             |
| ------------ | ---------------------------------------------------- | ------------------- |
| `entero`     | Número entero 64 bits con signo                      | `42`                |
| `u32`        | Entero 32 bits sin signo                             | `0x80000000`        |
| `u64`        | Entero 64 bits sin signo                             | `0xFFFFFFFF`        |
| `flotante`   | Número decimal                                       | `3.14`              |
| `texto`      | Cadena de caracteres                                 | `"Hola"`            |
| `caracter`   | Un carácter ASCII (0–255)                            | `'A'`               |
| `bool`       | Booleano (verdadero/falso)                           | `verdadero`         |
| `lista`      | Colección ordenada                                   | `[1, 2, 3]`         |
| `lista<T>`   | Colección tipada (T=entero, flotante...)             | `lista<flotante> v` |
| `mapa`       | Diccionario clave-valor                              | `{"a": 1}`          |
| `vec2`       | Dos flotantes (`x`, `y`)                             | `vec2 v`            |
| `vec3`       | Tres flotantes (`x`, `y`, `z`)                       | `vec3 v`            |
| `vec4`       | Cuatro flotantes (`x`, `y`, `z`, `w`)                | `vec4 v`            |
| `mat4`       | Matriz 4×4 en flotante (128 bytes, row-major)        | `mat4 m`            |
| `mat3`       | Matriz 3×3 en flotante (72 bytes)                    | `mat3 m`            |
| `concepto`   | ID de concepto en memoria neuronal                   | `'hola'`            |
| `nulo`       | Valor nulo (ausencia de valor)                       | `nulo`              |
| `indefinido` | Valor no definido (variable sin asignar)             | `indefinido`        |
| `NeN`        | No es un Número (resultado de operaciones inválidas) | `NeN`               |

### Conversión de Tipos

Jasboot es un lenguaje de tipado fuerte, pero permite ciertas conversiones automáticas para facilitar la legibilidad:

- **Numérica:** `entero` <-> `flotante` (implícita en ambos sentidos).
- **A Texto:** `entero` -> `texto` y `flotante` -> `texto` (implícita en asignación y concatenación).
- **Explícita:** Para otros casos, use `convertir_entero()`, `convertir_flotante()` o `str_desde_numero()`.

### Interpolación de Cadenas

Las variables y expresiones pueden ser insertadas directamente dentro de una cadena de texto usando la sintaxis `${...}`.

```jasb
entero edad = 25
texto msj = "Tengo ${edad} años"  # "Tengo 25 años"
imprimir "Suma: ${5 + 3}"         # "Suma: 8"
```

---

## 4. Variables y declaraciones

### Declaración con tipo

```
tipo nombre [= expresión]
```

```jasb
entero x = 10
flotante pi = 3.14159
texto mensaje = "Hola"
lista<entero> numeros = [1, 2, 3]
```

### Constantes

```
constante tipo nombre = expresión
```

Las constantes son variables inmutables. El valor es obligatorio en la declaración y no puede reasignarse después.

```jasb
constante entero PI = 3
constante texto SALUDO = "Hola"
constante flotante E = 2.718
```

Tipos permitidos por **jbc** en `constante`: `entero`, `texto`, `flotante`, `caracter`, `bool`, `u32`, `u64`, `u8`, `byte`, `vec2`, `vec3`, `vec4`, `mat4`, `mat3`. Intentar asignar a una constante produce error de compilación.

### Asignación

```
nombre = expresión
objeto[indice] = expresión   # lista o mapa
objeto.miembro = expresión   # registro
```

```jasb
x = x + 1
lista[0] = 100
persona.nombre = "Ana"
```

No se puede asignar a constantes.

### Conversión Automática en Asignación

Desde la versión 1.1, el compilador permite asignar valores numéricos directamente a variables de tipo `texto`. El sistema realiza la conversión a cadena automáticamente:

```jasb
texto ts = obtener_timestamp()  # El entero se convierte a texto automáticamente
texto pi_str = 3.14             # El flotante se convierte a "3.14"
```

**Internamente:** `VarDeclNode` → `OP_ESCRIBIR` (o `OP_LEER` para lectura). Los offsets se calculan en `symbol_table.c` y `resolve.c`. Las constantes tienen `is_const` en la tabla de símbolos. Si el destino es `texto` y el origen es numérico, se emite `OP_STR_DESDE_NUMERO`.

---

## 5. Literales

### Números

```jasb
42          # entero
0xFF        # hexadecimal (unsigned)
0x80000000  # hex sin signo (para u32/u64)
3.14        # flotante
.5          # flotante 0.5
```

### Cadenas

```jasb
"Hola mundo"
"Línea 1\nLínea 2"    # \n nueva línea
"Tab:\tcolumna"       # \t tabulador
"Comillas: \"abc\""   # \"
"Barra: \\"           # \\
```

### Carácter

```jasb
'A'                   # Un solo carácter entre comillas simples
'!'                   # Literal caracter (código ASCII)
```

Un literal con **una sola** letra entre comillas simples es de tipo `caracter` y almacena su código ASCII. Cadenas de varios caracteres (`'hola'`) se tratan como `concepto` (memoria neuronal).

### Conceptos (memoria neuronal)

```jasb
'nombre_concepto'     # ID de concepto, sintaxis con comillas simples (varios caracteres)
```

### Listas

```jasb
[1, 2, 3]
["a", "b", "c"]
[]                   # lista vacía
[1, "texto", 3.14]   # tipos mixtos
```

**Internamente:** `ListLiteralNode` → `OP_MEM_LISTA_CREAR` + `OP_MEM_LISTA_AGREGAR` en bucle.

### Mapas

```jasb
{"clave": "valor"}
{"nombre": "Jas", "edad": 10}
{}                    # mapa vacío
```

**Internamente:** `MapLiteralNode` → `OP_MEM_MAPA_CREAR` + `OP_MEM_MAPA_PONER` en bucle.

### Booleanos

```jasb
verdadero
falso
```

### Valores especiales

```jasb
nulo           # Valor nulo (ausencia de valor)
indefinido     # Valor no definido
NeN            # No es un Número (NaN), resultado de operaciones inválidas con flotantes
```

---

## 6. Operadores

### Aritméticos

| Operador | Descripción    | Ejemplo |
| -------- | -------------- | ------- |
| `+`      | Suma           | `a + b` |
| `-`      | Resta          | `a - b` |
| `*`      | Multiplicación | `a * b` |
| `/`      | División       | `a / b` |
| `%`      | Módulo         | `a % b` |

**Internamente:** `OP_SUMAR`, `OP_RESTAR`, `OP_MULTIPLICAR`, `OP_DIVIDIR`, `OP_MODULO`. Para flotantes: `OP_*_FLT`.

### Comparación

| Operador | Descripción   | Alternativa en español  |
| -------- | ------------- | ----------------------- |
| `==`     | Igual         | `es igual a`            |
| `!=`     | Distinto      | -                       |
| `<`      | Menor         | `menor que` / `menor a` |
| `>`      | Mayor         | `mayor que` / `mayor a` |
| `<=`     | Menor o igual | -                       |
| `>=`     | Mayor o igual | -                       |

```jasb
x == 10
edad mayor que 18
nombre es igual a "admin"
```

### Lógicos

| Operador | Descripción       |
| -------- | ----------------- |
| `y`      | AND lógico        |
| `o`      | OR lógico         |
| `no`     | NOT (también `!`) |

```jasb
activo y conectado
edad >= 18 o es_admin
no terminado
```

### Bits

| Operador | Descripción              |
| -------- | ------------------------ |
| `<<`     | Desplazamiento izquierda |
| `>>`     | Desplazamiento derecha   |

**Internamente:** `OP_BIT_SHL`, `OP_BIT_SHR`.

### Flotantes: funciones predefinidas (un argumento o dos)

En expresiones se pueden llamar (radianes en trigonometría):

| Función                               | Descripción                 |
| ------------------------------------- | --------------------------- |
| `sin(x)`, `cos(x)`, `tan(x)`          | Trigonometría               |
| `atan2(y, x)` o `arcotangente2(y, x)` | Arcotangente dos argumentos |
| `exp(x)`, `log(x)`, `log10(x)`        | Exponencial y logaritmos    |

No hay en fuente un `raiz(x)` genérico; la raíz cuadrada de flotantes se usa internamente en opcodes (p. ej. longitud de vectores).

### Ternario

```
condición ? valor_si_verdadero : valor_si_falso
```

```jasb
edad >= 18 ? "adulto" : "menor"
```

**Internamente:** `TernaryNode` → emisión de condición + `OP_SI` + ramas.

### Precedencia (mayor a menor)

1. Paréntesis `()`
2. Unario: `-`, `no`
3. Multiplicativos: `*`, `/`, `%`, `<<`, `>>`
4. Aditivos: `+`, `-`
5. Comparación: `==`, `!=`, `<`, `>`, `<=`, `>=`
6. Lógico AND: `y`
7. Lógico OR: `o`
8. Ternario: `?:`

---

## 7. Sentencias de control

### Condicional: cuando / si

```jasb
cuando condición entonces hacer
    # bloque si verdadero
sino
    # bloque si falso
fin_cuando
```

Alias: `si` / `fin_si`. El `entonces` y `hacer` son opcionales en algunas variantes.

```jasb
si x > 0 hacer
    imprimir "Positivo"
sino si x < 0 hacer
    imprimir "Negativo"
sino
    imprimir "Cero"
fin_si
```

**Internamente:** `IfNode` → evaluación de condición, `OP_SI`, saltos condicionales, `OP_IR`.

### Selección: seleccionar

Permite ejecutar diferentes bloques de código según el valor de una expresión.

```jasb
seleccionar expresion hacer
    caso valor1
        # bloque si expresion == valor1
    caso valor2
        # bloque si expresion == valor2
    defecto
        # bloque si no coincide ningún caso
fin_seleccionar
```

**Internamente:** `SwitchNode` → emite comparación por cada caso + saltos.

---

## 8. Manejo de excepciones

Jasboot permite capturar errores de ejecución (como división por cero o clave inexistente en mapa) mediante bloques de control de excepciones.

### intentar / atrapar / final

```jasb
intentar
    # Código que puede fallar
    entero x = 10 / 0
atrapar mensaje
    # Se ejecuta si ocurre un error (el mensaje se guarda en la variable 'mensaje')
    imprimir "Error capturado: " + mensaje
final
    # Se ejecuta siempre al final, haya error o no (opcional)
    imprimir "Limpieza final"
fin_intentar
```

### lanzar

Permite generar un error personalizado manualmente.

```jasb
si saldo < monto entonces
    lanzar "Saldo insuficiente"
fin_si
```

---

## 9. Bucles y repetición

### Bucle: mientras

```jasb
mientras condición hacer
    # cuerpo del bucle
fin_mientras
```

```jasb
mientras x > 0 hacer
    imprimir x
    x = x - 1
fin_mientras
```

**Internamente:** `WhileNode` → etiqueta inicio, evaluación condición, `OP_SI` a fin, cuerpo, salto a inicio.

### Romper y continuar

```jasb
mientras verdadero hacer
    cuando encontrado hacer
        romper
    fin_cuando
    cuando omitir hacer
        continuar
    fin_cuando
fin_mientras
```

- **romper:** Sale del bucle más interno.
- **continuar:** Salta al inicio de la siguiente iteración.

**Internamente:** `OP_IR` a la etiqueta de salida (romper) o de inicio (continuar).

---

## 10. Funciones

### Definición

```jasb
funcion nombre(tipo1 param1, tipo2 param2) retorna [tipo]
    # cuerpo
    retornar expresión
fin_funcion
```

```jasb
funcion sumar(entero a, entero b) retorna entero
    retornar a + b
fin_funcion

funcion saludar(texto nombre) retorna
    imprimir "Hola, " + nombre
fin_funcion
```

### Llamada

```jasb
variable = sumar(10, 20)
saludar("Mundo")
```

**Internamente:** `FunctionNode` → etiqueta, parámetros en offsets locales. Llamada: `OP_LLAMAR` + parche de salto. Retorno: `OP_RETORNAR` + `OP_MOVER` resultado a R1.

---

## 11. Registros (estructuras)

Los registros son agrupaciones simples de datos (sin métodos).

```jasb
registro Persona
    texto nombre
    entero edad
fin_registro

principal
    Persona p
    p.nombre = "Ana"
    p.edad = 25
    imprimir p.nombre
fin_principal
```

---

## 12. Clases y Herencia

Jasboot soporta un sistema completo de clases con herencia, polimorfismo y visibilidad.

### Definición y Herencia

Se usa `clase` y `extiende`.

```jasb
clase Animal
    texto nombre

    funcion inicializar(texto n)
        este.nombre = n
    fin_funcion

    funcion hablar()
        imprimir este.nombre + " hace un sonido"
    fin_funcion
fin_clase

clase Perro extiende Animal
    entero edad_perruna

    # Sobrescritura de constructor
    funcion inicializar(texto n, entero e)
        padre.inicializar(n)  # Llamada al constructor base
        este.edad_perruna = e
    fin_funcion

    # Sobrescritura de método (Polimorfismo)
    funcion hablar()
        imprimir este.nombre + " dice: ¡Guao!"
        imprimir "--- Detalle Base ---"
        padre.hablar()       # Llamada al método de la clase base
    fin_funcion
fin_clase
```

### Palabras Clave Especiales

- **`este`**: Referencia a la instancia actual del objeto (como `this` o `self`).
- **`padre`**: Referencia a la clase base inmediata para invocar métodos o constructores originales (como `super`).
- **`inicializar`**: Nombre reservado para el método constructor que se invoca automáticamente al instanciar.

### Visibilidad

Se puede usar el modificador `privado` para campos y métodos, restringiendo su acceso solo a métodos de la propia clase.

```jasb
clase CuentaBancaria
    privado flotante saldo

    funcion inicializar(flotante inicial)
        este.saldo = inicial
    fin_funcion

    funcion obtener_saldo() retorna flotante
        retornar este.saldo
    fin_funcion
fin_clase
```

### Polimorfismo (Despacho Dinámico)

El compilador genera dispatch dinámico. Si una variable de tipo clase base contiene una instancia de una clase derivada, al llamar a un método se ejecutará la versión de la clase derivada.

---

## 13. Entrada y salida

### imprimir / imprimir_sin_salto

Imprime expresiones en la consola estándar.

**Conversión Implícita:**
Soporta conversión automática de cualquier tipo numérico a `texto` durante la impresión o concatenación con el operador `+`.

```jasb
entero edad = 25
imprimir "Tengo " + edad + " años"  # Imprime: Tengo 25 años
```

### ingresar_texto / ingreso_inmediato

Permite capturar entrada del usuario. `ingresar_texto()` espera a que el usuario presione Enter, mientras que `ingreso_inmediato()` (alias `percibir_teclado()`) captura la primera tecla presionada.

---

## 14. Memoria neuronal (JMN)

Jasboot integra de forma nativa la **JMN (Red de Memoria Jasboot)**, permitiendo almacenar y recuperar información de forma asociativa y persistente.

### Operaciones Básicas

| Comando                      | Descripción                                                                              |
| ---------------------------- | ---------------------------------------------------------------------------------------- |
| `crear_memoria(ruta)`        | Crea o abre un archivo de memoria neuronal `.jmn`.                                       |
| `cerrar_memoria()`           | Cierra la memoria actual y guarda los cambios.                                           |
| `recordar clave con valor v` | Almacena un valor asociado a una clave en la red.                                        |
| `buscar clave`               | Recupera el valor asociado a la clave (se almacena en la palabra reservada `resultado`). |
| `asociar c1 con c2`          | Crea una conexión semántica entre dos conceptos.                                         |
| `pensar consulta`            | Realiza una búsqueda por similitud semántica en la red.                                  |

### Operaciones Avanzadas (Funciones No Documentadas pero Funcionales)

> **Nota**: Estas funciones existen y funcionan en la VM actual pero no están documentadas oficialmente. Se incluyen aquí por su funcionalidad comprobada.

| Comando                      | Descripción                                                                              |
| ---------------------------- | ---------------------------------------------------------------------------------------- |
| `buscar_asociados consulta`  | Busca conceptos asociados semánticamente (retorna ID numérico en `resultado`).           |
| `propagar_activacion(texto)` | Propaga activación semántica en la red (retorna ID numérico en `resultado`).              |

### Búsqueda Introspectiva en JMN

> **Nuevo en 2024**: Sistema modular de búsqueda en toda la memoria neuronal.

La **búsqueda introspectiva** permite buscar texto dentro de las claves y valores de todos los conceptos almacenados en JMN. Ofrece 4 niveles de funcionalidad según tus necesidades.

#### Funciones de Búsqueda (Estado de Implementación)

| Función | Estado | Descripción |
|---------|:------:|-------------|
| `buscar_en_memoria(termino)` | ✅ **FUNCIONA** | Búsqueda básica, primer resultado, case-insensitive |
| `buscar_en_memoria_cs(termino, cs)` | ✅ **FUNCIONA** | Con control de mayúsculas (0=insensitive, 1=sensitive) |
| `buscar_en_memoria_lista(termino, max)` | ⏳ Implementada* | Lista de IDs (requiere corrección de listas JMN) |
| `buscar_en_memoria_detallada(termino, max, cs)` | ⏳ Implementada* | Con metadata completa (requiere corrección de listas JMN) |

> **Nota**: Las funciones marcadas con * están completamente implementadas y encuentran resultados correctamente, pero dependen del sistema de listas JMN que tiene un bug pendiente de corrección. Las funciones básicas (sin listas) funcionan perfectamente.


#### 1. `buscar_en_memoria(termino)` - Búsqueda Básica ✅

Busca texto en claves y valores, devuelve el primer resultado encontrado (case-insensitive).

```jasb
crear_memoria("datos.jmn")

recordar "inteligencia_artificial" con valor "Sistema cognitivo"
recordar "redes_neuronales" con valor "Arquitectura del cerebro"

# Buscar
buscar_en_memoria("cerebro")
si resultado != 0 entonces
    imprimir("Encontrado: " + resultado)  # "Arquitectura del cerebro"
fin_si

cerrar_memoria()
```

**Características:**
- ✅ Case-insensitive (ignora mayúsculas)
- ✅ Retorna primer resultado en `resultado`
- ✅ Busca en claves y valores
- ✅ Retorna 0 si no encuentra nada

#### 2. `buscar_en_memoria_cs(termino, case_sensitive)` - Con Control de Mayúsculas ✅

Búsqueda con control de case-sensitivity.

```jasb
crear_memoria("datos.jmn")

recordar "Python" con valor "Lenguaje de programación"
recordar "python_snake" con valor "Serpiente pitón"

# Buscar exactamente "Python" (mayúscula)
buscar_en_memoria_cs("Python", 1)  # case-sensitive = 1
imprimir("Exacto: " + resultado)  # "Python"

# Buscar cualquier variante de "python"
buscar_en_memoria_cs("python", 0)  # case-sensitive = 0
imprimir("Flexible: " + resultado)  # "Python" o "python_snake"

cerrar_memoria()
```

**Parámetros:**
- `termino` (texto): Término a buscar
- `case_sensitive` (entero): `0` = insensitive, `1` = sensitive

**Sinónimo:** `buscar_introspectiva(termino)` es equivalente a `buscar_en_memoria(termino)`

#### 3. `buscar_en_memoria_lista(termino, max)` - Lista de Resultados ⏳

> ⚠️ **Implementada pero requiere corrección de listas JMN**

Devuelve una lista con múltiples IDs encontrados (cuando el sistema de listas funcione).

```jasb
# Sintaxis (funcionalidad pendiente de sistema de listas)
elemento lista = buscar_en_memoria_lista("aprendizaje", 5)
elemento tam = mem_lista_tamano(lista)

entero i = 0
mientras i < tam hacer
    elemento id = mem_lista_obtener(lista, i)
    imprimir("Resultado " + i + ": " + id)
    i = i + 1
fin_mientras
```

**Parámetros:**
- `termino` (texto): Término a buscar
- `max` (entero): Máximo de resultados (1-100, default 10)

#### 4. `buscar_en_memoria_detallada(termino, max, cs)` - Con Metadata ⏳

> ⚠️ **Implementada pero requiere corrección de listas JMN**

Devuelve lista de mapas con metadata completa: ID, texto, posición, relevancia, tipo.

```jasb
# Sintaxis (funcionalidad pendiente de sistema de listas)
elemento lista = buscar_en_memoria_detallada("procesamiento", 3, 0)
elemento tam = mem_lista_tamano(lista)

entero i = 0
mientras i < tam hacer
    elemento mapa = mem_lista_obtener(lista, i)
    
    elemento id = mapa_obtener(mapa, "id")
    elemento texto = mapa_obtener(mapa, "texto")
    elemento posicion = mapa_obtener(mapa, "posicion")
    elemento relevancia = mapa_obtener(mapa, "relevancia")
    elemento es_clave = mapa_obtener(mapa, "es_clave")
    
    imprimir("ID: " + id)
    imprimir("Texto: " + texto)
    imprimir("Posición: " + posicion)
    imprimir("Relevancia: " + relevancia)
    
    i = i + 1
fin_mientras
```

**Parámetros:**
- `termino` (texto): Término a buscar
- `max` (entero): Máximo de resultados (1-100)
- `case_sensitive` (entero): `0` = insensitive, `1` = sensitive (opcional)

**Metadata disponible:**
- `id`: ID del concepto
- `texto`: Texto completo del concepto
- `posicion`: Posición donde se encontró
- `longitud_match`: Longitud de la coincidencia
- `es_clave`: 1 si es clave, 0 si es valor
- `relevancia`: Score 0.0-1.0

### Ejemplo de uso completo

```jasb
principal
    crear_memoria("mi_memoria.jmn")

    # Almacenar información
    recordar "usuario_nombre" con valor "Aurora"
    recordar "usuario_rol" con valor "IA"

    # Asociar conceptos
    asociar "Aurora" con "IA"

    # Recuperar
    buscar "usuario_nombre"
    imprimir "Nombre: " + resultado  # Imprime: Nombre: Aurora

    # Búsqueda introspectiva básica (FUNCIONA)
    buscar_en_memoria("Aurora")
    si resultado != 0 entonces
        imprimir "Encontrado: " + resultado
    fin_si

    # Búsqueda con control de mayúsculas (FUNCIONA)
    buscar_en_memoria_cs("AURORA", 0)  # case-insensitive
    imprimir "Resultado: " + resultado

    # Operaciones avanzadas (funciones no documentadas pero funcionales)
    buscar_asociados "Aurora"
    imprimir "ID asociado: " + resultado  # Ej: 2147483650
    
    propagar_activacion "IA"
    imprimir "Activación: " + resultado  # Ej: 2826870867

    cerrar_memoria()
fin_principal
```

### Documentación Adicional

Para más información sobre búsqueda introspectiva:
- Ver: `docs/BUSQUEDA_INTROSPECTIVA_COMPLETA.md` - Documentación técnica completa
- Ver: `docs/API_buscar_introspectiva.md` - Referencia rápida de API
- Ver: `docs/LENGUAJE/jmn/BUSQUEDA_INTROSPECTIVA.md` - Guía de uso JMN

---

## 15. Llamadas de sistema

### Cadenas y Conversión

| Función               | Descripción                                       |
| --------------------- | ------------------------------------------------- |
| `str_desde_numero(n)` | Convierte `entero` o `flotante` a `texto`.        |
| `decimal(f, p)`       | Convierte `flotante` a `texto` con `p` decimales. |
| `str_a_entero(s)`     | Convierte `texto` a `entero`.                     |
| `str_a_flotante(s)`   | Convierte `texto` a `flotante`.                   |
| `longitud(s)`         | Retorna la longitud de una cadena o lista.        |
| `concatenar(s1, s2)`  | Une dos cadenas de texto.                         |

### Tiempo y Sistema

| Función                        | Descripción                                                                     |
| ------------------------------ | ------------------------------------------------------------------------------- |
| `obtener_timestamp()`          | Retorna el tiempo Unix actual (en segundos) como `entero`.                      |
| `formatear_timestamp(ts, fmt)` | Retorna el timestamp `ts` formateado según la cadena `fmt` (estilo `strftime`). |

**Ejemplo de formateo de tiempo:**

```jasb
principal
    entero ahora = obtener_timestamp()

    # Formatos comunes:
    texto f1 = formatear_timestamp(ahora, "%d/%m/%Y %H:%M:%S") # 17/04/2026 16:30:00
    texto f2 = formatear_timestamp(ahora, "%H:%M")             # 16:30
    texto f3 = formatear_timestamp(ahora, "%A, %d de %B")      # Friday, 17 de April

    imprimir "Fecha: " + f1
fin_principal
```

| Función                  | Descripción                                           |
| ------------------------ | ----------------------------------------------------- |
| `pausa_milisegundos(ms)` | Detiene la ejecución por `ms` milisegundos.           |
| `sistema_ejecutar(cmd)`  | Ejecuta un comando del sistema operativo.             |
| `sys_argc()`             | Retorna el número de argumentos de línea de comandos. |
| `sys_argv(i)`            | Retorna el argumento `i` de la línea de comandos.     |

### Archivos (FS)`pausa_milisegundos(ms)` | Detiene la ejecución por `ms` milisegundos. |

| `sistema_ejecutar(cmd)` | Ejecuta un comando del sistema operativo. |
| `sys_argc()` | Retorna el número de argumentos de línea de comandos. |
| `sys_argv(i)` | Retorna el argumento `i` de la línea de comandos. |

### Archivos (FS)

| Función                     | Descripción                                             |
| --------------------------- | ------------------------------------------------------- |
| `abrir_archivo(ruta, modo)` | Abre un archivo ("r", "w", "a"). Retorna un descriptor. |
| `leer_linea_archivo(fd)`    | Lee una línea de un archivo abierto.                    |
| `escribir_archivo(fd, txt)` | Escribe texto en un archivo.                            |
| `cerrar_archivo(fd)`        | Cierra el descriptor de archivo.                        |
| `existe_archivo(ruta)`      | Retorna `verdadero` si el archivo existe.               |

---

## 16. Módulos y bibliotecas

Jasboot soporta un sistema de módulos para organizar y reutilizar código.

### Importar módulos (`usar`)

Para importar funciones y clases desde otros archivos:

```jasb
# Importar funciones específicas
usar {funcion1, funcion2, clase1} de "modulo.jasb"

# Importar todo el módulo
usar todas de "modulo.jasb"

# Importar con ruta relativa
usar todas de "..\\stdlib\\logger.jasb"
```

**Reglas importantes:**

- La ruta del archivo debe estar entre comillas dobles
- Las funciones importadas deben estar exportadas con `enviar` en el módulo origen
- `usar todas` importa todo lo exportado del módulo
- Las rutas relativas usan `\\` como separador en Windows

### Exportar (`enviar`)

Para hacer funciones y clases disponibles para otros módulos:

```jasb
# Exportar funciones específicas
enviar funcion mi_funcion
enviar clase MiClase

# Exportar múltiples elementos
enviar {funcion1, funcion2, clase1, clase2}

# Exportar todo (no recomendado, explícito es mejor)
enviar todas
```

**Reglas importantes:**

- Solo se puede exportar lo que está definido en el archivo actual
- Las funciones deben ser declaradas antes de exportarse
- Las clases deben estar completamente definidas antes de exportarse

### Ejemplo completo

**Archivo: `matematicas.jasb`**

```jasb
funcion sumar(entero a, entero b) retorna entero
    retornar a + b
fin_funcion

funcion multiplicar(entero a, entero b) retorna entero
    retornar a * b
fin_funcion

enviar {sumar, multiplicar}
```

**Archivo: `principal.jasb`**

```jasb
usar {sumar, multiplicar} de "matematicas.jasb"

principal
    entero resultado1 = sumar(5, 3)
    entero resultado2 = multiplicar(4, 6)
    imprimir "Suma: " + resultado1
    imprimir "Multiplicación: " + resultado2
fin_principal
```

### Módulos de la biblioteca estándar

La biblioteca estándar de Jasboot está organizada en módulos:

```jasb
# Importar logger
usar todas de "stdlib\\logging\\logger.jasb"

# Importar utilidades matemáticas
usar todas de "stdlib\\math\\basicas.jasb"

# Importar componentes de UI
usar todas de "stdlib\\Estructa\\ui.jasb"
```

---

## 17. Gestor de Paquetes (jbc)

El compilador `jbc` también actúa como gestor de ejecución y compilación.

### Comandos principales

| Comando                 | Descripción                                                  |
| ----------------------- | ------------------------------------------------------------ |
| `jbc <archivo.jasb>`    | Compila el archivo a `.jbo`.                                 |
| `jbc -r <archivo.jasb>` | Compila y ejecuta inmediatamente.                            |
| `jbc -e`                | Establece el directorio de trabajo en la carpeta del script. |
| `jbc -v`                | Muestra la versión del compilador y la VM.                   |

---

## Resumen de opcodes principales

| Categoría | Opcodes                                                                            |
| --------- | ---------------------------------------------------------------------------------- |
| Clases    | `OP_HEAP_RESERVAR` (con Class ID), `OP_LEER` (Class ID para dispatch), `OP_LLAMAR` |

---

**Última actualización:** 2026-04-17 (Soporte completo de Clases, Herencia, Polimorfismo, Módulos y Conversión Automática a Texto)
