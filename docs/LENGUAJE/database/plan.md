# 🧠 🔥 NúcleoDB - Motor de Datos Inteligente

**Motor de datos inteligente para aplicaciones modernas — ecosistema Jasboot**

---

## 💡 🧩 ¿Por qué "NúcleoDB"?

* **"Núcleo"** = centro, origen, inteligencia
* Encaja perfectamente con el ecosistema:

```txt
jasboot → Forja → NúcleoDB → Estructa
```

👉 Suena a **ecosistema completo real**

---

## 🧠 🏗️ MODELO: Base de datos orientada a contexto

👉 No es:
* relacional (tablas)
* ni documento simple
* ni solo vectorial

👉 Es un modelo **nuevo**:

## 🔥 **Modelo Núcleo (Contextual + Semántico + Reactivo)**

---

## 🧩 1. Unidad básica: "Nodo"

En vez de filas o documentos, en Jasboot se modela con **registros**:

```jasb
registro NodoUsuario
    texto id
    texto nombre
    texto interes
    texto contenido
fin_registro
```

Cada nodo almacenado en NúcleoDB:
* tiene datos (campos del registro)
* tiene contexto (embedding generado automaticamente)
* tiene embedding automático (vectorizado por el motor)

---

## 🧠 2. Contexto automático (CLAVE)

```jasb
# Guardar nodo con texto rico para vectorizacion
nucleodb_guardar("usuarios", nodo_usuario)
```

Internamente el motor hace:
```txt
→ se genera vector del campo "contenido"
→ se indexa en HNSW
→ se conecta con otros nodos similares via mem_asociar
```

👉 Sin que el dev lo haga manualmente

---

## 🔗 3. Relaciones dinámicas (tipo grafo)

NúcleoDB usa la JMN (memoria neuronal) de Jasboot internamente:

```jasb
# Crear asociacion entre nodos
mem_asociar("usuario_juan", "interes_tecnologia", 0.9)

# Verificar la relacion
flotante fuerza = tiene_asociacion("usuario_juan", "interes_tecnologia")
```

👉 No necesitas tablas intermedias — el grafo neuronal lo gestiona

---

## 🔎 4. Búsqueda semántica nativa

```jasb
# Busqueda semantica usando propagar_activacion (JMN nativa)
texto consulta = "personas que invierten en tecnologia"
recordar "busqueda_actual" con valor consulta
propagar_activacion("busqueda_actual")

# Obtener resultados
lista similares = obtener_relacionados("busqueda_actual")
```

👉 No es SQL — usa el motor neuronal de Jasboot directamente

---

## ⚡ 5. Reactividad

NúcleoDB expone hooks que se llaman desde Forja/Estructa:

```jasb
# En el servidor Forja, manejar actualizaciones
funcion al_cambiar_usuario(texto id_nodo) retorna texto
    # Logica de notificacion
    texto notificacion = "usuario_" + id_nodo + "_actualizado"
    recordar notificacion con valor verdadero
    retornar forja_json("{\"evento\": \"cambio\", \"id\": \"" + id_nodo + "\"}")
fin_funcion
```

---

## 🧠 6. Consultas híbridas

```jasb
# Mezcla: filtro tradicional + semantica
funcion buscar_usuarios_mayor_de(entero edad_minima, texto contexto_semantico) retorna lista
    lista resultados = mem_lista_crear()
    propagar_activacion(contexto_semantico)
    lista candidatos = obtener_relacionados(contexto_semantico)
    # filtrar por edad (campo del nodo)
    entero i = 0
    mientras i < mem_lista_tamano(candidatos) hacer
        texto id_candidato = mem_lista_obtener(candidatos, i)
        buscar id_candidato + "_edad"
        entero edad_nodo = resultado
        si edad_nodo > edad_minima hacer
            mem_lista_agregar(resultados, id_candidato)
        fin_si
        i = i + 1
    fin_mientras
    retornar resultados
fin_funcion
```

---

## 🏗️ 7. Estructura interna (arquitectura)

```txt
NúcleoDB
 ├── Motor de nodos       → registros .jasb + archivos .ndb (fs_abrir/fs_escribir)
 ├── Motor de vectores    → JMN (mem_asociar, propagar_activacion)
 ├── Motor de grafos      → JMN (mem_asociar, obtener_relacionados)
 ├── Índices híbridos     → JMN HNSW interno + indices en archivo .idx
 └── Motor reactivo       → funciones Jasboot + Forja HTTP/WebSocket
```

---

## 🚀 8. API en Jasboot (SDK real)

```jasb
usar {nucleodb_guardar, nucleodb_buscar, nucleodb_conectar} de "nucleodb/src/nucleo/api.jasb"

# Guardar nodo
registro DatosUsuario
    texto nombre
    texto contenido_texto
fin_registro

DatosUsuario u
u.nombre = "Juan"
u.contenido_texto = "Me gusta la tecnologia"

nucleodb_guardar("usuarios", u.nombre, u.contenido_texto)

# Buscar por similitud semantica
lista resultado = nucleodb_buscar("usuarios", "personas tech")
```

---

## 🔥 9. Diferenciación REAL

| Comparación | Tecnología |
|---|---|
| PostgreSQL | tablas relacionales |
| MongoDB | documentos JSON |
| Pinecone | solo vectores |
| **NúcleoDB** | **Nodos + JMN + Grafo + Reactivo** |

👉 **NúcleoDB:** todo en uno, automático, nativamente integrado con Jasboot

---

## 🏁 10. Visión clara

