# P2_29_mapa_crear_poner_obtener — notas E

## Compilación (`jbc` debe fallar)

| Archivo | Qué prueba |
|---------|------------|
| `e_cu_p29_mapa_poner_sin_argumentos.jasb` | `mapa_poner()` sin argumentos. |
| `e_cu_p29_mapa_poner_un_argumento.jasb` | `mapa_poner(m)` — faltan clave y valor. |
| `e_cu_p29_mapa_poner_dos_argumentos.jasb` | `mapa_poner(m, 1)` — falta valor. |
| `e_cu_p29_mapa_obtener_sin_argumentos.jasb` | `mapa_obtener()`. |
| `e_cu_p29_mapa_obtener_un_argumento.jasb` | `mapa_obtener(m)` — falta clave. |

## Ejecución (`jbc` OK; VM debe fallar sin `intentar`)

| Archivo | Qué prueba |
|---------|------------|
| `e_ej_p29_mapa_obtener_clave_inexistente.jasb` | `mapa_obtener` con clave no insertada; stderr con `clave de mapa inexistente`; no imprime `no_deberia`. |

```powershell
Get-ChildItem tests\P2_29_mapa_crear_poner_obtener\E\e_cu_p29_*.jasb | ForEach-Object {
  & .\sdk-dependiente\jas-compiler-c\bin\jbc.exe $_.FullName -o $env:TEMP\p29e.jbo 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "FALLO: compilo (no deberia): $($_.Name)" }
}
```

```powershell
$jbc = ".\sdk-dependiente\jas-compiler-c\bin\jbc.exe"
$vm  = ".\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe"
$f = "tests\P2_29_mapa_crear_poner_obtener\E\e_ej_p29_mapa_obtener_clave_inexistente.jasb"
& $jbc $f -o "$env:TEMP\p29ej.jbo"
if ($LASTEXITCODE -ne 0) { throw "jbc debia compilar" }
$out = & $vm "$env:TEMP\p29ej.jbo" 2>&1
if ($LASTEXITCODE -eq 0) { throw "VM debia fallar" }
if ("$out" -notmatch "clave de mapa inexistente") { throw "mensaje inesperado: $out" }
```
