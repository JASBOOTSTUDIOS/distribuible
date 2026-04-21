# S — estrés CPU y lenguaje (integración agresiva)

Batería opcional para **presionar flotantes, matrices, vectores, trig y llamadas a función** en bucles muy largos. Pensada para máquinas de desarrollo; los tiempos dependen de la CPU.

## Ejecutar

Desde la raíz del repo:

```powershell
.\bin\jb.cmd tests\S_estres_cpu_lenguaje\<archivo>.jasb
```

## Archivos

| Archivo | Carga principal |
|---------|-----------------|
| `s_estres_cpu_mega_mat4_mul.jasb` | Cientos de miles de `mat4_mul` (identidad encadenada). |
| `s_estres_cpu_rejilla_mvp_xxl.jasb` | Rejilla grande de `mat4_mul_vec4` + `si`/`sino` (pipeline tipo MVP). |
| `s_estres_cpu_vec_trig_millones.jasb` | Millones de `vec3_normalizar` + `vec3_dot` + `sin`/`cos`. |
| `s_estres_cpu_func_trig_acumula.jasb` | 2M llamadas a `funcion` con `sin`/`cos` en el cuerpo. |
| `s_estres_cpu_mat3_mat4_vec_hybrid.jasb` | 600k ciclos mezclando `mat3_*`, `mat4_mul_vec4` y trig. |

Salidas esperadas (checksums): comentarios al inicio de cada `.jasb` y `NOTAS_S.md`.
