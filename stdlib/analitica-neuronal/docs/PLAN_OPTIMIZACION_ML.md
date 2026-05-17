# Plan de Estabilización y Optimización: Machine Learning en Jasboot

Este documento detalla las mejoras planificadas para la librería analítica y el núcleo de la VM, enfocadas en la eficiencia del entrenamiento de Redes Neuronales y la persistencia de sus modelos.

## 1. Optimización de Listas (VM Core)

### El Problema
Actualmente, la actualización de pesos en `redes_neuronales.jasb` utiliza una función que crea una copia completa de la lista para modificar un solo elemento. En una red con $W$ pesos, el entrenamiento tiene una complejidad de memoria de $O(W^2)$ por iteración, lo que causa latencia y presión excesiva en la memoria.

### La Solución
Implementar una operación de modificación "in-place" (en el sitio) directamente en la Máquina Virtual.

- **Opcode Nuevo**: `OP_MEM_LISTA_PONER` (si no existe) o asegurar que la implementación actual sea in-place.
- **Función Nativa**: `lista_poner_en_indice(lista l, entero i, elemento v)`.
- **Beneficio**: Reducción de la complejidad de $O(N)$ a $O(1)$ por actualización de peso.

## 2. Persistencia de Redes Neuronales (.jbr)

### El Problema
A diferencia del módulo de NLP, las Redes Neuronales no tienen forma de guardar sus pesos y sesgos una vez entrenadas. Todo el conocimiento se pierde al cerrar el programa.

### La Solución
Extender el formato `.jbr` (Jasboot Brain Resource) para soportar estructuras de datos de redes neuronales.

- **Nuevo Formato JBR para NN**:
  ```text
  JBR1
  tipo redes_neuronales
  capas [entrada, oculta1, ..., salida]
  activacion relu
  INICIO_BLOQUE_JBR
  pesos_capa_0: [0.1, -0.2, ...]
  sesgos_capa_0: [0.01, ...]
  ...
  FIN_BLOQUE_JBR
  ```
- **Nuevos Métodos en `RedesNeuronales`**:
  - `guardar_archivo_jbr(ruta, etiqueta)`: Serializa el mapa del modelo (pesos y sesgos) a texto.
  - `cargar_archivo_jbr(ruta)`: Reconstruye el modelo a partir de los datos guardados.

## 3. Cronograma de Implementación

1.  **Núcleo C**: Adición/Optimización de opcodes de lista en `vm.c`.
2.  **Compilador**: Registro de la función nativa en `symbol_table.c` y `keywords.c`.
3.  **Librería Jasboot**: Refactorización de `backward_pass` para usar la nueva función y adición de métodos de persistencia.
4.  **Validación**: Test de entrenamiento XOR con guardado y carga de modelo.
