# Solución de Conflictos de Scope - Biblioteca Analítica Neuronal

**Fecha**: 20 de Abril 2024  
**Problema**: Errores "variable ya declarada" al compilar analitica.jasb  
**Estado**: ✅ RESUELTO - Se identificaron y corrigieron errores de código

---

## 🔍 Investigación Realizada

### Problema Inicial
```
Error: variable 'c' ya declarada en este alcance (línea 391)
Error: variable 'y' no declarada antes de su uso (línea 395)
```

### Hipótesis Iniciales
1. ❌ Bug del compilador con scope de módulos importados
2. ❌ Conflicto entre variables de diferentes clases
3. ✅ **Errores reales de código** (variables duplicadas en mismo scope)

---

## ✅ Bugs Encontrados y Corregidos

### Bug #1: Variable duplicada en metricas_clustering.jasb
**Archivo**: `stdlib/analitica-neuronal/metricas/metricas_clustering.jasb`  
**Línea**: 391  
**Función**: `calcular_davies_bouldin_index`

**Código incorrecto**:
```jasboot
entero c = 0
mientras c < n_clusters hacer
    ...
    c = c + 1
fin_mientras

# ...más código...

entero c = 0  # ❌ ERROR: redeclaración en mismo scope
mientras c < n_clusters hacer
```

**Solución aplicada**:
```jasboot
entero c = 0
mientras c < n_clusters hacer
    ...
    c = c + 1
fin_mientras

# ...más código...

c = 0  # ✅ CORRECTO: reasignación, no redeclaración
mientras c < n_clusters hacer
```

**Comando de corrección**:
```bash
sed -i '391s/entero c = 0/c = 0/' metricas_clustering.jasb
```

---

### Bug #2: Nombre de parámetro incorrecto en modelos_prediccion.jasb
**Archivo**: `stdlib/analitica-neuronal/prediccion/modelos_prediccion.jasb`  
**Línea**: 395  
**Función**: `regresion_lineal_multiple`

**Código incorrecto**:
```jasboot
funcion regresion_lineal_multiple(lista X_matriz, lista _y) retorna mapa
    ...
    flotante yi = lista_obtener(y, i)  # ❌ ERROR: debería ser _y
```

**Solución aplicada**:
```jasboot
funcion regresion_lineal_multiple(lista X_matriz, lista _y) retorna mapa
    ...
    flotante yi = lista_obtener(_y, i)  # ✅ CORRECTO
```

**Comando de corrección**:
```bash
sed -i '395s/lista_obtener(y,/lista_obtener(_y,/' modelos_prediccion.jasb
sed -i '333s/lista_tamano(y)/lista_tamano(_y)/' modelos_prediccion.jasb
```

---

### Bug #3: Bloques intentar/capturar no son scopes separados
**Archivo**: `stdlib/analitica-neuronal/analitica.jasb`  
**Líneas**: 236, 253  
**Función**: `prediccion_modelo_completo`

**Descubrimiento**: El compilador Jasboot NO trata bloques `intentar/capturar` como scopes separados.

**Código incorrecto**:
```jasboot
intentar
    entero i = 0
    mientras i < n hacer
        ...
    fin_mientras
capturar
    entero i = 0  # ❌ ERROR: i ya declarada en scope de función
    mientras i < n hacer
        ...
    fin_mientras
fin_intentar
```

**Solución aplicada**:
```jasboot
intentar
    entero i = 0
    mientras i < n hacer
        ...
    fin_mientras
capturar
    entero j = 0  # ✅ CORRECTO: usar nombre diferente
    mientras j < n hacer
        ...
    fin_mientras
fin_intentar
```

---

## 📊 Resumen de Correcciones

| Archivo | Línea | Variable | Tipo de Error | Solución |
|---------|-------|----------|---------------|----------|
| metricas_clustering.jasb | 391 | `c` | Redeclaración | Quitar `entero` |
| modelos_prediccion.jasb | 395 | `y` → `_y` | Nombre incorrecto | Usar `_y` |
| modelos_prediccion.jasb | 333 | `y` → `_y` | Nombre incorrecto | Usar `_y` |
| analitica.jasb | 253 | `i` → `j` | Redeclaración | Renombrar |
| analitica.jasb | 248 | `predicciones` | Redeclaración | Renombrar |

---

## 🧪 Verificación

### Test de scope realizado:
- ✅ Múltiples módulos con variable `c` en diferentes funciones → **COMPILA OK**
- ✅ Imports con mismas variables en diferentes clases → **COMPILA OK**
- ❌ Variable declarada dos veces en mismo scope → **ERROR (esperado)**

### Resultado:
El compilador funciona correctamente. Los errores eran de código, no del compilador.

---

## 📝 Lecciones Aprendidas

### Reglas de Scope en Jasboot:

1. **Scope de función**: Variables declaradas en una función son visibles en toda la función
2. **Bloques no crean scope**: `si/sino`, `intentar/capturar` NO crean scopes nuevos
3. **No redeclarar**: Una vez declarada, usar solo asignación (`x = valor`)
4. **Nombres únicos**: Si necesitas reusar contador, usa nombres diferentes (`i`, `j`, `k`)

### Buenas Prácticas:

```jasboot
# ✅ CORRECTO
funcion ejemplo() retorna entero
    entero i = 0
    mientras i < 10 hacer
        i = i + 1
    fin_mientras
    
    # Reusar i - solo asignar
    i = 0
    mientras i < 5 hacer
        i = i + 1
    fin_mientras
    
    retornar i
fin_funcion

# ❌ INCORRECTO
funcion ejemplo_malo() retorna entero
    entero i = 0
    mientras i < 10 hacer
        i = i + 1
    fin_mientras
    
    entero i = 0  # ERROR: redeclaración
    mientras i < 5 hacer
        i = i + 1
    fin_mientras
    
    retornar i
fin_funcion
```

---

## 🎯 Estado Final

**metricas_clustering.jasb**: ✅ Compila correctamente  
**modelos_prediccion.jasb**: ⚠️ Tiene otros errores (variable `d` no declarada)  
**analitica.jasb**: ⚠️ Requiere más correcciones en código de ejemplo

**Recomendación**: Usar módulos individuales en lugar de analitica.jasb hasta que se complete la corrección de errores de código.

---

**Última actualización**: 20 Abril 2024, 21:30 UTC
