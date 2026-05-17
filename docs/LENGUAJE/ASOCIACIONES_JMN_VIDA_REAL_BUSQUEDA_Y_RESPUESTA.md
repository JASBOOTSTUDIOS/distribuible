# Asociaciones JMN en la vida real: búsqueda, aprendizaje, memoria y longitud de respuesta

Este documento complementa [TIPOS_RELACION_JMN.md](./TIPOS_RELACION_JMN.md). Aquí no hay código: solo una explicación de **cómo se usarían** los tipos de relación en un sistema como Neurixis, **cómo se obtendrían respuestas** a partir del grafo, **cómo un concepto puede “subir de categoría”** de relación con el aprendizaje, **cómo la IA conserva** esas asociaciones y **cómo decidir** si la salida debe ser breve o extensa.

**Plan futuro (capa fonética / acústica sobre JMN):** [JMN_PLAN_CAPA_FONETICA_FUTURO.md](./JMN_PLAN_CAPA_FONETICA_FUTURO.md).

Además, en las secciones **8 a 10** se desarrolla con más detalle: **cómo la gramática y la función sintáctica dan contexto** (no solo las palabras “con significado de diccionario”), **qué papel tiene repetir el mismo concepto** muchas veces en un mismo mensaje (por ejemplo *que*, *la*, *palabra*), y **cómo distinguir modos de interacción** (preguntar, consultar datos, enseñar, contar un hecho pasado, socializar), porque **no son el mismo acto comunicativo** y la IA debe interpretarlos con reglas distintas. Las secciones **11 y 12** aclaran **cómo el lenguaje asigna roles de tipo JMN a verbos polivalentes como *hablar*** y ofrecen una **prueba narrativa** de **escalado de tipos** en una misma cadena de conceptos.

---

## 1. Qué es una asociación en este marco

Una **asociación** es un vínculo dirigido entre dos conceptos (nodos), con un **tipo de relación** (del 1 al 30 en la guía) y un **peso** (fuerza o confianza). El tipo no es decoración: indica **qué papel juega** ese vínculo cuando se **activa** un concepto y se **expande** el rastro hacia vecinos para armar una respuesta.

En cada apartado siguiente, cuando digamos “**asociación**”, se entiende explícitamente **de qué concepto a cuál** y **con qué tipo** (número y nombre del documento de tipos).

---

## 2. Uso en la vida real, tipo por tipo (con referencia explícita a la asociación)

### Tipo 1 — Asociación general

- **Vida real**: Dos ideas suelen aparecer juntas en conversaciones o textos, sin que una sea definición de la otra.
- **Asociación ejemplo**: *mar* → *sal* (tipo **1**); *café* → *mañana* (tipo **1**).
- **Implementación conceptual**: sirve de **pegamento contextual**. Cuando el usuario menciona uno, el sistema puede **sugerir** el otro en el rastro interno, sin afirmar una regla lógica dura.

### Tipo 2 — Patrón reconocido

- **Vida real**: “Cuando pasa A+B+C, suele estar ocurriendo el fenómeno D”.
- **Asociación ejemplo**: *sujeto_verbo_predicado* → *oracion_valida* (tipo **2**).
- **Implementación conceptual**: agrupa **micro-señales** en una **etiqueta de nivel superior**; útil para estilo, gramática reconocida o plantillas habituales.

### Tipo 3 — Secuencia narrativa o gramatical

- **Vida real**: Orden de palabras o pasos: lo que “sigue” a lo anterior.
- **Asociación ejemplo**: *hola* → *como* (tipo **3**); *como* → *estas* (tipo **3**).
- **Implementación conceptual**: motor de **continuación** (generación o predicción del siguiente fragmento).

### Tipo 4 — Similitud / sinónimo

- **Vida real**: Dos formas de decir lo mismo o casi lo mismo.
- **Asociación ejemplo**: *feliz* → *contento* (tipo **4**); en muchos diseños el sistema **refleja** también *contento* → *feliz* (tipo **4**).
- **Implementación conceptual**: **unifica variantes** para que la búsqueda y la activación no dependan de una sola palabra.

### Tipo 5 — Oposición / antónimo

- **Vida real**: Contraste estable entre ideas.
- **Asociación ejemplo**: *luz* ↔ *oscuridad* (tipo **5**).
- **Implementación conceptual**: evita confusiones, permite **matizar polaridad** y detectar contradicciones.

### Tipo 6 — Pertenencia / taxonomía (“es un”)

- **Vida real**: Clasificación por categorías.
- **Asociación ejemplo**: *gato* → *mamifero* (tipo **6**); *manzana* → *fruta* (tipo **6**).
- **Implementación conceptual**: **herencia suave** de propiedades: si algo encaja en la categoría, arrastra expectativas razonables.

### Tipo 7 — Causalidad

- **Vida real**: “Si ocurre la causa, es plausible el efecto”.
- **Asociación ejemplo**: *fuego* → *calor* (tipo **7**); *lluvia* → *mojado* (tipo **7**).
- **Implementación conceptual**: cadena **causa → efecto** para explicaciones y predicción prudente (siempre acotada por peso e incertidumbre).

### Tipo 8 — Temporalidad

- **Vida real**: Antes/después en el tiempo.
- **Asociación ejemplo**: *desayuno* → *almuerzo* (tipo **8**).
- **Implementación conceptual**: ordena **relatos** e **instrucciones** cronológicas.

### Tipo 9 — Intención / objetivo

- **Vida real**: La acción apunta a una meta; una palabra dispara una intención conversacional.
- **Asociación ejemplo**: *estudiar* → *aprender* (tipo **9**); *que* → *intencion_pregunta* (tipo **9**).
- **Implementación conceptual**: **clasifica la intención** del usuario (ayuda, compra, curiosidad, etc.).

