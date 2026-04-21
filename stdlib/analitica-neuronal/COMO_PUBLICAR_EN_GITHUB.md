# 📦 GUÍA: Publicar analitica-neuronal en GitHub

**Tu Fork (trabajo):** https://github.com/JASBOOTSTUDIOS/a-modulos.git  
**Repositorio Oficial:** https://github.com/JASBOOTSTUDIO/a-modulos.git  
**Paquete:** `analitica-neuronal-0.0.1.jpkg`  
**Ubicación:** `C:\src\jasboot\stdlib\analitica-neuronal\analitica-neuronal-0.0.1.jpkg`

---

## 🔄 FLUJO DE TRABAJO (Fork → PR → Release)

```
1. Subes código a TU FORK
   └─ https://github.com/JASBOOTSTUDIOS/a-modulos.git
   
2. Creas Pull Request
   └─ De: JASBOOTSTUDIOS/a-modulos (tu fork)
   └─ A: JASBOOTSTUDIO/a-modulos (oficial)
   
3. Se revisa y aprueba el PR
   
4. Se hace merge al repositorio oficial
   
5. Se crea Release en el repositorio OFICIAL
   └─ Con el archivo .jpkg adjunto
   
6. Los usuarios instalan desde el repositorio OFICIAL
```

---

## 🎯 PASO 1: Subir al Fork Personal

### 1.1. Preparar repositorio local

```bash
# Navega al directorio
cd C:\src\jasboot\stdlib\analitica-neuronal

# Inicializa Git (si no está inicializado)
git init

# Configura tu fork como remoto "origin"
git remote add origin https://github.com/JASBOOTSTUDIOS/a-modulos.git

# Configura el repositorio oficial como "upstream"
git remote add upstream https://github.com/JASBOOTSTUDIO/a-modulos.git

# Verifica remotos
git remote -v
# Debe mostrar:
# origin    https://github.com/JASBOOTSTUDIOS/a-modulos.git (fetch)
# origin    https://github.com/JASBOOTSTUDIOS/a-modulos.git (push)
# upstream  https://github.com/JASBOOTSTUDIO/a-modulos.git (fetch)
# upstream  https://github.com/JASBOOTSTUDIO/a-modulos.git (push)
```

### 1.2. Crear branch para el paquete

```bash
# Crea branch específica para analitica-neuronal
git checkout -b analitica-neuronal

# Agrega archivos necesarios
git add jasboot.json
git add .jpmignore
git add *.jasb
git add estadistica/
git add probabilidad/
git add inferencia/
git add series_temporales/
git add machine_learning/
git add prediccion/
git add preprocesamiento/
git add visualizacion/
git add metricas/
git add validacion/
git add tests/
git add README.md
git add GUIA_USO_COMPLETA.md

# Commit
git commit -m "feat: Agregar analitica-neuronal v0.0.1

- Librería completa de analítica y machine learning
- Estadística descriptiva e inferencial  
- Algoritmos de ML: KNN, Random Forest, SVM, etc.
- Series temporales y predicción
- Métricas y validación
- 71 archivos, 983 KB empaquetado

SHA-512: 4aa11ccf0d2ad47b1eea0358e5b457f93cd4edbd29755fed540d8651d74bf95a9db312d29a92685ccf25d9f8f1d492c5b5d8e03ea85ec1cb514c92cb9258fd76"

# Push a TU FORK
git push -u origin analitica-neuronal
```

### 1.3. Crear tag local

```bash
# Crea tag con información detallada
git tag -a analitica-neuronal-v0.0.1 -m "Release v0.0.1 de Analítica Neuronal

Librería completa de analítica, estadística y machine learning para Jasboot.

Características principales:
- Estadística descriptiva completa
- Probabilidad y distribuciones
- Inferencia estadística
- Series temporales
- Machine Learning (10+ algoritmos)
- Modelos de predicción
- Preprocesamiento y validación

SHA-512: 4aa11ccf0d2ad47b1eea0358e5b457f93cd4edbd29755fed540d8651d74bf95a9db312d29a92685ccf25d9f8f1d492c5b5d8e03ea85ec1cb514c92cb9258fd76"

# Push del tag a TU FORK
git push origin analitica-neuronal-v0.0.1
```

