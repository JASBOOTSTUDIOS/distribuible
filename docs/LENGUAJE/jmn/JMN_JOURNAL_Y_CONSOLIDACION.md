# Journal `.jwl`, recuperación y consolidación (Fase 2.2)

Este documento describe el comportamiento **de producto** del motor Jasboot respecto a la memoria neuronal persistente (`.jmn`), el journal append-only (`.jwl`), la consolidación tipo sueño y el contexto reciente MAI expuesto en el lenguaje.

## Archivos en disco

| Archivo | Rol |
| ------- | --- |
| `ruta.jmn` | Snapshot binario del grafo JMN (nodos, conexiones, textos). |
| `ruta.jmn.jwl` | Journal **append-only** de operaciones incrementales (nodos, conexiones, textos, marcas de commit). |

Al abrir memoria con `crear_memoria("ruta.jmn", ...)`, el runtime puede **registrar** en el `.jwl` las mutaciones y, en condiciones controladas, **reconstruir** estado si el `.jmn` falta o no se puede leer.

## Variables de entorno (recuperación y diagnóstico)

Definidas en detalle en `AGENTS.md` y en `memoria_neuronal.h`. Resumen:

| Variable | Efecto |
| -------- | ------ |
| `JASBOOT_JWL_REPLAY=1` | Tras abrir, si el `.jmn` no es usable, **reproducir** operaciones desde el `.jwl` sobre memoria vacía o parcial. |
| `JASBOOT_JWL_CHECKPOINT=1` | Tras un guardado **exitoso** del `.jmn`, **truncar** el `.jwl` (checkpoint: el snapshot ya refleja el estado). |
| `JASBOOT_JWL_STAT=1` | Log del tamaño del `.jwl` al abrir (stderr). |
| `JASBOOT_JWL_REPLAY_DBG=1` | Diagnóstico extra durante replay. |
| `JASBOOT_JMN_NO_FINAL_SAVE=1` | No sobrescribir el `.jmn` al cerrar la VM (pruebas con `.jmn` corrupto o escenarios controlados). |

## API en Jasboot (sin depender del entorno)

| Llamada | Tipo / retorno | Descripción |
| ------- | -------------- | ----------- |
| `mai_contexto_recientes()` | `lista` | Hasta 10 IDs de concepto en foco reciente (más reciente primero). |
| `mai_contexto_recientes(n)` | `lista` | Igual con tope `n` entero **1..10** (literal o expresión entera). |
| `mai_contexto()` / `mai_contexto(n)` | `lista` | Alias de `mai_contexto_recientes`. |
| `consolidar_sueno()` | `entero` (éxito 0/1) | Igual que `consolidar_memoria` / `dormir` / `consolidar`: decae conexiones, olvido de débiles y consolidación del grafo (`OP_MEM_CONSOLIDAR_SUENO`). |

El buffer de foco se actualiza con operaciones típicas (`recordar`, `buscar`, etc.) **aunque** no se active el subsistema MAI por hilos; sirve como **memoria de trabajo** alineada al plan 3.1.

## Consolidación “sueño” en segundo plano (MAI + JMN)

Si `MAI_SUEÑO_JMN=1`, el scheduler MAI invoca de vez en cuando `jmn_consolidar_memoria_sueno` **en el hilo de la VM** (no desde workers), con parámetros suaves por defecto.

### Tuning opcional (`MAI_SUEÑO_JMN_*`)

Solo tienen efecto si `MAI_SUEÑO_JMN` está activo (distinto de `0`).

| Variable | Default | Rango | Significado |
| -------- | ------- | ----- | ----------- |
| `MAI_SUEÑO_JMN_FACTOR` | `0.45` | 0..1 | Factor de decaimiento global por pasada. |
| `MAI_SUEÑO_JMN_UMBRAL` | `0.04` | 0..0.5 | Umbral por debajo del cual se olvidan conexiones débiles. |
| `MAI_SUEÑO_JMN_BOOST` | `0.03` | 0..0.5 | Refuerzo relativo a supervivientes tras olvido. |
| `MAI_SUEÑO_JMN_WAVE_EVERY` | `6` | 1..64 | Cada cuántas **oleadas** de scheduler (aprox. cada 250 ticks de MAI) se aplica una pasada de sueño JMN. Valores mayores = menos frecuente. |

## Regresión automatizada (producto 2.2)

Desde la raíz del repositorio:

```bash
node tests/run_fase_2_2.cjs
```

Ejecuta, en orden:

1. `tests/test_mai_contexto_sueno.jasb` — API `mai_contexto_recientes` + `consolidar_sueno`.
2. `tests/run_estres_jwl_replay.cjs` — replay sin `.jmn` válido.
3. `tests/run_estres_jwl_corrupt_replay.cjs` — `.jmn` corrupto + replay.

Más detalle de las baterías JWL: `docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md`.

## Qué queda fuera de este cierre (hoja de ruta)

- Rotación de journals, checksums por registro, políticas de retención “enterprise”.
- Sharding y mmap masivos (véase Fase **2.1** del plan de replicante).

---

**Ver también:** [Preguntas técnicas críticas MAI (implementación realista)](../dev/PREGUNTAS_TECNICAS_MAI_IMPLEMENTACION_REALISTA.md) — arquitectura neuronal, propagación, concurrencia y filosofía operativa frente al código.
