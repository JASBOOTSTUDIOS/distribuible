# Sistema de predicciones

Documento principal para apps de prediccion (incluyendo texto).

## Alcance real actual

La libreria soporta bien:

- prediccion numerica clasica (regresion)
- clasificacion/regresion con ML clasico
- NLP de features (tokenizacion, bag of words, TF-IDF)
- NLP generativo ligero (modelo de lenguaje n-gram)

No busca reemplazar un LLM grande; es ideal para apps predictivas
deterministas, explicables y de bajo costo.

## Rutas de prediccion disponibles

## A) Regresion numerica

Usar `g_analitica.prediccion`:

- `regresion_lineal_simple(X, y)`
- `regresion_lineal_multiple(X_matriz, y)`
- `regresion_polinomial(X, y, grado)`

Prediccion:

- `predecir_regresion_multiple(x_nuevo, modelo)`
- `predecir_regresion_polinomial(x_nuevo, modelo)`

## B) Prediccion por ML supervisado

Usar segun caso:

- `g_analitica.ml` (KNN/logistica)
- `g_analitica.arboles`
- `g_analitica.random_forest`
- `g_analitica.gradient_boosting`
- `g_analitica.svm`
- `g_analitica.redes_neuronales`

## C) Prediccion de texto (MVP)

Combina:

1. `g_analitica.nlp` para features de texto.
2. modelo supervisado para clasificar/intencionar.
3. opcional `g_analitica.nlp_gen` para proponer siguiente palabra o frase.

### Flujo recomendado

1. Preprocesar texto:
   - tokenizar
   - vectorizar (BoW o TF-IDF)
2. Entrenar predictor:
   - KNN, SVM, arboles, random forest, etc.
3. Inferir texto nuevo:
   - misma transformacion
   - predecir clase/accion/respuesta
4. Evaluar:
   - accuracy, precision, recall, f1

## D) Prediccion temporal

Usar:

- `g_analitica.series` para analisis basico
- `g_analitica.arima` para forecast formal

## Inicializacion sugerida por tipo de app

## App de prediccion tabular

```jasboot
inicializar_fachada()
inicializar_ml_avanzado()
```

## App de prediccion de texto

```jasboot
inicializar_fachada()
inicializar_redes_svm_clustering()
inicializar_nlp_generativo_y_series()
```

## App de series temporales

```jasboot
inicializar_fachada()
inicializar_nlp_generativo_y_series()
```

## Plantilla minima de prediccion de texto

```jasboot
usar {
    g_analitica,
    inicializar_fachada,
    inicializar_redes_svm_clustering,
    inicializar_nlp_generativo_y_series
} de "stdlib/analitica-neuronal/analitica.jasb"

principal
    inicializar_fachada()
    inicializar_redes_svm_clustering()
    inicializar_nlp_generativo_y_series()

    texto entrada = "hola mundo desde jasboot"
    lista tokens = g_analitica.nlp.tokenizar(entrada)
    imprimir "tokens=" + str_desde_numero(lista_tamano(tokens))

    # Aqui conectas tu pipeline:
    # 1) vectorizacion (BoW/TF-IDF)
    # 2) prediccion con modelo entrenado
    # 3) evaluacion con metricas_clf
fin_principal
```

## Buenas practicas para prediccion

- separar entrenamiento y evaluacion (train/test o CV)
- fijar seed en procesos aleatorios
- normalizar features numericas antes de ciertos modelos
- medir con varias metricas, no solo una
- cargar solo modulos que realmente uses
