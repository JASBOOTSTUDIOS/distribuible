# Búsqueda Introspectiva en Memoria Neuronal JMN

## Descripción

La búsqueda introspectiva JMN permite buscar cadenas de texto en **todos los conceptos almacenados** en la memoria neuronal, sin necesidad de conocer los IDs específicos. Esta funcionalidad es útil para:

- Encontrar conceptos relacionados por contenido textual
- Realizar búsquedas semánticas en la base de conocimiento
- Descubrir patrones y conexiones ocultas
- Implementar sistemas de recuperación de información

## Funciones Disponibles

### 1. `jmn_buscar_introspectiva`

**Firma:**
```c
int jmn_buscar_introspectiva(JMNMemoria* mem, const char* termino, 
                           JMNBusquedaIntrospectivaResultado* resultados, 
                           uint32_t max_resultados, int case_sensitive);
```

**Parámetros:**
- `mem`: Puntero a la memoria neuronal JMN
- `termino`: Término de búsqueda (cadena de texto)
- `resultados`: Array donde se almacenarán los resultados
- `max_resultados`: Capacidad máxima del array de resultados
- `case_sensitive`: 0 = insensitive, 1 = sensitive

**Retorno:** Número de resultados encontrados, -1 en caso de error

**Estructura de resultado:**
```c
typedef struct JMNBusquedaIntrospectivaResultado {
    uint32_t id;           // ID del concepto que contiene el texto
    char texto[256];       // Texto completo del concepto
    int posicion;          // Posición donde se encontró la coincidencia
} JMNBusquedaIntrospectivaResultado;
```

### 2. `jmn_buscar_conceptos_con_texto`

**Firma:**
```c
int jmn_buscar_conceptos_con_texto(JMNMemoria* mem, const char* termino, 
                                  uint32_t* ids, uint32_t max_ids, int case_sensitive);
```

**Descripción:** Función simplificada que devuelve solo los IDs de los conceptos que contienen el término.

### 3. `jmn_concepto_contiene_texto`

**Firma:**
```c
int jmn_concepto_contiene_texto(JMNMemoria* mem, uint32_t id_concepto, 
                               const char* termino, int case_sensitive);
```

**Descripción:** Verifica si un concepto específico contiene el término de búsqueda.

**Retorno:** 1 si contiene el término, 0 si no lo contiene, -1 si hay error

## Ejemplos de Uso

### Ejemplo en C

```c
#include "memoria_neuronal.h"

int main() {
    // Crear memoria
    JMNMemoria* mem = jmn_crear_memoria_ram(1000, 2000);
    
    // Agregar conceptos
    jmn_guardar_texto(mem, 1001, "inteligencia artificial");
    jmn_guardar_texto(mem, 1002, "aprendizaje automático");
    jmn_guardar_texto(mem, 1003, "red neuronal artificial");
    
    // Búsqueda introspectiva
    JMNBusquedaIntrospectivaResultado resultados[10];
    int count = jmn_buscar_introspectiva(mem, "inteligencia", resultados, 10, 0);
    
    printf("Se encontraron %d resultados:\n", count);
    for (int i = 0; i < count; i++) {
        printf("ID: %u, Texto: '%s', Posición: %d\n", 
               resultados[i].id, resultados[i].texto, resultados[i].posicion);
    }
    
    jmn_cerrar(mem);
    return 0;
}
```

### Ejemplo en Jasboot

```jasboot
principal
    crear_memoria("conocimiento.jmn")
    
    # Agregar conceptos
    recordar "inteligencia artificial" con valor "Campo de la informática que desarrolla sistemas inteligentes"
    recordar "aprendizaje automático" con valor "Subcampo de IA que permite aprender sin programación explícita"
    
    # Buscar todos los conceptos que contienen "inteligencia"
    buscar "inteligencia"
    imprimir "Resultado: " + resultado
    
    cerrar_memoria()
fin_principal
```

## Características Avanzadas

### Búsqueda Case Insensitive

