# Cascada funcional P0_01..P1_14

El script `ejecutar_cascada_funcional.ps1` recorre en orden lexicográfico todos los programas **nominales** relevantes entre los paquetes `P0_01`..`P0_10` y `P1_11`..`P1_14`, más la carpeta `tests/P0_estres_produccion_P01_P09_integracion` (catálogo P01–P09).

## Qué se ejecuta

- Cada `R/*.jasb` y `N/*.jasb` (si existe `N/`) del paquete.
- En `S/`, solo `.jasb` que encajan en patrones de producción/estrés/integración (por nombre), más `main.jasb` y `s_gusanito_demo.jasb`. Se excluyen fragmentos `s_mod_*` (solo importados por otros programas).
- Subcarpetas `S/s_estres_*`: el `.jasb` homónimo a la carpeta y, si hay más `.jasb` en ese nivel (p. ej. `s_estres_deep_n20_main.jasb`), también; no se ejecutan nombres que empiezan por `_`.
- `S/casos_usar_enviar/cu_*.jasb` (P1_14).

Quedan **fuera** de forma intencionada: carpetas `E/` (errores), y los dos `.jasb` en `P0_04`.../S que prueban variables no declaradas (no son producción).

## Omisiones por defecto

- **Interactivos** (requieren teclado): `s_gusanito_interactivo_colision.jasb`, `s_prueba_ingreso_inmediato_limpiar.jasb`. Para incluirlos: `-IncludeInteractive`.

## Opciones

- `-SkipLimite200`: no ejecuta `s_estres_p0_p14_limite200.jasb` (muy costoso). Referencia de salida en `tests/P1_14_usar_modulos/S/s_estres_p0_p14_limite200/NOTAS_LIMITE200.md`.

## Alcance

- **P1_19** y otros paquetes fuera del rango P0_01–P1_14 no entran en esta cascada.

## Requisitos

- `bin\jbc.exe` (`sdk-dependiente\jas-compiler-c\build.bat`).
- VM: `sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe` (`build_vm.bat` en `jasboot-ir`).
- Opcional: variable `JASBOOT_JBC` si `jbc` no está en `bin\`.

## Ejecución

```powershell
.\tests\P0_P14_cascada_funcional\ejecutar_cascada_funcional.ps1 -SkipLimite200
```

O: `ejecutar_cascada_funcional.cmd -SkipLimite200`

**Nota de implementación:** dentro de una función de PowerShell, `return` dentro de `ForEach-Object` puede salir de **toda** la función; el script usa bucles `foreach` + `continue` para evitar cortar la lista de tests.