---

## 🎯 PASO 2: Crear Pull Request

### 2.1. Abrir Pull Request en GitHub

1. **Ve a tu fork:**  
   https://github.com/JASBOOTSTUDIOS/a-modulos

2. **Verás un banner amarillo** que dice:  
   *"analitica-neuronal had recent pushes"*  
   Click en **"Compare & pull request"**

3. **Configura el Pull Request:**
   - **Base repository:** `JASBOOTSTUDIO/a-modulos` (oficial, sin S)
   - **Base branch:** `main` o `master`
   - **Head repository:** `JASBOOTSTUDIOS/a-modulos` (tu fork, con S)
   - **Compare branch:** `analitica-neuronal`

4. **Título del PR:**
   ```
   feat: Agregar librería analitica-neuronal v0.0.1
   ```

5. **Descripción del PR:**
   ```markdown
   # 🧠 Analítica Neuronal v0.0.1
   
   ## Descripción
   
   Librería completa de analítica, estadística, probabilidad y machine learning para Jasboot.
   
   ## Contenido
   
   - ✅ **Estadística descriptiva completa**
     - Media, mediana, moda, varianza, desviación estándar
     - Percentiles, cuartiles, rango intercuartílico
     - Asimetría y curtosis
   
   - ✅ **Probabilidad y distribuciones**
     - Distribución normal, binomial, Poisson
     - PDF, CDF, funciones de probabilidad
   
   - ✅ **Inferencia estadística**
     - Correlación de Pearson y Spearman
     - Pruebas de hipótesis (Z-test, T-test)
     - Intervalos de confianza
   
   - ✅ **Series temporales**
     - Suavizado exponencial (SES, Holt)
     - ARIMA
     - Autocorrelación
   
   - ✅ **Machine Learning (10+ algoritmos)**
     - KNN (clasificación y regresión)
     - Regresión logística
     - Random Forest
     - SVM
     - Gradient Boosting
     - Clustering (K-Means, DBSCAN)
   
   - ✅ **Modelos de predicción**
     - Regresión lineal multidimensional
     - Ensembles
   
   - ✅ **Preprocesamiento**
     - Normalización (Min-Max, Z-Score)
     - Reducción de dimensionalidad (PCA)
     - Selección de features
   
   - ✅ **Métricas de evaluación**
     - Clasificación: Accuracy, Precision, Recall, F1-Score
     - Regresión: MAE, MSE, RMSE, R²
     - Clustering: Silhouette, Davies-Bouldin
   
   - ✅ **Validación**
     - Split de datos (train/test)
     - Cross-validation
   
   - ✅ **Visualización**
     - Histogramas, boxplots, gráficos analíticos
   
   ## Archivos
   
   - **Total:** 71 archivos
   - **Tamaño empaquetado:** 983 KB
   - **Formato:** `.jpkg` (listo para JPM)
   
   ## Verificación de Integridad
   
   **SHA-512:**
   ```
   4aa11ccf0d2ad47b1eea0358e5b457f93cd4edbd29755fed540d8651d74bf95a9db312d29a92685ccf25d9f8f1d492c5b5d8e03ea85ec1cb514c92cb9258fd76
   ```
   
   ## Testing
   
   - ✅ Tests incluidos en `tests/`
   - ✅ Compilación verificada
   - ✅ Sintaxis validada
   
   ## Documentación
   
   - ✅ README.md completo
   - ✅ GUIA_USO_COMPLETA.md con ejemplos
   - ✅ Comentarios en código
   
   ## Instalación (después del merge)
   
   ```bash
   jpm install https://github.com/JASBOOTSTUDIO/a-modulos/releases/download/analitica-neuronal-v0.0.1/analitica-neuronal-0.0.1.jpkg
   ```
   
   ## Checklist
   
   - [x] Código funcional y testeado
   - [x] Documentación completa
   - [x] jasboot.json configurado
   - [x] .jpmignore configurado
   - [x] Paquete .jpkg generado
   - [x] Hash SHA-512 calculado
   - [x] Sin archivos innecesarios
   ```

