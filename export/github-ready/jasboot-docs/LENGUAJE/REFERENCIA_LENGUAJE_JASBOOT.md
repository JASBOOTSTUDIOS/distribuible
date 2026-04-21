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
8. [Funciones](#8-funciones)
9. [Registros (estructuras)](#9-registros-estructuras)
10. [Entrada y salida](#10-entrada-y-salida)
11. [Memoria neuronal](#11-memoria-neuronal)
12. [Llamadas de sistema](#12-llamadas-de-sistema)
13. [Módulos y bibliotecas](#13-módulos-y-bibliotecas)

---

## 1. Introducción

Jasboot es un lenguaje de programación que sigue el paradigma de pensamiento humano: usa **conceptos** en lugar de variables, **cuando** en lugar de if, **mientras** en lugar de while, etc. La indentación define bloques; no se usan llaves.

### Palabras prohibidas (inglés)

El lexer rechaza: `if`, `else`, `for`, `while`, `function`, `return`, `true`, `false`, `null`, `var`, `let`, `const`, `class`, `import`, `export`. Use los equivalentes en español.

### Implementación de referencia (compilador jbc)

La **fuente de verdad** práctica del lenguaje que compila a `.jbo` es el compilador C **jbc** en `sdk-dependiente/jas-compiler-c/`:

- **Palabras clave y tokens:** `src/keywords.c`
- **Nombres aceptados como llamada predefinida** `nombre(...)` (además de funciones usuario): `src/sistema_llamadas.c`
- **Qué genera bytecode:** `src/codegen.c` (función `visit_call_sistema`): *no* todo lo listado en `sistema_llamadas.c` tiene necesariamente codegen; si algo no compila o no hace nada útil, busque el nombre ahí.

---

## 2. Estructura del programa

Un programa Jasboot tiene tres secciones principales, en cualquier orden:

- **Registros** (`registro` … `fin_registro`)
- **Variables globales** (declaraciones en el nivel raíz)
- **Funciones** (`funcion` … `fin_funcion`)
- **Bloque principal** (`principal` … `fin_principal`)

```jasb
registro Persona
    texto nombre
    entero edad
fin_registro

texto saludo = "Hola"
entero contador = 0

funcion saludar(texto quien) retorna
    imprimir saludo + ", " + quien
fin_funcion

principal
    saludar("Mundo")
fin_principal
```

**Internamente:** El parser construye un AST `ProgramNode` con `functions`, `globals`, `main_block` y `n_structs`. El codegen emite cabecera IR (magic JASB, versión) y luego instrucciones de bytecode.

---

## 3. Tipos de datos

| Tipo       | Descripción                              | Ejemplo         |
|------------|------------------------------------------|-----------------|
| `entero`   | Número entero 64 bits con signo          | `42`            |
| `u32`      | Entero 32 bits sin signo                 | `0x80000000`    |
| `u64`      | Entero 64 bits sin signo                 | `0xFFFFFFFF`    |
| `flotante` | Número decimal                           | `3.14`          |
| `texto`    | Cadena de caracteres                     | `"Hola"`        |
| `caracter` | Un carácter ASCII (0–255)                | `'A'`           |
| `bool`     | Booleano (verdadero/falso)               | `verdadero`     |
| `lista`    | Colección ordenada                       | `[1, 2, 3]`     |
| `mapa`     | Diccionario clave-valor                  | `{"a": 1}`      |
| `vec2`     | Dos flotantes (`x`, `y`)                 | `vec2 v`        |
| `vec3`     | Tres flotantes (`x`, `y`, `z`)           | `vec3 v`        |
| `vec4`     | Cuatro flotantes (`x`, `y`, `z`, `w`)    | `vec4 v`        |
| `mat4`     | Matriz 4×4 en flotante (128 bytes, row-major) | `mat4 m`   |
| `mat3`     | Matriz 3×3 en flotante (72 bytes)        | `mat3 m`        |
| `concepto` | ID de concepto en memoria neuronal       | `'hola'`        |
| `nulo`     | Valor nulo (ausencia de valor)           | `nulo`          |
| `indefinido` | Valor no definido (variable sin asignar) | `indefinido`    |
| `NeN`      | No es un Número (resultado de operaciones inválidas) | `NeN`     |
| `cualquiera` | Tipo dinámico / acepta cualquier tipo  | *(anotación)*   |

**Internamente:** Los tipos se resuelven en la tabla de símbolos (`resolve.c`). Cada variable tiene un offset en memoria; las listas/mapas usan IDs en el heap de la VM. Los tipos `nulo`, `indefinido`, `NeN` y `cualquiera` pueden estar en fase de implementación según la versión del compilador.

---

## 4. Variables y declaraciones

### Declaración con tipo

```
tipo nombre [= expresión]
```

```jasb
entero x = 10
u32 flags = 0x80000000
u64 handle = 0xFFFFFFFF
texto mensaje = "Hola"
flotante pi = 3.14159
caracter c = 'A'
bool activo = verdadero
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

**Internamente:** `VarDeclNode` → `OP_ESCRIBIR` (o `OP_LEER` para lectura). Los offsets se calculan en `symbol_table.c` y `resolve.c`. Las constantes tienen `is_const` en la tabla de símbolos.

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

| Operador | Descripción | Ejemplo   |
|----------|-------------|-----------|
| `+`      | Suma        | `a + b`   |
| `-`      | Resta       | `a - b`   |
| `*`      | Multiplicación | `a * b` |
| `/`      | División    | `a / b`   |
| `%`      | Módulo      | `a % b`   |

**Internamente:** `OP_SUMAR`, `OP_RESTAR`, `OP_MULTIPLICAR`, `OP_DIVIDIR`, `OP_MODULO`. Para flotantes: `OP_*_FLT`.

### Comparación

| Operador | Descripción | Alternativa en español     |
|----------|-------------|----------------------------|
| `==`     | Igual       | `es igual a`               |
| `!=`     | Distinto    | -                          |
| `<`      | Menor       | `menor que` / `menor a`    |
| `>`      | Mayor       | `mayor que` / `mayor a`    |
| `<=`     | Menor o igual | -                        |
| `>=`     | Mayor o igual | -                        |

```jasb
x == 10
edad mayor que 18
nombre es igual a "admin"
```

### Lógicos

| Operador | Descripción |
|----------|-------------|
| `y`      | AND lógico  |
| `o`      | OR lógico   |
| `no`     | NOT (también `!`) |

```jasb
activo y conectado
edad >= 18 o es_admin
no terminado
```

### Bits

| Operador | Descripción |
|----------|-------------|
| `<<`     | Desplazamiento izquierda |
| `>>`     | Desplazamiento derecha   |

**Internamente:** `OP_BIT_SHL`, `OP_BIT_SHR`.

### Flotantes: funciones predefinidas (un argumento o dos)

En expresiones se pueden llamar (radianes en trigonometría):

| Función | Descripción |
|---------|-------------|
| `sin(x)`, `cos(x)`, `tan(x)` | Trigonometría |
| `atan2(y, x)` o `arcotangente2(y, x)` | Arcotangente dos argumentos |
| `exp(x)`, `log(x)`, `log10(x)` | Exponencial y logaritmos |

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

## 8. Funciones

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

## 9. Registros (estructuras)

```jasb
registro NombreRegistro
    tipo1 campo1
    tipo2 campo2
    texto nombre
fin_registro
```

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

**Internamente:** `StructDefNode` → se registra en tabla de símbolos. Los campos se asignan a offsets secuenciales. Acceso: `MemberAccessNode` → `OP_LEER`/`OP_ESCRIBIR` con offset calculado.

---

## 10. Entrada y salida

### imprimir

Imprime una expresión y añade salto de línea.

```jasb
imprimir "Hola mundo"
imprimir x
imprimir "Total: " + total
```

**Internamente:** `PrintNode` → `OP_IMPRIMIR_TEXTO`, `OP_IMPRIMIR_NUMERO` o `OP_IMPRIMIR_FLOTANTE` según tipo, más `OP_IMPRIMIR_TEXTO` con `"\n"`.

### imprimir_sin_salto

Igual que `imprimir` pero sin salto de línea al final.

```jasb
imprimir_sin_salto ">> "
ingresar_texto entrada
```

**Internamente:** Igual que imprimir, pero sin emitir el `\n` final. Útil para prompts.

### Colores en la salida

Para dar una experiencia de usuario más cómoda, puedes usar **secuencias de color simples** dentro de las cadenas. Funcionan en terminales que soporten ANSI (Linux, macOS, Windows Terminal, PowerShell 7+).

```jasb
# Sintaxis de 4 letras: \rojo, \verd, \amar, \azul, etc.
imprimir "\rojoError\norm"
imprimir "\verdÉxito\norm"
imprimir "\amarAviso\norm"
imprimir "\azulInfo\norm"
imprimir "\magePúrpura\norm"
imprimir "\cianCian\norm"

# Negrita y restablecer
imprimir "\negrNegrita\norm"
imprimir "\verd\negrVerde y negrita\norm"
```

**Colores (4 letras):**

| Secuencia | Efecto |
|-----------|--------|
| `\rojo` | Rojo |
| `\verd` | Verde |
| `\amar` | Amarillo |
| `\azul` | Azul |
| `\mage` | Magenta/Púrpura |
| `\cian` | Cian |
| `\blan` | Blanco |
| `\negr` | Negrita |
| `\norm` o `\rese` | Restablecer (volver al color por defecto) |

**Avanzado:** También se acepta `\e[31m` para códigos ANSI personalizados.

### ingresar_texto

Lee una línea de stdin y la asigna a una variable.

```jasb
ingresar_texto nombre_usuario
ingresar_texto respuesta
```

**Internamente:** `InputNode` → `OP_IO_INPUT_REG` que lee a un registro; luego se escribe en la variable destino.

---

## 11. Memoria neuronal

La memoria neuronal (JMN) guarda conceptos y asociaciones para razonamiento tipo IA.

### Conceptos personalizados

Define un concepto con propiedades propias y crea instancias en JMN.

```jasb
concepto Persona con nombre texto edad entero ciudad texto fin_concepto

crear_memoria("data/cerebro.jmn")

principal
    crear_concepto Persona "ana" con nombre "Ana" edad 30 ciudad "Madrid"
    
    buscar "ana_nombre"
    imprimir resultado
    
    imprimir_id(propiedad_concepto("ana", "nombre"))
fin_principal
```

| Construcción | Descripción |
|--------------|-------------|
| `concepto Nombre con prop1 tipo1 prop2 tipo2 ... fin_concepto` | Define el esquema del concepto |
| `crear_concepto Tipo "id" con prop1 val1 prop2 val2` | Crea instancia en JMN (claves: `id_prop1`, etc.) |
| `propiedad_concepto(instancia, propiedad)` | Lee el valor de una propiedad (`buscar "instancia_propiedad"`) |

Las propiedades se almacenan como conceptos `instancia_propiedad` en la JMN, accesibles con `buscar` o `propiedad_concepto`. *Nota: Pendiente en jbc (compilador C).*

### recordar

Crea o actualiza un concepto con un valor.

```jasb
recordar "edad" con valor 25
recordar "nombre" con valor "Jas"
recordar clave con valor expresion   # clave y expresion son variables/expresiones
```

**Internamente:** `RecordarNode` → opcodes de memoria (por ejemplo `OP_MEM_RECORDAR_TEXTO` o equivalente según backend).

### buscar

Obtiene el valor de un concepto y lo deja en `resultado`.

```jasb
buscar "edad"
imprimir resultado
```

**Internamente:** Búsqueda en JMN por clave; resultado en R1 o variable implícita `resultado`.

### pensar

Evalúa una expresión y escribe en `resultado`. Usado para razonamiento.

```jasb
pensar entrada_usuario
responder resultado
```

### Refuerzo y penalización por concepto (conexiones)

**Auditoría (jbc + VM):** `aprender(concepto, peso)` / `OP_MEM_APRENDER_PESO_REG` actualiza el **peso del nodo** (valor asociado al ID del concepto), no las aristas entre conceptos. Las **conexiones** (fuerza entre dos IDs) las crea `mem_asociar` / `OP_MEM_ASOCIAR_CONCEPTOS`. Para feedback tipo éxito/fracaso sobre un concepto ya enlazado en el grafo:

| Construcción | Efecto |
|--------------|--------|
| `reforzar(expr [, magnitud])` | Suma **delta** a la fuerza de **todas** las conexiones en las que el ID de `expr` es **origen o destino** (recorrido global de la tabla de conexiones JMN). Fuerza acotada superiormente a **1.0**. |
| `penalizar(expr [, magnitud])` | Resta **delta** en las mismas conexiones; fuerza mínima **0**. |

- **Magnitud:** entero **1–100** opcional; representa centésimas (p. ej. `20` → delta **0.2**). Si se omite, se usa **10** (delta **0.1**). Solo está soportado como **literal entero** en compilación (no una variable en el segundo argumento).
- **Opcodes:** `OP_MEM_REFORZAR_CONCEPTO` (0xA5), `OP_MEM_PENALIZAR_CONCEPTO` (0xA6). Operando **A** = registro con ID del concepto; **C** inmediato = magnitud.
- **Varios argumentos en sentencia:** usar paréntesis, p. ej. `reforzar("alpha", 20)` y `penalizar("alpha", 10)` (la forma sin paréntesis solo encaja bien con un único argumento).

**Par (origen, destino) concreto** (sin tocar el resto de aristas del concepto): sigue existiendo `OP_MEM_PENALIZAR` (0xE3) para penalizar una sola asociación; exponerlo en fuente depende del binding del compilador.

**Inspección:** `mem_obtener_fuerza(id1, id2)` devuelve la fuerza **flotante** de la conexión dirigida origen `id1` → destino `id2` (mismo opcode interno que `tiene_asociacion` para mediciones). Útil en tests y depuración.

**Nota práctica:** en llamadas como `mem_asociar("a", "b", peso)`, si el tercer argumento es **flotante**, conviene pasarlo por una **variable** `flotante` ya asignada; un literal `0.5` en lista de argumentos puede no codificarse como IEEE754 esperado por la VM en todos los contextos.

### Decaimiento y sueño (conexiones)

| Construcción | Efecto |
|--------------|--------|
| `decae_conexiones()` / `decaer_conexiones()` | Aplica un decaimiento global (por defecto factor **5%** y umbral **0.010** en la VM). |
| `consolidar_memoria()` / `dormir()` / `consolidar()` | Ejecuta el ciclo **decaimiento → olvido de débiles → consolidación** (refuerzo multiplicativo fijo del **5%** sobre supervivientes; ver `docs/TECNICO/VM/VM_ESTABLE.md`). |
| `olvidar_debiles()` | Elimina aristas con fuerza por debajo del umbral por defecto (**0.010**); devuelve el **número** de aristas liberadas. |

**Opcodes:** `OP_MEM_DECAE_CONEXIONES` (0xCC), `OP_MEM_CONSOLIDAR_SUENO` (0xA7), `OP_MEM_OLVIDAR_DEBILES` (0xA8).

### Ventana de percepción temporal (flujo)

Buffer circular en la VM con los últimos IDs “percibidos”. **Política:** FIFO con capacidad fija (por defecto 64; rango 8–4096). Cada entrada guarda ID + marca de tiempo (~segundos vía `time`).

| Construcción | Efecto |
|--------------|--------|
| `ventana_percepcion(n)` / `flujo_temporal(n)` | Fija capacidad (literal entero **8–4096**); vacía el buffer. |
| `percepcion(expr)` | Registra explícitamente el ID resultado de `expr`. |
| `percepcion_limpiar()` | Vacía el buffer sin cambiar capacidad. |
| `percepcion_tamano()` | Devuelve cuántas entradas hay. |
| `percepcion_anterior(k)` | ID en posición **k** (0 = más reciente); `k` literal entero o expresión. |
| `percepcion_recientes()` | Devuelve el ID de una **lista** en memoria episódica (orden reciente → antiguo); ver `docs/TECNICO/VM/VM_ESTABLE.md`. |

**Registro automático:** además de `percepcion(...)`, la VM apila IDs tras `buscar`, `buscar_asociados`, `propagar_activacion`, `resolver_conflictos`, aprendizaje/recordar de concepto, `aprender_peso` y `leer_entrada`.

**Opcodes:** `OP_PERCEPCION_REGISTRAR` … `OP_PERCEPCION_LISTA` (0xA9–0xAE).

### Rastro de activación (introspección)

Buffer por **invocación** de propagación / pensar_respuesta / buscar_asociados / resolver_conflictos: orden **cronológico de primer toque** (índice **0** = primero). Capacidad por defecto **128** (rango 16–2048); desbordamiento FIFO.

| Construcción | Efecto |
|--------------|--------|
| `ventana_rastro_activacion(n)` / `rastro_activacion_ventana(n)` | Fija capacidad; vacía el rastro. |
| `rastro_activacion_limpiar()` | Vacía sin cambiar capacidad. |
| `rastro_activacion_tamano()` | Número de entradas. |
| `rastro_activacion_obtener(i)` | ID en índice `i` (literal o expresión). |
| `rastro_activacion_peso(i)` | Bits **float32** de la activación en ese índice (registro entero). |
| `rastro_activacion_lista()` / `rastro_activacion_recientes()` | ID de lista episódica (orden viejo → nuevo); ver `docs/TECNICO/VM/VM_ESTABLE.md`. |
| `propagar_activacion(concepto)` | Propagación BFS en JMN; además rellena el rastro y devuelve el mejor destino por activación. |
| `propagar_activacion_de(concepto, tipo_rel)` | Igual con tipo de relación entero (0–10). |

**Opcodes:** `0xAF`, `0xCF`, `0xB9`, `0xBF`, `0x6D`, `0x6E` (tabla en `RASTRO_ACTIVACION_VM.md`).

### Inferencia ponderada (Fase E)

Elegir un elemento de una **lista** (colecciones RAM) según la **fuerza** en el JMN entre un **contexto** y cada candidato. Ver `docs/TECNICO/VM/VM_ESTABLE.md`.

| Construcción | Efecto |
|--------------|--------|
| `elegir_por_peso(lista, contexto)` | Índice del ganador en la lista (alias: `elegir_por_peso_segun`). |
| `elegir_por_peso_id(lista, contexto)` | ID del concepto ganador. |
| `elegir_por_peso_semilla(u)` / `elegir_por_peso_seed(u)` | Semilla `u32` para desempate (0 = solo score + id + índice). |

**Opcodes:** `0x6F`, `0x70`, `0x71`.

---

## 12. Llamadas de sistema

Las llamadas de sistema son funciones predefinidas. Sintaxis: `nombre(argumentos)` o `nombre argumento` (un solo argumento sin paréntesis).

### Cadenas

| Función | Descripción | Ejemplo |
|---------|-------------|---------|
| `concatenar(s1, s2)` | Concatena textos | `concatenar("Hola", "!")` |
| `longitud_texto(s)` | Longitud de cadena | `longitud_texto(nombre)` |
| `dividir_texto(s, sep)` | Divide por separador | `dividir_texto(linea, " ")` |
| `minusculas(s)` | Minúsculas | `minusculas(texto)` |
| `str_minusculas(s)` | Idem | `str_minusculas(texto)` |
| `str_a_entero(s)` | Convierte a entero | `str_a_entero("42")` |
| `str_a_flotante(s)` | Convierte a flotante | `str_a_flotante("3.14")` |
| `str_desde_numero(n)` | Número a texto | `str_desde_numero(42)` |
| `codigo_caracter(s)` | Código ASCII del primer carácter | `codigo_caracter("A")` → 65 |
| `caracter_a_texto(c)` | Carácter (código) a texto de 1 char | `caracter_a_texto(65)` → "A" |
| `extraer_subtexto(s, i, l)` | Subcadena | `extraer_subtexto(s, 0, 5)` |
| `contiene_texto(s, p)` | ¿Contiene patrón? | `contiene_texto(s, "abc")` |
| `termina_con(s, suf)` | ¿Termina con? | `termina_con(nom, ".jasb")` |

### Listas

| Función | Descripción | Ejemplo |
|---------|-------------|---------|
| `mem_lista_crear()` | Crea lista vacía | `lista = mem_lista_crear()` |
| `mem_lista_agregar(l, e)` | Añade elemento | `mem_lista_agregar(lista, x)` |
| `mem_lista_obtener(l, i)` | Elemento en índice | `mem_lista_obtener(lista, 0)` |
| `mem_lista_tamano(l)` | Cantidad de elementos | `mem_lista_tamano(lista)` |

### Mapas

| Función | Descripción | Ejemplo |
|---------|-------------|---------|
| `mapa_crear()` | Crea mapa vacío | `mapa_crear()` |
| `mapa_poner(m, k, v)` | Inserta clave-valor | `mapa_poner(m, "a", 1)` |
| `mapa_obtener(m, k)` | Obtiene valor | `mapa_obtener(m, "a")` |

### Archivos

| Función | Descripción | Ejemplo |
|---------|-------------|---------|
| `fs_abrir(ruta, modo)` | Abre archivo | `fs_abrir("datos.txt", "r")` |
| `fs_cerrar(handle)` | Cierra archivo | `fs_cerrar(archivo)` |
| `fs_leer_linea(handle)` | Lee línea | `fs_leer_linea(archivo)` |
| `fs_escribir(handle, datos)` | Escribe | `fs_escribir(archivo, texto)` |
| `fs_leer_texto(handle)` | Lee todo el archivo | `fs_leer_texto(archivo)` |
| `fs_fin_archivo(handle)` | ¿Fin de archivo? | `fs_fin_archivo(archivo)` |
| `fs_existe(ruta)` | ¿Existe archivo? | `fs_existe("datos.txt")` |
| `fs_listar(patron)` | Lista archivos | `fs_listar("*.jasb")` |

### Sistema

| Función | Descripción | Ejemplo |
|---------|-------------|---------|
| `obtener_timestamp()` | Timestamp actual | `obtener_timestamp()` |
| `sys_argc` | Argumentos de programa | `sys_argc` |
| `sys_argv(i)` | Argumento i | `sys_argv(0)` |
| `sistema_ejecutar(cmd)` | Ejecuta comando | `sistema_ejecutar("ls")` |
| `finalizar()` | Termina programa | `finalizar()` |

### Vectores (`vec2`, `vec3`, `vec4`)

Operaciones reconocidas por **jbc** (los argumentos de vector suelen ser **variables**, no expresiones arbitrarias; ver `codegen.c`):

| Función | Descripción |
|---------|-------------|
| `vec2_longitud(v)` / `vec3_longitud` / `vec4_longitud` | Norma euclídea |
| `vec2_normalizar(dest, src)` / `vec3_` / `vec4_` | Normaliza en `dest` |
| `vec2_dot(a, b)` / `vec3_dot` / `vec4_dot` | Producto escalar |
| `vec3_cross(dest, a, b)` | Producto vectorial |

*Nota:* Nombres como `vec2_sumar` pueden figurar en listas de soporte futuro; si no aparecen en `visit_call_sistema`, no están soportados aún.

### Trigonometría y exponencial

Misma lista que en **§6 Operadores → Flotantes: funciones predefinidas**: `sin`, `cos`, `tan`, `atan2` / `arcotangente2`, `exp`, `log`, `log10`.

### Matrices (`mat3`, `mat4`)

| Función | Descripción |
|---------|-------------|
| `mat4_mul_vec4(dest, mat, vec)` | `dest` = mat × vec (homogéneo) |
| `mat4_mul(dest, izq, der)` | Multiplicación 4×4 |
| `mat4_identidad(dest)` | Matriz identidad |
| `mat4_transpuesta(dest, src)` | Transpuesta |
| `mat4_inversa(dest, src)` | Inversa |
| `mat3_mul_vec3(dest, mat, vec)` | mat × vec 3D |
| `mat3_mul(dest, izq, der)` | Multiplicación 3×3 |

### FFI (bibliotecas dinámicas) y heap

Llamar código en DLL/SO (convención de registros y límites: [FFI_CONVENCION_LLAMADA.md](../TECNICO/SDK/FFI_CONVENCION_LLAMADA.md)):

| Función | Descripción |
|---------|-------------|
| `ffi_cargar("ruta.dll")` | Carga biblioteca; devuelve handle (hoy suele exigirse **literal** de texto en ruta) |
| `ffi_simbolo(handle, "nombre")` | Resuelve función (segundo argumento suele ser literal) |
| `ffi_llamar(puntero_fn, arg0, …)` | Hasta **4** argumentos; retorno **entero** o puntero (64 bit); flotante como extensión futura |

Memoria dinámica de la VM:

| Función | Descripción |
|---------|-------------|
| `reservar(bytes)` | Reserva; devuelve entero/puntero usable con el heap de la VM |
| `liberar(ptr)` | Libera lo reservado con `reservar` |

### Memoria neuronal (JMN)

| Función | Descripción |
|---------|-------------|
| `mem_crear(ruta)` | Crea o abre memoria neuronal |
| `mem_cerrar()` | Cierra memoria neuronal |
| `mem_asociar(id1, id2, peso)` | Asocia conceptos |
| `tiene_asociacion(id1, id2)` | Fuerza de asociación (también usable como comprobación) |
| `mem_obtener_fuerza(id1, id2)` | Igual: fuerza flotante de la arista id1 → id2 |
| `reforzar(concepto [, magnitud])` | Refuerza todas las conexiones incidentes al concepto (ver §11) |
| `penalizar(concepto [, magnitud])` | Penaliza todas las conexiones incidentes al concepto (ver §11) |
| `decae_conexiones()` / `decaer_conexiones()` | Decaimiento global de fuerzas (ver §11) |
| `consolidar_memoria()` / `dormir()` / `consolidar()` | Ciclo sueño: decaer, olvidar débiles, consolidar supervivientes |
| `olvidar_debiles()` | Elimina aristas por debajo del umbral; devuelve cantidad eliminada |
| `ventana_percepcion(n)` / `flujo_temporal(n)` | Capacidad del buffer de percepción temporal |
| `percepcion(expr)` | Registro explícito de un ID en la ventana |
| `percepcion_limpiar()` / `percepcion_tamano()` / `percepcion_anterior(k)` / `percepcion_recientes()` | Consulta y control (ver §11) |
| `ventana_rastro_activacion(n)` / `rastro_activacion_*` | Rastro de nodos tocados por propagación / pensar_respuesta / asociados / conflictos (ver §11) |
| `propagar_activacion(concepto)` / `propagar_activacion_de(c, tipo)` | Propagación BFS + rastro (ver §11) |
| `elegir_por_peso(lista, ctx)` / `elegir_por_peso_id(...)` / `elegir_por_peso_semilla(u)` | Inferencia por peso JMN (ver §11) |
| `obtener_todos_conceptos()` | Lista todos los conceptos |
| `obtener_relacionados(id)` | Conceptos relacionados |
| `propiedad_concepto(inst, prop)` | Valor de propiedad en concepto personalizado |
| `imprimir_id(id)` | Imprime concepto por ID |
| `imprimir_flotante(x)` | Imprime flotante |

### Otras

| Función | Descripción |
|---------|-------------|
| `bit_shl(a, b)` | Desplazamiento izquierda |
| `bit_shr(a, b)` | Desplazamiento derecha |

**Internamente:** Cada llamada se traduce a uno o varios opcodes IR. Los argumentos se evalúan en registros R1, R2, R3, etc., y el resultado suele quedar en R1.

### Identificadores `n_*` (grafo de conocimiento)

En `sistema_llamadas.c` aparecen nombres como `n_abrir_grafo`, `n_recordar`, `n_heredar`, etc., para que el **parser** los acepte como llamadas. La **generación de código** en `codegen.c` puede no cubrirlos todos: compruebe ahí antes de usarlos en un programa `.jasb` serio.

---

## 13. Módulos y bibliotecas

### activar_modulo / usar

Carga un módulo Jasboot.

```jasb
activar_modulo "modulos/mi_modulo.jasb"
usar "std/pln.jasb"
```

**Internamente:** `ActivarModuloNode` → `OP_ACTIVAR_MODULO`. El path se resuelve respecto al directorio del fuente.

### biblioteca

Declara dependencia de una biblioteca externa.

```jasb
biblioteca "ruta/biblioteca"
```

### crear_memoria / cerrar_memoria

Gestiona la memoria neuronal persistente.

```jasb
crear_memoria("cerebro.jmn", 1000, 5000)
# ... uso ...
cerrar_memoria()
```

---

## Resumen de opcodes principales

| Categoría | Opcodes |
|-----------|---------|
| Datos | `OP_MOVER`, `OP_LEER`, `OP_ESCRIBIR`, `OP_LOAD_STR_HASH` |
| Aritmética | `OP_SUMAR`, `OP_RESTAR`, `OP_MULTIPLICAR`, `OP_DIVIDIR`, `OP_MODULO` |
| Comparación | `OP_CMP_EQ`, `OP_CMP_LT`, `OP_CMP_GT`, etc. |
| Lógica | `OP_Y`, `OP_O`, `OP_NO` |
| Control | `OP_IR`, `OP_SI`, `OP_LLAMAR`, `OP_RETORNAR` |
| I/O | `OP_IMPRIMIR_TEXTO`, `OP_IMPRIMIR_NUMERO`, `OP_IO_INPUT_REG` |
| Colecciones | `OP_MEM_LISTA_*`, `OP_MEM_MAPA_*` |
| Archivos | `OP_FS_ABRIR`, `OP_FS_LEER_LINEA`, `OP_FS_ESCRIBIR`, etc. |
| Heap | `OP_HEAP_RESERVAR`, `OP_HEAP_LIBERAR` |
| FFI | `OP_CARGAR_BIBLIOTECA`, `OP_FFI_OBTENER_SIMBOLO`, `OP_FFI_LLAMAR` |
| Trig / exp | `OP_SIN`, `OP_COS`, `OP_TAN`, `OP_ATAN2`, `OP_EXP`, `OP_LOG`, `OP_LOG10` |
| Matrices | `OP_MAT4_MUL_VEC4`, `OP_MAT4_MUL`, `OP_MAT3_MUL_VEC3`, `OP_MAT3_MUL`, etc. |
| Memoria neuronal | `OP_MEM_CREAR`, `OP_MEM_ASOCIAR_CONCEPTOS`, `OP_MEM_APRENDER_PESO_REG`, etc. |
| Refuerzo / penalización global | `OP_MEM_REFORZAR_CONCEPTO` (0xA5), `OP_MEM_PENALIZAR_CONCEPTO` (0xA6) |

---

**Última actualización:** 2026-03-24
