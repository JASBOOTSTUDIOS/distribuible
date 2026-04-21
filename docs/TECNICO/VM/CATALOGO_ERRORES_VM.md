# Catalogo de Errores de la VM

## Objetivo

Este catalogo centraliza los errores mas importantes de la VM de Jasboot, sus sintomas, causas probables, impacto y accion recomendada.

Su objetivo es servir como base para:

- endurecimiento del runtime;
- mensajes consistentes del motor de ejecucion;
- priorizacion de bugs;
- conversion de fallos reales en regression tests;
- definicion de criterios de release.

## Alcance

Este documento cubre errores de:

- VM IR;
- carga y validacion de `.jbo`;
- memoria y acceso a runtime;
- objetos, clases, layouts y campos;
- listas y mapas;
- JMN y su integracion con la VM;
- errores de diagnostico y estabilidad general.

## Severidades

| Severidad | Significado |
|-----------|-------------|
| `S0` | Corrupcion critica: crash nativo, violacion de acceso, posible daño de estado interno |
| `S1` | Error grave controlado: la VM aborta la ejecucion actual pero sin crash del proceso |
| `S2` | Error funcional: resultado incorrecto, comportamiento ambiguo o inconsistente |
| `S3` | Error de diagnostico: mensaje pobre, falta de contexto o trazas insuficientes |

## Estados Deseados

Todo error de este catalogo deberia terminar en uno de estos estados:

- `Detectado`
- `Reproducido`
- `Con regression test`
- `Mitigado`
- `Corregido`
- `Documentado`

## 1. Errores de Memoria y Acceso

### `VM_MEM_001` - Violacion de acceso en `OP_LEER`

- **Severidad:** `S0`
- **Sintoma:** mensajes como `Violacion de acceso en OP_LEER: direccion ... fuera de limites`.
- **Causa probable:** direccion corrupta, objeto no inicializado, offset invalido, confusion entre id y puntero, o lectura fuera del heap/rango permitido.
- **Impacto:** crash de la VM o aborto inmediato de la ejecucion.
- **Deteccion:** trazas del runtime, casos como `aurora_ia`, stress de objetos y campos.
- **Accion recomendada:** validar rango, region, tipo y metadata antes de leer; registrar opcode, pc, direccion, registro y tipo real.
- **Estado objetivo:** convertir siempre a error controlado y test de regresion.

### `VM_MEM_002` - Violacion de acceso en `OP_ESCRIBIR`

- **Severidad:** `S0`
- **Sintoma:** mensajes como `Violacion de acceso en OP_ESCRIBIR: direccion ... fuera de limites`.
- **Causa probable:** escritura en direccion invalida, objeto no inicializado, layout corrupto o confusion de contexto.
- **Impacto:** corrupcion de memoria o crash nativo.
- **Deteccion:** tests de asignacion a campos, listas, reservas de heap y objetos anidados.
- **Accion recomendada:** verificar direccion, ownership, layout y tag de destino antes de escribir.
- **Estado objetivo:** error controlado, nunca acceso nativo fuera de rango.

### `VM_MEM_003` - Acceso cercano a nulo

- **Severidad:** `S0`
- **Sintoma:** error de lectura o escritura en direccion muy baja o cercana a `0x00000000`.
- **Causa probable:** objeto no inicializado, `este`/`padre` invalido o campo accedido sobre valor nulo.
- **Impacto:** crash inmediato o corrupcion de contexto.
- **Deteccion:** tests de objetos sin inicializar y acceso a miembros.
- **Accion recomendada:** chequeo explicito de nulo antes de cualquier acceso estructural.

### `VM_MEM_004` - Heap overflow o reserva fuera de limite

- **Severidad:** `S0`
- **Sintoma:** mensajes de heap overflow o memoria insuficiente.
- **Causa probable:** reserva no validada, calculo incorrecto de tamaño, crecimiento sin limite o tamano corrupto.
- **Impacto:** corrupcion del heap o aborto del programa.
- **Deteccion:** tests masivos de reserva, listas, textos y estructuras.
- **Accion recomendada:** validar overflow aritmetico y limites antes de reservar.

### `VM_MEM_005` - Uso despues de liberar