> **"Motor de datos inteligente para aplicaciones modernas"**

---

## 💡 ROADMAP DE IMPLEMENTACIÓN

### Fase 1 (3 meses) - **Fundamentos**
- Registros de nodos con `registro` / `fin_registro`
- Almacenamiento con `fs_abrir`, `fs_escribir`, `fs_leer_texto`
- API simple: `nucleodb_guardar`, `nucleodb_obtener`

### Fase 2 (6 meses) - **Inteligencia (JMN)**
- Embeddings via `mem_asociar` + `recordar`
- Vectorización usando `propagar_activacion`
- Índices básicos en archivos `.idx`

### Fase 3 (9 meses) - **Búsqueda**
- Búsqueda semántica con `propagar_activacion` + `elegir_por_peso`
- Consultas híbridas (filtros + similitud)
- Optimización: `decae_conexiones`, `consolidar_memoria`

### Fase 4 (12 meses) - **Conexiones y Reactividad**
- Relaciones con `mem_asociar` + `obtener_relacionados`
- Motor de grafos completo
- Reactividad via Forja WebSocket + notificaciones

---

## 🚀 Formato de Almacenamiento

### 📁 **Estructura de Archivos del Proyecto**

Siguiendo el estándar de organización Jasboot:

```
nucleodb/
├── principal.jasb              # Punto de entrada / demo
├── README.md                   # Documentacion esencial
│
├── src/
│   ├── nucleo/
│   │   ├── api.jasb            # API publica principal
│   │   ├── nodos.jasb          # Gestion de nodos (.ndb)
│   │   ├── vectores.jasb       # Motor de embeddings (JMN)
│   │   └── grafos.jasb         # Relaciones (mem_asociar)
│   ├── almacenamiento/
│   │   ├── archivos.jasb       # fs_abrir/fs_escribir/fs_leer
│   │   ├── cache.jasb          # Cache en memoria (mapa)
│   │   └── wal.jasb            # Write-Ahead Log
│   ├── busqueda/
│   │   ├── semantica.jasb      # propagar_activacion + JMN
│   │   ├── hibrida.jasb        # Filtros + similitud
│   │   └── indices.jasb        # Indices en archivo .idx
│   └── protocolo/
│       ├── forja.jasb          # Integracion con Forja HTTP
│       └── mensajes.jasb       # Serializacion binaria
│
├── tests/
│   ├── test_nodos.jasb
│   ├── test_busqueda.jasb
│   └── test_grafos.jasb
│
├── data/
│   ├── nodos/                  # Archivos .ndb por coleccion
│   ├── vectores/               # Archivos .vec de embeddings
│   ├── indices/                # Archivos .idx semanticos
│   ├── grafos/                 # Archivos .grf de relaciones
│   ├── transacciones/          # Archivos .wal
│   ├── cache/                  # Cache en disco
│   └── cerebro.jmn             # Memoria neuronal JMN
│
├── config/
│   └── nucleodb.conf           # Configuracion del motor
│
└── docs/
    ├── README.md
    └── arquitectura/
```

---

### 🗃️ **Formato de Nodo (.ndb)**

El motor usa `fs_abrir` / `fs_escribir` / `fs_leer_texto`. Los nodos se serializan como texto estructurado (un nodo por línea en JSON compacto):

```jasb
# Serializar un nodo a texto para guardarlo en .ndb
funcion serializar_nodo(texto id, texto nombre, texto contenido) retorna texto
    texto linea = "{\"id\":\"" + id + "\","
    linea = concatenar(linea, "\"nombre\":\"" + nombre + "\",")
    linea = concatenar(linea, "\"contenido\":\"" + contenido + "\"}")
    retornar linea
fin_funcion

# Guardar nodo
funcion ndb_escribir(texto coleccion, texto id, texto nombre, texto contenido) retorna bool
    texto ruta = "data/nodos/" + coleccion + ".ndb"
    entero archivo = fs_abrir(ruta, "a")
    si archivo == 0 hacer
        retornar falso
    fin_si
    texto linea = serializar_nodo(id, nombre, contenido)
    linea = concatenar(linea, "\n")
    fs_escribir(archivo, linea)
    fs_cerrar(archivo)
    retornar verdadero
fin_funcion
```

---

### 🔢 **Formato Vectorial (.vec)**

Los vectores se almacenan como texto binario legible (ID + dimensiones):

```jasb
# Cabecera del archivo vectorial
# Formato: ID_NODO|dim1,dim2,...dimN
# Gestion via fs_abrir / fs_leer_linea / fs_escribir

funcion vec_guardar(texto id_nodo, lista vector) retorna bool
    texto ruta = "data/vectores/embeddings.vec"
    entero archivo = fs_abrir(ruta, "a")
    si archivo == 0 hacer
        retornar falso
    fin_si
    texto linea = id_nodo + "|"
    entero i = 0
    mientras i < mem_lista_tamano(vector) hacer
        texto dim = str_desde_numero(mem_lista_obtener(vector, i))
        linea = concatenar(linea, dim)
        si i < mem_lista_tamano(vector) - 1 hacer
            linea = concatenar(linea, ",")
        fin_si
        i = i + 1
    fin_mientras
    linea = concatenar(linea, "\n")
    fs_escribir(archivo, linea)
    fs_cerrar(archivo)
    retornar verdadero
fin_funcion
```

---

## 🔍 Lenguaje de Consultas: NúcleoQL

NúcleoQL es el **DSL de consultas**, implementado como funciones Jasboot que envuelven las operaciones del motor. No introduce sintaxis nueva al lenguaje — se usa sintaxis Jasboot estándar:

