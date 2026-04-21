# P2_25_bits_unsigned — `bit_shl`, `bit_shr`, `<<` `>>`, comparaciones `u32`/`u64`

Ítem de catálogo: **P2 · 25** en [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

- **`bit_shl` / `bit_shr`**: builtins de dos argumentos → `OP_BIT_SHL` / `OP_BIT_SHR` (`vm.c`).
- **`<<` / `>>`**: mismos opcodes desde expresiones enteras.
- **Unsigned**: si algún operando es **`u32`** o **`u64`**, las comparaciones `> < <= >=` usan `OP_CMP_*_U`.

**Nota (VM):** el desplazamiento a la derecha actúa sobre el valor en registro como **entero de 64 bits sin signo** para el desplazamiento; con cantidades negativas en `entero` el patrón de bits no coincide con un `>>` aritmético de C sobre `int` de 32 bits. Los tests **R** se limitan a operandos no negativos.

| Carpeta | Contenido |
|---------|-----------|
| **R/** | Tablas de valores y `u32` vs firmado. Ver `R/NOTAS_R.md`. |
| **E/** | Aridad de `bit_shl` / `bit_shr`. Ver `E/NOTAS_E.md`. |
| **S/** | Muchos shifts en bucle. Ver `S/NOTAS_S.md`. |
