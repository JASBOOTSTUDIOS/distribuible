# P0 — Test 2: `imprimir` (literal y expresión)

Referencia: `docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md` (fila P0 #2).  
**E** y **R** marcados en el catálogo; **S** no — se deja un script opcional de repetición.

## Compilador

**`jbc`** (`sdk-dependiente/jas-compiler-c`, `bin\jbc.exe`).

## Contenido

| Ruta | Rol |
|------|-----|
| `E/` | Errores lex/sintaxis y caso límite «sin expresión». |
| `R/` | Programas válidos, carga con muchos `imprimir`, interpolación. |
| `S/` | Estrés: muchos ciclos `jbc -e` sobre un `.jasb` con `imprimir` (opcional). |
| `RESULTADOS_*.txt` | Capturas de compilación y ejecución. |
| `NOTAS_HALLAZGOS.md` | Hallazgos del parser/codegen. |
| `E/NOTAS_E.md`, `R/NOTAS_R.md`, `S/NOTAS_S.md` | Notas por eje. |
