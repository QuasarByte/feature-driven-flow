@echo off
setlocal
set SCRIPT_DIR=%~dp0
pwsh -NoProfile -File "%SCRIPT_DIR%deploy-distribution-claude.ps1" %*
exit /b %ERRORLEVEL%