const linea = "usuario=42|accion=abrir|estado=ok\n";
let s = "";

for (let i = 0; i < 2500; i++) {
  s += linea;
}

const partes = s.split("\n");
const primera = partes[0];
const despues = primera.split("accion=")[1];
const accion = despues.split("|")[0];
let acc = s.length;
acc += s.includes("estado=ok") ? 1 : 0;
acc += primera.endsWith("ok") ? 1 : 0;
acc += accion.length;

console.log(acc);
