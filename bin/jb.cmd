@echo off
setlocal EnableExtensions
REM CLI jb: compila con jbc (compilador C estable) y ejecuta con la VM.
REM Uso: jb archivo.jasb [argumentos para el programa]
REM   Salida: build\NombreBase.jbo

set "ROOT=%~dp0.."
REM Compilador actual del SDK (evita bin\jbc.exe antiguo o bloqueado al enlazar)
set "JBC=%ROOT%\sdk-dependiente\jas-compiler-c\bin\jbc.exe"
if not exist "%JBC%" set "JBC=%ROOT%\bin\jbc.exe"
set "VM=%ROOT%\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe"
set "BUILD=%ROOT%\build"

if "%~1"=="" (
  echo Uso: jb archivo.jasb [argumentos...]
  echo   Compila con jbc y ejecuta el .jbo con la VM.
  exit /b 1
)

if not exist "%JBC%" (
  echo Error: no se encuentra "%JBC%" ^(compile sdk-dependiente\jas-compiler-c\build.bat^)
  exit /b 1
)

if not exist "%VM%" (
  echo Error: no se encuentra la VM. Ejecute: sdk-dependiente\jasboot-ir\build_vm.bat
  exit /b 1
)

set "JASB=%~f1"
if not exist "%JASB%" (
  echo Error: no se encuentra "%~1"
  exit /b 1
)

if not exist "%BUILD%" mkdir "%BUILD%"
for %%F in ("%JASB%") do set "BASE=%%~nF"
set "JBO=%BUILD%\%BASE%.jbo"

REM Sin argumentos extra: deja que jbc fije cwd del .jasb al ejecutar (-e)
if "%~2"=="" (
  "%JBC%" "%JASB%" -o "%JBO%" -e
  exit /b %ERRORLEVEL%
)

"%JBC%" "%JASB%" -o "%JBO%"
if errorlevel 1 exit /b 1

set "CWD="
for %%F in ("%JASB%") do set "CWD=%%~dpF"
if defined CWD pushd "%CWD%"
"%VM%" "%JBO%" %2 %3 %4 %5 %6 %7 %8 %9
set "ER=%ERRORLEVEL%"
if defined CWD popd
exit /b %ER%
