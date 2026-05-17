# FAQ y limitaciones

## La libreria ya sirve para una app de prediccion?

Si. Para MVP de prediccion numerica y de texto (clasificacion/intencion), si.

## Sirve como LLM completo?

No. El foco actual es ML clasico + NLP ligero/generativo n-gram.

## Por que la carga es por fases?

Para estabilidad y costo: evita inicializar objetos pesados que no necesitas.

## Que inicializar para texto?

- minimo: `inicializar_fachada()`
- recomendado para texto predictivo: `inicializar_nlp_generativo_y_series()`
- sumar `inicializar_redes_svm_clustering()` si usaras SVM/redes

## Riesgos conocidos

- `rnn` puede ser sensible cuando se crea junto con mucha carga de objetos.
- usar `inicializar_capa_rnn()` de forma explicita y separada.
- el modelo de lenguaje `nlp_gen` mantiene Markov/historial en variables de modulo `_mlm_*`: **no hay dos modelos N-gram independientes en el mismo proceso** salvo aislar ejecuciones o redisenar por instancia.

## Persistencia del N-gram (.jbr vs JMN)

Guía amplia en `MODELO_LENGUAJE_JBR_Y_JMN.md` y ejemplo en `EJEMPLOS_DE_USO.md` (§6).

- **`.jbr`:** Exporta/importa solo el historial de textos pasados por `nlp_gen.entrenar` (serialización `JBR1`). Para creación y uso detallados: API `guardar_archivo_jbr` / `cargar_archivo_jbr` y modo `fusionar` (0=reemplazo, 1=solo si coincide `orden_n`).
- **JMN:** Persistencia por `guardar_snapshot_jmn` / `cargar_snapshot_jmn` y memoria abierta (`recordar` / `buscar`), distinta del bundle `.jbr`.
- **Firma FS en el lenguaje:** Las rutas que escriben a disco desde la librería usan `escribir_archivo(contenido, fd)` tras `abrir_archivo(ruta,"wb")`. La referencia del lenguaje documenta esta firma en `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md` (sección Archivos FS).

## Buenas practicas

- mantener dataset de entrenamiento y test separados
- registrar metrica base antes de optimizar
- usar validacion cruzada cuando sea posible
- no mezclar documentacion historica con docs oficiales actuales
