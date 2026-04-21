# P0 — Test 1: `principal` … `fin_principal`

Referencia del catálogo: `docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md` (fila P0 #1).

## Compilador de referencia (estable)

Toda esta batería usa la CLI **`jbc`** (`sdk-dependiente/jas-compiler-c`). Invocación típica:

```text
bin\jbc.exe archivo.jasb -o salida.jbo
bin\jbc.exe archivo.jasb -e
```

Los resultados capturados aquí corresponden a ese binario.

## Contenido de la carpeta

| Ruta | Rol |
|------|-----|
| `E/` | Casos orientados a **errores** y límites del envoltorio (compilación / semántica aceptada). |
| `R/` | **Rendimiento** dentro de un bloque `principal` (bucle de trabajo). |
| `S/` | **Estrés**: repetición de compilación + ejecución vía `jbc`. |
| `RESULTADOS_COMPILACION_jbc.txt` | Salida y códigos de salida al compilar. |
| `RESULTADOS_EJECUCION_jbc.txt` | Salida relevante de `jbc -e` donde aplica. |
| `NOTAS_HALLAZGOS.md` | Resumen de comportamiento del parser y la VM con **jbc**. |
| `E/NOTAS_E.md`, `R/NOTAS_R.md`, `S/NOTAS_S.md` | Notas por eje E / R / S. |
