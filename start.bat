@echo off
title Water Technology and Intelligence Hub Launcher
cd /d "%~dp0"

echo =================================================================
echo   WATER TECHNOLOGY and COMPETITIVE INTELLIGENCE HUB
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

REM Verify real Python 3 (avoid Windows Store stub)
python -c "import sys; print(sys.version)" >nul 2>nul
if %errorlevel% equ 0 (
    echo Starting local web server with Python 3...
    start "" "http://localhost:8080/"
    python -m http.server 8080 --directory "%~dp0"
    goto end
)

REM Fallback to py launcher if available
py -3 -c "import sys" >nul 2>nul
if %errorlevel% equ 0 (
    echo Starting local web server with Python py launcher...
    start "" "http://localhost:8080/"
    py -3 -m http.server 8080 --directory "%~dp0"
    goto end
)

echo No server runtime (Node or Python) detected.
echo Opening platform directly in default web browser...
start "" "%~dp0index.html"
echo.
echo Platform opened successfully in your web browser.
echo Press any key to exit this launcher window.
pause >nul

:end
