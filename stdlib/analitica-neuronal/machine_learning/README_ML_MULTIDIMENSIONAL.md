# Algoritmos de Machine Learning Multidimensional

## Descripción General

Esta documentación describe los nuevos algoritmos de Machine Learning multidimensional agregados a la clase `MachineLearning` en el archivo `algoritmos_ml.jasb`.

Los métodos multidimensionales permiten trabajar con datos que tienen múltiples características (features), a diferencia de las versiones 1D que solo funcionan con datos unidimensionales.

## Métodos Principales

### 1. K-Means Multidimensional

#### `kmeans_multidimensional(lista X_matriz, entero k, entero max_iter, entero seed)`

Implementa el algoritmo K-Means clustering para datos multidimensionales.

**Parámetros:**
- `X_matriz` (lista): Matriz de datos - lista de listas donde cada sublista es un punto multidimensional
  - Ejemplo: `[[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]]` para puntos en 2D
- `k` (entero): Número de clusters a formar
- `max_iter` (entero): Número máximo de iteraciones del algoritmo
- `seed` (entero): Semilla para la inicialización de centroides

**Retorna:**
Un mapa con las siguientes claves:
- `"centroides"`: Lista de listas con las coordenadas de cada centroide
- `"asignaciones"`: Lista de enteros indicando a qué cluster pertenece cada punto
- `"iteraciones"`: Número de iteraciones ejecutadas
- `"inercia"`: Suma de distancias cuadradas de puntos a sus centroides (métrica de calidad)

**Ejemplo:**
```jasboot
MachineLearning ml = crear_instancia(MachineLearning)
ml.inicializar()

# Datos en 2D
lista datos = crear_lista()
lista_agregar(datos, crear_punto([2.0, 2.0]))
lista_agregar(datos, crear_punto([2.5, 2.3]))
lista_agregar(datos, crear_punto([8.0, 8.0]))
lista_agregar(datos, crear_punto([8.3, 7.9]))

# Ejecutar K-Means con 2 clusters, 20 iteraciones
mapa resultado = ml.kmeans_multidimensional(datos, 2, 20, 0)

# Acceder a resultados
lista centroides = mapa_obtener(resultado, "centroides")
lista asignaciones = mapa_obtener(resultado, "asignaciones")
flotante inercia = mapa_obtener(resultado, "inercia")
```

**Casos de uso:**
- Segmentación de clientes basada en múltiples características (edad, ingresos, gastos)
- Agrupación de imágenes por características visuales
- Compresión de datos
- Detección de patrones en datasets multidimensionales

---

### 2. KNN Clasificación

#### `knn_clasificacion(lista X_train, lista y_train, lista x_nuevo, entero k)`

Implementa K-Nearest Neighbors para clasificación con datos multidimensionales.

**Parámetros:**
- `X_train` (lista): Matriz de entrenamiento - lista de listas con los puntos de entrenamiento
- `y_train` (lista): Etiquetas de clase para cada punto de entrenamiento
- `x_nuevo` (lista): Punto nuevo a clasificar (lista con las mismas dimensiones que los puntos de entrenamiento)
- `k` (entero): Número de vecinos más cercanos a considerar

**Retorna:**
Elemento - La clase más frecuente entre los k vecinos más cercanos

**Ejemplo:**
```jasboot
MachineLearning ml = crear_instancia(MachineLearning)
ml.inicializar()

# Datos de entrenamiento: [altura_cm, peso_kg]
lista X_train = crear_lista()
lista y_train = crear_lista()

# Clase 0: Niños
lista_agregar(X_train, crear_punto([120.0, 30.0]))
lista_agregar(y_train, 0)
lista_agregar(X_train, crear_punto([125.0, 32.0]))
lista_agregar(y_train, 0)

# Clase 1: Adultos
lista_agregar(X_train, crear_punto([170.0, 70.0]))
lista_agregar(y_train, 1)
lista_agregar(X_train, crear_punto([175.0, 75.0]))
lista_agregar(y_train, 1)

# Clasificar nuevo punto
lista persona_nueva = crear_punto([172.0, 72.0])
entero clase = ml.knn_clasificacion(X_train, y_train, persona_nueva, 3)

escribir("Clase predicha: " + entero_a_texto(clase))
```

