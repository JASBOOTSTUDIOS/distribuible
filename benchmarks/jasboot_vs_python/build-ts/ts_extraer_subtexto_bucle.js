"use strict";
let s = "x";
for (let i = 0; i < 95000; i++) {
    s += " ab ";
    s += "Jefry Astacio";
}
let tmp = "";
for (let j = 0; j < 3000000; j++) {
    tmp = s.slice(0, 120);
}
console.log(s.length);
console.log("");
console.log(tmp);
