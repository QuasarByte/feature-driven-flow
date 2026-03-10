@echo off
setlocal
set SCRIPT_DIR=%~dp0
pwsh -NoProfile -File "%SCRIPT_DIR%run-validation-cycle.ps1" %*
exit /b %ERRORLEVEL%