### Tipo 10 — Valoración / prioridad

- **Vida real**: Qué se considera bueno, malo o importante en un perfil.
- **Asociación ejemplo**: *mentir* → *malo* (tipo **10**); *ayudar* → *bueno* (tipo **10**).
- **Implementación conceptual**: **políticas** y tono; puede ponderar caminos de respuesta.

### Tipo 11 — Ubicación espacial

- **Vida real**: Dónde está algo.
- **Asociación ejemplo**: *torre_eiffel* → *paris* (tipo **11**).
- **Implementación conceptual**: anclaje **geográfico** o de “lugar virtual” (sala, proyecto, carpeta mental).

### Tipo 12 — Propiedad / atributo

- **Vida real**: Cómo es algo.
- **Asociación ejemplo**: *cielo* → *azul* (tipo **12**); *limon* → *acido* (tipo **12**).
- **Implementación conceptual**: **descripción** de entidades.

### Tipo 13 — Parte de / meronimia

- **Vida real**: Composición física o estructural.
- **Asociación ejemplo**: *rueda* → *coche* (tipo **13**); *tecla* → *teclado* (tipo **13**).
- **Implementación conceptual**: descomposición y **preguntas de piezas**.

### Tipo 14 — Consecuencia lógica

- **Vida real**: “Entonces…” en un sentido más abstracto que la causalidad física.
- **Asociación ejemplo**: *delito* → *carcel* (tipo **14**).
- **Implementación conceptual**: **inferencia normativa o jurídica** (con cautela y transparencia de límites).

### Tipo 15 — Condición / prerrequisito

- **Vida real**: Sin A no tiene sentido o no es posible B.
- **Asociación ejemplo**: *llave* → *abrir_puerta* (tipo **15**); *internet* → *navegar* (tipo **15**).
- **Implementación conceptual**: **planificación** y validación de “¿tengo lo necesario?”.

### Tipo 16 — Instancia / individuo

- **Vida real**: Este ejemplar concreto pertenece a la clase.
- **Asociación ejemplo**: *pelusa* → *gato* (tipo **16**); *sol* → *estrella* (tipo **16**).
- **Implementación conceptual**: **identidad** y desambiguación (nombre propio vs. tipo).

### Tipo 17 — Posesión / tenencia

- **Vida real**: Quién tiene qué, sin que sea “parte de”.
- **Asociación ejemplo**: *juan* → *llaves* (tipo **17**); *ia* → *datos* (tipo **17**).
- **Implementación conceptual**: inventarios, permisos, responsabilidad.

### Tipo 18 — Funcionalidad / uso

- **Vida real**: Para qué sirve una herramienta o sistema.
- **Asociación ejemplo**: *martillo* → *clavar* (tipo **18**); *neurixis* → *asistir* (tipo **18**).
- **Implementación conceptual**: **selección de herramientas** y procedimientos.

### Tipo 19 — Evidencia / fuente

- **Vida real**: De dónde sale una creencia.
- **Asociación ejemplo**: *tierra_redonda* → *ciencia* (tipo **19**); *rumor* → *usuario_desconocido* (tipo **19**).
- **Implementación conceptual**: **confianza** y trazabilidad (qué tanto apoyar una afirmación).

### Tipo 20 — Magnitud / comparación

- **Vida real**: Comparaciones cualitativas o escalas relativas.
- **Asociación ejemplo**: *elefante* → *raton* (tipo **20**, interpretado como “más grande que” en el marco del sistema).
- **Implementación conceptual**: **lenguaje comparativo**; requiere convención interna para la dirección del vínculo.

### Tipo 21 — Frecuencia / probabilidad

- **Vida real**: “Suele pasar”, “casi siempre”, “rara vez”.
- **Asociación ejemplo**: *invierno* → *frio* (tipo **21**).
- **Implementación conceptual**: **expectativas** y advertencias de incertidumbre.

### Tipo 22 — Parentesco / social

- **Vida real**: Familia, roles, jerarquías humanas.
- **Asociación ejemplo**: *ana* → *pedro* (tipo **22**); *empleado* → *jefe* (tipo **22**).
- **Implementación conceptual**: **contexto interpersonal** y organizacional.

### Tipo 23 — Calificación / especificación

- **Vida real**: “Hecho científico” como *hecho* calificado por *científico*, sin fundirlo en un solo token opaco.
- **Asociación ejemplo**: *hecho* → *cientifico* (tipo **23**); *tierra* → *redonda* (tipo **23**).
- **Implementación conceptual**: **composición semántica** modular en lugar de explosión de identificadores rígidos.

### Tipo 24 — Acción / desempeño

- **Vida real**: Quién hace qué.
- **Asociación ejemplo**: *juan* → *corre* (tipo **24**); *sol* → *brilla* (tipo **24**).
- **Implementación conceptual**: núcleo **sujeto–verbo** del relato.

### Tipo 25 — Complemento / objeto

- **Vida real**: Sobre qué recae la acción.
- **Asociación ejemplo**: *come* → *manzana* (tipo **25**); *estudia* → *astronomia* (tipo **25**).
- **Implementación conceptual**: cierre **verbo–objeto** (SVO).

### Tipo 26 — Cuantificación / valor

- **Vida real**: Cuántos o cuánto.
- **Asociación ejemplo**: *manzanas* → *5* (tipo **26**).
- **Implementación conceptual**: **números atómicos** enlazados a conceptos.

### Tipo 27 — Unidad de medida / contexto numérico

- **Vida real**: En qué unidad va el número.
- **Asociación ejemplo**: *5* → *kilometros* (tipo **27**); *edad* → *años* (tipo **27**).
- **Implementación conceptual**: evita confusiones **km vs. millas**, **años vs. meses**, etc.

