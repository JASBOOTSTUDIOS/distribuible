# P0_10 — `ingreso_inmediato` + `limpiar_consola`

Bateria enfocada en las nuevas instrucciones de I/O de terminal:

- `ingreso_inmediato variable` (lectura no bloqueante de tecla/input inmediato)
- `limpiar_consola()` (limpieza ANSI de consola)

## Objetivo

Validar estabilidad de compilacion + ejecucion en escenarios de polling intensivo y limpieza reiterada de pantalla, que son patrones comunes de bucles de juego/monitor en consola.

## Contenido

| Ruta | Rol |
|------|-----|
| `S/s_estres_ingreso_inmediato_polling.jasb` | Miles de lecturas no bloqueantes consecutivas. |
| `S/s_estres_limpiar_consola_repetido.jasb` | Limpieza de consola en rafaga con trazas breves. |
| `S/s_estres_mixto_loop_terminal.jasb` | Mezcla ambas instrucciones en loop tipo game-frame. |
| `S/s_repeticion_compile_run.ps1` | Runner de repeticion para los 3 casos. |
| `S/NOTAS_S.md` | Notas y resultados esperados. |

