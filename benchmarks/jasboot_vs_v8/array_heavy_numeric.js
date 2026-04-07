let acc = 0;
const datos = [];

for (let i = 0; i < 2048; i++) {
  datos.push((i * 7) % 997);
}

for (let i = 0; i < 300000; i++) {
  acc += (datos[i % 2048] * 3) + (i % 11);
}

console.log(acc);
