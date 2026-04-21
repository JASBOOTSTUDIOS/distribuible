# Checklist de Release Beta Endurecida

Checklist operativo para validar una release interna de Jasboot centrada en estabilidad del núcleo.

## Objetivo

Publicar una beta endurecida con foco en:

- seguridad de memoria de la VM
- coherencia semántica del lenguaje
- persistencia JMN confiable
- suite mínima de verificación reproducible

## 1. Gate de compilación

- [ ] Compila `sdk-dependiente/jas-compiler-c` sin errores.
- [ ] Compila `sdk-dependiente/jasboot-ir` sin errores.
- [ ] Compila `sdk-dependiente/jasboot-jmn-core` como parte del build de VM.
- [ ] Los binarios esperados existen:
  - [ ] `sdk-dependiente/jas-compiler-c/bin/jbc.exe`
  - [ ] `sdk-dependiente/jasboot-ir/bin/jasboot-ir-vm.exe`

## 2. Gate de seguridad de memoria

- [ ] No quedan checks activos del tipo `addr + size > limit` en rutas de VM.
- [ ] Las rutas activas de lectura/escritura escalar usan helpers comunes.
- [ ] Existen tests negativos para:
  - [ ] lectura fuera de rango
  - [ ] escritura fuera de rango
  - [ ] puntero cercano a `NULL`
  - [ ] hash de texto usado como puntero
  - [ ] offset relativo corrupto
- [ ] La VM aborta con mensaje claro o captura el error de forma controlada.

## 3. Gate semántico del lenguaje

- [ ] Los built-ins críticos tienen contrato documentado.
- [ ] `buscar` tiene semántica estable y documentada.
- [ ] La familia de búsqueda introspectiva está documentada y diferenciada.
- [ ] No quedan tests oficiales usando una API con semántica incorrecta o ambigua.
- [ ] `resultado` mantiene semántica consistente en compilador y runtime.

## 4. Gate de persistencia JMN

- [ ] Crear memoria, recordar, buscar y cerrar funcionan en flujo básico.
- [ ] La carga posterior de `.jmn` recupera nodos, conexiones y textos.
- [ ] El formato v1/v2 sigue siendo legible por el runtime actual.
- [ ] Los mapas y listas persistentes no corrompen el archivo.
- [ ] Los casos de archivo inexistente, truncado o inválido producen error controlado.

## 5. Gate de suite mínima

- [ ] Existe una suite `smoke`.
- [ ] Existe una suite `regression`.
- [ ] Existe una suite `memory-safety`.
- [ ] Existe una suite `persistence`.
- [ ] La forma de ejecutar cada suite está documentada.
- [ ] La release no sale si falla cualquiera de las suites gate.

## 6. Gate de documentación

- [ ] `docs/TECNICO/VM/VM_ESTABLE.md` refleja la pila vigente.
- [ ] No quedan referencias principales al compilador Python como ruta estable.
- [ ] El plan de estabilización y backlog están actualizados.
- [ ] La documentación de built-ins críticos coincide con tests y runtime.

## 7. Gate de repo

- [ ] No hay artefactos generados innecesarios en el árbol principal.
- [ ] `.gitignore` cubre binarios y salidas temporales relevantes.
- [ ] No quedan archivos residuales que rompan tooling básico.
- [ ] Los documentos nuevos están ubicados en rutas coherentes.

## 8. Gate de verificación manual mínima

- [ ] Ejecutar un programa simple de consola.
- [ ] Ejecutar un programa con JMN.
- [ ] Ejecutar un caso de error controlado de VM.
- [ ] Ejecutar un caso de búsqueda introspectiva con API oficial.
- [ ] Confirmar que la salida de error sigue siendo comprensible.

## 9. Criterio de salida

La beta endurecida puede declararse lista cuando:

- todos los checks P0 están cerrados
- la suite gate pasa completa
- la documentación principal está alineada con el código real
- no quedan regresiones conocidas en VM, búsqueda o persistencia

## Registro de release

Versión interna:

Fecha:

Responsable:

Resultado final:

Observaciones:
