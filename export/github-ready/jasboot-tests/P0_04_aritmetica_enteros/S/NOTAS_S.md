# S — Estrés aritmética entera (P04)

## Archivos

| Archivo | Notas |
|---------|--------|
| `s_produccion_hotpath_aritmetica.jasb` | **~60k** vueltas con `+ - * / %` combinados; útil como núcleo caliente tipo batch. |
| `s_reasignacion_variable_no_declarada.jasb` | Caso de error semántico (no es estrés de producción “válido”; se mantiene por historial). |
| `s_uso_variable_no_declarada.jasb` | Ídem. |

## Integración

Ver `tests/P0_estres_produccion_P01_P09_integracion/` para pipeline que encadena P01–P09.
