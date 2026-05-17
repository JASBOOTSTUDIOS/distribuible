# 🧠 Memoria Activa Independiente - Diseño Arquitectónico

> **Propósito**: Sistema de memoria activa con neuronas como procesadores independientes, sincronizado con JMN base sin modificar su estructura.

---

## 🎯 Concepto Fundamental

### **🏗️ Sistema Dual de Memoria**

```
┌─────────────────┐    ┌─────────────────┐
│   JMN Base    │    │ Memoria Activa │
│ (Persistente)   │    │ (Temporal)     │
│                │    │                │
│ • Conceptos    │    │ • Procesadores │
│ • Asociaciones │    │ • Estado Actual │
│ • Pesos Fijos │    │ • Computación   │
└─────────────────┘    └─────────────────┘
```

**Características Clave:**

- **JMN Base**: Almacenamiento persistente, solo lectura para memoria activa
- **Memoria Activa**: Procesamiento en tiempo real, estado temporal
- **Sincronización**: Comunicación bidireccional controlada
- **Independencia**: Cada neurona como procesador autónomo

---

## 🔍 Estructura de Neurona Activa

### **📋 Definición de Estructura**

```c
typedef struct {
    // --- Identificación (compatible con JMN) ---
    uint32_t id_hash;           // ID único (mismo hash que JMN)
    char* texto_concepto;       // Texto legible del concepto

    // --- Estado de Procesamiento ---
    float estado_actual;           // Nivel de activación actual (0.0 - 1.0)
    float potencial_membrana;     // Potencial eléctrico simulado
    uint32_t timestamp_ultima;    // Última actualización en microsegundos
    uint32_t periodo_refractario; // Tiempo de recuperación antes de volver a activarse
    uint8_t estado_refractario;  // 1 = en período refractario

    // --- Procesador Independiente ---
    float (*procesar_entrada)(float* entradas, int num_entradas);
    float (*funcion_activacion)(float entrada);
    void (*propagar_salida)(float salida, uint32_t* destinos, int num_destinos);

    // --- Memoria Local Temporal ---
    float* memoria_local;         // Memoria privada de la neurona
    uint32_t tam_memoria_local;  // Tamaño de memoria local
    float contexto_actual[10];    // Buffer de contexto reciente (últimas 10 activaciones)
    uint32_t indice_contexto;    // Índice circular para buffer

    // --- Metadatos de Procesamiento ---
    uint32_t ciclos_procesados; // Total de ciclos ejecutados
    float eficiencia_promedio;    // Eficiencia promedio de procesamiento
    uint32_t timestamp_creacion;  // Cuándo se creó esta instancia activa

} NeuronaActiva;
```

### **🔧 Funciones de Procesamiento**

```c
// Función de activación sigmoide (suave y diferenciable)
float funcion_sigmoide(float entrada) {
    return 1.0f / (1.0f + exp(-entrada));
}

// Función ReLU (simple y eficiente)
float funcion_relu(float entrada) {
    return entrada > 0.0f ? entrada : 0.0f;
}

// Función tangente hiperbólica (centrada en 0)
float funcion_tanh(float entrada) {
    return tanh(entrada);
}

// Procesador principal de entrada
float procesar_entrada_estandar(float* entradas, int num_entradas) {
    float suma_ponderada = 0.0f;
    float peso_maximo = 0.0f;

    // Calcular entrada ponderada
    for (int i = 0; i < num_entradas; i++) {
        suma_ponderada += entradas[i];
        if (entradas[i] > peso_maximo) peso_maximo = entradas[i];
    }

    // Aplicar función de activación
    return funcion_sigmoide(suma_ponderada);
}

// Propagación de salidas a neuronas conectadas
void propagar_salida_estandar(float salida, uint32_t* destinos, int num_destinos) {
    for (int i = 0; i < num_destinos; i++) {
        enviar_mensaje_neuronal(destinos[i], salida, MENSAJE_ACTIVACION);
    }
}
```

---

## ⚡ Sistema de Activación Dinámica

