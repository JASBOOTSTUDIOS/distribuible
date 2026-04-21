# P1 · 19 — `imprimir_sin_salto`, `imprimir_flotante`, `imprimir_id`

Cubre el checklist **P1 | 19**.

- **`imprimir_sin_salto`**: como `imprimir` pero sin salto de línea final (útil para armar líneas por partes).
- **`imprimir_flotante`**: escribe un `flotante` con formato decimal (VM `OP_IMPRIMIR_FLOTANTE`); **no** añade salto de línea (`printf` sin `\n`).
- **`imprimir_id(expr)`**: la expresión debe ser algo que, en runtime, sea un **identificador** (en la práctica, un `texto` o un valor que ya sea un id de concepto/cadena). La VM **no** muestra el id numérico al usuario: intenta **resolver** ese id y escribir la **cadena legible** asociada (caché de textos de la VM, luego JMN si aplica). Por eso en `r_cu_p19_basico_tres_funciones.jasb`, `imprimir_id(saludo)` con `saludo = "hola"` imprime `hola`. Caso típico en documentación: ids devueltos por **`buscar`**, **`propiedad_concepto`**, etc. **No** añade salto de línea al final.

**R/** ejecución directa con `bin\jbc.cmd … -e`. **E/** llamadas sin argumentos (error de compilación).