6. **Click en "Create pull request"**

### 2.2. Esperar Revisión

- El mantenedor del repositorio oficial revisará tu PR
- Puede pedir cambios o aprobar directamente
- Una vez aprobado, se hará **merge** al repositorio oficial

---

## 🎯 PASO 3: Crear Release en el Repositorio OFICIAL

**⚠️ IMPORTANTE:** El Release se crea en el repositorio OFICIAL, NO en tu fork.

### 3.1. Después del Merge

Una vez que tu PR fue aprobado y merged:

1. **Ve al repositorio OFICIAL:**  
   https://github.com/JASBOOTSTUDIO/a-modulos

2. **Ve a "Releases":**  
   https://github.com/JASBOOTSTUDIO/a-modulos/releases

3. **Click en "Create a new release"**

### 3.2. Configurar el Release

**Tag version:**
```
analitica-neuronal-v0.0.1
```

**Target:**
- Selecciona la branch donde se hizo el merge (probablemente `main` o `master`)

**Release title:**
```
Analítica Neuronal v0.0.1
```

**Description:**
```markdown
# 🧠 Analítica Neuronal v0.0.1

Librería completa de analítica, estadística, probabilidad y machine learning para Jasboot.

## 📦 Instalación

### Con JPM (Jasboot Package Manager)

```bash
jpm install https://github.com/JASBOOTSTUDIO/a-modulos/releases/download/analitica-neuronal-v0.0.1/analitica-neuronal-0.0.1.jpkg
```

### Manual

1. Descarga `analitica-neuronal-0.0.1.jpkg`
2. Ejecuta: `jpm install analitica-neuronal-0.0.1.jpkg`

## ✨ Características Principales

- ✅ **Estadística descriptiva completa**
- ✅ **Probabilidad y distribuciones**
- ✅ **Inferencia estadística**
- ✅ **Series temporales**
- ✅ **Machine Learning** (10+ algoritmos)
- ✅ **Modelos de predicción**
- ✅ **Preprocesamiento de datos**
- ✅ **Métricas de evaluación**
- ✅ **Validación de modelos**
- ✅ **Visualización**

## 📚 Documentación

- [README.md](https://github.com/JASBOOTSTUDIO/a-modulos/blob/analitica-neuronal/README.md)
- [Guía de Uso Completa](https://github.com/JASBOOTSTUDIO/a-modulos/blob/analitica-neuronal/GUIA_USO_COMPLETA.md)

## 🔐 Verificación de Integridad

**SHA-512:**
```
4aa11ccf0d2ad47b1eea0358e5b457f93cd4edbd29755fed540d8651d74bf95a9db312d29a92685ccf25d9f8f1d492c5b5d8e03ea85ec1cb514c92cb9258fd76
```

**Verificar en Windows (PowerShell):**
```powershell
Get-FileHash analitica-neuronal-0.0.1.jpkg -Algorithm SHA512
```

**Verificar en Linux/macOS:**
```bash
sha512sum analitica-neuronal-0.0.1.jpkg
```

## 📊 Estadísticas

- **Archivos:** 71
- **Tamaño:** 983 KB
- **Módulos:** 11
- **Algoritmos ML:** 10+

## 🐛 Reportar Issues

https://github.com/JASBOOTSTUDIO/a-modulos/issues

## 📄 Licencia

MIT
```

### 3.3. Adjuntar el archivo .jpkg

1. En la sección **"Attach binaries"**
2. Arrastra o selecciona: `analitica-neuronal-0.0.1.jpkg`
3. Espera a que se suba (983 KB)

### 3.4. Publicar

1. ☑️ **Opcional:** Marca "Set as a pre-release" (si es versión 0.0.x)
2. ☑️ **Opcional:** Marca "Create a discussion for this release"
3. Click en **"Publish release"**

---

## 📥 URL FINAL DE INSTALACIÓN

Después de publicar el release, la URL será:

```
https://github.com/JASBOOTSTUDIO/a-modulos/releases/download/analitica-neuronal-v0.0.1/analitica-neuronal-0.0.1.jpkg
```