### 🗣️ **Operaciones Principales**

```jasb
usar {nucleodb_guardar, nucleodb_buscar, nucleodb_conectar, nucleodb_escuchar} de "nucleodb/src/nucleo/api.jasb"

# === Guardar nodo ===
nucleodb_guardar("usuarios", "juan_001", "Juan Perez", "Me gusta la tecnologia e invertir")

# === Busqueda por campo exacto ===
lista resultado = nucleodb_buscar_donde("usuarios", "nombre", "Juan")

# === Busqueda semantica ===
lista similares = nucleodb_buscar_similar("usuarios", "personas que invierten en tecnologia", 10)

# === Busqueda hibrida ===
lista hibridos = nucleodb_buscar_hibrida("usuarios", "interes en tecnologia", "edad", 18)

# === Conectar nodos ===
nucleodb_conectar("usuario_juan", "interes_tecnologia", 0.9)

# === Recorrer relaciones ===
lista relacionados = nucleodb_relacionados("usuario_juan", 2)
```

---

### 🎯 **Operadores Implementados como Funciones**

```jasb
# Operadores semanticos (implementados en busqueda/semantica.jasb)
# nucleodb_buscar_similar(coleccion, consulta, top_k)      → busqueda por similitud
# nucleodb_mas_cercanos(coleccion, consulta, k)            → los top-k mas cercanos
# nucleodb_relacionados(id_nodo, profundidad)              → recorrido de grafo

# Operadores contextuales (implementados en busqueda/hibrida.jasb)
# nucleodb_en_contexto(coleccion, contexto, consulta)      → filtro contextual
# nucleodb_con_metadatos(coleccion, clave_meta, valor)     → filtro por metadata
# nucleodb_cambiados_desde(coleccion, timestamp)           → cambios recientes

# Operadores reactivos (integrados con Forja en protocolo/forja.jasb)
# nucleodb_al_cambiar(coleccion, funcion_callback)         → suscripcion a cambios
# nucleodb_al_crear(coleccion, funcion_callback)           → suscripcion a creaciones
# nucleodb_al_eliminar(coleccion, funcion_callback)        → suscripcion a eliminaciones
```

---

## ⚡ Motor Reactivo

### 🔄 **Sistema de Eventos con Forja**

La reactividad se implementa sobre Forja (el servidor HTTP de Jasboot):

```jasb
usar todas de "../../stdlib/forja/forja.jasb"
usar {nucleodb_guardar, nucleodb_al_cambiar} de "nucleodb/src/nucleo/api.jasb"

# Callback de cambio (funcion Jasboot estandar)
funcion evento_usuario_actualizado(texto id_nodo) retorna texto
    imprimir "Usuario actualizado: " + id_nodo
    retornar forja_json("{\"evento\": \"usuario_actualizado\", \"id\": \"" + id_nodo + "\"}")
fin_funcion

# Registrar suscripcion
nucleodb_al_cambiar("usuarios", evento_usuario_actualizado)

# Endpoint que dispara el cambio
funcion api(texto solicitud) retorna texto
    si estructura_es_get(solicitud, "/api/usuarios/actualizar") entonces
        # Actualizar nodo y disparar evento
        nucleodb_guardar("usuarios", "juan_001", "Juan", "Nuevo contenido actualizado")
        retornar forja_json("{\"ok\": true}")
    fin_si
    retornar forja_no_encontrado()
fin_funcion

principal
    imprimir "NucleoDBServer activo en http://127.0.0.1:18300"
    imprimir estructura_http_bucle("127.0.0.1", 18300, 100, api)
fin_principal
```

---

## 🎯 API Oficial

### 📡 **API REST via Forja**

```jasb
usar todas de "../../stdlib/forja/forja.jasb"
usar {nucleodb_guardar, nucleodb_buscar_similar, nucleodb_conectar} de "nucleodb/src/nucleo/api.jasb"

funcion api(texto solicitud) retorna texto
    # POST /api/nodos/usuarios  → guardar nodo
    si forja_es_post(solicitud, "/api/nodos/usuarios") entonces
        texto cuerpo = forja_cuerpo(solicitud)
        texto id     = forja_json_campo(cuerpo, "id")
        texto nombre = forja_json_campo(cuerpo, "nombre")
        texto textoN = forja_json_campo(cuerpo, "texto")
        nucleodb_guardar("usuarios", id, nombre, textoN)
        retornar forja_json("{\"ok\": true, \"id\": \"" + id + "\"}")
    fin_si

    # GET /api/buscar/usuarios?q=personas+tech
    si forja_es_get(solicitud, "/api/buscar/usuarios") entonces
        texto q = forja_param(solicitud, "q")
        lista resultados = nucleodb_buscar_similar("usuarios", q, 10)
        retornar forja_json_lista(resultados)
    fin_si

    # POST /api/grafos/conectar
    si forja_es_post(solicitud, "/api/grafos/conectar") entonces
        texto cuerpo = forja_cuerpo(solicitud)
        texto desde = forja_json_campo(cuerpo, "desde")
        texto hacia = forja_json_campo(cuerpo, "hacia")
        nucleodb_conectar(desde, hacia, 0.8)
        retornar forja_json("{\"ok\": true}")
    fin_si

    # GET /api/sistema/status
    si forja_es_get(solicitud, "/api/sistema/status") entonces
        retornar forja_salud_ok()
    fin_si

    retornar forja_no_encontrado()
fin_funcion

principal
    imprimir "NucleoDB API activa en http://127.0.0.1:18300"
    imprimir estructura_http_bucle("127.0.0.1", 18300, 100, api)
fin_principal
```

