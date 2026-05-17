# Diagrama Completo de Conexiones Neuronales en Jasboot

Este documento presenta un diagrama completo en formato Mermaid de la arquitectura de conexiones neuronales en el lenguaje Jasboot, incluyendo la estructura de datos, tipos de relación y flujo de información.

---

## 1. Arquitectura General del Sistema Neuronal

```mermaid
graph TB
    subgraph Aplicacion_Jasboot["Aplicación Jasboot (.jasb)"]
        APP["Código Jasboot"]
        API["API JMN: recordar, buscar, asociar"]
    end

    subgraph VM_Jasboot["Máquina Virtual Jasboot"]
        OPCODES["Opcodes JMN"]
        MEM["Memoria RAM"]
    end

    subgraph JMN_Capa["JMN - Memoria de Largo Plazo (Persistente)"]
        NODOS["Nodos de Concepto<br/>ID + Peso"]
        CONEX["Conexiones<br/>Destino + Tipo + Fuerza"]
        TEXTOS["Textos Asociados"]
    end

    subgraph MAI_Capa["MAI - Memoria Activa (Córtex Dinámico)"]
        NEURONAS["Neuronas Activas<br/>Estado Energético"]
        SEÑALES["Señales: Activación<br/>Inhibición, Refuerzo"]
        COLAS["Colas de Prioridad"]
    end

    subgraph Persistencia["Persistencia en Disco"]
        JMN_FILE["archivo.jmn<br/>Snapshot Binario"]
        JWL_FILE["archivo.jmn.jwl<br/>Journal Append-Only"]
    end

    APP -->|Llamadas| API
    API -->|Opcodes| OPCODES
    OPCODES -->|Acceso| MEM
    MEM <-->|Mapeo| NODOS
    MEM <-->|Mapeo| CONEX
    MEM <-->|Mapeo| TEXTOS
    
    NODOS -.->|Reflexión<br/>Carga| NEURONAS
    NEURONAS -->|Señales| SEÑALES
    SEÑALES -->|Refuerzo| CONEX
    SEÑALES -->|Activación| NEURONAS
    
    NODOS -->|Snapshot| JMN_FILE
    CONEX -->|Snapshot| JMN_FILE
    TEXTOS -->|Snapshot| JMN_FILE
    
    OPCODES -->|Registro| JWL_FILE
    JWL_FILE -->|Replay| NODOS
    JWL_FILE -->|Replay| CONEX

    style JMN_Capa fill:#e1f5ff,stroke:#01579b,stroke-width:3px
    style MAI_Capa fill:#fff3e0,stroke:#e65100,stroke-width:3px
    style Persistencia fill:#f3e5f5,stroke:#4a148c,stroke-width:3px
```

---

## 2. Estructura de Datos C (Nodos y Conexiones)

```mermaid
classDiagram
    class JMNMemoria {
        +uint32_t cap_nodos
        +uint32_t cap_conexiones
        +uint32_t num_nodos
        +uint32_t num_conexiones
        +bool es_ram
        +bool dirty
        +JMNNodo* nodos
        +JMNConexion* conexiones
        +uint32_t* cabeza_origen
    }

    class JMNNodo {
        +uint32_t id
        +JMNValor peso
    }

    class JMNConexion {
        +uint32_t destino_id
        +uint32_t key_id
        +JMNValor fuerza
        +uint32_t origen_id
        +bool used
        +uint32_t next_origen
    }

    class JMNValor {
        +uint32_t u
        +float f
    }

    class JMNBusquedaResultado {
        +uint32_t id
        +uint32_t tipo_relacion
        +float fuerza
    }

    JMNMemoria "1" *-- "n" JMNNodo : contiene
    JMNMemoria "1" *-- "n" JMNConexion : contiene
    JMNNodo "1" *-- "1" JMNValor : peso
    JMNConexion "1" *-- "1" JMNValor : fuerza
    JMNMemoria --> JMNBusquedaResultado : retorna

    note for JMNNodo "ID = hash(texto)<br/>Peso = 0.0 a 1.0"
    note for JMNConexion "key_id = tipo relación (1-30)<br/>fuerza = 0.0 a 1.0<br/>origen_id = bucket hash"
```

---

## 3. Taxonomía Completa de los 30 Tipos de Relación

