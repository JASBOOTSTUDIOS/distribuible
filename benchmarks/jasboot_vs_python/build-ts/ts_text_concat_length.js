"use strict";
let s = "a";
for (let i = 0; i < 8000; i++) {
    s += "bc";
}
console.log(s.length);
console.log("");
