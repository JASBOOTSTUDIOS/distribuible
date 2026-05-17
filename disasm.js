const fs = require("fs");
const path = require("path");

const file = process.argv[2] || "test_math6.jbo";
if (!fs.existsSync(file)) {
  console.error(`File not found: ${file}`);
  process.exit(1);
}

const buf = fs.readFileSync(file);
const HEADER_SIZE = 16;
const INSTR_SIZE = 5;

const opcodes = {
  0x00: "HALT",
  0x01: "MOVER",
  0x02: "LEER",
  0x03: "ESCRIBIR",
  0x04: "MOVER_U24",
  0x05: "LOAD_STR_HASH",
  0x42: "LLAMAR",
  0x43: "RETORNAR",
  0x44: "RESERVAR_PILA",
  0x5b: "IMPRIMIR_TEXTO",
  0xc6: "ESTABLECER_CONTEXTO",
  0xf2: "CONFIGURAR_REGLAS_CONTEXTO",
  0xd7: "STR_CONCATENAR_REG",
  0x72: "STR_REEMPLAZAR",
  0x98: "STR_DESDE_NUMERO",
  0x90: "CONV_I2F",
  0x33: "JSON_PARSE",
  0x8e: "JSON_PARSE",
};

const FLAG_A_IMM = 1 << 0;
const FLAG_B_IMM = 1 << 1;
const FLAG_C_IMM = 1 << 2;
const FLAG_REL = 1 << 3;
const FLAG_SAFE = 1 << 4;
const FLAG_C_REG = 1 << 5;
const FLAG_A_REG = 1 << 6;
const FLAG_B_REG = 1 << 7;

for (let i = HEADER_SIZE; i < buf.length - 4; i += INSTR_SIZE) {
  const pc = i - HEADER_SIZE;
  const op = buf[i];
  const flags = buf[i + 1];
  const a = buf[i + 2];
  const b = buf[i + 3];
  const c = buf[i + 4];

  const name = opcodes[op] || op.toString(16).toUpperCase().padStart(2, "0");

  let fstr = "";
  if (flags & FLAG_A_IMM) fstr += "A_IMM ";
  if (flags & FLAG_B_IMM) fstr += "B_IMM ";
  if (flags & FLAG_C_IMM) fstr += "C_IMM ";
  if (flags & FLAG_REL) fstr += "REL ";
  if (flags & FLAG_A_REG) fstr += "A_REG ";
  if (flags & FLAG_B_REG) fstr += "B_REG ";
  if (flags & FLAG_C_REG) fstr += "C_REG ";

  console.log(
    `PC=${pc.toString().padStart(4, " ")}: OP=${name.padEnd(25, " ")} A=${a.toString().padStart(3, " ")} B=${b.toString().padStart(3, " ")} C=${c.toString().padStart(3, " ")} F=${flags.toString(16).padStart(2, "0")} [${fstr.trim()}]`,
  );
}
