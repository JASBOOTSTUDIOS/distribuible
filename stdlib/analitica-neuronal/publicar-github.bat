@echo off
REM ============================================================================
REM Script de Publicación Automática - analitica-neuronal v0.0.1
REM Para GitHub: https://github.com/JASBOOTSTUDIO/a-modulos.git
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================================
echo   PUBLICADOR DE PAQUETES JASBOOT - GITHUB
echo   Paquete: analitica-neuronal v0.0.1
echo   Repositorio: JASBOOTSTUDIO/a-modulos
echo ============================================================================
echo.

REM Verificar que el archivo .jpkg existe
if not exist "analitica-neuronal-0.0.1.jpkg" (
    echo [ERROR] No se encuentra el archivo analitica-neuronal-0.0.1.jpkg
    echo.
    echo Por favor ejecuta primero:
    echo   jpm pack
    echo.
    pause
    exit /b 1
)

echo [OK] Archivo .jpkg encontrado (983 KB)
echo.

REM Verificar si Git está instalado
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git no está instalado
    echo.
    echo Descarga Git desde: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo [OK] Git instalado
echo.

REM Preguntar al usuario si quiere continuar
echo Este script hara lo siguiente:
echo   1. Inicializar repositorio Git (si no existe)
echo   2. Configurar remoto: https://github.com/JASBOOTSTUDIO/a-modulos.git
echo   3. Crear branch: analitica-neuronal
echo   4. Agregar y commitear archivos del codigo fuente
echo   5. Push al repositorio
echo   6. Crear tag: analitica-neuronal-v0.0.1
echo   7. Push del tag
echo.
echo Despues deberas crear el Release manualmente en GitHub y adjuntar el .jpkg
echo.
set /p continuar="Deseas continuar? (S/N): "
if /i not "%continuar%"=="S" (
    echo.
    echo Operacion cancelada
    pause
    exit /b 0
)

echo.
echo ============================================================================
echo   PASO 1: Configurando Git
echo ============================================================================
echo.

REM Inicializar Git si no existe
if not exist ".git" (
    echo [INFO] Inicializando repositorio Git...
    git init
    if %errorlevel% neq 0 (
        echo [ERROR] Fallo al inicializar Git
        pause
        exit /b 1
    )
    echo [OK] Repositorio inicializado
) else (
    echo [INFO] Repositorio Git ya existe
)

echo.

REM Configurar remoto
echo [INFO] Configurando remoto...
git remote remove origin >nul 2>&1
git remote add origin https://github.com/JASBOOTSTUDIO/a-modulos.git
if %errorlevel% neq 0 (
    echo [ERROR] Fallo al configurar remoto
    pause
    exit /b 1
)
echo [OK] Remoto configurado: https://github.com/JASBOOTSTUDIO/a-modulos.git

echo.
echo ============================================================================
echo   PASO 2: Creando branch 'analitica-neuronal'
echo ============================================================================
echo.

git checkout -b analitica-neuronal 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Branch ya existe, cambiando a ella...
    git checkout analitica-neuronal
)
echo [OK] En branch: analitica-neuronal

echo.
echo ============================================================================
echo   PASO 3: Agregando archivos al commit
echo ============================================================================
echo.

echo [INFO] Agregando archivos de configuracion...
git add jasboot.json
git add .jpmignore

echo [INFO] Agregando archivos principales...
git add *.jasb

echo [INFO] Agregando modulos...
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

echo [INFO] Agregando documentacion...
git add README.md
git add GUIA_USO_COMPLETA.md
git add COMO_PUBLICAR_EN_GITHUB.md

echo [OK] Archivos agregados

echo.
echo ============================================================================
echo   PASO 4: Creando commit
echo ============================================================================
echo.

git commit -m "feat: Agregar analitica-neuronal v0.0.1

- Libreria completa de analitica y machine learning
- Estadistica descriptiva e inferencial
- Algoritmos de ML: KNN, Random Forest, SVM, etc.
- Series temporales y prediccion
- Metricas y validacion
- 71 archivos, 983 KB empaquetado

SHA-512: 4aa11ccf0d2ad47b1eea0358e5b457f93cd4edbd29755fed540d8651d74bf95a9db312d29a92685ccf25d9f8f1d492c5b5d8e03ea85ec1cb514c92cb9258fd76"

if %errorlevel% neq 0 (
    echo [ERROR] Fallo al crear commit
    echo Puede que no haya cambios para commitear
    echo.
)

echo.
echo ============================================================================
echo   PASO 5: Push al repositorio remoto
echo ============================================================================
echo.

echo [INFO] Haciendo push a GitHub...
echo [INFO] Es posible que te pida autenticacion...
echo.

