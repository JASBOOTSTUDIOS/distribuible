# Coexistencia: crear_memoria/recordar vs n_abrir_grafo/n_recordar

Los sistemas **crear_memoria + recordar** y **n_abrir_grafo + n_recordar** son **independientes** y **paralelos**. Un programa puede usar ambos sin conflicto.

---

## Sistema tradicional (memoria neuronal)

```jasb
crear_memoria("cerebro.jmn")
recordar "concepto" con valor "asociado"
buscar "concepto"
cerrar_memoria
```

- Persistencia en `.jmn`
- Paradigma de asociaciones libres
- Funciones: `recordar`, `buscar`, `aprender`, `olvidar`, `pensar`

---

## Sistema n_grafo (triples S-P-O)

```jasb
grafo = n_abrir_grafo("datos.ngf")
n_recordar(grafo, "francia", "capital", "paris")
objeto = n_buscar_objeto(grafo, "francia", "capital")
n_cerrar_grafo(grafo)
```

- Persistencia en `.ngf`
- Modelo de grafos (sujeto, predicado, objeto)
- Funciones: `n_recordar`, `n_buscar_objeto`, `n_buscar_sujeto`, etc.

---

## Uso simultáneo

```jasb
// Memoria neuronal para razonamiento
crear_memoria("cerebro.jmn")
recordar "temperatura" con valor "alta"
pensar "qué hacer"

// Grafo para conocimiento estructurado
g = n_abrir_grafo("conocimiento.ngf")
n_recordar(g, "paris", "capital_de", "francia")
n_cerrar_grafo(g)

cerrar_memoria
```

---

## Regla de oro

**Ninguna función n_* modifica ni interfiere con:**

- `recordar`, `buscar`, `aprender`, `olvidar`, `pensar`
- `crear_memoria`, `cerrar_memoria`
- `mem_crear`, `mem_cerrar`, `mem_asociar`
- Cualquier otra construcción existente

El sistema n_* es **adicional** y **opcional**.

---

## Unificación dual (jas-IA)

Ver `docs/TECNICO/VM/VM_ESTABLE.md` y el código de la VM para el routing:
- **recordar dual:** Definiciones "X es Y" → JMN + n_grafo (X, n_es_un, Y)
- **buscar dual:** JMN primero, n_grafo como fallback
