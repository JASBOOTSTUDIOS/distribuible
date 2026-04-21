# P1_20_1 — notas R

## Caso integrado

- `r_cu_p1201_funcion_orden_superior.jasb`: salida esperada **42** y **105** (líneas consecutivas). Cubre parámetro `funcion`, paso de global, variable `funcion` y lambda en el mismo programa.

## Cuatro ejemplos mínimos (solo parámetro `funcion`)

| Archivo | Qué muestra | Salida esperada (`imprimir`) |
|---------|-------------|-------------------------------|
| `r_cu_p1201_R01_param_funcion_callback.jasb` | Callback: `aplicar_uno(f, v)` con `f` global por nombre | una línea: **42** |
| `r_cu_p1201_R02_param_funcion_dos_estrategias.jasb` | Misma firma `ajustar(op, n)` con dos globales distintos | **11** luego **10** |
| `r_cu_p1201_R03_param_funcion_variable_lambda.jasb` | `funcion h` = lambda; se pasa a `ejecutar(g, n)` | **49** |
| `r_cu_p1201_R04_param_funcion_dos_veces.jasb` | `dos_veces(f, v)` aplica `f(f(v))` | **7** |

Ejecutar desde la raíz del repo, por ejemplo:

```powershell
.\bin\jb.cmd tests\P1_20_1\R\r_cu_p1201_R01_param_funcion_callback.jasb
```
