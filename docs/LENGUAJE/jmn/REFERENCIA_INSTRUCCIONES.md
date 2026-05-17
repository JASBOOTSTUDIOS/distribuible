# Referencia de Instrucciones JMN

Este documento detalla todas las instrucciones disponibles en Jasboot para manipular la Memoria Neuronal.

## 1. Gestión de Archivos

### `crear_memoria(ruta)` / `abrir_memoria(ruta)`

Inicializa o carga un archivo JMN.

- **Uso**: `crear_memoria("mi_cerebro.jmn")`
- **Nota**: Si ya hay una memoria abierta, la VM **consolida** automáticamente la anterior antes de abrir la nueva.

### `cerrar_memoria()`

Cierra la memoria actual y libera los recursos en la VM. Es una buena práctica llamar a esto al finalizar el programa.

### `consolidar_memoria()`

Fuerza el guardado de todos los cambios pendientes en el disco sin cerrar la sesión.

- **Uso**: Ideal después de grandes bloques de aprendizaje (`recordar` o `asociar`).

## 2. Persistencia de Datos

### `recordar clave con valor valor`

Almacena un dato persistente.

- **Ejemplo**: `recordar "nombre_usuario" con valor "Alex"`
- **Importante**: La sintaxis requiere la palabra clave `con valor`.

### `buscar clave`

Busca un concepto en la JMN. El resultado se deposita en la variable global del sistema `resultado`.

- **Ejemplo**:
  ```jasb
  buscar "nombre_usuario"
  imprimir resultado # Imprimirá "Alex"
  ```

## 3. Grafo y Relaciones

### `asociar concepto1 con concepto2`

Crea un vínculo genérico entre dos conceptos.

- **Uso**: `asociar "Aurora" con "Asistente"`

### `asociar_relacion(id1, id2, tipo, peso)`

Crea un vínculo especializado con fuerza de conexión.

- **id1 / id2**: Conceptos (texto o ID).
- **Tipos soportados**: `1` (Asociación/Similitud), `2` (Oposición), `3` (Secuencia). También acepta cadenas como `"secuencia"`.
- **Peso**: Un valor flotante (0.0 a 1.0). El sistema usa precisión de 16 bits (factor 1000).
- **Uso**: `asociar_relacion("agua", "h2o", 1, 0.95)`

### `buscar_peso(id1, id2)`

Devuelve la fuerza de conexión (0.0 a 1.0) entre dos conceptos.

- **Uso**: `flotante p = buscar_peso("grande", "enorme")`

## 4. Navegación Cognitiva y Búsqueda Avanzada

### `buscar_asociados_lista(concepto, K, tipo)`

Busca hasta los `K` mejores asociados de un concepto, **ordenados de mayor a menor peso**.

- **K**: Máximo de resultados a retornar.
- **tipo**: (Opcional) Tipo de relación.
- **Retorno**: Una `lista` de conceptos.
- **Ejemplo**:
  ```jasb
  lista asocs = buscar_asociados_lista("inteligente", 3)
  para_cada texto a indice i sobre asocs hacer
      imprimir str_desde_numero(i + 1) + ". " + a + " (Fuerza: " + buscar_peso("inteligente", a) + ")"
  fin_para_cada
  ```

### `buscar_asociados_rango(lista_conceptos, min_peso, max_peso)`

Realiza una búsqueda masiva para una lista de conceptos de consulta.

- **Retorno**: Un `mapa` donde las claves son los conceptos de consulta y los valores son `listas` de sus asociados que cumplen el rango.
- **Ejemplo**:
  ```jasb
  lista consulta = ["España", "Francia"]
  mapa resultados = buscar_asociados_rango(consulta, 0.8, 1.0)
  # Recorrido de mapa: usar la API de mapa o materializar claves en lista según el programa.
  ```

### `pensar_siguiente(concepto)`

Sigue una relación de tipo `"secuencia"`.

- **Uso**: `texto siguiente_paso = pensar_siguiente("saludo")`

### `pensar_anterior(concepto)`

Busca el concepto que precede al actual en una secuencia.

## 5. Otras Funciones (No Documentadas pero Funcionales)

### `buscar_asociados consulta`

Busca conceptos asociados semánticamente en la red neuronal.

- **Uso**: `buscar_asociados "consulta"`
- **Retorno**: ID numérico del concepto asociado (almacenado en `resultado`)
- **Nota**: Función no documentada oficialmente pero funcional en la VM actual
- **Ejemplo**:
  ```jasb
  buscar_asociados "test_concepto"
  imprimir resultado  # Ej: 2147483650
  ```

### `propagar_activacion(texto)`

Propaga activación semántica a través de la red neuronal.

- **Uso**: `propagar_activacion "concepto"` o con tope de saltos y salida: `propagar_activacion(concepto, d_max [, K])`. Guía completa, límites y auditoría: [**PROPAGACION_D_MAX_K_AUDITORIA_Y_ESTRES.md**](PROPAGACION_D_MAX_K_AUDITORIA_Y_ESTRES.md).
- **Retorno**: ID numérico del mejor candidato (también en `resultado`).
- **Ejemplo**:
  ```jasb
  propagar_activacion "test_concepto"
  imprimir resultado  # Ej: 2826870867
  propagar_activacion("test_concepto", 0, 16)  # solo semilla; ganador suele ser 0
  ```

### `esta_activo()` (en objetos JmnIA)

Verifica si la memoria neuronal está inicializada y activa.

- **Uso**: `si jmn.esta_activo() entonces...`
- **Retorno**: Booleano
- **Nota**: Función implementada para validación de estado
- **Ejemplo**:
  ```jasb
  si jmn.esta_activo() entonces
      jmn.recordar_dialogo("clave", "valor")
  fin_si
  ```

---

Siguiente: [Ejemplos y Reglas de Seguridad](EJEMPLOS_Y_REGLAS.md)
