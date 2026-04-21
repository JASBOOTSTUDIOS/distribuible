# Catálogo de errores del lenguaje (Nivel 1.5)

Documento que cumple el checklist 1.5: catálogo centralizado de errores del lenguaje y criterios para mensajes consistentes en español, sin depender de mensajes de C/host. Referencia: `CHECKLIST_PRODUCCION_E_IA.md`, `CONTRATO_RUNTIME_V1.0.md`.

---

## 1. Catálogo centralizado

Cada entrada del catálogo identifica un **tipo de error**, un **identificador** (para código y documentación), un **mensaje** recomendado en español y, cuando aplique, un **código de salida** sugerido.

### 1.1 Errores de concepto y memoria

| Id. | Tipo de error | Mensaje recomendado (español) | Código salida |
|-----|----------------|-------------------------------|---------------|
| `CONCEPTO_INEXISTENTE` | Se hace `buscar "nombre"` y el concepto no existe o no tiene valor accesible. | `Concepto inexistente: no se encontró "<nombre>" en la memoria.` | 2 |
| `MEMORIA_NO_ABIERTA` | Operación sobre memoria neuronal sin haber abierto una (p. ej. `recordar`/`buscar` sin `crear_memoria` previo). | `Memoria neuronal no abierta: no se puede leer ni escribir conceptos.` | 3 |
| `MEMORIA_NO_PUDO_CREAR` | Fallo al crear o cargar la memoria (archivo, permisos, disco). | `No se pudo crear o cargar la memoria: <detalle>.` | 4 |

### 1.2 Errores de tipos y operaciones

| Id. | Tipo de error | Mensaje recomendado (español) | Código salida |
|-----|----------------|-------------------------------|---------------|
| `TIPO_INCOMPATIBLE` | Operación o comparación entre tipos no permitidos (p. ej. número vs texto sin conversión definida). | `Tipo incompatible: <operación> no aplica entre <tipo1> y <tipo2>.` | 5 |
| `PENSAMIENTO_INVALIDO` | La expresión en `pensar` no pudo evaluarse o no tiene valor usable. | `Pensamiento inválido: la expresión no pudo evaluarse correctamente.` | 6 |
| `ACCESO_INVALIDO` | Índice fuera de rango, clave de mapa inexistente sin valor por defecto, etc. | `Acceso inválido: <descripción breve> (índice/clave/objeto).` | 7 |

### 1.3 Errores de ejecución (VM / recursos)

| Id. | Tipo de error | Mensaje recomendado (español) | Código salida |
|-----|----------------|-------------------------------|---------------|
| `PILA_LLENA` | Stack overflow (recursión o profundidad de llamadas). | `Pila llena: se superó el límite de recursión o llamadas.` | 8 |
| `MEMORIA_AGOTADA` | Pila de memoria (RESERVAR_PILA) agotada. | `Memoria agotada: no hay más espacio en la pila de ejecución.` | 9 |
| `INSTRUCCION_DESCONOCIDA` | Opcode no implementado o inválido. | `Instrucción desconocida en el programa (código 0x<hex>).` | 10 |
| `PASOS_EXCEDIDOS` | Se superó el límite de pasos de ejecución (anti-bucle). | `Se excedió el límite de pasos de ejecución.` | 11 |
| `VALIDACION_IR` | El binario IR no pasó la validación (magic, saltos, tamaños). | `Error de validación del programa: <mensaje del validador>.` | 12 |

### 1.4 Errores de compilación / sintaxis

| Id. | Tipo de error | Mensaje recomendado (español) | Código salida |
|-----|----------------|-------------------------------|---------------|
| `ERROR_LEXICO` | Carácter o palabra no reconocida (incl. palabras en inglés no permitidas). | `Error léxico en línea <n>, columna <m>: <detalle>.` | 13 |
| `ERROR_SINTAXIS` | Construcción inválida según la gramática. | `Error de sintaxis en línea <n>, columna <m>: <detalle>.` | 14 |

---

## 2. Mensajes consistentes: criterios

### 2.1 Sin filtrar detalles útiles

- Los mensajes deben incluir **contexto útil**: nombre del concepto, tipos involucrados, línea/columna cuando aplique, código de instrucción en hex si es relevante.
- No se deben **recortar** ni **generealizar** en exceso los mensajes del runtime/compilador para “simplificar”; el objetivo es que el usuario pueda depurar sin tener que adivinar.

### 2.2 Sin depender de mensajes de C/host

- Los errores **del lenguaje** deben tener **mensajes propios** definidos en este catálogo (o en la implementación según este catálogo), en **español**.
- No se debe exponer al usuario como mensaje principal un texto crudo de la biblioteca C (p. ej. `strerror(errno)`) o del sistema operativo sin traducir o sin acompañarlo de un mensaje del lenguaje. Si se incluye detalle técnico del host (p. ej. “errno: ENOENT”), debe ser **complementario** tras el mensaje en español.

### 2.3 Formato recomendado para salida

- **Una línea principal** en español que identifique el tipo de error y el motivo.
- **Opcional**: segunda línea o bloque con detalle técnico (archivo, PC, opcode, etc.) para depuración avanzada.

Ejemplo:

```
Concepto inexistente: no se encontró "edad" en la memoria.
  (buscar en principal, línea 5)
```

---

**Referencia**: `CHECKLIST_PRODUCCION_E_IA.md` Nivel 1.5, `docs/CONTRATO_RUNTIME_V1.0.md`.  
**Última actualización**: 2026-02-18
