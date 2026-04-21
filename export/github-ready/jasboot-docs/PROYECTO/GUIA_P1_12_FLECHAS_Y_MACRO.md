# Guía: funciones flecha y `macro` (P1 · 12)

Referencia corta para escribir y revisar tests **y** para interpretar mensajes del compilador (`jbc`). Complementa la batería [tests/P1_12_funciones_flecha/README.md](../../tests/P1_12_funciones_flecha/README.md) y el [checklist del catálogo](./CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md).

---

## 1. Formas válidas

| Forma | Ejemplo |
|--------|---------|
| Flecha en expresión (una línea) | `(x) => x + 1` |
| Cuerpo en bloque | `(x, y) => { imprimir x retornar x + y }` |
| Tipos opcionales en parámetros | `(texto nombre, entero edad) => …` (si un parámetro no lleva tipo, suele tratarse como `entero` en la implementación actual) |
| Invocación inmediata (IIFE) | `((x) => x + 1)(5)` |
| Alias con nombre (`macro`) | `macro doblar = (x) => x * 2` luego `doblar(10)` |

Las funciones con palabra clave `funcion` … `fin_funcion` siguen siendo el mecanismo principal para rutinas grandes y recursión; las flechas y `macro` cubren expresiones y pequeños fragmentos reutilizables.

---

## 2. Reglas que el compilador exige

1. **Después de la lista de parámetros siempre va `=>`** antes del cuerpo (expresión o `{`).  
   Inválido: `macro f = (x) x + 1`.  
   Válido: `macro f = (x) => x + 1`.

2. **La lista de parámetros va entre paréntesis**; no se admite la forma “estilo JavaScript” sin `(` inicial en macro.  
   Inválido: `macro f = x => x + 1`.  
   Válido: `macro f = (x) => x + 1`.

3. **No puede quedar el cuerpo vacío** entre `=>` y el `)` que cierra la lambda en un IIFE.  
   Inválido: `((x) => )(1)`.  
   Válido: `((x) => x)(1)`.

4. **Arity en IIFE** (número de argumentos vs parámetros) se valida en el parser con mensaje dedicado. **Arity al llamar un nombre de `macro`** se valida en **generación de código**, con mensaje que contrasta parámetros de la definición y argumentos de la llamada (y ruta de archivo cuando aplica).

---

## 3. Nombres de parámetro y palabras reservadas

Los parámetros de `funcion`, de flechas y de `macro` deben ser **identificadores permitidos**: no pueden coincidir con palabras reservadas del lenguaje (el compilador lo indica explícitamente). Ejemplos que suelen chocar en la práctica: letras usadas como artículo o conjunción (`a`, `y`), o palabras de control (`si`, …). Los tests de error **e4**, **e5** en `tests/P1_12_funciones_flecha/E/` documentan casos de parámetros inválidos.

Si un mensaje mezcla “sintaxis” con “reservada”, priorizar el texto que cita **palabra reservada** antes de reordenar el programa.

---

## 4. Interpolación `"${ … }"` en literales de texto

El fragmento entre `${` y `}` es **una expresión completa**, no solo un nombre de variable. Ahí pueden ir llamadas, operadores, IIFE, etc., igual que en el resto del programa:

```texto
"Total aprox: ${porcentaje(parte, total)}%"
```

**Análisis de “declarada pero no usada”:** el compilador debe considerar estas expresiones al marcar si una `macro` (u otro nombre) se usa. No escribir código “ficticio” solo para silenciar avisos: una macro solo presente dentro de `${…}` **debe** contar como uso (regresión si no).

---

## 5. Mapa rápido de tests de error (E)

La tabla completa está en `tests/P1_12_funciones_flecha/E/NOTAS_E.md`. Algunos mensajes que conviene **no regresionar** sin motivo:

| Archivo | Idea que debe quedar clara al usuario |
|---------|----------------------------------------|
| **e6** | Falta `=>` entre `(parámetros)` y el cuerpo en macro; ejemplo en el mensaje. |
| **e7** | Falta `(` al inicio de la lista de parámetros en macro; no usar `macro f = x => …`. |
| **e8** | Paréntesis / forma de IIFE incoherente (ver notas del test). |
| **e16** | Cuerpo vacío tras `=>` antes del `)` de cierre de la lambda. |
| **e17** / **e18** | Llamada a macro con demasiados o demasiados pocos argumentos (codegen; mensaje con archivo/línea cuando aplica). |

---

## 6. P1 · 13 — `llamar` explícita

Implementado como **palabra clave opcional** ante una llamada: `llamar nombre(arg1, …)` o `entero x = llamar nombre(…)` (misma emisión IR que `nombre(…)`). Tras `llamar` debe seguir la forma **`identificador( … )`** (incl. llamadas sistema reconocidas como tal).

- Tests y notas: [tests/P1_13_llamar_funcion/README.md](../../tests/P1_13_llamar_funcion/README.md).
- `retornar` acepta expresiones que empiezan por `llamar` (y por `no`, negación).

`macro` + flecha no cambian: siguen siendo expansión en codegen, no `OP_LLAMAR` a etiqueta de función `funcion`.

---

## 7. Referencias técnicas en el repo

- Parser: `sdk-dependiente/jas-compiler-c/src/parser.c` (`parse_lambda`, IIFE).
- Avisos de variables no usadas (incl. barrido de `${…}`): `sdk-dependiente/jas-compiler-c/src/main.c` (`unused_scan_expr`).
- Interpolación en codegen: `sdk-dependiente/jas-compiler-c/src/codegen.c` (`parser_parse_expression_from_string`, impresión / construcción de cadenas).
