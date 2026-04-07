"use strict";
function inc(u) {
    return u + 1;
}
let i = 0;
while (i < 5000) {
    i = inc(i);
}
console.log(i);
