# Métricas de Clustering - Jasboot Analytics

## Descripción

El módulo `metricas_clustering.jasb` proporciona una clase completa para evaluar la calidad de algoritmos de clustering mediante métricas estándar de la industria. Es parte del ecosistema de análitica neuronal de Jasboot.

## Características

- **Silhouette Score**: Mide la separación entre clusters (-1 a 1)
- **Davies-Bouldin Index**: Evalúa dispersión intra/inter-cluster (menor = mejor)
- **Calinski-Harabasz Score**: Ratio de varianza entre/dentro clusters (mayor = mejor)
- **Inercia (WCSS)**: Suma de cuadrados dentro de clusters (menor = mejor)
- **Análisis por muestra**: Silhouette score individual para cada punto
- **Informe completo**: Todas las métricas en un solo reporte

## Instalación

```jasboot
usar todas de "metricas_clustering.jasb"
```

## Uso Básico

### 1. Crear Instancia

```jasboot
MetricasClustering metricas = crear MetricasClustering()
metricas.describir()
```

### 2. Preparar Datos

Los datos deben estar en formato:
- `X_matriz`: Lista de listas (cada sublista es un punto con sus coordenadas)
- `labels`: Lista de enteros (etiqueta de cluster para cada punto)

```jasboot
# Ejemplo: 6 puntos en 2D, 2 clusters
lista X = crear_lista()

# Cluster 0
lista p1 = crear_lista()
lista_agregar(p1, 0.0)
lista_agregar(p1, 0.0)
lista_agregar(X, p1)

lista p2 = crear_lista()
lista_agregar(p2, 0.5)
lista_agregar(p2, 0.5)
lista_agregar(X, p2)

# Cluster 1
lista p3 = crear_lista()
lista_agregar(p3, 10.0)
lista_agregar(p3, 10.0)
lista_agregar(X, p3)

lista p4 = crear_lista()
lista_agregar(p4, 10.5)
lista_agregar(p4, 10.5)
lista_agregar(X, p4)

# Labels
lista labels = crear_lista()
lista_agregar(labels, 0)
lista_agregar(labels, 0)
lista_agregar(labels, 1)
lista_agregar(labels, 1)
```

### 3. Calcular Métricas

```jasboot
# Silhouette Score
flotante silhouette = metricas.calcular_silhouette_score(X, labels)
imprimir "Silhouette Score: " + str_desde_numero(silhouette)

# Davies-Bouldin Index
flotante db = metricas.calcular_davies_bouldin_index(X, labels)
imprimir "Davies-Bouldin: " + str_desde_numero(db)

# Calinski-Harabasz Score
flotante ch = metricas.calcular_calinski_harabasz_score(X, labels)
imprimir "Calinski-Harabasz: " + str_desde_numero(ch)

# Inercia
flotante inercia = metricas.calcular_inercia(X, labels, nulo)
imprimir "Inercia: " + str_desde_numero(inercia)
```

### 4. Informe Completo

```jasboot
mapa informe = metricas.informe_clustering(X, labels)
metricas.imprimir_informe(informe)
```

Salida ejemplo:
```
==========================================
  INFORME DE MÉTRICAS DE CLUSTERING
==========================================

Información General:
  - Número de muestras: 100
  - Número de clusters: 3

Métricas de Calidad:
  - Silhouette Score: 0.75
    (Rango: -1 a 1, donde 1 = mejor separación)
  - Davies-Bouldin Index: 0.45
    (Menor es mejor, 0 = ideal)
  - Calinski-Harabasz Score: 156.8
    (Mayor es mejor)
  - Inercia (WCSS): 45.2
    (Menor es mejor)

Distribución de Clusters:
  - Cluster 0: 35 puntos
  - Cluster 1: 32 puntos
  - Cluster 2: 33 puntos

==========================================
```

## Referencia de API

### Métricas Principales

#### `calcular_silhouette_score(lista X_matriz, lista labels) retorna flotante`

Calcula el Silhouette Score promedio para el clustering.

**Rango**: -1 a 1
- **1.0**: Clusters perfectamente separados
- **0.0**: Clusters superpuestos
- **-1.0**: Asignaciones incorrectas

**Fórmula**: `s(i) = (b(i) - a(i)) / max(a(i), b(i))`
- `a(i)`: Distancia media intra-cluster
- `b(i)`: Distancia media al cluster más cercano

**Uso**:
```jasboot
flotante score = metricas.calcular_silhouette_score(X, labels)
```

