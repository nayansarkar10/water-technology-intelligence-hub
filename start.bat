@echo off
title Water Technology and Intelligence Hub Launcher
cd /d "%~dp0"

echo =================================================================
echo   WATER TECHNOLOGY and COMPETITIVE INTELLIGENCE HUB
echo =================================================================
echo.

set AGY_NODE="%APPDATA%\Antigravity\bin\agy-node.cmd"
if exist %AGY_NODE% (
    if exist server.js (
        echo Starting local web server with Antigravity Node...
        call %AGY_NODE% server.js
        goto end
    )
)

where node >nul 2>nul
if %errorlevel% equ 0 (
    if exist server.js (
        echo Starting local web server with Node.js...
        node server.js
        goto end
    )
)

REM Verify Python 3
python -c "import sys; print(sys.version)" >nul 2>nul
if %errorlevel% equ 0 (
    echo Starting local web server with Python 3...
    start "" "http://localhost:8080/"
    python -m http.server 8080
    goto end
)

REM Fallback to py launcher
py -3 -c "import sys; print(sys.version)" >nul 2>nul
if %errorlevel% equ 0 (
    echo Starting local web server with Python py launcher...
    start "" "http://localhost:8080/"
    py -3 -m http.server 8080
    goto end
)

echo Opening platform directly in default web browser...
start "" "index.html"
echo.
echo Platform opened successfully.
pause

:end
