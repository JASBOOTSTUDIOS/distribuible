# S — Integración P01–P09

## Programas

- **`s_integracion_catalogo_P01_P09.jasb`**: un solo `principal` que encadena construcciones de los nueve primeros pasos P0. Última ejecución de referencia: **`checksum= 178122`** (tercera línea `estado=listo fin=178122`).
- **`s_repeticion_compile_run.ps1`**: repite **compilar + ejecutar** (`jbc -e`) sobre el integrador (ajustar `$N`).
- **`s_repeticion_todas_producciones_P01_P09.ps1`**: recorre los **`s_produccion_*.jasb`** de cada `P0_01`…`P0_09` (carga de producción por tema).

## Uso

```powershell
cd S
.\s_repeticion_compile_run.ps1
.\s_repeticion_todas_producciones_P01_P09.ps1
```

Si `P0_02` `s_produccion_tormenta_imprimir` (miles de líneas en consola) es demasiado pesado para CI, bajar `$N` en el script secundario o reducir el límite del bucle en ese `.jasb`.
