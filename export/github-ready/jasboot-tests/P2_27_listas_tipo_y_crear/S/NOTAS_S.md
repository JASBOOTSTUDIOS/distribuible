# P2_27 — notas S

| Archivo | Esperado |
|---------|----------|
| `s_estres_p27_mil_agregar.jasb` | `8000`, luego resumen `[lista id=… tamano=8000]` al imprimir `datos`. Ver comentarios en el `.jasb`. |
| `s_estres_p27_dos_listas_paralelas.jasb` | `3000`, vacía, `3000`, vacía, `2999`, vacía, `10000`, vacía. |
| `s_estres_p27_muchas_creaciones_huerfanas.jasb` | `1200`, vacía, `0`, vacía, `1199`, vacía. |
| `s_estres_p27_escaneo_obtener_acumulado.jasb` | `3123750`, vacía, `2500`, vacía. |
| `s_estres_p27_cuatro_listas_round_robin.jasb` | Cuatro veces `1200`, vacías entre números; luego `1199`, vacía, `9000`, vacía. |
| `s_estres_p27_anidado_doble_bucle.jasb` | `4000`, vacía, `0`, vacía, `7949`, vacía. |
| `s_estres_p27_tamano_repetido_en_bucle.jasb` | `3500`, vacía, `3499`, vacía. |
| `01_s_estres_p27_corchetes_y_miembro_bucle.jasb` | `399400`, vacía, `1197`, vacía. |
| `02_s_estres_p27_miles_liberar_pool.jasb` | `500`, vacía, `5988`, vacía — bucle 6000× `crear_lista` + `mem_lista_liberar` y acumulador cada 12 índices. |

```powershell
$jb = "$env:TEMP\p27s.jbo"
& .\sdk-dependiente\jas-compiler-c\bin\jbc.exe tests\P2_27_listas_tipo_y_crear\S\s_estres_p27_mil_agregar.jasb -o $jb
& .\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe $jb
```
