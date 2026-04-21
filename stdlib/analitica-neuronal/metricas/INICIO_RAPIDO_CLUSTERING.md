# 🚀 Inicio Rápido: Métricas de Clustering

## Instalación (1 línea)

```jasboot
usar todas de "metricas_clustering.jasb"
```

## Ejemplo Mínimo (5 líneas)

```jasboot
# 1. Crear instancia
MetricasClustering metricas = crear MetricasClustering()

# 2. Preparar datos (X = lista de puntos, labels = lista de clusters)
lista X = crear_lista()        # Tu matriz de datos
lista labels = crear_lista()   # Tus etiquetas de cluster

# 3. Evaluar
flotante score = metricas.calcular_silhouette_score(X, labels)
imprimir "Calidad del clustering: " + str_desde_numero(score)
```

## 📊 Las 4 Métricas Esenciales

### 1. Silhouette Score (la más popular)
```jasboot
flotante silh = metricas.calcular_silhouette_score(X, labels)
# Rango: -1 a 1
# Interpretación: > 0.5 = bueno, > 0.7 = excelente
```

### 2. Davies-Bouldin Index
```jasboot
flotante db = metricas.calcular_davies_bouldin_index(X, labels)
# Rango: 0 a ∞
# Interpretación: < 0.5 = excelente, < 1.0 = bueno
```

### 3. Calinski-Harabasz Score
```jasboot
flotante ch = metricas.calcular_calinski_harabasz_score(X, labels)
# Rango: 0 a ∞
# Interpretación: > 100 = excelente, > 50 = bueno
```

### 4. Inercia (WCSS)
```jasboot
flotante inercia = metricas.calcular_inercia(X, labels, nulo)
# Menor = mejor (usar para método del codo)
```

## 🎯 Casos de Uso Comunes

### Informe Completo (recomendado)
```jasboot
mapa informe = metricas.informe_clustering(X, labels)
metricas.imprimir_informe(informe)
```

### Comparar K-Means con diferentes k
```jasboot
entero mejor_k = 2
flotante mejor_score = -1.0

entero k = 2
mientras k <= 10 hacer
    lista labels = kmeans_clustering(X, k)
    flotante score = metricas.calcular_silhouette_score(X, labels)
    
    si score > mejor_score entonces
        mejor_score = score
        mejor_k = k
    fin_si
    k = k + 1
fin_mientras

imprimir "Mejor k: " + str_desde_numero(mejor_k)
```

### Detectar Puntos Mal Asignados
```jasboot
lista scores = metricas.calcular_silhouette_samples(X, labels)
entero i = 0
mientras i < lista_tamano(scores) hacer
    flotante s = lista_obtener(scores, i)
    si s < 0.0 entonces
        imprimir "⚠ Punto " + str_desde_numero(i) + " mal asignado"
    fin_si
    i = i + 1
fin_mientras
```

### Método del Codo
```jasboot
imprimir "k | Inercia"
imprimir "--|--------"
entero k = 2
mientras k <= 10 hacer
    lista labels = kmeans_clustering(X, k)
    flotante inercia = metricas.calcular_inercia(X, labels, nulo)
    imprimir str_desde_numero(k) + " | " + str_desde_numero(inercia)
    k = k + 1
fin_mientras
```

## 📝 Formato de Datos

### Matriz X (lista de listas)
```jasboot
lista X = crear_lista()

# Cada punto es una lista de coordenadas
lista punto1 = crear_lista()
lista_agregar(punto1, 1.0)  # x
lista_agregar(punto1, 2.0)  # y
lista_agregar(X, punto1)

lista punto2 = crear_lista()
lista_agregar(punto2, 3.0)
lista_agregar(punto2, 4.0)
lista_agregar(X, punto2)
# ... más puntos
```

### Labels (lista de enteros)
```jasboot
lista labels = crear_lista()
lista_agregar(labels, 0)  # punto1 → cluster 0
lista_agregar(labels, 1)  # punto2 → cluster 1
# ... un label por cada punto
```

