# P2_27 — notas R

| Archivo | Esperado (`jasboot-ir-vm` tras `jbc`) |
|---------|----------------------------------------|
| `r_cu_p27_crear_vacio_literal_y_tres_apis.jasb` | `0`, línea vacía, `1`, vacía, `1`, vacía, `1`, vacía, `40`, vacía, `50`, vacía, `60`, vacía. |
| `r_cu_p27_crear_lista_literal_texto.jasb` | `1`, vacía, `100`, vacía. |
| `r_cu_p27_crear_lista_expresion_entero.jasb` | `1`, vacía, `9`, vacía. |
| `r_cu_p27_global_y_reasignacion.jasb` | `1`, vacía, `3`, vacía. |
| `r_cu_p27_crear_lista_id_explicito.jasb` | `1`, vacía, `42`, vacía. |
| `08_r_p27_tres_elementos_por_agregar.jasb` | `3`, vacía, `20`, vacía. |
| `09_r_p27_agregar_segundo_arg_llamada.jasb` | `2`, vacía, `1`, vacía. |
| `01_r_p27_alias_lista_agregar_obtener_tamano.jasb` | `2`, vacía, `7`, vacía, `8`, vacía. |
| `02_r_p27_miembro_tamano_medida_size.jasb` | Tres líneas `2` separadas por vacías. |
| `03_r_p27_dos_referencias_alias.jasb` | `2`, vacía, `200`, vacía. |
| `04_r_p27_indexacion_corchetes.jasb` | `11`, vacía, `22`, vacía, `2`, vacía. |
| `05_r_p27_funcion_parametro_lista.jasb` | `42`, vacía (2 + `lista_obtener` índice 0 = 40). |
| `06_r_p27_obtener_indice_valido.jasb` | `1`, vacía, `1`, vacía. |
| `07_r_p27_lista_limpiar_y_mem_alias.jasb` | `2`, vacía, `0`, vacía, `7`, vacía, `0`, vacía. |

```powershell
$jb = "$env:TEMP\p27r.jbo"
& .\sdk-dependiente\jas-compiler-c\bin\jbc.exe tests\P2_27_listas_tipo_y_crear\R\r_cu_p27_crear_vacio_literal_y_tres_apis.jasb -o $jb
& .\sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe $jb
```
