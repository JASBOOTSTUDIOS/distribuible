# Formato .jmn — Memoria Neuronal Jasboot

Especificación del formato de persistencia de cerebro.jmn (JMN = Memoria Neuronal Jasboot).

## Versiones soportadas: 1 y 2

- **v1:** nodos, conexiones, textos y CRC32 final (compatibilidad con archivos existentes).
- **v2:** igual que v1 y, si hay datos de colecciones, bloques adicionales de **listas** y **mapas** en memoria persistente (mismo `JMNMemoria` no RAM).

La escritura usa **v1** cuando no hay listas ni mapas persistentes; en cuanto exista al menos una lista o un mapa con datos, se escribe **v2**.

## Layout del archivo (v1)

| Offset | Tamaño | Campo | Descripción |
|--------|--------|-------|-------------|
| 0 | 4 | magic | 0x4A4D4E31 ("JMN1" en big-endian) |
| 4 | 4 | version | 1 |
| 8 | 4 | num_nodos | Cantidad de nodos |
| 12 | 4 | num_conex | Cantidad de conexiones |
| 16 | 4 | num_textos | Cantidad de entradas de texto |
| 20 | variable | nodos | Bloques de 8 bytes por nodo: id(4), peso.u(4) |
| ... | variable | conexiones | Bloques de 16 bytes: ori(4), dest(4), key(4), fuerza(4) |
| ... | variable | textos | id(4), len(2), chars[len+1] por texto |
| ... | 4 | checksum | CRC32 del payload (desde magic hasta el último byte de textos, excluyendo el checksum) |

## Extensión v2 (después de textos, antes del checksum)

Tras el último bloque de texto:

| Campo | Descripción |
|--------|-------------|
| num_listas (4) | Cantidad de listas guardadas |
| Por cada lista | id (4), count (4), luego `count` valores de 4 bytes (`JMNValor.u`, little-endian) |
| num_mapas (4) | Cantidad de “slots” de mapa guardados |
| Por cada mapa | slot (4, índice 0–9999), count (4), luego `count` pares (key u32, val u32) |

El **checksum CRC32** cubre desde `magic` hasta el final de los datos de mapas (incluye la extensión v2).

Los mapas se persisten por **slot** (`map_id % 10000`), coherente con la implementación en tiempo de ejecución.

## Checksum

- **CRC32** sobre todos los bytes desde magic hasta el final del payload serializado (en v2, incluye listas y mapas; excluyendo los 4 bytes del checksum).
- Archivos creados antes de la introducción del checksum no lo tienen; la carga los acepta sin verificación.
- Archivos **v1** sin listas/mapas: mismo criterio que antes.

## Memoria RAM auxiliar de la VM

La VM puede usar un segundo `JMNMemoria` en RAM (`mem_colecciones`) para listas internas; **no** forma parte del archivo `cerebro.jmn` del programa. Lo que sí persiste en v2 son listas y mapas creados sobre la memoria neuronal principal abierta con `crear_memoria` / rutas de archivo.

## Migración de versiones

- **v1 → v2:** Los lectores actuales cargan v1 sin bloque adicional; v2 añade solo datos opcionales antes del CRC.
- **v1 → v2 (futuro mayor):** Cambios de layout mayores seguirían usando el campo `version` en cabecera.

## Archivos sin checksum

Formatos legacy (pre-CRC): si `fread` del checksum falla, se omite la verificación.

## Endianness

- Todos los campos multibyte son **little-endian** en la implementación de referencia (x86/x64).

---

*Última actualización: 2026-04-14*
