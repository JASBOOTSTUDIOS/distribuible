# Backlog de Estabilización Priorizado

Backlog técnico derivado de la auditoría del proyecto. Ordenado por severidad y valor de reducción de riesgo.

## P0

### P0-01: Eliminar validaciones de memoria vulnerables a overflow en VM

Área: VM

Archivos foco:

- `sdk-dependiente/jasboot-ir/src/vm.c`

Problema:

- Existen checks del tipo `addr + size > vm->memory_size`, vulnerables a overflow aritmético en validación.

Evidencia:

- `sdk-dependiente/jasboot-ir/src/vm.c`

Criterio de aceptación:

- No quedan checks de rango del tipo `addr + size`.
- Todas las validaciones usan forma segura: `addr > limit || limit - addr < size`.
- Los tests negativos de rango pasan.

### P0-02: Centralizar lectura y escritura segura de memoria

Área: VM

Archivos foco:

- `sdk-dependiente/jasboot-ir/src/vm.c`
- `sdk-dependiente/jasboot-ir/src/vm.h`

Problema:

- Hay múltiples accesos directos a `vm->memory` con semántica duplicada y validación inconsistente.

Criterio de aceptación:

- Toda lectura/escritura escalar de memoria usa wrappers o helpers compartidos.
- Las rutas activas de `OP_LEER`, `OP_ESCRIBIR` y opcodes relacionados no hacen dereferencia directa sin validación.

### P0-03: Corregir incoherencia semántica entre `buscar` y búsqueda introspectiva

Área: Lenguaje / Compilador / VM

Archivos foco:

- `sdk-dependiente/jas-compiler-c/src/codegen.c`
- `sdk-dependiente/jasboot-ir/src/vm.c`
- `tests/test_busqueda_introspectiva.jasb`
- `docs/`

Problema:

- `buscar` opera como lookup exacto, mientras algunos tests lo usan como búsqueda global de texto.

Criterio de aceptación:

- El contrato de `buscar` queda explícito y estable.
- Las funciones de búsqueda introspectiva quedan diferenciadas y documentadas.
- Los tests oficiales usan la API correcta.

### P0-04: Crear suite mínima obligatoria de release

Área: Calidad / Release

Archivos foco:

- `tests/`
- scripts de ejecución de tests

Problema:

- Hay muchos tests, pero no una suite corta y confiable que actúe como gate duro.

Criterio de aceptación:

- Existe una suite corta clasificable como:
  - `smoke`
  - `regression`
  - `memory-safety`
  - `persistence`
- Su ejecución está documentada y es reproducible.

## P1

### P1-01: Partir `vm.c` por dominios

Área: VM / Mantenibilidad

Archivos foco:

- `sdk-dependiente/jasboot-ir/src/vm.c`

Problema:

- El archivo central de VM está sobredimensionado y mezcla múltiples subsistemas.

Criterio de aceptación:

- Se separan módulos por dominio.
- La compilación no pierde funcionalidad.
- La navegación del código mejora de forma evidente.

### P1-02: Partir `parser.c` por dominios

Área: Compilador / Mantenibilidad

Archivos foco:

- `sdk-dependiente/jas-compiler-c/src/parser.c`

Problema:

- Parser monolítico con demasiadas responsabilidades.

Criterio de aceptación:

- Expresiones, sentencias y módulos quedan separados o claramente aislados.
- Los diagnósticos existentes se preservan.

### P1-03: Definir catálogo oficial de built-ins

Área: Lenguaje / Documentación

Archivos foco:

- `docs/`
- `sdk-dependiente/jas-compiler-c/src/sistema_llamadas.c`
- `sdk-dependiente/jas-compiler-c/src/codegen.c`

Problema:

- La superficie pública del lenguaje es amplia, pero no toda está consolidada como contrato.

Criterio de aceptación:

- Existe una tabla oficial con aridad, retorno y estado de estabilidad por built-in.
- Tests y docs referencian la misma fuente de verdad.

### P1-04: Sustituir buffer estático en JMN para conexiones

Área: JMN / Seguridad de API

Archivos foco:

- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_conexiones.c`
- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal.h`

Problema:

- `jmn_obtener_conexiones` usa un buffer estático no reentrante.

Criterio de aceptación:

- La función deja de depender de almacenamiento estático global.
- La API define propiedad y ciclo de vida del buffer de salida.

### P1-05: Corregir documentación contradictoria del toolchain

Área: Documentación

Archivos foco:

- `docs/TECNICO/VM/VM_ESTABLE.md`
- `docs/PROYECTO/ESTADO_PROYECTO_ACTUAL.md`

Problema:

- Quedan referencias mezcladas a compilador Python y compilador C como pila estable.

Criterio de aceptación:

- La documentación principal describe una sola pila vigente.
- Las referencias obsoletas quedan corregidas o marcadas como históricas.

## P2

### P2-01: Parametrizar límites rígidos de listas y mapas en JMN

Área: JMN

Archivos foco:

- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_core.c`
- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_io.c`

Problema:

- Hay capacidades fijas de `10000` slots que simplifican la implementación pero limitan evolución.

Criterio de aceptación:

- Las capacidades se vuelven configurables o al menos centralizadas.
- La persistencia sigue siendo compatible con el formato vigente o documenta migración.

### P2-02: Limpiar artefactos y residuos del árbol principal

Área: Repo / Tooling

Archivos foco:

- raíz del repo
- `export/`
- binarios generados

Problema:

- Hay residuos y artefactos que complican búsquedas, scripts y mantenimiento.

Criterio de aceptación:

- El árbol principal deja de contener residuos que rompan tooling básico.
- `.gitignore` refleja mejor artefactos generados.

### P2-03: Clasificar tests por estabilidad

Área: Calidad

Archivos foco:

- `tests/`

Problema:

- Tests de distinto nivel conviven sin separación clara entre release y experimental.

Criterio de aceptación:

- Los tests quedan agrupados al menos en:
  - `smoke`
  - `regression`
  - `stress`
  - `experimental`

## Dependencias sugeridas

- `P0-01` antes de `P1-01`
- `P0-02` antes de `P1-01`
- `P0-03` antes de `P1-03`
- `P0-04` antes de refactors grandes
- `P1-05` puede ejecutarse en paralelo con `P1-03`

## Definición de terminado

Un ítem del backlog se considera cerrado cuando:

- el cambio compila
- existe prueba o validación suficiente
- el contrato resultante quedó documentado si afecta API pública
- no introduce nueva contradicción con docs o tests oficiales