```mermaid
mindmap
  root((Tipos de Relación JMN))
    Semántica Básica
      (1) ASOCIACIÓN
      (2) PATRÓN
      (3) SECUENCIA
      (4) SIMILITUD
      (5) OPOSICIÓN
    Estructura y Taxonomía
      (6) PERTENENCIA
      (13) PARTE_DE
      (16) INSTANCIA
      (23) CALIFICACIÓN
    Causalidad y Lógica
      (7) CAUSALIDAD
      (14) CONSECUENCIA
      (15) CONDICIÓN
      (30) REFERENCIA
    Temporalidad
      (8) TEMPORALIDAD
    Intención y Valor
      (9) INTENCIÓN
      (10) VALORACIÓN
    Espacio y Ubicación
      (11) UBICACIÓN
      (29) SITUACIÓN
    Propiedades y Atributos
      (12) PROPIEDAD
      (20) MAGNITUD
      (21) FRECUENCIA
    Relaciones Sociales
      (17) POSESIÓN
      (22) PARENTESCO
    Funcionalidad
      (18) FUNCIONALIDAD
      (24) ACCIÓN
      (25) COMPLEMENTO
    Evidencia y Medición
      (19) EVIDENCIA
      (26) CUANTIFICACIÓN
      (27) MEDIDA
    Operadores
      (28) OPERADOR
```

---

## 4. Flujo de Información entre Capas (JMN ↔ MAI)

```mermaid
sequenceDiagram
    participant App as Aplicación Jasboot
    participant VM as Máquina Virtual
    participant JMN as JMN (Persistente)
    participant MAI as MAI (Activa)
    participant Disco as Disco (.jmn/.jwl)

    App->>VM: recordar("agua", "H2O")
    VM->>JMN: jmn_agregar_nodo(id_agua)
    VM->>JMN: jmn_guardar_texto(id_agua, "agua")
    VM->>JMN: jmn_journal_op_nodo()
    JMN->>Disco: Append a .jwl
    
    App->>VM: asociar_relacion("agua", "vida", 1, 0.95)
    VM->>JMN: jmn_agregar_conexion(orig, dest, fuerza, tipo)
    VM->>JMN: jmn_journal_op_conex()
    JMN->>Disco: Append a .jwl
    
    Note over MAI: Fase de Reflexión
    JMN->>MAI: Cargar nodo en neurona activa
    MAI->>MAI: Calcular estado energético
    MAI->>MAI: Propagar activación
    
    MAI->>JMN: Señal de refuerzo (Hebb)
    VM->>JMN: jmn_reforzar_concepto(id, delta)
    JMN->>Disco: Actualizar peso
    
    Note over JMN,Disco: Fase de Sueño
    App->>VM: consolidar_sueno()
    VM->>JMN: jmn_decaer_conexiones_global()
    VM->>JMN: jmn_olvidar_conexiones_debiles()
    VM->>JMN: jmn_consolidar_conexiones_supervivientes()
    JMN->>Disco: Guardar snapshot .jmn
    Disco->>JMN: Truncar .jwl (checkpoint)
    
    App->>VM: cerrar_memoria()
    VM->>JMN: jmn_finalizar_escritura()
    JMN->>Disco: Sincronizar disco
```

---

## 5. Ejemplo Práctico: Red de Conceptos "Café"

```mermaid
graph LR
    subgraph Nodos["Nodos de Concepto"]
        CAFE["café"]
        AGUA["agua"]
        GRANO["grano"]
        BEBIDA["bebida"]
        ENERGIA["energía"]
        MAÑANA["mañana"]
        CALIENTE["caliente"]
        OSCURO["oscuro"]
    end

    subgraph Tipos["Tipos de Relación"]
        T1["1: ASOCIACIÓN"]
        T3["3: SECUENCIA"]
        T6["6: PERTENENCIA"]
        T7["7: CAUSALIDAD"]
        T8["8: TEMPORALIDAD"]
        T12["12: PROPIEDAD"]
    end

    CAFE -- "0.95<br/>ASOCIACIÓN" --> AGUA
    CAFE -- "0.90<br/>ASOCIACIÓN" --> GRANO
    CAFE -- "1.00<br/>PERTENENCIA" --> BEBIDA
    CAFE -- "0.85<br/>CAUSALIDAD" --> ENERGIA
    CAFE -- "0.70<br/>TEMPORALIDAD" --> MAÑANA
    CAFE -- "0.80<br/>PROPIEDAD" --> CALIENTE
    CAFE -- "0.75<br/>PROPIEDAD" --> OSCURO

    AGUA -.->|Componente| CAFE
    GRANO -.->|Origen| CAFE

    style CAFE fill:#8B4513,stroke:#000,stroke-width:3px,color:#fff
    style AGUA fill:#4169E1,stroke:#000,stroke-width:2px,color:#fff
    style GRANO fill:#D2691E,stroke:#000,stroke-width:2px,color:#fff
```

