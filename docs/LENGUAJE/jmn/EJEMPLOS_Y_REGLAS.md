# Ejemplos y Reglas de Oro de la JMN

Para sacar el máximo provecho a la JMN y evitar errores de la Máquina Virtual, sigue estas directrices.

## Ejemplo: Manejo Robusto con Excepciones

Es vital manejar las operaciones de JMN dentro de bloques `intentar/atrapar`, especialmente al abrir archivos.

```jasb
principal
    intentar
        # Apertura dinámica
        crear_memoria("aurora_core.jmn")
        
        # Aprendizaje
        recordar "estado" con valor "operativa"
        asociar_relacion("inicio", "configuracion", "secuencia", 1.0)
        
        # Verificación
        buscar "estado"
        imprimir "Aurora está " + resultado
        
    atrapar error
        imprimir "Fallo en el núcleo neuronal: " + error
    fin_intentar
    
    cerrar_memoria()
fin_principal
```

## Reglas: Lo que SE PUEDE hacer

1. **Apertura Dinámica**: Puedes abrir memorias dentro de funciones. La VM ya no bloquea el retorno de funciones si la memoria está abierta.
2. **Cambio Caliente**: Puedes llamar a `crear_memoria()` varias veces. La VM guardará automáticamente la memoria actual antes de pasar a la siguiente.
3. **Persistencia de Tipos**: Puedes usar nombres de texto para los tipos de relación (`"secuencia"`, `"similitud"`) y la VM los entenderá.

## Reglas: Lo que NO SE DEBE hacer (Limitaciones)

1. **Claves Vacías**: No intentes `recordar` o `buscar` una cadena vacía `""`. Esto puede causar comportamientos inesperados en el grafo.
2. **Olvidar Consolidar**: Si el programa se cierra abruptamente (crash del sistema), los datos no consolidados podrían perderse. Usa `consolidar_memoria()` en puntos críticos.
3. **Recursividad Infinita en Pensar**: Evita crear ciclos cerrados en las secuencias (A -> B -> A) si vas a usar `pensar_siguiente` en bucles, o podrías causar un desbordamiento.
4. **Múltiples Archivos Simultáneos**: Jasboot solo soporta **una JMN activa a la vez**. Al abrir una nueva, la anterior se cierra. No puedes tener dos archivos `.jmn` abiertos en el mismo hilo de ejecución.

## Mejores Prácticas

- **Nombres de Claves**: Usa prefijos para organizar tu memoria (ej. `usr_nombre`, `ia_version`, `sys_timestamp`).
- **Validación**: Siempre verifica si `resultado` es lo que esperas después de un `buscar`.
- **Limpieza**: Usa `cerrar_memoria()` al final de tu bloque `principal` para asegurar una liberación de recursos limpia.