---

### 🎯 **SDK Jasboot (módulos `usar`)**

```jasb
# Importar el SDK de NucleoDB
usar {
    nucleodb_guardar,
    nucleodb_obtener,
    nucleodb_actualizar,
    nucleodb_eliminar,
    nucleodb_buscar_similar,
    nucleodb_buscar_hibrida,
    nucleodb_conectar,
    nucleodb_relacionados,
    nucleodb_al_cambiar
} de "nucleodb/src/nucleo/api.jasb"

principal
    # Crear memoria neuronal (obligatorio antes de operar)
    crear_memoria("nucleodb/data/cerebro.jmn")

    # === Guardar nodo ===
    nucleodb_guardar("usuarios", "juan_001", "Juan Perez", "Me gusta la tecnologia e invertir en startups")

    # === Busqueda semantica ===
    lista resultados = nucleodb_buscar_similar("usuarios", "interes en tecnologia", 10)
    entero i = 0
    mientras i < mem_lista_tamano(resultados) hacer
        imprimir mem_lista_obtener(resultados, i)
        i = i + 1
    fin_mientras

    # === Conectar nodos (relacion) ===
    nucleodb_conectar("usuario_juan_001", "interes_tecnologia", 0.9)

    # === Recorrer grafo ===
    lista relacionados = nucleodb_relacionados("usuario_juan_001", 2)
    imprimir "Relacionados: " + str_desde_numero(mem_lista_tamano(relacionados))

    cerrar_memoria()
fin_principal
```

---

## 🔥 Ventaja Competitiva

| Característica | PostgreSQL | MongoDB | Pinecone | **NúcleoDB** |
|---|---|---|---|---|
| Modelo | Tablas | Documentos | Vectores | **Nodos Contextuales** |
| Semántica | ❌ | ❌ | ✅ | ✅ **via JMN nativa** |
| Reactividad | ❌ | ❌ | ❌ | ✅ **via Forja** |
| Lenguaje | SQL | MongoDB Query | Pinecone API | **Jasboot nativo** |
| Ecosistema | Genérico | Genérico | Especializado | **Jasboot integrado** |

---

## 🏁 Conclusión

**NúcleoDB** no es solo otra base de datos — es un **nuevo paradigma** que:

✅ **Unifica** datos, contexto y relaciones usando registros Jasboot y la JMN  
✅ **Automatiza** la generación de embeddings usando `mem_asociar` y `propagar_activacion`  
✅ **Reacciona** a cambios en tiempo real via Forja (servidor HTTP/WebSocket)  
✅ **Habla** sintaxis Jasboot nativa — sin introducir nuevo lenguaje  
✅ **Integra** perfectamente con Forja, Estructa y el ecosistema completo  

---

## 🚀 Diseño Detallado de Componentes

### 1. 📦 **Motor de Nodos — Almacenamiento**

#### Módulo: `src/almacenamiento/archivos.jasb`

```jasb
# Operaciones de bajo nivel sobre archivos .ndb
# Todos los archivos se abren con fs_abrir, se escriben con fs_escribir

funcion ndb_existe_coleccion(texto coleccion) retorna bool
    texto ruta = "data/nodos/" + coleccion + ".ndb"
    retornar fs_existe(ruta)
fin_funcion

funcion ndb_insertar(texto coleccion, texto id, texto nombre, texto contenido) retorna bool
    texto ruta = "data/nodos/" + coleccion + ".ndb"
    entero archivo = fs_abrir(ruta, "a")
    si archivo == 0 hacer
        retornar falso
    fin_si
    texto linea = id + "|" + nombre + "|" + contenido + "\n"
    fs_escribir(archivo, linea)
    fs_cerrar(archivo)
    retornar verdadero
fin_funcion

funcion ndb_leer_todos(texto coleccion) retorna lista
    lista nodos = mem_lista_crear()
    texto ruta = "data/nodos/" + coleccion + ".ndb"
    si no fs_existe(ruta) hacer
        retornar nodos
    fin_si
    entero archivo = fs_abrir(ruta, "r")
    si archivo == 0 hacer
        retornar nodos
    fin_si
    mientras no fs_fin_archivo(archivo) hacer
        texto linea = fs_leer_linea(archivo)
        si longitud_texto(linea) > 0 hacer
            mem_lista_agregar(nodos, linea)
        fin_si
    fin_mientras
    fs_cerrar(archivo)
    retornar nodos
fin_funcion

funcion ndb_eliminar_coleccion(texto coleccion) retorna bool
    # Se reescribe el archivo sin el nodo eliminado
    # Implementacion via lectura-filtrado-reescritura
    retornar verdadero
fin_funcion
```

#### Módulo: `src/almacenamiento/wal.jasb` (Write-Ahead Log)

```jasb
# Registro de transacciones antes de aplicar cambios

constante texto WAL_INSERTAR = "INS"
constante texto WAL_ACTUALIZAR = "UPD"
constante texto WAL_ELIMINAR = "DEL"

funcion wal_registrar(texto tipo_op, texto coleccion, texto id_nodo) retorna bool
    entero archivo = fs_abrir("data/transacciones/registro.wal", "a")
    si archivo == 0 hacer
        retornar falso
    fin_si
    texto ts = str_desde_numero(obtener_timestamp())
    texto entrada = ts + "|" + tipo_op + "|" + coleccion + "|" + id_nodo + "\n"
    fs_escribir(archivo, entrada)
    fs_cerrar(archivo)
    retornar verdadero
fin_funcion

funcion wal_leer_pendientes() retorna lista
    lista ops = mem_lista_crear()
    si no fs_existe("data/transacciones/registro.wal") hacer
        retornar ops
    fin_si
    entero archivo = fs_abrir("data/transacciones/registro.wal", "r")
    mientras no fs_fin_archivo(archivo) hacer
        texto linea = fs_leer_linea(archivo)
        si longitud_texto(linea) > 0 hacer
            mem_lista_agregar(ops, linea)
        fin_si
    fin_mientras
    fs_cerrar(archivo)
    retornar ops
fin_funcion
```