---

## 6. Sistema de Journal y Recuperación

```mermaid
graph TB
    subgraph Operación["Operación JMN"]
        OP1["1: Agregar Nodo"]
        OP2["2: Agregar Conexión"]
        OP3["3: Guardar Texto"]
        OPFF["0xFF: Commit"]
    end

    subgraph Journal[".jwl (Append-Only)"]
        ENTRY1["Entry: nodo + id + peso"]
        ENTRY2["Entry: conex + ori + dest + tipo + fuerza"]
        ENTRY3["Entry: texto + id + len + payload"]
        COMMIT["Commit Marker"]
    end

    subgraph Snapshot[".jmn (Snapshot Binario)"]
        HEADER["Header + Magic + Version"]
        NODOS_BLK["Bloque de Nodos"]
        CONEX_BLK["Bloque de Conexiones"]
        TEXT_BLK["Bloque de Textos"]
        CHECKSUM["Checksum"]
    end

    subgraph Recuperación["Recuperación (si .jmn falla)"]
        REPLAY["Replay desde .jwl"]
        RECONSTRUIR["Reconstruir estado"]
        VALIDAR["Validar integridad"]
    end

    OP1 -->|Journal| ENTRY1
    OP2 -->|Journal| ENTRY2
    OP3 -->|Journal| ENTRY3
    OPFF -->|Journal| COMMIT
    
    ENTRY1 -->|Checkpoint| NODOS_BLK
    ENTRY2 -->|Checkpoint| CONEX_BLK
    ENTRY3 -->|Checkpoint| TEXT_BLK
    
    NODOS_BLK -->|Si corrupto| REPLAY
    CONEX_BLK -->|Si corrupto| REPLAY
    TEXT_BLK -->|Si corrupto| REPLAY
    
    ENTRY1 -->|Replay| RECONSTRUIR
    ENTRY2 -->|Replay| RECONSTRUIR
    ENTRY3 -->|Replay| RECONSTRUIR
    
    RECONSTRUIR --> VALIDAR
    VALIDAR -->|Éxito| NODOS_BLK

    style Journal fill:#fff9c4,stroke:#f57f17,stroke-width:2px
    style Snapshot fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
    style Recuperacion fill:#ffebee,stroke:#c62828,stroke-width:2px
```

---

## 7. Proceso de Consolidación (Sueño)

```mermaid
flowchart TD
    START["Inicio: consolidar_sueno()"] --> PARAMS["Parámetros:<br/>factor=0.45, umbral=0.04<br/>pasadas=1, boost=0.03"]
    
    PARAMS --> DECAER["Decaimiento Global<br/>jmn_decaer_conexiones_global()<br/>peso *= (1 - factor)"]
    
    DECAER --> OLVIDAR["Olvido de Débiles<br/>jmn_olvidar_conexiones_debiles()<br/>si peso < umbral: peso = 0"]
    
    OLVIDAR --> SUPERV["Supervivientes<br/>Conexiones con peso >= umbral"]
    
    SUPERV --> BOOST["Refuerzo Relativo<br/>jmn_consolidar_conexiones_supervivientes()<br/>peso *= (1 + boost)"]
    
    BOOST --> NORMALIZAR["Normalización<br/>Clamp pesos a [0.0, 1.0]"]
    
    NORMALIZAR --> GUARDAR["Guardar Snapshot<br/>jmn_finalizar_escritura()"]
    
    GUARDAR --> TRUNCAR["Truncar Journal<br/>jmn_journal_truncate()<br/>si JASBOOT_JWL_CHECKPOINT=1"]
    
    TRUNCAR --> END["Fin: Memoria consolidada"]

    style DECAER fill:#ffcdd2,stroke:#c62828,stroke-width:2px
    style OLVIDAR fill:#ffebee,stroke:#c62828,stroke-width:2px
    style BOOST fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px
    style GUARDAR fill:#bbdefb,stroke:#1565c0,stroke-width:2px
```

---

## 8. Mapeo de Funciones Jasboot → C

