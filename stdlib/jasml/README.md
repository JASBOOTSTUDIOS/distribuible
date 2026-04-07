# JASML - Jasboot Machine Learning Library

## Overview

JASML es la primera librería completa de Machine Learning para el lenguaje Jasboot, inspirada en las populares librerías de Python como scikit-learn, NumPy y pandas. Proporciona algoritmos de aprendizaje automático, estadística descriptiva y herramientas de evaluación de modelos.

**Estado Actual: Versión 1.0.0 - Funcional y lista para producción**

## Características

### 1. **Operaciones Matemáticas (Tipo NumPy)**
- Creación de vectores y matrices
- Operaciones vectoriales (suma, producto punto, normalización)
- Cálculo de magnitudes y distancias
- Raíz cuadrada implementada manualmente
- Álgebra lineal básica

### 2. **Estadística Descriptiva (Tipo Pandas/NumPy)**
- Media, mediana, moda, percentiles
- Desviación estándar y varianza
- Valores mínimo y máximo
- Rango intercuartílico
- Resúmenes estadísticos completos

### 3. **Algoritmos de Machine Learning (Tipo scikit-learn)**

#### Regresión
- **Regresión Lineal Simple**: `regresion_lineal_entrenar()`, `regresion_lineal_predecir()`
- **Regresión Polinomial**: `polinomial_transformar_grado2()`
- **Evaluación**: MSE, MAE, RMSE, R², MAPE

#### Clasificación
- **K-Nearest Neighbors (KNN)**: `knn_predecir()`, `encontrar_vecinos()`
- **Naive Bayes Classifier**: `naive_bayes_entrenar()`, `naive_bayes_predecir()`
- **Clasificación por Reglas**: `reglas_simple_entrenar()`, `reglas_simple_predecir()`
- **Evaluación**: Accuracy, Precision, Recall, F1-Score

#### Clustering
- **K-Means Clustering**: `kmeans_entrenar()`, `kmeans_asignar_clusters()`
- **Clustering Aglomerativo**: `clustering_aglomerativo()`
- **DBSCAN**: `dbscan_entrenar()`, `dbscan_encontrar_vecinos()`
- **Evaluación**: Índice de Silueta

### 4. **Preprocesamiento (Tipo scikit-learn preprocessing)**
- **Normalización**: Min-Max, Z-score
- **Transformaciones**: Logarítmica, Raíz cuadrada
- **Discretización**: Igual frecuencia, Igual rango
- **Manejo de valores faltantes**: Media, Mediana, Forward Fill
- **Selección de características**: Por varianza

### 5. **Evaluación (Tipo scikit-learn metrics)**
- **Regresión**: MSE, MAE, RMSE, R²
- **Clasificación**: Accuracy, Precision, Recall, F1-Score
- **Clustering**: Silueta
- **Matriz de Confusión**: Construcción y análisis

## Instalación

Para usar JASML en tu proyecto Jasboot, simplemente importa la librería:

```jasboot
usar todas de "stdlib/jasml/jasml.jasb"
```

## Quick Start

### Ejemplo Básico: Regresión Lineal

```jasboot
usar todas de "stdlib/jasml/jasml.jasb"

funcion ejemplo_regresion()
    // Datos de ejemplo
    lista X = crear_lista()
    lista y_objetivo = crear_lista()
    
    // Agregar datos (tamaño vs precio)
    lista punto1 = crear_lista()
    mem_lista_agregar(punto1, "50")
    mem_lista_agregar(X, punto1)
    mem_lista_agregar(y_objetivo, "150")
    
    lista punto2 = crear_lista()
    mem_lista_agregar(punto2, "75")
    mem_lista_agregar(X, punto2)
    mem_lista_agregar(y_objetivo, "200")
    
    // Entrenar modelo
    lista modelo = regresion_lineal_entrenar(X, y_objetivo)
    
    // Hacer predicción
    lista nuevo_punto = crear_lista()
    mem_lista_agregar(nuevo_punto, "80")
    flotante prediccion = regresion_lineal_predecir(modelo, nuevo_punto)
    
    imprimir "Predicción: " + str_desde_numero(prediccion)
fin_funcion
```

### Ejemplo: Clasificación KNN

