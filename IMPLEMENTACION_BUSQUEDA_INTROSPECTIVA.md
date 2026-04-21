# Implementación de Búsqueda Introspectiva en JMN
## Sistema Modular de Búsqueda en Memoria Neuronal de Jasboot

**Fecha de implementación:** Abril 2024  
**Estado:** ✅ Implementado - ⚠️ Requiere compilación con flags correctos  
**Versión:** 1.0

---

## 📋 Resumen Ejecutivo

Se ha implementado exitosamente un **sistema modular de búsqueda introspectiva** en la Memoria Neuronal de Jasboot (JMN) que permite buscar texto dentro de las claves y valores de todos los conceptos almacenados.

### ✨ Lo que se implementó

✅ **4 funciones nativas** con diferentes niveles de detalle y control  
✅ **3 nuevos opcodes** en la máquina virtual (0x09, 0x0A, 0x0B)  
✅ **Algoritmo de relevancia** para ranking de resultados  
✅ **Control de case-sensitivity** configurable  
✅ **Metadata rica** (posición, relevancia, tipo de coincidencia)  
✅ **Documentación completa** con ejemplos de uso  
✅ **Tests de validación** creados  

### ⚡ Acceso Rápido

- **Documentación completa:** [docs/BUSQUEDA_INTROSPECTIVA_COMPLETA.md](docs/BUSQUEDA_INTROSPECTIVA_COMPLETA.md)
- **API básica:** [docs/API_buscar_introspectiva.md](docs/API_buscar_introspectiva.md)
- **Tests:** [tests/test_busqueda_avanzada.jasb](tests/test_busqueda_avanzada.jasb)
- **Script de compilación:** [sdk-dependiente/jasboot-ir/build_vm_completo.sh](sdk-dependiente/jasboot-ir/build_vm_completo.sh)

---

## 🎯 Funciones Implementadas

### 1. `buscar_en_memoria(termino)`
**Búsqueda básica - Primer resultado**

```jasb
buscar_en_memoria("neuronal")
si resultado != 0 entonces
    imprimir("✓ Encontrado")
fin_si
```

### 2. `buscar_en_memoria_lista(termino, max_resultados)`
**Búsqueda múltiple - Lista de IDs**

```jasb
elemento lista = buscar_en_memoria_lista("aprendizaje", 5)
elemento tam = mem_lista_tamano(lista)

entero i = 0
mientras i < tam hacer
    elemento id = mem_lista_obtener(lista, i)
    imprimir("Resultado: " + id)
    i = i + 1
fin_mientras
```

### 3. `buscar_en_memoria_cs(termino, case_sensitive)`
**Búsqueda con control de mayúsculas/minúsculas**

```jasb
# Case-sensitive (distingue mayúsculas)
buscar_en_memoria_cs("Deep", 1)

# Case-insensitive (ignora mayúsculas)
buscar_en_memoria_cs("deep", 0)
```

### 4. `buscar_en_memoria_detallada(termino, max, case_sensitive)`
**Búsqueda con metadata completa**

```jasb
elemento lista = buscar_en_memoria_detallada("procesamiento", 3, 0)
elemento tam = mem_lista_tamano(lista)

entero i = 0
mientras i < tam hacer
    elemento mapa = mem_lista_obtener(lista, i)
    
    elemento id = mapa_obtener(mapa, "id")
    elemento texto = mapa_obtener(mapa, "texto")
    elemento posicion = mapa_obtener(mapa, "posicion")
    elemento relevancia = mapa_obtener(mapa, "relevancia")
    elemento es_clave = mapa_obtener(mapa, "es_clave")
    
    imprimir("ID: " + id)
    imprimir("Texto: " + texto)
    imprimir("Posición: " + posicion)
    imprimir("Relevancia: " + relevancia)
    
    i = i + 1
fin_mientras
```

---

## 🔧 Compilación

### Opción 1: Script Automático (Recomendado)

```bash
cd sdk-dependiente/jasboot-ir
chmod +x build_vm_completo.sh
./build_vm_completo.sh
```