### **🔄 Gestor de Eventos de Activación**

```c
typedef struct {
    uint32_t tipo_evento;       // 1=entrada_usuario, 2=reflexion_interna, 3=tiempo_real
    char* texto_entrada;         // Texto que dispara la activación
    uint32_t* conceptos_hash;    // Conceptos extraídos del texto
    int num_conceptos;          // Número de conceptos encontrados
    float intensidad_base;        // Intensidad base del estímulo
    uint32_t timestamp;         // Momento exacto del evento
    uint8_t prioridad;          // 0=baja, 1=normal, 2=alta, 3=crítica
} EventoActivacion;

// Sistema principal de activación
void activar_memoria_desde_evento(EventoActivacion* evento) {
    // 1. Parsear texto a conceptos usando tokenizer
    uint32_t* conceptos = parsear_texto_a_conceptos(evento->texto_entrada);

    // 2. Activar neuronas correspondientes
    for (int i = 0; i < evento->num_conceptos; i++) {
        NeuronaActiva* neurona = buscar_neurona_activa(conceptos[i]);
        if (neurona) {
            // Calcular entrada basada en intensidad del evento
            float entrada = evento->intensidad_base;

            // Activar neurona con entrada
            neurona->procesar_entrada(&entrada, 1);

            // Actualizar timestamp
            neurona->timestamp_ultima = evento->timestamp;
        }
    }

    // 3. Iniciar ciclo de procesamiento paralelo
    if (evento->prioridad >= PRIORIDAD_ALTA) {
        iniciar_ciclo_procesamiento_inmediato();
    }
}
```

### **🧠 Reflexión Automática (Propagación en Cascada)**

```c
void reflexion_automatica_continua() {
    static uint32_t ultimo_ciclo = 0;
    uint32_t tiempo_actual = obtener_timestamp_microsegundos();

    // Ejecutar cada 100 microsegundos
    if (tiempo_actual - ultimo_ciclo < 100) return;
    ultimo_ciclo = tiempo_actual;

    // Recorrer todas las neuronas activas
    for (int i = 0; i < total_neuronas_activas; i++) {
        NeuronaActiva* neurona = &neuronas_activas[i];

        // Verificar si la neurona está activa y no está refractaria
        if (neurona->estado_actual > UMBRAL_ACTIVACION &&
            !neurona->estado_refractario) {

            // Obtener conexiones salientes desde JMN (solo lectura)
            uint32_t* asociadas = obtener_conexiones_jmn(neurona->id_hash);
            int num_asociadas = contar_conexiones_jmn(neurona->id_hash);

            // Propagar a cada neurona asociada
            for (int j = 0; j < num_asociadas; j++) {
                NeuronaActiva* neurona_destino = buscar_neurona_activa(asociadas[j]);

                if (neurona_destino) {
                    // Calcular entrada basada en peso JMN y estado actual
                    float peso_jmn = leer_peso_jmn(neurona->id_hash, asociadas[j]);
                    float entrada = neurona->estado_actual * peso_jmn;

                    // Enviar mensaje asíncrono
                    enviar_mensaje_neuronal(asociadas[j], entrada, MENSAJE_ACTIVACION);
                }
            }
        }
    }
}
```

---

## 🧠 Procesamiento Paralelo Independiente

### **🔧 Sistema de Hilos por Neurona**