### Tipo 28 — Operador matemático

- **Vida real**: Palabras que disparan operaciones.
- **Asociación ejemplo**: *mas* → *suma* (tipo **28**); *diferencia* → *resta* (tipo **28**).
- **Implementación conceptual**: puente **lenguaje natural ↔ operación** formal.

### Tipo 29 — Situación / contexto situacional

- **Vida real**: Marco escénico de un hecho.
- **Asociación ejemplo**: *cena* → *restaurante* (tipo **29**).
- **Implementación conceptual**: **desambiguación global** (“en qué escenario estamos hablando”).

### Tipo 30 — Referencia lógica / deducción

- **Vida real**: Dependencias entre entidades para razonar sin almacenar todo como tabla estática.
- **Asociación ejemplo**: *ana* → *juan* (tipo **30**), como ancla para una **regla** o **constraint** que el motor mantiene aparte del grafo.
- **Implementación conceptual**: combina **relación** + **mecanismo de inferencia** (el grafo señala el vínculo; las reglas operan sobre él).

---

## 3. Cómo se hacen las asociaciones (sin código)

1. **Entrada del usuario o del sistema**: texto, hechos confirmados, correcciones, o lectura de un corpus ya curado.
2. **Normalización de conceptos**: sinónimos y variantes se alinean vía tipo **4** (y a veces tipo **23** para calificadores).
3. **Elección del tipo**: según la intención del vínculo (¿es orden temporal? tipo **8**. ¿Es “parte de”? tipo **13**. ¿Es meta? tipo **9**.).
4. **Peso inicial**: refleja confianza o frecuencia observada; puede ser bajo si la evidencia es débil.
5. **Actualización**: si el mismo vínculo se repite con evidencia consistente, el peso **sube**; si hay refutación o baja utilidad, puede **bajar** o quedar relegado frente a otros tipos más informativos.

La “implementación” en producto es, en esencia: **política de escritura** (quién puede crear qué tipo de arista) + **criterio de tipado** (clasificador o humano en el lazo) + **persistencia** (siguiente sección).

---

## 4. Cómo será la búsqueda de respuestas en base a las asociaciones

Piensa en tres capas que trabajan juntas:

### Activación y expansión

- Se **activan** los nodos que mejor coinciden con la consulta actual (y con el **contexto situacional** tipo **29** si está disponible).
- Desde ahí, el sistema **recorre aristas** con reglas distintas según el **tipo**:
  - Para **continuar** una frase, prioriza tipo **3** y, en segundo plano, tipo **1** por color semántico.
  - Para **explicar por qué**, prioriza tipos **7**, **14** y evidencia tipo **19**.
  - Para **ubicar o describir**, tipos **11**, **12**, **13**.
  - Para **intención**, tipo **9** y políticas tipo **10**.

### Filtrado y ranking

- No todas las aristas salen a la respuesta final: se **rankean** por peso, por tipo pertinente al **modo** de la tarea (pregunta corta vs. explicación), y por **compatibilidad** con el escenario (tipo **29**).

### Ensamblaje de la respuesta

- La salida se construye como un **camino explicable**: una cadena de conceptos donde cada salto puede etiquetarse mentalmente (“esto es taxonomía”, “esto es evidencia”, “esto es secuencia”). Eso ayuda a **evitar alucinación**: si no hay arista de soporte razonable (especialmente **19** para hechos delicados), el sistema puede **acotar** o **preguntar** en lugar de inventar.

---

## 5. Cómo un concepto nuevo puede “escalar” hacia otro tipo de relación según el aprendizaje

Al principio, muchas relaciones nuevas son **débiles** y **genéricas**:

- **Fase inicial**: “A y B aparecen juntos a menudo” → se representa como **asociación general** *A* → *B* (tipo **1**) con peso moderado.
- **Fase de estructura**: si el patrón es establemente **ordenado**, parte del flujo puede **especializarse** a *A* → *B* (tipo **3** secuencia) o a orden temporal *A* → *B* (tipo **8**).
- **Fase taxonómica**: si se confirma “A es clase de B”, puede surgir o reforzarse *A* → *B* (tipo **6**), reduciendo la dependencia del vínculo genérico tipo **1**.
- **Fase lógica**: si hay reglas o consecuencias repetidas, pueden aparecer tipos **7**, **14** o **15** con peso creciente, mientras el tipo **1** queda como **residuo contextual** (útil pero no decisivo).
- **Fase de evidencia**: cuando hay fuentes, se añaden aristas tipo **19** que **anclan** o **limitan** cómo deben leerse los tipos causales o lógicos.

Este “ascenso” no borra siempre el vínculo anterior: lo **reclasifica** en importancia. Un tipo **1** puede seguir existiendo como **eco asociativo**, pero la **búsqueda** preferirá tipos más informativos cuando el modo de la conversación lo exija.

---

## 6. Cómo la IA va a “recordar” las asociaciones

En términos de producto (alineado con la arquitectura JMN del proyecto):

- **Memoria persistente**: el grafo se **guarda** entre sesiones; las aristas no viven solo en la RAM de un turno.
- **Consolidación**: periódicamente o al cerrar tareas, el sistema **integra** cambios recientes para que el archivo de memoria refleje el estado coherente (y, donde aplique, mecanismos de diario/recuperación evitan pérdida brusca ante cortes).
- **Refuerzo por uso**: cada vez que un vínculo ayuda a una respuesta buena (o el usuario confirma), su **peso** o su **prioridad de recuperación** puede aumentar; si no se usa, decae suavemente.
- **Separación memoria vs. razonamiento**: el grafo **recuerda** “qué está conectado y cómo”; el motor de inferencia **decide** cuándo es prudente usar cada arista. La memoria no sustituye la lógica, la **alimenta**.

