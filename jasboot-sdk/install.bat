@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ===============================
:: JASBOOT SDK INSTALLER PRO v2.0
:: ===============================

:: Config
set "LOG=%~dp0install.log"
set "ERROR_FLAG=0"
set "SILENT=0"

:: Detect silent mode
if "%1"=="/S" set "SILENT=1"

:: Logger
:log
echo [%date% %time%] %~1 >> "%LOG%"
exit /b 0

:: Error handler
:fail
echo [ERROR] %~1
call :log "ERROR: %~1"
set "ERROR_FLAG=1"
goto rollback

:: Success message
:success
if "%SILENT%"=="0" (
    echo.
    echo [SUCCESS] Instalacion completada correctamente
)
call :log "Instalacion completada"
goto end

:: Rollback
:rollback
echo.
echo [ROLLBACK] Revirtiendo cambios...
call :log "Iniciando rollback"

if exist "build\hola.jbo" del /f /q "build\hola.jbo"

:: No eliminamos PATH automaticamente por seguridad
call :log "Rollback finalizado"
echo [FAIL] Instalacion fallida
pause
exit /b 1

:: ===============================
:: INICIO
:: ===============================

echo =============================================
echo     INSTALADOR JASBOOT SDK PRO
echo =============================================

call :log "Inicio de instalacion"

:: Verificar binarios
if not exist "bin\jbc.exe" (
    call :fail "No se encuentra jbc.exe"
)

if not exist "bin\jasboot-ir-vm.exe" (
    call :fail "No se encuentra jasboot-ir-vm.exe"
)

call :log "Binarios verificados"

:: Crear estructura
if not exist "temp" mkdir temp
if not exist "build" mkdir build

call :log "Directorios creados"

:: PATH setup
if "%SILENT%"=="0" (
    set /p add_path="Agregar al PATH? (S/N): "
    set "add_path=!add_path:~0,1!"
) else (
    set "add_path=S"
)

if /I "!add_path!"=="S" (
    set "jasboot_path=!CD!\bin"

    for /f "tokens=2*" %%a in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "user_path=%%b"

    echo(!user_path! | findstr /I /C:"!jasboot_path!" >nul
    if errorlevel 1 (
        call :log "Agregando al PATH"
        setx PATH "!user_path!;!jasboot_path!" >nul
    ) else (
        call :log "Ya estaba en PATH"
    )
)

:: Test compilacion
if exist "build\hola.jbo" del /f /q "build\hola.jbo"

echo.
echo [TEST] Compilando ejemplo...

"bin\jbc.exe" "examples\hola.jasb"
if errorlevel 1 (
    call :fail "Error en compilacion"
)

if not exist "build\hola.jbo" (
    call :fail "No se genero hola.jbo"
)

call :log "Compilacion exitosa"

:: Ejecutar

echo.
echo [TEST] Ejecutando ejemplo...
"bin\jasboot-ir-vm.exe" "build\hola.jbo"
if errorlevel 1 (
    call :fail "Error en ejecucion"
)

call :log "Ejecucion exitosa"

:: Crear launcher
if "%SILENT%"=="0" (
    set /p create_shortcut="Crear acceso directo? (S/N): "
    set "create_shortcut=!create_shortcut:~0,1!"
) else (
    set "create_shortcut=S"
)

if /I "!create_shortcut!"=="S" (
    setlocal DisableDelayedExpansion
    (
        echo @echo off
        echo cd /d "%CD%"
        echo echo JASBOOT SDK
        echo cmd /k
    ) > "%USERPROFILE%\Desktop\Jasboot SDK.bat"
    endlocal

    call :log "Acceso directo creado"
)

:: Final
call :success

:end
exit /b 0
