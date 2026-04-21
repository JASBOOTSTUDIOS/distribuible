# Herencia y Polimorfismo

Jasboot permite que una clase herede propiedades y métodos de otras clases, facilitando la reutilización de código y la creación de jerarquías complejas.

## Herencia con `extiende`

Se usa la palabra clave `extiende` para indicar que una clase deriva de otra u otras.

```jasb
clase Animal
    texto nombre

    funcion emitir_sonido() retorna
        imprimir este.nombre + " hace un sonido genérico."
    fin_funcion
fin_clase

# Perro hereda de Animal
clase Perro extiende Animal
    texto raza

    # Sobrescritura de método (Polimorfismo)
    funcion emitir_sonido() retorna
        imprimir este.nombre + " (Raza: " + este.raza + ") dice: ¡Guau!"
    fin_funcion
fin_clase
```

## Herencia Múltiple

Jasboot soporta herencia múltiple, lo que permite que una clase combine funcionalidades de varias clases base separándolas por comas.

```jasb
clase Volador
    texto tipo_vuelo
    funcion volar() retorna
        imprimir "Volando con: " + este.tipo_vuelo
    fin_funcion
fin_clase

clase Nadador
    texto estilo_nado
    funcion nadar() retorna
        imprimir "Nadando como: " + este.estilo_nado
    fin_funcion
fin_clase

clase Pato extiende Volador, Nadador
    texto nombre
fin_clase
```

## Polimorfismo

El polimorfismo en Jasboot permite que una clase hija redefina el comportamiento de un método de sus clases padre. Cuando se llama al método desde una instancia de la clase hija, se ejecutará la versión sobrescrita.

```jasb
principal
    Animal generico
    generico.nombre = "Cosa"

    Perro firulais
    firulais.nombre = "Firulais"
    firulais.raza = "Labrador"

    generico.emitir_sonido() # Salida: Cosa hace un sonido genérico.
    firulais.emitir_sonido() # Salida: Firulais (Raza: Labrador) dice: ¡Guau!
fin_principal
```

## Acceso a la clase base con `padre`

Dentro de un método, se puede usar la palabra clave `padre` para referirse a la implementación de la primera clase base listada en `extiende`.

## Reglas de Herencia

1. **Herencia Múltiple**: Se pueden heredar múltiples clases separándolas por comas.
2. **Acceso a Campos**: La clase hija tiene acceso a todos los campos definidos en todas sus clases padre.
3. **Resolución de Conflictos**: Si dos clases padre tienen un método con el mismo nombre, la clase hija heredará la implementación de la última clase base que lo defina (o deberá sobrescribirlo para evitar ambigüedad).
4. **Herencia entre Archivos**: Es posible heredar de clases definidas en otros archivos usando la instrucción `usar`.
5. **Constructores Implícitos**: La inicialización de campos se realiza directamente sobre la instancia después de su creación.

---

Siguiente: [Modularización y Arquitectura](MODULARIZACION.md)
