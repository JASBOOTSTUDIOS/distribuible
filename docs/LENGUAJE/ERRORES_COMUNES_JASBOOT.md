# ERRORES COMUNES EN JASBOOT

Este documento describe los errores más comunes al programar en Jasboot y cómo solucionarlos.

---

## 1. ERRORES SINTÁCTICOS

### Error: `Error de sintaxis inesperado cerca de...`
**Causa**: Error en la estructura del lenguaje, falta operador, paréntesis, etc.

**Ejemplo**:
```
# ❌ Incorrecto
para entero i = 0 hasta 10 hacer
    imprimir i

# ✅ Correcto  
para entero i = 0 mientras i < 10 hacer
    imprimir i
    i = i + 1
fin_mientras
```

### Error: `Bloque sin cierre`
**Causa**: Falta `fin_para`, `fin_mientras`, `fin_si`, etc.

**Ejemplo**:
```
# ❌ Incorrecto
para entero i = 0 mientras i < 10 hacer
    imprimir i
# Falta fin_mientras

# ✅ Correcto
para entero i = 0 mientras i < 10 hacer
    imprimir i
    i = i + 1
fin_mientras
```

---

## 2. ERRORES SEMÁNTICOS

### Error: `Identificador coincide con palabra reservada`
**Causa**: Usar palabras reservadas como nombres de variables.

**Palabras reservadas comunes**:
- `y`, `a`, `valor`, `peso`, `entrada`, `clase`, `e`
- `principal`, `hacer`, `fin`, `funcion`, `clase`, `si`, `mientras`

**Ejemplo**:
```
# ❌ Incorrecto
flotante y = 5.0
flotante a = 10.0
flotante valor = 20.0

# ✅ Correcto
flotante _y = 5.0
flotante _a = 10.0
flotante _valor = 20.0
```

### Error: `Variable no declarada antes de su uso`
**Causa**: Usar variable diferente al parámetro declarado.

**Ejemplo**:
```
# ❌ Incorrecto
funcion mi_funcion(lista y_target) retorna flotante
    # Error: y no existe, es y_target
    suma = suma + y

# ✅ Correcto
funcion mi_funcion(lista y_target) retorna flotante
    suma = suma + y_target
```

---

## 3. ERRORES DE TIPOS

### Error: `Tipos incompatibles`
**Causa**: Mezclar tipos sin conversión explícita.

**Ejemplo**:
```
# ❌ Incorrecto
texto nombre = "Juan"
entero edad = nombre  # Error: texto → entero

# ✅ Correcto
texto nombre = "Juan"
entero edad = convertir_entero(nombre)  # Conversión explícita
```

---

## 4. ERRORES DE ESTRUCTURA

### Error: `Uso incorrecto de 'hacer'`
**Causa**: La palabra `hacer` es un alias para `mientras`, no para bucles `para`.

**Ejemplo**:
```
# ❌ Incorrecto
para entero i = 0 hasta 10 hacer
    # código
fin_hacer

# ✅ Correcto
para entero i = 0 mientras i < 10 con i++ hacer
    # código
fin_para

# ✅ Alternativa (mientras tradicional)
entero i = 0
mientras i < 10 hacer
    # código
    i = i + 1
fin_mientras
```

### Error: `Uso incorrecto de 'principal'`
**Causa**: `principal` es una palabra reservada para el punto de entrada, no para nombres de funciones.

**Ejemplo**:
```
# ❌ Incorrecto
funcion principal() retorna texto
    retornar "Hola"

# ✅ Correcto
funcion mi_funcion_principal() retorna texto
    retornar "Hola"

# ✅ Para el punto de entrada del programa
principal
    # código del programa
fin_principal
```

---

## 5. ERRORES CON LISTAS

### Error: `Acceso fuera de límites`
**Causa**: Intentar acceder a un índice que no existe en la lista.