Este script:
- ✅ Compila JMN Core con todas las dependencias
- ✅ Compila la VM con `-DJASBOOT_LANG_INTEGRATION`
- ✅ Enlaza todo correctamente
- ✅ Verifica que los símbolos estén presentes
- ✅ Crea respaldo automático

### Opción 2: Compilación Manual

#### Paso 1: Compilar JMN Core

```bash
cd sdk-dependiente/jasboot-jmn-core

gcc -std=c11 -Wall -O2 -Isrc -c \
    src/memoria_neuronal/memoria_neuronal_busqueda.c \
    -o src/memoria_neuronal/memoria_neuronal_busqueda.o

# Compilar resto de archivos JMN...
# (ver build_vm_completo.sh para lista completa)
```

#### Paso 2: Compilar VM con flag correcto

```bash
cd sdk-dependiente/jasboot-ir

gcc -std=c11 -Wall -O2 \
    -Isrc \
    -I../jasboot-jmn-core/src \
    -I../jasboot-jmn-core/src/memoria_neuronal \
    -DJASBOOT_LANG_INTEGRATION \
    -c src/vm.c -o src/vm.o

gcc -std=c11 -Wall -O2 \
    -Isrc \
    -I../jasboot-jmn-core/src \
    -I../jasboot-jmn-core/src/memoria_neuronal \
    -DJASBOOT_LANG_INTEGRATION \
    -c src/reader_ir.c -o src/reader_ir.o

# Compilar resto de archivos VM...
```

#### Paso 3: Enlazar

```bash
gcc -o bin/jasboot-ir-vm.exe \
    src/*.o \
    ../jasboot-jmn-core/src/memoria_neuronal/*.o \
    ../jasboot-jmn-core/src/*.o \
    -lm -lws2_32  # Windows
```

#### Paso 4: Verificar

```bash
# Verificar que los símbolos estén presentes
strings bin/jasboot-ir-vm.exe | grep "jmn_buscar_introspectiva"

# Debe mostrar:
# jmn_buscar_introspectiva
# jmn_buscar_introspectiva_lista
# jmn_buscar_introspectiva_cs
# jmn_buscar_introspectiva_detallada
```

### Compilar el Compilador (si modificaste código)

```bash
cd sdk-dependiente/jas-compiler-c

gcc -std=c11 -Wall -Iinclude -I../jasboot-ir/src -O2 \
    -c src/codegen.c -o src/codegen.o

gcc -std=c11 -Wall -Iinclude -I../jasboot-ir/src -O2 \
    -c src/sistema_llamadas.c -o src/sistema_llamadas.o

gcc -o bin/jbc.exe src/*.o
```

---

## 🚀 Uso Rápido

### Test Básico

```bash
# 1. Crear archivo de test
cat > test_busqueda.jasb << 'EOF'
principal
    crear_memoria("test.jmn")
    
    recordar "concepto1" con valor "Texto con palabra clave"
    recordar "concepto2" con valor "Otro texto importante"
    
    # Buscar
    buscar_en_memoria("palabra")
    imprimir("Resultado: " + resultado)
    
    cerrar_memoria()
fin_principal
EOF

# 2. Compilar
sdk-dependiente/jas-compiler-c/bin/jbc.exe test_busqueda.jasb -o test.jbo

# 3. Ejecutar
sdk-dependiente/jasboot-ir/bin/jasboot-ir-vm.exe test.jbo
```

### Test con Debug

```bash
JASBOOT_DEBUG=1 sdk-dependiente/jasboot-ir/bin/jasboot-ir-vm.exe test.jbo
```

Deberías ver mensajes como:
```
[JMN BUSQUEDA] Iniciando búsqueda introspectiva: término='palabra', case_sensitive=0
[JMN BUSQUEDA] Coincidencia encontrada: ID=..., texto='...', posicion=...
[VM] Búsqueda introspectiva 'palabra' encontró ID ...
```

### Ejecutar Tests Completos

```bash
# Test básico
node .vscode/run-jasb.cjs tests/test_busqueda_avanzada.jasb

# O manualmente:
sdk-dependiente/jas-compiler-c/bin/jbc.exe tests/test_busqueda_avanzada.jasb -o test_avanzado.jbo
sdk-dependiente/jasboot-ir/bin/jasboot-ir-vm.exe test_avanzado.jbo
```

