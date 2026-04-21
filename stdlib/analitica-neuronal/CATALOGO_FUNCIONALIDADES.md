# 📖 Catálogo de Funcionalidades - Analítica Neuronal Jasboot

Este catálogo detalla todas las clases y funciones públicas disponibles en la librería de Analítica Neuronal, organizadas por módulos.

---

## 📂 Módulo: Estadística
### 📄 `estadistica/estadistica_descriptiva.jasb`
**Clase: `EstadisticaDescriptiva`**
Proporciona métodos para el análisis estadístico descriptivo de conjuntos de datos numéricos.

- `inicializar()`: Inicializa el analizador.
- `validar_datos_numericos(lista datos)`: Verifica que todos los elementos sean números válidos.
- `ordenar_datos(lista datos)`: Ordena una lista numérica en orden ascendente.
- `calcular_media_aritmetica(lista datos)`: Calcula el promedio de un conjunto de datos.
- `calcular_media_geometrica(lista datos)`: Calcula la media geométrica (útil para tasas).
- `calcular_media_armonica(lista datos)`: Calcula la media armónica (útil para velocidades).
- `calcular_mediana(lista datos)`: Calcula el valor central del conjunto ordenado.
- `calcular_moda(lista datos)`: Encuentra el valor o valores más frecuentes.
- `calcular_varianza(lista datos, bool es_muestra)`: Calcula la dispersión cuadrática.
- `calcular_desviacion_estandar(lista datos, bool es_muestra)`: Raíz cuadrada de la varianza.
- `calcular_rango(lista datos)`: Diferencia entre el valor máximo y mínimo.
- `calcular_rango_intercuartilico(lista datos)`: Dispersión del 50% central de los datos.
- `calcular_coeficiente_variacion(lista datos)`: Variabilidad relativa en porcentaje.
- `calcular_percentil(lista datos, flotante percentil)`: Valor bajo el cual cae un porcentaje de datos.
- `calcular_cuartil(lista datos, entero num_cuartil)`: Calcula Q1, Q2 (mediana) o Q3.
- `calcular_decil(lista datos, entero num_decil)`: Calcula los deciles (1-10).
- `calcular_asimetria(lista datos)`: Mide la asimetría de la distribución.
- `calcular_curtosis(lista datos)`: Mide el achatamiento de la distribución.
- `resumen_estadistico_completo(lista datos)`: Genera un mapa con las principales estadísticas.
- `resumen_cinco_numeros(lista datos)`: Mínimo, Q1, Mediana, Q3 y Máximo.
- `detectar_valores_atipicos(lista datos, flotante factor)`: Identifica valores fuera de rango usando el criterio IQR.

---

## 📂 Módulo: Probabilidad
### 📄 `probabilidad/probabilidad_basica.jasb`
**Clase: `Probabilidad`**
Implementa funciones combinatorias y distribuciones de probabilidad.

- `factorial(entero n)`: Calcula el factorial de un número.
- `combinaciones(entero n, entero k)`: Calcula combinaciones C(n, k).
- `binomial_pmf(entero k, entero n, flotante p)`: Función de masa de probabilidad binomial.
- `poisson_pmf(entero k, flotante lambda)`: Función de masa de probabilidad de Poisson.
- `normal_pdf(flotante x, flotante mu, flotante sigma)`: Función de densidad de probabilidad Normal.
- `normal_cdf(flotante x, flotante mu, flotante sigma)`: Función de distribución acumulada Normal.

---

## 📂 Módulo: Inferencia
### 📄 `inferencia/inferencia_estadistica.jasb`
**Clase: `InferenciaEstadistica`**
Herramientas para realizar inferencias sobre poblaciones a partir de muestras.

- `intervalo_confianza_media(lista datos, flotante nivel_confianza)`: Calcula el intervalo de confianza para la media.
- `prueba_t_una_muestra(lista datos, flotante mu_hipotetica)`: Realiza una prueba T de una muestra.
- `prueba_t_welch_dos_muestras(lista poblacion_a, lista poblacion_b)`: Prueba T para dos muestras con varianzas desiguales.
- `correlacion_pearson(lista x, lista y)`: Calcula el coeficiente de correlación de Pearson.

---

## 📂 Módulo: Machine Learning
### 📄 `machine_learning/algoritmos_ml.jasb`
**Clase: `MachineLearning`**
Algoritmos fundamentales de aprendizaje supervisado y no supervisado.

