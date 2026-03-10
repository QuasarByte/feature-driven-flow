@echo off
setlocal
set SCRIPT_DIR=%~dp0
pwsh -NoProfile -File "%SCRIPT_DIR%convert-effective-instructions.ps1" %*
exit /b %ERRORLEVEL%