---

## 7. Cómo saber cuándo responder solo lo necesario y cuándo dar una respuesta larga

Esto no sale de un solo tipo de relación: sale de **señales** y de un **presupuesto de profundidad**. Las secciones **8** (gramática y cohesión), **9** (repetición y foco en el turno) y **10** (pregunta vs. consulta vs. enseñanza vs. relato vs. socialización) detallan **de dónde salen** esas señales más allá de la lista de palabras “importantes”.

### Señales de brevedad

- **Intención de pregunta puntual** detectada vía tipo **9** (por ejemplo, intención de “dato único” o “sí/no”).
- **Preguntas cerradas** o con alcance explícito (“en una frase”, “solo el nombre”).
- **Contexto de UI** (chat móvil, lista, notificación) donde la política de producto favorece **concisión**.
- **Alta confianza en un único nodo respuesta** con aristas de soporte **19** claras: basta con enunciar el hecho y, si hace falta, una **fuente** breve.

### Señales de extensión

- **Intención** tipo **9** de tipo “explicar”, “enseñar”, “comparar”, “paso a paso”.
- **Cadena causal o lógica** larga (tipos **7**, **14**, **15**) donde omitir pasos **rompe** la comprensión.
- **Situación** tipo **29** ambigua: hace falta **marco** antes de la respuesta central.
- **Evidencia mixta** (tipo **19** con pesos medios o conflictivos): conviene **contextualizar** y dar matices.

### Mecanismo unificador (presupuesto)

El sistema lleva un **presupuesto de expansión** (pasos en el grafo, tokens objetivo, o “nivel de detalle”):

- Si las señales piden brevedad, se **corta** la expansión tras los tipos más directos (**12**, **6**, **26–27**, **9**).
- Si piden profundidad, se **permite** encadenar tipos **7–8–14–19** y, si aplica, **23–24–25** para estructurar una explicación legible.

La **valoración** tipo **10** y las **políticas de seguridad** también pueden **forzar** brevedad (“responde mínimo y ofrece ampliar”) en temas sensibles.

---

## 8. Gramática, función de las palabras y contexto: no todo son “palabras con definición”

Cuando una persona habla, el significado no está repartido solo en sustantivos y verbos “fuertes”. También está en **cómo se ensamblan** las piezas: en el **orden**, en las **relaciones de dependencia**, en las **concordancias**, en los **marcadores discursivos** y en las **expectativas** que esas formas activan. Eso es lo que suele llamarse **regla gramatical** en sentido amplio: no es un adorno, es un **sistema de señales** que le dice al oyente qué tipo de acto se está realizando, qué queda **pendiente** de completar y qué parte del mensaje es **tema** frente a **remate**.

En el marco de asociaciones JMN, esas señales se pueden modelar sin convertir cada coma en un nodo místico, pero **sí** reconociendo que muchas palabras que parecen “vacías” son en realidad **operadores de contexto**. Por ejemplo:

- **Artículos y determinantes** (*el*, *la*, *un*, *esta*) no “dicen” un objeto del mundo por sí solos, pero **anclan** la referencia: indican si hablamos de algo **definido** (ya introducido o compartido) o **indefinido** (nuevo en el foco). Eso inclina la búsqueda hacia **continuidad referencial** en el propio turno y en turnos anteriores. Conceptualmente, el sistema puede apoyarse en asociaciones de **situación** *mensaje_actual* → *suposicion_referencia_definida* (tipo **29**) y en **patrones** que reconocen plantillas de nominalización (tipo **2**).
- **Pronombres y repetición léxica** (*que*, *esto*, *lo mismo*, *la palabra X otra vez*) crean **puentes** entre fragmentos: obligan a resolver “¿a qué apunta esto?”. Eso es **cohesión**: la gramática exige que el significado se **recupere** de un antecedente. En términos de asociación, aparece una red temporal de **lectura**: *token_en_posicion_k* queda ligado por **secuencia** (tipo **3**) y por **patrón** (tipo **2**) a *antecedente_en_posicion_j*, y además por **intención** (tipo **9**) cuando el pronombre introduce subordinación interrogativa o relativa.
- **Conjunciones y conectores** (*y*, *pero*, *porque*, *aunque*, *entonces*) explicitan **relaciones lógicas o retóricas** entre cláusulas: suma, contraste, causa, concesión, conclusión. Esas relaciones no son meramente léxicas; son **instrucciones de ensamblaje** del pensamiento. Aquí los tipos **7** (causalidad), **14** (consecuencia lógica), **8** (temporalidad) y a veces **15** (prerrequisito) son los roles naturales del grafo cuando el conector ya no es solo “ruido estadístico” sino **disparador de una lectura obligatoria**.
- **Orden de palabras y marcas de modo** (pregunta vs. afirmación, subjuntivo vs. indicativo en lenguas que lo marcan) cambian la **interpretación epistémica**: lo mismo dicho con distinta forma puede pasar de **hecho** a **deseo**, de **orden** a **sugerencia**, de **información** a **petición**. Eso se alinea con **intención / objetivo** (tipo **9**) y con **valoración** (tipo **10**) cuando la forma implica cortesía, distancia o autoridad.

Por qué importa para la búsqueda de respuestas: si el sistema solo “enciende” nodos por palabras sueltas, confundirá **sinónimos** con **misma función**, o **homónimos** con **mismo sentido**. La gramática actúa como un **filtro de ambigüedad**: reduce el espacio de nodos candidatos **antes** de expandir el grafo semántico. Dicho de otro modo: la regla gramatical **canaliza** qué aristas (tipos **3**, **7**, **9**, **29**, etc.) son **legítimas** en ese punto del análisis.

