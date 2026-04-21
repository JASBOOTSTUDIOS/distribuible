# Documentación JB-C (Compilador en C)

Checklist de lo que debe implementar un compilador Jasboot en C para alcanzar paridad funcional con el compilador Python.

| Documento | Descripción |
|-----------|-------------|
| [CHECKLIST_COMPILADOR_C.md](CHECKLIST_COMPILADOR_C.md) | Lo que falta: Lexer, Parser, CodeGen, IR, CLI |

---

**Contexto:** El compilador **jbc** (`sdk-dependiente/jas-compiler-c`, `bin/jbc.exe`) es la implementación de referencia estable: genera `.jbo` ejecutables por `jasboot-ir-vm`. La JMN enlazada por la VM vive en **`sdk-dependiente/jasboot-jmn-core/`**. El checklist histórico de “paridad con Python” quedó obsoleto al retirar el árbol del compilador Python.
