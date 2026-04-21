# NOTAS_S — S_estres_usar_cadena_4nivel

## `s_estres_usar_main.jasb`

Imprime dos enteros separados por línea vacía:

1. **`acc`**: acumulado de 350000 vueltas con `svc_cap_uno` (cadena l1→l2→l3→l4) + `hoja_mix` directo. Con la VM actual del repo: **91945262500** (anotado en el `.jasb`; si cambia semántica de `entero`, recalibrar).
2. **Comprobación fija**: `hoja_mix(999)` (= **361** con la definición actual: `bit_shl(7,4) + bit_shr(999,2)`).

Si el runtime usa enteros con ancho fijo y wrap, `acc` puede diferir; la segunda línea sirve de sanidad rápida.

**Recalibración:** ejecutar `jb.cmd` una vez y copiar el valor de `acc` al comentario del `.jasb` si hace falta.
