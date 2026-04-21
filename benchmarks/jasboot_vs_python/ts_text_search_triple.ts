let s = "x";
for (let i = 0; i < 800; i++) {
    s += "ab";
}

let acc = 0;
for (let j = 0; j < 5000; j++) {
    acc += s.includes("ab") ? 1 : 0;
    acc += s.indexOf("ab");
    acc += s.endsWith("b") ? 1 : 0;
}

console.log(s.length);
console.log("");
console.log(acc);
console.log("");