---

#### `calcular_silhouette_samples(lista X_matriz, lista labels) retorna lista`

Calcula el Silhouette Score individual para cada punto.

**Retorna**: Lista de flotantes (un score por muestra)

**Uso**:
```jasboot
lista scores = metricas.calcular_silhouette_samples(X, labels)
entero i = 0
mientras i < lista_tamano(scores) hacer
    flotante s = lista_obtener(scores, i)
    imprimir "Punto " + str_desde_numero(i) + ": " + str_desde_numero(s)
    i = i + 1
fin_mientras
```

---

#### `calcular_davies_bouldin_index(lista X_matriz, lista labels) retorna flotante`

Calcula el índice Davies-Bouldin (ratio de dispersión intra/inter cluster).

**Rango**: 0 a ∞ (menor es mejor)
- **0.0**: Clusters idealmente separados
- **> 1.0**: Clusters con alta superposición

**Interpretación**:
- **< 0.5**: Excelente separación
- **0.5-1.0**: Buena separación
- **> 1.0**: Separación pobre

**Uso**:
```jasboot
flotante db = metricas.calcular_davies_bouldin_index(X, labels)
```

---

#### `calcular_calinski_harabasz_score(lista X_matriz, lista labels) retorna flotante`

Calcula el Calinski-Harabasz Score (ratio de varianza entre/dentro clusters).

**Rango**: 0 a ∞ (mayor es mejor)

También conocido como "Variance Ratio Criterion".

**Interpretación**:
- **> 100**: Clusters muy bien definidos
- **50-100**: Clusters bien definidos
- **< 50**: Clusters poco definidos

**Uso**:
```jasboot
flotante ch = metricas.calcular_calinski_harabasz_score(X, labels)
```

---

#### `calcular_inercia(lista X_matriz, lista labels, lista centroides) retorna flotante`

Calcula la inercia o Within-Cluster Sum of Squares (WCSS).

**Parámetros**:
- `X_matriz`: Datos
- `labels`: Etiquetas de cluster
- `centroides`: Lista de centroides (opcional, se calculan si es `nulo`)

**Rango**: 0 a ∞ (menor es mejor)

**Uso común**: Método del codo (Elbow Method) para determinar número óptimo de clusters.

**Uso**:
```jasboot
# Con centroides calculados automáticamente
flotante inercia = metricas.calcular_inercia(X, labels, nulo)

# Con centroides pre-calculados
lista cents = crear_lista()
# ... agregar centroides ...
flotante inercia = metricas.calcular_inercia(X, labels, cents)
```

---

#### `informe_clustering(lista X_matriz, lista labels) retorna mapa`

Genera un informe completo con todas las métricas.

**Retorna**: Mapa con las siguientes claves:
- `"n_muestras"`: Número de puntos
- `"n_clusters"`: Número de clusters
- `"silhouette_score"`: Silhouette Score
- `"davies_bouldin_index"`: Davies-Bouldin Index
- `"calinski_harabasz_score"`: Calinski-Harabasz Score
- `"inercia"`: Inercia (WCSS)
- `"tamanos_clusters"`: Lista con tamaño de cada cluster

**Uso**:
```jasboot
mapa informe = metricas.informe_clustering(X, labels)

# Acceder a métricas individuales
flotante silh = mapa_obtener(informe, "silhouette_score")
entero n_clusters = mapa_obtener(informe, "n_clusters")
lista tamanos = mapa_obtener(informe, "tamanos_clusters")
```

### Métodos Auxiliares

#### `obtener_indices_cluster(lista labels, entero cluster_id) retorna lista`

Obtiene los índices de todos los puntos pertenecientes a un cluster.

```jasboot
lista indices = metricas.obtener_indices_cluster(labels, 0)
imprimir "Puntos en cluster 0: " + str_desde_numero(lista_tamano(indices))
```

---

#### `calcular_centroide_cluster(lista X, lista labels, entero cluster_id) retorna lista`

Calcula el centroide (punto promedio) de un cluster.

```jasboot
lista centroide = metricas.calcular_centroide_cluster(X, labels, 0)
flotante cx = lista_obtener(centroide, 0)
flotante cy = lista_obtener(centroide, 1)
imprimir "Centroide: (" + str_desde_numero(cx) + ", " + str_desde_numero(cy) + ")"
```

---

#### `distancia_media_intra_cluster(lista X, lista labels, entero indice) retorna flotante`

