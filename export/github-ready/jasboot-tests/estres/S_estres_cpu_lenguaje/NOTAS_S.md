# NOTAS_S — S_estres_cpu_lenguaje

## Tiempos orientativos

Orden de magnitud (indicativo): `vec_trig_millones` (~40M iteraciones) suele ser el mas largo (**~0.5–3 min**). `mega_mat4_mul` (2M×2) y el híbrido mat3/mat4 suelen ir en **~10–90 s** según máquina. Usar solo para benchmark o estrés térmico.

## Checksums de referencia (float32, VM actual)

| Archivo | Salida principal |
|---------|------------------|
| `s_estres_cpu_mega_mat4_mul.jasb` | `1.0000` (`ac.e0`); 2M×2 `mat4_mul`. |
| `s_estres_cpu_rejilla_mvp_xxl.jasb` | `2311.3569` (checksum rejilla ~25k `mat4_mul_vec4`). |
| `s_estres_cpu_vec_trig_millones.jasb` | `0.6077`, `0.7941`, `0.0088`, `8.0000`; 40M vueltas normalizar+dot+trig. |
| `s_estres_cpu_func_trig_acumula.jasb` | `-0.0693`; 2M llamadas a función. |
| `s_estres_cpu_mat3_mat4_vec_hybrid.jasb` | `600588.0625`; 600k ciclos mat3+mat4+trig. |

Si actualizas la VM o el compilador y cambian los valores, recalibrar con `jb.cmd` y actualizar comentarios.
