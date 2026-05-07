"use strict";
const fs = require("fs");
const path = process.argv[2];
if (!path) {
  console.error("Usage: node dump-op-leer.js <file.jbo>");
  process.exit(1);
}
const buf = fs.readFileSync(path);
const IR_HEADER_SIZE = 16;
const IR_INSTRUCTION_SIZE = 5;
const OP_LEER = 0x02;
const F_B_IMM = 1 << 1;
const F_C_IMM = 1 << 2;
const F_REL = 1 << 3;
const F_B_REG = 1 << 7;

let n = 0;
for (let i = IR_HEADER_SIZE; i + IR_INSTRUCTION_SIZE <= buf.length; i += IR_INSTRUCTION_SIZE) {
  const op = buf[i];
  if (op !== OP_LEER) continue;
  const f = buf[i + 1];
  const a = buf[i + 2];
  const b = buf[i + 3];
  const c = buf[i + 4];
  const bImm = !!(f & F_B_IMM);
  const rel = !!(f & F_REL);
  const bReg = !!(f & F_B_REG);
  const pc = i - IR_HEADER_SIZE;
  /* Direccion desde registro B sin relativo => uso de puntero absoluto desde reg b */
  if (bReg && !bImm && !rel) {
    console.log(
      `pc=${pc} LEER dest=R${a} addr=R${b} c=${c} f=0x${f.toString(16)} (B_REGISTER, no RELATIVE)`
    );
    n++;
  }
}
console.log(`total OP_LEER B_REGISTER sin RELATIVE: ${n}`);
