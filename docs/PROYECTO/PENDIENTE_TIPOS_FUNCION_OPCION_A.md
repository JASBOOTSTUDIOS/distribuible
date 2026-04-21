# Pendiente de diseño: tipos función nombrados + campos invocables en registros (opción A)

**Estado:** no implementado en el compilador Jasboot actual; nota de diseño para trabajo futuro.

## Objetivo

Permitir **funciones de orden superior** y **registros que contienen referencias a funciones** (comportamiento como dato), **sin** incrustar `macro` dentro del bloque `registro`. La firma se declara con un **tipo con nombre**; los campos del registro usan ese nombre como tipo.

## Modelo (opción A)

1. Declarar **firmas con nombre** (tipo función):
   - Ejemplo conceptual: `tipo funcion NombreTipo(param1, param2, ...) retorna TipoRetorno`
   - Cada nombre es un identificador de tipo en la tabla de símbolos, con metadato de firma.

2. En **`registro`**, los campos pueden ser tipos escalares habituales **o** un **tipo función** ya declarado:
   - Ocupa un slot invocable en memoria (representación por definir: índice de función, etiqueta VM, handle, etc.).

3. **Asignación**: `campo = funcion_global` solo si la firma de `funcion_global` coincide con el tipo del campo.

4. **Llamada**: `campo(arg1, arg2)` o variable que almacena ese campo; mismas reglas que una llamada normal, con comprobación de tipos.

5. **Funciones de orden superior**: parámetros declarados con tipo función nombrado; el cuerpo invoca el parámetro como función.

## Lo que se descarta en esta opción (por ahora)

- Definir `macro ... =>` **dentro** de `registro` (se pospone o se trata como azúcar que baja a campos `tipo funcion` + registro de función, con reglas explícitas de `self`/captura).

- **Closures** que capturen variables locales (fase 2 si se desea; implica entorno, tiempo de vida, copia de registros).

## Decisiones abiertas para implementación

- **MVP sugerido:** solo referencias a **funciones globales** con firma fija; sin lambdas en campos de registro.
- **Representación en IR/VM:** tamaño del slot (p. ej. 8 bytes = id de función), convención de llamada alineada con `OP_LLAMAR` actual.
- **Compatibilidad:** no solapar nombres `tipo funcion X` con `funcion x` (convención de mayúsculas o prefijos).
- **Errores:** mensajes explícitos por firma incompatible en asignación o llamada.

## Ejemplo de referencia (esquema)

Ver conversación de diseño / ejemplo grande en el hilo donde se definieron `PredicadoEntero`, `CriterioBusqueda`, `filtrar_y_transformar`, asignaciones `crit.coincide = es_par` y llamadas `filtro(valor)`.

## Enlace con OS-IA

Callbacks, estrategias intercambiables y pipelines declarativos encajan con **lógica dinámica** si el host puede **registrar** o **cargar** funciones y asignarlas a campos de registro; la sintaxis del lenguaje define **tipos**; la inyección en runtime puede vivir en VM + API del sistema.

---

*Última actualización: documento creado para dejar constancia del diseño pendiente.*
