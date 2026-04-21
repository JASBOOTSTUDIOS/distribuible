const fs = require("fs");

let out = "";
for (let i = 0; i < 600; i++) {
  out += "fila\n";
}
fs.writeFileSync("v8_io_roundtrip.txt", out, "utf8");
console.log(fs.readFileSync("v8_io_roundtrip.txt", "utf8").length);
