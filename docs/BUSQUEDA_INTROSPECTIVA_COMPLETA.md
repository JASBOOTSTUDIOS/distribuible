# Búsqueda Introspectiva Completa en JMN
## Sistema Modular de Búsqueda en Memoria Neuronal

**Versión:** 1.0  
**Fecha:** Abril 2024  
**Estado:** Implementado (Requiere compilación con JASBOOT_LANG_INTEGRATION)

---

## 📋 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Funciones Disponibles](#funciones-disponibles)
3. [Comparación de Funciones](#comparación-de-funciones)
4. [Ejemplos de Uso](#ejemplos-de-uso)
5. [Arquitectura Técnica](#arquitectura-técnica)
6. [Estado de Implementación](#estado-de-implementación)
7. [Resolución de Problemas](#resolución-de-problemas)
8. [Próximos Pasos](#próximos-pasos)

---

## Introducción

El sistema de **Búsqueda Introspectiva** en JMN (Jasboot Memoria Neuronal) permite buscar texto dentro de las claves y valores de todos los conceptos almacenados en la memoria neuronal. Esta implementación modular ofrece cuatro niveles de funcionalidad que permiten al desarrollador elegir exactamente el nivel de detalle y control que necesita.

### Ventajas del Sistema

✅ **Modular**: Elige la función según tus necesidades  
✅ **Flexible**: Control sobre case-sensitivity y límites  
✅ **Eficiente**: Búsqueda en O(n) optimizada  
✅ **Rica en datos**: Metadata opcional (posición, relevancia, tipo)  
✅ **Fácil de usar**: API simple en español

---

## Funciones Disponibles

### 1. `buscar_en_memoria(termino)` 
**Búsqueda Básica - Primer Resultado**

```jasb
buscar_en_memoria(termino_texto)
```

**Parámetros:**
- `termino_texto` (texto): Término a buscar

**Retorna:**
- ID del primer concepto encontrado (en variable `resultado`)
- `0` si no se encontró nada

**Características:**
- ✅ Case-insensitive (no distingue mayúsculas)
- ✅ Solo primer resultado
- ✅ Más rápida (termina al encontrar)
- ✅ Ideal para verificación rápida

**Ejemplo:**
```jasb
buscar_en_memoria("neuronal")
si resultado != 0 entonces
    imprimir("✓ Encontrado")
fin_si
```

**Sinónimo:** `buscar_introspectiva(termino)`

---

### 2. `buscar_en_memoria_lista(termino, max_resultados)`
**Búsqueda Múltiple - Lista de IDs**

```jasb
elemento lista = buscar_en_memoria_lista(termino_texto, max_resultados)
```

**Parámetros:**
- `termino_texto` (texto): Término a buscar
- `max_resultados` (entero): Máximo de resultados (1-100, default 10)

**Retorna:**
- Lista JMN con IDs de conceptos encontrados
- Lista vacía si no se encontró nada

**Características:**
- ✅ Case-insensitive
- ✅ Múltiples resultados
- ✅ Control de límite
- ✅ Retorna lista JMN manipulable

**Ejemplo:**
```jasb
elemento lista = buscar_en_memoria_lista("aprendizaje", 5)
elemento tam = mem_lista_tamano(lista)

entero i = 0
mientras i < tam hacer
    elemento id = mem_lista_obtener(lista, i)
    imprimir("ID encontrado: " + id)
    i = i + 1
fin_mientras
```

---

### 3. `buscar_en_memoria_cs(termino, case_sensitive)`
**Búsqueda con Control de Mayúsculas/Minúsculas**

```jasb
buscar_en_memoria_cs(termino_texto, case_sensitive)
```

**Parámetros:**
- `termino_texto` (texto): Término a buscar
- `case_sensitive` (entero): 
  - `0` = Case-insensitive (ignora mayúsculas)
  - `1` = Case-sensitive (respeta mayúsculas)

**Retorna:**
- ID del primer concepto encontrado (en variable `resultado`)
- `0` si no se encontró nada

**Características:**
- ✅ Control total sobre case-sensitivity
- ✅ Primer resultado
- ✅ Útil para búsquedas exactas

**Ejemplo:**
```jasb
# Buscar exactamente "Deep" (con D mayúscula)
buscar_en_memoria_cs("Deep", 1)
si resultado != 0 entonces
    imprimir("Encontrado con mayúscula exacta")
fin_si

# Buscar cualquier variante de "deep"
buscar_en_memoria_cs("deep", 0)
si resultado != 0 entonces
    imprimir("Encontrado (case insensitive)")
fin_si
```

---

### 4. `buscar_en_memoria_detallada(termino, max_resultados, case_sensitive)`
**Búsqueda Detallada con Metadata**

```jasb
elemento lista = buscar_en_memoria_detallada(termino, max, case_sensitive)
```

**Parámetros:**
- `termino_texto` (texto): Término a buscar
- `max_resultados` (entero): Máximo de resultados (1-100, default 10)
- `case_sensitive` (entero): 0 = insensitive, 1 = sensitive (opcional)

**Retorna:**
- Lista JMN de mapas, cada uno con metadata completa:
  - `id`: ID del concepto
  - `texto`: Texto completo del concepto
  - `posicion`: Posición donde se encontró el término
  - `longitud_match`: Longitud de la coincidencia
  - `es_clave`: 1 si es clave, 0 si es valor
  - `relevancia`: Score de relevancia (0.0-1.0)

**Características:**
- ✅ Múltiples resultados
- ✅ Control de case-sensitivity
- ✅ Metadata rica
- ✅ Score de relevancia
- ✅ Ideal para análisis y ranking

**Ejemplo:**
```jasb
elemento lista = buscar_en_memoria_detallada("procesamiento", 3, 0)
elemento tam = mem_lista_tamano(lista)

entero i = 0
mientras i < tam hacer
    elemento mapa = mem_lista_obtener(lista, i)
    
    elemento id = mapa_obtener(mapa, "id")
    elemento texto = mapa_obtener(mapa, "texto")
    elemento pos = mapa_obtener(mapa, "posicion")
    elemento relev = mapa_obtener(mapa, "relevancia")
    
    imprimir("─────────────────────────────────")
    imprimir("ID: " + id)
    imprimir("Texto: " + texto)
    imprimir("Posición: " + pos)
    imprimir("Relevancia: " + relev)
    
    i = i + 1
fin_mientras
```

---

## Comparación de Funciones

| Característica | Básica | Lista | Case-Sensitive | Detallada |
|---|:---:|:---:|:---:|:---:|
| **Función** | `buscar_en_memoria()` | `buscar_en_memoria_lista()` | `buscar_en_memoria_cs()` | `buscar_en_memoria_detallada()` |
| **Múltiples resultados** | ❌ | ✅ | ❌ | ✅ |
| **Control case-sensitivity** | ❌ (siempre OFF) | ❌ (siempre OFF) | ✅ | ✅ |
| **Metadata (posición, relevancia)** | ❌ | ❌ | ❌ | ✅ |
| **Velocidad** | ⚡⚡⚡ | ⚡⚡ | ⚡⚡⚡ | ⚡ |
| **Uso de memoria** | Mínimo | Bajo | Mínimo | Alto |
| **Complejidad** | Simple | Media | Simple | Avanzada |
| **Ideal para** | Verificación rápida | Búsqueda exhaustiva | Búsqueda exacta | Análisis profundo |

---

## Ejemplos de Uso

### Ejemplo 1: Sistema de Búsqueda Inteligente

```jasb
principal
    crear_memoria("conocimiento.jmn")
    
    # Guardar conceptos
    recordar "inteligencia_artificial" con valor "Sistema cognitivo avanzado"
    recordar "machine_learning" con valor "Aprendizaje automático"
    recordar "deep_learning" con valor "Aprendizaje profundo"
    
    # Búsqueda progresiva con fallback
    imprimir("¿Qué tema buscas?")
    texto consulta = leer_entrada()
    
    # 1. Intentar búsqueda exacta (case-sensitive)
    buscar_en_memoria_cs(consulta, 1)
    si resultado != 0 entonces
        imprimir("✓ Coincidencia exacta encontrada")
        terminar
    fin_si
    
    # 2. Intentar búsqueda flexible (case-insensitive)
    buscar_en_memoria(consulta)
    si resultado != 0 entonces
        imprimir("✓ Coincidencia flexible encontrada")
        terminar
    fin_si
    
    # 3. Buscar todas las coincidencias parciales
    elemento lista = buscar_en_memoria_lista(consulta, 10)
    elemento tam = mem_lista_tamano(lista)
    
    si tam > 0 entonces
        imprimir("Encontradas " + tam + " coincidencias parciales:")
        entero i = 0
        mientras i < tam hacer
            elemento id = mem_lista_obtener(lista, i)
            imprimir("  - " + id)
            i = i + 1
        fin_mientras
    sino
        imprimir("✗ No se encontraron resultados")
    fin_si
    
    cerrar_memoria()
fin_principal
```

### Ejemplo 2: Análisis de Relevancia

```jasb
principal
    crear_memoria("documentos.jmn")
    
    # Guardar documentos
    recordar "doc1" con valor "Inteligencia artificial y machine learning"
    recordar "doc2" con valor "Machine learning aplicado"
    recordar "doc3" con valor "Introducción a ML y AI"
    
    # Búsqueda detallada con ranking
    texto termino = "machine"
    elemento resultados = buscar_en_memoria_detallada(termino, 10, 0)
    elemento tam = mem_lista_tamano(resultados)
    
    imprimir("Resultados ordenados por relevancia:")
    imprimir("")
    
    entero i = 0
    mientras i < tam hacer
        elemento mapa = mem_lista_obtener(resultados, i)
        
        elemento texto = mapa_obtener(mapa, "texto")
        elemento relev = mapa_obtener(mapa, "relevancia")
        elemento pos = mapa_obtener(mapa, "posicion")
        elemento es_clave = mapa_obtener(mapa, "es_clave")
        
        imprimir("#" + (i + 1) + " [Relevancia: " + relev + "]")
        imprimir("   Texto: " + texto)
        imprimir("   Posición: " + pos)
        
        si es_clave == 1 entonces
            imprimir("   Tipo: Clave (concepto)")
        sino
            imprimir("   Tipo: Valor (contenido)")
        fin_si
        
        imprimir("")
        i = i + 1
    fin_mientras
    
    cerrar_memoria()
fin_principal
```

### Ejemplo 3: Validación con Case-Sensitivity

```jasb
principal
    crear_memoria("codigos.jmn")
    
    recordar "API_KEY_PROD" con valor "clave-produccion-123"
    recordar "api_key_dev" con valor "clave-desarrollo-456"
    recordar "ApiKeyTest" con valor "clave-pruebas-789"
    
    # Buscar exactamente "API" (mayúsculas)
    imprimir("Buscando 'API' (mayúsculas)...")
    buscar_en_memoria_cs("API", 1)
    si resultado != 0 entonces
        imprimir("✓ Encontrado: " + resultado)
    sino
        imprimir("✗ No encontrado")
    fin_si
    
    # Buscar "api" (minúsculas)
    imprimir("Buscando 'api' (minúsculas)...")
    buscar_en_memoria_cs("api", 1)
    si resultado != 0 entonces
        imprimir("✓ Encontrado: " + resultado)
    sino
        imprimir("✗ No encontrado")
    fin_si
    
    # Buscar cualquier variante
    imprimir("Buscando 'api' (insensitive)...")
    buscar_en_memoria_cs("api", 0)
    si resultado != 0 entonces
        imprimir("✓ Encontrado: " + resultado)
    sino
        imprimir("✗ No encontrado")
    fin_si
    
    cerrar_memoria()
fin_principal
```

---

## Arquitectura Técnica

### Componentes Implementados

#### 1. **JMN Core** (`jasboot-jmn-core/src/memoria_neuronal/`)

**Archivo:** `memoria_neuronal_busqueda.c`

**Funciones Implementadas:**
```c
// Búsqueda básica
int jmn_buscar_introspectiva(JMNMemoria* mem, const char* termino, 
                              JMNBusquedaIntrospectivaResultado* resultados, 
                              uint32_t max_resultados, int case_sensitive);

// Búsqueda lista (solo IDs)
int jmn_buscar_introspectiva_lista(JMNMemoria* mem, const char* termino,
                                    uint32_t* ids, uint32_t max_resultados,
                                    int case_sensitive);

// Búsqueda con control CS
int jmn_buscar_introspectiva_cs(JMNMemoria* mem, const char* termino,
                                 JMNBusquedaIntrospectivaResultado* resultado,
                                 int case_sensitive);

// Búsqueda detallada con metadata
int jmn_buscar_introspectiva_detallada(JMNMemoria* mem, const char* termino,
                                        JMNBusquedaDetalladaResultado* resultados,
                                        uint32_t max_resultados,
                                        int case_sensitive);
```

**Estructuras:**
```c
typedef struct {
    uint32_t id;
    char texto[256];
    int posicion;
} JMNBusquedaIntrospectivaResultado;

typedef struct {
    uint32_t id;
    char texto[256];
    int posicion;
    int longitud_match;
    int es_clave;
    float relevancia;
} JMNBusquedaDetalladaResultado;
```

#### 2. **Compilador** (`jas-compiler-c/src/`)

**Archivo:** `codegen.c`

**Funciones Reconocidas:**
- `buscar_en_memoria()`
- `buscar_introspectiva()` (sinónimo)
- `buscar_en_memoria_lista()`
- `buscar_en_memoria_cs()`
- `buscar_en_memoria_detallada()`

**Archivo:** `sistema_llamadas.c`
- Agregadas a la lista blanca de funciones del sistema

#### 3. **Máquina Virtual** (`jasboot-ir/src/`)

**Archivo:** `vm.c`

**Opcodes Implementados:**

| Opcode | Hex | Función |
|--------|-----|---------|
| `OP_MEM_BUSCAR_INTROSPECTIVA` | `0xCC` | Búsqueda básica (ya existía) |
| `OP_MEM_BUSCAR_INTROSPECTIVA_LISTA` | `0x09` | Búsqueda con lista |
| `OP_MEM_BUSCAR_INTROSPECTIVA_CS` | `0x0A` | Búsqueda case-sensitive |
| `OP_MEM_BUSCAR_INTROSPECTIVA_DETALLADA` | `0x0B` | Búsqueda detallada |

**Archivo:** `ir_format.h`
- Definiciones de opcodes agregadas al enum `IROpcode`

**Archivo:** `reader_ir.c`
- Validación de opcodes agregada

#### 4. **Headers** (`include/`)

**Archivo:** `opcodes.h`
- Definiciones de macros de opcodes

---

## Estado de Implementación

### ✅ Completado

1. **JMN Core**
   - ✅ 4 funciones de búsqueda implementadas
   - ✅ Algoritmo de relevancia implementado
   - ✅ Soporte case-sensitive/insensitive
   - ✅ Estructuras de datos definidas
   - ✅ Compilado exitosamente

2. **Compilador**
   - ✅ 4 funciones agregadas a sistema_llamadas.c
   - ✅ Generación de código en codegen.c
   - ✅ Uso correcto de registros temporales
   - ✅ Escritura en variable `resultado`
   - ✅ Compilado exitosamente

3. **VM**
   - ✅ 3 nuevos opcodes implementados (0x09, 0x0A, 0x0B)
   - ✅ Integración con JMN Core
   - ✅ Creación de listas JMN
   - ✅ Creación de mapas con metadata
   - ✅ Código compilado

4. **Documentación**
   - ✅ API completa documentada
   - ✅ Ejemplos de uso
   - ✅ Comparación de funciones
   - ✅ Arquitectura técnica

### ⚠️ Pendiente

1. **Compilación con Flag Correcto**
   - ⚠️ La VM necesita compilarse con `-DJASBOOT_LANG_INTEGRATION`
   - ⚠️ Actualmente la VM no ejecuta el código de búsqueda

2. **Testing**
   - ⚠️ Tests funcionales pendientes de validación
   - ⚠️ Tests de integración completos
   - ⚠️ Benchmarks de rendimiento

3. **Optimizaciones**
   - 🔄 Índices para búsqueda más rápida
   - 🔄 Cache de resultados frecuentes
   - 🔄 Búsqueda paralela en memorias grandes

---

## Resolución de Problemas

### Problema 1: Funciones no reconocidas

**Síntoma:**
```
error semantico: Llamada no resuelta: 'buscar_en_memoria_lista' no es una funcion definida
```

**Solución:**
1. Verificar que el compilador esté actualizado:
   ```bash
   cd sdk-dependiente/jas-compiler-c
   gcc -std=c11 -Wall -Iinclude -I../jasboot-ir/src -O2 -c src/sistema_llamadas.c -o src/sistema_llamadas.o
   gcc -o bin/jbc.exe src/*.o
   ```

2. Verificar que las funciones están en `sistema_llamadas.c`:
   ```bash
   grep "buscar_en_memoria" sdk-dependiente/jas-compiler-c/src/sistema_llamadas.c
   ```

### Problema 2: Listas vacías o "indefinido"

**Síntoma:**
```jasb
elemento lista = buscar_en_memoria_lista("palabra", 5)
imprimir(lista)  # Muestra: indefinido
```

**Causa:** La VM no está compilada con `JASBOOT_LANG_INTEGRATION`

**Solución:**
```bash
cd sdk-dependiente/jasboot-ir
gcc -std=c11 -Wall -Wextra -O2 -Isrc \
    -I../jasboot-jmn-core/src \
    -I../jasboot-jmn-core/src/memoria_neuronal \
    -DJASBOOT_LANG_INTEGRATION \
    -c src/vm.c -o src/vm.o

# Re-enlazar con todos los objetos de JMN Core
gcc -o bin/jasboot-ir-vm.exe src/*.o \
    ../jasboot-jmn-core/src/memoria_neuronal/*.o \
    ../jasboot-jmn-core/src/*.o
```

### Problema 3: Resultados inconsistentes

**Síntoma:** La búsqueda encuentra resultados pero no se muestran correctamente

**Diagnóstico:**
```bash
JASBOOT_DEBUG=1 sdk-dependiente/jasboot-ir/bin/jasboot-ir-vm.exe test.jbo 2>&1 | grep "BUSQUEDA"
```

**Posibles causas:**
1. Memoria JMN no abierta correctamente
2. Textos no guardados en JMN
3. IDs runtime vs IDs hash confundidos

### Problema 4: Compilación de VM falla

**Síntoma:**
```
error: duplicate case value
case OP_MEM_BUSCAR_INTROSPECTIVA_LISTA:
```

**Solución:** Verificar que los valores de opcodes no estén duplicados en `opcodes.h` e `ir_format.h`

---

## Próximos Pasos

### Fase 1: Estabilización (Corto Plazo)

1. **Compilar VM correctamente**
   - [ ] Crear script de compilación con flags correctos
   - [ ] Verificar que `-DJASBOOT_LANG_INTEGRATION` esté activo
   - [ ] Probar todos los opcodes nuevos

2. **Validación funcional**
   - [ ] Ejecutar test_busqueda_avanzada.jasb completamente
   - [ ] Validar que las listas se devuelven correctamente
   - [ ] Verificar metadata en búsqueda detallada

3. **Corrección de bugs**
   - [ ] Resolver problema de listas "indefinidas"
   - [ ] Verificar conversión ID → texto
   - [ ] Validar acceso a mapas de metadata

### Fase 2: Mejoras (Mediano Plazo)

1. **Funcionalidades adicionales**
   - [ ] `buscar_en_memoria_regex()` - Búsqueda con expresiones regulares
   - [ ] `buscar_en_memoria_fuzzy()` - Búsqueda difusa/aproximada
   - [ ] `buscar_en_memoria_ordenada()` - Resultados ordenados por relevancia

2. **Optimizaciones**
   - [ ] Índice invertido para búsquedas frecuentes
   - [ ] Cache de últimas N búsquedas
   - [ ] Búsqueda incremental (ir agregando resultados)

3. **Usabilidad**
   - [ ] Función helper para imprimir resultados formateados
   - [ ] Builder pattern para búsquedas complejas
   - [ ] Soporte para filtros adicionales (fecha, tipo, etc.)

### Fase 3: Avanzado (Largo Plazo)

1. **Búsqueda semántica**
   - [ ] Integración con embeddings
   - [ ] Búsqueda por similitud vectorial
   - [ ] Ranking semántico automático

2. **Rendimiento**
   - [ ] Búsqueda paralela multi-thread
   - [ ] Índices persistentes en disco
   - [ ] Compresión de resultados

3. **Integración**
   - [ ] API REST para búsqueda remota
   - [ ] Plugin para Aurora IA
   - [ ] Integración con Neurixis

---

## Casos de Uso Reales

### 1. Sistema de Ayuda Contextual

```jasb
funcion buscar_ayuda(tema)
    # Búsqueda progresiva: exacta → flexible → sugerencias
    
    # 1. Búsqueda exacta
    buscar_en_memoria_cs(tema, 1)
    si resultado != 0 entonces
        retornar mostrar_ayuda(resultado)
    fin_si
    
    # 2. Búsqueda flexible
    buscar_en_memoria(tema)
    si resultado != 0 entonces
        retornar mostrar_ayuda(resultado)
    fin_si
    
    # 3. Sugerencias
    elemento sugerencias = buscar_en_memoria_lista(tema, 5)
    elemento tam = mem_lista_tamano(sugerencias)
    
    si tam > 0 entonces
        imprimir("¿Te refieres a alguno de estos?")
        mostrar_sugerencias(sugerencias, tam)
    sino
        imprimir("No se encontró ayuda para: " + tema)
    fin_si
fin

funcion mostrar_sugerencias(lista, tam)
    entero i = 0
    mientras i < tam hacer
        elemento id = mem_lista_obtener(lista, i)
        imprimir("  " + (i+1) + ". " + id)
        i = i + 1
    fin_mientras
fin
```

### 2. Análisis de Conocimiento

```jasb
funcion analizar_cobertura(tema)
    # Analizar qué tan cubierto está un tema en la base de conocimiento
    
    elemento resultados = buscar_en_memoria_detallada(tema, 100, 0)
    elemento total = mem_lista_tamano(resultados)
    
    imprimir("Análisis de cobertura para: " + tema)
    imprimir("Total de menciones: " + total)
    imprimir("")
    
    # Calcular estadísticas
    flotante relevancia_promedio = 0.0
    entero menciones_en_claves = 0
    entero menciones_en_valores = 0
    
    entero i = 0
    mientras i < total hacer
        elemento mapa = mem_lista_obtener(resultados, i)
        
        elemento relev = mapa_obtener(mapa, "relevancia")
        elemento es_clave = mapa_obtener(mapa, "es_clave")
        
        relevancia_promedio = relevancia_promedio + relev
        
        si es_clave == 1 entonces
            menciones_en_claves = menciones_en_claves + 1
        sino
            menciones_en_valores = menciones_en_valores + 1
        fin_si
        
        i = i + 1
    fin_mientras
    
    si total > 0 entonces
        relevancia_promedio = relevancia_promedio / total
    fin_si
    
    imprimir("Relevancia promedio: " + relevancia_promedio)
    imprimir("Menciones en claves: " + menciones_en_claves)
    imprimir("Menciones en valores: " + menciones_en_valores)
fin
```

---

## Referencias

### Archivos Modificados

```
sdk-dependiente/
├── jasboot-jmn-core/
│   ├── src/memoria_neuronal/
│   │   ├── memoria_neuronal.h           [MODIFICADO]
│   │   └── memoria_neuronal_busqueda.c  [MODIFICADO]
│
├── jas-compiler-c/
│   ├── include/opcodes.h                [MODIFICADO]
│   └── src/
│       ├── codegen.c                    [MODIFICADO]
│       └── sistema_llamadas.c           [MODIFICADO]
│
└── jasboot-ir/
    └── src/
        ├── ir_format.h                  [MODIFICADO]
        ├── reader_ir.c                  [MODIFICADO]
        └── vm.c                         [MODIFICADO]
```

### Tests Creados

```
tests/
├── test_busqueda_avanzada.jasb         [NUEVO]
└── test_lista_simple.jasb              [NUEVO]
```

### Documentación

```
docs/
├── BUSQUEDA_INTROSPECTIVA_COMPLETA.md  [ESTE ARCHIVO]
└── API_buscar_introspectiva.md         [CREADO PREVIAMENTE]
```

---

## Contacto y Contribuciones

Este sistema es parte del proyecto **Jasboot Programming Language**.

Para reportar bugs o sugerir mejoras:
1. Verificar la sección [Resolución de Problemas](#resolución-de-problemas)
2. Revisar el [Estado de Implementación](#estado-de-implementación)
3. Consultar los ejemplos en [Ejemplos de Uso](#ejemplos-de-uso)

---

**Última actualización:** Abril 2024  
**Versión del documento:** 1.0  
**Licencia:** Jasboot Project License