# E — funciones flecha (errores)

Convención: **`eN.jasb`** (`e1`, `e2`, …). Cada archivo **debe fallar** compilación o codegen. La matriz cubre IIFE, `macro`, parámetros, bloques `{ }` y arity en parser vs codegen.

Cada `.jasb` incluye al inicio **comentarios `//`**: título del caso, **qué se espera** (fallo y mensaje aproximado) y **qué se mide** (regla o fase del compilador).

| Archivo | Qué provoca el fallo (resumen) | Fase típica |
|---------|--------------------------------|-------------|
| **e1** | IIFE: más argumentos que parámetros `((x)=>…)(1,2)` | Parser (mensaje *cantidad de argumentos*) |
| **e2** | IIFE: menos argumentos que parámetros `((m,n)=>…)(1)` | Parser (mismo mensaje) |
| **e3** | Cuerpo bloque `=> { …` con `)` en lugar de `}` | Sintaxis (mensaje explícito: falta `}` antes de `)`; bloque de flecha) |
| **e4** | Parámetro nombre reservado `y` (conjunción) | Nombre inválido |
| **e5** | Parámetro tipado con nombre reservado `si` | Nombre inválido |
| **e6** | `macro` sin `=>` entre firma y cuerpo `(x) x + 1` | Sintaxis (mensaje explícito: debe ir `=>` antes del cuerpo) |
| **e7** | `macro` sin paréntesis alrededor de parámetros `x => …` | Sintaxis (mensaje explícito: lista de parámetros entre `(` … `)`) |
| **e8** | Lista de parámetros sin `(` de apertura: `(x => …)(1)` | Sintaxis |
| **e9** | Paréntesis mal cerrados: `((x)=>x+1(1)` (falta `)` antes de la llamada) | Sintaxis |
| **e10** | Doble coma en parámetros `((x,,y)=>…)` | Sintaxis |
| **e11** | IIFE sin parámetros pero con un argumento `(()=>1)(1)` | Parser (arity) |
| **e12** | IIFE sin parámetros pero con dos argumentos `(()=>1)(1,2)` | Parser (arity) |
| **e13** | Tipo en lista de parámetros sin identificador `((entero)=>…)(1)` | Sintaxis |
| **e14** | `macro` con lambda IIFE incompleta (falta cerrar `)`) | Sintaxis |
| **e15** | Bloque con `retornar` pero `)` en lugar de `}` antes de cerrar | Sintaxis |
| **e16** | Cuerpo vacío entre `=>` y `)` en IIFE `((x)=>)(1)` | Sintaxis (mensaje explícito: falta expresión o `{ ... }` antes del `)`) |
| **e17** | Llamada a `macro` (lambda almacenada) con **demasiados** argumentos | Codegen (mensaje: parámetros vs argumentos; pista *sobran valores*) |
| **e18** | Llamada a `macro` con **insuficientes** argumentos | Codegen (mensaje: parámetros vs argumentos; pista *faltan valores*) |

**Notas**

- Para **e1, e2, e11, e12** (arity en IIFE), el compilador muestra **dos marcas `^`**: una en el `(` de la lista de **parámetros** y otra en el `(` de la lista de **argumentos** de la llamada.
- En **e1–e2, e11–e12** se usa asignación a `entero tmp` para forzar el análisis de la expresión completa (evita el fallo conocido de `imprimir ((x)=>…)(1,2)` en el parser).
- **e17–e18** fallan en **codegen**, no en el mismo punto que la IIFE inline; documentan arity al invocar un nombre de macro.
- No es posible listar *todos* los errores teóricos del lenguaje; esta batería es la cobertura **práctica** centrada en flechas y `macro`. Ampliar con nuevos `e19+` si aparecen regresiones.
