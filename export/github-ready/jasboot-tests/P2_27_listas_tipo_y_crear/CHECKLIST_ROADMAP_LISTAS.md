# Checklist — ruta para llevar `lista` más allá del catálogo P2_27

Documento de seguimiento para evolucionar listas en Jasboot (compilador, IR, VM/JMN, tests).  
**Carpeta de tests:** `tests/P2_27_listas_tipo_y_crear/` (este directorio).  
**Estado actual del diseño:** [README.md](./README.md).  
**Catálogo ítem:** [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md) (P2 · 27).

---

## Fase A — Corrección y seguridad (alto impacto, alcance acotado)

| Estado | Tarea | Rutas / notas |
|--------|--------|----------------|
| [ ] | **Literales `[e1, e2, …]`** estables en Windows (sin AV): hoy `jbc` puede fallar con no vacíos; `[]` OK. Requiere depuración nativa de `NODE_LIST_LITERAL`. | `codegen.c`; workaround **R** `08_r_p27_tres_elementos_por_agregar.jasb` |
| [x] | **`crear_lista(0)`**: rechazar en compilación; alinear con JMN (id 0 no usable). | `codegen.c`; **E** `03_e_p27_crear_lista_literal_cero.jasb` |
| [x] | **`crear_lista` aridad estricta**: 0 o 1 argumento; error si hay 2+. | `codegen.c`; **E** `04_e_p27_crear_lista_demasiados_argumentos.jasb`; **R** `r_cu_p27_crear_lista_id_explicito.jasb` (un arg) |
| [x] | **`lista_limpiar` / `mem_lista_limpiar`**: registradas en `sistema_llamadas.c` y `keywords.c`; test **R** `07_r_p27_lista_limpiar_y_mem_alias.jasb`; aridad en **E** `02_e_p27_mem_lista_limpiar_sin_args.jasb`. | `codegen.c`, `sistema_llamadas.c`, `keywords.c`, `vm.c` |
| [x] | **Mensajes de error** (aridad APIs lista): `obtener`/`agregar`/`tamano`/`limpiar` + mensajes dedicados para `crear_lista` (aridad y literal `0`). | `codegen.c` |

---

## Fase B — Experiencia de usuario y depuración

| Estado | Tarea | Rutas / notas |
|--------|--------|----------------|
| [x] | **`imprimir` de `lista`**: resumen `[lista id=… tamano=…]`; misma ruta en interpolación `${…}`. | `codegen.c` (`emit_imprimir_lista_resumen`); **S** `s_estres_p27_mil_agregar.jasb` |
| [x] | **Anidar llamadas en `mem_lista_agregar` segundo argumento**: lista en temporal antes de evaluar el valor. | `codegen.c`; **R** `09_r_p27_agregar_segundo_arg_llamada.jasb` |
| [x] | **Documentar** en README del catálogo el comportamiento final de impresión y límites. | [README.md](./README.md) |

---

## Fase C — Tipado y lenguaje (mediano plazo)

| Estado | Tarea | Rutas / notas |
|--------|--------|----------------|
| [x] | **Genéricos `lista<T>`** (`T` = entero, flotante, texto, bool): parser, AST `list_element_type`, tabla de símbolos, comprobación al agregar. | `parser.c`, `nodes.h`, `symbol_table.c`, `resolve.c`, `codegen.c` |
| [x] | **Validación y VM**: sin etiqueta de tipo en `JMNValor` en runtime; comentario en `memoria_neuronal.h`; comprobación fuerte en codegen para `mem_lista_agregar` vs `lista<T>`. | `jasboot-jmn-core`, `codegen.c` |
| [x] | **Iteración nativa**: `para_cada T nombre sobre expr hacer ... fin_para_cada` (`sobre` evita reservar `en`). | `parser.c`, `keywords.c`, `codegen.c`, tests `10_r_*.jasb` |
| [x] | **Orden superior**: `lista_mapear` / `lista_filtrar` (alias `mem_lista_*`), segundo argumento = nombre de función global. | `sistema_llamadas.c`, `codegen.c`, test `11_r_*.jasb` |

---

## Fase D — Ciclo de vida y escala (largo plazo / “OS-IA”)

| Estado | Tarea | Rutas / notas |
|--------|--------|----------------|
| [x] | **Estrategia ante listas huérfanas**: sin GC; **pool 10k slots** + sondeo documentado; huérfanas ocupan ranura hasta fin de VM o **`mem_lista_liberar`**. | `memoria_neuronal_utilidades.c`, `README.md` (P2_27) |
| [x] | **API explícita de destrucción**: `lista_limpiar` vacía elementos; **`lista_liberar` / `mem_lista_liberar`** libera slot (`jmn_lista_liberar`, `OP_MEM_LISTA_LIBERAR`). | `codegen.c`, `vm.c`, `sistema_llamadas.c` |
| [x] | **Tests de estrés** `S/02_` (miles de crear+liberar + acumulador); `R/12_` cobertura básica de liberar. | `S/02_s_estres_p27_miles_liberar_pool.jasb`, `R/12_r_p27_mem_lista_liberar.jasb` |

---

## Referencia rápida de rutas en el monorepo

| Componente | Ruta típica |
|-----------|-------------|
| Codegen listas / IR | `sdk-dependiente/jas-compiler-c/src/codegen.c` |
| Parser / AST | `sdk-dependiente/jas-compiler-c/src/parser.c`, `include/nodes.h` |
| Llamadas sistema | `sdk-dependiente/jas-compiler-c/src/sistema_llamadas.c` |
| Opcodes (nombres) | `sdk-dependiente/jas-compiler-c/include/opcodes.h`, `jasboot-ir/src/ir_format.h` |
| VM opcodes lista | `sdk-dependiente/jasboot-ir/src/vm.c` |
| JMN listas | `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_utilidades.c` |
| Tests P2_27 | `tests/P2_27_listas_tipo_y_crear/{R,E,S}/` |

---

## Cómo usar este checklist

1. Marca `[x]` cuando un ítem esté **hecho y cubierto por tests** (actualizar `NOTAS_*.md` si cambian salidas).
2. Si un ítem se abandona o se difiere, anótalo bajo el ítem (una línea) para no reabrir el debate sin contexto.
3. Mantén **un issue o PR por fase** cuando sea posible, para revisiones revisables.

Última revisión alineada con el README y tests del catálogo P2_27 en el repo `jasboot`.