## 🎓 Tabla de Referencia Rápida

| Métrica | Mejor Valor | Rango | ¿Cuándo usar? |
|---------|-------------|-------|---------------|
| **Silhouette** | 1.0 | -1 a 1 | Evaluación general |
| **Davies-Bouldin** | 0.0 | 0 a ∞ | Compacidad de clusters |
| **Calinski-Harabasz** | ∞ | 0 a ∞ | Complemento a Silhouette |
| **Inercia** | 0.0 | 0 a ∞ | Método del codo |

## ✅ Checklist de Buenas Prácticas

- [ ] Normalizar datos antes de clustering
- [ ] Usar múltiples métricas (no solo una)
- [ ] Probar con diferentes valores de k
- [ ] Validar estabilidad con múltiples ejecuciones
- [ ] Revisar puntos con bajo Silhouette score

## 🔍 ¿Qué métrica usar?

### Caso General → **Silhouette Score**
```jasboot
flotante score = metricas.calcular_silhouette_score(X, labels)
si score > 0.5 entonces
    imprimir "✓ Buen clustering"
fin_si
```

### Elegir número de clusters → **Método del Codo + Silhouette**
```jasboot
# Graficar inercia vs k, buscar el "codo"
# Validar con Silhouette que el k elegido tenga buen score
```

### Comparar algoritmos → **Informe Completo**
```jasboot
mapa informe1 = metricas.informe_clustering(X, labels_kmeans)
mapa informe2 = metricas.informe_clustering(X, labels_dbscan)
# Comparar todas las métricas
```

### Detectar anomalías → **Silhouette por Muestra**
```jasboot
lista scores = metricas.calcular_silhouette_samples(X, labels)
# Puntos con score < 0 son sospechosos
```

## 🐛 Solución de Problemas

### Error: "Matriz X es nula"
**Solución**: Verificar que `X` esté inicializada
```jasboot
lista X = crear_lista()  # ← No olvidar esto
```

### Error: "Tamaños no coinciden"
**Solución**: `X` y `labels` deben tener el mismo tamaño
```jasboot
# Si X tiene 100 puntos, labels debe tener 100 etiquetas
```

### Warning: "Solo hay 1 cluster"
**Solución**: Las métricas requieren al menos 2 clusters
```jasboot
# Verificar que labels tenga valores diferentes: 0, 1, 2, etc.
```

### Score = 0.0
**Solución**: Verificar que los datos tengan varianza
```jasboot
# Asegurar que los puntos no sean todos idénticos
```

## 📚 Siguientes Pasos

1. **Leer documentación completa**: `README_CLUSTERING.md`
2. **Ejecutar tests**: `test_metricas_clustering.jasb`
3. **Ver ejemplo interactivo**: `ejemplo_clustering.jasb`
4. **Revisar resumen técnico**: `RESUMEN_CLUSTERING.md`

## 💡 Tip Pro

**Siempre combina métricas con visualización** y conocimiento del dominio. Las métricas son guías, no verdades absolutas.

```jasboot
# ✓ BIEN: Decisión basada en múltiples factores
mapa informe = metricas.informe_clustering(X, labels)
flotante silh = mapa_obtener(informe, "silhouette_score")
flotante db = mapa_obtener(informe, "davies_bouldin_index")

si silh > 0.5 y db < 1.0 entonces
    imprimir "✓ Clustering prometedor - revisar visualmente"
sino
    imprimir "⚠ Considerar ajustar parámetros"
fin_si

# ✗ MAL: Confiar ciegamente en una sola métrica
si silh > 0.5 entonces
    imprimir "Perfecto!" # ← Demasiado simplista
fin_si
```

---

**¿Listo para empezar?** Copia el ejemplo mínimo y adapta con tus datos. ¡Es así de simple!

**Versión**: 1.0 | **Actualizado**: 2024 | **Licencia**: Jasboot Project