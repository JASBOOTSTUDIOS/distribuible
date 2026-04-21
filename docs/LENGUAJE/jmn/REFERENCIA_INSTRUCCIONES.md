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
Crea un vínculo especializado.
- **Tipos soportados**: `"secuencia"`, `"similitud"`, `"oposicion"`.
- **Peso**: Un valor decimal (0.0 a 1.0).
- **Uso**: `asociar_relacion("paso1", "paso2", "secuencia", 1.0)`

### `asociados_de(concepto)`
Devuelve una cadena con todos los conceptos vinculados al concepto dado.
- **Uso**: `texto lista = asociados_de("Aurora")`

## 4. Navegación Cognitiva

### `pensar_siguiente(concepto)`
Sigue una relación de tipo `"secuencia"`.
- **Uso**: `texto siguiente_paso = pensar_siguiente("saludo")`

### `pensar_anterior(concepto)`
Busca el concepto que precede al actual en una secuencia.

## 5. Búsqueda Avanzada (Funciones No Documentadas pero Funcionales)

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
- **Uso**: `propagar_activacion "concepto"`
- **Retorno**: ID numérico de activación (almacenado en `resultado`)
- **Nota**: Función no documentada oficialmente pero funcional en la VM actual
- **Ejemplo**:
  ```jasb
  propagar_activacion "test_concepto"
  imprimir resultado  # Ej: 2826870867
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
