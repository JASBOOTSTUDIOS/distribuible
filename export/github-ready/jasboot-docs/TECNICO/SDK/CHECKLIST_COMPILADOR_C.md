# Checklist: Compilador Jasboot en C

El compilador en C (`jbc`, `sdk-dependiente/jas-compiler-c`) es la **implementación de referencia** del lenguaje Jasboot. Genera binarios `.jbo` (IR) ejecutables por `jasboot-ir-vm`.

---

## Visión

| Componente | Compilador Python | Compilador C (objetivo) |
|------------|-------------------|--------------------------|
| **Lexer** | lexer.py | ❌ A implementar |
| **Parser** | parser.py | ❌ A implementar |
| **CodeGen** | codegen.py | ❌ A implementar |
| **IR / .jbo** | Formato binario JASB | ❌ A implementar |
| **CLI** | jbc (compile, test, -e) | ✅ |

---

## Leyenda de estados

| Símbolo | Significado |
|---------|-------------|
| ✅ | Hecho / estable |
| 🔄 | En curso |
| ⚠️ | Parcial |
| ❌ | Pendiente |

---

## Nivel 1: Lexer

*Tokenización del fuente.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 1.1 | Tipos de token | KEYWORD, IDENTIFIER, STRING, NUMBER, OPERATOR, EOF, NEWLINE | ✅ |
| 1.2 | Palabras reservadas | principal, fin_principal, funcion, fin_funcion, mientras, fin_mientras, cuando, fin_cuando, si, sino, fin_si | ✅ |
| 1.3 | Keywords IA/cognitivas | recordar, buscar, pensar, aprender, asociar, crear_memoria, cerrar_memoria | ✅ |
| 1.4 | Keywords sistema | activar_modulo, usar, imprimir, ingresar_texto, retornar, romper, continuar | ✅ |
| 1.5 | Tipos | entero, texto, flotante, caracter, lista, mapa, registro, bool | ✅ |
| 1.11 | Constante | constante (keyword para declaraciones inmutables) | ✅ |
| 1.6 | Operadores | =, +, -, *, /, %, ==, !=, <, >, <=, >=, +=, -=, ., [, ], {, }, :, ? | ✅ |
| 1.7 | Strings | Literales "..." con escape \n, \t, \", \\ | ✅ |
| 1.8 | Línea y columna | Metadatos en cada token para mensajes de error | ✅ |
| 1.9 | Rechazo de inglés | FORBIDDEN_ENGLISH (if, else, for, etc.) | ✅ |
| 1.10 | Todas las keywords | Ver lexer.py KEYWORDS (~90 entradas) | ✅ |

---

## Nivel 2: Parser

*Construcción del AST.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 2.1 | Nodos base | ProgramNode, BlockNode, FunctionNode | ✅ |
| 2.2 | Declaraciones | VarDeclNode (con is_const), StructDefNode | ✅ |
| 2.3 | Expresiones | LiteralNode, IdentifierNode, BinaryOpNode, UnaryOpNode | ✅ |
| 2.4 | Llamadas | CallNode con lista de argumentos | ✅ |
| 2.5 | Control de flujo | WhileNode, IfNode, ReturnNode, BreakNode, ContinueNode | ✅ |
| 2.6 | I/O | PrintNode, InputNode | ✅ |
| 2.7 | Memoria neuronal | RecordarNode, BuscarPesoNode, AprenderNode, AsociarNode | ✅ |
| 2.8 | Módulos | ActivarModuloNode, usar (incluir otro .jasb) | ✅ |
| 2.9 | Memoria | CrearMemoriaNode, CerrarMemoriaNode | ✅ |
| 2.10 | Texto/NLP | ExtraerTextoNode, ContieneTextoNode, TerminaConNode, UltimaPalabraNode, CopiarTextoNode | ✅ |
| 2.11 | Colecciones | ListLiteralNode, MapLiteralNode, IndexAccessNode, IndexAssignmentNode | ✅ |
| 2.12 | Miembros | MemberAccessNode (struct.field) | ✅ |
| 2.13 | Ternario | TernaryNode (cond ? a : b) | ✅ |
| 2.14 | Biblioteca | BibliotecaNode (cargar DLL/SO) | ✅ |
| 2.15 | Conceptos | DefineConceptoNode | ✅ |
| 2.16 | SISTEMA_LLAMADAS | Reconocer ~40 llamadas de sistema como válidas | ✅ |
| 2.17 | Mensajes de error | Línea, columna, mensaje claro | ✅ |

---

## Nivel 3: Tabla de símbolos

*Gestión de scopes y variables.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 3.1 | Scopes anidados | enter_scope, exit_scope | ✅ |
| 3.2 | Variables globales | next_global_offset desde 0x0800 | ✅ |
| 3.3 | Variables locales | next_local_offset por función | ✅ |
| 3.4 | Parámetros | Marcar parámetros en scope | ✅ |
| 3.5 | lookup / declare | Búsqueda por nombre, declaración con tipo, is_const para constantes | ✅ |
| 3.6 | get_or_create | Obtener o declarar si no existe | ✅ |
| 3.7 | Estructuras | Registrar structs con campos y offsets | ✅ |
| 3.8 | Tipo por variable | type_scopes para inferencia/validación | ✅ |

