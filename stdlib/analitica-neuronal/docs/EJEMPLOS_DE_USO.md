# Ejemplos de uso

Ejemplos cortos, alineados con API actual.

## 1) Inicio minimo

```jasboot
usar { g_analitica, inicializar_fachada } de "stdlib/analitica-neuronal/analitica.jasb"

principal
    inicializar_fachada()
    lista datos = crear_lista()
    lista_agregar(datos, 10.0)
    lista_agregar(datos, 20.0)
    lista_agregar(datos, 30.0)
    flotante media = g_analitica.estadistica.calcular_media_aritmetica(datos)
    imprimir "media=" + str_desde_numero(media)
fin_principal
```

## 2) Regresion lineal simple

```jasboot
usar { g_analitica, inicializar_fachada } de "stdlib/analitica-neuronal/analitica.jasb"

principal
    inicializar_fachada()
    lista X = crear_lista()
    lista y = crear_lista()

    lista_agregar(X, 1.0)
    lista_agregar(X, 2.0)
    lista_agregar(X, 3.0)
    lista_agregar(y, 3.0)
    lista_agregar(y, 5.0)
    lista_agregar(y, 7.0)

    mapa modelo = g_analitica.prediccion.regresion_lineal_simple(X, y)
    flotante b1 = mapa_obtener(modelo, "pendiente")
    flotante b0 = mapa_obtener(modelo, "intercepto")
    imprimir "y = " + str_desde_numero(b1) + "x + " + str_desde_numero(b0)
fin_principal
```

## 3) Split + metricas de regresion

```jasboot
usar { g_analitica, inicializar_fachada } de "stdlib/analitica-neuronal/analitica.jasb"

principal
    inicializar_fachada()
    lista X = crear_lista()
    lista y = crear_lista()
    entero i = 0
    mientras i < 40 hacer
        flotante xi = i + 0.0
        lista_agregar(X, xi)
        lista_agregar(y, (2.0 * xi) + 1.0)
        i = i + 1
    fin_mientras

    mapa sp = g_analitica.split.train_test_split(X, y, 0.2, 42)
    lista x_train = mapa_obtener(sp, "X_train")
    lista y_train = mapa_obtener(sp, "y_train")
    lista x_test = mapa_obtener(sp, "X_test")
    lista y_test = mapa_obtener(sp, "y_test")

    mapa m = g_analitica.prediccion.regresion_lineal_simple(x_train, y_train)
    lista y_pred = crear_lista()
    entero j = 0
    mientras j < lista_tamano(x_test) hacer
        flotante xj = lista_obtener(x_test, j)
        lista_agregar(y_pred, (mapa_obtener(m, "pendiente") * xj) + mapa_obtener(m, "intercepto"))
        j = j + 1
    fin_mientras

    flotante rmse = g_analitica.metricas_reg.calcular_rmse(y_test, y_pred)
    imprimir "rmse=" + str_desde_numero(rmse)
fin_principal
```

## 4) NLP basico

```jasboot
usar {
    g_analitica,
    inicializar_fachada
} de "stdlib/analitica-neuronal/analitica.jasb"

principal
    inicializar_fachada()
    lista toks = g_analitica.nlp.tokenizar("prediccion de texto con jasboot")
    imprimir "tokens=" + str_desde_numero(lista_tamano(toks))
fin_principal
```

## 5) Prediccion de texto ligera (nlp_gen)

```jasboot
usar {
    g_analitica,
    inicializar_fachada,
    inicializar_nlp_generativo_y_series
} de "stdlib/analitica-neuronal/analitica.jasb"

principal
    inicializar_fachada()
    inicializar_nlp_generativo_y_series()

    g_analitica.nlp_gen.entrenar("hola mundo hola jasboot hola prediccion")
    texto sig = g_analitica.nlp_gen.predecir_siguiente("hola")
    imprimir "siguiente=" + sig
fin_principal
```

## 6) Exportar y cargar modelo `.jbr` (N-gram en disco)

Cada llamada a `entrenar` añade un documento al historial; `guardar_archivo_jbr` lo vuelca en formato texto `JBR1`. Para la semántica de `fusionar` y el formato línea a línea, ver `MODELO_LENGUAJE_JBR_Y_JMN.md`.

```jasboot
usar {
    g_analitica,
    inicializar_fachada,
    inicializar_nlp_generativo_y_series
} de "stdlib/analitica-neuronal/analitica.jasb"

principal
    crear_memoria("ejemplo_nlp_export.jmn")
    inicializar_fachada()
    inicializar_nlp_generativo_y_series()

    g_analitica.nlp_gen.entrenar("documento corto numero uno")
    g_analitica.nlp_gen.entrenar("documento corto numero dos")

    entero escritos = g_analitica.nlp_gen.guardar_archivo_jbr("mi_modelo.jbr", "demo")
    imprimir "bloques_escritos=" + str_desde_numero(escritos)

    entero cargados = g_analitica.nlp_gen.cargar_archivo_jbr("mi_modelo.jbr", 0)
    imprimir "bloques_reaplicados=" + str_desde_numero(cargados)

    consolidar_memoria()
    cerrar_memoria()
fin_principal
```