```c
typedef struct {
    NeuronaActiva* neurona;
    pthread_t hilo_id;
    uint8_t esta_ejecutando;
    uint32_t ciclos_procesados;
    uint32_t mensajes_procesados;
    float cpu_utilizacion;         // Porcentaje de CPU utilizada
    uint32_t ultima_activacion;   // Última vez que procesó algo
} HiloNeuronal;

// Función principal de cada hilo neuronal
void* hilo_procesador_neuronal(void* arg) {
    HiloNeuronal* hilo = (HiloNeuronal*)arg;
    MensajeNeuronal mensaje;

    while (hilo->esta_ejecutando) {
        // 1. Esperar mensaje o timeout (para procesamiento periódico)
        if (recibir_mensaje_neuronal(hilo->neurona->id_hash, &mensaje, TIMEOUT_10MS)) {
            // 2. Procesar mensaje recibido
            hilo->neurona->procesar_entrada(&mensaje.valor, 1);
            hilo->neurona->timestamp_ultima = mensaje.timestamp;
            hilo->mensajes_procesados++;

        } else {
            // 3. Procesamiento periódico (decaimiento natural)
            aplicar_decaimiento_natural(hilo->neurona);
        }

        // 4. Verificar si debe propagar salida
        if (hilo->neurona->estado_actual > UMBRAL_DISPARO) {
            uint32_t* destinos = obtener_destinos_activos(hilo->neurona->id_hash);
            int num_destinos = contar_destinos_activos(hilo->neurona->id_hash);

            hilo->neurona->propagar_salida(
                hilo->neurona->estado_actual,
                destinos, num_destinos
            );

            // 5. Establecer período refractario
            hilo->neurona->estado_refractario = 1;
            hilo->neurona->periodo_refractario = PERIODO_REFRACTARIO_ESTANDAR;
        }

        hilo->ciclos_procesados++;

        // 6. Actualizar métricas de rendimiento
        actualizar_metricas_rendimiento(hilo);
    }

    return NULL;
}
```

### **📨 Sistema de Mensajes Entre Neuronas**

```c
typedef struct {
    uint32_t id_origen;
    uint32_t id_destino;
    float valor;
    uint32_t timestamp;
    uint8_t tipo_mensaje;      // 1=activacion, 2=refuerzo, 3=reset, 4=modificacion
    uint8_t prioridad;         // 0=baja, 1=normal, 2=urgente
} MensajeNeuronal;

typedef struct {
    MensajeNeuronal* mensajes;
    uint32_t capacidad;
    uint32_t inicio;
    uint32_t fin;
    uint32_t count;
    pthread_mutex_t mutex;
    pthread_cond_t condicion;
} ColaMensajes;

// Envío asíncrono de mensajes
void enviar_mensaje_neuronal(uint32_t id_destino, float valor, uint8_t tipo) {
    ColaMensajes* cola = obtener_cola_mensajes(id_destino);

    pthread_mutex_lock(&cola->mutex);

    // Verificar capacidad
    if ((cola->fin + 1) % cola->capacidad == cola->inicio) {
        // Cola llena, descartar mensaje menos prioritario
        descartar_mensaje_antiguo(cola);
    }

    // Agregar nuevo mensaje
    MensajeNeuronal* msg = &cola->mensajes[cola->fin];
    msg->id_origen = obtener_id_neurona_actual();
    msg->id_destino = id_destino;
    msg->valor = valor;
    msg->timestamp = obtener_timestamp_microsegundos();
    msg->tipo_mensaje = tipo;
    msg->prioridad = (tipo == MENSAJE_ACTIVACION) ? PRIORIDAD_NORMAL : PRIORIDAD_BAJA;

    cola->fin = (cola->fin + 1) % cola->capacidad;
    cola->count++;

    pthread_cond_signal(&cola->condicion);
    pthread_mutex_unlock(&cola->mutex);
}
```

---

## 🌐 Ciclo de Vida de Memoria Activa

### **🚀 Inicialización del Sistema**

