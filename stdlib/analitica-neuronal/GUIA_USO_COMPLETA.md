# 📚 GUÍA COMPLETA DE USO - Biblioteca Analítica-Neuronal Jasboot

**Versión:** 2.0  
**Última actualización:** Diciembre 2024  
**Estado:** ✅ Completa y Funcional

---

## 📋 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Instalación e Importación](#instalación-e-importación)
3. [Módulos Disponibles](#módulos-disponibles)
4. [Ejemplos Básicos](#ejemplos-básicos)
5. [Casos de Uso Avanzados](#casos-de-uso-avanzados)
6. [Referencia Rápida](#referencia-rápida)
7. [Mejores Prácticas](#mejores-prácticas)
8. [Solución de Problemas](#solución-de-problemas)

---

## 🎯 Introducción

La **Biblioteca Analítica-Neuronal de Jasboot** es una implementación completa de algoritmos de Machine Learning, Estadística y Análisis de Datos en español. Es comparable a scikit-learn básico y proporciona todas las herramientas necesarias para:

- Análisis estadístico completo
- Machine Learning (clasificación, regresión, clustering)
- Validación de modelos
- Preprocesamiento de datos
- Series temporales
- Evaluación de modelos con métricas

### ✅ Características Principales:

- 🔢 **Estadística completa**: Media, desviación, percentiles, correlación
- 🤖 **ML Avanzado**: Árboles, Random Forest, SVM, Redes Neuronales
- 📊 **Métricas**: MAE, RMSE, R², Accuracy, Precision, F1, Silhouette
- ✔️ **Validación**: Train/Test Split, K-Fold Cross Validation
- 🔧 **Preprocesamiento**: Normalización, PCA, Feature Selection
- 📈 **Series Temporales**: ARIMA completo

---

## 🚀 Instalación e Importación

### Importación Completa (Fachada Global)

```jasboot
usar todas de "stdlib/analitica-neuronal/analitica.jasb"

principal
    # Ahora tienes acceso a g_analitica con todos los módulos
    flotante media = g_analitica.estadistica.calcular_media_aritmetica(datos)
fin_principal
```

### Importación Modular

```jasboot
# Solo estadística
usar todas de "stdlib/analitica-neuronal/estadistica/estadistica_descriptiva.jasb"

# Solo machine learning
usar todas de "stdlib/analitica-neuronal/machine_learning/algoritmos_ml.jasb"

# Solo métricas
usar todas de "stdlib/analitica-neuronal/metricas/metricas_regresion.jasb"
```

---

## 📦 Módulos Disponibles

### 1. **Estadística Descriptiva** (`estadistica`)

```jasboot
# Media, mediana, moda
flotante media = g_analitica.estadistica.calcular_media_aritmetica(datos)
flotante mediana = g_analitica.estadistica.calcular_mediana(datos)

# Varianza y desviación estándar
flotante varianza = g_analitica.estadistica.calcular_varianza(datos, verdadero)
flotante desv_std = g_analitica.estadistica.calcular_desviacion_estandar(datos)

# Percentiles y cuartiles
flotante q1 = g_analitica.estadistica.calcular_percentil(datos, 25)
flotante q3 = g_analitica.estadistica.calcular_percentil(datos, 75)

# Detección de valores atípicos
lista outliers = g_analitica.estadistica.detectar_valores_atipicos(datos, 1.5)

# Resumen completo
mapa resumen = g_analitica.estadistica.resumen_estadistico_completo(datos)
```

### 2. **Probabilidad** (`probabilidad`)

```jasboot
# Distribución Normal
flotante pdf = g_analitica.probabilidad.normal_pdf(x, mu, sigma)
flotante cdf = g_analitica.probabilidad.normal_cdf(x, mu, sigma)

# Distribución Binomial
flotante prob = g_analitica.probabilidad.binomial_pmf(k, n, p)

# Distribución de Poisson
flotante prob_poisson = g_analitica.probabilidad.poisson_pmf(k, lambda)
```

### 3. **Regresión** (`prediccion`)

```jasboot
# Regresión Lineal Simple: y = mx + b
lista X = crear_lista()  # Variable independiente
lista y = crear_lista()  # Variable dependiente

mapa modelo = g_analitica.prediccion.regresion_lineal_simple(X, y)
flotante pendiente = mapa_obtener(modelo, "pendiente")
flotante intercepto = mapa_obtener(modelo, "intercepto")
flotante r2 = mapa_obtener(modelo, "r2")

# Predicción
flotante prediccion = g_analitica.prediccion.predecir_simple(modelo, nuevo_x)

# Regresión Lineal Múltiple
lista X_matriz = crear_lista()  # [[x1, x2], [x3, x4], ...]
mapa modelo_multi = g_analitica.prediccion.regresion_lineal_multiple(X_matriz, y)
```

### 4. **Machine Learning** (`ml`)

```jasboot
# K-Means Clustering
mapa resultado = g_analitica.ml.kmeans_simple(datos, n_clusters, max_iter, seed)
lista centroides = mapa_obtener(resultado, "centroides")
lista asignaciones = mapa_obtener(resultado, "asignaciones")

# KNN (K-Nearest Neighbors)
lista predicciones = g_analitica.ml.knn_simple(X_train, y_train, X_test, k)

# Regresión Logística
mapa modelo_log = g_analitica.ml.regresion_logistica_simple(X, y, lr, epochs)
```

### 5. **Árboles de Decisión** (`arboles`)

```jasboot
# Árbol de Decisión para Clasificación
mapa arbol = g_analitica.arboles.arbol_decision_clasificacion_fit(X, y, max_profundidad)
lista predicciones = g_analitica.arboles.arbol_decision_predecir_batch(arbol, X_test)

# Árbol de Decisión para Regresión
mapa arbol_reg = g_analitica.arboles.arbol_decision_regresion_fit(X, y, max_profundidad)
```

### 6. **Random Forest** (`random_forest`)

```jasboot
# Random Forest
mapa rf = g_analitica.random_forest.random_forest_fit(X_train, y_train, n_arboles, max_profundidad)
lista pred_rf = g_analitica.random_forest.random_forest_predecir_batch(rf, X_test)
```

### 7. **SVM** (`svm`)

```jasboot
# Support Vector Machine
mapa modelo_svm = g_analitica.svm.svm_lineal_fit(X_train, y_train, C, lr, max_iter)
lista pred_svm = g_analitica.svm.svm_predecir_batch(modelo_svm, X_test)
```

### 8. **Redes Neuronales** (`redes`)

```jasboot
# MLP (Multi-Layer Perceptron)
lista capas = crear_lista()
lista_agregar(capas, 10)  # 10 neuronas en capa oculta 1
lista_agregar(capas, 5)   # 5 neuronas en capa oculta 2

mapa mlp = g_analitica.redes.mlp_fit(X_train, y_train, capas, lr, epochs)
lista pred_mlp = g_analitica.redes.mlp_predecir_batch(mlp, X_test)
```

### 9. **Validación** (`validacion`)

```jasboot
# Train/Test Split
mapa split = g_analitica.validacion.train_test_split(X, y, test_size, seed)
lista X_train = mapa_obtener(split, "X_train")
lista X_test = mapa_obtener(split, "X_test")
lista y_train = mapa_obtener(split, "y_train")
lista y_test = mapa_obtener(split, "y_test")

# K-Fold Cross Validation
lista folds = g_analitica.validacion.k_fold_split(X, y, n_folds, seed)
```

### 10. **Normalización** (`normalizacion`)

```jasboot
# Min-Max Scaling (0 a 1)
mapa scaler = g_analitica.normalizacion.min_max_scaler_fit(X_train)
lista X_norm = g_analitica.normalizacion.min_max_scaler_transform(X_train, scaler)
lista X_test_norm = g_analitica.normalizacion.min_max_scaler_transform(X_test, scaler)

# Standard Scaling (Z-score)
mapa std_scaler = g_analitica.normalizacion.standard_scaler_fit(X_train)
lista X_std = g_analitica.normalizacion.standard_scaler_transform(X_train, std_scaler)

# Robust Scaling (resistente a outliers)
mapa rob_scaler = g_analitica.normalizacion.robust_scaler_fit(X_train)
lista X_rob = g_analitica.normalizacion.robust_scaler_transform(X_train, rob_scaler)
```

### 11. **PCA (Reducción de Dimensionalidad)** (`reduccion_dim`)

```jasboot
usar todas de "stdlib/analitica-neuronal/preprocesamiento/reduccion_dim.jasb"

ReduccionDimensionalidad pca_obj = ReduccionDimensionalidad()
pca_obj.inicializar()

# Ajustar PCA
mapa pca_modelo = pca_obj.pca_fit(X_matriz, n_componentes)

# Transformar datos
lista X_reducido = pca_obj.pca_transform(X_matriz, pca_modelo)

# Ver varianza explicada
mapa var_info = pca_obj.varianza_explicada_acumulada(pca_modelo)
```

### 12. **Métricas de Regresión** (`metricas_reg`)

```jasboot
# MAE (Mean Absolute Error)
flotante mae = g_analitica.metricas_reg.calcular_mae(y_real, y_pred)

# MSE (Mean Squared Error)
flotante mse = g_analitica.metricas_reg.calcular_mse(y_real, y_pred)

# RMSE (Root Mean Squared Error)
flotante rmse = g_analitica.metricas_reg.calcular_rmse(y_real, y_pred)

# R² Score
flotante r2 = g_analitica.metricas_reg.calcular_r2_score(y_real, y_pred)

# MAPE (Mean Absolute Percentage Error)
flotante mape = g_analitica.metricas_reg.calcular_mape(y_real, y_pred)

# Informe completo
mapa informe = g_analitica.metricas_reg.informe_metricas_regresion(y_real, y_pred)
```

### 13. **Métricas de Clasificación** (`metricas_clf`)

```jasboot
# Accuracy
flotante accuracy = g_analitica.metricas_clf.calcular_accuracy(y_true, y_pred)

# Precision
flotante precision = g_analitica.metricas_clf.calcular_precision(y_true, y_pred, clase_positiva)

# Recall
flotante recall = g_analitica.metricas_clf.calcular_recall(y_true, y_pred, clase_positiva)

# F1-Score
flotante f1 = g_analitica.metricas_clf.calcular_f1_score(y_true, y_pred, clase_positiva)

# Matriz de Confusión
mapa matriz = g_analitica.metricas_clf.matriz_confusion(y_true, y_pred)
```

### 14. **Métricas de Clustering** (`metricas_clustering`)

```jasboot
usar todas de "stdlib/analitica-neuronal/metricas/metricas_clustering.jasb"

MetricasClustering metricas = MetricasClustering()
metricas.inicializar()

# Silhouette Score
flotante silhouette = metricas.calcular_silhouette_score(X, labels)

# Davies-Bouldin Index
flotante db = metricas.calcular_davies_bouldin_index(X, labels)

# Calinski-Harabasz Score
flotante ch = metricas.calcular_calinski_harabasz_score(X, labels)
```

### 15. **Series Temporales - ARIMA** (`series_temporales`)

```jasboot
# Modelo ARIMA(p, d, q)
mapa arima = g_analitica.series_temporales.arima_fit(datos_historicos, p, d, q)

# Predicción futura
lista forecast = g_analitica.series_temporales.arima_forecast(arima, n_pasos)

# Suavizamiento exponencial
lista suavizado = g_analitica.series_temporales.suavizamiento_exponencial(datos, alpha)
```

---

## 💡 Ejemplos Básicos

### Ejemplo 1: Análisis Estadístico Completo

```jasboot
usar todas de "stdlib/analitica-neuronal/analitica.jasb"

principal
    # Datos de ventas mensuales
    lista ventas = crear_lista()
    lista_agregar(ventas, 1200.0)
    lista_agregar(ventas, 1350.0)
    lista_agregar(ventas, 1180.0)
    lista_agregar(ventas, 1420.0)
    lista_agregar(ventas, 1550.0)
    
    # Calcular estadísticas
    flotante media = g_analitica.estadistica.calcular_media_aritmetica(ventas)
    flotante mediana = g_analitica.estadistica.calcular_mediana(ventas)
    flotante desv_std = g_analitica.estadistica.calcular_desviacion_estandar(ventas)
    
    imprimir "Media de ventas: " + str_desde_numero(media)
    imprimir "Mediana: " + str_desde_numero(mediana)
    imprimir "Desviación estándar: " + str_desde_numero(desv_std)
    
    # Detectar valores atípicos
    lista outliers = g_analitica.estadistica.detectar_valores_atipicos(ventas, 1.5)
    imprimir "Valores atípicos detectados: " + str_desde_numero(lista_tamano(outliers))
fin_principal
```

### Ejemplo 2: Predicción con Regresión Lineal

```jasboot
usar todas de "stdlib/analitica-neuronal/analitica.jasb"

principal
    # Datos: Experiencia (años) vs Salario (miles)
    lista experiencia = crear_lista()
    lista_agregar(experiencia, 1.0)
    lista_agregar(experiencia, 2.0)
    lista_agregar(experiencia, 3.0)
    lista_agregar(experiencia, 5.0)
    lista_agregar(experiencia, 8.0)
    
    lista salario = crear_lista()
    lista_agregar(salario, 25.0)
    lista_agregar(salario, 30.0)
    lista_agregar(salario, 35.0)
    lista_agregar(salario, 45.0)
    lista_agregar(salario, 60.0)
    
    # Entrenar modelo
    mapa modelo = g_analitica.prediccion.regresion_lineal_simple(experiencia, salario)
    
    # Ver parámetros
    flotante pendiente = mapa_obtener(modelo, "pendiente")
    flotante intercepto = mapa_obtener(modelo, "intercepto")
    flotante r2 = mapa_obtener(modelo, "r2")
    
    imprimir "Ecuación: Salario = " + str_desde_numero(pendiente) + " * Experiencia + " + str_desde_numero(intercepto)
    imprimir "R² = " + str_desde_numero(r2)
    
    # Predecir salario para 10 años de experiencia
    flotante prediccion = g_analitica.prediccion.predecir_simple(modelo, 10.0)
    imprimir "Salario predicho para 10 años: " + str_desde_numero(prediccion) + "k"
fin_principal
```

### Ejemplo 3: Validación de Modelo

```jasboot
usar todas de "stdlib/analitica-neuronal/analitica.jasb"

principal
    # Crear dataset
    lista X = crear_lista()
    lista y = crear_lista()
    entero i = 0
    mientras i < 100 hacer
        flotante x_val = i + 0.0
        flotante y_val = (2.0 * x_val) + 5.0 + (aleatorio() * 2.0 - 1.0)
        lista_agregar(X, x_val)
        lista_agregar(y, y_val)
        i = i + 1
    fin_mientras
    
    # Split train/test
    mapa split = g_analitica.validacion.train_test_split(X, y, 0.2, 42)
    lista X_train = mapa_obtener(split, "X_train")
    lista X_test = mapa_obtener(split, "X_test")
    lista y_train = mapa_obtener(split, "y_train")
    lista y_test = mapa_obtener(split, "y_test")
    
    # Entrenar en train
    mapa modelo = g_analitica.prediccion.regresion_lineal_simple(X_train, y_train)
    
    # Predecir en test
    lista y_pred = crear_lista()
    entero j = 0
    mientras j < lista_tamano(X_test) hacer
        flotante x = lista_obtener(X_test, j)
        flotante pred = g_analitica.prediccion.predecir_simple(modelo, x)
        lista_agregar(y_pred, pred)
        j = j + 1
    fin_mientras
    
    # Evaluar
    flotante mae = g_analitica.metricas_reg.calcular_mae(y_test, y_pred)
    flotante r2 = g_analitica.metricas_reg.calcular_r2_score(y_test, y_pred)
    
    imprimir "MAE en test: " + str_desde_numero(mae)
    imprimir "R² en test: " + str_desde_numero(r2)
fin_principal
```

### Ejemplo 4: Clustering con K-Means

```jasboot
usar todas de "stdlib/analitica-neuronal/analitica.jasb"

principal
    # Datos de clientes: [edad1, edad2, edad3, ...]
    lista edades = crear_lista()
    lista_agregar(edades, 25.0)
    lista_agregar(edades, 28.0)
    lista_agregar(edades, 45.0)
    lista_agregar(edades, 48.0)
    lista_agregar(edades, 65.0)
    lista_agregar(edades, 68.0)
    
    # Agrupar en 3 segmentos
    mapa resultado = g_analitica.ml.kmeans_simple(edades, 3, 100, 42)
    
    lista centroides = mapa_obtener(resultado, "centroides")
    lista asignaciones = mapa_obtener(resultado, "asignaciones")
    
    imprimir "Centroides encontrados:"
    entero i = 0
    mientras i < lista_tamano(centroides) hacer
        flotante c = lista_obtener(centroides, i)
        imprimir "  Cluster " + str_desde_numero(i) + ": " + str_desde_numero(c)
        i = i + 1
    fin_mientras
fin_principal
```

---

## 🔥 Casos de Uso Avanzados

### Caso 1: Pipeline Completo de ML

```jasboot
usar todas de "stdlib/analitica-neuronal/analitica.jasb"

principal
    imprimir "=== PIPELINE COMPLETO DE MACHINE LEARNING ==="
    imprimir ""
    
    # 1. Cargar/crear datos
    imprimir "1. Preparando datos..."
    lista X = crear_lista()
    lista y = crear_lista()
    # ... llenar con datos reales ...
    
    # 2. Split train/test
    imprimir "2. Dividiendo en train/test (80/20)..."
    mapa split = g_analitica.validacion.train_test_split(X, y, 0.2, 42)
    lista X_train = mapa_obtener(split, "X_train")
    lista X_test = mapa_obtener(split, "X_test")
    lista y_train = mapa_obtener(split, "y_train")
    lista y_test = mapa_obtener(split, "y_test")
    
    # 3. Normalización
    imprimir "3. Normalizando datos..."
    mapa scaler = g_analitica.normalizacion.min_max_scaler_fit(X_train)
    lista X_train_norm = g_analitica.normalizacion.min_max_scaler_transform(X_train, scaler)
    lista X_test_norm = g_analitica.normalizacion.min_max_scaler_transform(X_test, scaler)
    
    # 4. Entrenamiento
    imprimir "4. Entrenando modelo..."
    mapa modelo = g_analitica.prediccion.regresion_lineal_simple(X_train_norm, y_train)
    
    # 5. Predicción
    imprimir "5. Realizando predicciones..."
    lista y_pred = crear_lista()
    entero i = 0
    mientras i < lista_tamano(X_test_norm) hacer
        flotante x = lista_obtener(X_test_norm, i)
        flotante pred = g_analitica.prediccion.predecir_simple(modelo, x)
        lista_agregar(y_pred, pred)
        i = i + 1
    fin_mientras
    
    # 6. Evaluación
    imprimir "6. Evaluando modelo..."
    mapa metricas = g_analitica.metricas_reg.informe_metricas_regresion(y_test, y_pred)
    
    flotante mae = mapa_obtener(metricas, "mae")
    flotante rmse = mapa_obtener(metricas, "rmse")
    flotante r2 = mapa_obtener(metricas, "r2_score")
    
    imprimir ""
    imprimir "=== RESULTADOS ==="
    imprimir "MAE:  " + str_desde_numero(mae)
    imprimir "RMSE: " + str_desde_numero(rmse)
    imprimir "R²:   " + str_desde_numero(r2)
fin_principal
```

### Caso 2: Comparación de Modelos

```jasboot
usar todas de "stdlib/analitica-neuronal/analitica.jasb"

principal
    # Datos
    lista X_train = crear_lista()
    lista y_train = crear_lista()
    lista X_test = crear_lista()
    lista y_test = crear_lista()
    # ... llenar datos ...
    
    # Modelo 1: Regresión Lineal
    mapa modelo1 = g_analitica.prediccion.regresion_lineal_simple(X_train, y_train)
    lista y_pred1 = crear_lista()
    # ... generar predicciones ...
    
    # Modelo 2: (otro modelo)
    # ...
    
    # Comparar
    mapa comparacion = g_analitica.metricas_reg.comparar_modelos(
        y_test, 
        y_pred1, 
        y_pred2,
        "Regresión Lineal",
        "Otro Modelo"
    )
    
    texto mejor = mapa_obtener(comparacion, "mejor_modelo")
    imprimir "Mejor modelo: " + mejor
fin_principal
```

### Caso 3: Cross Validation

```jasboot
usar todas de "stdlib/analitica-neuronal/analitica.jasb"

principal
    lista X = crear_lista()
    lista y = crear_lista()
    # ... datos ...
    
    # K-Fold Cross Validation (5 folds)
    lista folds = g_analitica.validacion.k_fold_split(X, y, 5, 42)
    
    lista scores = crear_lista()
    entero fold_idx = 0
    mientras fold_idx < lista_tamano(folds) hacer
        mapa fold = lista_obtener(folds, fold_idx)
        
        lista X_train = mapa_obtener(fold, "X_train")
        lista y_train = mapa_obtener(fold, "y_train")
        lista X_val = mapa_obtener(fold, "X_val")
        lista y_val = mapa_obtener(fold, "y_val")
        
        # Entrenar y evaluar
        mapa modelo = g_analitica.prediccion.regresion_lineal_simple(X_train, y_train)
        # ... predecir y calcular score ...
        
        fold_idx = fold_idx + 1
    fin_mientras
    
    # Calcular score promedio
    flotante score_medio = g_analitica.estadistica.calcular_media_aritmetica(scores)
    imprimir "Score promedio CV: " + str_desde_numero(score_medio)
fin_principal
```

---

## 📖 Referencia Rápida

### Cheatsheet de Funciones Más Usadas

| Categoría | Función | Descripción |
|-----------|---------|-------------|
| **Estadística** | `calcular_media_aritmetica(datos)` | Media de los datos |
| | `calcular_desviacion_estandar(datos)` | Desviación estándar |
| | `calcular_mediana(datos)` | Mediana |
| **Regresión** | `regresion_lineal_simple(X, y)` | Ajustar y = mx + b |
| | `predecir_simple(modelo, x)` | Predecir nuevo valor |
| **ML** | `kmeans_simple(datos, k, max_iter, seed)` | Clustering K-Means |
| | `knn_simple(X_train, y_train, X_test, k)` | K-Nearest Neighbors |
| **Validación** | `train_test_split(X, y, test_size, seed)` | Dividir train/test |
| | `k_fold_split(X, y, n_folds, seed)` | K-Fold CV |
| **Normalización** | `min_max_scaler_fit(X)` | Crear scaler 0-1 |
| | `min_max_scaler_transform(X, scaler)` | Normalizar datos |
| **Métricas Reg** | `calcular_mae(y_real, y_pred)` | Error absoluto medio |
| | `calcular_rmse(y_real, y_pred)` | RMSE |
| | `calcular_r2_score(y_real, y_pred)` | R² |
| **Métricas Clf** | `calcular_accuracy(y_true, y_pred)` | Accuracy |
| | `calcular_f1_score(y_true, y_pred, clase)` | F1-Score |

---

## ✨ Mejores Prácticas

### 1. **Siempre Valida tus Modelos**

❌ **MAL:**
```jasboot
mapa modelo = g_analitica.prediccion.regresion_lineal_simple(X, y)
# Sin validación, no sabes si funciona bien
```

✅ **BIEN:**
```jasboot
mapa split = g_analitica.validacion.train_test_split(X, y, 0.2, 42)
mapa modelo = g_analitica.prediccion.regresion_lineal_simple(split.X_train, split.y_train)
# Evaluar en test set...
```

### 2. **Normaliza los Datos**

❌ **MAL:**
```jasboot
# Datos sin normalizar [1, 100, 10000] pueden sesgar algoritmos
mapa resultado = g_analitica.ml.kmeans_simple(datos_sin_normalizar, 3, 100, 42)
```

✅ **BIEN:**
```jasboot
mapa scaler = g_analitica.normalizacion.min_max_scaler_fit(datos)
lista datos_norm = g_analitica.normalizacion.min_max_scaler_transform(datos, scaler)
mapa resultado = g_analitica.ml.kmeans_simple(datos_norm, 3, 100, 42)
```

### 3. **Usa Múltiples Métricas**

✅ **BIEN:**
```jasboot
flotante mae = g_analitica.metricas_reg.calcular_mae(y_test, y_pred)
flotante rmse = g_analitica.metricas_reg.calcular_rmse(y_test, y_pred)
flotante r2 = g_analitica.metricas_reg.calcular_r2_score(y_test, y_pred)
# Analiza múltiples métricas para decisión robusta
```

### 4. **Semillas Aleatorias para Reproducibilidad**

✅ **BIEN:**
```jasboot
# Usar siempre el mismo seed para resultados reproducibles
mapa split = g_analitica.validacion.train_test_split(X, y, 0.2, 42)
mapa km