# Auditoria de `OP_LEER` en la VM

## Objetivo

Este documento registra la auditoria inicial de `OP_LEER` en `sdk-dependiente/jasboot-ir/src/vm.c`, como parte de la Fase 1 de contencion inmediata del plan de estabilidad de la VM.

## Archivos Auditados

- `sdk-dependiente/jasboot-ir/src/vm.c`

## Ubicaciones Relevantes

- Implementacion principal de `OP_LEER`: [vm.c:L3010-L3061](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3010-L3061)
- Implementacion rapida de `OP_LEER`: [vm.c:L8479-L8498](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8479-L8498)
- Manejador `try/catch` del runtime: [vm_try_catch_or_abort](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L2884-L2897)
- Lectura indirecta de 32 bits con `memcpy`: [vm.c:L6044-L6054](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L6044-L6054)

## Resumen Ejecutivo

La auditoria confirma que `OP_LEER` ya tiene protecciones utiles, pero todavia presenta huecos importantes de estabilidad.

Resultado general:

- La ruta principal tiene mejores mensajes y contencion que la ruta rapida.
- Existen dos implementaciones distintas de `OP_LEER` con comportamiento no equivalente.
- Hay al menos un riesgo critico de validacion por overflow aritmetico.
- La lectura final sigue haciendose con cast directo a `uint64_t*`, lo que no es la opcion mas robusta.

## Lo que ya esta bien

### 1. Resolucion de direccion razonable

La implementacion principal resuelve:

- direccion inmediata por `operand_b`;
- extension de 16 bits con `operand_c`;
- direccion desde registro `b_val`;
- direccionamiento relativo a `fp`.

Esto esta en [vm.c:L3011-L3024](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3011-L3024).

### 2. Hay una primera barrera de contencion

La ruta principal ya intenta clasificar el fallo como:

- acceso cercano a nulo;
- hash de texto usado como puntero;
- direccion fuera de limites.

Esto esta en [vm.c:L3026-L3053](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3026-L3053).

### 3. Existe integracion con `try/catch`

Si hay un bloque `intentar`, la ruta principal intenta redirigir el fallo con `vm_try_catch_or_abort()` en [vm.c:L3048-L3052](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3048-L3052).

Esto es mejor que abortar siempre el proceso.

## Hallazgos

### `OPLEER-A01` - Hay dos implementaciones de `OP_LEER` no equivalentes

- **Severidad:** alta
- **Ubicaciones:** [vm.c:L3010-L3061](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3010-L3061) y [vm.c:L8479-L8498](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8479-L8498)

La ruta principal:

- intenta clasificar el error;
- usa `vm_try_catch_or_abort()`;
- setea `exit_code = 1`.

La ruta rapida:

- solo imprime fuera de limites;
- no usa `vm_try_catch_or_abort()`;
- setea `exit_code = 11`;
- no detecta cercania a nulo ni confusion texto/puntero.

**Riesgo:** el mismo bug puede producir distinto comportamiento segun la ruta de ejecucion activa.

**Accion recomendada:** unificar la logica de validacion y error en una sola rutina compartida.

### `OPLEER-A02` - La validacion `addr + 8 > memory_size` es vulnerable a overflow

- **Severidad:** critica
- **Ubicaciones:** [vm.c:L3028-L3053](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3028-L3053) y [vm.c:L8485-L8495](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8485-L8495)

La condicion actual depende de:

```c
if (addr + 8 > vm->memory_size)
```

Como `addr` es `uint64_t`, si viene con un valor muy alto, `addr + 8` puede desbordar y volver a un numero pequeno. En ese caso, la validacion puede pasar por error.

**Riesgo:** lectura fuera de rango no contenida.

**Accion recomendada:** reemplazar por una forma segura, por ejemplo:

```c
if (addr > vm->memory_size || vm->memory_size - addr < 8)
```

con cuidado extra para no restar si `addr > vm->memory_size`.

