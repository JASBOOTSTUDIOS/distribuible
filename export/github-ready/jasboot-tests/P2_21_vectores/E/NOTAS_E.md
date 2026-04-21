# P2_21_vectores — notas E

Cada archivo debe **fallar la compilación** (`jbc` distinto de cero).

| Archivo | Qué prueba |
|---------|------------|
| `e_cu_p21_vec2_arity.jasb` | `vec2` con **3** argumentos → mensaje de constructor (2 requeridos). |
| `e_cu_p21_vec2_arity_un_arg.jasb` | `vec2` con **1** argumento → mismo tipo de mensaje. |
| `e_cu_p21_vec3_arity_extra.jasb` | `vec3` con **4** argumentos → constructor (3 requeridos). |
| `e_cu_p21_vec4_arity_pocos.jasb` | `vec4` con **3** argumentos → constructor (4 requeridos). |
| `e_cu_p21_vec3_cross_arity.jasb` | `vec3_cross` con **2** argumentos → aridad (3 requeridos). |
| `e_cu_p21_vec3_cross_demasiados.jasb` | `vec3_cross` con **4** argumentos → aridad. |
| `e_cu_p21_vec2_dot_demasiados.jasb` | `vec2_dot` con **3** argumentos → aridad (2 requeridos). |
| `e_cu_p21_vec3_dot_arity.jasb` | `vec3_dot` con **1** argumento → aridad. |
| `e_cu_p21_vec3_dot_miembro.jasb` | `vec3_dot(u.x, v)` → argumentos deben ser **identificadores** de vector, no miembros. |
| `e_cu_p21_vec3_longitud_arity.jasb` | `vec3_longitud` con **2** argumentos → aridad (1 requerido). |
| `e_cu_p21_vec3_normalizar_arity.jasb` | `vec3_normalizar` con **1** argumento → aridad (2 requeridos). |
| `e_cu_p21_vec4_normalizar_arity.jasb` | `vec4_normalizar` con **1** argumento → aridad. |

Comprobar todos (desde la raíz del repo):

```powershell
Get-ChildItem tests\P2_21_vectores\E\*.jasb | ForEach-Object {
  & .\sdk-dependiente\jas-compiler-c\bin\jbc.exe $_.FullName -o $env:TEMP\p21e.jbo 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "FALLO: compilo (no deberia): $($_.Name)" }
}
```
