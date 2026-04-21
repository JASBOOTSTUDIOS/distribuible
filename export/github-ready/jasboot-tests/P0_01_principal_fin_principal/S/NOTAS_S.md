# S — Estrés (`principal` / `fin_principal`), **jbc**

## Script

- **`s_repeticion_compile_run.ps1`**: repite **N** veces (por defecto 200) la secuencia **compilar + ejecutar** (`jbc -e`) sobre `R/r_baseline_minimo.jasb`, resolviendo `jbc.exe` desde la raíz del repo (`bin\jbc.exe`).

## Uso

Ejecutar desde PowerShell en esta carpeta:

```powershell
.\s_repeticion_compile_run.ps1
```

Ajustar `$N` en el script para mayor presión (miles de ciclos).

## Objetivo

Detectar regresiones de **jbc** o de la VM ante repetición (manejos de archivos temporales `.jbo`, `spawn` de la VM, etc.), no la lógica del bloque `principal` en sí.

## Producción (carga realista P01)

- **`s_produccion_linea_base.jasb`**: envoltorio mínimo con una salida entera estable; útil como sanity check entre pasadas pesadas.
- Suite completa P01–P09: `tests/P0_estres_produccion_P01_P09_integracion/S/s_repeticion_todas_producciones_P01_P09.ps1`.
