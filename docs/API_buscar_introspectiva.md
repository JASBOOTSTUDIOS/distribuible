# API: buscar_en_memoria() / buscar_introspectiva()

## Descripción

Función nativa de búsqueda introspectiva en la memoria neuronal JMN. Permite buscar texto dentro de las claves y valores de todos los conceptos almacenados en la memoria.

## Sintaxis

```jasb
buscar_en_memoria(termino_busqueda)
buscar_introspectiva(termino_busqueda)
```

Ambas funciones son sinónimos y tienen el mismo comportamiento.

## Parámetros

- **termino_busqueda** (texto): El término o subcadena a buscar dentro de los conceptos de la memoria JMN.

## Retorno

- **ID del concepto** (elemento): Devuelve el ID del primer concepto que contiene el término de búsqueda.
- **0**: Si no se encuentra ninguna coincidencia.

El resultado se almacena automáticamente en la variable especial `resultado`.

## Características

- **Búsqueda case-insensitive**: No distingue entre mayúsculas y minúsculas por defecto.
- **Búsqueda en claves y valores**: Busca tanto en los nombres de los conceptos (claves) como en sus valores asociados.
- **Búsqueda de subcadenas**: Encuentra coincidencias parciales dentro del texto.
- **Retorno del primer resultado**: Devuelve el primer concepto que coincide con el término.

## Ejemplos

### Ejemplo 1: Búsqueda básica

```jasb
principal
    crear_memoria("datos.jmn")
    
    # Guardar conceptos
    recordar "inteligencia_artificial" con valor "Sistema cognitivo avanzado"
    recordar "redes_neuronales" con valor "Arquitectura inspirada en el cerebro"
    
    # Buscar término en valores
    buscar_en_memoria("cerebro")
    
    # El resultado contiene el ID del concepto encontrado
    imprimir("ID encontrado:")
    imprimir(resultado)
    
    cerrar_memoria()
fin_principal
```

### Ejemplo 2: Verificar si existe un concepto

```jasb
principal
    crear_memoria("base.jmn")
    
    recordar "python" con valor "Lenguaje de programación"
    recordar "javascript" con valor "Lenguaje para web"
    
    # Buscar un término
    buscar_en_memoria("java")
    
    si resultado == 0 entonces
        imprimir("No se encontró ningún concepto con 'java'")
    sino
        imprimir("Se encontró un concepto")
    fin_si
    
    cerrar_memoria()
fin_principal
```

### Ejemplo 3: Buscar en claves de conceptos

```jasb
principal
    crear_memoria("conceptos.jmn")
    
    recordar "aprendizaje_profundo" con valor "Deep learning"
    recordar "aprendizaje_supervisado" con valor "Supervised learning"
    
    # Buscar en el nombre de la clave
    buscar_en_memoria("aprendizaje")
    
    si resultado != 0 entonces
        imprimir("✓ Encontrado concepto que contiene 'aprendizaje'")
    fin_si
    
    cerrar_memoria()
fin_principal
```

### Ejemplo 4: Búsqueda iterativa (encontrar múltiples coincidencias)

```jasb
principal
    crear_memoria("biblioteca.jmn")
    
    recordar "libro_ia" con valor "Inteligencia artificial moderna"
    recordar "libro_ml" con valor "Machine learning aplicado"
    recordar "libro_python" con valor "Python para ciencia de datos"
    
    # Primera búsqueda
    buscar_en_memoria("learning")
    
    si resultado != 0 entonces
        imprimir("Primer resultado encontrado")
        # Nota: actualmente solo devuelve el primer resultado
        # Para búsquedas exhaustivas, se necesitaría implementar
        # una función que devuelva una lista de IDs
    fin_si
    
    cerrar_memoria()
fin_principal
```

### Ejemplo 5: Uso del sinónimo buscar_introspectiva()

```jasb
principal
    crear_memoria("memoria.jmn")
    
    recordar "procesador" con valor "Intel Core i7"
    recordar "gpu" con valor "NVIDIA GeForce RTX"
    
    # Usar el nombre alternativo de la función
    buscar_introspectiva("NVIDIA")
    
    imprimir("Resultado de búsqueda:")
    imprimir(resultado)
    
    cerrar_memoria()
fin_principal
```

## Notas Importantes

1. **Variable resultado**: La función automáticamente guarda el ID encontrado en la variable especial `resultado`, que es de tipo `elemento`.

2. **IDs vs Texto**: La función devuelve un ID (hash) del concepto, no el texto directamente. Para obtener el texto completo del concepto, use la función `buscar()`:
   ```jasb
   buscar_en_memoria("término")
   elemento texto_completo = buscar(resultado)
   ```

3. **Primer resultado**: Solo devuelve el primer concepto que coincide. Si necesita todas las coincidencias, considere implementar una función personalizada que itere sobre todos los conceptos.

4. **Memoria JMN requerida**: Debe tener una memoria neuronal abierta con `crear_memoria()` antes de usar esta función.

5. **Case-insensitive**: La búsqueda no distingue entre mayúsculas y minúsculas. "Cerebro", "cerebro" y "CEREBRO" producen los mismos resultados.

## Casos de Uso

- **Búsqueda de conocimiento**: Encontrar conceptos relacionados con un tema específico.
- **Validación de existencia**: Verificar si un término ya existe en la memoria antes de agregarlo.
- **Depuración**: Inspeccionar qué conceptos contienen cierta información.
- **Filtrado conceptual**: Identificar conceptos relevantes basados en palabras clave.
- **Análisis de contenido**: Explorar qué información está almacenada en la memoria neuronal.

## Implementación Técnica

- **Opcode VM**: `OP_MEM_BUSCAR_INTROSPECTIVA (0xCC)`
- **Función JMN Core**: `jmn_buscar_introspectiva()`
- **Complejidad**: O(n) donde n es el número de textos en la memoria JMN
- **Tipo de búsqueda**: Búsqueda lineal con comparación de subcadenas

## Funciones Relacionadas

- `buscar(clave)`: Obtiene el valor asociado a una clave en JMN
- `recordar clave con valor`: Almacena un concepto en la memoria
- `crear_memoria(archivo)`: Crea o abre una memoria neuronal
- `cerrar_memoria()`: Cierra y persiste la memoria actual

## Limitaciones Actuales

1. Solo devuelve el primer resultado encontrado.
2. No hay control sobre la sensibilidad de mayúsculas/minúsculas (siempre case-insensitive).
3. No devuelve la posición donde se encontró la coincidencia.
4. No soporta expresiones regulares o patrones complejos.
5. El resultado es un ID que requiere conversión adicional para obtener texto legible.

## Mejoras Futuras Planeadas

- Función que devuelva una lista con todos los conceptos que coinciden
- Parámetro opcional para búsqueda case-sensitive
- Soporte para límite de resultados
- Ordenamiento por relevancia
- Metadatos de coincidencia (posición, contexto)

## Ver También

- [Memoria Neuronal JMN](./JMN_memoria_neuronal.md)
- [API de Búsqueda](./API_busqueda.md)
- [Funciones de Memoria](./API_memoria.md)

---

**Versión**: 1.0  
**Fecha**: Abril 2024  
**Lenguaje**: Jasboot Programming Language