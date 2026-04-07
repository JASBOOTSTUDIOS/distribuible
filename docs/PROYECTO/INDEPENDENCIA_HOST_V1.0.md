# Independencia del host (v1.0, opcional)

Documento de la capa de abstracción del host (opcional para v1.0).

---

## 1. Capa de abstracción: única puerta a I/O, memoria y APIs externas

### Objetivo de diseño

Toda interacción con el host (salida estándar, entrada estándar, sistema de archivos, memoria persistente, otras APIs) debería pasar por una **capa de abstracción** (host layer) con una interfaz mínima, de modo que:

- El runtime (VM) no llame directamente a `printf`/`fopen`/`fprintf` del host, sino a funciones de la capa (p. ej. `vm_host_write_stdout`, `vm_host_read_stdin`, `vm_host_open_file`, `vm_host_memory_create`).
- El compilador (Python) ya usa la stdlib de forma aislada (archivos, subprocess); la única “puerta” externa es la invocación de la VM y el sistema de archivos para leer .jasb y escribir .jbo.

### Estado actual (v1.0)

- **VM (C):** Actualmente la VM usa directamente:
  - **Salida:** `printf` para salida de programa e impresión de números; `fprintf(stderr, ...)` para errores y trazas.
  - **Archivos:** `fopen`/`fread` para cargar el binario IR y para opcodes de lectura/escritura de archivos (p. ej. `OP_FS_LEER_TEXTO`, `OP_FS_ESCRIBIR_TEXTO`).
  - **Memoria neuronal:** código en `sdk-dependiente/jasboot-jmn-core/src/memoria_neuronal` (JMN) que a su vez usa E/S para persistencia.
- **Compilador (Python):** Usa `open()`, `subprocess.run`/`Popen`, `os.path`; no hay una capa intermedia explícita, pero el contacto con el host está acotado a stdlib.

Para v1.0 (opcional) no se exige refactorizar la VM; se documenta este diseño como **meta** y los puntos de contacto actuales para una futura capa única:

| Componente | Puntos de contacto actuales con el host |
|------------|----------------------------------------|
| VM (vm.c, ir_vm.c, etc.) | `printf`, `fprintf(stderr, ...)`, `fopen`/`fread`/`fwrite`, llamadas a JMN (crear/cargar memoria). |
| JMN (jasboot-jmn-core) | E/S de archivos para cerebro.jmn, asignación de memoria (malloc/free). |
| Compilador (jbc, C) | `fopen`/`fread`/`fwrite`, libc estándar. |

Una implementación futura de la “única puerta” consistiría en definir en la VM un pequeño conjunto de callbacks o funciones `vm_host_*` (stdout, stdin, archivos, crear/cargar memoria) e inyectarlas en el arranque de la VM, de modo que todo el I/O y la memoria pasen por ahí.

---

## 2. API interna del runtime documentada

El **runtime** es la VM IR (ejecutor del binario generado por el compilador). La API interna relevante para integradores y mantenimiento es la siguiente.

### Entrada y formato binario

- **Invocación:** La VM se ejecuta como proceso independiente; recibe por argumentos la ruta del binario IR (p. ej. `jasboot-ir-vm programa.jbo`).
- **Carga del programa:** Lectura del binario desde disco (actualmente `fopen`/`fread`). Formato definido en **`jasboot-ir/src/ir_format.h`**: cabecera (magic "JASB", versión, code_size, data_size), luego código (instrucciones de 5 bytes) y datos.
- **Estructuras:** `IRHeader`, `IRInstruction`; opcodes definidos en el enum de `ir_format.h` (p. ej. `OP_HALT`, `OP_MOVER`, `OP_LEER`, `OP_ESCRIBIR`, `OP_IMPRIMIR_TEXTO`, `OP_MEM_*`, `OP_FS_*`).

### Ciclo de ejecución

- La VM mantiene PC (program counter), registros, pila de llamadas, pila de memoria (RESERVAR_PILA).
- En cada paso: leer instrucción en PC, decodificar opcode y operandos, ejecutar (switch por opcode en `vm.c`), actualizar PC (o saltar con `OP_IR`/`OP_SI`/`OP_LLAMAR`/`OP_RETORNAR`).
- **Finalización:** `OP_HALT` o condición de error detiene la ejecución; el proceso sale con el `exit_code` definido por la VM.

### Semántica y errores

- La **semántica** de las operaciones sobre conceptos (crear, leer, actualizar, olvidar) y los **tipos de error** del runtime están documentados en **`docs/CONTRATO_RUNTIME_V1.0.md`**.
- Los **opcodes** están listados en `jasboot-ir/src/ir_format.h`; el comportamiento de cada uno se puede seguir en `jasboot-ir/src/vm.c` (switch por `inst.opcode`).
- Códigos de error del lenguaje y mensajes: **`docs/CATALOGO_ERRORES_V1.0.md`**.

Resumen: **API interna del runtime** = entrada (binario IR + argumentos), formato (ir_format.h), conjunto de opcodes (ir_format.h + vm.c), contrato semántico (CONTRATO_RUNTIME_V1.0.md). No hay API pública estable en C para “embebir” la VM; la integración es por proceso (invocar el binario de la VM).

---

## 3. Reducir dependencias externas no críticas

### Dependencias actuales

| Dependencia | Uso | Crítica |
|-------------|-----|---------|
| **gcc (o compatible C11)** | Compilador (jbc), VM, core | Sí |
| **core/** (C: memoria neuronal, compat) | VM depende de JMN y platform_compat | Sí |
| **libc** (printf, fopen, malloc, etc.) | VM y core | Sí |
| **NASM / enlazador** | No usado (jbc → IR; VM C ejecuta IR). | No para v1.0 |

### Criterios para reducir

- **Compilador (jbc):** Solo dependencias de **libc**; compilado con gcc C11. Sin dependencia de Python.
- **VM:** Las únicas dependencias externas son el compilador C y el código fuente de `core/`. No hay librerías de terceros obligatorias; la VM usa libc estándar. Reducir dependencias no críticas aquí implica no añadir nuevas librerías sin justificación.
- **Opcional:** En el futuro, la capa de abstracción (punto 1) podría permitir sustituir implementaciones concretas de I/O o memoria sin tocar el núcleo de la VM, reduciendo el acoplamiento al host.

Para v1.0 se considera cumplido el ítem si las dependencias están **documentadas** (como arriba) y se evita añadir dependencias externas no críticas al flujo principal; no es obligatorio eliminar ya ninguna dependencia existente.

---

**Referencias:** `jasboot-ir/src/ir_format.h`, `jasboot-ir/src/vm.c`, `docs/CONTRATO_RUNTIME_V1.0.md`, `docs/CATALOGO_ERRORES_V1.0.md`.  
Última actualización: 2026-02-18
