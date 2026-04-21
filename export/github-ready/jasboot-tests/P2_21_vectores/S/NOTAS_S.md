# P2_21_vectores — notas S

## `s_estres_p21_normalizar_millones.jasb`

- Bucle `1_000_000` de `vec3_normalizar(n, v)` con `v = (3, 4, 0)`.
- Al final imprime `n.x`, `n.y`, `n.z` (y líneas en blanco entre medias).

Salida esperada en la última terna (vector unitario en el plano XY):

| Línea | Valor aproximado |
|-------|------------------|
| `n.x` | `0.6000` |
| `n.y` | `0.8000` |
| `n.z` | `0.0000` |

Ejecutar:

```powershell
.\bin\jb.cmd tests\P2_21_vectores\S\s_estres_p21_normalizar_millones.jasb
```
