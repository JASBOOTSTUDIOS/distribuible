# P2_25_bits_unsigned — notas E

| Archivo | Esperado |
|---------|----------|
| `e_cu_p25_bit_shl_arity.jasb` | `jbc` codigo != 0 (un solo argumento). |
| `e_cu_p25_bit_shr_arity.jasb` | `jbc` codigo != 0 (cero argumentos). |
| `e_cu_p25_bit_shl_tres_args.jasb` | `jbc` codigo != 0 (tres argumentos). |

```powershell
foreach ($f in Get-ChildItem tests\P2_25_bits_unsigned\E\*.jasb) {
  & .\sdk-dependiente\jas-compiler-c\bin\jbc.exe $f.FullName -o $env:TEMP\p25e.jbo 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "FALLO: compilo: $($f.Name)" }
}
```