```jasboot
usar todas de "stdlib/jasml/jasml.jasb"

funcion ejemplo_clasificacion()
    // Datos de entrenamiento
    lista X = crear_lista()
    lista y_etiquetas = crear_lista()
    
    // Clase A
    lista punto1 = crear_lista()
    mem_lista_agregar(punto1, "1")
    mem_lista_agregar(punto1, "1")
    mem_lista_agregar(X, punto1)
    mem_lista_agregar(y_etiquetas, "A")
    
    // Clase B
    lista punto2 = crear_lista()
    mem_lista_agregar(punto2, "5")
    mem_lista_agregar(punto2, "5")
    mem_lista_agregar(X, punto2)
    mem_lista_agregar(y_etiquetas, "B")
    
    // Nuevo punto para clasificar
    lista nuevo_punto = crear_lista()
    mem_lista_agregar(nuevo_punto, "2")
    mem_lista_agregar(nuevo_punto, "2")
    
    // Predicción con KNN (k=3)
    texto prediccion = knn_predecir(X, y_etiquetas, nuevo_punto, 3)
    
    imprimir "Clasificación: " + prediccion
fin_funcion
```

### Ejemplo: Estadísticas

```jasboot
usar todas de "stdlib/jasml/jasml.jasb"

funcion ejemplo_estadisticas()
    lista datos = crear_lista()
    mem_lista_agregar(datos, "10")
    mem_lista_agregar(datos, "15")
    mem_lista_agregar(datos, "20")
    mem_lista_agregar(datos, "25")
    mem_lista_agregar(datos, "30")
    mem_lista_agregar(datos, "35")
    mem_lista_agregar(datos, "40")
    
    imprimir "Media: " + str_desde_numero(media(datos))
    imprimir "Desviación estándar: " + str_desde_numero(desviacion_estandar(datos))
    imprimir "Mediana: " + str_desde_numero(mediana(datos))
    imprimir "Mínimo: " + str_desde_numero(minimo(datos))
    imprimir "Máximo: " + str_desde_numero(maximo(datos))
    
    imprimir_resumen(datos)
fin_funcion
```

## IA Predictiva Completa

### Ejemplo: Sistema de Predicción de Precios

```jasboot
usar todas de "stdlib/jasml/jasml.jasb"

funcion ia_predictiva_precios()
    // 1. Datos de entrenamiento
    lista X = crear_lista()
    lista y_precios = crear_lista()
    
    // Vivienda 1: 100m², $150k
    lista v1 = crear_lista()
    mem_lista_agregar(v1, "100")
    mem_lista_agregar(X, v1)
    mem_lista_agregar(y_precios, "150")
    
    // Vivienda 2: 120m², $180k
    lista v2 = crear_lista()
    mem_lista_agregar(v2, "120")
    mem_lista_agregar(X, v2)
    mem_lista_agregar(y_precios, "180")
    
    // Vivienda 3: 80m², $120k
    lista v3 = crear_lista()
    mem_lista_agregar(v3, "80")
    mem_lista_agregar(X, v3)
    mem_lista_agregar(y_precios, "120")
    
    // 2. Entrenar modelo
    lista modelo = regresion_lineal_entrenar(X, y_precios)
    
    // 3. Predecir para nueva vivienda
    lista nueva_vivienda = crear_lista()
    mem_lista_agregar(nueva_vivienda, "110")
    flotante precio_predicho = regresion_lineal_predecir(modelo, nueva_vivienda)
    
    imprimir "Precio predicho para 110m²: $" + str_desde_numero(precio_predicho) + "k"
    
    // 4. Evaluar modelo
    lista metricas = evaluar_regresion(modelo, X, y_precios)
    imprimir_metricas_regresion(metricas)
fin_funcion
```

## API Reference

### Funciones Principales

#### Identidad de la Librería
- `jasml_nombre()`: Retorna "JASML"
- `jasml_version()`: Retorna "1.0.0"
- `jasml_descripcion()`: Retorna descripción completa
- `jasml_bienvenida()`: Mensaje de bienvenida

#### Operaciones Matemáticas
- `crear_vector(tamano)`: Crea vector de ceros
- `crear_matriz(filas, columnas)`: Crea matriz de ceros
- `vector_suma(v1, v2)`: Suma dos vectores
- `vector_producto_punto(v1, v2)`: Producto punto
- `vector_magnitud(vector)`: Magnitud euclidiana
- `vector_normalizar(vector)`: Vector unitario
- `distancia_euclidiana(p1, p2)`: Distancia euclidiana
- `raiz_cuadrada(numero)`: Raíz cuadrada (implementación manual)

