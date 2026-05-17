# 💾 Gestión de Datos Masivos en JMN (400GB+)

Este documento detalla la ingeniería necesaria para que Replicante IA maneje una base de conocimiento de escala universal en un hardware de consumo.

---

## 1. Estrategia de Acceso: Offset Directo O(1)

A diferencia de las bases de datos SQL o NoSQL, JMN no realiza búsquedas por nombre de columna o escaneos de índices complejos.
- **Mecanismo**: Cada concepto tiene un `ID_HASH` (uint32_t).
- **Fórmula de Localización**: `Byte_Offset = ID_HASH * ESTRUCTURA_SIZE`.
- **Rendimiento**: El tiempo de recuperación de un concepto es constante, sin importar si el archivo pesa 1GB o 1TB. El límite es la velocidad de latencia del SSD (nanosegundos).

## 2. Segmentación de Conocimiento (Sharding)

Para garantizar la robustez y evitar límites del sistema de archivos:
- **Segmentos**: El archivo JMN se divide en fragmentos de **4GB** (`seg_0001.jmn`, `seg_0002.jmn`, etc.).
- **Localización de Segmento**: `Numero_Segmento = ID_HASH / CONCEPTOS_POR_SEGMENTO`.
- **Ventaja**: Permite realizar copias de seguridad en caliente de partes de la memoria sin detener el sistema.

## 3. Mapeo de Memoria (mmap)

Para operar con 400GB en solo 4GB de RAM:
- El sistema operativo crea una ventana de memoria virtual hacia el archivo en el SSD.
- **Carga bajo demanda**: Solo los bytes que la IA "toca" son traídos físicamente a la RAM.
- **Descarga automática**: El SO libera automáticamente las páginas de memoria de conceptos que la IA dejó de usar, manteniendo el consumo de RAM estable.

## 4. Robustez e Integridad (Journaling)

Manejar 400GB implica un riesgo de corrupción ante cortes de energía.
- **WAL (Write-Ahead Logging)**: Cada cambio se anota primero en un log binario pequeño.
- **Atomicidad**: Una actualización de peso solo se considera exitosa si se escribe el checksum final.
- **Recuperación**: Al arrancar, el sistema verifica el último estado válido y repara cualquier inconsistencia en los segmentos.

---

## 📊 Especificaciones Técnicas

| Componente | Configuración | Propósito |
| :--- | :--- | :--- |
| **Tamaño Segmento** | 4,294,967,296 bytes (4GB) | Compatibilidad y estabilidad. |
| **Acceso** | `fseek` + `fread` / `mmap` | Velocidad extrema. |
| **Persistencia** | Sincronización cada 60s | Equilibrio vida de SSD vs Seguridad. |
| **Capacidad Total** | 2,000 GB (2TB) | Conocimiento universal + Vida personal. |
