# P2_24_trig_exp_log — notas E

## Compilacion (`jbc` debe fallar, codigo != 0)

| Archivo | Que prueba |
|---------|------------|
| `e_cu_p24_sin_sin_args.jasb` | `sin()` sin argumento. |
| `e_cu_p24_exp_sin_args.jasb` | `exp()` sin argumento. |
| `e_cu_p24_atan2_arity_uno.jasb` | `atan2` con un solo argumento. |
| `e_cu_p24_atan2_arity_tres.jasb` | `atan2` con tres argumentos. |

```powershell
Get-ChildItem tests\P2_24_trig_exp_log\E\*.jasb | ForEach-Object {
  & .\sdk-dependiente\jas-compiler-c\bin\jbc.exe $_.FullName -o $env:TEMP\p24e.jbo 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "FALLO: compilo: $($_.Name)" }
}
```
