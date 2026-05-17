# Libreria Analitica Neuronal (estado actual)

## Descripcion

`analitica-neuronal` es la libreria estandar de analitica, ML y NLP de Jasboot.
El punto de entrada recomendado es `analitica.jasb`, que expone una fachada
global `g_analitica` y funciones de inicializacion por fases.

## Documentacion oficial (carpeta docs)

- [Indice](docs/README.md)
- [Arquitectura y carga](docs/ARQUITECTURA_Y_CARGA.md)
- [API de fachada](docs/API_FACHADA.md)
- [Modulos y capacidades](docs/MODULOS_Y_CAPACIDADES.md)
- [Sistema de predicciones](docs/SISTEMA_PREDICCIONES.md)
- [Ejemplos de uso](docs/EJEMPLOS_DE_USO.md)
- [FAQ y limitaciones](docs/FAQ_Y_LIMITACIONES.md)

## Importacion correcta (sintaxis actual)

Usa importacion explicita con llaves:

```jasboot
usar { g_analitica, inicializar_fachada } de "stdlib/analitica-neuronal/analitica.jasb"
```

No usar `usar todas de ...` en codigo nuevo.

## Inicializacion por fases

1. Base (siempre):

```jasboot
inicializar_fachada()
```

2. Modulos avanzados (segun necesidad):

```jasboot
inicializar_ml_avanzado()
inicializar_redes_svm_clustering()
inicializar_nlp_generativo_y_series()
inicializar_capa_rnn()
```

## Modulos disponibles en `g_analitica`

- Core: `estadistica`, `probabilidad`, `inferencia`, `series`, `ml`, `nlp`, `prediccion`, `visualizacion`
- Metricas/validacion: `metricas_reg`, `metricas_clf`, `metricas_cluster`, `split`, `cv`
- Preprocesamiento: `normalizacion`, `seleccion_features`, `pca`
- Avanzado (carga diferida): `arboles`, `random_forest`, `gradient_boosting`, `redes_neuronales`, `svm`, `clustering_avanzado`, `nlp_gen`, `embeddings`, `arima`, `rnn`

## Nota de estabilidad

- `rnn` se inicializa de forma separada con `inicializar_capa_rnn()` para minimizar
  riesgos de cuelgue al crear muchos objetos pesados en la misma carga.
