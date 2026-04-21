# P2_23_mat3 — `mat3_mul_vec3`, `mat3_mul`

Ítem de catálogo: **P2 · 23** en [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

Incluye `mat3_mul_vec3(dest, mat, vec)` y `mat3_mul(dest, L, R)`. La matriz está en **row-major**; acceso por componentes `e0`…`e8` (misma convención que la VM: `OP_MAT3_MUL` / `OP_MAT3_MUL_VEC3`).

| Carpeta | Contenido |
|---------|-----------|
| **R/** | Salidas comprobables. Ver `R/NOTAS_R.md`. |
| **E/** | Aridad incorrecta y argumentos que no son identificadores. Ver `E/NOTAS_E.md`. |
| **S/** | Muchas `mat3_mul` con identidad. Ver `S/NOTAS_S.md`. |

---

## VM

Tras `build_vm.bat`, si no se puede sobrescribir `jasboot-ir-vm.exe`, usar `jasboot-ir-vm-trace.exe` como en P2_22.
