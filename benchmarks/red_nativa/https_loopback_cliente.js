const tls = require('tls');

const request = Buffer.from(
  'GET / HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n',
  'utf8'
);

function fetchOnce() {
  return new Promise((resolve, reject) => {
    const socket = tls.connect({
      host: '127.0.0.1',
      port: 18444,
      rejectUnauthorized: false,
      servername: 'localhost',
    });
    const chunks = [];
    let done = false;

    socket.on('secureConnect', () => {
      socket.write(request);
    });

    socket.on('data', (chunk) => {
      chunks.push(chunk);
    });

    socket.on('end', () => {
      if (done) return;
      done = true;
      resolve(Buffer.concat(chunks).toString('utf8').length);
    });

    socket.on('error', (err) => {
      if (done) return;
      done = true;
      reject(err);
    });
  });
}

async function main() {
  let acc = 0;
  for (let i = 0; i < 100; i++) {
    acc += await fetchOnce();
  }
  console.log(acc);
}

main().catch((err) => {
  console.error(err && err.stack ? err.stack : String(err));
  process.exit(1);
});
