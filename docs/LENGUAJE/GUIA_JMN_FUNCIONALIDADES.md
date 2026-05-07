# Guía JMN (Memoria Neuronal) en Jasboot

Esta guía está dedicada exclusivamente a la **JMN (Red de Memoria Jasboot)**: qué funcionalidades tiene, cuándo usarlas y ejemplos prácticos.

## Índice de instrucciones JMN

- [`crear_memoria(ruta)`](#crearmemoriaruta)
- [`cerrar_memoria()`](#cerrarmemoria)
- [`consolidar_memoria()`](#consolidarmemoria)
- [`recordar clave con valor v`](#recordar-clave-con-valor-v)
- [`buscar clave`](#buscar-clave)
- [`asociar c1 con c2`](#asociar-c1-con-c2)
- [`asociar c1 con c2 con peso p`](#asociar-c1-con-c2-con-peso-p)
- [`buscar_asociados consulta`](#buscar_asociados-consulta)
- [`propagar_activacion(texto)`](#propagar_activaciontexto)
- [`buscar_en_memoria(termino)`](#buscar_en_memoriatermino-funcional)
- [`buscar_en_memoria_cs(termino, cs)`](#buscar_en_memoria_cstermino-cs-funcional)
- [`buscar_introspectiva(termino)`](#buscar_introspectivatermino-sinónimo)
- [`buscar_en_memoria_lista(termino, max)`](#buscar_en_memoria_listatermino-max-implementada-depende-de-listas-jmn)
- [`buscar_en_memoria_detallada(termino, max, cs)`](#buscar_en_memoria_detalladatermino-max-cs-implementada-depende-de-listas-jmn)

---

## 1) Qué es la JMN

La JMN es la memoria asociativa de Jasboot. Permite:

- Guardar datos como pares clave/valor.
- Relacionar conceptos entre sí.
- Recuperar información por clave o por búsqueda semántica.
- Persistir la memoria en disco (`.jmn`) entre ejecuciones.

---

## 2) Ciclo de vida de la memoria

### `crear_memoria(ruta)`

Abre o crea un archivo `.jmn` para trabajar con memoria persistente.

```jasb
principal
    crear_memoria("apps/jasboot_IA/memoria/demo.jmn")
    imprimir "Memoria abierta."
    cerrar_memoria()
fin_principal
```

### `cerrar_memoria()`

Cierra la memoria y guarda cambios.

```jasb
principal
    crear_memoria("demo.jmn")
    recordar "estado" con valor "activo"
    cerrar_memoria()
fin_principal
```

### `consolidar_memoria()`

Fuerza consolidación de cambios antes de cerrar (útil en sesiones largas).

```jasb
principal
    crear_memoria("demo.jmn")
    recordar "usuario" con valor "Jefry"
    consolidar_memoria()
    cerrar_memoria()
fin_principal
```

---

## 3) Almacenamiento y recuperación básica

### `recordar clave con valor v`

Guarda un valor asociado a una clave.

```jasb
principal
    crear_memoria("datos.jmn")
    recordar "usuario_nombre" con valor "Aurora"
    recordar "usuario_rol" con valor "IA"
    cerrar_memoria()
fin_principal
```

### `buscar clave`

Recupera el valor asociado. El resultado queda en la palabra reservada `resultado`.

```jasb
principal
    crear_memoria("datos.jmn")
    recordar "idioma" con valor "espanol"

    buscar "idioma"
    imprimir "Idioma: " + resultado

    cerrar_memoria()
fin_principal
```

---

## 4) Asociaciones semánticas entre conceptos

### `asociar c1 con c2`

Crea un vínculo entre dos conceptos.

```jasb
principal
    crear_memoria("asociaciones.jmn")

    asociar "aurora" con "asistente"
    asociar "asistente" con "jasboot"

    cerrar_memoria()
fin_principal
```

### `asociar c1 con c2 con peso p`

Asociación con fuerza/peso (valor flotante).

```jasb
principal
    crear_memoria("asociaciones.jmn")

    asociar "agua" con "vida" con peso 0.95
    asociar "agua" con "lluvia" con peso 0.70

    cerrar_memoria()
fin_principal
```

---

## 5) Recuperación por asociación y activación

> Estas funciones están disponibles en la VM actual y se usan en apps cognitivas.

### `buscar_asociados consulta`

Busca conceptos asociados al término de entrada.

```jasb
principal
    crear_memoria("asociaciones.jmn")
    asociar "sol" con "luz"
    asociar "sol" con "calor"

    buscar_asociados "sol"
    imprimir "ID asociado: " + resultado

    cerrar_memoria()
fin_principal
```

### `propagar_activacion(texto)`

Propaga activación semántica por la red y retorna un ID relacionado.

```jasb
principal
    crear_memoria("asociaciones.jmn")
    asociar "ia" con "aprendizaje"
    asociar "aprendizaje" con "datos"

    entero id_rel = propagar_activacion("ia")
    imprimir "ID activado: " + id_rel

    cerrar_memoria()
fin_principal
```

---

## 6) Búsqueda introspectiva en toda la memoria

La búsqueda introspectiva revisa texto tanto en claves como en valores.

### `buscar_en_memoria(termino)` (funcional)

Case-insensitive. Devuelve primer resultado en `resultado`.

```jasb
principal
    crear_memoria("introspectiva.jmn")
    recordar "redes_neuronales" con valor "Arquitectura inspirada en el cerebro"
    recordar "procesamiento_lenguaje" con valor "Analisis de texto"

    buscar_en_memoria("cerebro")
    imprimir "Match: " + resultado

    cerrar_memoria()
fin_principal
```

### `buscar_en_memoria_cs(termino, cs)` (funcional)

Control de mayúsculas:

- `cs = 0`: no sensible a mayúsculas.
- `cs = 1`: sensible a mayúsculas.

```jasb
principal
    crear_memoria("introspectiva.jmn")
    recordar "Python" con valor "Lenguaje"
    recordar "python_snake" con valor "Serpiente"

    buscar_en_memoria_cs("Python", 1)
    imprimir "Exacto: " + resultado

    buscar_en_memoria_cs("python", 0)
    imprimir "Flexible: " + resultado

    cerrar_memoria()
fin_principal
```

### `buscar_introspectiva(termino)` (sinónimo)

Equivalente a `buscar_en_memoria(termino)`.

```jasb
principal
    crear_memoria("introspectiva.jmn")
    recordar "motor_ia" con valor "Modulo generativo"

    buscar_introspectiva("generativo")
    imprimir "Resultado: " + resultado

    cerrar_memoria()
fin_principal
```

### `buscar_en_memoria_lista(termino, max)` (implementada, depende de listas JMN)

Devuelve lista de IDs cuando el flujo de listas está habilitado/corregido.

```jasb
principal
    elemento lista = buscar_en_memoria_lista("aprendizaje", 5)
    elemento tam = mem_lista_tamano(lista)
    imprimir "Total: " + tam
fin_principal
```

### `buscar_en_memoria_detallada(termino, max, cs)` (implementada, depende de listas JMN)

Devuelve metadata por resultado (id, texto, relevancia, etc.) cuando el soporte de listas está disponible.

```jasb
principal
    elemento lista = buscar_en_memoria_detallada("procesamiento", 3, 0)
    elemento tam = mem_lista_tamano(lista)
    imprimir "Resultados detallados: " + tam
fin_principal
```

### Flujo recomendado de búsqueda semántica introspectiva

Cuando quieras una recuperación "inteligente" y robusta, usá este orden:

1. `buscar clave` (si conocés la clave exacta, por ejemplo `def_hola`).
2. `buscar_en_memoria(termino)` para hallazgo rápido (claves y valores).
3. `buscar_en_memoria_cs(termino, 1)` si necesitás coincidencia exacta por mayúsculas.
4. Si el módulo de listas está disponible en tu build, pasar a:
   - `buscar_en_memoria_lista(termino, max)`
   - `buscar_en_memoria_detallada(termino, max, cs)`

Ejemplo práctico de fallback escalonado:

```jasb
principal
    crear_memoria("fallback_semantico.jmn")

    recordar "def_hola" con valor "saludo cordial"
    recordar "perfil_usuario" con valor "Jefry Astacio, programador"

    # 1) Intento por clave exacta
    buscar "def_hola"
    si resultado != "" y resultado != "indefinido" y resultado != nulo entonces
        imprimir "Exacta: " + resultado
    sino
        # 2) Fallback introspectivo
        buscar_en_memoria("Jefry")
        si resultado != 0 entonces
            imprimir "Introspectiva: " + resultado
        sino
            imprimir "Sin coincidencias en memoria."
        fin_si
    fin_si

    cerrar_memoria()
fin_principal
```

Consejo: para asistentes conversacionales, combiná esta búsqueda introspectiva con claves `def_` y `nota_` para priorizar respuestas más útiles antes de ir al fallback general.

---

## 7) Patrón recomendado para apps con memoria

```jasb
principal
    crear_memoria("mi_asistente.jmn")

    # 1) Aprender
    recordar "usuario_nombre" con valor "Jefry"
    recordar "preferencia" con valor "modo oscuro"
    asociar "Jefry" con "modo oscuro"

    # 2) Recuperar directo
    buscar "usuario_nombre"
    imprimir "Nombre: " + resultado

    # 3) Recuperar por introspección
    buscar_en_memoria("oscuro")
    imprimir "Introspectiva: " + resultado

    consolidar_memoria()
    cerrar_memoria()
fin_principal
```

---

## 8) Buenas prácticas JMN

- Abrí memoria al inicio (`crear_memoria`) y cerrá al final (`cerrar_memoria`).
- Usá claves estables y legibles (`usuario_nombre`, `def_hola`, `nota_saludo`).
- Si es una sesión larga, llamá `consolidar_memoria()` periódicamente.
- Para depuración, imprimí `resultado` después de `buscar` o `buscar_en_memoria`.
- Si hay comportamientos heredados de pruebas viejas, limpiá/renombrá el `.jmn`.

---

## 9) Errores comunes

- **“No recupera lo que guardé”**: verificar que la misma ruta `.jmn` se abre en lectura/escritura.
- **“Trae datos viejos”**: estás reutilizando un `.jmn` con historial previo.
- **“Buscar por pregunta no encuentra”**: posiblemente la clave no existe; enseñá primero con `recordar` o con una frase tipo `X es Y` en tu lógica de app.

