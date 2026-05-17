/**
 * Salida automatica del laboratorio MAI (cierra con "99" por stdin).
 * Uso: node tools/run_mai_laboratorio_smoke.cjs
 */
const { spawn } = require('child_process');
const path = require('path');

const root = path.resolve(__dirname, '..');
const run = path.join(root, '.vscode', 'run-jasb.cjs');
const jasb = path.join(root, 'apps', 'mai_laboratorio', 'mai_laboratorio.jasb');

const child = spawn(process.execPath, [run, jasb], {
  cwd: root,
  stdio: ['pipe', 'inherit', 'inherit'],
});
child.stdin.write('99\n');
child.stdin.end();
child.on('close', (code) => process.exit(code ?? 0));