Por defecto, las búsquedas son case insensitive (no distinguen mayúsculas/minúsculas):

```c
// Encuentra "Inteligencia", "inteligencia", "INTELIGENCIA", etc.
int count = jmn_buscar_introspectiva(mem, "inteligencia", resultados, 10, 0);
```

### Búsqueda Case Sensitive

Para búsquedas que distingan mayúsculas/minúsculas:

```c
// Solo encuentra exactamente "Inteligencia"
int count = jmn_buscar_introspectiva(mem, "Inteligencia", resultados, 10, 1);
```

### Manejo de Límites

Las funciones respetan los límites especificados:

```c
JMNBusquedaIntrospectivaResultado resultados[5];
int count = jmn_buscar_introspectiva(mem, "a", resultados, 5, 0);
// count será <= 5, incluso si hay más coincidencias
```

## Consideraciones de Rendimiento

### Complejidad Temporal

- **Peor caso:** O(N × M) donde N = número de textos, M = longitud promedio de texto
- **Mejor caso:** O(N) cuando se encuentra temprano

### Optimizaciones Implementadas

1. **Iteración eficiente:** Solo se procesan textos que están en uso
2. **Búsqueda optimizada:** Uso de `strstr()` nativo para mejor rendimiento
3. **Memoria temporal mínima:** Solo se almacenan los resultados solicitados

### Recomendaciones

- Para búsquedas frecuentes, considere cachear resultados
- Use límites apropiados para evitar consumo excesivo de memoria
- Para bases de datos muy grandes, considere implementar índices

## Depuración

Para activar mensajes de depuración:

```bash
# En Windows
set JASBOOT_DEBUG=1

# En Linux/Mac
export JASBOOT_DEBUG=1
```

Esto mostrará mensajes detallados durante la búsqueda:

```
[JMN BUSQUEDA] Iniciando búsqueda introspectiva: término='inteligencia', case_sensitive=0
[JMN BUSQUEDA] Coincidencia encontrada: ID=1001, texto='inteligencia artificial', posicion=0
[JMN BUSQUEDA] Búsqueda completada: 8 textos procesados, 1 coincidencias encontradas
```

## Integración con la VM

La búsqueda introspectiva está integrada en la VM Jasboot a través del opcode `OP_BUSCAR_GLOBAL`:

```jasboot
buscar "término"          # Busca en todos los conceptos
texto resultado_var = resultado  # Variable 'resultado' contiene el ID encontrado
```

## Casos de Uso Recomendados

1. **Sistemas de问答:** Encontrar respuestas relevantes
2. **Recuperación de información:** Buscar documentos por contenido
3. **Análisis semántico:** Descubrir relaciones conceptuales
4. **Asistentes virtuales:** Encontrar conocimiento relacionado
5. **Sistemas de recomendación:** Identificar contenido similar

## Limitaciones Actuales

1. **Búsqueda de subcadena:** No soporta búsqueda de palabras completas únicamente
2. **Sin stemming:** No realiza reducción de palabras a su raíz
3. **Sin sinónimos:** No expande términos con sinónimos
4. **Sin ranking:** Los resultados no están ordenados por relevancia

## Futuras Mejoras

1. **Búsqueda de palabras completas:** Opción para coincidencias exactas
2. **Expresiones regulares:** Soporte para patrones complejos
3. **Ranking por relevancia:** Ordenar resultados por importancia
4. **Búsqueda difusa:** Permitir errores tipográficos
5. **Indexación:** Mejorar rendimiento para bases de datos grandes

## Errores Comunes

### Error: Resultado vacío

**Causa:** El término de búsqueda no existe en ningún concepto.

**Solución:** Verifique que los conceptos estén correctamente almacenados y use términos más generales.

### Error: Retorno -1

**Causa:** Parámetros inválidos (NULL, tamaños incorrectos).

**Solución:** Valide todos los parámetros antes de llamar a la función.

### Error: Desbordamiento de buffer

**Causa:** El array de resultados es demasiado pequeño.

**Solución:** Use un array más grande o procese resultados en lotes.
