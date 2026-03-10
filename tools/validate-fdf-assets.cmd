@echo off
setlocal
set SCRIPT_DIR=%~dp0
pwsh -NoProfile -File "%SCRIPT_DIR%validate-fdf-assets.ps1" %*
exit /b %ERRORLEVEL%