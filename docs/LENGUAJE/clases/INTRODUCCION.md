# Programación Orientada a Objetos en Jasboot

Jasboot implementa un sistema de clases moderno, basado en el concepto de **registros** pero con capacidades extendidas de herencia, métodos y polimorfismo.

## ¿Qué es una Clase?

Una clase es un "plano" o plantilla para crear objetos. Permite agrupar **datos** (campos) y **comportamiento** (funciones/métodos) en una sola unidad lógica.

## Estructura Básica

```jasb
clase Vehiculo
    texto marca
    texto modelo
    entero anio
    
    # Método de la clase
    funcion describir() retorna
        imprimir "Vehiculo: " + este.marca + " " + este.modelo
    fin_funcion
fin_clase
```

### La palabra clave `este`
Dentro de cualquier función de clase, se usa `este` para referirse a la instancia actual del objeto. Es equivalente a `self` en Python o `this` en Java/C++.

## Instanciación y Uso

```jasb
principal
    Vehiculo mi_auto
    mi_auto.marca = "Toyota"
    mi_auto.modelo = "Corolla"
    
    # Llamada al método
    mi_auto.describir()
fin_principal
```

---
Siguiente: [Herencia y Polimorfismo](HERENCIA.md)
