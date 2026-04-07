# Catálogo de instrucciones Jasboot: orden, tests y alcance de errores

Documento de referencia para **pruebas de estrés**, **rendimiento** y **catálogo de errores** del lenguaje. Lista las construcciones en **orden creciente de complejidad** (prioridad para diseñar tests) y marca el **alcance** sugerido de cada batería.

**Referencia técnica:** compilador principal `sdk-dependiente/jas-compiler-c` (`codegen.c`, `sistema_llamadas.c`, `keywords.c`, `parser.c` — `parse_lambda`, `NODE_LAMBDA_DECL`, `parse_struct_body`, `StructDefNode.extends_name`; `symbol_table.c` — `sym_register_struct_extends`; `resolve.c`, `main.c`); VM `sdk-dependiente/jasboot-ir` (`ir_format.h`, `vm.c`).

**Leyenda de columnas de test**

| Código | Objetivo |
|--------|----------|
| **E** | Errores y límites: entradas inválidas, división por cero, desbordamiento, archivos ausentes, índices fuera de rango, memoria nula, `ffi` inválido, etc. |
| **R** | Rendimiento: bucles grandes, muchas cadenas/listas, grafos JMN densos, I/O por lotes, medir tiempo por instrucción o por programa. |
| **S** | Estrés: concurrencia host si aplica, repetición prolongada, presión de pila (`LLAMAR`), presión de heap, cierre/recreate de `crear_memoria`. |

---

## Estado de trabajo — P3·31 (`extraer_subtexto`, `extraer_antes_de`, `extraer_despues_de`)

- **Rama Git:** `feature/p3-31-cadenas-subtexto-vm` (trabajo de batería + VM/compilador asociado a esta unidad).
- **Batería:** [tests/P3_31_extraer_subtexto_y_alrededor/](../../tests/P3_31_extraer_subtexto_y_alrededor/) (**E**/**R**/**S**); NOTAS manuales donde el generador no cubra el caso.
- **VM (`sdk-dependiente/jasboot-ir`):** caché de texto con longitud (`text_len`); `OP_STR_SUBTEXTO` y operaciones relacionadas evitan trabajo redundante sobre el buffer 4K; `imprimir` de registro texto largo vía `fwrite` y `fflush` acotado para no penalizar cuerdas muy grandes.
- **Compilador (`sdk-dependiente/jas-compiler-c`):** `jbc` admite `--ir-opt` (optimizador IR); **por defecto desactivado** hasta validar equivalencia del `.jbo` en toda la batería.
- **Estrés:** `tests/P3_31_extraer_subtexto_y_alrededor/S/s_estres_p31_extraer_bucle.jasb` — bucle de `concatenar` + muchas extracciones; salida mínima (p. ej. longitud final), sin volcar la cadena completa en consola. Panorama P0–P3_31: `tests/estres/S_estres_panorama_P0_P31/`.

---

## Estado de trabajo — P3·32 (`buscar_en_texto`, `contiene_texto`, `termina_con`)

- **Batería:** [tests/P3_32_buscar_contiene_termina/](../../tests/P3_32_buscar_contiene_termina/) (**E**/**R**/**S**). `buscar_en_texto` y `contiene_texto` comparten emisión (`OP_MEM_CONTIENE_TEXTO_REG`); aridad **exactamente 2** validada en `jbc`.
- **VM:** `OP_MEM_TERMINA_CON_REG` usa la **caché de texto** de la VM cuando ambos operandos están en caché (paridad con `contiene_texto` sin depender solo de JMN); si no, sigue `jmn_termina_con` cuando hay memoria neuronal.

---

## Estado de trabajo — P3·44 (`pensar`, `procesar_texto`)

- **Batería:** [tests/P3_44_pensar_procesar_texto/](../../tests/P3_44_pensar_procesar_texto/) (**E**/**R**/**S**). Aridad **exactamente 1** para ambas APIs; mensajes vía `codegen_error_if_bad_arity_pensar_procesar_texto` en `jas-compiler-c/src/codegen.c` (también en el fallback de `NODE_CALL`).
- **Compilador:** `pensar` emite `OP_MEM_PENSAR` (profundidad por defecto 2 en el byte C) y después `OP_ESCRIBIR` hacia la variable sistema `resultado`. `procesar_texto` emite `OP_MEM_PROCESAR_TEXTO` (`0xDE`, paridad con `ir_format.h`).
- **VM (`jasboot-ir`):** `OP_MEM_PENSAR` llama a `jmn_razonamiento_multipath` cuando hay integración JMN (el stub devuelve el mismo id) y refresca la caché de texto si aplica. `OP_MEM_PROCESAR_TEXTO` invoca `jmn_procesar_texto` sin alterar el id en el registro de resultado de la expresión.

---

## Estado de trabajo — P4·54 (archivos / `fs_*`)

- **Batería:** [tests/P4_54_archivos_sistema/](../../tests/P4_54_archivos_sistema/) (**E**/**R**/**S**). Cubre `abrir_archivo`/`fs_abrir`, `cerrar_archivo`/`fs_cerrar`, `leer_linea_archivo`/`fs_leer_linea`, `escribir_archivo`/`fs_escribir`, `fin_archivo`, `existe_archivo`, `listar_archivos`/`fs_listar`, `fs_leer_byte`, `fs_escribir_byte`, `fs_leer_texto`.
- **VM (`jasboot-ir`):** implementado `OP_FS_LISTAR` (patrón glob; `FindFirstFile` en Windows, `glob(3)` en Unix); nombres ordenados y tope de tamaño de salida. `existe_archivo` (`OP_FS_EXISTE`) resuelve ruta vía `vm_resolve_path` y caché de texto.
- **E** portables: aridad / firma en compilación; permisos y disco lleno: ver `E/NOTAS_E.md`.

