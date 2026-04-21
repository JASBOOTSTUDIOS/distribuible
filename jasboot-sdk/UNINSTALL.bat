@echo off
setlocal enabledelayedexpansion

echo ╔══════════════════════════════════════════════════════════════╗
echo ║              DESINSTALADOR JASBOOT SDK v1.0                ║
echo ║          Lenguaje de Programación en Español                ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

rem Preguntar confirmación
set /p confirm="¿Estás seguro de que deseas desinstalar Jasboot SDK? (S/N): "
if /i not "%confirm%"=="S" (
    echo Desinstalación cancelada.
    pause
    exit /b 0
)

echo.
echo 🗑️ Desinstalando Jasboot SDK...
echo.

rem Eliminar del PATH del sistema
echo 🔧 Removiendo del PATH del sistema...
set "jasboot_path=%CD%\bin"

for /f "tokens=2*" %%a in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "user_path=%%b"

if defined user_path (
    echo !user_path! | findstr /i /c:"%jasboot_path%" >nul
    if not errorlevel 1 (
        rem Reemplazar la ruta del PATH
        set "new_path=!user_path:%jasboot_path%=!"
        rem Eliminar punto y coma duplicado si queda
        set "new_path=!new_path:;;=;!"
        setx PATH "!new_path!" >nul
        echo    ✓ Jasboot removido del PATH del usuario
    ) else (
        echo    ✓ Jasboot no estaba en el PATH
    )
) else (
    echo    ✓ PATH del usuario no encontrado
)

rem Eliminar acceso directo del escritorio
if exist "%USERPROFILE%\Desktop\Jasboot SDK.bat" (
    del "%USERPROFILE%\Desktop\Jasboot SDK.bat"
    echo    ✓ Acceso directo del escritorio eliminado
)

rem Preguntar si desea eliminar archivos de configuración
set /p delete_config="¿Deseas eliminar también los archivos de configuración y proyectos? (S/N): "
if /i "%delete_config%"=="S" (
    echo.
    echo 📁 Eliminando archivos del SDK...
    
    rem Eliminar directorio completo
    cd ..
    rmdir /s /q jasboot-sdk
    
    if exist jasboot-sdk (
        echo    ⚠️  Algunos archivos no pudieron ser eliminados
        echo    Puede que necesites ejecutar este script como administrador
    ) else (
        echo    ✓ SDK eliminado completamente
    )
) else (
    echo.
    echo 📁 Conservando archivos del SDK en: %CD%
    echo    Puedes eliminarlos manualmente más tarde si lo deseas
)

echo.
echo ✅ Desinstalación completada.
echo.
echo Gracias por haber usado Jasboot SDK.
echo Esperamos verte de nuevo pronto.
echo.
pause
