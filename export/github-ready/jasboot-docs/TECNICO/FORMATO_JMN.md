# Formato .jmn — Memoria Neuronal Jasboot

Especificación del formato de persistencia de cerebro.jmn (JMN = Memoria Neuronal Jasboot).

## Versión actual: 1

## Layout del archivo

| Offset | Tamaño | Campo | Descripción |
|--------|--------|-------|-------------|
| 0 | 4 | magic | 0x4A4D4E31 ("JMN1" big-endian) |
| 4 | 4 | version | 1 (formato estable) |
| 8 | 4 | num_nodos | Cantidad de nodos |
| 12 | 4 | num_conex | Cantidad de conexiones |
| 16 | 4 | num_textos | Cantidad de entradas de texto |
| 20 | variable | nodos | Bloques de 8 bytes por nodo: id(4), peso.u(4) |
| ... | variable | conexiones | Bloques de 16 bytes: ori(4), dest(4), key(4), fuerza(4) |
| ... | variable | textos | id(4), len(2), chars[len+1] por texto |
| ... | 4 | checksum | CRC32 del payload (solo formato v1 nuevo) |

## Checksum

- **CRC32** sobre todos los bytes desde magic hasta el final de textos (excluyendo el checksum).
- Archivos creados antes de la introducción del checksum no lo tienen; la carga los acepta sin verificación.

## Migración de versiones

- **v1** (actual): Formato estable. Solo se soporta esta versión.
- **v1 → v2** (futuro): En `jmn_io_cargar` añadir:
  1. `if (version == 2)` → cargar con nuevo layout
  2. O: cargar v1, convertir in-memory a estructura v2
- **Archivos sin checksum**: Formatos legacy (pre-CRC) se aceptan; si `fread` del checksum falla, se omite la verificación.

## Endianness

- Todos los campos son **little-endian** (estándar en x86/x64).
