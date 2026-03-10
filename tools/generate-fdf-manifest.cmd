@echo off
setlocal
set SCRIPT_DIR=%~dp0
pwsh -NoProfile -File "%SCRIPT_DIR%generate-fdf-manifest.ps1" %*
exit /b %ERRORLEVEL%