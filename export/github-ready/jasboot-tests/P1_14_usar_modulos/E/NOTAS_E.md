# E — `usar` (módulos), **jbc**

| Archivo | Intento | Resultado esperado con **jbc** |
|---------|---------|--------------------------------|
| `e_usar_ruta_inexistente.jasb` | `usar` apunta a un `.jasb` que no existe | **Fallo compilación** con mensaje que indica módulo inexistente (ruta mostrada). |
| `e_usar_ciclo_main.jasb` + `m_ciclo_a.jasb` / `m_ciclo_b.jasb` | A importa B, B importa A | **Fallo compilación** con mensaje de **dependencia circular**. |
| `e_usar_nombre_no_enviado.jasb` | `usar { triple } de` un módulo donde `triple` existe pero **no** lleva `enviar` | **Fallo compilación**: mensaje de que no está marcado con `enviar`. Ruta al módulo de ejemplo: `../R/r_mod_export.jasb`. |
