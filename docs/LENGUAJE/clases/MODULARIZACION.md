# Modularización Compleja con Clases

Para sistemas de gran escala (como Aurora IA o Neurixis), Jasboot permite una modularización avanzada separando interfaces de implementación y encapsulando lógica en capas.

## Patrón de Arquitectura Recomendado

Un sistema modular complejo suele dividirse en:

1. **Modelos**: Clases que solo contienen datos.
2. **Servicios/Motores**: Clases que contienen la lógica pesada.
3. **Controladores**: Coordinan la interacción entre el usuario y los servicios.

### Ejemplo: Sistema de Procesamiento de Lenguaje (NLP)

**Archivo: `modelos_nlp.jasb`**

```jasb
clase Token
    texto valor
    texto tipo # sustantivo, verbo, etc.
    flotante confianza
fin_clase

clase AnalisisResultado
    lista<Token> tokens
    texto intencion_detectada
fin_clase
```

**Archivo: `motor_nlp.jasb`**

```jasb
usar ".\\modelos_nlp.jasb"

clase MotorNLP
    texto idioma_base

    funcion inicializar(texto idioma) retorna
        este.idioma_base = idioma
        imprimir "Motor NLP iniciado en " + este.idioma_base
    fin_funcion

    funcion analizar(texto frase) retorna AnalisisResultado
        # Lógica compleja de procesamiento...
        AnalisisResultado res
        res.intencion_detectada = "saludo"
        retornar res
    fin_funcion
fin_clase
```

## Modularización con Inyección de Dependencias

Puedes pasar instancias de clases como parámetros a otros métodos para desacoplar el código.

```jasb
clase OrquestadorIA
    MotorNLP motor

    funcion configurar(MotorNLP nlp) retorna
        este.motor = nlp
    fin_funcion

    funcion ejecutar_comando(texto comando) retorna
        AnalisisResultado ar = este.motor.analizar(comando)
        imprimir "Ejecutando accion para: " + ar.intencion_detectada
    fin_funcion
fin_clase
```

## Encapsulamiento y Visibilidad

Jasboot soporta la palabra clave `privado` para restringir el acceso a campos y métodos desde fuera de la clase.

```jasb
clase CuentaBancaria
    privado flotante saldo

    funcion depositar(flotante monto) retorna
        este.saldo = este.saldo + monto
    fin_funcion

    funcion obtener_saldo() retorna flotante
        retornar este.saldo
    fin_funcion
fin_clase
```

## Lo que NO se puede hacer (Limitaciones actuales)

1. **Clases anidadas**: No se pueden definir clases dentro de otras clases.
2. **Métodos Estáticos**: Todos los métodos requieren una instancia y el uso de `este`.
3. **Constructores Explícitos**: La inicialización se realiza directamente sobre los campos de la instancia.

---

[Volver al Índice de JMN](../jmn/INTRODUCCION.md) | [Volver al Índice General](../REFERENCIA_LENGUAJE_JASBOOT.md)