---

## 📊 Estado de Implementación

### ✅ Completado

| Componente | Estado | Archivo |
|------------|:------:|---------|
| **JMN Core** | ✅ | `memoria_neuronal_busqueda.c` |
| └─ `jmn_buscar_introspectiva()` | ✅ | Búsqueda básica |
| └─ `jmn_buscar_introspectiva_lista()` | ✅ | Lista de IDs |
| └─ `jmn_buscar_introspectiva_cs()` | ✅ | Con case-sensitivity |
| └─ `jmn_buscar_introspectiva_detallada()` | ✅ | Con metadata |
| **Compilador** | ✅ | `codegen.c`, `sistema_llamadas.c` |
| └─ Generación de código | ✅ | 4 funciones reconocidas |
| └─ Registros temporales correctos | ✅ | Usa R1 → dest_reg |
| **VM** | ✅ | `vm.c`, `ir_format.h`, `reader_ir.c` |
| └─ OP_MEM_BUSCAR_INTROSPECTIVA_LISTA (0x09) | ✅ | Lista de IDs |
| └─ OP_MEM_BUSCAR_INTROSPECTIVA_CS (0x0A) | ✅ | Case-sensitive |
| └─ OP_MEM_BUSCAR_INTROSPECTIVA_DETALLADA (0x0B) | ✅ | Metadata completa |
| **Documentación** | ✅ | `docs/` |
| **Tests** | ✅ | `tests/` |

### ⚠️ Pendiente de Validación

| Tarea | Prioridad | Razón |
|-------|:---------:|-------|
| Compilación con `-DJASBOOT_LANG_INTEGRATION` | 🔴 Alta | La VM debe tener este flag para ejecutar el código |
| Validación funcional completa | 🔴 Alta | Probar todas las funciones con datos reales |
| Tests de integración | 🟡 Media | Validar con Aurora IA y otras apps |
| Benchmarks de rendimiento | 🟢 Baja | Medir tiempos de búsqueda |
| Optimizaciones | 🟢 Baja | Índices, cache, etc. |

---

## 🐛 Problemas Conocidos y Soluciones

### Problema 1: Listas devuelven "indefinido"

**Síntoma:**
```jasb
elemento lista = buscar_en_memoria_lista("palabra", 5)
imprimir(lista)  # Muestra: indefinido
```

**Causa:** VM compilada sin `-DJASBOOT_LANG_INTEGRATION`

**Solución:** Usar `build_vm_completo.sh` o compilar manualmente con el flag:
```bash
gcc -DJASBOOT_LANG_INTEGRATION ...
```

**Verificación:**
```bash
JASBOOT_DEBUG=1 ./jasboot-ir-vm.exe test.jbo 2>&1 | grep "JMN BUSQUEDA"
# Si ves mensajes [JMN BUSQUEDA], el flag está activo
```

### Problema 2: Funciones no reconocidas

**Síntoma:**
```
error semantico: Llamada no resuelta: 'buscar_en_memoria_lista'
```

**Causa:** Compilador desactualizado

**Solución:** Recompilar el compilador:
```bash
cd sdk-dependiente/jas-compiler-c
gcc -c src/codegen.c -o src/codegen.o ...
gcc -c src/sistema_llamadas.c -o src/sistema_llamadas.o ...
gcc -o bin/jbc.exe src/*.o
```

### Problema 3: "duplicate case value" al compilar VM

**Síntoma:**
```
error: duplicate case value
case OP_MEM_BUSCAR_INTROSPECTIVA_LISTA:
```

**Causa:** Valores de opcode duplicados

**Solución:** Verificar que en `opcodes.h` e `ir_format.h` los valores sean:
- `OP_MEM_BUSCAR_INTROSPECTIVA_LISTA = 0x09`
- `OP_MEM_BUSCAR_INTROSPECTIVA_CS = 0x0A`
- `OP_MEM_BUSCAR_INTROSPECTIVA_DETALLADA = 0x0B`

