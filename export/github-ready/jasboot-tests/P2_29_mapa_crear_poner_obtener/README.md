# P2_29 — `mapa_crear`, `mapa_poner`, `mapa_obtener`

Ítem de catálogo **P2 · 29** en [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

Los mapas son **handles** (id numérico) en `mem_colecciones` / JMN; clave y valor se modelan como **enteros** (`u32` en runtime). Si se lee una clave que **no** fue definida con `mapa_poner`, la VM emite un error de ejecución **capturable** con `intentar` / `atrapar` (mensaje en `texto`, p. ej. contiene `clave de mapa inexistente`); fuera de `intentar`, la VM termina con código distinto de cero.

- **E/** Aridad incorrecta en `mapa_poner` / `mapa_obtener`; y ejecución con clave inexistente sin `intentar`. Ver `E/NOTAS_E.md`.
- **R/** Flujo básico, indexación `mapa[clave]`, `imprimir` de mapa (resumen `id`/`tamano`), mapa de **funciones** (valores = direcciones), clave ausente. Ver `R/NOTAS_R.md`.
- **S/** Miles de `mapa_poner` + bucle de `mapa_obtener` con suma verificable. Ver `S/NOTAS_S.md`.

IR: `OP_MEM_MAPA_CREAR`, `OP_MEM_MAPA_PONER`, `OP_MEM_MAPA_OBTENER`, `OP_MEM_MAPA_TAMANO` (`codegen.c`, `vm.c`, `memoria_neuronal_utilidades.c`).
