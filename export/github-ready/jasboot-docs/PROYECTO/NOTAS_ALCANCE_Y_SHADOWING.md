# Alcance de Variables (Scope) y Ensombrecimiento (Shadowing) en Jasboot

Este documento explica formalmente cómo Jasboot maneja la visibilidad de las variables a través de diferentes niveles de bloques de código (como `principal`, `si`, `mientras`, y `funcion`).

## 1. Alcance Léxico (Lexical Scoping)
Jasboot utiliza **alcance léxico basado en bloques**. Esto significa que cuando se declara una variable, su "vida útil" (visibilidad y existencia en memoria) está estrictamente limitada al bloque en el que fue creada y a los sub-bloques anidados dentro de él.

Un bloque se define típicamente por las palabras clave de apertura y cierre, por ejemplo:
* `principal` ... `fin_principal`
* `si ... entonces` ... `fin_si`
* `mientras ... hacer` ... `fin_mientras`

### Regla principal de visibilidad:
Una variable declarada en un bloque exterior **es visible y modificable** en los bloques interiores. Sin embargo, una variable declarada en un bloque interior **es destruida y deja de existir** una vez que se alcanza el fin de ese bloque (`fin_si`, `fin_mientras`, etc.), siendo invisible para el exterior.

## 2. Ensombrecimiento (Shadowing)
El comportamiento conocido como *Shadowing* ocurre cuando declaras una variable nueva en un bloque interno que tiene **exactamente el mismo nombre** que una variable de un bloque externo.

Jasboot **permite el shadowing**.

**¿Qué sucede internamente?**
1. La variable exterior sigue existiendo en memoria, pero queda temporalmente "oculta" o inaccesible desde el bloque interno.
2. Cualquier referencia a ese nombre dentro del bloque interno interactuará **únicamente** con la nueva variable local.
3. Cuando el bloque interno termina, la variable local interna es destruida y la variable exterior vuelve a ser la que responde a ese nombre, conservando el valor que tenía antes de entrar al bloque interno.

### Ejemplo de Shadowing (Resultado: 10, 20, 10)
```jasboot
principal
    entero num = 10
    imprimir num      # Imprime 10 (la variable exterior)
    
    si verdadero entonces
        entero num = 20 # Se crea una NUEVA variable "num" para este sub-bloque
        imprimir num    # Imprime 20 (la variable interior ensombrece a la exterior)
    fin_si
    # Aqui la "num" interior se destruye
    
    imprimir num      # Imprime 10 (la exterior vuelve a la luz intacta)
fin_principal
```

## 3. Restricciones del Lenguaje (Errores de Compilación)
Para mantener la cordura del código, el compilador aplica las siguientes reglas estrictas:

* **Doble Declaración Ilegal:** NO puedes declarar dos variables con el mismo nombre dentro del **mismo** bloque de alcance. El compilador lanzará un error: `Error: variable 'X' ya declarada en este alcance`.
* **Fuera de Alcance (Out of Scope):** NO puedes intentar usar o leer una variable desde el exterior si esta fue declarada en un bloque interno. El compilador lanzará el error: `Error: variable 'X' no declarada antes de su uso`.
