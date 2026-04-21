# Checklist de Estabilidad de la VM

## Objetivo

Este documento define que significa endurecer la VM de Jasboot, como reducir los fallos nativos y como validar la estabilidad del runtime con un criterio tecnico repetible.

Catalogo complementario: `docs/TECNICO/VM/CATALOGO_ERRORES_VM.md`

La meta no es "que la app no falle a veces", sino que la VM:

- nunca haga lecturas o escrituras fuera de rango;
- nunca se caiga por un programa de usuario, aunque el programa sea invalido;
- siempre degrade a error de runtime controlado con contexto util;
- tenga una suite de regresion y stress que convierta cada bug real en una prueba permanente.

## Principios

- La VM debe fallar de forma segura.
- El compilador debe rechazar lo que pueda detectar antes de ejecutar.
- El runtime debe validar lo que todavia pueda salir mal en ejecucion.
- JMN, objetos, listas, mapas y registros deben tener invariantes verificables.
- Toda caida nativa debe convertirse en un test reproducible.

## Riesgos Principales

### 1. Acceso invalido de memoria

Ejemplos:

- `OP_LEER` o `OP_ESCRIBIR` usando direcciones corruptas.
- acceso a campos de objeto con desplazamientos invalidos;
- indices fuera de rango en listas;
- ids de mapa o lista reutilizados o corruptos;
- uso de memoria liberada.

### 2. Confusion de tipos

Ejemplos:

- tratar un id interno como `texto`;
- comparar `nulo`, `0` y `""` como si fueran equivalentes;
- usar `resultado` como si siempre fuera string;
- concatenar texto con valores no validados.

### 3. Estados internos ambiguos

Ejemplos:

- objetos parcialmente inicializados;
- clases con layouts inconsistentes entre compilador y VM;
- herencia profunda sin verificacion del layout real;
- JMN devolviendo un tipo distinto al esperado por la app.

### 4. Errores de integracion entre capas

Capas criticas:

- compilador C;
- codegen IR;
- VM IR;
- JMN core;
- librerias stdlib y apps de integracion como `aurora_ia`.

## Objetivos Tecnicos

- convertir fallos nativos en errores manejados;
- endurecer opcodes criticos con verificaciones explicitas;
- validar tipos y layouts antes de leer memoria;
- instrumentar el runtime para tener trazas diagnosticas;
- ejecutar tests unitarios, de integracion, stress, fuzzing y soak;
- definir un gate de release de estabilidad.

## Areas Prioritarias

### Runtime

- `sdk-dependiente/jasboot-ir/src/vm.c`
- `sdk-dependiente/jasboot-ir/src/ir_vm.c`
- `sdk-dependiente/jasboot-ir/src/reader_ir.c`
- `sdk-dependiente/jasboot-ir/src/ir_validator.c`

### Compilador / Codegen

- `sdk-dependiente/jas-compiler-c/src/codegen.c`
- validacion semantica y contratos de tipos;
- emision correcta de metadata para objetos, campos y layouts.

### JMN Core

- `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal_utilidades.c`
- operaciones de listas;
- asociaciones;
- ids de nodos;
- conversion de valores y resultados magicos.

## Endurecimiento del Runtime

### 1. Blindaje de `OP_LEER` y `OP_ESCRIBIR`

Para cada lectura y escritura:

- validar rango antes de tocar memoria;
- validar si la direccion apunta a una region permitida;
- validar tipo del dato esperado;
- registrar opcode, direccion, registro, frame y origen fuente cuando falle;
- retornar error de runtime controlado en vez de abortar el proceso.

### 2. Layout de objetos y clases

- validar que toda instancia tenga header valido;
- validar que el id de clase exista;
- validar el numero de campos antes de acceder por offset;
- verificar consistencia entre herencia compilada y layout cargado;
- rechazar acceso a `padre`, `este` o campos privados si la metadata no coincide.

### 3. Colecciones

- validar `lista_tamano`, `lista_obtener` y `lista_poner` contra indices negativos o fuera de rango;
- validar ids de coleccion antes de operar;
- no reutilizar ids sin limpiar metadata;
- distinguir claramente lista vacia, id invalido y valor nulo.

### 4. Tipos y conversiones

- hacer obligatoria la validacion de tag de tipo en operaciones sensibles;
- impedir que `resultado` se use como texto sin chequeo;
- diferenciar internamente `0`, `nulo`, `""` e id de objeto;
- agregar helpers seguros para conversion a texto.

### 5. Trazas y diagnostico

Todo error critico debe incluir:

- opcode;
- pc actual;
- registros implicados;
- tipo esperado y tipo real;
- direccion o id accedido;
- funcion y archivo origen si hay metadata disponible.

## Estrategia de Pruebas

### 1. Tests unitarios del runtime

Crear casos directos por opcode:

- lecturas validas;
- lecturas fuera de rango;
- escrituras invalidas;
- acceso a registros limite;
- tipos invalidos;
- operandos inmediatos extremos.

### 2. Tests de integracion del lenguaje

Cubrir:

- clases;
- herencia multiple por niveles;
- polimorfismo;
- campos privados;
- listas y mapas;
- JMN;
- modulos;
- excepciones;
- conversiones y concatenaciones.

### 3. Regression tests

Cada crash real debe producir:

- un caso minimo reproducible;
- un test fijo en la suite;
- una nota del bug original;
- validacion para que no reaparezca.

