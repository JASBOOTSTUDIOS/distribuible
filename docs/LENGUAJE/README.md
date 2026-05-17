# Documentación de Sintaxis Jasboot

Contiene la referencia completa del lenguaje Jasboot.

## Documentos

- **[TIPOS_RELACION_JMN.md](TIPOS_RELACION_JMN.md)** — **Tipos de arista 1–15:** constantes C, alias en texto, simetrías en VM, máscaras, `pensar_siguiente_mai`; ejemplos Jasboot.
- **[CAPAS_JMN_MAI_VM_Y_USO.md](CAPAS_JMN_MAI_VM_Y_USO.md)** — **Arquitectura por capas:** compilador/IR, VM, JMN (tipos 1–15), rastro, percepción, MAI, funciones `*_mai`, persistencia; tablas de uso, ejemplos Jasboot y encaje con **Neurixis** (`apps/neurixis/`).
- **[jmn/PROPAGACION_D_MAX_K_AUDITORIA_Y_ESTRES.md](jmn/PROPAGACION_D_MAX_K_AUDITORIA_Y_ESTRES.md)** — **`propagar_activacion*`**: `d_max`, `K`, empaquetado IR, límites JMN/VM, auditoría `JASBOOT_PROPAGAR_AUDIT`, pruebas de regresión y estrés.
- **[REFERENCIA_LENGUAJE_JASBOOT.md](REFERENCIA_LENGUAJE_JASBOOT.md)** — **Referencia oficial de sintaxis y semántica** (alineada con el compilador **jbc**): tipos, control de flujo, JMN, FFI, heap, vectores, matrices, etc.
- **[jmn/JMN_JOURNAL_Y_CONSOLIDACION.md](jmn/JMN_JOURNAL_Y_CONSOLIDACION.md)** — Journal `.jwl`, recuperación, API `mai_contexto*` / `consolidar_sueno`, tuning `MAI_SUEÑO_JMN_*` (Fase 2.2).
- **[../PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md](../PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md)** — Catálogo de instrucciones, estrés y estado de baterías (incluye **JMN journal / replay `.jwl`**).
- **[../../AGENTS.md](../../AGENTS.md)** — Contexto para agentes: stack SDK, variables de entorno JMN/JWL, tests de regresión.
- **[ESTANDAR_ORGANIZACION_PROYECTOS_JASBOOT.md](ESTANDAR_ORGANIZACION_PROYECTOS_JASBOOT.md)** — **Estructura de carpetas y convenciones** (`src/`, `tests/`, `data/`, `docs/`, `usar`, perfiles aplicación/biblioteca/dominio).

## Contenido de la referencia

1. Estructura del programa (principal, funciones, registros)
2. Tipos de datos (entero, texto, flotante, caracter, lista, mapa, etc.)
3. Variables y declaraciones
4. Literales (números, cadenas, listas, mapas)
5. Operadores (aritméticos, comparación, lógicos, bits)
6. Sentencias de control (cuando/si, mientras, `para_cada`/`para cada` incl. tipo `caracter` sobre texto, `indice`, `sobre`/`en`, romper, continuar)
7. Funciones
8. Registros (estructuras)
9. Entrada y salida (imprimir, imprimir_sin_salto, ingresar_texto)
10. Memoria neuronal (recordar, buscar, pensar; persistencia `.jmn`, journal `.jwl` y recuperación — [jmn/JMN_JOURNAL_Y_CONSOLIDACION.md](jmn/JMN_JOURNAL_Y_CONSOLIDACION.md), `AGENTS.md`, checklist de proyecto)
11. Llamadas de sistema (cadenas —incluye **`tokenizar_L` / `claves_L`** (pipeline L nativo), `reemplazar`/`remplazar`, etc.—, listas, mapas, archivos, JMN; detalle pipeline L: [../../sdk-dependiente/docs/TOKENIZAR_L_PIPELINE_NATIVE.md](../../sdk-dependiente/docs/TOKENIZAR_L_PIPELINE_NATIVE.md))
12. Módulos y bibliotecas
