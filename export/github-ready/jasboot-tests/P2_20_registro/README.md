# P2 · 20 — `registro` … `fin_registro`, campos y acceso miembro

Cubre el checklist **P2 | 20**.

- **R/**: lectura/escritura de campos (`entero`, `flotante`, `texto`); variable local `Tipo nombre`; registro global; campo cuyo tipo es **otro registro** (anidación) y acceso `a.b.c`. (Tipo `funcion` / orden superior sin registros: [tests/P1_20_1/](../P1_20_1/).)
- **E/**: cierre sin `fin_registro`; campo con nombre reservado (`y`, `o`, …); miembro inexistente en asignación.
- **S/**: muchas iteraciones leyendo/escribiendo los mismos campos.

**Compilador:** los registros se registran en la tabla de símbolos (`sym_register_struct`); el tamaño de campo usa `get_field_size` en `symbol_table.c`. Las variables con tipo nombre de registro (`Punto origen`) se analizan en `parser.c` como `IDENT IDENT`. La asignación a `obj.campo` emite `OP_ESCRIBIR` en `codegen.c` (antes solo existía carga vía `OP_LEER` en expresiones).

**Campos:** evitar palabras reservadas como nombres de campo (p. ej. `y`, `o`, `valor`, `de`).

**Ejecutar un R (desde la raíz del repo):**

```powershell
.\bin\jb.cmd tests\P2_20_registro\R\r_cu_p20_registro_mixto.jasb
```

Los **E/** deben fallar al compilar (`bin\jbc.cmd …` con código distinto de 0).