---

## Estado de trabajo — P2·20 Clase, `extiende` y polimorfismo manual

Extiende el modelo de **P2·20** (`registro`): tipos con **`clase` … `fin_clase`**, herencia de layout con **`extiende NombreBase`**, y campos **`funcion nombreCampo`** (puntero a función en el registro de la VM; patrón estilo vtable). **No** hay dispatch automático `obj.metodo()` ni nuevos opcodes de “método virtual”; el polimorfismo es **manual** (asignar al campo `funcion` e invocar con la semántica de **P1·20.1** / `expr(args)`).

- **Batería recomendada (monorepo):** [tests/P2_20_clase_extiende_polimorfismo/](../../tests/P2_20_clase_extiende_polimorfismo/) (**E**/**R**/**S**). Convive con [tests/P2_20_registro/](../../tests/P2_20_registro/): mismas reglas de acceso a miembros y asignación; añadir casos de herencia y punteros a función almacenados en instancia.
- **Smoke actual en el compilador C:** [sdk-dependiente/jas-compiler-c/tests/test_clase_extiende.jasb](../../sdk-dependiente/jas-compiler-c/tests/test_clase_extiende.jasb) — clase base, clase derivada con `extiende` y campo `funcion`; compilar con `jbc` y, si aplica, ejecutar con `-e`.
- **Compilador (`jas-compiler-c`):** palabras `clase`, `fin_clase`, `extiende` en `keywords.c`; cuerpo unificado en `parse_struct_body` (parser); `NODE_STRUCT_DEF` con `extends_name`; registro de layout en `sym_register_struct_extends` (campos de la base primero, luego los propios; error si el nombre de campo colisiona con la base o si la base no existe). `resolve_program` y `codegen_generate` registran structs en el mismo orden; si `resolve_program` devuelve errores > 0, `main.c` aborta la compilación antes de codegen.
- **VM:** sin cambios obligatorios para esta unidad; el comportamiento reutiliza structs y **P1·20.1** para llamadas indirectas.

| Alcance | Qué cubrir |
|--------|------------|
| **E** | Base ausente o definida después del derivado; campo derivado con el mismo nombre que uno de la base; `fin_registro` cerrando `clase` o `fin_clase` cerrando `registro`; `funcion nombre(` tratado como función anidada (debe rechazarse; usar `funcion idCampo` sin paréntesis en la lista de campos); tipos inexistentes en campos; mezcla `registro`/`clase` con imports (`usar`) si aplica. |
| **R** | Cadenas de herencia (varios niveles); muchas clases con el mismo patrón de campos; instancias y lectura/escritura repetida de miembros heredados y propios. |
| **S** | Muchas instancias o asignaciones a campos `funcion` en bucle; llamadas indirectas masivas a través del campo (presión de pila alineada con **P1·13**). |

**Regresiones conscientes:** mensajes de error en español al fallar el registro por herencia; coherencia de offsets de campos entre `registro` y `clase` sin `extiende` (paridad con P2·20).

---

## Parte A — Orden maestro (simplicidad → complejidad, prioridad para tests)

Cada fila es una **unidad mínima** a cubrir antes de asumir que las superiores funcionan. El orden es **pedagógico y de prioridad de test** (P0 más urgente).

