const fs = require('fs');
const https = require('https');

const server = https.createServer({
  key: fs.readFileSync('c:/src/jasboot/tests/P4_55_red_nativa/certs/localhost-key.pem'),
  cert: fs.readFileSync('c:/src/jasboot/tests/P4_55_red_nativa/certs/localhost-cert.pem'),
}, (_req, res) => {
  res.sendDate = false;
  res.writeHead(200, {
    'Content-Type': 'text/plain',
    Connection: 'close',
    'Content-Length': '12',
  });
  res.end('seguro=/hola');
});

server.listen(18443, '127.0.0.1');
