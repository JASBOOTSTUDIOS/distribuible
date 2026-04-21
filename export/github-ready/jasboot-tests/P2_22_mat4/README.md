# P2_22_mat4 — `mat4` y operaciones 3D

Ítem de catálogo: **P2 · 22** en [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

Incluye `mat4_identidad`, `mat4_mul_vec4(dest, mat, vec)`, `mat4_mul(dest, L, R)`, `mat4_transpuesta(dest, src)`, `mat4_inversa(dest, src)`. La matriz se almacena en **row-major**; en código se puede acceder por componentes `e0`…`e15` (misma orden que la VM).

| Carpeta | Contenido |
|---------|-----------|
| **R/** | Comportamiento correcto y salidas documentadas en `R/NOTAS_R.md`. |
| **E/** | Errores de compilación (aridad) y caso **inversa singular** (compila; fallo en ejecución). Ver `E/NOTAS_E.md`. |
| **S/** | Estrés: muchas `mat4_mul`; escena **MVP + rejilla de vértices** (`s_estres_p22_escena_mvp_vertices.jasb`). Ver `S/NOTAS_S.md`. |

---

## VM

- `OP_MAT4_INVERSA`: si la matriz es singular o no se reduce a identidad (tolerancia numérica), la VM escribe en stderr y termina con **código de salida 1** (no continúa el programa).
- Tras `build_vm.bat`, si aparece el aviso de que no se pudo copiar a `jasboot-ir-vm.exe`, el binario enlazado es **`jasboot-ir-vm-trace.exe`** (mismo código); cierra procesos que usen la VM y vuelve a compilar, o ejecuta el `.jbo` con ese exe para pruebas.