En resumen, el habla no es una lista de conceptos; es un **proceso** en el que la forma **obliga** a ciertas lecturas. Las asociaciones deben poder representar tanto **contenido** (*qué* se habla) como **procedimiento de lectura** (*cómo* debe enlazarse lo que se acaba de decir con lo anterior y con lo que falta). Los tipos **2** (patrón), **3** (secuencia gramatical/narrativa) y **29** (situación) son los más útiles para capturar esa capa sin pretender que el grafo sustituya a un parser completo: el parser (o su equivalente) entrega **estructura**; el grafo entrega **mundo y preferencias de interpretación**.

---

## 9. Repetición del mismo concepto muchas veces en un mensaje: cómo “inclina” el contexto

En un mensaje largo o en una oración compuesta, es normal **volver** a las mismas formas: *que*, *la*, *palabra*, *concepto*, *contexto*, etc. Esa repetición no es fallo de estilo; muchas veces es **mecanismo cognitivo**. Hace tres cosas a la vez: **mantiene el hilo**, **refuerza el foco** y **reorganiza** qué lectura es la dominante.

### 9.1. No es la misma “instancia mental” en cada aparición

Una misma cadena de caracteres puede activar el **mismo nodo léxico** en el lexicón, pero en cada posición cumple **función distinta**. Ejemplo abstracto con *que*: puede introducir **subordinada sustantiva** (“no creo **que**…”), **relativa** (“la idea **que**…”), **comparativa** o **exclamativa** según el entorno. El grafo no debería fusionar todas las apariciones en un solo “sentido”; debería registrar **apariciones indexadas** por posición o por rol sintáctico, y enlazarlas con aristas de **secuencia** (tipo **3**) y **patrón** (tipo **2**). La **asociación** relevante no es solo *que* → *significado_unico* (eso sería engañoso), sino *que_en_contexto_C* → *rol_subordinante* (tipo **9** o **2**, según cómo se modele la intención local) y *que_en_contexto_C* → *antecedente_X* (tipo **3** o **30** cuando hay dependencia lógica explícita).

### 9.2. Repetición léxica con la misma función: refuerzo de foco

Cuando repites *palabra*, *concepto* o *contexto* a sabiendas, muchas veces estás **enseñando al oyente** a mirar el mensaje con una lente: “fíjate en la palabra como unidad”, “fíjate en el concepto como nodo”, “fíjate en el contexto como marco”. Cada repetición **sube la activación** de ese nodo y **estrecha** la competencia con vecinos alternativos. En el grafo, eso se parece a **refuerzo temporal** dentro del turno: no necesariamente a un peso permanente enorme, sino a un **sesgo de búsqueda** (“en este mensaje, este tema manda”). Los tipos **1** (co-ocurrencia forzada dentro del texto) y **29** (situación: “estamos en una lección meta-lingüística”) explican bien ese fenómeno sin confundirlo con una relación causal del mundo.

### 9.3. Palabras muy frecuentes (*la*, *de*, *en*) y “tendencia” estadística vs. tendencia interpretativa

Palabras como *la* aparecen muchas veces; si el sistema solo contara frecuencia, **inflaría** importancia irrelevante. La solución conceptual es **separar capas**: la capa léxica reconoce la forma; la capa sintáctica asigna **función** (determinante, pronombre clítico, etc.); la capa semántica solo **propaga** activación cuando la función lo permite. Así, la repetición de *la* **no** debería disparar veces el mismo razonamiento semántico, sino **actualizar** el estado de referencia (“seguimos hablando del mismo referente” vs. “cambió el referente”). Eso es cohesión de **definición**: asociación *determinante + sustantivo* → *referente_resuelto* (tipo **23** calificando el núcleo, más **29** para el marco conversacional).

### 9.4. Efecto acumulativo en todo el mensaje

Un mensaje completo es una **trayectoria**: cada frase deja **supuestos activos** (open questions, entidades salientes, tono). La repetición de un concepto a lo largo del texto **alinea** la interpretación de frases posteriores: lo que al principio era ambiguo, al final se lee “a la luz” del eje repetido. Para la IA, eso significa mantener un **estado de discurso** (memoria de trabajo del turno) que no es lo mismo que el archivo JMN: el archivo guarda **conocimiento estable**; el estado del turno guarda **obligaciones interpretativas recientes**. Las asociaciones persistentes (tipos **1**, **6**, **7**, **19**, etc.) alimentan ese estado; el estado **prioriza** qué aristas del archivo entran en juego ahora.

Referencia explícita de asociación “tipo de trabajo” en este fenómeno: *mensaje_largo* → *tema_recurrente_T* (tipo **1** o **29**, según se modele el tema como co-ocurrencia o como marco); *aparicion_i_de_T* → *aparicion_{i+1}_de_T* (tipo **3** secuencia discursiva); y, si el hablante **metaexplica**, *T* → *rol_metaexplicativo* (tipo **9** intención local: “estoy señalando T como objeto de análisis”).

---

## 10. Pregunta, consulta, enseñanza, relato y socialización: modos distintos y cómo interpretarlos

No es lo mismo que alguien **pregunte**, que **consulte**, que **enseñe**, que **cuente** algo que pasó, o que **socialice** (saludar, bromear, mantener vínculo). La superficie lingüística puede parecerse: todos usan frases en español y muchas veces entonación o emoji no están disponibles. Por eso la IA necesita **señales múltiples** y un **modo conversacional** explícito, no una sola etiqueta “pregunta sí/no”.

### 10.1. Pregunta (pedir información o acción)

