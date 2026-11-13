// server.js - Zero-Dependency Local HTTP Server for Water Technology & Intelligence Hub
// Works out-of-the-box on Windows, macOS, and Linux with pure Node.js built-in modules.

const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

let PORT = 8080;
const BASE_DIR = __dirname;

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  '.pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  '.pdf': 'application/pdf',
  '.txt': 'text/plain; charset=utf-8'
};

const server = http.createServer((req, res) => {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  let reqUrl = decodeURI(req.url.split('?')[0]);
  if (reqUrl === '/' || reqUrl === '' || reqUrl === '/index.html') {
    reqUrl = 'index.html';
  } else {
    reqUrl = reqUrl.replace(/^\/+/, '');
  }

  const filePath = path.join(BASE_DIR, reqUrl);

  fs.stat(filePath, (err, stats) => {
    if (err || !stats.isFile()) {
      res.writeHead(404, { 'Content-Type': 'text/html; charset=utf-8' });
      res.end(`
        <!DOCTYPE html>
        <html>
        <head><title>404 Not Found</title></head>
        <body style="font-family: sans-serif; text-align: center; padding: 50px; background: #0A192F; color: #fff;">
          <h1 style="color: #F97316;">404 - File Not Found</h1>
          <p>The requested file <code>${reqUrl}</code> was not found on this server.</p>
          <p><a href="/index.html" style="color: #38BDF8; text-decoration: none; font-weight: bold;">&larr; Return to Home Dashboard</a></p>
        </body>
        </html>
      `);
      return;
    }

    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';

    res.writeHead(200, {
      'Content-Type': contentType,
      'Content-Length': stats.size,
      'Cache-Control': 'no-cache'
    });

    const readStream = fs.createReadStream(filePath);
    readStream.pipe(res);
  });
});

function openBrowser(url) {
  const start = (process.platform === 'darwin' ? 'open' : process.platform === 'win32' ? 'start ""' : 'xdg-open');
  exec(`${start} "${url}"`, (err) => {
    if (err) {
      console.log(`Open in your browser: ${url}`);
    }
  });
}

function startServer(portToTry) {
  server.listen(portToTry, () => {
    const url = `http://localhost:${portToTry}/`;
    console.log('=================================================================');
    console.log('  WATER TECHNOLOGY & COMPETITIVE INTELLIGENCE HUB');
    console.log('=================================================================');
    console.log('  Status: Running');
    console.log(`  Local URL: ${url}`);
    console.log(`  Directory: ${BASE_DIR}`);
    console.log('-----------------------------------------------------------------');
    console.log('  Opening platform in your default web browser...');
    console.log('  Press Ctrl+C in this terminal window to stop the server.');
    console.log('=================================================================');
    openBrowser(url);
  });

  server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      console.log(`Port ${portToTry} is in use, trying port ${portToTry + 1}...`);
      startServer(portToTry + 1);
    } else {
      console.error('Server error:', err);
    }
  });
}

startServer(PORT);
