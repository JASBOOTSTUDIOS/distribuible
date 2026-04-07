let acc = 0;
const ev = { id: 0, total: 0, nombre: "" };

for (let i = 0; i < 80000; i++) {
  ev.id = i;
  ev.total = i * 2;
  ev.nombre = "evento";
  acc += ev.id + ev.total + ev.nombre.length;
}

console.log(acc);
