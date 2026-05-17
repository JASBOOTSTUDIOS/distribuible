# Modulos y capacidades

Resumen operativo de lo que puede hacer la libreria hoy.

## Estadistica (`estadistica`)

- media, mediana, moda
- varianza, desviacion, percentiles, cuartiles, deciles
- asimetria, curtosis
- outliers por IQR
- resumen estadistico completo

## Probabilidad (`probabilidad`)

- factorial y combinaciones
- binomial PMF
- poisson PMF
- normal PDF/CDF

## Inferencia (`inferencia`)

- intervalo de confianza de media
- prueba t de una muestra
- prueba t de Welch (dos muestras)
- correlacion de Pearson

## Machine Learning base (`ml`)

- K-Means 1D y multidimensional
- regresion logistica simple
- KNN clasificacion y regresion
- utilidades de distancia y vecinos

## Prediccion (`prediccion`)

- regresion lineal simple
- regresion lineal multiple
- regresion polinomial
- prediccion de demanda (serie)
- intervalos de confianza de prediccion
- ensemble basico de predicciones

## NLP base (`nlp`)

- tokenizar
- bag of words
- TF-IDF
- busqueda semantica basica por vectores

## NLP generativo (`nlp_gen`)

Ver detalle en `MODELO_LENGUAJE_JBR_Y_JMN.md`.

- entrenar modelo de lenguaje n-gram (`preparar_markov_lm` tras la fachada)
- predecir siguiente token
- generar texto desde semilla
- persistencia en JMN: `guardar_snapshot_jmn` / `cargar_snapshot_jmn`, `guardar_parte_cerebro` / `cargar_parte_cerebro`
- persistencia en archivo: `guardar_archivo_jbr` / `cargar_archivo_jbr` (`.jbr`, texto `JBR1`)
- limitacion: estado Markov compartido en proceso (`_mlm_*`); un solo modelo activo real por VM

## Embeddings (`embeddings`)

- registrar palabra con vector
- obtener vector por palabra
- similitud semantica

## Series temporales

### `series`

- media movil
- suavizamiento exponencial simple/doble
- autocorrelacion

### `arima`

- ajuste ARIMA(p,d,q)
- forecast multi-step
- diagnostico base (residuos, SSE, MSE, RMSE)

## Modelos avanzados

- `arboles`: clasificacion/regresion por arbol
- `random_forest`: ensamble de arboles
- `gradient_boosting`: boosting supervisado
- `svm`: clasificacion lineal
- `redes_neuronales`: MLP
  - entrenamiento: `perceptron_multicapa_fit`
  - inferencia: `perceptron_predecir`, `perceptron_predecir_batch`
  - persistencia textual compatible: `guardar_archivo_jbr` / `cargar_archivo_jbr`
  - persistencia binaria portable de pesos/sesgos: `guardar_archivo_jbm` / `cargar_archivo_jbm` (`.jbm`, fixed-point escala 1e6)
- `rnn`: capa recurrente (inicializacion separada)
- `clustering_avanzado`: clustering extra

## Evaluacion y ciclo ML

- `metricas_reg`: MAE, MSE, RMSE, R2, MAPE
- `metricas_clf`: accuracy, precision, recall, f1, matriz confusion
- `metricas_cluster`: silhouette, davies-bouldin, calinski-harabasz, inercia
- `split`: train/test y split temporal
- `cv`: k-fold indices y variantes temporales

## Preprocesamiento

- `normalizacion`: min-max, z-score, robust
- `seleccion_features`: seleccion univariante y baja varianza
- `pca`: ajuste y transformacion por componentes
