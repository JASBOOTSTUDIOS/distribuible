# P2_27 — notas E

| Archivo | Esperado |
|---------|----------|
| `e_cu_p27_llamada_lista_desconocida.jasb` | `jbc` código ≠ 0 (llamada no resuelta / sin lowering). |
| `e_cu_p27_mem_lista_agregar_sin_argumentos.jasb` | `jbc` código ≠ 0. |
| `e_cu_p27_mem_lista_agregar_un_argumento.jasb` | `jbc` código ≠ 0. |
| `e_cu_p27_mem_lista_tamano_sin_argumentos.jasb` | `jbc` código ≠ 0. |
| `e_cu_p27_mem_lista_obtener_un_argumento.jasb` | `jbc` código ≠ 0. |
| `01_e_p27_mem_lista_obtener_sin_args.jasb` | `jbc` código ≠ 0. |
| `02_e_p27_mem_lista_limpiar_sin_args.jasb` | `jbc` código ≠ 0 (aridad: hace falta la lista). |
| `03_e_p27_crear_lista_literal_cero.jasb` | `jbc` código ≠ 0 (`crear_lista(0)` rechazado). |
| `04_e_p27_crear_lista_demasiados_argumentos.jasb` | `jbc` código ≠ 0 (más de un argumento en `crear_lista`). |

```powershell
foreach ($f in Get-ChildItem tests\P2_27_listas_tipo_y_crear\E\*.jasb) {
  & .\sdk-dependiente\jas-compiler-c\bin\jbc.exe $f.FullName -o $env:TEMP\p27e.jbo 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "FALLO: compilo: $($f.Name)" }
}
```