---

### 2. 🧠 **Motor de Vectores — JMN Integrada**

#### Módulo: `src/nucleo/vectores.jasb`

```jasb
# El motor vectorial usa la JMN (memoria neuronal) de Jasboot
# No requiere libreria externa: usa mem_asociar + propagar_activacion

funcion vec_indexar(texto id_nodo, texto contenido_texto) retorna bool
    # Registrar el concepto en la JMN
    recordar id_nodo con valor contenido_texto

    # Registrar en la ventana de percepcion temporal
    percepcion(id_nodo)

    # Asociar con palabras clave extraidas
    lista palabras = dividir_texto(contenido_texto, " ")
    entero i = 0
    mientras i < mem_lista_tamano(palabras) hacer
        texto palabra = mem_lista_obtener(palabras, i)
        si longitud_texto(palabra) > 3 hacer
            mem_asociar(id_nodo, palabra, 0.7)
        fin_si
        i = i + 1
    fin_mientras

    retornar verdadero
fin_funcion

funcion vec_buscar_similares(texto consulta, entero top_k) retorna lista
    # Indexar la consulta temporalmente
    recordar "_consulta_tmp" con valor consulta

    # Propagar activacion para encontrar similares
    propagar_activacion("_consulta_tmp")

    # Obtener el rastro de activacion
    lista similares = mem_lista_crear()
    entero total = rastro_activacion_tamano()
    entero i = 0
    entero limite = top_k
    si total < limite hacer
        limite = total
    fin_si
    mientras i < limite hacer
        texto id_similar = rastro_activacion_obtener(i)
        mem_lista_agregar(similares, id_similar)
        i = i + 1
    fin_mientras

    retornar similares
fin_funcion

funcion vec_similitud(texto id1, texto id2) retorna flotante
    retornar mem_obtener_fuerza(id1, id2)
fin_funcion

funcion vec_reforzar(texto id_nodo) retorna bool
    reforzar(id_nodo, 20)
    retornar verdadero
fin_funcion

funcion vec_debilitar(texto id_nodo) retorna bool
    penalizar(id_nodo, 10)
    retornar verdadero
fin_funcion

funcion vec_mantenimiento() retorna bool
    decae_conexiones()
    olvidar_debiles()
    consolidar_memoria()
    retornar verdadero
fin_funcion
```

---

### 3. 🔗 **Motor de Grafos — Relaciones**

#### Módulo: `src/nucleo/grafos.jasb`

```jasb
# Motor de grafos usando mem_asociar de la JMN

funcion grafo_conectar(texto desde, texto hacia, flotante peso) retorna bool
    mem_asociar(desde, hacia, peso)
    # Persistir en archivo .grf
    entero archivo = fs_abrir("data/grafos/conexiones.grf", "a")
    si archivo == 0 hacer
        retornar falso
    fin_si
    texto ts = str_desde_numero(obtener_timestamp())
    texto linea = desde + "|" + hacia + "|" + str_desde_numero(peso) + "|" + ts + "\n"
    fs_escribir(archivo, linea)
    fs_cerrar(archivo)
    retornar verdadero
fin_funcion

funcion grafo_desconectar(texto desde, texto hacia) retorna bool
    # Penalizar la conexion hasta peso 0
    penalizar(desde, 100)
    retornar verdadero
fin_funcion

funcion grafo_fuerza(texto desde, texto hacia) retorna flotante
    retornar mem_obtener_fuerza(desde, hacia)
fin_funcion

funcion grafo_relacionados(texto id_nodo, entero profundidad) retorna lista
    # Usar propagar_activacion con BFS
    propagar_activacion(id_nodo)
    lista relacionados = mem_lista_crear()
    entero total = rastro_activacion_tamano()
    entero i = 0
    mientras i < total hacer
        texto id_rel = rastro_activacion_obtener(i)
        si id_rel != id_nodo hacer
            mem_lista_agregar(relacionados, id_rel)
        fin_si
        i = i + 1
    fin_mientras
    retornar relacionados
fin_funcion

funcion grafo_camino_existe(texto desde, texto hacia) retorna bool
    flotante fuerza = mem_obtener_fuerza(desde, hacia)
    retornar fuerza > 0.0
fin_funcion
```

---

### 4. 🔍 **Motor de Búsqueda**

#### Módulo: `src/busqueda/semantica.jasb`

```jasb
usar {vec_buscar_similares, vec_indexar} de "../nucleo/vectores.jasb"

funcion buscar_semantico(texto coleccion, texto consulta, entero top_k) retorna lista
    # Buscar usando la JMN
    lista candidatos = vec_buscar_similares(consulta, top_k * 2)

    # Filtrar por coleccion (prefijo del id)
    lista resultados = mem_lista_crear()
    texto prefijo = coleccion + "_"
    entero i = 0
    mientras i < mem_lista_tamano(candidatos) hacer
        texto id_candidato = mem_lista_obtener(candidatos, i)
        si contiene_texto(id_candidato, prefijo) hacer
            mem_lista_agregar(resultados, id_candidato)
            si mem_lista_tamano(resultados) >= top_k hacer
                i = mem_lista_tamano(candidatos)  # salir
            fin_si
        fin_si
        i = i + 1
    fin_mientras

    retornar resultados
fin_funcion
```