| Pri | # | Instrucción o construcción | E | R | S | Notas |
|-----|---|----------------------------|---|---|---|--------|
| P0 | 1 | `principal` … `fin_principal` | ✓ | ✓ | ✓ | Envoltorio del programa |
| P0 | 2 | `imprimir` (literal y expresión) | ✓ | ✓ | | |
| P0 | 3 | `entero`, declaración y asignación `=` | ✓ | ✓ | ✓ | `tests/P0_03_entero_declaracion_asignacion/` |
| P0 | 4 | Aritmética `+` `-` `*` `/` `%` enteros | ✓ | ✓ | ✓ | [tests/P0_04_aritmetica_enteros/](./tests/P0_04_aritmetica_enteros/) Incluye **E**: `/` y `%` por cero |
| P0 | 5 | Comparaciones `==` `!=` `<` `>` `<=` `>=` | ✓ | ✓ | [P0_05](tests/P0_05_comparaciones/) | |
| P0 | 6 | `si` / `sino` / `fin_si` o `cuando` … `fin_cuando` | ✓ | ✓ | ✓ | Ramas y cortocircuito `y`/`o` |
| P0 | 7 | `mientras` … `fin_mientras` | ✓ | ✓ | ✓ | [tests/P0_07_mientras/](./tests/P0_07_mientras/) **R**: muchas iteraciones |
| P0 | 8 | `romper`, `continuar` | ✓ | ✓ | ✓ | [tests/P0_08_romper_continuar/](./tests/P0_08_romper_continuar/) Bucles anidados, `hacer`…`mientras`; error si fuera de bucle |
| P0 | 9 | `texto`, literal `"…"`, interpolación `${}` en literales | ✓ | ✓ | ✓ | [tests/P0_09_texto_literal_interpolacion/](./tests/P0_09_texto_literal_interpolacion/) **E**: formato / vacío; ver NOTAS_E (hallazgos `${}` vacío / expr inválida) |
| P0 | 10 | Concatenación textual `+` | ✓ | ✓ | ✓ | **R**: cadenas muy largas |
| P1 | 11 | `funcion` … `fin_funcion`, `retorna`, `retornar` | ✓ | ✓ | ✓ | [tests/P1_11_funcion_retorna_retornar/](../../tests/P1_11_funcion_retorna_retornar/) **S**: recursion / profundidad |
| P1 | 12 | **Funciones flecha** `(params) => expr`, cuerpo `=> { … }`, tipado `(entero x, texto t) => …`, invocación inmediata `((…) => …)(args)`; alias con `macro nombre = … => …` | ✓ | ✓ | ✓ | [tests/P1_12_funciones_flecha/](../../tests/P1_12_funciones_flecha/) (**E**, **R**, **S**). **Guía:** [GUIA_P1_12_FLECHAS_Y_MACRO.md](./GUIA_P1_12_FLECHAS_Y_MACRO.md). Contrato y regresiones: § *P1_12 — Contrato pedagógico y regresiones* abajo. AST `NODE_LAMBDA_DECL`, `parse_lambda` en `parser.c` |
| P1 | 13 | `llamar` función (OP `LLAMAR`, frame `RESERVAR_PILA`) | ✓ | ✓ | ✓ | [tests/P1_13_llamar_funcion/](../../tests/P1_13_llamar_funcion/) — palabra clave opcional con misma emisión que `f(args)`; **S**: `s_estres_llamar_miles.jasb` (5000×). Ver `README.md` de la carpeta. |
| P1 | 14 | `usar todas`/`todo de` / `usar {…} de` (sin `usar "ruta"` solo), `enviar` (export) | ✓ | ✓ | | [tests/P1_14_usar_modulos/](../../tests/P1_14_usar_modulos/) **E**: ruta inexistente, ciclos, import nominal sin `enviar`, sintaxis obsoleta; **R**: ver `R/NOTAS_R.md`. `jas-compiler-c`: `parser.c`, `main.c` (`register_usar_modules`). |
| P1 | 15 | `flotante`, literales y ops `+ - * /`, comparaciones flotantes | ✓ | ✓ | | [tests/P1_15_flotante/](../../tests/P1_15_flotante/) VM: división flotante por **0.0** → **0** (no NaN). Comparaciones `==`/`!=` con `OP_CMP_EQ_FLT` (semántica C). Opcodes `0x3C`–`0x3E`: `<=` `>=` `==` flotante. |
| P1 | 16 | Conversiones `conv` implícitas / `OP_CONV_I2F` `F2I` | ✓ | ✓ | | [tests/P1_16_conversiones/](../../tests/P1_16_conversiones/) Declaración, `=` y `retornar`. Compilador: `emit_conv_for_store` en `codegen.c`. |
| P1 | 17 | `caracter`, `str_extraer_caracter`, `codigo_caracter`, `caracter_a_texto`, `byte_a_caracter`, `caracter_a_byte` | ✓ | ✓ | | [tests/P1_17_caracter/](../../tests/P1_17_caracter/) **E**/**R**. Entrada filtrada / `entrada_flotante`: [tests/P1_17_entrada_filtrada/](../../tests/P1_17_entrada_filtrada/) (**S**: `s_estres_p17_entrada_filtrada_catalogo.jasb`, `S/NOTAS_S.md`). |
| P1 | 18 | `ingresar_texto`, `pausa` / entrada estándar | ✓ | | | [tests/P1_18_ingresar_texto/](../../tests/P1_18_ingresar_texto/) **E**/**R**: sintaxis destino; EOF (`--continuo`); línea >255 chars (`fgets`); `pausa` en formas `pausa` y `pausa("mensaje")`; error con más de un argumento; batería **R** `r_cu_p18_ctrl_*.jasb` (texto como control: `si`, `mientras`, `seleccionar`, `cuando`, `str_a_entero`, etc.) y caso interactivo `r_cu_p18_pausa_basica.jasb`; ver `E/NOTAS_E.md`, `README.md`. |
| P1 | 19 | `imprimir_sin_salto`, `imprimir_flotante`, `imprimir_id` | ✓ | ✓ | | [tests/P1_19_imprimir_variantes/](../../tests/P1_19_imprimir_variantes/) **E**/**R**. `imprimir_flotante` / `imprimir_id` no anaden `\n` (ver `R/r_cu_p19_basico_tres_funciones.jasb`). |
| P1 | 20.1 | Tipo `funcion`, parámetro función, llamada indirecta `expr(args)`, flecha como valor | ✓ | ✓ | ✓ | [tests/P1_20_1/](../../tests/P1_20_1/) **Sin** `registro`; batería aparte de P2·20. Ver `README.md`, `R/NOTAS_R.md`. Relacionado: P1·11–13, VM `OP_LLAMAR` con destino en registro. Ampliación tipos-función nombrados: [PENDIENTE_TIPOS_FUNCION_OPCION_A.md](PENDIENTE_TIPOS_FUNCION_OPCION_A.md). |
| P2 | 20 | `registro` … `fin_registro`, campos, acceso miembro | ✓ | ✓ | ✓ | [tests/P2_20_registro/](../../tests/P2_20_registro/) **E**/**R**/**S**: `Tipo nombre` (`parser.c`); asignación `x.campo =` (`codegen.c`). Volcado `${registro}` / `imprimir` con indentación legible. Campos: no usar palabras reservadas (`y`, `o`, …). Ver `README.md`, `E/NOTAS_E.md`. Orden superior / `funcion` como valor: [tests/P1_20_1/](../../tests/P1_20_1/). |
| P2 | 20b | `clase` … `fin_clase`, **`extiende`**, campo **`funcion`** (polimorfismo manual) | ✓ | ✓ | ✓ | [tests/P2_20_clase_extiende_polimorfismo/](../../tests/P2_20_clase_extiende_polimorfismo/) **E**/**R**/**S**; smoke: [test_clase_extiende.jasb](../../sdk-dependiente/jas-compiler-c/tests/test_clase_extiende.jasb). **Estado implementación:** § *Estado de trabajo — P2·20 Clase, `extiende` y polimorfismo manual* (encima de la tabla maestra). Sin `obj.metodo()` automático. |
| P2 | 21 | `vec2` `vec3` `vec4` constructores y acceso; `vec*_longitud`, `normalizar`, `dot`, `vec3_cross` | ✓ | ✓ | ✓ | [tests/P2_21_vectores/](../../tests/P2_21_vectores/) **E**/**R**/**S**: `vec*_normalizar`, `vec3_cross`; compilador: structs `vec*` en `codegen_generate`, `.y` tras `.` en `parser.c`, `OP_ESCRIBIR` en normalizar/cross, `get_expression_type` para `vec*_longitud`/`vec*_dot`. Ver `README.md`, `R/NOTAS_R.md`, `S/NOTAS_S.md`. |
| P2 | 22 | `mat4_mul_vec4`, `mat4_mul`, `mat4_identidad`, `mat4_transpuesta`, `mat4_inversa` | ✓ | ✓ | ✓ | [tests/P2_22_mat4/](../../tests/P2_22_mat4/) **E**/**R**/**S**: aridad builtins; `mat4_inversa` **singular** → error en ejecución (VM `OP_MAT4_INVERSA`). Struct `mat4` con campos `e0`…`e15` en `resolve.c` / `codegen_generate`. `build_vm.bat`: si `jasboot-ir-vm.exe` está bloqueado, usar `jasboot-ir-vm-trace.exe`. Ver `README.md`, `R/NOTAS_R.md`, `E/NOTAS_E.md`, `S/NOTAS_S.md`. |
| P2 | 23 | `mat3_mul_vec3`, `mat3_mul` | ✓ | ✓ | ✓ | [tests/P2_23_mat3/](../../tests/P2_23_mat3/) **E**/**R**/**S**: aridad e identificadores; struct `mat3` `e0`…`e8` en `resolve.c` / `codegen_generate` (paridad con P2_22). Ver `README.md`, `R/NOTAS_R.md`, `E/NOTAS_E.md`, `S/NOTAS_S.md`. |
| P2 | 24 | `sin`, `cos`, `tan`, `atan2` / `arcotangente2`, `exp`, `log`, `log10` | ✓ | ✓ | ✓ | [tests/P2_24_trig_exp_log/](../../tests/P2_24_trig_exp_log/) **E**/**R**/**S**: tablas de valores; aridad `atan2`; mensajes claros sin argumentos (`codegen.c`). `get_expression_type` → `flotante`. Ver `README.md`, `R/NOTAS_R.md`, `E/NOTAS_E.md`, `S/NOTAS_S.md`. |
| P2 | 25 | Operadores bits `bit_shl`, `bit_shr`; comparaciones unsigned si aplica | ✓ | ✓ | ✓ | [tests/P2_25_bits_unsigned/](../../tests/P2_25_bits_unsigned/) **E**/**R**/**S**: `<<`/`>>` y builtins; `OP_CMP_*_U` cuando interviene `u32`/`u64` (`codegen.c`). Aridad estricta 2 en `bit_shl`/`bit_shr`. **Nota:** `>>` en VM es desplazamiento logico sobre 64 bits (ver `README.md`). |
| P2 | 26 | Operadores asignación `+=` `-=` `*=` `/=` y dobles `==` `!=` `<=` `>=` `<<` `>>` | ✓ | ✓ | ✓ | [tests/P2_26_operadores_asignacion_y_dobles/](../../tests/P2_26_operadores_asignacion_y_dobles/) **E**/**R**/**S**: compuestos, comparaciones y shifts; **E** miembro de `registro` y literal; **S** bucle `+=` (suma &lt; 1e9 por `imprimir`/timestamp en VM). Ver `README.md`. |
| P2 | 27 | Listas literales y `lista` tipo; `crear_lista` / `mem_lista_crear` / `lista_crear` | ✓ | ✓ | ✓ | [tests/P2_27_listas_tipo_y_crear/](../../tests/P2_27_listas_tipo_y_crear/) **E**/**R**/**S**: `[]`, APIs, aridad `crear_lista`, `imprimir lista` resumido, `lista_limpiar`; literal `[…]` no vacío aún problemático en algunos entornos (ver `README.md`). Roadmap: `CHECKLIST_ROADMAP_LISTAS.md`. |
| P2 | 28 | `mem_lista_agregar`, `mem_lista_obtener`, `mem_lista_tamano`, `lista_limpiar` | ✓ | ✓ | ✓ | [tests/P2_28_listas_obtener_agregar/](../../tests/P2_28_listas_obtener_agregar/) **E**: índice fuera de rango (VM aborta; handle inexistente sigue dando 0) |
| P2 | 29 | `mapa_crear`, `mapa_poner`, `mapa_obtener` | ✓ | ✓ | ✓ | [tests/P2_29_mapa_crear_poner_obtener/](../../tests/P2_29_mapa_crear_poner_obtener/) **E**/**R**/**S**: aridad; clave inexistente → error VM **capturable** (`intentar`/`atrapar`), mismo criterio que `m[clave]`; **E** ejecución sin `intentar`; **S** miles de claves; suma en **S** partida por timestamp en `imprimir`. Ver `README.md`, `NOTAS_*.md`. |
| P3 | 30 | Cadenas: `concatenar`, `longitud` / `longitud_texto`, `dividir` / `dividir_texto`, `minusculas` / `str_minusculas`, `copiar_texto` / `str_copiar` | ✓ | ✓ | ✓ | [tests/P3_30_cadenas_utilidades/](../../tests/P3_30_cadenas_utilidades/) **E**/**R**/**S**: aridad (0/1/2+ según API; `dividir`/`dividir_texto` exactamente 2); **R**/**S** como en `README.md`. |
| P3 | 31 | `extraer_subtexto`, `extraer_antes_de`, `extraer_despues_de` | ✓ | ✓ | ✓ | [tests/P3_31_extraer_subtexto_y_alrededor/](../../tests/P3_31_extraer_subtexto_y_alrededor/) **E**/**R**/**S**: aridad (2–3 subtexto, 2 antes/despues); VM **ANTES_REG** con caché de texto; ver `README.md`, `S/NOTAS_S.md`. **Estado implementación:** § *Estado de trabajo — P3·31* (encima de la tabla maestra). |
| P3 | 32 | `buscar_en_texto` / `contiene_texto`, `termina_con` (expresión o sentencia según AST) | ✓ | ✓ | ✓ | [tests/P3_32_buscar_contiene_termina/](../../tests/P3_32_buscar_contiene_termina/) **E**/**R**/**S**: aridad 2 en llamadas incorporadas; sinónimos buscar/contiene; `termina_con` con sufijo; AST `NODE_CONTIENE_TEXTO` / `NODE_TERMINA_CON` (sentencia → `resultado`). Ver `README.md`, `S/NOTAS_S.md`. **Estado:** § *Estado de trabajo — P3·32* (encima de la tabla maestra). |
| P3 | 33 | `str_a_entero`, `str_a_flotante`, `str_desde_numero` | ✓ | ✓ | | **E**: texto no numérico |
| P3 | 34 | `ultima_palabra`, `copiar_texto` (sentencias AST si aplican) | ✓ | ✓ | | [tests/P3_34_ultima_palabra_copiar_ast/](../../tests/P3_34_ultima_palabra_copiar_ast/) **E**/**R**: forma sentencia `api(expr) en destino`; parser + VM alineados para escribir `texto` visible en destino. |
| P3 | 35 | `define_concepto` (NODE_DEFINE_CONCEPTO) | ✓ | ✓ | | [tests/P3_35_define_concepto_ast/](../../tests/P3_35_define_concepto_ast/) **E**/**R**: `define_concepto "x"` y `define_concepto "x" como "desc"`; parser AST alineado con `NODE_DEFINE_CONCEPTO`. |
| P3 | 36 | `crear_memoria`, `cerrar_memoria` | ✓ | ✓ | ✓ | Alcance deseado: **E** uso inválido / aridad / ruta problemática si aplica y error si se abre memoria persistente y se termina sin `cerrar_memoria()`; **R** abrir memoria, operar sin error y cerrar limpiamente; **S** crear/cerrar en bucle, reapertura y verificación de que no se corrompe el ciclo de vida de la memoria neuronal entre iteraciones. |
| P3 | 37 | `recordar` … `con valor` / sin valor | ✓ | ✓ | ✓ | [tests/P3_37_recordar_con_y_sin_valor/](../../tests/P3_37_recordar_con_y_sin_valor/) **E**/**R**/**S**: `recordar "concepto"` y `recordar "clave" con valor "texto"`; búsqueda posterior con `buscar`; persistencia tras `crear_memoria` / `cerrar_memoria`. |
| P3 | 38 | `buscar` → variable `resultado` | ✓ | ✓ | ✓ | [tests/P3_38_buscar_resultado/](../../tests/P3_38_buscar_resultado/) **E**/**R**/**S**: `buscar` escribe en `resultado`, se sobreescribe entre consultas, devuelve el propio concepto cuando existe sin `con valor`, devuelve el valor asociado cuando aplica y falla si la clave no existe. |
| P3 | 39 | `asociar` (sentencia) y `mem_asociar` (llamada) | ✓ | ✓ | ✓ | [tests/P3_39_asociar_mem_asociar/](../../tests/P3_39_asociar_mem_asociar/) **E**/**R**/**S**: `asociar origen con destino` como sentencia y `mem_asociar(origen, destino, peso)` como llamada; verificación con `mem_obtener_fuerza(...)`. |
| P3 | 40 | `aprender` (sentencia) y `aprender` / `aprender_peso` (llamada) | ✓ | ✓ | ✓ | [tests/P3_40_aprender_y_aprender_peso/](../../tests/P3_40_aprender_y_aprender_peso/) **E**/**R**/**S**: `aprender concepto`, `aprender concepto con peso magnitud`, `aprender(concepto, magnitud)` y `aprender_peso(concepto, magnitud)`; comprobación posterior con `buscar`. |
| P3 | 41 | `reforzar`, `penalizar` | ✓ | ✓ | ✓ | [tests/P3_41_reforzar_penalizar/](../../tests/P3_41_reforzar_penalizar/) **E**/**R**/**S**: refuerzo y penalización por concepto sobre conexiones JMN; verificación con `mem_asociar` y `mem_obtener_fuerza`; magnitud opcional como literal entero 1–100. |
| P3 | 42 | `decae_conexiones` / `decaer_conexiones`, `olvidar_debiles` | ✓ | ✓ | ✓ | |
| P3 | 43 | `consolidar_memoria` / `dormir` / `consolidar` | ✓ | ✓ | ✓ | [tests/P3_43_consolidar_memoria_dormir/](../../tests/P3_43_consolidar_memoria_dormir/) **E**/**R**/**S**: tres alias sin argumentos (error de compilación si sobran); `mem_asociar` + `mem_obtener_fuerza` para observar el efecto; **S** bucle con `mientras … hacer` alternando los tres nombres. Ver `README.md`, `R/NOTAS_R.md`, `S/NOTAS_S.md`. |
| P3 | 44 | `pensar`, `procesar_texto` | ✓ | ✓ | ✓ | [tests/P3_44_pensar_procesar_texto/](../../tests/P3_44_pensar_procesar_texto/) **E**/**R**/**S**; ver § *Estado de trabajo — P3·44* arriba. |
| P3 | 45 | `registrar_patron`, `asociar_secuencia`, `comparar_patrones` | ✓ | ✓ | ✓ | |
| P3 | 46 | `pensar_siguiente`, `pensar_anterior` | ✓ | ✓ | ✓ | |
| P3 | 47 | `buscar_asociados` / `asociados_de`, `buscar_asociados_lista` / `asociados_lista_de` | ✓ | ✓ | ✓ | |
| P3 | 48 | `obtener_relacionados`, `obtener_todos_conceptos`, `es_variable_sistema` | ✓ | ✓ | | |
| P3 | 49 | `propagar_activacion` / `propagar_activacion_de` | ✓ | ✓ | ✓ | **R**: grafos ampliados |
| P3 | 50 | `elegir_por_peso` / `elegir_por_peso_segun` / `elegir_por_peso_id` / `elegir_por_peso_semilla` / `elegir_por_peso_seed` | ✓ | ✓ | ✓ | |
| P3 | 51 | `resolver_conflictos` / `resolver_conflictos_de` (si opcode en VM) | ✓ | ✓ | | Verificar paridad VM-compilador |
| P3 | 52 | Percepción: `ventana_percepcion` / `flujo_temporal`, `percepcion`, `percepcion_limpiar`, `percepcion_tamano`, `percepcion_anterior`, `percepcion_recientes` | ✓ | ✓ | ✓ | |
| P3 | 53 | Rastro: `ventana_rastro_activacion` / `rastro_activacion_ventana`, `rastro_activacion_limpiar`, `rastro_activacion_tamano`, `rastro_activacion_obtener`, `rastro_activacion_peso`, `rastro_activacion_lista` / `rastro_activacion_recientes` | ✓ | ✓ | ✓ | |
| P4 | 54 | Archivos: `abrir_archivo` / `fs_abrir`, `cerrar_archivo` / `fs_cerrar`, `leer_linea_archivo` / `fs_leer_linea`, `escribir_archivo` / `fs_escribir`, `fin_archivo`, `existe_archivo`, `listar_archivos` / `fs_listar`, `fs_leer_byte`, `fs_escribir_byte`, `fs_leer_texto` | ✓ | ✓ | ✓ | [tests/P4_54_archivos_sistema/](../../tests/P4_54_archivos_sistema/). **E**: permisos, rutas, disco lleno |
| P4 | 55 | `leer_entrada`, `percibir_teclado` | ✓ | | | |
| P4 | 56 | `obtener_timestamp` / `ahora` / `obtener_ahora`, `diferencia_en_segundos` | ✓ | ✓ | | |
| P4 | 57 | `reservar`, `liberar` (heap VM) | ✓ | ✓ | ✓ | **E**: doble libre, fugas |
| P4 | 58 | `sistema_ejecutar`, `sys_argc`, `sys_argv` | ✓ | | ✓ | **E**: comando inválido |
| P4 | 59 | `ffi_cargar`, `ffi_simbolo`, `ffi_llamar` | ✓ | | ✓ | **S**: llamadas masivas; **E**: simbolo inexistente |
| P4 | 60 | `activar_modulo` | ✓ | ✓ | | |
| P4 | 61 | `responder` (NODE_RESPONDER) | ✓ | | | |
| P4 | 62 | Extraer texto sentencias AST (`NODE_EXTRAER_TEXTO` si aplica) | ✓ | | | |
| P5 | 63 | Opcodes presentes en IR pero **no** vistos en `visit_call_sistema` como alias listados: revisar usos indirectos (p. ej. `OP_IR_ESCRIBIR`, `OP_MEM_LISTA_UNIR`, `OP_MEM_LISTA_PONER`, etc.) | ✓ | ✓ | | Auditar `ir_format.h` vs `vm.c` vs codegen |
| P5 | 64 | `seleccionar` / `caso` / `defecto` / `fin_seleccionar` | ✓ | ✓ | ✓ | [tests/P1_19_seleccionar_intentar_lanzar/](../../tests/P1_19_seleccionar_intentar_lanzar/) |
| P5 | 65 | `intentar` / `atrapar` / `final` / `fin_intentar` + `lanzar` | ✓ | ✓ | ✓ | [tests/P1_19_seleccionar_intentar_lanzar/](../../tests/P1_19_seleccionar_intentar_lanzar/) |

