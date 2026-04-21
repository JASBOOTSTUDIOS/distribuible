# Gestión del Heap en Jasboot (jbc + VM)

Cómo usar **reservar** y **liberar** para gestión dinámica de memoria.

---

## 1. Opcodes en la VM

| Opcode | Nombre | Semántica |
|--------|--------|-----------|
| 0x45 | OP_HEAP_RESERVAR | A ← malloc(B\|C). Reserva memoria dinámica y devuelve el puntero (handle). |
| 0x46 | OP_HEAP_LIBERAR | free(A). Libera el bloque de memoria apuntado por el handle en A. |

La VM realiza un seguimiento de todos los bloques reservados en una lista interna para liberarlos automáticamente cuando la VM se destruye, evitando fugas de memoria si el programa Jasboot olvida llamar a `liberar`.

---

## 2. Uso desde Jasboot (jbc)

Llamadas de sistema reconocidas:

### **reservar(n_bytes)**
- **n_bytes:** cantidad de memoria a reservar (entero).
- **Retorno:** un `entero` que representa la dirección de memoria (handle). Si falla, devuelve 0.
- **Nota:** La memoria devuelta **no está inicializada** (contiene basura). Es responsabilidad del programador inicializarla.

### **liberar(puntero)**
- **puntero:** el handle devuelto previamente por `reservar`.
- **Nota:** Solo se pueden liberar bloques reservados explícitamente con `reservar`. Intentar liberar direcciones inválidas o memoria de la pila no tiene efecto (la VM lo ignora por seguridad).

---

## 3. Ejemplo de uso

```jasb
principal
    REM Reservar espacio para un array de 10 enteros (80 bytes)
    entero p = reservar(80)
    
    si p != 0 entonces hacer
        imprimir("Memoria reservada en: ")
        imprimir(str_desde_numero(p))
        imprimir("\n")
        
        REM ... usar la memoria (vía opcodes de bajo nivel o FFI) ...
        
        liberar(p)
        imprimir("Memoria liberada.\n")
    sino
        imprimir("Error: no se pudo reservar memoria.\n")
    fin_si
fin_principal
```

---

## 4. Limitaciones actuales

- No existe una sintaxis de alto nivel para acceder a los contenidos de la memoria reservada (como `p[i]`). Actualmente el uso principal es para pasar buffers a funciones C vía **FFI**.
- El tamaño máximo de reserva individual está limitado por la VM (actualmente ~1GB) para prevenir ataques de denegación de servicio o errores de desbordamiento.