### Para usuarios finales:

```bash
# Instalación con JPM
jpm install https://github.com/JASBOOTSTUDIO/a-modulos/releases/download/analitica-neuronal-v0.0.1/analitica-neuronal-0.0.1.jpkg
```

---

## 🔄 ACTUALIZAR A UNA NUEVA VERSIÓN

Cuando necesites publicar v0.0.2, v1.0.0, etc:

### En tu fork:

```bash
# 1. Actualiza jasboot.json
# Cambia "version": "0.0.1" a "version": "0.0.2"

# 2. Empaqueta
jpm pack
# Genera: analitica-neuronal-0.0.2.jpkg

# 3. Commit y push
git add jasboot.json
git commit -m "chore: Bump version to 0.0.2"
git push origin analitica-neuronal

# 4. Tag
git tag -a analitica-neuronal-v0.0.2 -m "Release v0.0.2"
git push origin analitica-neuronal-v0.0.2
```

### Crear nuevo PR:

1. Ve a tu fork en GitHub
2. Crea nuevo Pull Request (misma branch)
3. Sigue el mismo proceso del PASO 2

### Después del merge:

1. Crea nuevo Release en el repositorio OFICIAL
2. Adjunta `analitica-neuronal-0.0.2.jpkg`

---

## 📊 DIAGRAMA DE FLUJO COMPLETO

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  TU COMPUTADORA                                             │
│  ───────────────                                            │
│                                                             │
│  1. Desarrollas código                                      │
│  2. jpm pack → analitica-neuronal-0.0.1.jpkg                │
│  3. git add, commit                                         │
│                                                             │
└──────────────────────┬──────────────────────────────────────┘
                       │ git push origin
                       ↓
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  TU FORK (JASBOOTSTUDIOS/a-modulos)                         │
│  ────────────────────────────────────                       │
│                                                             │
│  Branch: analitica-neuronal                                 │
│  Tag: analitica-neuronal-v0.0.1                             │
│                                                             │
└──────────────────────┬──────────────────────────────────────┘
                       │ Pull Request
                       ↓
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  REPOSITORIO OFICIAL (JASBOOTSTUDIO/a-modulos)              │
│  ───────────────────────────────────────────                │
│                                                             │
│  1. Se revisa el PR                                         │
│  2. Se hace merge                                           │
│  3. Se crea Release con .jpkg                               │
│                                                             │
└──────────────────────┬──────────────────────────────────────┘
                       │ Release URL
                       ↓
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  USUARIOS FINALES                                           │
│  ──────────────                                             │
│                                                             │
│  jpm install https://github.com/JASBOOTSTUDIO/.../pkg.jpkg  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## ❓ PREGUNTAS FRECUENTES

### ¿Por qué usar un fork?

Para mantener el repositorio oficial limpio. Los cambios se revisan antes de ser integrados.

### ¿Quién crea el Release?

El mantenedor del repositorio oficial (JASBOOTSTUDIO) después de aprobar el PR.

### ¿Dónde se sube el archivo .jpkg?

En el **Release del repositorio OFICIAL**, no en tu fork.

### ¿Puedo crear el Release en mi fork?

Sí, pero los usuarios deberían instalar desde el repositorio oficial para garantizar autenticidad.

### ¿Qué pasa si mi PR no se aprueba?

Haz los cambios solicitados en tu fork, commitea y push. El PR se actualizará automáticamente.

### ¿Cómo sincronizo mi fork con el oficial?

```bash
# Fetch cambios del repositorio oficial
git fetch upstream

# Merge en tu branch local
git checkout main
git merge upstream/main

# Push a tu fork
git push origin main
```

---

## 📞 SOPORTE

**Tu Fork:** https://github.com/JASBOOTSTUDIOS/a-modulos  
**Repositorio Oficial:** https://github.com/JASBOOTSTUDIO/a-modulos  
**Issues:** https://github.com/JASBOOTSTUDIO/a-modulos/issues  
**Documentación JPM:** `C:\src\jasboot\sdk-dependiente\manejador-de-paquetes\`

---

**¡Listo para publicar! 🚀**