- **Qué busca el usuario**: una **laguna** en su modelo mental; quiere que el sistema **llene** ese hueco o **confirme** una hipótesis.
- **Señales típicas**: morfología interrogativa, orden de palabras, signos de interrogación, pronombres interrogativos (*qué*, *cuál*, *cómo*, *por qué*), o verbos de petición implícita (*¿puedes…?*).
- **Asociaciones que ayudan a interpretarlo**: *forma_oracion* → *intencion_pregunta* (tipo **9**); *palabra_interrogativa* → *tipo_de_respuesta_esperada* (tipo **9** ligado a plantillas: definición, procedimiento, sí/no); a veces *pregunta* → *prerrequisito_de_contexto* (tipo **15**) cuando la respuesta sensata exige aclarar antes (*¿a qué te refieres con X?*).
- **Conducta de respuesta**: priorizar **precisión** y **delimitación**; si la pregunta es ambigua, el modo pregunta autoriza **una contra-pregunta** breve. La longitud debe ser la mínima que **cierre** la laguna salvo que la pregunta pida explícitamente profundidad.

### 10.2. Consulta (acceso a registro, estado o catálogo)

- **Qué busca el usuario**: no siempre “saber qué es algo”, sino **obtener un dato** de un sistema: saldo, cita, estado de pedido, última versión, política vigente.
- **Señales típicas**: posesivos sobre registros (*mi*, *nuestro*), referencia a **sistemas** o **identificadores**, verbos de recuperación (*muéstrame*, *dame*, *verifica*), tiempo presente de estado.
- **Diferencia clave respecto a la pregunta abierta**: la consulta espera **formato** y **fuente**; la incertidumbre no es conceptual, es **de acceso**.
- **Asociaciones**: *consulta_tipo_T* → *campos_requeridos* (tipo **15** prerrequisitos de la consulta); *resultado_consulta* → *fuente_o_log* (tipo **19**); *entidad* → *ubicacion_en_sistema* (tipo **11** en sentido de “dónde vive” el dato).
- **Conducta de respuesta**: brevedad, **tabular** o estructurada si aplica, y **trazabilidad** (de dónde salió). Si falla el acceso, el modo consulta pide **error claro** y siguiente paso, no una disertación.

### 10.3. Enseñanza (transferencia estructurada de conocimiento)

- **Qué busca el usuario**: que el interlocutor **entienda un marco**: definiciones, analogías, pasos, contraejemplos, ejercicios.
- **Señales típicas**: imperativos pedagógicos (*explica*, *enseña*, *paso a paso*), marcadores de generalización (*en general*, *la idea es*), meta-lenguaje (*definamos*, *notación*), deicticos que organizan (*primero*, *segundo*, *por tanto*).
- **Asociaciones**: taxonomías (tipo **6**), prerequisitos (tipo **15**), causalidad y consecuencia (tipos **7** y **14**), evidencia (tipo **19**), y **patrones** didácticos recurrentes (tipo **2**: “definición → ejemplo → contraejemplo”).
- **Conducta de respuesta**: **macro-estructura** visible; puede ser larga pero **segmentada**; debe vigilarse que no se confunda con “socialización” solo porque el tono es amable: la **intención** (tipo **9**) sigue siendo *transferencia*.

### 10.4. Relato de algo que pasó (narración de experiencia o evento)

- **Qué busca el usuario**: **testigo** o **comprensión afectiva** más que un manual; el foco es la **línea temporal** y los **actores**.
- **Señales típicas**: tiempo pasado, anclas temporales (*ayer*, *cuando era*), deíxis personal (*me pasó*, *nosotros*), secuencias de eventos.
- **Asociaciones**: temporalidad (tipo **8**), causalidad vivida (tipo **7** con matices de subjetividad), roles sociales (tipo **22**), situación (tipo **29**: “este es un espacio de confianza”).
- **Conducta de respuesta**: validación prudente, **preguntas mínimas** si hace falta claridad emocional, evitar “modo consulta” frío; la longitud depende de si piden consejo o solo **acompañamiento**.

### 10.5. Socialización (afecto, ritual, humor, mantenimiento de relación)

- **Qué busca el usuario**: a menudo **no** una pieza de información nueva, sino **continuidad relacional**: saludo, reconocimiento, broma, small talk.
- **Señales típicas**: formulaciones convencionales (*¿qué tal?*), humor, ironía, temas ligeros, poca densidad proposicional explícita.
- **Asociaciones**: valoración (tipo **10**), patrones rituales (tipo **2**), asociaciones laxas (tipo **1**) que sustentan “temas seguros”.
- **Conducta de respuesta**: **breve**, tono acorde, evitar sobre-explicar; el error típico del sistema es tratar un ritual como **pregunta informacional** pura.

### 10.6. Cómo combinar señales sin colapsar todo en “pregunta”

En la práctica, un solo turno mezcla modos (*“Oye, ¿me explicas X? Es que ayer pasó Y y no sé si…”*). La interpretación robusta usa **puntuación por evidencias**: varias hipótesis de modo con un **peso** cada una. Las aristas tipo **9** pueden apuntar a **varias intenciones** candidatas; la gramática (sección **8**) y el relato (marcas de tiempo, sección **10.4**) **desempatan**. El **presupuesto de profundidad** (sección **7**) se elige según el **modo dominante**, con reglas de seguridad: si hay mezcla de enseñanza + emoción, primero **aclarar** el objetivo con una frase corta puede ser mejor que una clase magistral o que un síntesis demasiado seca.

### 10.7. Referencia explícita de asociaciones “de modo”

Para fijar ideas, el sistema puede mantener nodos de **etiqueta de modo** no como adorno, sino como **destino de intención**:

- *turno_usuario* → *modo_pregunta* (tipo **9**)
- *turno_usuario* → *modo_consulta* (tipo **9**)
- *turno_usuario* → *modo_ensenanza* (tipo **9**)
- *turno_usuario* → *modo_relato* (tipo **9** + refuerzo temporal tipo **8**)
- *turno_usuario* → *modo_social* (tipo **9** + patrón ritual tipo **2**)