---

## P1_12 — Contrato pedagógico y regresiones (flechas y `macro`)

Documento de referencia para autores de tests y cambios en `parser.c` / `codegen.c` / avisos en `main.c`:

- **Guía del lenguaje (P1 · 12):** [GUIA_P1_12_FLECHAS_Y_MACRO.md](./GUIA_P1_12_FLECHAS_Y_MACRO.md) — formas válidas, reglas de `=>` y `(`, interpolación `${…}` como expresión completa, parámetros y palabras reservadas, nota hacia **P1 · 13** (`llamar`).

**Cobertura de carpetas** (`tests/P1_12_funciones_flecha/`):

| Carpeta | Objetivo |
|---------|----------|
| **E/** | Errores `e1.jasb`…`e18.jasb`; matriz en `E/NOTAS_E.md`. |
| **R/** | Casos válidos: IIFE, interpolación con flecha, `macro`, cuerpo multilínea. |
| **S/** | Estrés: repetición de invocaciones a `macro`; integración P0–P1_12 (p. ej. `s_estres_p12_presupuesto_hogar.jasb`). |

**Mensajes que conviene tratar como regresión consciente** (antes de acortar o generalizar el texto del compilador):

- **e6:** falta explícita de `=>` tras `(parámetros)` en macro, con ejemplo.
- **e7:** obligatoriedad de `(` al inicio de la lista de parámetros en macro (no `macro f = x => …`).
- **e8:** errores de paréntesis / forma de IIFE según `NOTAS_E.md`.
- **e16:** cuerpo vacío tras `=>` antes del `)` que cierra la lambda.
- **e17 / e18:** arity en **llamada a macro** (codegen): contraste parámetros vs argumentos, pista de sobran/faltan valores; inclusión de **ruta de archivo** en el diagnóstico cuando hay línea/columna válidas.

**Variables / macros “no usadas”:** el paso de avisos debe recorrer las expresiones dentro de `"${ … }"` (misma expresión que usa codegen al interpolar). Cambiar `unused_scan_expr` sin replicar ese barrido puede reintroducir **falsos avisos** sobre `macro` solo usada en literales interpolados.

---

## Parte B — Inventario alfabético: llamadas reconocidas como “sistema” en el parser

Lista tomada de `sistema_llamadas.c` (`SISTEMA_LLAMADAS[]`). **Muchas están permitidas en análisis léxico/sintáctico** pero **no** aparecen como ramas en `visit_call_sistema` del compilador C: exigen verificación antes de marcarlas como “funcionales” en bytecode.

| Nombre | Lowering en codegen.c (jas-compiler-c) |
|--------|----------------------------------------|
| `abrir_archivo` | Sí (alias `fs_abrir`) |
| `cerrar_archivo` | Sí |
| `escribir_archivo` | Sí |
| `leer_linea_archivo` | Sí |
| `fin_archivo` | Sí |
| `existe_archivo` | Sí |
| `obtener_todos_conceptos` | Sí |
| `obtener_relacionados` | Sí |
| `lista_tamano` | Sí |
| `lista_obtener` | Sí |
| `obtener_timestamp` | Sí |
| `aprender_peso` | Sí (junto `aprender`) |
| `procesar_texto` | Sí |
| `str_minusculas` | Sí |
| `str_copiar` | Sí |
| `lista_agregar` | Sí |
| `crear_lista` | Sí |
| `obtener_nombre_concepto` | **Comprobar** lowering |
| `listar_archivos` | Sí |
| `finalizar` | **Comprobar** |
| `olvidar` | **Comprobar** (no confundir con `olvidar_debiles`) |
| `pensar` | Sí |
| `obtener_campo` | **Comprobar** |
| `bit_shl` | Sí |
| `bit_shr` | Sí |
| `sistema_ejecutar` | Sí |
| `mapa_crear` | Sí |
| `mapa_poner` | Sí |
| `mapa_obtener` | Sí |
| `str_a_entero` | Sí |
| `str_a_flotante` | Sí |
| `fs_abrir` … `fs_leer_texto` | Parcialmente listado arriba |
| `sys_argc`, `sys_argv` | Sí |
| `str_extraer_caracter`, `str_desde_numero`, `codigo_caracter`, `caracter_a_texto`, `byte_a_caracter`, `caracter_a_byte` | Sí |
| `mem_lista_*`, `mem_crear`, `mem_cerrar`, `mem_asociar`, `tiene_asociacion` | Sí |
| `imprimir_flotante` | Sí |
| `comparar_gt_flt`, `mem_poner_u32_ind`, `mem_obtener_u32_ind`, `mem_aprender_peso_reg` | **Comprobar** opcodes |
| `pensar_respuesta` | **Comprobar** (existe `OP_MEM_PENSAR_RESPUESTA` en VM; falta confirmar emisión en codegen) |
| `buscar` | Sí |
| `imprimir_sin_salto` | Sí |
| `es_variable_sistema` | Sí |
| `reforzar`, `penalizar`, `mem_obtener_fuerza` | Sí |
| `asociar_pesos_conceptos` | **Comprobar** |
| `asociar_secuencia`, `registrar_patron`, `pensar_siguiente`, `pensar_anterior`, `corregir_secuencia`, `asociar_relacion`, `comparar_patrones` | Parcial: confirmar `corregir_secuencia`, `asociar_relacion` |
| `asociar_similitud`, `asociar_diferencia` | **Comprobar** |
| `buscar_asociados*`, `decae_conexiones*`, `consolidar*`, `olvidar_debiles` | Sí |
| Percepción y rastro | Sí (familia listada en Parte A) |
| `propagar_activacion*`, `elegir_por_peso*`, `resolver_conflictos*` | Confirmar `resolver_conflictos` en codegen |
| `segmentar_palabras`, `palabras_de` | **Sin rama en visit_call_sistema** (solo registro parser) |
| `dividir_texto`, `minusculas`, `extraer_subtexto`, `imprimir_id`, `longitud_texto` | Sí / síntesis arriba |
| `propiedad_concepto` | **Comprobar** |
| `reservar`, `liberar`, `ir_escribir` | `reservar`/`liberar` sí; **`ir_escribir` comprobar** |
| `concatenar`, `longitud`, `dividir`, `buscar_en_texto`, `contiene_texto`, `termina_con` | Sí |
| `leer_entrada`, `percibir_teclado`, `ahora*`, `diferencia_en_segundos` | Sí |
| `n_abrir_grafo` … `n_heredar_texto` (familia `n_*`) | **Sin ramas en visit_call_sistema** — grafo N en VM distinta / stub |
| `vec2_sumar` … `vec4_restar` | **Sin ramas**; solo `longitud`, `normalizar`, `dot`, `cross` y matrices |
| `vec2_longitud` … `mat3_mul` | Sí en codegen |
| `sin` … `log10` | Sí |
| `ffi_cargar`, `ffi_simbolo`, `ffi_llamar` | Sí |

**Acción recomendada:** cerrar filas “Comprobar” con un test `.jasb` mínimo por nombre y traza de disassembly IR; mover a Parte A cuando esté verificado.

---

## Parte C — Palabras clave estructurales (lexer)

Tomado de `keywords.c` (`KEYWORDS`). Forman la gramática; los tests **E** incluyen programas mal formados.

- Bloques: `principal`, `fin_principal`, `funcion`, `fin_funcion`, `mientras`, `fin_mientras`, `cuando`, `fin_cuando`, `si`, `sino`, `fin_si`, `registro`, `fin_registro`, `clase`, `fin_clase`, `concepto`, `fin_concepto`, `hacer`, `usar`
- Herencia de tipos compuestos (tras el nombre del tipo): `extiende` (solo en `registro`/`clase`; ver **P2·20b**)
- Nuevos bloques de control: `seleccionar`, `caso`, `defecto`, `fin_seleccionar`, `intentar`, `atrapar`, `final`, `fin_intentar`, `lanzar`
- Tipos y calificadores: `entero`, `texto`, `flotante`, `caracter`, `lista`, `mapa`, `bool`, `constante`, `vec2`, `vec3`, `vec4`, `mat4`, `mat3`, `u32`, `u64`, `u8`, `byte`
- Flujo: `retornar`, `romper`, `continuar`, `entonces`, `retorna`
- Expresiones anónimas / alias: `macro` … `=` … (ligadura a función flecha; ver ítem **P1·12**, carpeta `tests/P1_12_funciones_flecha/`)
- E/S: `imprimir`, `imprimir_sin_salto`, `imprimir_texto`, `ingresar_texto`, `entrada`
- Memoria cognitiva (sentencias): `recordar`, `responder`, `aprender`, `reforzar`, `penalizar`, `buscar`, `buscar_peso`, `asociar`, `define_concepto`, `crear_memoria`, `cerrar_memoria`, `crear_concepto`, `activar_modulo`, `biblioteca`
- Auxiliares léxicos: `con`, `valor`, `peso`, `igual`, `es`, `mayor`, `menor`, `distinto`, `como`, `o`, `y`, `no`, `que`, `de`, `a`

**Operadores:** de un carácter `=+-*/%(),.[]{}:?!<>` y de dos `== != <= >= += -= *= /= << >>`; **función flecha** `=>` (token `TOK_OPERATOR`, no palabra reservada en `keywords.c`).

---

## Parte D — Catálogo de errores (alcance del estándar)

Para **estandarizar** mensajes y códigos de fallo, conviene una tabla paralela (versión siguiente del documento o `docs/TECNICO/ERRORES_JASBOOT.md`) con:

| Código | Fase | Ejemplo |
|--------|------|---------|
| JAS-E001 | Compilación | identificador no declarado |
| JAS-E002 | Compilación | tipo incompatible |
| JAS-R001 | VM | división por cero |
| JAS-R002 | VM | desbordamiento de pila de llamadas |
| JAS-R003 | VM | índice fuera de rango (lista, memoria) |
| JAS-R004 | VM | archivo no encontrado |
| JAS-R005 | VM | `ffi` símbolo no resuelto |
| … | … | … |

Este checklist define **qué** hay que ejercitar para descubrir y asignar esos códigos; la numeración final es decisión del equipo.

---

## Parte E — Referencias

- **P1 · 13 (`llamar`):** [tests/P1_13_llamar_funcion/README.md](../../tests/P1_13_llamar_funcion/README.md)
- **P1 · 14 (`usar` / módulos):** [tests/P1_14_usar_modulos/README.md](../../tests/P1_14_usar_modulos/README.md)
- **Guía P1 · 12 (flechas y `macro`):** [GUIA_P1_12_FLECHAS_Y_MACRO.md](./GUIA_P1_12_FLECHAS_Y_MACRO.md)
- **Funciones flecha** (E/R/S): [tests/P1_12_funciones_flecha/README.md](../../tests/P1_12_funciones_flecha/README.md)
- Batería de **estrés de producción P0_01–P0_09** (un integrador + `s_produccion_*` por carpeta): [tests/P0_estres_produccion_P01_P09_integracion/](../../tests/P0_estres_produccion_P01_P09_integracion/README.md)
- Tests de producción (estrategia): `docs/PROYECTO/CHECKLIST_TESTS_PRODUCCION_JASBOOT.md`
- Opcodes IR: `sdk-dependiente/jasboot-ir/src/ir_format.h`
- Sintaxis lenguaje: `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md`
- **P2 · 20b (clase / `extiende` / polimorfismo manual):** § *Estado de trabajo — P2·20 Clase, `extiende` y polimorfismo manual* arriba; batería [tests/P2_20_clase_extiende_polimorfismo/](../../tests/P2_20_clase_extiende_polimorfismo/)

---

*Documento generado a partir del árbol de código del repo; actualizar la columna “Comprobar” conforme se cierren huecos en `codegen.c`.*
