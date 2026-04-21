# `S_estres_vital_analytics` — estrés integrado “usable” (mapa, lista, funciones, módulos)

Suite **modular** que simula un **agregador ligero de eventos**: histograma por tipo (`mapa`), ventana acotada de muestras (`lista` + `lista_limpiar`), **tabla de funciones** en mapa (estrategias que alimentan un acumulador), **`intentar`/`atrapar`** ante clave inexistente, **`seleccionar`**, **`concatenar`/`str_desde_numero`/`longitud`**.

## Módulos

| Archivo | Rol |
|---------|-----|
| `v00_escala.jasb` | **Único punto de escala**: `VITAL_OUTER` (iteraciones), `VITAL_RING_MAX` (tope antes de vaciar la ventana), `VITAL_KINDS` (bins del histograma). |
| `v01_evento.jasb` | Generador sintético `vital_tick_evento` (LCG). |
| `v02_frecuencias.jasb` | Bootstrap del histograma, incremento y máximo por bin. |
| `v03_contrib.jasb` | Tres contribuciones al acumulador + `vital_aplicar_contrib` (orden superior). |
| `vital_main.jasb` | Orquestación, `usar` nominal y `usar todo`. |

## Ejecución

Desde **esta carpeta** (las rutas `de "…"` son relativas al `.jasb` principal):

```powershell
Set-Location tests\S_estres_vital_analytics
& ..\..\sdk-dependiente\jas-compiler-c\bin\jbc.exe vital_main.jasb -e
```

## Salida de referencia (toolchain actual)

Con los valores por defecto en `v00_escala.jasb` (`OUTER=20000`, `RING_MAX=4000`, `KINDS=48`), la VM imprime en orden:

1. Acumulador `acc` (entero).
2. Línea vacía.
3. Máximo conteo en un bin del histograma (`topbin`).
4. Línea vacía.
5. Veces que se vació la ventana (`picos`).
6. Línea vacía.
7. Tamaño final de la lista ventana.
8. Línea vacía.
9. Texto `ticks=20000` (refleja `VITAL_OUTER`).
10. Línea vacía.
11. `vital:ok`.
12. Línea vacía.

Valores numéricos de las líneas 1, 3, 5 y 7 **cambian** si alteras `v00_escala.jasb`; vuelve a anotarlos aquí tras ajustar la escala.

## Escalar

- Subir **carga CPU**: aumenta `VITAL_OUTER`.
- Más **memoria de ventana** (más `mem_lista_agregar` antes de cada `lista_limpiar`): sube `VITAL_RING_MAX`.
- Histograma más fino: sube `VITAL_KINDS` (y el coste de `vital_max_bin` + bootstrap).

Añadir una nueva estrategia: exporta otra `funcion vital_cont_*` en `v03_contrib.jasb`, regístrala en `ops` en el main con una clave nueva y ajusta `i % 3` → `i % 4` (o usa un mapa de más entradas y un selector propio).
