@echo off
setlocal EnableExtensions
set "ROOT_DIR=%~dp0.."
pushd "%ROOT_DIR%"
set "ROOT=%CD%"
popd

set "JB_CLI=%ROOT%\bin\jb.jbo"
set "VM=%ROOT%\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe"

rem Si no existe el CLI compilado, intentar usar el ejecutable nativo directamente
if not exist "%JB_CLI%" (
    if "%~1"=="" (
        echo Uso: jb archivo.jasb [argumentos...]
        exit /b 1
    )
    "%VM%" %*
    exit /b %ERRORLEVEL%
)

rem Ejecutar el CLI unificado escrito en Jasboot, pasando el ROOT como primer argumento oculto
"%VM%" "%JB_CLI%" "%ROOT%" %*
exit /b %ERRORLEVEL%
