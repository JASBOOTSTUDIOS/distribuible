# P2_26 — notas R

| Archivo | Esperado (`jasboot-ir-vm` tras `jbc`) |
|---------|----------------------------------------|
| `r_cu_p26_compuestos_comparaciones_shift.jasb` | Líneas: `15`, vacía, `3`, vacía, `eq`, vacía, `ne`, vacía, `le`, vacía, `ge`, vacía, `16`, vacía, `16`, vacía. |

```powershell
$jb = "$env:TEMP\p26r.jbo"
& .\sdk-dependiente\jas-compiler-c\bin\jbc.exe tests\P2_26_operadores_asignacion_y_dobles\R\r_cu_p26_compuestos_comparaciones_shift.jasb -o $jb
& .\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe $jb
```
