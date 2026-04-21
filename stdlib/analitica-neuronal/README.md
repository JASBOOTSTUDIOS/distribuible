# 🧠 Librería de Analítica Neuronal Jasboot (V2.1 OOP)

## 📋 Descripción General

La **Librería de Analítica Neuronal V2.1** es una suite completa y nativa de herramientas estadísticas, probabilísticas y de Machine Learning implementadas para Jasboot. Su diseño modular y orientado a objetos permite un análisis de datos preciso y escalable.

---

## 📚 Índice de Documentación

Para facilitar el uso y la comprensión de la librería, dispones de los siguientes recursos:

1.  **[Guía de Uso Completa](GUIA_USO_COMPLETA.md)**: Tutoriales detallados y ejemplos prácticos paso a paso.
2.  **[Catálogo de Funcionalidades](CATALOGO_FUNCIONALIDADES.md)**: Referencia técnica de todas las clases y funciones públicas disponibles.
3.  **[Guía Estructurada de Arquitectura](GUIA_ESTRUCTURADA.md)**: Explicación detallada del diseño interno y la jerarquía de módulos.

---

## 🏗️ Estructura de la Librería

```
analitica-neuronal/
├── analitica.jasb                 # Fachada Global y punto de entrada
├── base.jasb                      # Clase base AnalizadorBase
├── math_lib.jasb                  # Núcleo matemático de alta precisión
├── estadistica/                   # Análisis descriptivo
├── probabilidad/                  # Distribuciones y combinatoria
├── inferencia/                    # Pruebas de hipótesis y correlación
├── series_temporales/             # Análisis de datos secuenciales y ARIMA
├── machine_learning/              # Árboles, Bosques, Redes Neuronales, SVM, NLP
├── preprocesamiento/              # Escalado (Normalización), PCA, Selección de features
├── metricas/                      # Evaluación de modelos (Regresión, Clasificación, Clustering)
└── validación/                    # Split de datos y Validación Cruzada (K-Fold)
```

---

## 🚀 Inicio Rápido

### 1. Inicialización
La librería utiliza una **Fachada** para centralizar todos los módulos.

```jasboot
usar todas de "./analitica-neuronal/analitica.jasb"

# Inicializar todas las instancias internas
inicializar_fachada()

# Acceso a través del objeto global 'g_analitica'
flotante media = g_analitica.estadistica.calcular_media_aritmetica(datos)
```

### 2. Ejemplo de Machine Learning
```jasboot
# Dividir datos
mapa split = g_analitica.split.train_test_split(X, y, 0.2, 42)

# Entrenar un Random Forest
mapa rf = g_analitica.random_forest.random_forest_fit(split.X_train, split.y_train, 10, 5)

# Evaluar
lista predicciones = g_analitica.random_forest.random_forest_predecir_batch(rf, split.X_test)
flotante accuracy = g_analitica.metricas_clf.calcular_accuracy(split.y_test, predicciones)
```

---
**🧠 Analítica Neuronal Jasboot: Tu motor inteligente de procesamiento de datos.**
