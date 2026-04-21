# VOID RUNNER — juego interactivo de madurez (Jasboot)

Demo jugable que **enciende a la vez** gran parte del lenguaje y del runtime: módulos con `enviar`, `usar todas de`, `registro`, macros, `llamar`, bucles anidados densos, `ingreso_inmediato`, `limpiar_consola`, cadenas e interpolación, ANSI (`\negr`, `\cian`, `\rojo`, `\verd`, `\amar`, `\norm`), conversiones `convertir_flotante` / `str_desde_numero`, `imprimir_flotante`, y un **núcleo numérico por fotograma** (miles de llamadas a `mod_void_mix`).

## Cómo jugar

Desde la raíz del repo:

```powershell
.\bin\jb.cmd tests\Juego_madurez_void_runner\void_runner.jasb
```

- **@** eres tú, en la penúltima fila.
- **#** son obstáculos que caen; si te ocupan la misma celda, fin de ronda.
- **a** / **d** (mayúsculas o minúsculas): mover una columna.
- **q**: salir.

La entrada usa **espera activa** como en el gusanito: hasta **1 segundo** por turno (`obtener_timestamp` + `diferencia_en_segundos`), haciendo polling con `ingreso_inmediato` hasta que llegue una tecla o se agote el segundo. Sin esto, los fotogramas duran milisegundos y el juego avanza decenas de ticks antes de que puedas pulsar nada.

## Objetivos de diseño

| Objetivo | Cómo se cubre |
|----------|----------------|
| **Profundidad del lenguaje** | `registro EstadoVoid`, `macro`, `llamar` a funciones importadas, condicionales encadenados, aritmética y módulo, textos y `concatenar` en el renderizado fila a fila. |
| **Rendimiento / estrés** | Cada tick ejecuta `VOID_PERF_ITER` veces `mod_void_mix` (LCG); la rejilla hace, por celda, hasta 8 comprobaciones de obstáculos → muchas comparaciones por fotograma. |
| **Dificultad progresiva** | `mod_void_dificultad` reduce el intervalo de aparición conforme sube `st.ticks`. |
| **Victoria de aguante** | Si alcanzas `VOID_LIM_TICKS` sin chocar, el juego termina con mensaje de resistencia (en la práctica es un objetivo extremo para quien suba el límite y baje la dificultad). |

## Modo benchmark (máxima carga)

Edita **`mod_void_core.jasb`**:

- Sube `VOID_PERF_ITER` (por ejemplo **4000–12000**) para castigar CPU por tick.

Edita **`void_runner.jasb`**:

- Sube `VOID_LIM_TICKS` (por ejemplo **80000**) si quieres sesiones largas de aguante.

Vuelve a compilar con `bin\jbc.cmd` (o `jb.cmd`).

## Archivos

| Archivo | Rol |
|---------|-----|
| `mod_void_core.jasb` | Constantes de rejilla, `VOID_PERF_ITER`, funciones exportadas (`mod_void_mix`, `mod_void_mod`, `mod_void_clamp`, `mod_void_dificultad`). |
| `void_runner.jasb` | Bucle principal, 8 slots de obstáculos, renderizado, colisiones, estado con `EstadoVoid`. |

## Relación con otros tests

- La lógica de rejilla e **input inmediato** es del mismo estilo que `tests/P0_estres_produccion_P01_P09_integracion/S/s_gusanito_interactivo_colision.jasb`, pero aquí se añaden **módulos**, **registro**, **macros** y el **núcleo LCG** explícito por fotograma.
