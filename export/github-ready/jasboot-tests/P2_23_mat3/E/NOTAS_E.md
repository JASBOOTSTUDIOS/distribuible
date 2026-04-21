# P2_23_mat3 — notas E

## Compilación (`jbc` debe fallar)

| Archivo | Qué prueba |
|---------|------------|
| `e_cu_p23_mat3_mul_vec3_arity.jasb` | `mat3_mul_vec3` con **2** argumentos. |
| `e_cu_p23_mat3_mul_arity.jasb` | `mat3_mul` con **2** argumentos. |
| `e_cu_p23_mat3_mul_vec3_no_id.jasb` | Tercer argumento **`vec3(...)`** en lugar de identificador. |
| `e_cu_p23_mat3_mul_no_id.jasb` | Segundo argumento **miembro** (`mizq.e1`), no `mat3` identificador. |

Comprobar aridad y no-id (PowerShell, desde la raíz del repo):

```powershell
$e = @(
  "tests\P2_23_mat3\E\e_cu_p23_mat3_mul_vec3_arity.jasb",
  "tests\P2_23_mat3\E\e_cu_p23_mat3_mul_arity.jasb",
  "tests\P2_23_mat3\E\e_cu_p23_mat3_mul_vec3_no_id.jasb",
  "tests\P2_23_mat3\E\e_cu_p23_mat3_mul_no_id.jasb"
)
foreach ($f in $e) {
  & .\sdk-dependiente\jas-compiler-c\bin\jbc.exe (Join-Path $PWD $f) -o $env:TEMP\p23e.jbo 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "FALLO: compilo (no deberia): $f" }
}
```