---

## Nivel 4: CodeGen — Estructuras de control

*Emisión de IR para control de flujo.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 4.1 | PrintNode | OP_IMPRIMIR_TEXTO, OP_IMPRIMIR_NUMERO, OP_IMPRIMIR_FLOTANTE, OP_MEM_IMPRIMIR_ID | ✅ |
| 4.2 | Interpolación | imprimir "x=" + x (emit_print_interpolated) | ⚠️ |
| 4.3 | VarDeclNode | OP_RESERVAR_PILA, OP_ESCRIBIR; constante (is_const) rechaza asignación | ✅ |
| 4.4 | AssignmentNode | OP_ESCRIBIR, incl. index (lista/mapa) y += (append) | ✅ |
| 4.5 | WhileNode | OP_CMP_EQ, OP_SI, OP_IR, labels, loop_stack | ✅ |
| 4.6 | IfNode | OP_SI, OP_IR, else_label, end_label | ✅ |
| 4.7 | BreakNode / ContinueNode | Saltos a labels del loop_stack | ✅ |
| 4.8 | ReturnNode | OP_RETORNAR | ✅ |
| 4.9 | FunctionNode | OP_LLAMAR, convención de llamada, slots de parámetros | ⚠️ |

---

## Nivel 5: CodeGen — Expresiones

*Emisión de IR para expresiones.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 5.1 | Literales | Números, strings (add_string, OP_LOAD_STR_HASH) | ✅ |
| 5.2 | Identificadores | lookup, OP_LEER | ✅ |
| 5.3 | Aritmética | OP_SUMAR, OP_RESTAR, OP_MULTIPLICAR, OP_DIVIDIR, OP_MODULO | ✅ |
| 5.4 | Flotantes | OP_SUMAR_FLT, OP_RESTAR_FLT, etc., OP_CONV_I2F, OP_CONV_F2I | ✅ |
| 5.5 | Comparaciones | OP_CMP_EQ, OP_CMP_LT, OP_CMP_GT, OP_CMP_LE, OP_CMP_GE | ✅ |
| 5.6 | Lógica | OP_Y, OP_O, OP_NO, OP_XOR | ✅ |
| 5.7 | Bitwise | OP_BIT_SHL, OP_BIT_SHR | ✅ |
| 5.8 | Llamadas | visit_call con dest_reg | ✅ |
| 5.9 | IndexAccessNode | OP_MEM_LISTA_OBTENER, OP_MEM_MAPA_OBTENER | ✅ |
| 5.10 | MemberAccessNode | get_member_address, offsets de struct | ✅ |
| 5.11 | TernaryNode | Condicional en expresión | ✅ |
| 5.12 | ListLiteralNode / MapLiteralNode | OP_MEM_LISTA_CREAR, OP_MEM_LISTA_AGREGAR, etc. | ✅ |

---

## Nivel 6: CodeGen — Llamadas de sistema

*~52 funciones reconocidas en visit_call. Lista representativa:*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 6.1 | Texto | concatenar, longitud, dividir, buscar_en_texto, contiene_texto, termina_con | ✅ |
| 6.2 | Texto | extraer_subtexto, extraer_antes_de, extraer_despues_de, copiar_texto | ✅ |
| 6.3 | IA | aprender, pensar, buscar | ✅ |
| 6.4 | I/O | leer_entrada | ✅ |
| 6.5 | Tiempo | ahora, obtener_ahora, diferencia_en_segundos | ✅ |
| 6.6 | Archivos | abrir_archivo, cerrar_archivo, leer_linea_archivo, escribir_archivo, fin_archivo, existe_archivo, listar_archivos | ✅ |
| 6.7 | Listas | crear_lista, lista_agregar, lista_obtener, lista_tamano, etc. | ✅ |
| 6.8 | Mapas | mapa_crear, mapa_poner, mapa_obtener | ✅ |
| 6.9 | Memoria neuronal | mem_crear, mem_cerrar, mem_asociar, mem_lista_*, procesar_texto, etc. | ✅ |
| 6.10 | Sistema | sistema_ejecutar, sys_argc, sys_argv | ✅ |
| 6.11 | Conversiones | str_a_entero, str_a_flotante, str_desde_numero, codigo_caracter, caracter_a_texto | ✅ |
| 6.12 | Resto | Ver SISTEMA_LLAMADAS y visit_call en codegen.py | ✅ |

---

## Nivel 7: CodeGen — Sentencias cognitivas

