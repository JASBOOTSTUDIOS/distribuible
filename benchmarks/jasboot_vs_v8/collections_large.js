let acc = 0;
const valores = [];
const indices = new Map();

for (let i = 0; i < 20000; i++) {
  valores.push(i % 1000);
  indices.set(i, i * 3);
}

for (let i = 0; i < 20000; i++) {
  acc += valores[i % 1000];
  acc += indices.get(i);
}

console.log(acc);