**Ejemplo**:
```
# ❌ Incorrecto
lista mi_lista = crear_lista()
elemento valor = lista_obtener(mi_lista, 5)  # Error si la lista tiene menos de 6 elementos

# ✅ Correcto
lista mi_lista = crear_lista()
si lista_tamano(mi_lista) > 5 entonces
    elemento valor = lista_obtener(mi_lista, 5)
fin_si
```

### Error: `Índice incorrecto`
**Causa**: Usar índice negativo o mayor que el tamaño.

**Ejemplo**:
```
# ❌ Incorrecto
elemento valor = lista_obtener(mi_lista, -1)

# ✅ Correcto
elemento valor = lista_obtener(mi_lista, 0)  # Primer elemento
```

---

## 6. BUENAS PRÁCTICAS

### 1. Siempre validar tamaños
```jasboot
si lista_tamano(mi_lista) > 0 entonces
    elemento primero = lista_obtener(mi_lista, 0)
fin_si
```

### 2. Usar nombres descriptivos
```jasboot
# ❌ Poco claro
entero x = 5
texto y = "hola"

# ✅ Más claro
entero indice_usuario = 5
texto mensaje_saludo = "hola"
```

### 3. Evitar abreviaciones ambiguas
```jasboot
# ❌ Ambiguo
lista lst = crear_lista()

# ✅ Clara
lista elementos = crear_lista()
```

### 4. Comentarios donde sea necesario
```jasboot
# Calcular el promedio de una lista
flotante suma = 0.0
entero i = 0
mientras i < lista_tamano(valores) hacer
    elemento val = lista_obtener(valores, i)
    suma = suma + val  # Acumular suma
    i = i + 1
fin_mientras

flotante promedio = suma / lista_tamano(valores)
```

---

## 7. EJEMPLOS COMPLETOS CORRECTOS

### Programa básico
```jasboot
principal
    # Declarar variables con nombres no reservados
    entero _contador = 0
    flotante _total = 0.0
    texto _mensaje = "Procesando..."
    
    # Crear lista
    lista numeros = crear_lista()
    lista_agregar(numeros, 10)
    lista_agregar(numeros, 20)
    lista_agregar(numeros, 30)
    
    # Procesar con bucle estándar
    entero i = 0
    mientras i < lista_tamano(numeros) hacer
        elemento num = lista_obtener(numeros, i)
        _total = _total + num
        i = i + 1
    fin_mientras
    
    imprimir "Total: " + _total
    imprimir "Mensaje: " + _mensaje
fin_principal
```

### Función con parámetros
```jasboot
funcion calcular_promedio(lista valores) retorna flotante
    # Validar entrada
    si valores == nulo entonces
        retornar 0.0
    fin_si
    
    entero n = lista_tamano(valores)
    si n == 0 entonces
        retornar 0.0
    fin_si
    
    # Calcular suma
    flotante suma = 0.0
    entero i = 0
    mientras i < n hacer
        elemento val = lista_obtener(valores, i)
        suma = suma + val
        i = i + 1
    fin_mientras
    
    # Retornar promedio
    retornar suma / n
fin_funcion
```

---

## 8. HERRAMIENTAS DE DEPURACIÓN

### Uso de imprimir para debug
```jasboot
# Imprimir valores intermedios
imprimir "Debug: i = " + i
imprimir "Debug: valor = " + valor
```

### Validación de datos
```jasboot
# Validar antes de usar
si lista != nulo y lista_tamano(lista) > 0 entonces
    # Procesar lista
fin_si
```

---

## 9. CONCLUSIONES

1. **Siempre usar nombres descriptivos** que no entren en conflicto con palabras reservadas
2. **Validar siempre los límites** antes de acceder a listas o arrays
3. **Usar la sintaxis correcta** para cada tipo de bucle
4. **Mantener consistencia** en los nombres de variables
5. **Comentar el código complejo** para facilitar el mantenimiento

Siguiendo estas guías, evitarás la mayoría de los errores comunes en Jasboot.
