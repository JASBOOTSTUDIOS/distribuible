const path = "v8_io_roundtrip.txt";
let out = "";
for (let i = 0; i < 600; i++) {
  out += "fila\n";
}

if (typeof os !== "undefined" && typeof os.system === "function") {
  const escaped = out.replace(/\n/g, "\\n");
  os.system(`powershell -NoProfile -Command "$s='${escaped}'; [System.IO.File]::WriteAllText('${path}', $s.Replace('\\n', \"\`n\"))"`);
  print(read(path).length);
} else {
  throw new Error("d8 no expone os.system; no se puede ejecutar el benchmark de I/O.");
}
