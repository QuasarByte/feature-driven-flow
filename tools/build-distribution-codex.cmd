@echo off
setlocal
set SCRIPT_DIR=%~dp0
pwsh -NoProfile -File "%SCRIPT_DIR%build-distribution-codex.ps1" %*
exit /b %ERRORLEVEL%