*Nodos especiales de memoria neuronal.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 7.1 | RecordarNode | OP_MEM_ASOCIAR_CONCEPTOS, OP_MEM_APRENDER_CONCEPTO | ✅ |
| 7.2 | AsociarNode | OP_MEM_ASOCIAR_CONCEPTOS | ✅ |
| 7.3 | AprenderNode | OP_MEM_APRENDER_CONCEPTO | ✅ |
| 7.4 | CrearMemoriaNode | OP_MEM_CREAR | ✅ |
| 7.5 | CerrarMemoriaNode | OP_MEM_CERRAR | ✅ |
| 7.6 | ActivarModuloNode | OP_ACTIVAR_MODULO | ✅ |
| 7.7 | ExtraerTextoNode | OP_STR_EXTRAER_ANTES_REG, OP_STR_EXTRAER_DESPUES_REG | ✅ |
| 7.8 | ContieneTextoNode, TerminaConNode, UltimaPalabraNode | Opcodes correspondientes | ✅ |
| 7.9 | CopiarTextoNode | OP_MEM_COPIAR_TEXTO | ✅ |
| 7.10 | DefineConceptoNode | OP_MEM_RECORDAR_TEXTO | ✅ |
| 7.11 | ResponderNode | OP_MEM_IMPRIMIR_ID | ✅ |
| 7.12 | InputNode | OP_IO_INPUT_REG, OP_ESCRIBIR | ✅ |

---

## Nivel 8: Formato IR y salida

*Generar binario .jbo.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 8.1 | Cabecera IR | Magic "JASB", versión, endianness, code_size, data_size | ✅ |
| 8.2 | Instrucciones 5B | opcode, flags, operand_a, operand_b, operand_c | ✅ |
| 8.3 | Sección data | Strings, constantes | ✅ |
| 8.4 | Labels y patches | Forward references, add_patch, mark_label | ✅ |
| 8.5 | Flags de instrucción | IR_INST_FLAG_* (A_IMMEDIATE, A_REGISTER, etc.) | ✅ |
| 8.6 | Sincronía con ir_format.h | Opcodes y formato idénticos a VM | ✅ |

---

## Nivel 9: CLI y herramientas

*Interfaz de línea de comandos.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 9.1 | Compilar | jbc archivo.jasb -o archivo.jbo | ✅ |
| 9.2 | Ejecutar | -e / --ejecutar (compilar + invocar VM) | ✅ |
| 9.3 | Verbose | -v / --verbose para depuración | ✅ |
| 9.4 | Ruta cerebro | -b / --ruta-cerebro (JASBOOT_RUTA_CEREBRO) | ✅ |
| 9.5 | Test runner | Subcomando test, suite de pruebas | ✅ |
| 9.6 | Compatibilidad | Sin subcomando: archivo.jasb como primer arg | ✅ |

---

## Nivel 10: Herramientas auxiliares (opcional)

*No indispensables para paridad, pero útiles.*

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| 10.1 | Linter | Análisis estático: palabras en inglés prohibidas + verificación de compilación | ⚠️ |
| 10.2 | Formatter | Formateo de código (indentación por bloques, comentarios preservados) | ⚠️ |
| 10.3 | Disassembler | Disasm de .jbo a texto legible (opcodes, operandos) | ❌ |
| 10.4 | REPL | Consola interactiva: compilar + ejecutar cada línea/snippet | ❌ |

**Detalle por tarea:**

- **10.1 Linter** — `tools_linter.c` implementa `do_lint()`: detecta inglés prohibido y compila para validar sintaxis. Falta integración en `main.c` como subcomando `jbc lint archivo.jasb`.
- **10.2 Formatter** — `tools_formatter.c` implementa `do_format()` y `format_source()`: indentación, manejo de comentarios. Falta integración en `main.c` como subcomando `jbc format [--write] archivo.jasb`.
- **10.3 Disassembler** — No existe. Pendiente implementar en C (lee cabecera IR, desensambla instrucciones 5B).
- **10.4 REPL** — No existe. Pendiente implementar en C (tempfile → compilar → VM).

---

## Prioridades sugeridas

1. **1.1–1.10** — Lexer completo.
2. **2.1–2.10** — Parser para programa mínimo (principal, imprimir, variables).
3. **3.1–3.8** — Tabla de símbolos.
4. **4.1–4.9** — CodeGen básico (print, vars, while, if, funciones).
5. **5.1–5.8** — Expresiones (aritmética, comparaciones, llamadas).
6. **8.1–8.6** — Formato IR y emisión.
7. **6.1–6.12** — Llamadas de sistema (por bloques).
8. **7.1–7.12** — Sentencias cognitivas.
9. **9.1–9.6** — CLI.
10. **10.1–10.4** *(opcional)* — Linter/Formatter (integrar en main.c), Disassembler, REPL.

---

## Referencias

- `sdk-dependiente/jas-compiler-c/src/lexer.c` — Lexer.
- `sdk-dependiente/jas-compiler-c/src/parser.c` — Parser.
- `sdk-dependiente/jas-compiler-c/src/codegen.c` — CodeGen.
- `sdk-dependiente/jas-compiler-c/include/nodes.h` — Nodos AST.
- `sdk-dependiente/jasboot-ir/src/ir_format.h` — Formato binario IR.
- **Nivel 10:** `jas-compiler-c/src/tools_linter.c`, `tools_formatter.c`.

---

**Última actualización:** 2026-02-18