Esas aristas **no sustituyen** el análisis lingüístico; **resumen** el resultado para que el resto del grafo sepa **qué tipos de relación** deben tener prioridad al expandir la respuesta.

---

## 11. ¿A qué tipo(s) de relación pertenece “hablar”? La función del lenguaje como “etiquetador de roles”

### 11.1. Lo primero: el tipo no se le pega a la palabra sola; se le pega al **vínculo** en un **marco**

En JMN/ARA, lo que tiene tipo es la **arista** entre dos nodos en un contexto interpretable: *A* → *B* con tipo **N**. Por eso la pregunta correcta no es “¿*hablar* es tipo 24?” sino “**entre qué conceptos** aparece *hablar* en este enunciado, y **qué relación semántica** une esos conceptos”.

Eso importa porque *hablar* es **polivalente**: puede ser acción, medio, ritual social, señal de intención, parte de una secuencia conversacional, etc. El **lenguaje** (morfología, sintaxis, entonación implícita en la puntuación, colocaciones, cohesión con el turno anterior) es lo que **disambigúa** qué aristas crear o activar.

### 11.2. Qué “función lingüística” aporta el análisis del enunciado

La función del lenguaje, en este sentido técnico, es **asignar roles** a los fragmentos del mensaje: **quién** hace qué, **sobre qué**, **para qué**, **en qué orden**, **en qué escenario**, **con qué evidencia**. Esas funciones se mapean a familias de tipo JMN:

| Señal lingüística (idea breve) | Rol que fija el lenguaje | Tipos JMN típicos donde encaja *hablar* o su marco |
|--------------------------------|--------------------------|-----------------------------------------------------|
| *hablar* como **verbo principal** de un sujeto humano | acción atribuida a un agente | **24** (*ana* → *hablar*) |
| complemento de tema/medio: “hablar **de** X”, “hablar **en** Y” | objeto o marco del acto | **25** (*hablar* → *tema_X*) y a veces **29** (*hablar* → *escenario_Y*) |
| finalidad explícita: “hablamos **para** alinear…” | meta u objetivo del acto | **9** (*hablar* → *alinear_expectativas*) |
| conectores de causa/consecuencia alrededor del acto de hablar | lectura lógica del discurso | **7**, **14**, **15** (según sea causa, consecuencia abstracta o prerequisito) |
| “después de hablar, quedó…” | orden en el relato | **8** |
| “hablar” como costumbre conjunta en pareja/equipo | vínculo social o rol | **22** |
| colocación vaga: “reunión, café, hablar” suelen aparecer juntos sin regla dura todavía | pegamento estadístico/contextual | **1** |
| plantilla conversacional reconocida (saludo → charla → despedida) | patrón de interacción | **2** |
| turno siguiente predicho (“hola” → …) a nivel de **cadena de habla** | secuencia de producción | **3** |

Nada de esto contradice el diccionario: el diccionario dice qué es *hablar* en abstracto; la **gramática del enunciado** dice **qué relación** instancia *hablar* **ahora**.

### 11.3. Mini-ejemplos con la misma lexía y distinto tipo (por el marco)

- “**Ana habla**.” → la lectura mínima es **acción/desempeño**: *ana* → *hablar* (**24**). Puede coexistir con *hablar* → *modo_social* (**9**) si el contexto es small talk, pero la arista **24** es la columna vertebral del predicado.
- “**Hablamos del presupuesto**.” → núcleo verbal + tema: *hablar* (o *hablamos* como evento grupal) → *presupuesto* (**25**), y el marco puede ser *turno* → *modo_consulta_o_ensenanza* (**9**) según tono y historia.
- “**Si hablamos, entendemos mejor**.” → lectura condicional/consecuencia: aristas **15** (hablar como prerequisito de entender) y/o **14**/**7** según cómo se modele la consecuencia.
- “**Habla** y luego **decidimos**.” → orden de fases: *hablar* → *decidir* (**8** temporal de proceso, a veces **3** si se modela como cadena de actos típica).

### 11.4. Resumen operativo para implementación mental

1. **Segmentar y analizar** el enunciado (parser + reglas de rol).  
2. Para cada par (*origen*, *destino*) que el análisis impone, **elegir tipo** según la tabla de roles (no según “la palabra bonita”).  
3. Si hay ambigüedad, **varias hipótesis** de aristas con peso bajo (**1**) hasta que el contexto (tipo **29**) o la evidencia (**19**) desempaten.  
4. Con el tiempo, el sistema puede **especializar** (sección **5** y prueba de la sección **12**): lo que empezó como co-ocurrencia (**1**) se convierte en patrón (**2**) o en acción explícita (**24–25**) cuando el lenguaje lo exige una y otra vez de forma estable.

---

## 12. Prueba narrativa (“test”): una secuencia de conceptos que **escalan** de tipo

Este “test” no es un programa: es un **guión verificable** que puedes recorrer como checklist. Muestra **cómo** las mismas entidades (*maría*, *reunión*, *alinear*, *equipo*) van ganando **aristas más informativas** a medida que el lenguaje aporta más estructura y evidencia.

### 12.0. Criterio de éxito del test

Al final de la secuencia deben cumplirse tres cosas a la vez:

1. Sigue existiendo, si hace falta, una arista **débil** de contexto (tipo **1**) que no miente: “suelen aparecer juntas”.  
2. Existe al menos una **cadena explícita** de acción/objeto/intención (**24**, **25**, **9**) que soporte preguntas del tipo “¿qué hace María y sobre qué?”.  
3. Si hubo fuente externa (calendario, acta), hay soporte de **evidencia** (**19**) que justifique subir el peso de lo inferido a “sostenido”.

### 12.1. Paso 1 — solo convivencia léxica (evidencia mínima)

**Situación**: en varios mensajes sueltos aparecen *maría* y *reunión* cerca, pero sin sintaxis que imponga sujeto/verbo/objeto ni finalidad clara.

**Arista razonable**: *maría* → *reunión* con tipo **1** (asociación general), peso bajo.

**Qué aún no está justificado**: que María “organice” reuniones, que la reunión sea instrumento de alineación, etc. Cualquier salto fuerte sería especulación.

### 12.2. Paso 2 — patrón recurrente (misma secuencia de conceptos, más observaciones)

**Situación**: en el 80 % de los hilos laborales, el orden micro del texto es “*maría* … *reunión* … *lunes*” o variantes muy parecidas.

**Arista nueva o reforzada**: *patron_maria_reunion_lunes* → *bloque_agenda_tipico* con tipo **2** (patrón reconocido), o bien refuerzo del **1** con peso mayor si aún no quieres comprometerte con una plantilla nombrada.

**Escalado**: de “van juntas” (**1**) a “esto es una **forma** que se repite” (**2**).

### 12.3. Paso 3 — el lenguaje impone **orden** de proceso

**Situación**: alguien escribe con claridad procedural: “**Primero** la reunión de alineación, **después** el compromiso por escrito.”

**Aristas**: *reunion_alineacion* → *compromiso_escrito* con tipo **8** (temporalidad de proceso). Si el sistema modela además micro-pasos de redacción, puede haber cadenas tipo **3** entre actos de habla consecutivos.

**Escalado**: el mismo concepto *reunión* deja de ser “vecino suelto de María” y pasa a anclar un **flujo** (**8**/**3**).