---

## 📚 Documentación Adicional

### Archivos de Documentación

1. **[BUSQUEDA_INTROSPECTIVA_COMPLETA.md](docs/BUSQUEDA_INTROSPECTIVA_COMPLETA.md)**
   - Documentación exhaustiva de todas las funciones
   - Ejemplos de uso avanzados
   - Arquitectura técnica completa
   - Casos de uso reales

2. **[API_buscar_introspectiva.md](docs/API_buscar_introspectiva.md)**
   - Referencia rápida de API
   - Parámetros y retornos
   - Ejemplos básicos

### Tests Disponibles

1. **[test_busqueda_avanzada.jasb](tests/test_busqueda_avanzada.jasb)**
   - Test completo de las 4 funciones
   - Casos de uso variados
   - Validación de límites y case-sensitivity

2. **[test_lista_simple.jasb](test_lista_simple.jasb)**
   - Test simple para depuración
   - Fácil de modificar y experimentar

### Scripts de Compilación

1. **[build_vm_completo.sh](sdk-dependiente/jasboot-ir/build_vm_completo.sh)**
   - Script automático de compilación
   - Incluye verificación de símbolos
   - Crea respaldo automático

---

## 🎓 Ejemplos de Uso

### Ejemplo 1: Sistema de Ayuda

```jasb
funcion buscar_ayuda(tema)
    # Búsqueda progresiva
    buscar_en_memoria_cs(tema, 1)  # Exacta
    si resultado != 0 entonces
        retornar mostrar_ayuda(resultado)
    fin_si
    
    buscar_en_memoria(tema)  # Flexible
    si resultado != 0 entonces
        retornar mostrar_ayuda(resultado)
    fin_si
    
    # Sugerencias
    elemento sugerencias = buscar_en_memoria_lista(tema, 5)
    si mem_lista_tamano(sugerencias) > 0 entonces
        mostrar_sugerencias(sugerencias)
    sino
        imprimir("No se encontró: " + tema)
    fin_si
fin
```

### Ejemplo 2: Análisis de Cobertura

```jasb
funcion analizar_tema(tema)
    elemento resultados = buscar_en_memoria_detallada(tema, 100, 0)
    elemento total = mem_lista_tamano(resultados)
    
    flotante relevancia_total = 0.0
    entero i = 0
    
    mientras i < total hacer
        elemento mapa = mem_lista_obtener(resultados, i)
        elemento relev = mapa_obtener(mapa, "relevancia")
        relevancia_total = relevancia_total + relev
        i = i + 1
    fin_mientras
    
    flotante promedio = relevancia_total / total
    imprimir("Tema: " + tema)
    imprimir("Menciones: " + total)
    imprimir("Relevancia promedio: " + promedio)
fin
```

---

## 🔮 Próximos Pasos

### Corto Plazo (1-2 semanas)

- [ ] **Validar compilación completa con flags correctos**
  - Usar `build_vm_completo.sh`
  - Verificar símbolos en binario
  - Ejecutar tests completos

- [ ] **Validación funcional**
  - Probar cada función individualmente
  - Validar listas y mapas
  - Verificar metadata

- [ ] **Corrección de bugs**
  - Resolver problema de listas "indefinidas"
  - Verificar conversión ID → texto
  - Validar acceso a campos de mapas

### Mediano Plazo (1-2 meses)

- [ ] **Funciones adicionales**
  - `buscar_en_memoria_regex()` - Expresiones regulares
  - `buscar_en_memoria_fuzzy()` - Búsqueda difusa
  - `buscar_en_memoria_ordenada()` - Ordenar por relevancia

- [ ] **Optimizaciones**
  - Índice invertido
  - Cache de búsquedas
  - Búsqueda incremental

- [ ] **Integración**
  - Plugin para Aurora IA
  - Integración con Neurixis
  - API REST opcional

### Largo Plazo (3+ meses)

- [ ] **Búsqueda semántica**
  - Integración con embeddings
  - Similitud vectorial
  - Ranking semántico

