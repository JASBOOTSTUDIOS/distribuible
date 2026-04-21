# P3_30 — Cadenas: `concatenar`, `longitud` / `longitud_texto`, `dividir` / `dividir_texto`, `minusculas` / `str_minusculas`, `copiar_texto` / `str_copiar`

Ítem de catálogo **P3 · 30** en [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

Cubre llamadas de sistema de **manipulación de texto** usadas por programas reales (p. ej. `dividir_texto` en aplicaciones con CSV-like). Compilador: `codegen.c` (`visit_call_sistema`); VM: `OP_STR_CONCATENAR_REG`, `OP_STR_LONGITUD`, `OP_STR_DIVIDIR_TEXTO`, `OP_STR_MINUSCULAS`, `OP_MEM_COPIAR_TEXTO`, etc.

- **E/** Aridad incorrecta: demasiados pocos o demasiados argumentos en APIs de texto (`concatenar`, `longitud`/`longitud_texto`, `dividir`/`dividir_texto` exactamente dos, `minusculas`/`str_minusculas`, `copiar_texto`/`str_copiar`). Ver `E/NOTAS_E.md`.
- **R/** Caminos felices: `concatenar`, alias `longitud`/`longitud_texto`, `dividir`/`dividir_texto` → `lista`, `minusculas`/`str_minusculas`. Ver `R/NOTAS_R.md`.
- **S/** Cadena larga por concatenación repetida y `dividir_texto` con miles de tokens. Ver `S/NOTAS_S.md`.

**Nota sobre `copiar_texto` / `str_copiar`:** la emisión actual usa `OP_MEM_COPIAR_TEXTO` acoplada al layout de datos / JMN; en esta batería solo se exige **fallo de compilación** sin argumentos. Un caso R semántico de copia fiel queda pendiente de alinear VM + codegen con el uso `texto x = copiar_texto("literal")`.
