#!/usr/bin/env bash
# start.sh - Cross-platform launcher for macOS and Linux

cd "$(dirname "$0")"

echo "================================================================="
echo "  WATER TECHNOLOGY & COMPETITIVE INTELLIGENCE HUB"
echo "================================================================="
echo ""

if command -v node >/dev/null 2>&1; then
    echo "Starting local web server with Node.js..."
    node server.js
    exit 0
fi

if command -v python3 >/dev/null 2>&1; then
    echo "Starting local web server with Python 3..."
    if command -v open >/dev/null 2>&1; then
        open "http://localhost:8080/index.html"
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "http://localhost:8080/index.html"
    fi
    python3 -m http.server 8080
    exit 0
fi

echo "Opening platform directly in default web browser..."
if command -v open >/dev/null 2>&1; then
    open index.html
elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open index.html
else
    echo "Please open index.html in your web browser."
fi
