@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ejecutar_cascada_funcional.ps1" %*
exit /b %ERRORLEVEL%
