# Tickets P0 de Estabilización

Tickets iniciales para ejecutar el trabajo de endurecimiento del núcleo. Están redactados para poder asignarse sin reinterpretación adicional.

## TICKET P0-01

### Título

Eliminar validaciones de memoria vulnerables a overflow en la VM

### Área

VM

### Archivos foco

- `sdk-dependiente/jasboot-ir/src/vm.c`

### Problema

Existen validaciones de rango de la forma `addr + size > vm->memory_size`, que pueden desbordar antes de comparar y permitir falsos negativos.

### Evidencia inicial

- helpers de lectura/escritura flotante
- rutas de `OP_LEER`
- rutas de `OP_ESCRIBIR`
- otras escrituras directas validadas con suma

### Trabajo esperado

- Reemplazar todas las validaciones vulnerables por checks sin overflow.
- Revisar tanto rutas principales como rutas secundarias o legacy.
- No introducir cambios semánticos fuera de seguridad de memoria.

### Criterio de aceptación

- No quedan checks activos `addr + size > limit` en rutas de ejecución reales.
- El código compila sin errores.
- Los tests negativos de rango pasan.

### Riesgo

Crítico

## TICKET P0-02

### Título

Centralizar lectura y escritura segura de memoria escalar en la VM

### Área

VM

### Archivos foco

- `sdk-dependiente/jasboot-ir/src/vm.c`
- `sdk-dependiente/jasboot-ir/src/vm.h`

### Problema

Hay múltiples puntos de acceso directo a `vm->memory`, lo que duplica validación y facilita inconsistencias.

### Trabajo esperado

- Crear helpers comunes para:
  - `u64`
  - `u32`
  - `float`
- Sustituir dereferencias directas activas por esos helpers.
- Mantener mensajes de error útiles cuando aplique.

### Criterio de aceptación

- Las rutas activas de acceso escalar usan helpers compartidos.
- El comportamiento observable no cambia salvo el endurecimiento esperado.
- El código queda más fácil de auditar.

### Riesgo

Crítico

## TICKET P0-03

### Título

Congelar semántica de `buscar` y separar formalmente búsqueda introspectiva

### Área

Lenguaje / Compilador / VM / Tests

### Archivos foco

- `sdk-dependiente/jas-compiler-c/src/codegen.c`
- `sdk-dependiente/jasboot-ir/src/vm.c`
- `tests/test_busqueda_introspectiva.jasb`
- documentación relacionada

### Problema

Hay deriva entre la semántica implementada de `buscar` y el uso que hacen algunos tests y documentos al tratarlo como búsqueda textual global.

### Trabajo esperado

- Decidir y documentar la semántica oficial de `buscar`.
- Corregir tests oficiales para usar la API correcta.
- Dejar documentada la familia:
  - `buscar`
  - `buscar_introspectiva`
  - aliases existentes, si se conservan

### Criterio de aceptación

- Los tests oficiales ya no dependen de una semántica incorrecta.
- El contrato de búsqueda queda explícito en docs.
- El runtime y el compilador implementan el mismo contrato.

### Riesgo

Crítico

## TICKET P0-04

### Título

Crear suite mínima obligatoria de release para VM, persistencia y regresión

### Área

Calidad / Release

### Archivos foco

- `tests/`
- scripts de ejecución
- documentación de QA/release

### Problema

Hay muchos tests, pero no una suite corta y confiable que funcione como gate duro antes de release.

### Trabajo esperado

- Definir una suite mínima dividida en:
  - `smoke`
  - `regression`
  - `memory-safety`
  - `persistence`
- Documentar cómo ejecutarla.
- Elegir casos representativos y mantenibles.

### Criterio de aceptación

- Existe una lista explícita de tests gate.
- La suite se puede correr de forma repetible.
- La release beta endurecida depende de su resultado.

### Riesgo

Crítico

## TICKET P0-05

### Título

Corregir documentación contradictoria sobre la pila estable del proyecto

### Área

Documentación

### Archivos foco

- `docs/TECNICO/VM/VM_ESTABLE.md`
- `docs/PROYECTO/ESTADO_PROYECTO_ACTUAL.md`

### Problema

La documentación principal mezcla referencias históricas al compilador Python con la pila actual basada en `jbc`.

### Trabajo esperado

- Dejar una sola descripción vigente de la pila estable.
- Marcar cualquier referencia histórica como histórica, no vigente.
- Confirmar que docs, scripts y flujo real coinciden.

### Criterio de aceptación

- La documentación principal no contiene contradicciones sobre el toolchain estable.
- Un lector nuevo entiende cuál es la pila soportada hoy.

### Riesgo

Alta

## TICKET P0-06

### Título

Agregar pruebas negativas específicas para corrupción de contexto en VM

### Área

VM / Tests

### Archivos foco

- `tests/`
- posibles nuevos casos `.jasb`

### Problema

Hay mensajes y protecciones para usar hashes de texto como punteros u objetos no inicializados, pero falta endurecerlos con regresiones explícitas.

### Trabajo esperado

- Crear casos que reproduzcan:
  - objeto no inicializado
  - miembro sobre valor no objeto
  - puntero cercano a `NULL`
  - lectura/escritura fuera de rango
- Verificar que el error es claro y controlado.

### Criterio de aceptación

- Existen casos de regresión ejecutables para los errores críticos de memoria/contexto.
- La VM no cae en fallo nativo silencioso en esos casos.

### Riesgo

Crítico

## Orden sugerido de ejecución

1. `P0-01`
2. `P0-02`
3. `P0-06`
4. `P0-03`
5. `P0-04`
6. `P0-05`

## Nota de ejecución

Durante la etapa P0 no se deben aceptar features nuevas en VM, parser ni built-ins, salvo cambios estrictamente necesarios para cerrar contradicciones semánticas ya existentes.