```mermaid
graph LR
    subgraph Jasboot["Lenguaje Jasboot"]
        J1["crear_memoria()"]
        J2["recordar()"]
        J3["buscar()"]
        J4["asociar_relacion()"]
        J5["buscar_asociados_lista()"]
        J6["consolidar_memoria()"]
        J7["cerrar_memoria()"]
    end

    subgraph C_API["API C (memoria_neuronal.h)"]
        C1["jmn_abrir_escritura()"]
        C2["jmn_agregar_nodo()<br/>jmn_guardar_texto()"]
        C3["jmn_obtener_nodo()<br/>jmn_obtener_texto()"]
        C4["jmn_agregar_conexion()"]
        C5["jmn_buscar_asociaciones()"]
        C6["jmn_consolidar_memoria_sueno()"]
        C7["jmn_cerrar()"]
    end

    subgraph VM["Máquina Virtual"]
        OP1["OP_MEM_CREAR"]
        OP2["OP_MEM_RECORDAR"]
        OP3["OP_MEM_BUSCAR"]
        OP4["OP_MEM_ASOCIAR"]
        OP5["OP_MEM_BUSCAR_ASOC"]
        OP6["OP_MEM_CONSOLIDAR"]
        OP7["OP_MEM_CERRAR"]
    end

    J1 -->|Compilador| OP1
    J2 -->|Compilador| OP2
    J3 -->|Compilador| OP3
    J4 -->|Compilador| OP4
    J5 -->|Compilador| OP5
    J6 -->|Compilador| OP6
    J7 -->|Compilador| OP7

    OP1 -->|Runtime| C1
    OP2 -->|Runtime| C2
    OP3 -->|Runtime| C3
    OP4 -->|Runtime| C4
    OP5 -->|Runtime| C5
    OP6 -->|Runtime| C6
    OP7 -->|Runtime| C7

    style Jasboot fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    style C_API fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px
    style VM fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
```

---

## 9. Ejemplo Completo: Secuencia de Oración

```mermaid
graph TB
    subgraph Patrón["Neurona Maestra de Patrón"]
        MASTER((Patrón:<br/>"me gusta el café"))
    end

    subgraph Secuencia["Nodos de Secuencia"]
        S1["me"]
        S2["gusta"]
        S3["el"]
        S4["café"]
    end

    subgraph ConexionesHorizontales["Conexiones de Secuencia (Tipo 3)"]
        C1["me → gusta<br/>peso: 0.60"]
        C2["gusta → el<br/>peso: 0.48"]
        C3["el → café<br/>peso: 0.48"]
    end

    subgraph ConexionesVerticales["Conexiones de Patrón (Tipo 2)"]
        V1["Patrón → me<br/>peso: 0.50"]
        V2["Patrón → gusta<br/>peso: 0.50"]
        V3["Patrón → el<br/>peso: 0.50"]
        V4["Patrón → café<br/>peso: 0.50"]
    end

    MASTER -.->|PATRÓN| S1
    MASTER -.->|PATRÓN| S2
    MASTER -.->|PATRÓN| S3
    MASTER -.->|PATRÓN| S4

    S1 -->|SECUENCIA| S2
    S2 -->|SECUENCIA| S3
    S3 -->|SECUENCIA| S4

    style MASTER fill:#9c27b0,stroke:#4a148c,stroke-width:4px,color:#fff
    style Secuencia fill:#e1bee7,stroke:#4a148c,stroke-width:2px
```

---

## 10. Resumen de Arquitectura

```mermaid
graph TB
    subgraph Nivel1["Nivel 1: Aplicación"]
        CODE["Código Jasboot"]
    end

    subgraph Nivel2["Nivel 2: Máquina Virtual"]
        VM["VM Jasboot"]
        OPCODES["Opcodes JMN"]
    end

    subgraph Nivel3["Nivel 3: Memoria Neuronal"]
        JMN["JMN Core C"]
        ESTRUCTURAS["Estructuras de Datos<br/>Nodos, Conexiones"]
    end

    subgraph Nivel4["Nivel 4: Persistencia"]
        JMN_FILE["archivo.jmn"]
        JWL_FILE["archivo.jwl"]
    end

    CODE --> VM
    VM --> OPCODES
    OPCODES --> JMN
    JMN --> ESTRUCTURAS
    ESTRUCTURAS --> JMN_FILE
    ESTRUCTURAS --> JWL_FILE

    style Nivel1 fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    style Nivel2 fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    style Nivel3 fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px
    style Nivel4 fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
```

---

## Referencias

- **Documentación JMN**: `docs/LENGUAJE/jmn/`
- **Tipos de Relación**: `docs/LENGUAJE/TIPOS_RELACION_JMN.md`
- **API C**: `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal/memoria_neuronal.h`
- **Estructura Conexiones**: `docs/ESTRUCTURA_CONEXIONES_NEURONALES.md`
- **Journal**: `docs/LENGUAJE/jmn/JMN_JOURNAL_Y_CONSOLIDACION.md`

---

**Fecha de creación**: 2026-05-14  
**Versión**: 1.0  
**Autor**: AI Agent (Cascade)  
**Proyecto**: Jasboot Programming Language