### `OPLEER-A03` - El sentinel `0xFFFFFFFFFFFFFFFFULL` evita la guardia pero no evita la lectura

- **Severidad:** critica
- **Ubicacion:** [vm.c:L3028-L3056](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3028-L3056)

La guardia de la ruta principal excluye explicitamente:

```c
addr != 0xFFFFFFFFFFFFFFFFULL
```

Eso significa que para ese valor la comprobacion no entra, pero luego la VM igual ejecuta:

```c
uint64_t value = *(uint64_t*)(vm->memory + addr);
```

No se observa en `vm.c` otra proteccion local que vuelva seguro ese caso.

**Riesgo:** acceso totalmente invalido si ese sentinel aparece como direccion efectiva.

**Accion recomendada:** eliminar la excepcion o convertir ese valor en error controlado explicito antes de cualquier lectura.

### `OPLEER-A04` - La lectura usa cast directo a puntero

- **Severidad:** media-alta
- **Ubicaciones:** [vm.c:L3055-L3057](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3055-L3057) y [vm.c:L8485-L8488](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8485-L8488)

La lectura actual usa:

```c
*(uint64_t*)(vm->memory + addr)
```

Esto asume alineacion suficiente y aliasing seguro. En varias arquitecturas suele funcionar, pero no es la via mas robusta.

Hay un ejemplo mas seguro en `OP_LEER_U32_IND`, que usa `memcpy` en [vm.c:L6044-L6054](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L6044-L6054).

**Riesgo:** comportamiento dependiente de arquitectura o UB sutil.

**Accion recomendada:** migrar la lectura de 64 bits a `memcpy`.

### `OPLEER-A05` - Falta diagnostico minimo uniforme

- **Severidad:** media
- **Ubicaciones:** [vm.c:L3029-L3052](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L3029-L3052) y [vm.c:L8490-L8494](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8490-L8494)

Hoy falta incluir de forma uniforme:

- `pc`;
- registro origen;
- si la direccion vino de inmediato o de registro;
- `fp` cuando aplica `RELATIVE`;
- linea fuente si esta disponible;
- ruta de ejecucion usada.

**Riesgo:** depuracion lenta y fixes parciales.

**Accion recomendada:** crear una plantilla unica de error para accesos invalidos.

### `OPLEER-A06` - La ruta rapida no respeta la estrategia de contencion del runtime

- **Severidad:** alta
- **Ubicacion:** [vm.c:L8479-L8498](file:///c:/src/jasboot/sdk-dependiente/jasboot-ir/src/vm.c#L8479-L8498)

La ruta rapida devuelve error directo y no intenta pasar por `try/catch`, a diferencia de la ruta principal.

**Riesgo:** semantica inconsistente entre modos de ejecucion.

**Accion recomendada:** centralizar `OP_LEER` en helper comun y reutilizarlo en ambas rutas.

## Conclusiones

La auditoria de `OP_LEER` permite marcar la tarea como realizada, pero no como resuelta.

Estado real:

- **Auditado:** si
- **Contenida la causa raiz:** no
- **Lista para marcar como estable:** no

## Acciones Inmediatas Recomendadas

1. Extraer la validacion de direccion y lectura a una funcion comun.
2. Eliminar el bypass del sentinel `0xFFFFFFFFFFFFFFFFULL`.
3. Reemplazar `addr + 8 > memory_size` por una comprobacion segura sin overflow.
4. Sustituir la lectura por cast directo por `memcpy`.
5. Hacer que la ruta rapida use la misma politica de errores que la ruta principal.
6. Agregar tests de regresion para:
   - direccion cercana a nulo;
   - direccion alta con overflow;
   - hash de texto usado como puntero;
   - sentinel invalido;
   - acceso relativo con `fp` corrupto.

## Estado del Checklist

La tarea `Auditar vm.c alrededor de OP_LEER` puede marcarse como completada con hallazgos abiertos.
