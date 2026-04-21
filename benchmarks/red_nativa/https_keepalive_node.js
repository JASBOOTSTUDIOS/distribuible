const https = require('https');

const agent = new https.Agent({
  keepAlive: true,
  maxSockets: 1,
  rejectUnauthorized: false,
});

function once() {
  return new Promise((resolve, reject) => {
    const req = https.request({
      host: '127.0.0.1',
      port: 18443,
      path: '/hola',
      method: 'GET',
      agent,
      servername: 'localhost',
      headers: { Connection: 'keep-alive' },
      rejectUnauthorized: false,
    }, (res) => {
      let data = '';
      res.setEncoding('utf8');
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => resolve(data.length));
    });
    req.on('error', reject);
    req.end();
  });
}

(async () => {
  let acc = 0;
  for (let i = 0; i < 100; i++) acc += await once();
  console.log(acc);
  agent.destroy();
})().catch((err) => {
  console.error(err && err.stack ? err.stack : String(err));
  process.exit(1);
});
