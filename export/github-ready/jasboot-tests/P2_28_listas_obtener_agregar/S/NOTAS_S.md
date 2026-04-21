# P2_28_listas_obtener_agregar — notas S

En esta carpeta hay pruebas **ligeras** y **profundas** (cientos de miles o millones de pasos de VM). Las profundas suelen tardar **~10–60 s** cada una en hardware reciente con `jasboot-ir-vm` (interpretación); el **02** (1M `agregar` con lista que crece hasta ~1M elementos) puede ser la más costosa en memoria y tiempo.

| Archivo | Esperado | Notas |
|---------|----------|--------|
| `01_s_estres_p28_obtener_cada_elemento.jasb` | `2000`, vacía, `1999`, vacía. | Referencia rápida. |
| `02_s_estres_p28_millon_agregar_consulta.jasb` | `1000000`, vacía, `0`, vacía, `999999`, vacía. | 1M `agregar` + lectura en extremos. |
| `03_s_estres_p28_dos_millones_suma_en_intentar.jasb` | `2000000`, vacía, `hecho`, vacía. | 2M incrementos dentro de `intentar` (sin fallo). |
| `04_s_estres_p28_millon_obtener_mod1000.jasb` | `499500000`, vacía. | 1M `obtener` sobre lista fija de 1000 elementos. |
| `05_s_estres_p28_doscientos_mil_crear_liberar.jasb` | `200000`, vacía, `42`, vacía. | 200k `crear_lista` + `liberar` (pool). |
| `06_s_estres_p28_millon_limpiar_reagregar.jasb` | `1`, vacía, `999999`, vacía. | 1M `lista_limpiar` + un `agregar` por vuelta. |

```powershell
$jbc = ".\sdk-dependiente\jas-compiler-c\bin\jbc.exe"
$vm  = ".\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe"
$dir = ".\tests\P2_28_listas_obtener_agregar\S"
# Ejemplo: solo estrés profundo (puede tardar varios minutos en conjunto)
foreach ($name in @(
  "02_s_estres_p28_millon_agregar_consulta.jasb",
  "03_s_estres_p28_dos_millones_suma_en_intentar.jasb",
  "04_s_estres_p28_millon_obtener_mod1000.jasb",
  "05_s_estres_p28_doscientos_mil_crear_liberar.jasb",
  "06_s_estres_p28_millon_limpiar_reagregar.jasb"
)) {
  $jasb = Join-Path $dir $name
  $jbo = [System.IO.Path]::ChangeExtension($jasb, ".jbo")
  & $jbc $jasb -o $jbo
  if ($LASTEXITCODE -ne 0) { Write-Host "FALLO compilar $name"; break }
  & $vm $jbo
  Write-Host "--- $name exit=$LASTEXITCODE ---"
}
```
