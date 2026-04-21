# P0 — Test 9: `texto`, literal `"…"`, interpolación `${}` en literales

Referencia: `docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md` (fila P0 #9).

## Compilador

`bin\jbc.exe` (proyecto `sdk-dependiente/jas-compiler-c`).

## Contenido

| Ruta | Rol |
|------|-----|
| `E/` | Formato y vacío: `${}` sin expresión, `}` faltante, expresión inválida dentro de `${}`, literal `texto` no cerrado. |
| `R/` | Programas válidos: tipo `texto`, literales, interpolación en `imprimir`. |
| `S/` | Estrés: muchos ciclos `jbc -e` con interpolación repetida. |
| `E/NOTAS_E.md`, `R/NOTAS_R.md`, `S/NOTAS_S.md` | Resultados esperados y hallazgos. |
