const tls = require('tls');

const request = Buffer.from(
  'GET /hola HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n',
  'utf8'
);

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function fetchOnce(port) {
  return new Promise((resolve, reject) => {
    const socket = tls.connect({
      host: '127.0.0.1',
      port,
      rejectUnauthorized: false,
      servername: 'localhost',
    });
    const chunks = [];
    let done = false;
    const finish = () => {
      if (done) return;
      done = true;
      resolve(Buffer.concat(chunks).toString('utf8'));
    };

    socket.on('secureConnect', () => socket.write(request));
    socket.on('data', (chunk) => chunks.push(chunk));
    socket.on('end', finish);
    socket.on('close', () => {
      if (chunks.length > 0) finish();
    });
    socket.on('error', (err) => {
      if (done) return;
      if (chunks.length > 0 && String(err && err.code || err).includes('ECONNRESET')) {
        finish();
        return;
      }
      done = true;
      reject(err);
    });
  });
}

async function main() {
  const port = Number(process.argv[2]);
  let acc = 0;
  for (let i = 0; i < 100; i++) {
    let text = null;
    for (let attempt = 0; attempt < 400; attempt++) {
      try {
        text = await fetchOnce(port);
        break;
      } catch (err) {
        const msg = String(err && err.code || err);
        if (!msg.includes('ECONNREFUSED') && !msg.includes('ECONNRESET')) throw err;
        await sleep(25);
      }
    }
    if (text === null) {
      throw new Error(`No se pudo conectar al puerto ${port}`);
    }
    acc += text.length;
  }
  console.log(acc);
}

main().catch((err) => {
  console.error(err && err.stack ? err.stack : String(err));
  process.exit(1);
});