- `kmeans_1d(lista datos, entero k)`: Clustering K-Means para datos unidimensionales.
- `regresion_logistica_simple(lista x, lista y, flotante alpha)`: Clasificación mediante regresión logística.
- `knn_regresion_1d(lista x_train, lista y_train, flotante x_nuevo, entero k)`: KNN para regresión 1D.
- `distancia_euclidiana(lista punto_a, lista punto_b)`: Distancia entre puntos multidimensionales.
- `kmeans_multidimensional(lista X, entero k, entero max_iter, entero seed)`: K-Means para múltiples dimensiones.
- `knn_clasificacion(lista X_train, lista y_train, lista x_nuevo, entero k)`: Clasificación KNN.
- `knn_regresion_multidimensional(lista X_train, lista y_train, lista x_nuevo, entero k)`: Regresión KNN.

### 📄 `machine_learning/arboles_decision.jasb`
**Clase: `ArbolesDecision`**
Implementación de árboles de decisión para clasificación y regresión.

- `arbol_decision_clasificacion_fit(lista X, lista y, entero max_profundidad)`: Entrena un árbol de clasificación.
- `arbol_decision_predecir(mapa modelo, lista x_nuevo)`: Predice la clase para una muestra.
- `arbol_decision_predecir_batch(mapa modelo, lista X_test)`: Predicciones en lote.
- `arbol_importancia_features(mapa modelo)`: Calcula la importancia de cada característica.

### 📄 `machine_learning/random_forest.jasb`
**Clase: `RandomForest`**
Conjuntos de árboles de decisión (Ensemble Learning).

- `random_forest_fit(lista X, lista y, entero n_arboles, entero max_prof, entero seed)`: Entrena un bosque aleatorio.
- `random_forest_predecir(mapa modelo, lista x_nuevo)`: Predicción para una muestra.
- `random_forest_predecir_batch(mapa modelo, lista X_test)`: Predicción en lote.
- `random_forest_importancia_features(mapa modelo)`: Importancia agregada de características.

### 📄 `machine_learning/gradient_boosting.jasb`
**Clase: `GradientBoosting`**
Algoritmo de Boosting para regresión y clasificación.

- `gradient_boosting_fit(lista X, lista y, entero n_estimadores, flotante lr, entero max_prof)`: Entrena un modelo GBM.
- `gradient_boosting_predecir(mapa modelo, lista x_nuevo)`: Predicción individual.
- `gradient_boosting_predecir_batch(mapa modelo, lista X_test)`: Predicción en lote.

### 📄 `machine_learning/redes_neuronales.jasb`
**Clase: `RedesNeuronales`**
Implementación de Perceptrón Multicapa (MLP).

- `perceptron_multicapa_fit(lista X, lista y, lista capas_ocultas, flotante lr, entero epochs)`: Entrena una red neuronal.
- `perceptron_predecir(mapa modelo, lista x_nuevo)`: Predicción individual.
- `perceptron_predecir_batch(mapa modelo, lista X_test)`: Predicción en lote.

### 📄 `machine_learning/svm.jasb`
**Clase: `SVM`**
Support Vector Machines para clasificación lineal.

- `svm_lineal_fit(lista X, lista y, flotante C, flotante lr, entero iter)`: Entrena un modelo SVM.
- `svm_predecir(mapa modelo, lista x_nuevo)`: Clasifica una muestra.

### 📄 `machine_learning/nlp_basico.jasb`
**Clase: `ProcesadorLenguajeNatural`**
Herramientas para procesamiento de texto.

- `tokenizar(texto contenido)`: Divide texto en palabras.
- `bag_of_words(lista tokens, lista vocabulario)`: Crea vectores de frecuencia de palabras.
- `calcular_tf_idf(lista tokens, lista vocab, lista doc_freq, entero total_docs)`: Calcula métricas TF-IDF.

---

## 📂 Módulo: Métricas
### 📄 `metricas/metricas_regresion.jasb`
**Clase: `MetricasRegresion`**
Evaluación de modelos de regresión.

- `calcular_mae(lista y_real, lista y_pred)`: Error Absoluto Medio.
- `calcular_mse(lista y_real, lista y_pred)`: Error Cuadrático Medio.
- `calcular_rmse(lista y_real, lista y_pred)`: Raíz del Error Cuadrático Medio.
- `calcular_r2_score(lista y_real, lista y_pred)`: Coeficiente de determinación R².
- `informe_metricas_regresion(lista y_real, lista y_pred)`: Informe detallado de errores.

### 📄 `metricas/metricas_clasificacion.jasb`
**Clase: `MetricasClasificacion`**
Evaluación de modelos de clasificación.

