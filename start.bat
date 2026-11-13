@echo off
title Water Technology & Intelligence Hub Launcher
cd /d "%~dp0"

echo =================================================================
echo   WATER TECHNOLOGY & COMPETITIVE INTELLIGENCE HUB
echo =================================================================
echo.

set AGY_NODE="%APPDATA%\Antigravity\bin\agy-node.cmd"
if exist %AGY_NODE% (
    echo Starting local web server with Antigravity Node...
    call %AGY_NODE% server.js
    goto end
)

where node >nul 2>nul
if %errorlevel% equ 0 (
    echo Starting local web server with Node.js...
    node server.js
    goto end
)

where python >nul 2>nul
if %errorlevel% equ 0 (
    echo Starting local web server with Python 3...
    start "" "http://localhost:8080/index.html"
    python -m http.server 8080
    goto end
)

echo No local server runtime detected.
echo Opening platform directly in default web browser...
start "" "%~dp0index.html"
echo.
echo Platform opened successfully.
echo You can keep or close this window.
pause

:end