**Casos de uso:**
- Clasificación de especies (flores, animales) basada en características físicas
- Diagnóstico médico basado en síntomas múltiples
- Reconocimiento de patrones
- Filtrado de spam basado en múltiples features

---

### 3. KNN Regresión Multidimensional

#### `knn_regresion_multidimensional(lista X_train, lista y_train, lista x_nuevo, entero k)`

Implementa K-Nearest Neighbors para regresión (predicción de valores continuos) con múltiples features.

**Parámetros:**
- `X_train` (lista): Matriz de entrenamiento - lista de listas con los puntos de entrenamiento
- `y_train` (lista): Valores objetivo (números) para cada punto de entrenamiento
- `x_nuevo` (lista): Punto nuevo para el cual predecir el valor
- `k` (entero): Número de vecinos más cercanos a considerar

**Retorna:**
Flotante - Promedio de los valores y de los k vecinos más cercanos

**Ejemplo:**
```jasboot
MachineLearning ml = crear_instancia(MachineLearning)
ml.inicializar()

# Predecir precio de casa: [m2, habitaciones, baños] -> precio
lista X_train = crear_lista()
lista y_train = crear_lista()

lista_agregar(X_train, crear_punto([80.0, 2.0, 1.0]))
lista_agregar(y_train, 150000.0)

lista_agregar(X_train, crear_punto([100.0, 3.0, 2.0]))
lista_agregar(y_train, 200000.0)

lista_agregar(X_train, crear_punto([120.0, 3.0, 2.0]))
lista_agregar(y_train, 250000.0)

# Predecir precio para casa nueva
lista casa_nueva = crear_punto([90.0, 2.0, 1.0])
flotante precio = ml.knn_regresion_multidimensional(X_train, y_train, casa_nueva, 2)

escribir("Precio estimado: $" + flotante_a_texto(precio))
```

**Casos de uso:**
- Predicción de precios (casas, acciones, productos)
- Estimación de consumo energético
- Predicción de demanda
- Interpolación de valores en datasets multidimensionales

---

## Métodos Auxiliares

### `distancia_euclidiana(lista punto_a, lista punto_b)`

Calcula la distancia euclidiana entre dos puntos multidimensionales.

**Fórmula:** `√[(x₁-y₁)² + (x₂-y₂)² + ... + (xₙ-yₙ)²]`

**Parámetros:**
- `punto_a` (lista): Primer punto
- `punto_b` (lista): Segundo punto

**Retorna:**
Flotante - Distancia euclidiana, o -1.0 si los puntos tienen dimensiones diferentes

**Ejemplo:**
```jasboot
MachineLearning ml = crear_instancia(MachineLearning)
ml.inicializar()

lista p1 = crear_punto([0.0, 0.0])
lista p2 = crear_punto([3.0, 4.0])
flotante dist = ml.distancia_euclidiana(p1, p2)
# Resultado: 5.0 (teorema de Pitágoras)
```

---

### `encontrar_k_vecinos_mas_cercanos(lista X, lista punto, entero k)`

Encuentra los índices de los k puntos más cercanos a un punto dado.

**Parámetros:**
- `X` (lista): Matriz de puntos (lista de listas)
- `punto` (lista): Punto de referencia
- `k` (entero): Número de vecinos a encontrar

**Retorna:**
Lista - Índices de los k vecinos más cercanos

**Ejemplo:**
```jasboot
MachineLearning ml = crear_instancia(MachineLearning)
ml.inicializar()

lista puntos = crear_lista()
lista_agregar(puntos, crear_punto([1.0, 1.0]))
lista_agregar(puntos, crear_punto([2.0, 2.0]))
lista_agregar(puntos, crear_punto([10.0, 10.0]))

lista referencia = crear_punto([1.5, 1.5])
lista vecinos = ml.encontrar_k_vecinos_mas_cercanos(puntos, referencia, 2)
# Resultado: [0, 1] (índices de los 2 puntos más cercanos)
```

---

### `moda_lista(lista valores)`

Encuentra el valor más frecuente en una lista (moda estadística).

**Parámetros:**
- `valores` (lista): Lista de valores (pueden ser de cualquier tipo)

**Retorna:**
Elemento - El valor que aparece más veces en la lista

