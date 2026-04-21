# P1 · 17 — Entrada filtrada / teclado / `entrada_flotante`

Cubre el apartado **entrada filtrada** citado en el [checklist](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md) junto a **P1_17_caracter** (APIs de caracter).

## Contenido

| Ruta | Rol |
|------|-----|
| **R/** | Lectura interactiva: solo digitos, caracteres permitidos, `entrada_flotante()`. |
| **S/** | **Estres integrado** `s_estres_p17_entrada_filtrada_catalogo.jasb` + modulos `mod_p17_*.jasb` (`usar` / `activar_modulo` / `enviar`). Ver `S/NOTAS_S.md` para el checksum de referencia. |

**Ejecutar un R (interactivo):**

```powershell
.\bin\jb.cmd tests\P1_17_entrada_filtrada\R\r_entrada_solo_numeros.jasb
```

**Ejecutar el estres S (no interactivo, checksum fijo sin teclas):**

```powershell
.\bin\jb.cmd tests\P1_17_entrada_filtrada\S\s_estres_p17_entrada_filtrada_catalogo.jasb
```