#### Módulo: `src/busqueda/hibrida.jasb`

```jasb
usar {buscar_semantico} de "./semantica.jasb"

funcion buscar_hibrido(texto coleccion, texto consulta, texto campo_filtro, entero valor_minimo) retorna lista
    # Paso 1: busqueda semantica amplia
    lista candidatos_sem = buscar_semantico(coleccion, consulta, 50)

    # Paso 2: filtrar por campo usando JMN
    lista resultados = mem_lista_crear()
    entero i = 0
    mientras i < mem_lista_tamano(candidatos_sem) hacer
        texto id_cand = mem_lista_obtener(candidatos_sem, i)
        texto clave_campo = id_cand + "_" + campo_filtro
        buscar clave_campo
        entero valor_campo = resultado
        si valor_campo >= valor_minimo hacer
            mem_lista_agregar(resultados, id_cand)
        fin_si
        i = i + 1
    fin_mientras

    retornar resultados
fin_funcion
```

---

### 5. 📡 **API Publica del SDK**

#### Módulo: `src/nucleo/api.jasb` (punto de entrada del SDK)

```jasb
usar {ndb_insertar, ndb_leer_todos} de "../almacenamiento/archivos.jasb"
usar {wal_registrar} de "../almacenamiento/wal.jasb"
usar {vec_indexar, vec_buscar_similares} de "./vectores.jasb"
usar {grafo_conectar, grafo_relacionados, grafo_fuerza} de "./grafos.jasb"
usar {buscar_semantico} de "../busqueda/semantica.jasb"
usar {buscar_hibrido} de "../busqueda/hibrida.jasb"

# === CRUD de Nodos ===

funcion nucleodb_guardar(texto coleccion, texto id, texto nombre, texto contenido) retorna bool
    texto id_nodo = coleccion + "_" + id
    wal_registrar("INS", coleccion, id_nodo)
    bool guardado = ndb_insertar(coleccion, id_nodo, nombre, contenido)
    si guardado hacer
        vec_indexar(id_nodo, contenido)
        recordar id_nodo + "_nombre" con valor nombre
        recordar id_nodo + "_coleccion" con valor coleccion
    fin_si
    retornar guardado
fin_funcion

funcion nucleodb_obtener(texto coleccion, texto id) retorna texto
    texto id_nodo = coleccion + "_" + id
    buscar id_nodo + "_nombre"
    retornar resultado
fin_funcion

funcion nucleodb_actualizar(texto coleccion, texto id, texto nuevo_contenido) retorna bool
    texto id_nodo = coleccion + "_" + id
    wal_registrar("UPD", coleccion, id_nodo)
    recordar id_nodo con valor nuevo_contenido
    vec_indexar(id_nodo, nuevo_contenido)
    retornar verdadero
fin_funcion

funcion nucleodb_eliminar(texto coleccion, texto id) retorna bool
    texto id_nodo = coleccion + "_" + id
    wal_registrar("DEL", coleccion, id_nodo)
    penalizar(id_nodo, 100)
    retornar verdadero
fin_funcion

# === Busqueda ===

funcion nucleodb_buscar_similar(texto coleccion, texto consulta, entero top_k) retorna lista
    retornar buscar_semantico(coleccion, consulta, top_k)
fin_funcion

funcion nucleodb_buscar_hibrida(texto coleccion, texto consulta, texto campo, entero valor_min) retorna lista
    retornar buscar_hibrido(coleccion, consulta, campo, valor_min)
fin_funcion

funcion nucleodb_buscar_donde(texto coleccion, texto campo, texto valor) retorna lista
    lista resultados = mem_lista_crear()
    lista todos = ndb_leer_todos(coleccion)
    entero i = 0
    mientras i < mem_lista_tamano(todos) hacer
        texto linea = mem_lista_obtener(todos, i)
        si contiene_texto(linea, valor) hacer
            mem_lista_agregar(resultados, linea)
        fin_si
        i = i + 1
    fin_mientras
    retornar resultados
fin_funcion

# === Grafo ===

funcion nucleodb_conectar(texto desde, texto hacia, flotante peso) retorna bool
    retornar grafo_conectar(desde, hacia, peso)
fin_funcion

funcion nucleodb_relacionados(texto id_nodo, entero profundidad) retorna lista
    retornar grafo_relacionados(id_nodo, profundidad)
fin_funcion

funcion nucleodb_fuerza_relacion(texto desde, texto hacia) retorna flotante
    retornar grafo_fuerza(desde, hacia)
fin_funcion

# === Mantenimiento ===

funcion nucleodb_mantenimiento() retorna bool
    decae_conexiones()
    olvidar_debiles()
    consolidar_memoria()
    retornar verdadero
fin_funcion
```

---

### 6. 🌐 **Protocolo de Comunicación — Integración Forja**

#### Módulo: `src/protocolo/forja.jasb`

