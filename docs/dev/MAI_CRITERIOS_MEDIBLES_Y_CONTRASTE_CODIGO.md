# Criterios medibles de «funciona» (MAI + JMN) y contraste con el código

Este documento fija **cinco criterios observables** para una app Jasboot que use MAI/JMN, y en cada uno indica **cómo medirlo**, **qué hace el código hoy**, y **brechas** respecto a un producto exigente.

---

## 1. Recuperación ante apagón / `.jmn` corrupto (journal)

| Medición | Ejemplo concreto |
|----------|------------------|
| Ejecutar la batería fase 2.2 y exigir `exit 0`. | `node tests/run_fase_2_2.cjs` |
| Replay con `.jmn` borrado o corrupto reproduce grafo + textos esperados. | `tests/run_estres_jwl_replay.cjs`, `tests/run_estres_jwl_corrupt_replay.cjs` |

**Código:** el orquestador agrupa esas pruebas en `tests/run_fase_2_2.cjs` (MAI contexto + sueño, replay sano, replay corrupto).

**Estado:** **Cumplido** en lo que cubren esos tests (no sustituye una suite de carga infinita ni rotación de journals «enterprise»).

---

## 2. Límites de RAM y colas sin degradación silenciosa inaceptable

| Medición | Ejemplo concreto |
|----------|------------------|
| RAM estimada del subsistema MAI por debajo de un techo o activación explícita de LRA. | Variable de entorno `MAI_LRA_LIMIT_MB` (véase `mai_init` en `mai.c`). |
| Bajo ráfagas de `mai_send_message*`, no se pierden activaciones críticas **sin que el producto lo sepa**. | Contador de fallos de encolado, o test de estrés que compare pasos VM vs mensajes procesados. |

**Código:**

- Tamaño acotado: `MAI_Q_CAP`, `MAI_MAX_ACTIVE_NEURONS`, colas `cortex` / `sub` en `mai.h`.
- `mai_priq_push` puede devolver **-1** si la cola está llena y el mensaje no desbanca al de menor prioridad (`mai.c`).
- `mai_send_message_ex` devuelve **0** o **-1**; acumula **`enqueue_failures`** (consulta `mai_enqueue_failures`) y con `JASBOOT_DEBUG` registra rechazos en stderr. La VM sigue ignorando el código de retorno salvo `(void)` explícito; un opcode Jasboot dedicado podría exponer el contador al lenguaje.

**Estado:** **Parcial**. Los límites existen; hay **contador** y **traza en depuración**; falta **API en Jasboot** si el producto debe reaccionar en runtime (p. ej. bajar ráfaga o priorizar).

---

## 3. Coherencia del ciclo de vida JMN ↔ puntero MAI

| Medición | Ejemplo concreto |
|----------|------------------|
| Tras `cerrar_memoria()` (o equivalente IR), ningún camino de MAI/reflexión/sueño usa el `JMNMemoria*` antiguo. | Test que abre JMN, cierra, sigue ejecutando pasos VM con `MAI_REFLECT=1` y no debe crashear. |

**Código:**

- Al **abrir** memoria: `mai_set_jmn_base` con `vm->mem_neuronal` en `vm.c` (opcode abrir escritura).
- Al **cerrar** con `OP_MEM_CERRAR` y en `vm_destroy`: debe anularse la base JMN en MAI **antes** de que el programa siga corriendo con MAI activo.

**Estado:** **Corregido en código** (mayo 2026): al cerrar JMN se llama `mai_set_jmn_base(..., NULL)` para no dejar `mai->jmn_base` colgando. Si detectas otra ruta que cierre JMN sin pasar por ahí, conviene el mismo patrón.

---

## 4. «Contexto activo» usable desde Jasboot

| Medición | Ejemplo concreto |
|----------|------------------|
| Tras N operaciones que registran contexto, `mai_contexto_recientes` (o el opcode seguro asociado) devuelve una lista de IDs acotada y estable. | `tests/test_mai_contexto_sueno.jasb` + salidas esperadas en fase 2.2. |

**Código:**

- Anillo fijo de 10 IDs: `vm_mai_note_context` escribe en `vm->mai_ctx_ring[vm->mai_ctx_write_idx % 10u]` (`vm.c`).
- Lectura hacia lista JMN de colecciones: rama `IR_INST_FLAG_SAFE` en `OP_MEM_ASOCIAR` (`vm.c`), tope `maxn` clamp a 10.

**Estado:** **Cumplido** para «últimos hasta 10 conceptos tocados». No es un resumen semántico de conversación larga; es un **buffer de recencia**, no un modelo de diálogo.

---

## 5. Reflexión y consolidación «como en el plan de visión»

| Medición | Ejemplo concreto |
|----------|------------------|
| Con flags activados, medir efecto en pesos JMN o en archivo LRA tras ciclos. | `MAI_REFLECT`, `MAI_JMN_REFLECT`, `MAI_SUEÑO_JMN`, `MAI_SUEÑO_JMN_WAVE_EVERY`, etc. (`mai.c`, docs JWL/sueño). |
| Sin flags, el comportamiento debe ser determinista y ligero (por defecto producto). | Misma suite sin variables extra. |

**Código:**

- `mai_process_cycle` / `mai_scheduler_tick` se invocan desde el bucle de la VM cada **1000 pasos** (`vm.c`: `steps % 1000`).
- `mai_reflect_from_jmn` está acotado (throttle, presupuesto de búsquedas, semillas por energía).
- `delta_ms` en `mai_process_cycle` usa diferencia de `time(NULL)*1000` entre ticks: **resolución gruesa** (segundos), no alta precisión temporal.

**Estado:** **Parcial / diseño explícito**. La capa «cognitiva» fuerte es **opt-in por entorno** y **acotada**; el plan de producto debe asumir eso o extender IR/pruebas para comportamiento por defecto.

---

## Resumen rápido

| Criterio | ¿Medible? | Código hoy |
|----------|-----------|------------|
| 1. Recuperación JWL/JMN | Sí (scripts + exit code) | Cubierto por fase 2.2 |
| 2. Colas / RAM | Sí (env + `mai_enqueue_failures` + stderr con debug) | Límites sí; contador + log; IR aún no expone fallos al `.jasb` |
| 3. Vida útil puntero JMN en MAI | Sí (test abrir/cerrar/reflect) | `mai_set_jmn_base(NULL)` al cerrar |
| 4. Contexto reciente | Sí (test existente) | Anillo 10 + opcode seguro |
| 5. Reflexión / sueño | Sí (pesos, logs, env) | Opcional, throttled, delta tiempo grueso |

---

## Enlace

Preguntas amplias de arquitectura: [PREGUNTAS_TECNICAS_MAI_IMPLEMENTACION_REALISTA.md](./PREGUNTAS_TECNICAS_MAI_IMPLEMENTACION_REALISTA.md).