- `calcular_matriz_confusion(lista y_real, lista y_pred, entero clase_pos)`: Genera VP, VN, FP, FN.
- `calcular_accuracy(lista y_real, lista y_pred)`: Exactitud global.
- `calcular_precision(lista y_real, lista y_pred, entero clase_pos)`: Precisión.
- `calcular_recall(lista y_real, lista y_pred, entero clase_pos)`: Exhaustividad.
- `calcular_f1_score(lista y_real, lista y_pred, entero clase_pos)`: Valor F1.
- `informe_clasificacion_binaria(lista y_real, lista y_pred, entero clase_pos)`: Resumen completo.

### 📄 `metricas/metricas_clustering.jasb`
**Clase: `MetricasClustering`**
Evaluación de calidad de agrupamientos.

- `calcular_silhouette_score(lista X, lista labels)`: Coeficiente de Silueta.
- `calcular_davies_bouldin_index(lista X, lista labels)`: Índice de Davies-Bouldin.
- `calcular_calinski_harabasz_score(lista X, lista labels)`: Índice de Calinski-Harabasz.
- `calcular_inercia(lista X, lista labels, lista centroides)`: Suma de cuadrados dentro de los clusters.

---

## 📂 Módulo: Preprocesamiento
### 📄 `preprocesamiento/normalizacion.jasb`
**Clase: `Normalizacion`**
Escalado y transformación de características.

- `min_max_scaler_fit(lista datos)`: Calcula parámetros para escalado 0-1.
- `min_max_scaler_transform(lista datos, mapa scaler)`: Aplica escalado 0-1.
- `standard_scaler_fit(lista datos)`: Calcula media y desviación estándar para Z-score.
- `standard_scaler_transform(lista datos, mapa scaler)`: Aplica normalización Z-score.
- `robust_scaler_fit(lista datos)`: Calcula mediana e IQR para escalado robusto.
- `robust_scaler_transform(lista datos, mapa scaler)`: Aplica escalado robusto.

### 📄 `preprocesamiento/seleccion_features.jasb`
**Clase: `SeleccionFeatures`**
Identificación de las variables más importantes.

- `seleccionar_k_mejores_univariante(lista X, lista y, entero k)`: Selección basada en correlación.
- `eliminar_caracteristicas_baja_varianza(lista X, flotante umbral)`: Filtra variables constantes.

### 📄 `preprocesamiento/reduccion_dim.jasb`
**Clase: `ReduccionDimensionalidad`**
Técnicas de reducción de dimensiones.

- `pca_fit(lista X, entero n_componentes)`: Ajusta el modelo de Análisis de Componentes Principales.
- `pca_transform(lista X, mapa modelo)`: Proyecta los datos al nuevo espacio reducido.

---

## 📂 Módulo: Series Temporales
### 📄 `series_temporales/analisis_series_temporales.jasb`
**Clase: `SeriesTemporales`**
Análisis de datos secuenciales.

- `media_movil_simple(lista datos, entero ventana)`: Suavizado por media móvil.
- `suavizamiento_exponencial_simple(lista datos, flotante alfa)`: Suavizado exponencial (SES).
- `suavizamiento_exponencial_doble(lista datos, flotante alfa, flotante beta)`: Método de Holt.
- `autocorrelacion(lista datos, entero lag)`: Calcula la correlación con retardos.

### 📄 `series_temporales/arima.jasb`
**Clase: `ARIMA`**
Modelado Auto-Regresivo Integrado de Media Móvil.

- `arima_fit(lista datos, entero p, entero d, entero q)`: Ajusta un modelo ARIMA.
- `arima_forecast(mapa modelo, entero pasos)`: Predice valores futuros.

---

## 📂 Módulo: Validación
### 📄 `validacion/split_datos.jasb`
**Clase: `SplitDatos`**
División de conjuntos de datos.

- `train_test_split(lista X, lista y, flotante test_size, entero seed)`: Divide en entrenamiento y prueba.
- `split_temporal(lista datos, flotante test_size)`: Divide manteniendo el orden cronológico.

### 📄 `validacion/cross_validation.jasb`
**Clase: `CrossValidation`**
Técnicas de validación cruzada.

- `validacion_cruzada_k_fold_indices(entero n, entero k, entero seed)`: Genera índices para K-Fold.
- `time_series_split(lista datos, entero n_splits)`: Validación cruzada para series temporales.

---
**Nota:** Este catálogo se genera automáticamente a partir de los comentarios y estructuras del código fuente de la librería Analítica Neuronal.