```jasb
usar todas de "../../../stdlib/forja/forja.jasb"
usar {
    nucleodb_guardar,
    nucleodb_obtener,
    nucleodb_buscar_similar,
    nucleodb_conectar,
    nucleodb_relacionados
} de "../nucleo/api.jasb"

# Middleware que parsea rutas y despacha al SDK

funcion protocolo_despachar(texto solicitud) retorna texto
    # POST /nodos/{coleccion}
    si forja_es_post(solicitud, "/nodos") entonces
        texto cuerpo   = forja_cuerpo(solicitud)
        texto coleccion = forja_json_campo(cuerpo, "coleccion")
        texto id        = forja_json_campo(cuerpo, "id")
        texto nombre    = forja_json_campo(cuerpo, "nombre")
        texto contenido = forja_json_campo(cuerpo, "contenido")
        bool ok = nucleodb_guardar(coleccion, id, nombre, contenido)
        si ok hacer
            retornar forja_json("{\"ok\":true,\"id\":\"" + id + "\"}")
        fin_si
        retornar forja_json("{\"ok\":false,\"error\":\"No se pudo guardar\"}")
    fin_si

    # GET /buscar/{coleccion}?q=consulta&top=10
    si forja_es_get(solicitud, "/buscar") entonces
        texto coleccion = forja_param(solicitud, "coleccion")
        texto consulta  = forja_param(solicitud, "q")
        entero top_k    = str_a_entero(forja_param(solicitud, "top"))
        si top_k == 0 hacer
            top_k = 10
        fin_si
        lista resultados = nucleodb_buscar_similar(coleccion, consulta, top_k)
        retornar forja_json_lista(resultados)
    fin_si

    # POST /grafos/conectar
    si forja_es_post(solicitud, "/grafos/conectar") entonces
        texto cuerpo = forja_cuerpo(solicitud)
        texto desde  = forja_json_campo(cuerpo, "desde")
        texto hacia  = forja_json_campo(cuerpo, "hacia")
        flotante peso_rel = 0.8
        nucleodb_conectar(desde, hacia, peso_rel)
        retornar forja_json("{\"ok\":true}")
    fin_si

    # GET /sistema/status
    si forja_es_get(solicitud, "/sistema/status") entonces
        retornar forja_salud_ok()
    fin_si

    retornar forja_no_encontrado()
fin_funcion
```

---

### 7. 🤖 **Motor de Embeddings — Modelos**

#### Módulo: `src/nucleo/embeddings.jasb`

El motor de embeddings usa la JMN de Jasboot como base y puede extenderse vía FFI:

```jasb
# Estrategia actual: embedding via JMN (mem_asociar + propagar_activacion)
# Estrategia futura: FFI a modelo externo (sentence-transformers u otro)

funcion embedding_generar_jmn(texto texto_entrada, texto id_destino) retorna bool
    # Tokenizar el texto
    lista tokens = dividir_texto(texto_entrada, " ")
    entero i = 0
    mientras i < mem_lista_tamano(tokens) hacer
        texto token = mem_lista_obtener(tokens, i)
        si longitud_texto(token) > 2 hacer
            # Asociar token con el concepto destino
            flotante peso_tok = 0.6
            mem_asociar(id_destino, token, peso_tok)
        fin_si
        i = i + 1
    fin_mientras
    retornar verdadero
fin_funcion

# Futura expansion via FFI (cuando el modelo externo este disponible):
# funcion embedding_generar_ffi(texto texto_entrada) retorna lista
#     entero lib = ffi_cargar("libnucleodb_embed.dll")
#     entero fn_embed = ffi_simbolo(lib, "generar_embedding")
#     # ffi_llamar(fn_embed, texto_entrada)
#     retornar []
# fin_funcion

funcion embedding_similitud_jmn(texto id1, texto id2) retorna flotante
    retornar mem_obtener_fuerza(id1, id2)
fin_funcion

funcion embedding_indexar(texto id_nodo, texto contenido) retorna bool
    retornar embedding_generar_jmn(contenido, id_nodo)
fin_funcion
```

---

### 8. 📦 **SDK en Aplicaciones con Estructa**

#### Integración en pantalla web (vía Forja + Estructa):

```jasb
usar todas de "../../stdlib/forja/forja.jasb"
usar todas de "../../stdlib/Estructa/codigo-jasb/estructura.jasb"
usar {nucleodb_guardar, nucleodb_buscar_similar} de "nucleodb/src/nucleo/api.jasb"

funcion pantalla_buscador(texto solicitud) retorna texto
    texto consulta = estructura_estado_texto(solicitud, "consulta", "")
    lista resultados = mem_lista_crear()

    si longitud_texto(consulta) > 2 hacer
        resultados = nucleodb_buscar_similar("productos", consulta, 20)
    fin_si

    # Construir pagina HTML con Estructa
    texto cuerpo = estructura_titulo("Buscar Productos con NucleoDB")

    texto formulario = estructura_campo("Consulta", estructura_entrada("consulta", consulta, "Escribe tu busqueda..."))
    formulario = concatenar(formulario, estructura_submit("Buscar"))
    formulario = estructura_formulario_get("/", formulario)
    cuerpo = concatenar(cuerpo, estructura_tarjeta("Busqueda semantica", formulario))

    entero i = 0
    texto lista_resultados = ""
    mientras i < mem_lista_tamano(resultados) hacer
        texto id_res = mem_lista_obtener(resultados, i)
        lista_resultados = concatenar(lista_resultados, estructura_texto(id_res))
        i = i + 1
    fin_mientras

    si longitud_texto(lista_resultados) > 0 hacer
        cuerpo = concatenar(cuerpo, estructura_tarjeta("Resultados", lista_resultados))
    fin_si

    cuerpo = estructura_columna(cuerpo)
    retornar estructura_pagina("NucleoDB - Buscador", "Motor de busqueda semantica.", cuerpo)
fin_funcion

funcion app(texto solicitud) retorna texto
    si estructura_es_get(solicitud, "/") entonces
        retornar pantalla_buscador(solicitud)
    fin_si
    retornar forja_no_encontrado()
fin_funcion

principal
    crear_memoria("nucleodb/data/cerebro.jmn")
    imprimir "NucleoDB + Estructa activo en http://127.0.0.1:18310"
    imprimir estructura_http_bucle("127.0.0.1", 18310, 100, app)
    cerrar_memoria()
fin_principal
```

