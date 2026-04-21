# P2_28_listas_obtener_agregar — notas E

## Ejecución (compila; `jbc -e` / VM deben fallar)

| Archivo | Qué prueba |
|---------|------------|
| `e_cu_p28_mem_lista_obtener_indice_fuera_de_rango.jasb` | Un elemento; `mem_lista_obtener(buf, 99)`. Mensaje stderr y **código ≠ 0**. |
| `e_cu_p28_corchetes_indice_fuera_de_rango.jasb` | `buf[3]` con un solo elemento. |
| `e_cu_p28_obtener_lista_vacia.jasb` | Lista creada sin `agregar`; índice `0` con **tamano 0**. |

**Nota:** un **id de lista inexistente** (handle inválido) sigue devolviendo **0** sin abortar; la comprobación aplica solo cuando la lista **existe** en JMN.

```powershell
$jb = "$env:TEMP\p28e.jbo"
$vm = ".\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe"
Get-ChildItem tests\P2_28_listas_obtener_agregar\E\e_cu_p28_*.jasb | ForEach-Object {
  & .\sdk-dependiente\jas-compiler-c\bin\jbc.exe $_.FullName -o $jb 2>&1 | Out-Null
  if ($LASTEXITCODE -ne 0) { Write-Host "FALLO: no compilo: $($_.Name)"; return }
  & $vm $jb 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "FALLO: VM exit 0: $($_.Name)" }
}
```
