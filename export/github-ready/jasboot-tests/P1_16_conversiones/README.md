# P1_16 — Conversiones implícitas entero ↔ flotante

Cobertura del catálogo **P1 §16**: promoción **`OP_CONV_I2F`** y truncado/conversión **`OP_CONV_F2I`** al asignar o al **`retornar`** cuando el tipo de destino y el de la expresión difieren (`entero` / `flotante`).

## Cómo ejecutar

Desde la raíz del monorepo:

```bat
bin\jbc.cmd tests\P1_16_conversiones\R\r_conv_f2i_declaracion.jasb -e
```

## Contenido

| Carpeta | Rol |
|---------|-----|
| `R/` | Programas válidos; salidas en comentarios `#` y en `R/NOTAS_R.md`. |
| `E/` | Deben **fallar al compilar** (`jbc` con código de salida ≠ 0): no conversión implícita a `entero`/`flotante` desde `texto`, `mapa`, `caracter`, etc. Ver `E/NOTAS_E.md`. |
| `S/` | Estrés P0–P1_16: bucles, funciones, macros, `convertir_*`, `str_desde_numero`, `decimal`. Ver `S/NOTAS_S.md`. |

La semántica de **F2I** en la VM coincide con la conversión **float → entero** en C (truncamiento hacia cero para valores representables).