### 12.4. Paso 4 — predicado explícito: acción, objeto e intención

**Situación**: “**María propone la reunión para alinear expectativas del equipo**.”

Aquí el lenguaje **obliga** roles:

- Agente y acción: *maría* → *proponer* (**24**).  
- Objeto de la acción: *proponer* → *reunion* (**25**).  
- Finalidad: *proponer* (o *reunion*) → *alinear_expectativas* (**9**).  
- Marco colectivo: *reunion* → *equipo* o *equipo* → *expectativas* según el análisis elegido (**22**/**25**/**23** según granularidad).

**Escalado**: de patrón estadístico (**2**) a **modelo accional** (**24–25**) + **teleología** (**9**). El tipo **1** puede seguir existiendo, pero **deja de mandar** en la expansión cuando la pregunta es “¿por qué lo hace?”.

### 12.5. Paso 5 — evidencia externa que “cierra” la lectura causal sin magia

**Situación**: el calendario muestra la serie recurrente y el acta dice: “**Objetivo de la reunión: alinear alcance**.”

**Aristas**:

- *afirmacion_sobre_objetivo* → *acta_reunion* (**19** evidencia/fuente).  
- Opcionalmente, si el acta licencia lectura causal fuerte: *reunion* → *alineacion_de_alcance* con tipo **7** o **14**, pero **solo** si la política del producto permite inferencia normativa/causal a partir de documentos; si no, se queda en **19** + **9**.

**Escalado**: la intención (**9**) y la acción (**24–25**) pasan de “muy creíbles por sintaxis” a **sostenidas** por **fuente** (**19**).

### 12.6. Cómo “leer” el test como tabla de transición de tipos

| Fase | Hecho observable en el lenguaje o en el mundo | Arista representativa | Tipos dominantes |
|------|-----------------------------------------------|------------------------|------------------|
| 1 | co-ocurrencia sin roles forzados | *maría* → *reunión* | **1** |
| 2 | repetición de forma | *…* → *bloque_agenda_tipico* | **2** (y/o **1** fuerte) |
| 3 | conectores y orden procedural | *reunión* → *compromiso* | **8** / **3** |
| 4 | predicado completo + para/qué | *maría* → *proponer* → *reunión* → *alinear…* | **24**, **25**, **9**, pos. **22** |
| 5 | documento o log | *claim* → *acta* / *calendario* | **19** (+ **7**/**14** si procede) |

### 12.7. Qué demuestra este test sobre “hablar” y similares

Si en el paso 4 la acción hubiera sido *hablar* en lugar de *proponer*, el **mismo mecanismo** aplicaría: el verbo no “trae” el tipo; **el análisis del enunciado** elige **24/25/9/8…** y el aprendizaje **sube** la solidez de esas aristas cuando el **patrón** (**2**) y la **evidencia** (**19**) lo respaldan.

---

## 13. Cierre

Las treinta familias de relación son un **vocabulario de roles** en el grafo: definen **cómo** se propaga la activación y **qué clase de ensamblaje** merece la respuesta. La **búsqueda** no es solo “vecinos cercanos”, sino **vecinos del tipo correcto para la tarea**. El **aprendizaje** mueve los vínculos de genéricos (tipo **1**) a estructurados (tipos **3**, **6**, **7**, etc.). La **memoria persistente** conserva esas aristas y su peso. La **longitud** de la respuesta se gobierna con **intención** (tipo **9**), **situación** (tipo **29**), **evidencia** (tipo **19**) y un **presupuesto de profundidad**, no con una regla mágica única.

Además, el habla real aporta **gramática y cohesión** (sección **8**), la **repetición** organiza foco y lectura en el tiempo del mensaje (sección **9**), y los **modos del diálogo** exigen políticas de respuesta distintas (sección **10**). Las secciones **11 y 12** cierran el círculo: el lenguaje **etiqueta roles** entre conceptos (ej. *hablar* en distintos marcos) y una **secuencia de observaciones** puede **escalar** tipos sin confundir estadística con intención.

*Documento orientado a diseño conversacional y cognitivo; última revisión: 2026-05-14.*