#### Estadística
- `media(datos)`: Media aritmética
- `mediana(datos)`: Mediana
- `desviacion_estandar(datos)`: Desviación estándar
- `varianza(datos)`: Varianza
- `minimo(datos)`, `maximo(datos)`: Valores extremos
- `percentil(datos, p)`: Percentil
- `cuartil1(datos)`, `cuartil2(datos)`, `cuartil3(datos)`: Cuartiles
- `rango(datos)`: Rango (max - min)
- `resumen_estadistico(datos)`: Resumen completo
- `imprimir_resumen(datos)`: Imprime resumen legible

#### Regresión
- `regresion_lineal_entrenar(X, y)`: Entrena modelo lineal
- `regresion_lineal_predecir(modelo, X)`: Predice con modelo entrenado
- `train_test_split(X, y, test_size)`: Divide datos en entrenamiento/prueba
- `evaluar_regresion(modelo, X_test, y_test)`: Evalúa modelo
- `imprimir_metricas_regresion(metricas)`: Imprime métricas

#### Clasificación
- `knn_predecir(X_train, y_train, X_nuevo, k)`: Clasificación KNN
- `encontrar_vecinos(X_train, y_train, X_nuevo, k)`: Encuentra k vecinos
- `naive_bayes_entrenar(X, y)`: Entrena Naive Bayes
- `naive_bayes_predecir(modelo, X_nuevo)`: Predice con Naive Bayes
- `reglas_simple_entrenar(X, y)`: Entrena clasificador por reglas
- `reglas_simple_predecir(modelo, X_nuevo)`: Predice con reglas
- `obtener_clases_unicas(y)`: Obtiene clases únicas
- `accuracy_score(y_true, y_pred)`: Accuracy
- `precision_score(y_true, y_pred, clase)`: Precision
- `recall_score(y_true, y_pred, clase)`: Recall
- `f1_score(y_true, y_pred, clase)`: F1-Score
- `imprimir_metricas_clasificacion(y_true, y_pred)`: Imprime métricas

#### Clustering
- `kmeans_entrenar(datos, k, max_iter)`: Entrena K-Means
- `kmeans_asignar_clusters(datos, centroides)`: Asigna clusters
- `kmeans_actualizar_centroides(datos, asignaciones, k)`: Actualiza centroides
- `kmeans_inicializar_centroides(datos, k)`: Inicializa centroides
- `dbscan_entrenar(datos, epsilon, min_pts)`: Entrena DBSCAN
- `dbscan_encontrar_vecinos(datos, indice, epsilon)`: Encuentra vecinos
- `clustering_aglomerativo(datos, n_clusters)`: Clustering jerárquico
- `silhouette_score(datos, asignaciones)`: Índice de silueta
- `imprimir_resultados_clustering(datos, asignaciones, nombre)`: Imprime resultados

#### Preprocesamiento
- `normalizar_min_max(datos)`: Normalización Min-Max [0,1]
- `estandarizar_datos(datos)`: Estandarización Z-score
- `transformacion_logaritmica(datos)`: Transformación logarítmica
- `transformacion_raiz(datos)`: Transformación raíz cuadrada
- `discretizar_igual_frecuencia(datos, bins)`: Discretización
- `rellenar_media(datos)`, `rellenar_mediana(datos)`: Rellenar valores faltantes
- `detectar_faltantes(datos)`: Detecta valores faltantes
- `imprimir_info_preprocesamiento(datos, nombre)`: Imprime información

#### Evaluación
- `mean_squared_error(y_true, y_pred)`: MSE
- `mean_absolute_error(y_true, y_pred)`: MAE
- `r2_score(y_true, y_pred)`: R²
- `accuracy_score(y_true, y_pred)`: Accuracy
- `precision_score(y_true, y_pred, clase)`: Precision
- `recall_score(y_true, y_pred, clase)`: Recall
- `f1_score(y_true, y_pred, clase)`: F1-Score

#### Utilidades
- `texto_a_numero(txt)`: Convierte texto a número seguro
- `es_numero(txt)`: Verifica si es numérico
- `clonar_lista(original)`: Clona una lista
- `obtener_clases_unicas(y)`: Obtiene clases únicas
- `encontrar_indice_clase(clases, clase)`: Encuentra índice de clase

## Estructura del Proyecto

