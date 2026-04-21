# R — Rendimiento (`principal` / `fin_principal`), **jbc**

## Archivos

- **`r_baseline_minimo.jasb`**: cuerpo principal vacío. Sirve como referencia de coste mínimo de compilación + ejecución (`jbc -e`).
- **`r_bucle_imprimir.jasb`**: `principal` con `mientras` que incrementa un contador hasta un tope y luego `imprimir` del valor final.

## Medición registrada (una máquina, Windows)

- Programa: `r_bucle_imprimir.jasb` con tope **50 000** iteraciones.
- Comando: `Measure-Command { jbc.exe …\r_bucle_imprimir.jasb -e }`.
- Resultado aproximado: **~112 ms** (solo como orden de magnitud local).

Para estrés con más iteraciones, aumentar el literal en `mientras i < …` (p. ej. 200 000 o 500 000) y volver a medir; el coste crece con el trabajo dentro del `principal`, no con el envoltorio en sí.

## Alcance del test R respecto al checklist

El checklist marca **R** para esta fila porque el programa real vive dentro de `principal`; el coste dominante aquí es el bucle y la VM, no el par de palabras clave.