**Ejemplo:**
```jasboot
MachineLearning ml = crear_instancia(MachineLearning)
ml.inicializar()

lista clases = crear_lista()
lista_agregar(clases, 1)
lista_agregar(clases, 2)
lista_agregar(clases, 1)
lista_agregar(clases, 1)
lista_agregar(clases, 2)

elemento clase_mas_comun = ml.moda_lista(clases)
# Resultado: 1 (aparece 3 veces)
```

---

## Comparación: 1D vs Multidimensional

### Métodos Legacy (1D)

Los siguientes métodos permanecen disponibles para compatibilidad con código existente:

- `kmeans_1d(lista datos, entero k)` - K-Means para datos unidimensionales
- `knn_regresion_1d(lista x_train, lista y_train, flotante x_nuevo, entero k)` - KNN regresión para una sola variable

**Cuándo usar 1D:**
- Datos con una sola característica (temperatura, edad, precio)
- Problemas simples unidimensionales
- Visualización más fácil

### Métodos Multidimensionales (Nuevos)

**Cuándo usar Multidimensional:**
- Datos con múltiples características (altura + peso, longitud + ancho + profundidad)
- Problemas del mundo real que requieren considerar varios factores
- Mayor precisión en predicciones complejas

---

## Tips y Mejores Prácticas

### 1. Normalización de Datos

Antes de usar algoritmos de distancia (K-Means, KNN), normaliza tus datos para que todas las features estén en la misma escala:

```jasboot
# Ejemplo: Normalizar a rango [0, 1]
funcion normalizar_feature(lista valores) retorna lista
    flotante min_val = encontrar_minimo(valores)
    flotante max_val = encontrar_maximo(valores)
    flotante rango = max_val - min_val
    
    lista normalizados = crear_lista()
    entero i = 0
    mientras i < lista_tamano(valores) hacer
        flotante val = lista_obtener(valores, i)
        flotante norm = (val - min_val) / rango
        lista_agregar(normalizados, norm)
        i = i + 1
    fin_mientras
    
    retornar normalizados
fin_funcion
```

### 2. Selección de K

**Para K-Means:**
- Prueba con diferentes valores de k
- Observa la inercia: valores más bajos indican mejor clustering
- Usa el "método del codo" (elbow method)

**Para KNN:**
- k impares evitan empates en clasificación
- k pequeños (3-7) funcionan bien para la mayoría de casos
- k muy grandes suavizan demasiado, k=1 es muy sensible a ruido

### 3. Dimensionalidad

- Más dimensiones no siempre es mejor (maldición de la dimensionalidad)
- Considera reducción de dimensionalidad si tienes >10 features
- Elimina features correlacionadas o redundantes

### 4. Validación

Siempre valida tus modelos con datos de prueba separados:

```jasboot
# Dividir datos en 80% entrenamiento, 20% prueba
entero n_total = lista_tamano(X_datos)
entero n_train = (n_total * 80) / 100

lista X_train = obtener_primeros_n(X_datos, n_train)
lista X_test = obtener_ultimos_n(X_datos, n_total - n_train)
```

---

## Limitaciones Conocidas

1. **Escalabilidad**: K-Means y KNN pueden ser lentos con datasets grandes
2. **Memoria**: Algoritmos cargan todos los datos en memoria
3. **Sin validación cruzada**: Implementar manualmente si se requiere
4. **Inicialización K-Means**: Usa inicialización simple, no K-Means++

---

## Ejemplos Completos

Ver el archivo `examples/ejemplo_ml_multidimensional.jasb` para ejemplos completos de:
- Clustering de puntos 2D con K-Means
- Clasificación de flores con KNN
- Predicción de precios de casas con KNN regresión
- Cálculo de distancias euclidianas

---

## Próximas Mejoras

Futuras versiones podrían incluir:
- K-Means++ para mejor inicialización
- Normalización automática de datos
- Métricas de evaluación (silhouette score, accuracy, R²)
- Support Vector Machines (SVM)
- Árboles de decisión
- Redes neuronales básicas

---

## Referencias

- **K-Means**: Lloyd's Algorithm (1957)
- **KNN**: Cover & Hart (1967)
- **Distancia Euclidiana**: Geometría euclidiana clásica

---

**Autor**: Sistema Jasboot - Módulo de Analítica Neuronal  
**Versión**: 2.0  
**Última actualización**: 2026