### 4. Stress tests

Ejecutar:

- millones de iteraciones simples;
- objetos anidados profundos;
- herencia y polimorfismo con multiples niveles;
- aperturas y cierres repetidos de JMN;
- uso intensivo de listas y mapas;
- combinaciones grandes de entradas de usuario.

### 5. Fuzzing

Generar programas Jasboot aleatorios o semi-aleatorios para:

- parser;
- semantica;
- codegen;
- carga de IR;
- ejecucion en VM.

### 6. Soak tests

Ejecutar durante horas:

- programas largos;
- ciclos de carga y descarga de memoria;
- operaciones repetidas con JMN;
- escenarios mixtos que combinen objetos, listas y texto.

## Criterio de Release

La VM no debe considerarse estable para produccion hasta cumplir como minimo:

- cero crashes nativos en la suite oficial;
- cero errores de sanitizer;
- cero lecturas/escrituras fuera de rango detectadas;
- cero use-after-free;
- todos los bugs historicos convertidos en regression tests;
- soak test estable durante multiples horas;
- resultados deterministas en corridas repetidas.

## Checklist de Ejecucion

### Fase 1. Contencion inmediata

- [x] Auditar `vm.c` alrededor de `OP_LEER`.
- Nota: ver `docs/TECNICO/VM/AUDITORIA_OP_LEER_VM.md`. Hallazgos criticos: overflow en validacion `addr + 8`, bypass del sentinel `0xFFFFFFFFFFFFFFFFULL`, divergencia entre ruta principal y ruta rapida, y lectura por cast directo.
- [x] Auditar `vm.c` alrededor de `OP_ESCRIBIR`.
- Nota: ver `docs/TECNICO/VM/AUDITORIA_OP_ESCRIBIR_VM.md`. Hallazgos criticos: 3 implementaciones no equivalentes, overflow en validacion, bypass del sentinel, escritura por cast directo, y ruta rapida dispatch sin validacion alguna. Soluciones implementadas con `vm_escribir_seguro()`.
- [ ] Agregar validaciones de rango en todas las lecturas/escrituras criticas.
- [ ] Convertir abortos y violaciones en errores de runtime controlados.
- [ ] Registrar contexto minimo de fallo: opcode, pc, direccion, registro y tipo.

### Fase 2. Tipos e invariantes

- [ ] Definir representacion interna explicita para `nulo`, `0`, `""`, ids y objetos.
- [ ] Revisar el manejo del simbolo magico `resultado`.
- [ ] Agregar chequeos de tipo antes de operaciones de texto.
- [ ] Validar layouts de objetos y campos antes de acceder.
- [ ] Validar ids de listas, mapas y nodos JMN.

### Fase 3. Endurecimiento de JMN

- [ ] Auditar `buscar`, `buscar_asociados`, `asociados_de` y `propagar_activacion`.
- [ ] Verificar que JMN no devuelva ids crudos donde la capa superior espera texto.
- [ ] Unificar contrato de retorno para operaciones JMN.
- [ ] Agregar tests de asociaciones vacias, ids invalidos y nodos inexistentes.
- [ ] Revisar integridad de listas internas en JMN core.

### Fase 4. Suite de regresion

- [ ] Crear carpeta dedicada para crashes historicos reproducidos.
- [ ] Agregar un test minimo por cada bug real ya detectado.
- [ ] Incluir casos de `aurora_ia` como regresion oficial.
- [ ] Etiquetar cada test con el modulo afectado y la causa raiz.
- [ ] Ejecutar la suite en cada cambio del runtime.

### Fase 5. Stress y soak

- [ ] Crear stress tests para herencia profunda y polimorfismo.
- [ ] Crear stress tests para objetos anidados y campos privados.
- [ ] Crear stress tests para listas y mapas con miles de operaciones.
- [ ] Crear stress tests para JMN con busquedas y asociaciones repetidas.
- [ ] Ejecutar soak tests largos y registrar memoria, errores y tiempos.

### Fase 6. Tooling de validacion

- [ ] Compilar la VM con AddressSanitizer en modo debug.
- [ ] Compilar la VM con UndefinedBehaviorSanitizer.
- [ ] Crear build de diagnostico con asserts reforzados.
- [ ] Agregar script de ejecucion automatica de suite + sanitizers.
- [ ] Guardar reportes de crash y resumen de regresiones.

### Fase 7. Gate de release

- [ ] Definir una suite minima obligatoria para merge.
- [ ] Definir una suite extendida obligatoria para release.
- [ ] Exigir cero crashes nativos para etiquetar una version estable.
- [ ] Exigir reproduccion y cierre documental de cada bug critico.
- [ ] Publicar un estado de estabilidad por version de la VM.

## Orden Recomendado

1. Blindar `OP_LEER` y `OP_ESCRIBIR`.
2. Endurecer tipos y layouts de objetos.
3. Auditar JMN y contratos de retorno.
4. Convertir bugs reales en regression tests.
5. Incorporar stress, fuzzing y soak.
6. Establecer gate de release.

## Resultado Esperado

Si este checklist se ejecuta completo, la VM no sera "matematicamente perfecta", pero si alcanzara un nivel de estabilidad de ingenieria alto:

- sin violaciones de acceso conocidas;
- con errores de runtime trazables;
- con regresion automatizada para bugs historicos;
- con un proceso claro para aceptar o bloquear releases.