```c
typedef struct {
    NeuronaActiva* neuronas;
    int total_neuronas;
    HiloNeuronal* hilos;
    int total_hilos;
    ColaMensajes* colas_mensajes;
    uint8_t sistema_activo;
    uint32_t timestamp_inicio;
    uint32_t ciclos_totales;
} SistemaMemoriaActiva;

void inicializar_memoria_activa() {
    printf("🚀 Inicializando Memoria Activa Independiente...\n");

    // 1. Cargar conceptos desde JMN base (solo lectura)
    printf("📚 Cargando conceptos desde JMN base...\n");
    uint32_t total_conceptos = jmn_contar_conceptos();
    sistema.total_neuronas = total_conceptos;
    sistema.neuronas = malloc(sizeof(NeuronaActiva) * total_conceptos);

    for (int i = 0; i < total_conceptos; i++) {
        ConceptoJMN concepto = jmn_obtener_concepto_indice(i);
        crear_neurona_activa(&sistema.neuronas[i], concepto);
    }

    // 2. Crear sistema de colas de mensajes
    printf("📨 Creando sistema de mensajes...\n");
    sistema.colas_mensajes = crear_sistema_colas(total_conceptos);

    // 3. Iniciar hilos de procesamiento
    printf("🧠 Iniciando hilos de procesamiento neuronal...\n");
    sistema.total_hilos = total_conceptos;
    sistema.hilos = malloc(sizeof(HiloNeuronal) * total_conceptos);

    for (int i = 0; i < total_conceptos; i++) {
        sistema.hilos[i].neurona = &sistema.neuronas[i];
        sistema.hilos[i].esta_ejecutando = 1;

        if (pthread_create(&sistema.hilos[i].hilo_id, NULL,
                         hilo_procesador_neuronal, &sistema.hilos[i]) != 0) {
            printf("❌ Error creando hilo para neurona %u\n", i);
        }
    }

    // 4. Activar sistema de eventos externos
    printf("⚡ Activando sistema de eventos...\n");
    activar_sistema_eventos();

    // 5. Iniciar ciclo principal
    sistema.sistema_activo = 1;
    sistema.timestamp_inicio = obtener_timestamp_microsegundos();

    printf("✅ Memoria Activa inicializada con %d neuronas procesadoras\n", total_conceptos);
}

void crear_neurona_activa(NeuronaActiva* neurona, ConceptoJMN concepto) {
    // Inicializar estructura básica
    neurona->id_hash = concepto.id_hash;
    neurona->texto_concepto = strdup(concepto.texto);
    neurona->estado_actual = 0.0f;
    neurona->potencial_membrana = 0.0f;
    neurona->timestamp_ultima = 0;
    neurona->periodo_refractario = 1000; // 1ms por defecto
    neurona->estado_refractario = 0;

    // Asignar funciones de procesamiento
    neurona->procesar_entrada = procesar_entrada_estandar;
    neurona->funcion_activacion = funcion_sigmoide;
    neurona->propagar_salida = propagar_salida_estandar;

    // Inicializar memoria local
    neurona->tam_memoria_local = 1024; // 1KB por neurona
    neurona->memoria_local = calloc(neurona->tam_memoria_local, sizeof(float));

    // Inicializar buffer de contexto
    memset(neurona->contexto_actual, 0, sizeof(neurona->contexto_actual));
    neurona->indice_contexto = 0;

    // Inicializar métricas
    neurona->ciclos_procesados = 0;
    neurona->eficiencia_promedio = 1.0f;
    neurona->timestamp_creacion = obtener_timestamp_microsegundos();
}
```

### **🔄 Ciclo Principal de Operación**

```c
void ciclo_principal_memoria_activa() {
    printf("🔄 Iniciando ciclo principal de Memoria Activa...\n");

    while (sistema.sistema_activo) {
        uint32_t tiempo_inicio_ciclo = obtener_timestamp_microsegundos();

        // 1. Procesar eventos externos (entrada de usuario)
        procesar_eventos_entrantes();

        // 2. Ejecutar reflexión automática en cascada
        reflexion_automatica_continua();

        // 3. Sincronizar estados globales
        sincronizar_estados_globales();

        // 4. Procesar consolidaciones pendientes
        procesar_consolidaciones_pendientes();

        // 5. Actualizar métricas del sistema
        actualizar_metricas_sistema();

        // 6. Control de tiempo real (ciclo de 100 microsegundos)
        uint32_t tiempo_ciclo = obtener_timestamp_microsegundos() - tiempo_inicio_ciclo;
        if (tiempo_ciclo < 100) {
            usleep(100 - tiempo_ciclo);
        }

        sistema.ciclos_totales++;

        // 7. Verificar condiciones de apagado
        if (debe_apagar_sistema()) {
            printf("🛑 Condición de apagado detectada\n");
            break;
        }
    }

    printf("🏁 Ciclo principal finalizado. Total ciclos: %u\n", sistema.ciclos_totales);
}
```