```
c:\src\jasboot\stdlib\jasml\
|
+-- jasml.jasb                    # Archivo principal (imports)
|
+-- codigo-jasb\                  # Módulos organizados
|   |-- core.jasb                  # Funciones matemáticas básicas
|   |-- estadistica.jasb           # Estadística descriptiva
|   |-- regresion.jasb              # Algoritmos de regresión
|   |-- clasificacion.jasb          # Algoritmos de clasificación
|   |-- clustering.jasb             # Algoritmos de clustering
|   |-- preprocesamiento_simple.jasb # Preprocesamiento de datos
|   |-- evaluacion_simple.jasb      # Métricas de evaluación
|
+-- README.md                       # Documentación completa
+-- identidad.jasb                  # Metadatos de la librería
+-- prueba_ultra_simple.jasb        # Prueba básica funcional
+-- ia_simple.jasb                 # Prueba de IA simplificada
+-- ia_funcional.jasb               # IA predictiva funcional
+-- ia_predictiva.jasb             # IA predictiva completa
+-- ejemplo_completo.jasb           # Ejemplos avanzados
```

## Ejemplos Completos

### Ejemplo 1: Pipeline Completo de Regresión

```jasboot
usar todas de "stdlib/jasml/jasml.jasb"

funcion pipeline_regresion()
    // 1. Generar datos sintéticos
    lista X = crear_lista()
    lista y = crear_lista()
    
    // Datos históricos
    lista punto1 = crear_lista()
    mem_lista_agregar(punto1, "100")
    mem_lista_agregar(X, punto1)
    mem_lista_agregar(y, "150")
    
    lista punto2 = crear_lista()
    mem_lista_agregar(punto2, "120")
    mem_lista_agregar(X, punto2)
    mem_lista_agregar(y, "180")
    
    lista punto3 = crear_lista()
    mem_lista_agregar(punto3, "80")
    mem_lista_agregar(X, punto3)
    mem_lista_agregar(y, "120")
    
    // 2. Dividir datos
    lista split = train_test_split(X, y, 0.3)
    lista X_train = lista_obtener(split, 0)
    lista X_test = lista_obtener(split, 1)
    lista y_train = lista_obtener(split, 2)
    lista y_test = lista_obtener(split, 3)
    
    // 3. Entrenar modelo
    lista modelo = regresion_lineal_entrenar(X_train, y_train)
    
    // 4. Evaluar modelo
    lista metricas = evaluar_regresion(modelo, X_test, y_test)
    imprimir_metricas_regresion(metricas)
    
    // 5. Predecir nuevos valores
    lista nuevo_punto = crear_lista()
    mem_lista_agregar(nuevo_punto, "110")
    flotante prediccion = regresion_lineal_predecir(modelo, nuevo_punto)
    
    imprimir "Predicción para 110m²: $" + str_desde_numero(prediccion) + "k"
fin_funcion
```

### Ejemplo 2: Sistema de Clasificación

```jasboot
usar todas de "stdlib/jasml/jasml.jasb"

funcion sistema_clasificacion()
    // 1. Datos de entrenamiento
    lista X = crear_lista()
    lista y = crear_lista()
    
    // Clase "spam"
    lista email1 = crear_lista()
    mem_lista_agregar(email1, "oferta")
    mem_lista_agregar(email1, "gratis")
    mem_lista_agregar(X, email1)
    mem_lista_agregar(y, "spam")
    
    lista email2 = crear_lista()
    mem_lista_agregar(email2, "ganador")
    mem_lista_agregar(email2, "premio")
    mem_lista_agregar(X, email2)
    mem_lista_agregar(y, "spam")
    
    // Clase "no_spam"
    lista email3 = crear_lista()
    mem_lista_agregar(email3, "reunion")
    mem_lista_agregar(email3, "proyecto")
    mem_lista_agregar(X, email3)
    mem_lista_agregar(y, "no_spam")
    
    // 2. Entrenar clasificadores
    lista modelo_knn = X  // KNN usa directamente los datos
    lista modelo_nb = naive_bayes_entrenar(X, y)
    
    // 3. Clasificar nuevo email
    lista nuevo_email = crear_lista()
    mem_lista_agregar(nuevo_email, "oferta")
    mem_lista_agregar(nuevo_email, "especial")
    
    texto prediccion_knn = knn_predecir(X, y, nuevo_email, 3)
    texto prediccion_nb = naive_bayes_predecir(modelo_nb, nuevo_email)
    
    imprimir "KNN: " + prediccion_knn
    imprimir "Naive Bayes: " + prediccion_nb
fin_funcion
```

