const http = require('http');

const server = http.createServer((_req, res) => {
  res.sendDate = false;
  res.writeHead(200, {
    'Content-Type': 'text/plain',
    Connection: 'close',
    'Content-Length': '10',
  });
  res.end('ruta=/hola');
});

server.listen(18082, '127.0.0.1');