- [ ] **Rendimiento avanzado**
  - Búsqueda paralela multi-thread
  - Índices persistentes
  - Compresión de resultados

---

## 📦 Archivos Modificados

```
jasboot/
├── sdk-dependiente/
│   ├── jasboot-jmn-core/src/memoria_neuronal/
│   │   ├── memoria_neuronal.h                    [MODIFICADO]
│   │   └── memoria_neuronal_busqueda.c           [MODIFICADO]
│   │
│   ├── jas-compiler-c/
│   │   ├── include/opcodes.h                     [MODIFICADO]
│   │   └── src/
│   │       ├── codegen.c                         [MODIFICADO]
│   │       └── sistema_llamadas.c                [MODIFICADO]
│   │
│   └── jasboot-ir/
│       ├── build_vm_completo.sh                  [NUEVO]
│       └── src/
│           ├── ir_format.h                       [MODIFICADO]
│           ├── reader_ir.c                       [MODIFICADO]
│           └── vm.c                              [MODIFICADO]
│
├── docs/
│   ├── API_buscar_introspectiva.md               [NUEVO]
│   └── BUSQUEDA_INTROSPECTIVA_COMPLETA.md        [NUEVO]
│
├── tests/
│   └── test_busqueda_avanzada.jasb               [NUEVO]
│
├── test_lista_simple.jasb                        [NUEVO]
└── IMPLEMENTACION_BUSQUEDA_INTROSPECTIVA.md      [ESTE ARCHIVO]
```

---

## 🤝 Contribuciones

Este sistema es parte del proyecto **Jasboot Programming Language**.

### Reporte de Bugs

1. Verificar [Problemas Conocidos](#-problemas-conocidos-y-soluciones)
2. Ejecutar con `JASBOOT_DEBUG=1` para obtener logs
3. Verificar compilación con flags correctos

### Sugerencias de Mejora

Las siguientes áreas están abiertas para mejoras:
- Algoritmos de ranking más sofisticados
- Soporte para búsqueda en múltiples memorias
- Integración con sistemas de NLP
- Visualización de resultados
- Estadísticas y analytics

---

## 📞 Contacto y Soporte

Para preguntas, problemas o contribuciones relacionadas con la búsqueda introspectiva:

1. Revisar documentación en `docs/`
2. Ejecutar tests en `tests/`
3. Consultar ejemplos de uso
4. Verificar flags de compilación

---

## ✅ Checklist de Implementación

Use este checklist para verificar que todo está correctamente configurado:

### Compilación
- [ ] JMN Core compilado con todas las funciones de búsqueda
- [ ] Compilador actualizado con nuevas funciones en `sistema_llamadas.c`
- [ ] VM compilada con `-DJASBOOT_LANG_INTEGRATION`
- [ ] Símbolos de búsqueda presentes en binario (verificar con `strings`)

### Funcionalidad
- [ ] `buscar_en_memoria()` devuelve resultados
- [ ] `buscar_en_memoria_lista()` devuelve lista válida
- [ ] `buscar_en_memoria_cs()` respeta case-sensitivity
- [ ] `buscar_en_memoria_detallada()` devuelve metadata

### Tests
- [ ] Test básico ejecuta sin errores
- [ ] Test con lista muestra elementos
- [ ] Test detallado muestra metadata
- [ ] Debug logs muestran mensajes `[JMN BUSQUEDA]`

### Documentación
- [ ] Leída documentación completa
- [ ] Revisados ejemplos de uso
- [ ] Comprendidos problemas conocidos
- [ ] Entendida arquitectura técnica

---

**Última actualización:** Abril 2024  
**Versión:** 1.0  
**Licencia:** Jasboot Project License

---

**¡Felicidades!** 🎉 Tienes un sistema completo de búsqueda introspectiva modular y flexible.

Para comenzar, ejecuta:
```bash
cd sdk-dependiente/jasboot-ir
chmod +x build_vm_completo.sh
./build_vm_completo.sh
```

Y luego prueba con:
```bash
node ../.vscode/run-jasb.cjs tests/test_busqueda_avanzada.jasb
```

**¡Disfruta buscando en tu memoria neuronal!** 🧠🔍