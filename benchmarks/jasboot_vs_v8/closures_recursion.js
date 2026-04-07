function fact(n) {
  return n <= 1 ? 1 : (n * fact(n - 1));
}

const base = 7;
const add7 = (x) => x + base;
let acc = 0;

for (let i = 0; i < 20000; i++) {
  acc += add7(i % 5);
  acc += fact(6);
}

console.log(acc);
