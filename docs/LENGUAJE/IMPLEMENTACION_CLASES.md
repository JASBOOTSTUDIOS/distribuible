# Implementación de Clases en Jasboot

Este documento describe la arquitectura, sintaxis y reglas de la implementación de clases en el lenguaje Jasboot.

## 1. Conceptos Fundamentales

Las clases en Jasboot son una extensión de los `registros` que añaden soporte para:
1.  **Herencia Simple:** Una clase puede extender a otra clase base.
2.  **Métodos Nativos:** Funciones definidas dentro del cuerpo de la clase que operan sobre la instancia.
3.  **Polimorfismo:** Capacidad de sobrescribir métodos en clases derivadas.

## 2. Sintaxis

### Definición de Clase

```jasb
clase Persona
    texto nombre
    entero edad
    
    funcion saludar() retorna
        imprimir "Hola, soy " + este.nombre
    fin_funcion
fin_clase
```

### Herencia (`extiende`)

```jasb
clase Empleado extiende Persona
    entero salario
    
    funcion saludar() retorna
        imprimir "Hola, soy el empleado " + este.nombre
    fin_funcion
fin_clase
```

*   **Palabra clave `este`**: Dentro de un método, `este` referencia a la instancia actual de la clase. Es equivalente a `this` o `self`.

## 3. Detalles de Implementación (Compilador)

La implementación se encuentra principalmente en los siguientes archivos del compilador C (`jbc`):

- **[nodes.h](file:///c:/src/jasboot/sdk-dependiente/jas-compiler-c/include/nodes.h):** Define `StructDefNode` que contiene los campos (`field_types`, `field_names`), el nombre de la clase base (`extends_name`) y los métodos (`methods`).
- **[parser.c](file:///c:/src/jasboot/sdk-dependiente/jas-compiler-c/src/parser.c):** La función `parse_struct_body` maneja la lectura de campos y métodos. Automáticamente inyecta un parámetro implícito `este` del tipo de la clase a cada método definido.
- **[resolve.c](file:///c:/src/jasboot/sdk-dependiente/jas-compiler-c/src/resolve.c):** Valida la jerarquía de herencia, detecta colisiones de campos y resuelve los tipos de los métodos.
- **[codegen.c](file:///c:/src/jasboot/sdk-dependiente/jas-compiler-c/src/codegen.c):** Emite el bytecode necesario. Los métodos se compilan como funciones globales con un prefijo interno o una entrada en la tabla de métodos para permitir el despacho dinámico.

## 4. Errores Comunes y Límites

El compilador Jasboot realiza las siguientes validaciones:

1.  **Cierre incorrecto:** Una `clase` debe cerrarse con `fin_clase`. Usar `fin_registro` causará un error.
2.  **Colisión de campos:** Una clase derivada no puede definir un campo con el mismo nombre que uno de su clase base.
3.  **Orden de declaración:** La clase base debe estar definida **antes** que la clase derivada en el código fuente.
4.  **Herencia Circular:** No se permite que A extienda B y B extienda A.
5.  **Herencia Múltiple:** Jasboot solo soporta herencia simple (una sola clase base).
6.  **Funciones Anidadas:** No se pueden definir funciones normales (bloques `funcion ... fin_funcion`) dentro de una clase si no son métodos (deben ser campos de tipo `funcion` o métodos nativos).

## 5. Alcances y Limitaciones (V1.0)

- **Visibilidad:** Actualmente todos los campos y métodos son públicos. No existen palabras clave `privado` o `protegido` en esta versión.
- **Constructores:** No hay constructores nativos. La inicialización de campos se realiza manualmente tras crear la instancia.
- **Despacho Dinámico:** El polimorfismo nativo se resuelve en tiempo de ejecución mediante una búsqueda en la jerarquía de la clase si el método está sobrescrito.
- **Compatibilidad con Registros:** Los `registros` también pueden usar `extiende`, pero no pueden definir métodos nativos (solo campos de tipo `funcion`).
