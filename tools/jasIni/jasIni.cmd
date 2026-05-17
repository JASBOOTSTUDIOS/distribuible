@echo off
setlocal EnableExtensions
rem jasIni — arranca el runner en Jasboot (jasIni.jbo). Argumentos: <entrada.jasb> [once] [debounce_ms]
rem Raiz del repo = dos niveles por encima de tools\jasIni (donde vive este .cmd).

rem %%~fI puede dejar barra final; con comillas en la misma linea rompe \" al concatenar rutas.
pushd "%~dp0..\.."
set "JASBOOT_REPO=%CD%"
popd
if not exist "%JASBOOT_REPO%\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe" (
  echo jasIni.cmd: no se encontro la VM en "%JASBOOT_REPO%\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe"
  exit /b 1
)

cd /d "%JASBOOT_REPO%"
if not exist "%JASBOOT_REPO%\tools\jasIni\jasIni.jbo" (
  echo jasIni.cmd: compilando tools\jasIni\jasIni.jasb ...
  node "%JASBOOT_REPO%\.vscode\run-jasb.cjs" "%JASBOOT_REPO%\tools\jasIni\jasIni.jasb"
  if errorlevel 1 exit /b 1
)

rem Pasar solo argumentos no vacios (evita "" final que en algunos hosts altera argc).
set "JASINI_A1=%~1"
set "JASINI_A2=%~2"
set "JASINI_A3=%~3"
if not defined JASINI_A1 goto :uso_host
if defined JASINI_A3 (
  "%JASBOOT_REPO%\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe" "%JASBOOT_REPO%\tools\jasIni\jasIni.jbo" "%JASBOOT_REPO%" "%JASINI_A1%" "%JASINI_A2%" "%JASINI_A3%"
) else if defined JASINI_A2 (
  "%JASBOOT_REPO%\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe" "%JASBOOT_REPO%\tools\jasIni\jasIni.jbo" "%JASBOOT_REPO%" "%JASINI_A1%" "%JASINI_A2%"
) else (
  "%JASBOOT_REPO%\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe" "%JASBOOT_REPO%\tools\jasIni\jasIni.jbo" "%JASBOOT_REPO%" "%JASINI_A1%"
)
goto :eof
:uso_host
echo jasIni.cmd: indique al menos la ruta del .jasb de entrada (relativa a la raiz del repo o absoluta).
echo Ejemplo: tools\jasIni\jasIni.cmd examples\hola_mundo_exe\hola_mundo.jasb once
exit /b 1
