@echo off
REM Si jbc.exe en esta carpeta esta desactualizado o bloqueado por el linker, este script
REM invoca el compilador construido en sdk-dependiente\jas-compiler-c\bin\jbc.exe .
call "%~dp0jbc.cmd" %*
