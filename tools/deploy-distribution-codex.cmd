@echo off
setlocal
set SCRIPT_DIR=%~dp0
pwsh -NoProfile -File "%SCRIPT_DIR%deploy-distribution-codex.ps1" %*
exit /b %ERRORLEVEL%