- **Severidad:** `S0`
- **Sintoma:** comportamiento no determinista, crash aleatorio o lectura de basura.
- **Causa probable:** objeto o coleccion liberada cuya referencia sigue viva.
- **Impacto:** uno de los fallos mas peligrosos del runtime.
- **Deteccion:** sanitizers, soak tests, fuzzing y stress prolongado.
- **Accion recomendada:** poisoning en debug, invalidacion de ids y validacion estricta de headers.

## 2. Errores de Tipos y Conversion

### `VM_TYPE_001` - Confusion entre id interno y texto

- **Severidad:** `S1`
- **Sintoma:** se intenta usar un id de runtime o de JMN como si fuera `texto`.
- **Causa probable:** contrato de retorno ambiguo, conversion implicita insegura o falta de validacion de tag.
- **Impacto:** puede terminar en mensajes incorrectos o en violacion de acceso si ese id se interpreta como direccion.
- **Deteccion:** busquedas JMN, `resultado`, concatenaciones y funciones de texto.
- **Accion recomendada:** helpers seguros de conversion y chequeo obligatorio de tipo.

### `VM_TYPE_002` - Ambiguedad entre `nulo`, `0` y `""`

- **Severidad:** `S1`
- **Sintoma:** condiciones o comparaciones que se comportan de forma incoherente.
- **Causa probable:** representacion interna poco diferenciada o convenciones inconsistentes entre capas.
- **Impacto:** bugs funcionales, rutas equivocadas o errores de acceso posteriores.
- **Deteccion:** tests de igualdad, comparacion y flujos con `resultado`.
- **Accion recomendada:** definir semantica interna explicita y tests por tipo.

### `VM_TYPE_003` - `resultado` usado con tipo incorrecto

- **Severidad:** `S1`
- **Sintoma:** el programa toma `resultado` como texto, pero la operacion previa devolvio otro tipo.
- **Causa probable:** contrato implicito no documentado o no validado por compilador/runtime.
- **Impacto:** errores de logica o crash en operaciones posteriores.
- **Deteccion:** flujos `buscar`, `buscar_asociados`, `propagar_activacion`, concatenacion y filtros de texto.
- **Accion recomendada:** documentar contrato de `resultado`, validar tipo y endurecer compilador cuando sea posible.

### `VM_TYPE_004` - Conversion insegura a texto

- **Severidad:** `S2`
- **Sintoma:** concatenaciones o impresiones inconsistentes con valores no textuales.
- **Causa probable:** conversion implicita permisiva o falta de helper seguro.
- **Impacto:** salidas ambiguas y errores funcionales.
- **Deteccion:** tests de `imprimir`, concatenacion y conversiones.
- **Accion recomendada:** centralizar conversion segura con tag checks.

## 3. Errores de Objetos, Clases y Layout

### `VM_OBJ_001` - Layout de objeto inconsistente

- **Severidad:** `S0`
- **Sintoma:** lectura o escritura de campos equivocados, o crash al acceder a miembros.
- **Causa probable:** desacople entre compilador y VM sobre offsets, orden de campos o herencia.
- **Impacto:** corrupcion de objetos y comportamiento no determinista.
- **Deteccion:** tests de clases, herencia y campos privados.
- **Accion recomendada:** metadata de layout verificable y validacion de header de instancia.

### `VM_OBJ_002` - Acceso a campo sobre objeto no inicializado

- **Severidad:** `S0`
- **Sintoma:** crash al usar `este.campo`, `padre.metodo()` o asignaciones a miembros.
- **Causa probable:** constructor incompleto, referencia nula o inicializacion parcial.
- **Impacto:** violacion de acceso o corrupcion de contexto.
- **Deteccion:** tests de clases anidadas, jerarquias profundas y caminos de excepcion.
- **Accion recomendada:** chequeos de nulo y estado de inicializacion antes del acceso.

### `VM_OBJ_003` - Herencia profunda con metadata invalida

