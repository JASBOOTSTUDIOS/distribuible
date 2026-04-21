# P1_15 — `flotante`, aritmética y comparaciones

Cobertura del catálogo **P1 §15**: tipo `flotante`, literales decimales, operadores `+` `-` `*` `/`, comparaciones `==` `!=` `<` `>` `<=` `>=`, mezcla con `entero` (promoción a flotante) y menos unario.

## Cómo ejecutar (Windows)

Desde la raíz del monorepo, con `bin\jbc.exe` y `sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe` construidos:

```bat
bin\jb.cmd tests\P1_15_flotante\R\r_flotante_aritmetica.jasb
```

Estrés (misma herramienta):

```bat
bin\jbc.cmd tests\P1_15_flotante\S\s_estres_p15_hogar_kwh.jasb -e
```

O compilar y ejecutar a mano:

```bat
bin\jbc.exe tests\P1_15_flotante\R\r_flotante_comparaciones.jasb -o build\t.jbo -e
```

## Contenido

| Carpeta | Rol |
|---------|-----|
| `R/` | Casos válidos; cada `.jasb` lleva comentarios `#` con la salida o el comportamiento esperado. `r_division_cero_flotante.jasb` fija el contrato VM (`/ 0.0` → 0). Integración **P1_14 + P1_15**: `m_flotante_usar.jasb` y `r_usar_flotante_*.jasb` (`usar` + condicionales + flotante). Ver `R/NOTAS_R.md`. |
| `E/` | Errores de compilación (p. ej. `%` con flotantes). |
| `S/` | Estrés e integración flotante (bucles densos, malla de comparaciones, macros, escenario kWh). Ver `S/NOTAS_S.md`. |

Ver `E/NOTAS_E.md` para NaN/inf y división por cero. Para comparadores: `R/NOTAS_R.md` (salida esperada de `r_flotante_comparaciones.jasb`).
