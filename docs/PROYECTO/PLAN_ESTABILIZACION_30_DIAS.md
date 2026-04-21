# Plan de Estabilización de 30 Días

Plan operativo para endurecer Jasboot en cuatro semanas, con foco en seguridad de memoria, coherencia semántica y capacidad de release.

## Objetivo

Pasar de una beta funcional pero frágil a una beta endurecida con:

- VM con validaciones de memoria consistentes
- Contratos del lenguaje congelados para built-ins críticos
- Suite mínima de regresión obligatoria
- Documentación técnica alineada con el estado real del código

## Alcance

Incluye:

- `sdk-dependiente/jasboot-ir`
- `sdk-dependiente/jas-compiler-c`
- `sdk-dependiente/jasboot-jmn-core`
- `tests/`
- `docs/`

No incluye en esta fase:

- nuevas features del lenguaje
- ampliación de stdlib
- nuevas apps demo
- optimizaciones de rendimiento no relacionadas con seguridad o estabilidad

## Semana 1: Blindaje de VM

### Objetivo

Eliminar patrones inseguros de acceso a memoria y centralizar la validación.

### Tareas

- Reemplazar checks de la forma `addr + size > limit` por validaciones sin overflow.
- Introducir wrappers únicos para:
  - lectura segura `u64`
  - escritura segura `u64`
  - lectura segura `u32`
  - escritura segura `u32`
  - lectura segura `float`
  - escritura segura `float`
- Sustituir accesos directos a `vm->memory` donde hoy se escribe o lee sin wrapper.
- Auditar opcodes con direccionamiento relativo al `fp`.
- Agregar pruebas negativas de:
  - acceso cerca de `NULL`
  - desbordamiento de offset
  - lectura fuera de límites
  - escritura fuera de límites
  - puntero de texto usado como puntero de objeto

### Criterio de salida

- No quedan validaciones vulnerables a overflow en rutas activas de VM.
- Toda lectura/escritura escalar de memoria pasa por wrappers comunes o helpers equivalentes.
- Existe una suite mínima de tests de memoria que falla antes del fix y pasa después.

## Semana 2: Congelar contratos del lenguaje

### Objetivo

Eliminar deriva entre semántica real, tests y documentación.

### Tareas

- Definir catálogo oficial de built-ins:
  - nombre
  - aridad
  - tipo de retorno
  - semántica esperada
  - estado: estable, beta o experimental
- Resolver inconsistencia entre:
  - `buscar`
  - `buscar_introspectiva`
  - `buscar_en_memoria`
- Corregir tests que hoy asumen una semántica distinta a la implementada.
- Añadir tests de contrato por built-in crítico.
- Alinear ejemplos y documentación que hoy mezclan APIs estables con APIs en transición.

### Criterio de salida

- Cada built-in crítico tiene un contrato escrito y un test asociado.
- No hay tests oficiales que dependan de semántica no documentada.
- La API pública de búsqueda queda definida y consistente.

## Semana 3: Refactor estructural

### Objetivo

Reducir riesgo de regresión y mejorar mantenibilidad del núcleo.

### Tareas

- Partir `sdk-dependiente/jasboot-ir/src/vm.c` por dominios:
  - memoria
  - texto
  - JMN
  - colecciones
  - red / TLS
  - dispatch / ejecución
- Partir `sdk-dependiente/jas-compiler-c/src/parser.c` por dominios:
  - expresiones
  - sentencias
  - módulos
  - funciones
  - clases
- Sustituir buffers estáticos peligrosos en JMN por salida gestionada por caller o buffers explícitos.
- Aislar código legacy, experimental o transicional.

### Criterio de salida

- `vm.c` y `parser.c` dejan de ser archivos monolíticos principales.
- Las interfaces nuevas compilan y mantienen comportamiento existente.
- La complejidad ciclomática visible del núcleo disminuye.

## Semana 4: Release Engineering

### Objetivo

Dejar una beta endurecida reproducible y verificable.

### Tareas

- Crear suite corta obligatoria de release:
  - smoke
  - regression
  - memory-safety
  - persistence
- Definir qué tests son gate de release y cuáles son experimentales.
- Limpiar artefactos generados del árbol principal.
- Corregir documentación contradictoria u obsoleta.
- Publicar checklist de salida de release interna.

### Criterio de salida

- Existe una secuencia de verificación corta y repetible antes de release.
- La documentación principal refleja el estado actual del toolchain.
- El árbol principal no contiene residuos que rompan tooling básico.

## Riesgos del plan

- Refactor demasiado agresivo en VM puede introducir regresiones si se mezcla con cambios semánticos.
- Cambiar contratos de built-ins sin tabla oficial puede romper tests y apps.
- Limpiar repo sin clasificar artefactos puede eliminar insumos útiles de benchmarking o distribución.

## Reglas de ejecución

- No introducir features nuevas durante estas cuatro semanas.
- Todo bug histórico corregido debe dejar test de regresión.
- No fusionar refactors grandes sin pasar la suite corta obligatoria.
- Priorizar seguridad y coherencia semántica por encima de rendimiento.

## Resultado esperado al día 30

- VM más segura y predecible
- Semántica pública más clara
- Menor deuda estructural en núcleo
- Base más confiable para continuar expandiendo lenguaje, stdlib y apps
