# P1_19 — `seleccionar` / `intentar` / `lanzar`

Cobertura para nuevas construcciones de control:

- `seleccionar ... caso ... defecto ... fin_seleccionar`
- `intentar ... atrapar ... final ... fin_intentar`
- `lanzar <expr>`

## Contenido

| Ruta | Rol |
|------|-----|
| `E/` | Errores de sintaxis/semantica (`lanzar` fuera de `intentar`, cierres faltantes). |
| `R/` | Casos validos de seleccion y manejo de error. |
| `S/` | Estres en bucle con muchas decisiones y lanzamientos atrapados. |

