const fs = require("fs");
const h = fs.readFileSync(
  "c:/src/jasboot/sdk-dependiente/jasboot-ir/src/ir_format.h",
  "utf8",
);
const vals = [];
for (const m of h.matchAll(/=\s*(0x[0-9A-Fa-f]+)/gi)) {
  vals.push(parseInt(m[1], 16));
}
const uniq = new Set(vals);
console.log("assignments", vals.length, "unique", uniq.size);
const used = [...uniq].sort((a, b) => a - b);
const free = [];
for (let i = 0; i < 256; i++) if (!uniq.has(i)) free.push(i);
console.log("free bytes", free.length, free.slice(0, 40).map((x) => "0x" + x.toString(16)));

const v = fs.readFileSync("c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c", "utf8");
const sym = [];
for (const m of v.matchAll(/case\s+(OP_[A-Z0-9_]+)\s*:/g)) sym.push(m[1]);
console.log("vm symbolic cases", sym.length);
