# S — Estrés (`entero`, `=`), **jbc**

## Script

`s_repeticion_compile_run.ps1` invoca **`bin\jbc.exe`** (desde la raíz del repo) en bucle sobre `../R/r_ok_basico.jasb` con la opción **`-e`** (compilar y ejecutar en un paso).

## Cifra de referencia

Tras una corrida en entorno de desarrollo (2026-03-25): **120** iteraciones, **~4.7 s** total (`iteraciones=120 tiempo_total_ms=4696`). Las máquinas variarán; el script falla con excepción si alguna iteración devuelve `LASTEXITCODE` distinto de **0**.

## Producción (P03)

- **`s_produccion_churn_asignaciones.jasb`**: cientos de vueltas con reasignación, `+=` y variable local por iteración (patrón agregación). Última referencia de salida: **41400**.
- Integración P01–P09: `tests/P0_estres_produccion_P01_P09_integracion/`.