---

## 🔄 Sincronización con JMN Base

### **📖 Comunicación de Solo Lectura**

```c
// Interface de lectura segura desde JMN base
typedef struct {
    uint32_t id_origen;
    uint32_t id_destino;
    float peso;
    uint8_t tipo_relacion;
    uint32_t timestamp;
    uint8_t es_valida;
} ConexionJMN;

// Lectura segura de pesos desde JMN
float leer_peso_jmn(uint32_t id_origen, uint32_t id_destino) {
    ConexionJMN conn = jmn_buscar_conexion(id_origen, id_destino);
    return conn.es_valida ? conn.peso : 0.0f;
}

// Obtener lista de conexiones salientes
uint32_t* obtener_conexiones_jmn(uint32_t id_concepto) {
    return jmn_listar_conexiones_salientes(id_concepto);
}

// Obtener metadatos de concepto
ConceptoJMN obtener_concepto_jmn(uint32_t id_hash) {
    return jmn_buscar_concepto(id_hash);
}
```

### **💾 Escritura Controlada a JMN**

```c
typedef struct {
    uint32_t id_origen;
    uint32_t id_destino;
    float peso_anterior;
    float peso_nuevo;
    float delta_peso;         // Cambio en el peso
    uint32_t timestamp;
    uint32_t frecuencia_refuerzo; // Veces que se ha reforzado
    float confianza;            // Confianza en este aprendizaje
    uint8_t tipo_aprendizaje;   // 1=hebbiano, 2=correccion, 3=nuevo
} Aprendizaje;

// Sistema de consolidación inteligente
void consolidar_aprendizaje_en_jmn(Aprendizaje* aprendizaje) {
    // Solo consolidar aprendizajes importantes
    if (aprendizaje->confianza > UMBRAL_CONSOLIDACION &&
        fabs(aprendizaje->delta_peso) > DELTA_MINIMO_CONSOLIDACION) {

        printf("💾 Consolidando aprendizaje: %u -> %u (Δ: %.4f)\n",
               aprendizaje->id_origen, aprendizaje->id_destino, aprendizaje->delta_peso);

        // Actualizar JMN base de forma segura
        jmn_actualizar_peso_seguro(
            aprendizaje->id_origen,
            aprendizaje->id_destino,
            aprendizaje->peso_nuevo
        );

        // Actualizar estadísticas de aprendizaje
        aprendizaje->frecuencia_refuerzo++;
        aprendizaje->timestamp = obtener_timestamp_microsegundos();

        // Sincronizar también en memoria activa
        sincronizar_conexion_memoria_activa(aprendizaje);
    }
}

// Detección de aprendizajes importantes
void detectar_aprendizajes_significativos() {
    for (int i = 0; i < total_neuronas_activas; i++) {
        NeuronaActiva* neurona = &sistema.neuronas[i];

        // Buscar patrones de activación repetitivos
        if (neurona->ciclos_procesados > 1000) {
            float frecuencia_activacion = calcular_frecuencia_activacion(neurona);

            if (frecuencia_activacion > UMBRAL_FRECUENCIA_ALTA) {
                // Esta neurona es importante, reforzar sus conexiones
                reforzar_conexiones_importantes(neurona);
            }
        }
    }
}
```

---

## 🎯 Ventajas y Características

### **⚡ Procesamiento de Alto Rendimiento**

| Característica         | Descripción                    | Beneficio                 |
| ---------------------- | ------------------------------ | ------------------------- |
| **Paralelismo Masivo** | Cada neurona en su propio hilo | Procesamiento simultáneo  |
| **Tiempo Real**        | Ciclos de 100 microsegundos    | Respuestas inmediatas     |
| **Asíncronía**         | Mensajes no bloqueantes        | No hay cuellos de botella |
| **Memoria Local**      | Cada neurona tiene su RAM      | Acceso ultrarrápido       |

