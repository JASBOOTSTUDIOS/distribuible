@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "ROOT=%~dp0..\.."
set "JBC=%ROOT%\sdk-dependiente\jas-compiler-c\bin\jbc.exe"
set "GCC=gcc"

if not exist "%JBC%" (
  echo ERROR: no se encuentra jbc.exe en %JBC%
  echo Ejecute: sdk-dependiente\jas-compiler-c\build.bat
  exit /b 1
)

"%JBC%" "%~dp0hola_mundo.jasb" -o "%~dp0hola_mundo.jbo"
if errorlevel 1 exit /b 1

where %GCC% >nul 2>&1
if errorlevel 1 (
  echo ERROR: gcc no esta en PATH ^(necesario para enlazar hola_mundo.exe^)
  exit /b 1
)

%GCC% -std=c11 -O2 -Wall "%~dp0jbo_launcher.c" -o "%~dp0hola_mundo.exe"
if errorlevel 1 exit /b 1

echo.
echo Listo:
echo   %~dp0hola_mundo.jbo   ^(binario Jasboot / IR^)
echo   %~dp0hola_mundo.exe   ^(launcher PE que invoca la VM^)
echo.
echo Prueba: hola_mundo.exe
exit /b 0
