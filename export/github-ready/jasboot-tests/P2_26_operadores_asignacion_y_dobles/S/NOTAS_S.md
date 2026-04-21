# P2_26 — notas S

| Archivo | Esperado |
|---------|----------|
| `s_estres_p26_bucle_mas_igual.jasb` | Una línea: `967978000` (suma de `0` a `43999`). Compilación y ejecución OK. |

La cota `i < 44000` evita que la suma supere `10^9` y active el formateo como timestamp en `OP_IMPRIMIR` de la VM (`vm_escribir_si_timestamp` en `vm.c`).

```powershell
$jb = "$env:TEMP\p26s.jbo"
& .\sdk-dependiente\jas-compiler-c\bin\jbc.exe tests\P2_26_operadores_asignacion_y_dobles\S\s_estres_p26_bucle_mas_igual.jasb -o $jb
& .\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe $jb
```