git push -u origin analitica-neuronal

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Fallo al hacer push
    echo.
    echo Posibles causas:
    echo   1. No tienes permisos para el repositorio
    echo   2. Necesitas autenticarte con GitHub
    echo   3. Problemas de conexion
    echo.
    echo Para autenticarte, puedes:
    echo   - Usar GitHub CLI: gh auth login
    echo   - Usar Git Credential Manager
    echo   - Configurar SSH keys
    echo.
    pause
    exit /b 1
)

echo [OK] Push completado

echo.
echo ============================================================================
echo   PASO 6: Creando tag de version
echo ============================================================================
echo.

echo [INFO] Creando tag: analitica-neuronal-v0.0.1...

git tag -a analitica-neuronal-v0.0.1 -m "Release v0.0.1 de Analitica Neuronal

Libreria completa de analitica, estadistica y machine learning para Jasboot.

Caracteristicas principales:
- Estadistica descriptiva completa
- Probabilidad y distribuciones
- Inferencia estadistica
- Series temporales
- Machine Learning (10+ algoritmos)
- Modelos de prediccion
- Preprocesamiento y validacion

SHA-512: 4aa11ccf0d2ad47b1eea0358e5b457f93cd4edbd29755fed540d8651d74bf95a9db312d29a92685ccf25d9f8f1d492c5b5d8e03ea85ec1cb514c92cb9258fd76"

if %errorlevel% neq 0 (
    echo [ERROR] Fallo al crear tag
    pause
    exit /b 1
)

echo [OK] Tag creado

echo.
echo ============================================================================
echo   PASO 7: Push del tag
echo ============================================================================
echo.

echo [INFO] Enviando tag a GitHub...

git push origin analitica-neuronal-v0.0.1

if %errorlevel% neq 0 (
    echo [ERROR] Fallo al enviar tag
    pause
    exit /b 1
)

echo [OK] Tag enviado a GitHub

echo.
echo ============================================================================
echo   EXITO - Codigo publicado en GitHub
echo ============================================================================
echo.
echo [OK] El codigo fuente esta en GitHub
echo [OK] Branch: analitica-neuronal
echo [OK] Tag: analitica-neuronal-v0.0.1
echo.
echo ============================================================================
echo   SIGUIENTE PASO: Crear Release en GitHub
echo ============================================================================
echo.
echo Ahora debes crear el Release manualmente:
echo.
echo 1. Ve a: https://github.com/JASBOOTSTUDIO/a-modulos/releases
echo.
echo 2. Click en "Create a new release"
echo.
echo 3. Configuracion:
echo    - Tag version: analitica-neuronal-v0.0.1
echo    - Target: branch analitica-neuronal
echo    - Release title: Analitica Neuronal v0.0.1
echo.
echo 4. En Description, copia esto:
echo.
echo    # 🧠 Analitica Neuronal v0.0.1
echo
echo    Libreria completa de analitica, estadistica, probabilidad y machine learning para Jasboot.
echo
echo    ## Instalacion
echo
echo    ```bash
echo    jpm install https://github.com/JASBOOTSTUDIO/a-modulos/releases/download/analitica-neuronal-v0.0.1/analitica-neuronal-0.0.1.jpkg
echo    ```
echo
echo    ## Caracteristicas
echo
echo    - Estadistica descriptiva completa
echo    - Probabilidad y distribuciones
echo    - Inferencia estadistica
echo    - Series temporales
echo    - Machine Learning (10+ algoritmos)
echo    - Modelos de prediccion
echo    - Preprocesamiento y validacion
echo
echo    ## SHA-512
echo    ```
echo    4aa11ccf0d2ad47b1eea0358e5b457f93cd4edbd29755fed540d8651d74bf95a9db312d29a92685ccf25d9f8f1d492c5b5d8e03ea85ec1cb514c92cb9258fd76
echo    ```
echo.
echo 5. Adjunta el archivo: analitica-neuronal-0.0.1.jpkg
echo    (Arrastra o selecciona el archivo desde este directorio)
echo.
echo 6. Marca "This is a pre-release" (opcional)
echo.
echo 7. Click en "Publish release"
echo.
echo ============================================================================
echo.
echo DESPUES DE PUBLICAR EL RELEASE, LA URL SERA:
echo https://github.com/JASBOOTSTUDIO/a-modulos/releases/download/analitica-neuronal-v0.0.1/analitica-neuronal-0.0.1.jpkg
echo.
echo Los usuarios podran instalar con:
echo jpm install [URL de arriba]
echo.
echo ============================================================================
echo.
echo Presiona cualquier tecla para abrir GitHub en tu navegador...
pause >nul

start https://github.com/JASBOOTSTUDIO/a-modulos/releases/new

echo.
echo [INFO] Navegador abierto. Sigue los pasos de arriba.
echo.
pause
