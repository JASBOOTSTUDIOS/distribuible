const fs = require('fs');
const tls = require('tls');

const server = tls.createServer({
  key: fs.readFileSync('c:/src/jasboot/tests/P4_55_red_nativa/certs/localhost-key.pem'),
  cert: fs.readFileSync('c:/src/jasboot/tests/P4_55_red_nativa/certs/localhost-cert.pem'),
}, (socket) => {
  socket.on('error', () => {});
  socket.on('data', () => {
    socket.end('pong');
  });
});

server.on('tlsClientError', () => {});
server.on('error', () => {});

server.listen(Number(process.argv[2] || 18447), '127.0.0.1');
