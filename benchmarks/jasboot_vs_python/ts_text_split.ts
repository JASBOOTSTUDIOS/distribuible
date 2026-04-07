let s = "a";
for (let i = 0; i < 3000; i++) {
    s += ",a";
}
const parts = s.split(",");
console.log(parts.length);
console.log("");
