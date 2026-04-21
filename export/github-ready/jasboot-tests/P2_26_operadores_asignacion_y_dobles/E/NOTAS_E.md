# P2_26 — notas E

| Archivo | Esperado |
|---------|----------|
| `e_cu_p26_compuesto_miembro_registro.jasb` | `jbc` código ≠ 0; mensaje que indica que los operadores compuestos solo aplican a variable simple. |
| `e_cu_p26_compuesto_literal.jasb` | `jbc` código ≠ 0; error de sintaxis (literal a la izquierda de `+=`). |

```powershell
foreach ($f in Get-ChildItem tests\P2_26_operadores_asignacion_y_dobles\E\*.jasb) {
  & .\sdk-dependiente\jas-compiler-c\bin\jbc.exe $f.FullName -o $env:TEMP\p26e.jbo 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "FALLO: compilo: $($f.Name)" }
}
```
