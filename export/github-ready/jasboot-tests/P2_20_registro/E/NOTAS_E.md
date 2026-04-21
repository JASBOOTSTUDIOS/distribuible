# Errores esperados (P2 · 20)

| Archivo | Motivo |
|---------|--------|
| `e_cu_p20_sin_fin_registro.jasb` | Error explícito al encontrar `principal` (u otro bloque de nivel superior) **antes** de `fin_registro`: el registro no está cerrado (`parser.c`, `parse_struct_def`). |
| `e_cu_p20_campo_reservado_y.jasb` | El nombre de campo `y` es palabra reservada del lenguaje. |
| `e_cu_p20_miembro_desconocido.jasb` | Mensaje explícito: registro y nombre de campo (p. ej. `Punto` / `no_existe`), con línea y columna en el identificador del miembro (`parser.c` rellena `line`/`col` en `MemberAccessNode`; `codegen.c` emite el texto). |