- **Severidad:** `S1`
- **Sintoma:** fallos al resolver metodos, `padre` o polimorfismo en multiples niveles.
- **Causa probable:** tabla de clases o dispatch inconsistente.
- **Impacto:** llamada a metodo equivocado, lectura de campo incorrecta o crash.
- **Deteccion:** stress tests de polimorfismo y herencia profunda.
- **Accion recomendada:** validar tablas de dispatch y layouts antes de ejecutar.

## 4. Errores de Colecciones

### `VM_COL_001` - Indice fuera de rango en listas

- **Severidad:** `S1`
- **Sintoma:** `lista_obtener` o `lista_poner` con indice invalido.
- **Causa probable:** chequeo faltante o id de lista corrupto.
- **Impacto:** error funcional o acceso invalido de memoria.
- **Deteccion:** tests unitarios de colecciones y stress con miles de operaciones.
- **Accion recomendada:** validar id, tamaño e indice en cada operacion.

### `VM_COL_002` - Id de coleccion invalido o reutilizado

- **Severidad:** `S1`
- **Sintoma:** lista o mapa apunta a otra estructura o a memoria liberada.
- **Causa probable:** lifecycle mal gestionado o limpieza incompleta de metadata.
- **Impacto:** corrupcion silenciosa de datos o crash.
- **Deteccion:** soak tests, sanitizers y stress mixto.
- **Accion recomendada:** invalidar ids liberados y no reutilizarlos sin reinicializacion segura.

### `VM_COL_003` - Lista vacia confundida con error

- **Severidad:** `S2`
- **Sintoma:** la capa superior no distingue entre sin elementos, valor nulo o fallo.
- **Causa probable:** contrato de retorno ambiguo.
- **Impacto:** ramificaciones erradas en apps y stdlib.
- **Deteccion:** tests de borde sobre listas y asociaciones vacias.
- **Accion recomendada:** separar semantica de vacio, nulo y error.

## 5. Errores de JMN e Integracion

### `VM_JMN_001` - JMN devuelve id crudo donde se esperaba texto

- **Severidad:** `S1`
- **Sintoma:** la capa superior intenta hacer operaciones de texto sobre un id numerico.
- **Causa probable:** contrato no unificado entre JMN y VM/app.
- **Impacto:** errores funcionales o acceso invalido posterior.
- **Deteccion:** `buscar_asociados`, `asociados_de`, `propagar_activacion`, `resultado`.
- **Accion recomendada:** unificar contratos y agregar wrappers seguros.

### `VM_JMN_002` - Memoria neuronal no abierta o no consolidada

- **Severidad:** `S1`
- **Sintoma:** busquedas vacias, escritura fallida o perdida de datos al cerrar.
- **Causa probable:** no llamar `crear_memoria`, `consolidar_memoria` o `cerrar_memoria`.
- **Impacto:** perdida de persistencia y comportamiento inconsistente.
- **Deteccion:** tests de apertura/cierre/reapertura.
- **Accion recomendada:** ciclo de vida explicito y validado en runtime y wrappers.

### `VM_JMN_003` - Contrato ambiguo de retorno en operaciones JMN

- **Severidad:** `S2`
- **Sintoma:** la misma operacion puede devolver `0`, `nulo`, `""` o id, segun el caso.
- **Causa probable:** evolucion historica sin contrato unico.
- **Impacto:** codigo defensivo excesivo y bugs sutiles.
- **Deteccion:** tests especificos por operacion.
- **Accion recomendada:** especificacion formal de retornos y compatibilidad hacia atras controlada.

## 6. Errores de Carga y Validacion de IR

### `VM_IR_001` - Jump target out of bounds

- **Severidad:** `S1`
- **Sintoma:** salto invalido detectado por el lector o validador IR.
- **Causa probable:** codegen defectuoso, binario corrupto o metadata inconsistente.
- **Impacto:** el programa no debe ejecutarse.
- **Deteccion:** `reader_ir.c`, `ir_validator.c`.
- **Accion recomendada:** bloquear carga y reportar origen exacto.

### `VM_IR_002` - Immediate read/write out of bounds

- **Severidad:** `S1`
- **Sintoma:** direccion inmediata fuera de rango detectada antes de ejecutar.
- **Causa probable:** generacion incorrecta de operandos o binario manipulado.
- **Impacto:** si no se detecta a tiempo, puede terminar en crash.
- **Deteccion:** validacion previa a ejecucion.
- **Accion recomendada:** rechazo temprano del `.jbo`.

