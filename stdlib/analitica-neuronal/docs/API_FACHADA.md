# API de fachada

Referencia de exportaciones reales de `analitica.jasb`.

## Clase exportada

- `AnaliticaFachada`

## Instancia global

- `g_analitica`

## Funciones exportadas

- `inicializar_fachada() -> entero`
- `inicializar_ml_avanzado() -> entero`
- `inicializar_redes_svm_clustering() -> entero`
- `inicializar_nlp_generativo() -> entero`  
  (dentro: `g_analitica.nlp_gen.preparar_markov_lm(3)`; ver `MODELO_LENGUAJE_JBR_Y_JMN.md`)
- `inicializar_embeddings() -> entero`
- `inicializar_capa_rnn() -> entero`
- `inicializar_arima_modulo() -> entero`
- `inicializar_nlp_generativo_y_series() -> entero`
- `inicializar_analitica_neuronal() -> bool`
- `analisis_completo_dataset(lista datos) -> mapa`

## Campos de `g_analitica`

### Core

- `estadistica`
- `probabilidad`
- `inferencia`
- `series`
- `ml`
- `nlp`
- `prediccion`
- `visualizacion`

### Metricas y validacion

- `metricas_reg`
- `metricas_clf`
- `metricas_cluster`
- `split`
- `cv`

### Preprocesamiento

- `normalizacion`
- `seleccion_features`
- `pca`

### Avanzado (carga diferida)

- `arboles`
- `random_forest`
- `gradient_boosting`
- `redes_neuronales`
- `svm`
- `clustering_avanzado`
- `nlp_gen` (`ModeloLenguaje`: N-gram, JMN, `.jbr`; ver `MODELO_LENGUAJE_JBR_Y_JMN.md`)
- `embeddings`
- `arima`
- `rnn`
