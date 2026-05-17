# Introducción a la JMN (Memoria Neuronal)

La **Memoria Neuronal (JMN)** es el núcleo de persistencia inteligente de Jasboot. A diferencia de una base de datos tradicional (SQL/NoSQL), la JMN se comporta como un grafo de conceptos y relaciones que emula procesos cognitivos.

## ¿Qué es la JMN?

Es un archivo binario con extensión `.jmn` que almacena:

1. **Conceptos**: Claves o términos únicos (ej. "usuario", "Aurora", "saludo").
2. **Valores**: Información asociada a un concepto (ej. "Alex", "2.0", "Hola").
3. **Relaciones**: Vínculos entre conceptos con un **tipo** y un **peso** (fuerza).
4. **Secuencias**: Hilos de pensamiento que permiten a la IA saber qué paso sigue a otro.

## Características Principales

- **Persistencia Dinámica**: Los datos se guardan en disco y sobreviven al cierre del programa.
- **Asociatividad**: Puedes buscar qué conceptos están relacionados con otros sin necesidad de índices complejos.
- **Aprendizaje por Refuerzo**: Las relaciones pueden fortalecerse o debilitarse con el tiempo.
- **Consolidación Automática**: La Máquina Virtual de Jasboot gestiona la integridad de los datos al cambiar de memoria.
- **Journal y recuperación (`.jwl`)**: registro incremental junto al `.jmn`; replay y checkpoint con variables de entorno. Detalle y API de producto: [JMN_JOURNAL_Y_CONSOLIDACION.md](JMN_JOURNAL_Y_CONSOLIDACION.md).

---

Siguiente: [Referencia de Instrucciones](REFERENCIA_INSTRUCCIONES.md)