### `VM_IR_003` - Opcode invalido o no implementado

- **Severidad:** `S1`
- **Sintoma:** instruccion desconocida en runtime o validacion.
- **Causa probable:** binario corrupto, version incompatible o tabla de opcodes incompleta.
- **Impacto:** ejecucion abortada.
- **Deteccion:** validador y dispatch de la VM.
- **Accion recomendada:** mensaje claro con opcode y version del IR.

## 7. Errores de Diagnostico

### `VM_DIAG_001` - Mensaje de error insuficiente

- **Severidad:** `S3`
- **Sintoma:** el runtime falla pero no informa opcode, pc, tipos ni origen.
- **Causa probable:** manejo de error incompleto.
- **Impacto:** baja velocidad de depuracion y fixes frágiles.
- **Deteccion:** revision de mensajes y reportes de crash.
- **Accion recomendada:** plantilla unica de diagnostico minimo.

### `VM_DIAG_002` - Error correcto, causa raiz equivocada

- **Severidad:** `S3`
- **Sintoma:** se reporta un mensaje engañoso que oculta el problema real.
- **Causa probable:** clasificacion pobre del fallo o falta de metadata.
- **Impacto:** tiempo perdido y regresiones.
- **Deteccion:** contraste entre traza, core logic y caso reproducible.
- **Accion recomendada:** enriquecer contexto y separar errores por categoria real.

## 8. Errores de Estabilidad General

### `VM_STAB_001` - Crash reproducible sin contencion

- **Severidad:** `S0`
- **Sintoma:** un programa de usuario tumba la VM de forma nativa.
- **Causa probable:** ausencia de guardas o validaciones en un camino critico.
- **Impacto:** la VM no puede considerarse estable.
- **Deteccion:** cualquier crash confirmado por suite o app real.
- **Accion recomendada:** convertir el caso en regression test antes de cerrar el bug.

### `VM_STAB_002` - Comportamiento no determinista

- **Severidad:** `S1`
- **Sintoma:** el mismo programa produce resultados distintos en corridas equivalentes.
- **Causa probable:** memoria corrupta, estado global compartido o inicializacion parcial.
- **Impacto:** perdida de confianza en el runtime.
- **Deteccion:** corridas repetidas, soak tests y fuzzing.
- **Accion recomendada:** capturar seed, estado y traza reproducible.

## Tabla de Priorizacion Inicial

| Id | Prioridad | Motivo |
|----|-----------|--------|
| `VM_MEM_001` | `P0` | Es el patron mas critico observado en ejecucion real |
| `VM_MEM_002` | `P0` | Puede corromper memoria y romper objetos |
| `VM_OBJ_001` | `P0` | Afecta clases, herencia y campos |
| `VM_JMN_001` | `P0` | Impacta flujos reales de apps como `aurora_ia` |
| `VM_TYPE_003` | `P1` | `resultado` es un punto de fragilidad transversal |
| `VM_COL_001` | `P1` | Las colecciones son base de stdlib y apps |
| `VM_IR_001` | `P1` | El validador debe contener estos fallos antes de ejecutar |
| `VM_DIAG_001` | `P2` | No rompe solo, pero dificulta resolver todo lo demas |

## Uso Recomendado

Por cada bug nuevo:

1. asignar un id del catalogo o crear uno nuevo;
2. guardar caso minimo reproducible;
3. clasificar severidad;
4. registrar modulo afectado;
5. crear regression test;
6. documentar fix y estado.

## Relacion con Otros Documentos

- Plan de endurecimiento: `docs/TECNICO/VM/CHECKLIST_ESTABILIDAD_VM.md`
- VM estable actual: `docs/TECNICO/VM/VM_ESTABLE.md`
- Catalogo general del proyecto: `docs/PROYECTO/CATALOGO_ERRORES_V1.0.md`

## Resultado Esperado

Con este catalogo, la VM gana:

- lenguaje comun para clasificar fallos;
- base para regression tests;
- prioridad clara de endurecimiento;
- criterio uniforme para documentar bugs y releases.
