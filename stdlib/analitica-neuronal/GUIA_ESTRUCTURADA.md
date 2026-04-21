# 🏗️ Guía Estructurada: Arquitectura de Analítica Neuronal

Esta guía explica la arquitectura de la librería de Analítica Neuronal, detallando la relación entre la fachada, los módulos y los componentes base.

---

## 🏛️ Visión General de la Arquitectura

La librería sigue un patrón de **Fachada (Facade)** para simplificar el acceso a un sistema complejo de módulos interconectados. Toda la funcionalidad se organiza en clases, heredando de una base común para mantener la consistencia.

### 🧩 Componentes Principales

1.  **Fachada Global (`analitica.jasb`)**: Actúa como el punto de entrada único. Expone una instancia global `g_analitica` que agrupa todos los submódulos.
2.  **Clase Base (`base.jasb`)**: Define `AnalizadorBase`, que proporciona funcionalidades comunes como validación de datos y metadatos del módulo.
3.  **Núcleo Matemático (`math_lib.jasb`)**: Proporciona funciones matemáticas de alta precisión necesarias para los algoritmos de ML.
4.  **Submódulos Especializados**: Organizados por carpetas según su dominio funcional (estadística, machine_learning, etc.).

---

## 🛰️ La Fachada: `AnaliticaFachada`

La clase `AnaliticaFachada` es el corazón de la librería. Al inicializarse mediante `inicializar_fachada()`, instancia y configura todos los submódulos disponibles.

### Estructura de `g_analitica`:

-   **Área de Estadística**:
    -   `g_analitica.estadistica`: Estadística descriptiva.
    -   `g_analitica.probabilidad`: Distribuciones y combinatoria.
    -   `g_analitica.inferencia`: Pruebas de hipótesis y correlación.
-   **Área de Machine Learning**:
    -   `g_analitica.ml`: Algoritmos base (K-Means, KNN, Logística).
    -   `g_analitica.arboles`: Árboles de decisión.
    -   `g_analitica.random_forest`: Ensambles de árboles.
    -   `g_analitica.gradient_boosting`: Modelos de boosting.
    -   `g_analitica.redes_neuronales`: Perceptrón multicapa.
    -   `g_analitica.svm`: Support Vector Machines.
-   **Área de Datos y Series**:
    -   `g_analitica.series`: Análisis de series temporales.
    -   `g_analitica.arima`: Modelado ARIMA avanzado.
    -   `g_analitica.normalizacion`: Escalado de datos.
    -   `g_analitica.pca`: Reducción de dimensionalidad.
-   **Área de Validación y Métricas**:
    -   `g_analitica.split`: División de datasets.
    -   `g_analitica.cv`: Validación cruzada.
    -   `g_analitica.metricas_reg`: Evaluación de regresión.
    -   `g_analitica.metricas_clf`: Evaluación de clasificación.
    -   `g_analitica.metricas_cluster`: Evaluación de clustering.

---

## 🛠️ Jerarquía de Clases

La mayoría de las clases de la librería extienden de `AnalizadorBase`.

### `AnalizadorBase` (en `base.jasb`)
Propiedades:
- `nombre_analizador`: Nombre del módulo.
- `version_analizador`: Versión actual.

Métodos:
- `inicializar(nombre, version)`: Configura el módulo.
- `describir()`: Imprime información del módulo.
- `validar_lista_numerica(lista)`: Utilidad compartida para validar datos.

---

## 🔄 Flujo de Trabajo Recomendado

Para mantener la integridad y reproducibilidad en proyectos de ciencia de datos con Jasboot, se recomienda seguir este flujo:

1.  **Carga y Limpieza**: Usar `estadistica` para entender los datos y limpiar valores nulos.
2.  **Preprocesamiento**: Usar `normalizacion` y, si es necesario, `pca`.
3.  **División**: Usar `split` o `cv` para separar datos de entrenamiento y prueba.
4.  **Modelado**: Seleccionar el algoritmo adecuado de `machine_learning`.
5.  **Evaluación**: Usar el módulo de `metricas` correspondiente para validar el rendimiento.

---

## 🚀 Extensibilidad

La arquitectura modular permite agregar nuevos algoritmos fácilmente:
1. Crear el nuevo archivo `.jasb` en la carpeta correspondiente.
2. Heredar de `AnalizadorBase`.
3. Registrar el nuevo módulo en la clase `AnaliticaFachada` dentro de `analitica.jasb`.
4. Inicializarlo en la función `inicializar_fachada()`.