Calcula `a(i)` para Silhouette: distancia media de un punto a otros del mismo cluster.

```jasboot
flotante a_i = metricas.distancia_media_intra_cluster(X, labels, 0)
```

---

#### `distancia_media_inter_cluster(lista X, lista labels, entero indice, entero cluster_destino) retorna flotante`

Calcula `b(i)` para Silhouette: distancia media de un punto a puntos de otro cluster.

```jasboot
flotante b_i = metricas.distancia_media_inter_cluster(X, labels, 0, 1)
```

## Casos de Uso

### 1. Comparar Algoritmos de Clustering

```jasboot
# Probar K-Means con k=3
lista labels_kmeans = kmeans_clustering(X, 3)
flotante silh_kmeans = metricas.calcular_silhouette_score(X, labels_kmeans)

# Probar DBSCAN
lista labels_dbscan = dbscan_clustering(X, epsilon, min_pts)
flotante silh_dbscan = metricas.calcular_silhouette_score(X, labels_dbscan)

si silh_kmeans > silh_dbscan entonces
    imprimir "K-Means es mejor para estos datos"
sino
    imprimir "DBSCAN es mejor para estos datos"
fin_si
```

### 2. Método del Codo (Elbow Method)

```jasboot
lista inercias = crear_lista()
entero k = 2

mientras k <= 10 hacer
    lista labels = kmeans_clustering(X, k)
    flotante inercia = metricas.calcular_inercia(X, labels, nulo)
    lista_agregar(inercias, inercia)
    imprimir "k=" + str_desde_numero(k) + ", inercia=" + str_desde_numero(inercia)
    k = k + 1
fin_mientras

# Buscar el "codo" donde inercia deja de disminuir significativamente
```

### 3. Validación de Calidad de Clusters

```jasboot
mapa informe = metricas.informe_clustering(X, labels)

flotante silh = mapa_obtener(informe, "silhouette_score")
flotante db = mapa_obtener(informe, "davies_bouldin_index")

si silh > 0.5 y db < 1.0 entonces
    imprimir "✓ Clustering de alta calidad"
sino_si silh > 0.25 y db < 1.5 entonces
    imprimir "⚠ Clustering de calidad media"
sino
    imprimir "✗ Clustering de baja calidad - considerar ajustar parámetros"
fin_si
```

### 4. Identificar Puntos Mal Asignados

```jasboot
lista silh_samples = metricas.calcular_silhouette_samples(X, labels)
entero i = 0

imprimir "Puntos con baja cohesión (posiblemente mal asignados):"
mientras i < lista_tamano(silh_samples) hacer
    flotante s = lista_obtener(silh_samples, i)
    si s < 0.0 entonces
        imprimir "  - Punto " + str_desde_numero(i) + ": score = " + str_desde_numero(s)
    fin_si
    i = i + 1
fin_mientras
```

## Guía de Interpretación

### Tabla de Referencia Rápida

| Métrica | Rango | Mejor | Excelente | Bueno | Aceptable | Malo |
|---------|-------|-------|-----------|-------|-----------|------|
| **Silhouette** | -1 a 1 | 1.0 | > 0.7 | 0.5-0.7 | 0.25-0.5 | < 0.25 |
| **Davies-Bouldin** | 0 a ∞ | 0.0 | < 0.5 | 0.5-1.0 | 1.0-1.5 | > 1.5 |
| **Calinski-Harabasz** | 0 a ∞ | ∞ | > 100 | 50-100 | 20-50 | < 20 |
| **Inercia** | 0 a ∞ | 0.0 | Relativo al dataset | ↓ | ↓ | ↑ |

### Recomendaciones por Aplicación

#### Segmentación de Clientes
- **Prioridad**: Silhouette Score > 0.5
- **Secundario**: Davies-Bouldin < 1.0
- **Interpretar**: Clusters bien definidos permiten estrategias de marketing específicas

#### Compresión de Datos
- **Prioridad**: Inercia baja
- **Secundario**: Calinski-Harabasz alto
- **Interpretar**: Minimizar pérdida de información en representación comprimida

#### Detección de Anomalías
- **Prioridad**: Silhouette samples individuales
- **Secundario**: Identificar puntos con score < 0
- **Interpretar**: Puntos con bajo score son candidatos a anomalías

#### Agrupación de Documentos
- **Prioridad**: Davies-Bouldin bajo
- **Secundario**: Silhouette > 0.3
- **Interpretar**: Tópicos bien separados con alguna superposición natural

