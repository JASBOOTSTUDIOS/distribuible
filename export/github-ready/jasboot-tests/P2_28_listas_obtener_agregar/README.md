# P2_28 — `mem_lista_agregar`, `mem_lista_obtener`, `mem_lista_tamano`, `lista_limpiar`

Cobertura alineada con el catálogo de instrucciones (fila P2 · 28).

- **E/** Errores en **ejecución**: índice fuera de rango en `mem_lista_obtener` y en indexación `buf[i]` cuando la lista **existe** en JMN; también índice `0` con lista vacía. Ver `E/NOTAS_E.md`.
- **R/** Flujo válido agregar → obtener → tamano → `lista_limpiar`. Ver `R/NOTAS_R.md`.
- **S/** Estrés: caso rápido (`01_`) y batería **profunda** (`02_`–`06_`): millones de `agregar`/`obtener`/`limpiar`, suma en `intentar`, crear+`liberar` masivo. Ver `S/NOTAS_S.md` (tiempos orientativos y script PowerShell).

**Relación con P2_27:** creación de listas, literales y roadmap ampliado siguen en `tests/P2_27_listas_tipo_y_crear/`. El test R `06_r_p27_obtener_indice_valido.jasb` sustituye al antiguo caso que documentaba “devuelve 0” fuera de rango.

**VM:** `OP_MEM_LISTA_OBTENER` llama a `jmn_lista_indice_fuera_de_rango` antes de leer. Sin `intentar` activo: mensaje en stderr y código de salida 1. Con `intentar` … `atrapar` (o solo `final`): el fallo **salta al manejador** como un `lanzar` implícito — el texto llega a la variable de `atrapar` (registro 1 / id texto). Opcodes `OP_TRY_ENTER` / `OP_TRY_LEAVE`. Ver `R/02_r_p28_intentar_atrapa_indice_lista.jasb`. Otros errores cubiertos de la misma forma incluyen división y módulo por cero, `mat4_inversa` singular, desbordamiento de pila de llamadas, pila de memoria agotada y opcode desconocido.
