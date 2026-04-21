# P0 — Test 3: `entero`, declaración y asignación `=`

Referencia: `docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md` (fila P0 #3).  
Catálogo marca **E**, **R** y **S**.

## Compilador

**`jbc`** (`sdk-dependiente/jas-compiler-c`, `bin\jbc.exe`).

## Contenido

| Ruta | Rol |
|------|-----|
| `E/` | Errores esperados, límites y casos que *deberían* fallar pero hoy no lo hacen (ver `E/NOTAS_E.md`). |
| `R/` | Programas válidos: inicialización, asignación posterior, expresión compuesta, bucle con muchas reasignaciones. |
| `S/` | Estrés: repetir `jbc -e` sobre `R/r_ok_basico.jasb`. |
| `RESULTADOS_*.txt` | Capturas de compilación y ejecución. |
| `NOTAS_HALLAZGOS.md` | Resumen técnico frente a **jbc**. |
| `E/NOTAS_E.md`, `R/NOTAS_R.md`, `S/NOTAS_S.md` | Notas por eje. |
