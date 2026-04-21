# Conceptos en Jasboot

Documento de referencia sobre el sistema de **conceptos** y la **memoria neuronal (JMN)** en el lenguaje Jasboot. Los conceptos son la unidad fundamental de almacenamiento y razonamiento en el paradigma de pensamiento humano.

---

## Índice

1. [¿Qué es un concepto?](#1-qué-es-un-concepto)
2. [Memoria neuronal (JMN)](#2-memoria-neuronal-jmn)
3. [Operaciones básicas: crear, leer, actualizar, olvidar](#3-operaciones-básicas-crear-leer-actualizar-olvidar)
4. [Conceptos personalizados (con esquema)](#4-conceptos-personalizados-con-esquema)
5. [Asociaciones y pesos](#5-asociaciones-y-pesos)
6. [Tipo de dato `concepto` y literales](#6-tipo-de-dato-concepto-y-literales)
7. [Variable implícita `resultado`](#7-variable-implícita-resultado)
8. [Errores relacionados con conceptos](#8-errores-relacionados-con-conceptos)
9. [Ejemplos prácticos](#9-ejemplos-prácticos)

---

## 1. ¿Qué es un concepto?

Un **concepto** es una unidad de conocimiento almacenada en la memoria neuronal (JMN). Cada concepto tiene:

- **Nombre o clave:** Identificador textual que lo distingue (p. ej. `"edad"`, `"capital"`, `"perro"`).
- **Valor asociado:** El dato vinculado al concepto (texto, número, etc.).
- **ID interno (opcional):** Algunas implementaciones usan un hash o identificador numérico para referenciar conceptos de forma eficiente.

En el paradigma de **pensamiento humano**, los conceptos sustituyen en parte la noción tradicional de "variables": en lugar de guardar datos solo en memoria de ejecución, se almacenan en un grafo de conocimiento persistente que permite asociaciones, razonamiento y aprendizaje.

### Características principales

- **Persistencia:** Los conceptos se guardan en un archivo JMN (p. ej. `cerebro.jmn`) y pueden sobrevivir entre ejecuciones del programa.
- **Asociaciones:** Los conceptos pueden estar conectados entre sí con pesos (fuerza del enlace), formando un grafo de conocimiento.
- **Acceso por nombre:** Se consultan y modifican por su clave textual, lo que facilita un estilo de programación declarativo y basado en significado.

---

## 2. Memoria neuronal (JMN)

La **JMN** (memoria neuronal) es el almacén donde residen los conceptos y sus asociaciones. Antes de usar conceptos, debes **abrir** una memoria; al terminar, debes **cerrarla** para que los cambios se guarden correctamente.

### Abrir y cerrar memoria

```jasb
crear_memoria("data/cerebro.jmn")   # Abre o crea el archivo JMN

principal
    # Aquí puedes usar recordar, buscar, etc.
    cerrar_memoria()                 # Cierra y persiste cambios
fin_principal
```

| Función | Descripción |
|---------|-------------|
| `crear_memoria("ruta.jmn")` | Abre o crea el archivo de memoria neuronal. Parámetros adicionales (capacidad, etc.) según implementación. |
| `cerrar_memoria()` | Cierra la memoria, libera recursos y guarda los cambios en disco. |

**Importante:** Sin `crear_memoria` previo, las operaciones `recordar`, `buscar` y otras sobre conceptos fallarán con error `MEMORIA_NO_ABIERTA`.

---

## 3. Operaciones básicas: crear, leer, actualizar, olvidar

### 3.1 Crear o actualizar: `recordar`

Crea un concepto o actualiza su valor si ya existe. Es idempotente por nombre: no importa si el concepto existía o no.

```jasb
recordar "nombre" con valor expresion
recordar clave con valor valor    # clave y valor pueden ser variables
```

**Ejemplos:**

```jasb
recordar "edad" con valor 25
recordar "capital" con valor "Madrid"
recordar "activo" con valor verdadero
recordar pregunta con valor respuesta   # variables
```

### 3.2 Leer: `buscar`

Obtiene el valor de un concepto por su nombre. El resultado se almacena en la variable implícita `resultado`.

```jasb
buscar "nombre"
# resultado contiene el valor del concepto
imprimir_id(resultado)
```

**Comportamiento si no existe:** Depende del runtime (puede devolver 0, nulo, valor por defecto o provocar error `CONCEPTO_INEXISTENTE`). Consulta la documentación de tu implementación.

### 3.3 Actualizar

No hay operación separada. **Actualizar = recordar de nuevo.** Si el concepto existe, `recordar` sobrescribe su valor.

```jasb
recordar "contador" con valor 0
# ... más tarde ...
recordar "contador" con valor 1   # Actualiza el valor
```

### 3.4 Olvidar (debilitar): `olvidar`

Reduce el peso o la presencia del concepto. No garantiza borrado físico inmediato; es una operación de penalización sobre el grafo neuronal.

```jasb
olvidar expresion    # expresión debe evaluar al ID del concepto
```

**Nota:** `olvidar` actúa sobre el ID interno del concepto, no sobre el nombre. Para olvidar por nombre, normalmente necesitas primero `buscar` para obtener el ID y luego pasar ese valor a `olvidar`.

### Resumen operativo

| Operación | Construcción | Efecto |
|-----------|--------------|--------|
| Crear | `recordar "nombre" con valor expr` | Crea o refuerza el concepto |
| Leer | `buscar "nombre"` | Valor → `resultado` |
| Actualizar | `recordar "nombre" con valor expr` | Mismo que crear (idempotente) |
| Olvidar | `olvidar expr` | Debilita/penaliza el concepto por ID |

---

## 4. Conceptos personalizados (con esquema)

Puedes definir **tipos de concepto** con propiedades propias, similares a estructuras o clases. Cada instancia es un concepto con varias propiedades almacenadas como conceptos derivados.

### Definir el esquema: `concepto` … `fin_concepto`

```jasb
concepto Persona con nombre texto edad entero ciudad texto fin_concepto
```

Esto define un tipo `Persona` con tres propiedades: `nombre`, `edad`, `ciudad`.

### Crear instancia: `crear_concepto`

```jasb
crear_concepto Persona "ana" con nombre "Ana" edad 30 ciudad "Madrid"
```

Crea una instancia del concepto `Persona` con ID `"ana"`. Las propiedades se almacenan internamente como conceptos con claves como `ana_nombre`, `ana_edad`, `ana_ciudad`.

### Leer propiedad: `propiedad_concepto`

```jasb
propiedad_concepto("ana", "nombre")   # Devuelve "Ana"
propiedad_concepto("ana", "edad")     # Devuelve 30
```

Alternativamente, puedes usar `buscar "ana_nombre"` para acceder a la propiedad.

### Estado de implementación

*Nota: Los conceptos personalizados pueden estar pendientes o parcialmente implementados en el compilador C (jbc). Verifica la documentación de tu versión.*

---

## 5. Asociaciones y pesos

Los conceptos no solo guardan valores; pueden estar **asociados** entre sí con un **peso** que indica la fuerza del enlace. Esto permite razonamiento por similitud, grafos de conocimiento y aprendizaje.

### Funciones relacionadas

| Función | Descripción |
|---------|-------------|
| `mem_asociar(id1, id2, peso)` | Crea o refuerza una asociación entre dos conceptos con un peso |
| `tiene_asociacion(id1, id2)` | Comprueba si existe una asociación entre dos conceptos |
| `aprender "nombre" con valor expr` | Similar a `recordar`, pero refuerza el concepto con un peso |
| `aprender_peso(concepto, peso)` | Ajusta el peso de un concepto (refuerzo o penalización) |
| `obtener_relacionados(id)` | Obtiene los conceptos relacionados con uno dado |
| `obtener_todos_conceptos()` | Lista todos los conceptos en la memoria |

El paradigma de pensamiento humano usa estas asociaciones para simular razonamiento: conceptos que aparecen juntos o en contextos similares refuerzan sus enlaces; los que se usan poco se debilitan con el tiempo.

---

## 6. Tipo de dato `concepto` y literales

### Tipo `concepto`

En la tabla de tipos de Jasboot, existe el tipo `concepto`, que representa un **ID de concepto** en la memoria neuronal (un identificador interno, no el valor).

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `concepto` | ID de concepto en JMN | `'hola'` |

### Literales de concepto

Los literales de concepto usan **comillas simples**:

```jasb
'nombre_concepto'     # ID del concepto con ese nombre
```

Este valor se usa cuando necesitas pasar o almacenar la referencia a un concepto (por ejemplo, en `olvidar` o en funciones que trabajan con IDs).

---

## 7. Variable implícita `resultado`

Tras ciertas operaciones, el valor queda disponible en la variable implícita **`resultado`**:

| Operación | Qué deja en `resultado` |
|-----------|-------------------------|
| `buscar "nombre"` | El valor (o ID) del concepto |
| `pensar expresion` | El valor de la expresión evaluada |
| Retorno de función | El valor devuelto por la función |

**Uso típico:**

```jasb
buscar "capital"
imprimir_id(resultado)

pensar 2 + 3
imprimir_id(resultado)
```

`resultado` no se declara; está siempre disponible y se sobrescribe en cada operación que lo use.

---

## 8. Errores relacionados con conceptos

Según el catálogo de errores del lenguaje:

| Id. | Descripción | Mensaje recomendado |
|-----|-------------|---------------------|
| `CONCEPTO_INEXISTENTE` | `buscar "nombre"` y el concepto no existe | `Concepto inexistente: no se encontró "<nombre>" en la memoria.` |
| `MEMORIA_NO_ABIERTA` | Operación sobre conceptos sin `crear_memoria` previo | `Memoria neuronal no abierta: no se puede leer ni escribir conceptos.` |
| `MEMORIA_NO_PUDO_CREAR` | Fallo al crear o cargar el archivo JMN | `No se pudo crear o cargar la memoria: <detalle>.` |

---

## 9. Ejemplos prácticos

### Ejemplo 1: Almacenamiento simple

```jasb
crear_memoria("data/cerebro.jmn")

principal
    recordar "saludo" con valor "Hola"
    recordar "despedida" con valor "Adiós"
    buscar "saludo"
    imprimir_id(resultado)
    cerrar_memoria()
fin_principal
```

### Ejemplo 2: Pregunta-respuesta (IA)

```jasb
crear_memoria("data/cerebro.jmn")

principal
    recordar "que es jasboot" con valor "Un lenguaje de programacion en espanol"
    ingresar_texto pregunta
    buscar pregunta
    imprimir_id(resultado)
    cerrar_memoria()
fin_principal
```

### Ejemplo 3: Aprendizaje por asociación

```jasb
crear_memoria("data/cerebro.jmn")

principal
    # Registrar asociación principal
    recordar "capital de espana" con valor "Madrid"
    # Asociar palabras relacionadas
    recordar "madrid" con valor "capital"
    recordar "espana" con valor "Madrid"
    buscar "capital de espana"
    imprimir_id(resultado)
    cerrar_memoria()
fin_principal
```

### Ejemplo 4: Conceptos personalizados (si está implementado)

```jasb
concepto Persona con nombre texto edad entero ciudad texto fin_concepto

crear_memoria("data/cerebro.jmn")

principal
    crear_concepto Persona "ana" con nombre "Ana" edad 30 ciudad "Madrid"
    buscar "ana_nombre"
    imprimir resultado
    imprimir_id(propiedad_concepto("ana", "nombre"))
    cerrar_memoria()
fin_principal
```

---

## Referencias

- **Referencia del lenguaje:** `REFERENCIA_LENGUAJE_JASBOOT.md` (sección 11: Memoria neuronal)
- **Contrato de runtime:** `CONTRATO_RUNTIME_V1.0.md` (operaciones sobre conceptos)
- **Catálogo de errores:** `CATALOGO_ERRORES_V1.0.md` (errores de concepto y memoria)
- **Ejemplos por instrucción:** `ejemplos/recordar.md`, `ejemplos/buscar.md`, etc.

---

**Última actualización:** 2026-02-18
