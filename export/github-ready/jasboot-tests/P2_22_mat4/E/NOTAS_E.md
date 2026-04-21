# P2_22_mat4 — notas E

## Compilación (`jbc` debe fallar)

| Archivo | Qué prueba |
|---------|------------|
| `e_cu_p22_mat4_mul_vec4_arity.jasb` | `mat4_mul_vec4` con **2** argumentos. |
| `e_cu_p22_mat4_mul_arity.jasb` | `mat4_mul` con **2** argumentos. |
| `e_cu_p22_mat4_identidad_arity.jasb` | `mat4_identidad` **sin** argumentos. |
| `e_cu_p22_mat4_transpuesta_arity.jasb` | `mat4_transpuesta` con **1** argumento. |
| `e_cu_p22_mat4_inversa_arity.jasb` | `mat4_inversa` con **1** argumento. |
| `e_cu_p22_mat4_mul_vec4_no_id.jasb` | `mat4_mul_vec4` con tercer argumento **`vec4(...)`** (debe ser **identificador**). |
| `e_cu_p22_mat4_mul_no_id.jasb` | `mat4_mul` con segundo argumento **miembro** (`a.e1`), no matriz identificador. |

## Ejecución (compila; `jb` / VM deben fallar)

| Archivo | Qué prueba |
|---------|------------|
| `e_cu_p22_mat4_inversa_singular.jasb` | `mat4_inversa` sobre matriz **singular** (primera fila nula). Mensaje en stderr y **código de salida 1**. |

Comprobar aridad (PowerShell, desde la raíz del repo):

```powershell
Get-ChildItem tests\P2_22_mat4\E\e_cu_p22_mat4_*arity.jasb | ForEach-Object {
  & .\sdk-dependiente\jas-compiler-c\bin\jbc.exe $_.FullName -o $env:TEMP\p22e.jbo 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "FALLO: compilo (no deberia): $($_.Name)" }
}
```

Singular: `jbc` OK y ejecución con código ≠ 0. Con **`jbc -e`** (o `run-jasb`), el propio **jbc** elige la VM más reciente entre `jasboot-ir-vm.exe` y `jasboot-ir-vm-trace.exe` y, si la VM termina con código **1**, imprime un resumen en stderr además del mensaje de la VM (`mat4_inversa: matriz singular...`).

```powershell
& .\sdk-dependiente\jas-compiler-c\bin\jbc.exe tests\P2_22_mat4\E\e_cu_p22_mat4_inversa_singular.jasb -o $env:TEMP\p22sing.jbo -e
# Debe: stderr de la VM + linea jbc (-e); codigo de salida != 0; sin imprimir no_deberia
```
