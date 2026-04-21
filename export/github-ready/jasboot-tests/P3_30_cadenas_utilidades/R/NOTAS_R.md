# P3_30 — Notas R (regresión)

Ejecutar con `bin\jb.cmd` o `bin\jbc.cmd … -e` desde la raíz del monorepo.

| Archivo | Salida esperada (resumen) |
|---------|---------------------------|
| `r_p30_smoke.jasb` | `HolaMundo`, `3`, `3`, `hola`, `abc` (minúsculas de `AbC`), `3` (partes de `uno,dos,tres`), resumen de lista, luego `tres`/`dos`/`uno` (bucle índice descendente). Usar `lista<texto>` y tipado de `mem_lista_obtener` para que `imprimir` use texto, no número. |
| `r_p30_dividir_alias.jasb` | `2` — `dividir("x\|y", "\|")` misma semántica que `dividir_texto`. |

**Tip:** Para funciones que devuelven **texto** (p. ej. `minusculas`), asignar a una variable `texto` antes de `imprimir`; un `imprimir minusculas("…")` directo puede interpretarse como número en algunos builds.
