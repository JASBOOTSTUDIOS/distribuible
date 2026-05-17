# Modelo de lenguaje (N-gram): JBR, JMN y estado en proceso

Aplica a `g_analitica.nlp_gen` (`ModeloLenguaje` en `machine_learning/nlp_generativo.jasb`).

## Inicializacion

- Tras `inicializar_nlp_generativo()` o `inicializar_nlp_generativo_y_series()`, el modelo llama internamente a **`preparar_markov_lm(entero n)`** (orden N-gram típico: `3`).
- No uses `inicializar(...)` con un solo entero en `ModeloLenguaje`: ese nombre en la clase base es `inicializar(texto, texto)`; el entrypoint del modelo generativo es **`preparar_markov_lm`**.

## API principal

| Metodo | Rol |
|--------|-----|
| `entrenar(texto corpus)` | Incrementa historial y estadisticas Markov. |
| `predecir_siguiente(texto contexto)` | Siguiente token mas frecuente. |
| `generar_texto(texto semilla, entero max_palabras)` | Generacion por extension. |
| `guardar_snapshot_jmn(texto namespace)` / `cargar_snapshot_jmn(namespace, max_docs)` | Persistencia del historial en la **JMN abierta** (`recordar`/`buscar`). |
| `guardar_parte_cerebro(nombre_parte)` / `cargar_parte_cerebro(nombre_parte, max_docs)` | Namespaces `brain:parte:<nombre>` en JMN. |
| `guardar_archivo_jbr(ruta, etiqueta_parte)` | Exporta el historial en archivo **`.jbr`** (texto UTF-8, portable). **Requiere** que la lista global de historial tenga elementos; si esta vacía no se abre el archivo en modo truncado (no se pierde un `.jbr` anterior vacío por error). |
| `cargar_archivo_jbr(ruta, fusionar)` | Importa: `fusionar=0` reemplazo total y reaplica corpus con `orden_n` del archivo; `fusionar=1` **suma** corpus al modelo vivo solo si **`orden_n` del archivo coincide** con el del proceso (si no, retorna `0`). |
| `orden_markov_lm()`, `elementos_historial()` | Introspeccion ligera. |

---

## Como crear archivos `.jbr` desde Jasboot

Flujo tipico:

1. **Memoria neuronal opcional pero habitual:** `crear_memoria("ruta.jmn")` si el programa usa `recordar`/`buscar`, snapshots JMN del modelo u otras integraciones VM+JMN.
2. **`inicializar_fachada()`** y **`inicializar_nlp_generativo_y_series()`** para que `g_analitica.nlp_gen` no sea `nulo`.
3. Una o más llamadas **`g_analitica.nlp_gen.entrenar(texto)`** — cada string es un “documento” en el historial que luego sale como un bloque `INICIO_BLOQUE_JBR` … `FIN_BLOQUE_JBR`.
4. **`g_analitica.nlp_gen.guardar_archivo_jbr(ruta_archivo, etiqueta_parte)`**
   - Escribe UTF-8 con cabecera `JBR1`, `orden_n`, `parte`, `historial_count` y todos los bloques.
   - **Retorna** el número de bloques escritos (`lista_tamano` del historial). `0` indica sin historial o fallo de apertura del archivo.

Detalle de implementacion (para depuracion): por debajo usa `abrir_archivo(ruta, "wb")`, `escribir_archivo(contenido, fd)` y `cerrar_archivo(fd)`. La VM y el compilador deben estar alineados con esa firma de **escritura `(texto, descriptor)`**.

Ejemplo autocontenido equivalente al script de prueba `apps/michelle_IA/herramientas/test_export_jbr_desde_lenguaje.jasb` (allí también se muestra el wrapper `exportar_modelo_nlp_jbr` del motor híbrido):

```jasboot
usar {
    g_analitica,
    inicializar_fachada,
    inicializar_nlp_generativo_y_series
} de "stdlib/analitica-neuronal/analitica.jasb"

principal
    crear_memoria("scratch.jmn")
    inicializar_fachada()
    inicializar_nlp_generativo_y_series()

    g_analitica.nlp_gen.entrenar("primera frase de entrenamiento")
    g_analitica.nlp_gen.entrenar("segunda frase distinta")

    entero n = g_analitica.nlp_gen.guardar_archivo_jbr("modelo_demo.jbr", "demo")
    imprimir "bloques_jbr=" + str_desde_numero(n)

    consolidar_memoria()
    cerrar_memoria()
fin_principal
```

Las rutas en `de "..."` deben coincidir con la ubicación de tu árbol (en el repo se usan a veces rutas absolutas en apps).

---

## Como usar (cargar) archivos `.jbr`

### Desde metodo directo

```jasboot
# Sustituir modelo activo por el del archivo:
entero cargados = g_analitica.nlp_gen.cargar_archivo_jbr("modelo_michelle.jbr", 0)

# O fusionar corpus si ya habia entrenamiento y el orden_n coincide:
entero fusion = g_analitica.nlp_gen.cargar_archivo_jbr("otra_parte.jbr", 1)
```

Tras cargar (`fusionar=0` o `1` con éxito), `predecir_siguiente` y `generar_texto` usan el estadistico reconstruido.

### Helpers Michelle / motor hibrido

En `apps/michelle_IA/modulos/motor_hibrido.jasb`:

- `cargar_modelo_entrenado_jbr(ruta, fusionar)` → delegado en `cargar_archivo_jbr`.
- `exportar_modelo_nlp_jbr(ruta, etiqueta)` → delegado en `guardar_archivo_jbr`.

El chat (`entrada/chat_michelle.jasb`) suele fusionar al inicio varios bundles (`michelle_modelo.jbr`, `brain_*.jbr`) con `fusionar=1`, y **al cerrar sesion** puede volver a exportar `michelle_modelo.jbr` con el historial **acumulado en esa ejecución** (`exportar_modelo_nlp_jbr`). Los “cerebros por dominio” pueden regenerarse con `herramientas/construir_partes_cerebro.jasb`.

---

## Formato `.jbr` (resumen)

Primera línea `JBR1`, cabecera con `orden_n`, `parte`, `historial_count`, y bloques:

```text
JBR1
orden_n 3
parte etiqueta_opcional
historial_count N
INICIO_BLOQUE_JBR
...lineas de texto...
FIN_BLOQUE_JBR
```

Evita una línea aislada igual a `FIN_BLOQUE_JBR` dentro del cuerpo. El cargador también admite por compatibilidad el formato anterior `BEGIN` / `#JBR.END#`.

---

## Estado compartido (`_mlm_*`) y limitacion

El mapa Markov, la lista de corpus y contadores viven en variables de módulo **`enviar`** (`_mlm_hist_global`, `_mlm_markov_global`, `_mlm_orden_global`, `_mlm_hist_count_global`) para que todas las rutas vean el mismo modelo. **No hay dos grafos N-gram independientes en el mismo proceso** sin ejecutar programas separados o redisenar el almacenamiento por instancia.

---

## JMN frente a JBR

| Recurso | Contenido | Uso |
|---------|-----------|-----|
| **`.jmn`** | Grafo asociativo, textos por ID, snapshots bajo namespaces | Persistencia conversacional amplia |
| **`.jbr`** | Solo el historial lineal serializado del N-gram | Intercambio ligero entre apps / “partes del cerebro” |

Para aplicación práctica en chat vea `apps/michelle_IA/docs/JBR_MODELOS_JASBOOT.md`.