## Limitaciones

1. **Número de Clusters**: Todas las métricas requieren al menos 2 clusters
2. **Tamaño de Datos**: Complejidad O(n²) para Silhouette con datasets grandes
3. **Distancia Euclidiana**: Métricas asumen espacio euclidiano (no aplicable a datos categóricos)
4. **Forma de Clusters**: Favorecen clusters convexos y compactos

## Mejores Prácticas

1. **Usar múltiples métricas**: No confiar en una sola métrica
2. **Normalizar datos**: Asegurar que todas las dimensiones tengan escala similar
3. **Validación cruzada**: Probar con diferentes semillas aleatorias
4. **Contexto del dominio**: Las métricas son guías, no verdades absolutas
5. **Visualización**: Complementar con gráficos (t-SNE, PCA)

## Ejemplos Avanzados

### Selección Automática de k Óptimo

```jasboot
funcion encontrar_k_optimo(lista X, entero k_min, entero k_max) retorna entero
    MetricasClustering metricas = crear MetricasClustering()
    
    flotante mejor_score = -2.0
    entero mejor_k = k_min
    
    entero k = k_min
    mientras k <= k_max hacer
        lista labels = kmeans_clustering(X, k)
        flotante silh = metricas.calcular_silhouette_score(X, labels)
        
        imprimir "k=" + str_desde_numero(k) + ", silhouette=" + str_desde_numero(silh)
        
        si silh > mejor_score entonces
            mejor_score = silh
            mejor_k = k
        fin_si
        
        k = k + 1
    fin_mientras
    
    imprimir ""
    imprimir "Mejor k: " + str_desde_numero(mejor_k) + " (score=" + str_desde_numero(mejor_score) + ")"
    retornar mejor_k
fin_funcion

# Uso
entero k_optimo = encontrar_k_optimo(X, 2, 10)
```

### Análisis de Estabilidad

```jasboot
funcion evaluar_estabilidad(lista X, entero k, entero n_iteraciones) retorna flotante
    MetricasClustering metricas = crear MetricasClustering()
    
    lista scores = crear_lista()
    entero iter = 0
    
    mientras iter < n_iteraciones hacer
        # Ejecutar clustering con semilla aleatoria diferente
        lista labels = kmeans_clustering_con_semilla(X, k, iter)
        flotante silh = metricas.calcular_silhouette_score(X, labels)
        lista_agregar(scores, silh)
        iter = iter + 1
    fin_mientras
    
    # Calcular desviación estándar de scores
    flotante promedio = calcular_promedio(scores)
    flotante desv_std = calcular_desviacion_estandar(scores)
    
    imprimir "Promedio: " + str_desde_numero(promedio)
    imprimir "Desviación: " + str_desde_numero(desv_std)
    
    si desv_std < 0.1 entonces
        imprimir "✓ Clustering estable"
    sino
        imprimir "⚠ Clustering inestable - resultados varían mucho"
    fin_si
    
    retornar desv_std
fin_funcion
```

## Solución de Problemas

### Error: "Matriz X es nula"
**Causa**: Datos no inicializados
**Solución**: Verificar que `X_matriz` esté creada con `crear_lista()`

### Error: "Tamaños no coinciden"
**Causa**: Número de labels diferente al número de puntos
**Solución**: Asegurar `lista_tamano(X) == lista_tamano(labels)`

### Advertencia: "Solo hay 1 cluster"
**Causa**: Todas las etiquetas son iguales
**Solución**: Verificar algoritmo de clustering o aumentar número de clusters

### Score = 0.0 inesperado
**Causa**: Posible división por cero o datos idénticos
**Solución**: Verificar varianza en datos y que no todos los puntos sean iguales

## Referencias

- Rousseeuw, P.J. (1987). "Silhouettes: A graphical aid to the interpretation and validation of cluster analysis"
- Davies, D.L.; Bouldin, D.W. (1979). "A Cluster Separation Measure"
- Caliński, T.; Harabasz, J. (1974). "A dendrite method for cluster analysis"

## Versión

**Versión actual**: 1.0  
**Compatibilidad**: Jasboot VM 1.0+  
**Última actualización**: 2024

## Soporte

Para reportar bugs o sugerir mejoras, contacta al equipo de desarrollo de Jasboot.

---

**Licencia**: Parte del proyecto Jasboot  
**Autor**: Equipo Jasboot Analytics