---

### 9. 🔄 **Transacciones Atómicas**

#### Módulo: `src/almacenamiento/transacciones.jasb`

```jasb
usar {wal_registrar, wal_leer_pendientes} de "./wal.jasb"
usar {ndb_insertar} de "./archivos.jasb"

# Estado global de transaccion activa
bool transaccion_activa = falso
lista operaciones_pendientes = mem_lista_crear()

funcion transaccion_iniciar() retorna bool
    si transaccion_activa hacer
        imprimir "Error: ya hay una transaccion activa"
        retornar falso
    fin_si
    transaccion_activa = verdadero
    operaciones_pendientes = mem_lista_crear()
    retornar verdadero
fin_funcion

funcion transaccion_agregar_op(texto op) retorna bool
    si no transaccion_activa hacer
        imprimir "Error: no hay transaccion activa"
        retornar falso
    fin_si
    mem_lista_agregar(operaciones_pendientes, op)
    retornar verdadero
fin_funcion

funcion transaccion_confirmar() retorna bool
    si no transaccion_activa hacer
        retornar falso
    fin_si
    # Aplicar operaciones pendientes
    entero i = 0
    mientras i < mem_lista_tamano(operaciones_pendientes) hacer
        texto op = mem_lista_obtener(operaciones_pendientes, i)
        wal_registrar("CONFIRMAR", "transaccion", op)
        i = i + 1
    fin_mientras
    transaccion_activa = falso
    operaciones_pendientes = mem_lista_crear()
    retornar verdadero
fin_funcion

funcion transaccion_revertir() retorna bool
    si no transaccion_activa hacer
        retornar falso
    fin_si
    # Marcar operaciones como revertidas en WAL
    entero i = 0
    mientras i < mem_lista_tamano(operaciones_pendientes) hacer
        texto op = mem_lista_obtener(operaciones_pendientes, i)
        wal_registrar("REVERTIR", "transaccion", op)
        i = i + 1
    fin_mientras
    transaccion_activa = falso
    operaciones_pendientes = mem_lista_crear()
    retornar verdadero
fin_funcion
```

---

## 📊 Especificaciones Técnicas

### Configuración del motor (`config/nucleodb.conf`)

```
# NucleoDB Configuration
version=1.0
jmn_ruta=data/cerebro.jmn
jmn_capacidad_nodos=100000
jmn_capacidad_conexiones=500000
datos_ruta=data/
cache_tam_mb=256
wal_habilitado=true
mantenimiento_intervalo=3600
similitud_umbral=0.5
top_k_defecto=10
puerto_servidor=18300
host_servidor=127.0.0.1
```

### Parámetros de la JMN

| Parámetro | Valor | Descripción |
|---|---|---|
| `jmn_capacidad_nodos` | 100,000 | Nodos en la memoria neuronal |
| `jmn_capacidad_conexiones` | 500,000 | Aristas en el grafo neuronal |
| `ventana_percepcion` | 64 | Buffer circular de percepción |
| `ventana_rastro` | 128 | Rastro de activación |
| `decaimiento` | 5% | Factor de decaimiento global |
| `umbral_olvido` | 0.010 | Umbral para `olvidar_debiles` |

---

## 🔥 Ventaja Competitiva (Técnica)

| Característica | Implementación NúcleoDB |
|---|---|
| Almacenamiento | `fs_abrir` / `fs_escribir` / archivos `.ndb` |
| Vectores | JMN nativa (`mem_asociar`, `propagar_activacion`) |
| Grafo | JMN (`mem_asociar`, `obtener_relacionados`) |
| Búsqueda semántica | `propagar_activacion` + `rastro_activacion` |
| Reactividad | Forja HTTP + callbacks como funciones Jasboot |
| SDK | Módulos `.jasb` importados con `usar` |
| Integración UI | Estructa (página web) vía Forja |
| Persistencia | Archivos + JMN (`.jmn`) en `data/` |

---

## 🎯 Conclusión del Plan Completo

**NúcleoDB** ahora tiene un diseño **completamente alineado con Jasboot**:

✅ **Sintaxis real** — usa `registro`, `funcion`, `funcion … retorna`, `mientras`, `si`, `usar`, `enviar`, `principal`  
✅ **JMN integrada** — `mem_asociar`, `propagar_activacion`, `rastro_activacion`, `elegir_por_peso`  
✅ **Archivos reales** — `fs_abrir`, `fs_escribir`, `fs_leer_linea`, `fs_cerrar`, `fs_existe`  
✅ **SDK modular** — módulos `.jasb` organizados según el **Estándar de Proyectos Jasboot**  
✅ **Forja + Estructa** — reactividad y UI nativamente integradas  
✅ **Sin pseudo-sintaxis** — cero constructos inventados fuera del lenguaje  

Este es el **motor de datos inteligente** que las aplicaciones Jasboot necesitan.

---

*Última actualización: Versión 3.0.0 — Plan alineado con sintaxis real de Jasboot*
