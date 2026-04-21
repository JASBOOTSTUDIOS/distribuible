# S — Estres nuevas instrucciones terminal

## Casos incluidos

- `s_estres_ingreso_inmediato_polling.jasb`: 15k lecturas no bloqueantes.
- `s_estres_limpiar_consola_repetido.jasb`: 120 limpiezas ANSI consecutivas.
- `s_estres_mixto_loop_terminal.jasb`: loop tipo juego (clear + ventana de captura inmediata).

## Validacion sugerida

```powershell
cd tests/P0_10_io_inmediato_consola/S
.\s_repeticion_compile_run.ps1
```

El objetivo principal es detectar cuelgues, validaciones IR rotas por opcode nuevo y regresiones de rendimiento en polling.

