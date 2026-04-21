@echo off
setlocal
set "ROOT=%~dp0.."
set "SDKJBC=%ROOT%\sdk-dependiente\jas-compiler-c\bin\jbc.exe"
if exist "%SDKJBC%" (
  "%SDKJBC%" %*
) else (
  "%~dp0jbc.exe" %*
)
exit /b %ERRORLEVEL%
