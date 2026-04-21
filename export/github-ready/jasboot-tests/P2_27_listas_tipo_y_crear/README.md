# P2_27_listas_tipo_y_crear — `lista`, `[]`, `crear_lista`, `mem_lista_crear`, `lista_crear`

Ítem de catálogo: **P2 · 27** en [CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

**Roadmap / checklist de evolución de listas:** [CHECKLIST_ROADMAP_LISTAS.md](./CHECKLIST_ROADMAP_LISTAS.md).

---

## Qué es una `lista` en Jasboot

En el **código fuente**, `lista` es un tipo de variable: un nombre que referencia una **colección ordenada** a la que se le pueden añadir valores y consultar tamaño y elementos por índice.

En la **práctica del compilador y la VM**, una variable `lista` **no guarda los elementos dentro del stack ni en el `.jbo`**: solo guarda un **identificador numérico** (handle) que la máquina virtual usa para localizar la colección en la **memoria de colecciones** (`mem_colecciones` / JMN). `imprimir` y la interpolación `${…}` con tipo `lista` muestran un **resumen legible** `[lista id=… tamano=…]` (no un volcado de elementos; eso sería modo depuración futuro).

---

## Cómo está compuesta (capas)

1. **Variable Jasboot** (`lista x = …`): ocupa un slot como el resto de escalares (tamaño alineado a lo que declare la tabla de símbolos, típicamente 8 bytes en frame global o local). Su **contenido** es el id devuelto por `crear_lista` / `mem_lista_crear` / `lista_crear` o por un literal `[]`.

2. **IR / opcodes**: las operaciones se traducen a `OP_MEM_LISTA_CREAR`, `OP_MEM_LISTA_AGREGAR`, `OP_MEM_LISTA_OBTENER`, `OP_MEM_LISTA_TAMANO`, etc. (`codegen.c` → `vm.c`).

3. **Runtime (JMN)**: la colección real es un array dinámico de valores (`jmn_lista_agregar`, `jmn_lista_obtener`, … en `jasboot-jmn-core`). Los tests del catálogo usan sobre todo **enteros** como elementos; el modelo interno empaqueta valores en `JMNValor`.

En resumen: **lista en el lenguaje = handle opaco; lista en memoria = estructura gestionada por la VM**, no visible como struct Jasboot.

---

## Uso en el lenguaje

- **Declaración**: `lista nombre = …` (también puede ser **global** fuera de `principal`).
- **Creación** (equivalentes reconocidos por el compilador):
  - `crear_lista()` sin argumentos: genera un id interno único por compilación (`literal_counter` + `OP_MEM_LISTA_CREAR`).
  - `crear_lista("texto")`: id derivado del nombre en datos del IR (útil para depuración o nombres estables en VM).
  - `crear_lista(expresion_entera)`: el valor de la expresión es el id lógico; **no puede ser el literal entero `0`** (error de compilación); en otro caso JMN usa ese id.
  - `mem_lista_crear()` y `lista_crear()` son alias de la misma ruta de codegen.
- **Literal vacío** `[]`: crea una lista nueva vacía en expresión (`NODE_LIST_LITERAL` con cero elementos).
- **Mutación y lectura**: `mem_lista_agregar` / `lista_agregar`, `mem_lista_obtener` / `lista_obtener`, `mem_lista_tamano` / `lista_tamano` (y `.tamano` / `.medida` / `.size` en miembro, tipados como entero). Si la lista **existe** en JMN y el índice es **≥ tamano** (incluida lista vacía con índice `0`), la VM **termina con error** — ver catálogo **P2 · 28** y `tests/P2_28_listas_obtener_agregar/`.
- **Asignación**: `lista a = crear_lista(); lista b = a;` hace que **dos variables compartan el mismo id**; los cambios a través de una se ven por la otra (alias del mismo almacén JMN).

---

## Alcance y tiempo de vida

- **Alcance léxico** de variables `lista`: el mismo que el del resto de variables (bloque `principal`, funciones, bloques internos de `mientras` / `si` según `resolve.c` / `codegen.c`: entradas y salidas de ámbito con `sym_enter_scope` / `sym_exit_scope`).
- **Tiempo de vida del handle**: mientras exista la variable que lo contiene o una copia del valor; reasignar la variable sustituye el id almacenado (la variable “apunta” a otra lista).
- **Tiempo de vida de la colección en JMN** (Fase D / roadmap):
  - Sin **GC** ni conteo de referencias: el runtime no sabe cuántos handles Jasboot apuntan al mismo id.
  - **`lista_limpiar` / `mem_lista_limpiar`**: dejan la lista **vacía** (`count = 0`) pero el **id y el slot JMN siguen existiendo** (misma reserva de buffer base).
  - **`lista_liberar` / `mem_lista_liberar`**: **liberan** el buffer de elementos, sacan la entrada de la tabla hash y devuelven el **slot al pool** fijo de JMN (`jasboot-jmn-core`). Tras llamarla, el **número guardado en la variable Jasboot es un handle obsoleto**; no debe usarse para `agregar`/`obtener` sin asignar un `crear_lista()` nuevo. El valor de la expresión de la llamada se emite como **0** en codegen como señal.
  - **Listas huérfanas** (bucle que crea `lista tmp = crear_lista()` y no libera): los slots se ocupan hasta **agotar el pool** (véase límites abajo). Para bucles masivos, use **`mem_lista_liberar(tmp)`** cuando el temporal ya no se necesite (ver `S/02_s_estres_p27_miles_liberar_pool.jasb`).

---

## Límites y comportamientos reales

- **`crear_lista(0)`** (literal): **error de compilación**; use `crear_lista()` sin argumentos u otro entero.
- **`crear_lista(a, b, …)` con dos o más argumentos**: **error de compilación** (aridad 0 o 1).
- **Literal no vacío `[1, 2, …]`**: en algunos entornos Windows `jbc` puede **terminar anormalmente** al compilar (fallo aún bajo investigación en `visit_expression` / `NODE_LIST_LITERAL`). Use `crear_lista()` + `mem_lista_agregar` para la misma semántica; ver `08_r_p27_tres_elementos_por_agregar.jasb`. El literal vacío `[]` sí está cubierto.
- **`lista_limpiar` / `mem_lista_limpiar`**: vacían los elementos de la lista en JMN (`OP_MEM_LISTA_LIMPIAR`); registradas en `sistema_llamadas.c`. Ver `07_r_p27_lista_limpiar_y_mem_alias.jasb`.
- **`lista_liberar` / `mem_lista_liberar`**: liberación explícita del slot de lista en JMN (`jmn_lista_liberar`, `OP_MEM_LISTA_LIBERAR`). Ver `12_r_p27_mem_lista_liberar.jasb`.
- **Pool de listas en JMN**: hay un vector de **10 000** ranuras con **sondeo circular** desde `id % 10000` al asignar un id nuevo. Si todas las ranuras con `id != 0` están ocupadas, **no hay más slots** hasta que se llame **`mem_lista_liberar`** en alguna lista existente (o termine el proceso). No hay recolección automática de ids “huérfanos”.

---

## Carpetas de tests

| Carpeta | Contenido |
|---------|-----------|
| **R/** | Tres APIs + `[]` + `tamano`/`obtener`; `crear_lista` con texto, id explícito, tres elementos vía `agregar`, `agregar` con 2.º arg llamada; lista global y reasignación; Fase C (`para_cada`, `lista_mapear`/`filtrar`, `lista<T>`); Fase D (`mem_lista_liberar`). Prefijos **`01_`…`12_`**. Ver `R/NOTAS_R.md`. |
| **E/** | Llamada no resuelta; APIs de lista con aridad incorrecta; `crear_lista(0)` y `crear_lista` con demasiados argumentos; error de tipo `lista<T>` + `agregar`. Prefijos **`01_`…`05_`**. Ver `E/NOTAS_E.md`. |
| **S/** | Listas grandes, varias listas, bucles anidados, miles de `obtener`/`tamano`, listas huérfanas por iteración; **`02_`**: miles de `crear_lista` + `mem_lista_liberar` y acumulador. Ver `S/NOTAS_S.md`. |