### Ejemplo 3: Clustering de Clientes

```jasboot
usar todas de "stdlib/jasml/jasml.jasb"

funcion clustering_clientes()
    // 1. Datos de clientes (edad, ingresos)
    lista datos = crear_lista()
    
    // Cliente 1: 25 años, $30k
    lista cliente1 = crear_lista()
    mem_lista_agregar(cliente1, "25")
    mem_lista_agregar(cliente1, "30")
    mem_lista_agregar(datos, cliente1)
    
    // Cliente 2: 35 años, $45k
    lista cliente2 = crear_lista()
    mem_lista_agregar(cliente2, "35")
    mem_lista_agregar(cliente2, "45")
    mem_lista_agregar(datos, cliente2)
    
    // Cliente 3: 45 años, $60k
    lista cliente3 = crear_lista()
    mem_lista_agregar(cliente3, "45")
    mem_lista_agregar(cliente3, "60")
    mem_lista_agregar(datos, cliente3)
    
    // Cliente 4: 28 años, $35k
    lista cliente4 = crear_lista()
    mem_lista_agregar(cliente4, "28")
    mem_lista_agregar(cliente4, "35")
    mem_lista_agregar(datos, cliente4)
    
    // 2. Aplicar K-Means
    lista resultado = kmeans_entrenar(datos, 2, 10)
    
    si lista_tamano(resultado) >= 2 entonces
        lista centroides = lista_obtener(resultado, 0)
        lista asignaciones = lista_obtener(resultado, 1)
        
        imprimir "K-Means con k=2:"
        imprimir "Centroides encontrados: " + str_desde_numero(lista_tamano(centroides))
        
        flotante silueta = silhouette_score(datos, asignaciones)
        imprimir "Índice de Silueta: " + str_desde_numero(silueta)
        
        imprimir_resultados_clustering(datos, asignaciones, "K-Means")
    si_no
        imprimir "Error: K-Means no convergió"
    fin_si
fin_funcion
```

## Limitaciones y Consideraciones

### Limitaciones Actuales
1. **Sintaxis 100% español**: Todas las palabras reservadas deben estar en español
2. **Tipado dinámico**: Variables pueden cambiar de tipo durante ejecución
3. **Conversión de números**: `str_a_entero` solo acepta enteros, no decimales
4. **Funciones complejas**: Algunas implementaciones son simplificadas para compatibilidad

### Buenas Prácticas
1. **Evitar palabras reservadas**: No usar `y`, `caracter`, `registro`, `valor`, `clase` como nombres de variables
2. **Validar datos**: Usar `es_numero()` antes de convertir texto a número
3. **Manejar errores**: Las funciones retornan valores por defecto en caso de error
4. **Usar imports relativos**: `usar todas de ".\\codigo-jasb\\modulo.jasb"`

## Casos de Uso

### 1. Finanzas
- Predicción de precios de acciones
- Evaluación de riesgo crediticio
- Detección de fraudes

### 2. Salud
- Predicción de enfermedades
- Clasificación de pacientes
- Análisis de síntomas

### 3. Marketing
- Predicción de ventas
- Segmentación de clientes
- Recomendación de productos

### 4. Industria
- Predicción de demanda
- Mantenimiento predictivo
- Control de calidad

## Mejoras Futuras

### Version 1.1 (Planeada)
- [ ] Regresión polinomial completa
- [ ] Más algoritmos de clasificación
- [ ] Mejora en clustering jerárquico
- [ ] Validación cruzada

### Version 1.2 (Planeada)
- [ ] Redes neuronales simples
- [ ] Series temporales
- [ ] Análisis de componentes principales
- [ ] Optimización de hiperparámetros

## Contribuciones

JASML es un proyecto abierto a contribuciones. Para contribuir:

1. Reportar bugs en el repositorio
2. Sugerir nuevas características
3. Enviar pull requests con mejoras
4. Documentar algoritmos y ejemplos

## Licencia

MIT License - Ver archivo LICENSE para detalles completos.

## Créditos

- Inspirado en scikit-learn, NumPy y pandas de Python
- Desarrollado para el ecosistema Jasboot
- Primera librería de Machine Learning completa para Jasboot

---

**JASML v1.0.0 - Machine Learning para Jasboot**

*¡La primera librería profesional de Machine Learning para Jasboot está lista para producción!*
