# Estrés de producción — integración P0_01 … P0_09

Batería que **combina en un solo programa** las construcciones del catálogo P0 (envoltorio, imprimir, `entero`, aritmética, comparaciones, condicionales, bucles `mientras`/`hacer`…`mientras`, `romper`/`continuar`, `texto` e interpolación `${}`).

| Ruta | Rol |
|------|-----|
| `S/s_integracion_catalogo_P01_P09.jasb` | Pipeline determinista; imprime un checksum final para comprobar regresiones. |
| `S/s_repeticion_compile_run.ps1` | Repite compilación + ejecución (`jbc -e`) sobre el integrador. |
| `S/s_repeticion_todas_producciones_P01_P09.ps1` | Recorre los `.jasb` **s_produccion_*** de cada carpeta `P0_01`…`P0_09`. |
| `S/NOTAS_S.md` | Uso y cifras de referencia. |

Cada carpeta **`tests/P0_0X_*/S/`** incluye además un **`s_produccion_*.jasb`** enfocado en el tema de ese paso, con carga parecida a rutas calientes en producción (bucles grandes, muchas ramas o mucha salida).
