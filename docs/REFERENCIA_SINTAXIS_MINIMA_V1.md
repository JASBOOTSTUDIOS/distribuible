# Referencia de sintaxis mínima (v1)

Resumen orientativo. La **referencia completa y al día** del lenguaje que compila **jbc** está en:

→ **[LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md](LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md)**

Ahí se documentan tipos (`vec2`–`mat4`), `constante`, FFI (`ffi_cargar` / `ffi_simbolo` / `ffi_llamar`), `reservar`/`liberar`, trigonometría, matrices y el resto de llamadas de sistema con notas sobre `codegen.c`.

---

## Estructura

- **principal** … **fin_principal**: bloque principal; la indentación define bloques.
- **funcion** … **fin_funcion**; **registro** … **fin_registro**.

## Conceptos y memoria (JMN)

- **recordar "nombre" con valor** *expresión*
- **buscar** *expresión*
- **resultado** — último valor relevante según la operación.

## Evaluación y salida

- **pensar** *expresión*
- **imprimir(** *expresión* **)**

## Condicionales y bucles

- **cuando** … **sino** … **fin_cuando** (alias **si** / **fin_si**).
- **mientras** … **fin_mientras**; **romper** / **continuar**.

## Comparaciones

*E1* **es mayor que** *E2*, **es menor que**, **es igual a**, etc. Operadores: `==`, `!=`, `<`, `>`, `<=`, `>=`.

## Literales

Números; cadenas `"..."` con `\n`, `\t`, `\"`, `\\`. Booleanos **verdadero** / **falso**.

## Palabras clave e implementación

Listas mantenidas en el compilador:

- `sdk-dependiente/jas-compiler-c/src/keywords.c`
- `sdk-dependiente/jas-compiler-c/src/sistema_llamadas.c`

---

**Última actualización:** 2026-03-24