### **🧠 Simulación Cerebral Realista**

| Característica             | Implementación        | Realismo Cerebral               |
| -------------------------- | --------------------- | ------------------------------- |
| **Potencial de Membrana**  | `potencial_membrana`  | Simula potencial eléctrico      |
| **Período Refractario**    | `periodo_refractario` | Tiempo de recuperación neuronal |
| **Propagación en Cascada** | Reflexión automática  | Activación natural en red       |
| **Decaimiento**            | Función exponencial   | Olvido natural                  |

### **💾 Persistencia Inteligente**

| Característica                | Mecanismo                     | Ventaja                      |
| ----------------------------- | ----------------------------- | ---------------------------- |
| **Base Estable**              | JMN no se modifica            | Consistencia garantizada     |
| **Memoria Temporal**          | Estado en memoria activa      | Flexibilidad total           |
| **Consolidación Selectiva**   | Solo aprendizajes importantes | Eficiencia de almacenamiento |
| **Sincronización Controlada** | Escritura periódica           | Sin corrupción de datos      |

---

## 🚀 Guía de Implementación

### **Fase 1: Estructuras Base**

1. Implementar `NeuronaActiva` y funciones básicas
2. Crear sistema de colas de mensajes
3. Desarrollar interface de lectura JMN

### **Fase 2: Procesamiento Paralelo**

1. Implementar hilos por neurona
2. Crear sistema de envío/recepción de mensajes
3. Desarrollar reflexión automática

### **Fase 3: Sincronización**

1. Implementar sincronización con JMN
2. Crear sistema de consolidación
3. Desarrollar detección de aprendizajes importantes

### **Fase 4: Optimización**

1. Afinar tiempos de ciclo
2. Optimizar uso de memoria
3. Implementar métricas de rendimiento

### **Fase 5: Integración**

1. Integrar con sistema Neutron IA
2. Crear interface de control
3. Implementar sistema de eventos

---

## 📈 Métricas y Monitoreo

### **📊 Indicadores Clave**

```c
typedef struct {
    uint32_t ciclos_totales;
    uint32_t neuronas_activas;
    float cpu_utilizacion_promedio;
    uint32_t mensajes_procesados;
    uint32_t consolidaciones_realizadas;
    float latencia_promedio;
    float throughput_promedio;
    uint32_t errores_procesamiento;
} MetricasSistema;

void actualizar_metricas_sistema() {
    static uint32_t ultima_actualizacion = 0;
    uint32_t tiempo_actual = obtener_timestamp_microsegundos();

    // Actualizar cada segundo
    if (tiempo_actual - ultima_actualizacion < 1000000) return;

    // Calcular métricas
    metricas.ciclos_totales = sistema.ciclos_totales;
    metricas.neuronas_activas = contar_neuronas_activas();
    metricas.cpu_utilizacion_promedio = calcular_cpu_promedio();
    metricas.mensajes_procesados = contar_mensajes_totales();
    metricas.consolidaciones_realizadas = contar_consolidaciones();
    metricas.latencia_promedio = calcular_latencia_promedio();
    metricas.throughput_promedio = calcular_throughput_promedio();
    metricas.errores_procesamiento = contar_errores();

    ultima_actualizacion = tiempo_actual;
}
```

---

## 🏁 Conclusión

Este diseño de **Memoria Activa Independiente** permite:

✅ **Procesamiento paralelo masivo** con neuronas independientes  
✅ **Simulación cerebral realista** con potenciales y períodos refractarios  
✅ **Persistencia controlada** sin modificar JMN base  
✅ **Aprendizaje en tiempo real** con consolidación inteligente  
✅ **Escalabilidad total** con sistema de hilos distribuidos  
✅ **Sincronización bidireccional** entre memoria activa y JMN

La arquitectura proporciona una base sólida para implementar una memoria neuronal verdaderamente activa y procesadora, manteniendo la estabilidad y persistencia de JMN como base fundamental.
