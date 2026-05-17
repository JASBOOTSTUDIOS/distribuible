# Arquitectura y carga de modulos

## Punto de entrada

Archivo principal: `stdlib/analitica-neuronal/analitica.jasb`

Exporta:

- clase `AnaliticaFachada`
- instancia global `g_analitica`
- funciones de inicializacion por fases

## Importacion recomendada

```jasboot
usar { g_analitica, inicializar_fachada } de "stdlib/analitica-neuronal/analitica.jasb"
```

No usar `usar todas de ...` en codigo nuevo.

## Carga por fases

### Fase 1 (base)

```jasboot
inicializar_fachada()
```

Carga e inicializa:

- estadistica, probabilidad, inferencia, series, ml, nlp, prediccion, visualizacion
- metricas (regresion, clasificacion, clustering)
- validacion (split y cross validation)
- preprocesamiento (normalizacion, seleccion de features, reduccion dimensional)

### Fase 2 (ML avanzado)

```jasboot
inicializar_ml_avanzado()
```

Carga:

- arboles de decision
- random forest
- gradient boosting

### Fase 3 (redes, svm y clustering avanzado)

```jasboot
inicializar_redes_svm_clustering()
```

Carga:

- redes neuronales (MLP)
- SVM
- clustering avanzado

### Fase 4 (NLP generativo, embeddings y series avanzadas)

```jasboot
inicializar_nlp_generativo_y_series()
```

Internamente ejecuta:

- `inicializar_embeddings()`
- `inicializar_nlp_generativo()`
- `inicializar_arima_modulo()`

### Fase 5 (RNN)

```jasboot
inicializar_capa_rnn()
```

`rnn` se deja separada por estabilidad cuando hay mucha carga de objetos.

## Convencion recomendada para apps

1. Inicializar solo fase 1.
2. Subir fases segun necesidad real del flujo.
3. Evitar inicializar todo si no se usa en runtime.
