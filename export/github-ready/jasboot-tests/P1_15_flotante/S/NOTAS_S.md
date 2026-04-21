# S — estrés flotante (P1_15)

Regresión de **carga** y escenarios integrados sobre `flotante`, bucles, comparaciones, macros flecha, `funcion`/`retornar`, interpolación y ternarios. Ejecutar con `bin\jbc.cmd` … `-e` (o `bin\jb.cmd`).

| Archivo | Qué hace | Salida esperada (VM actual) |
|---------|-----------|-----------------------------|
| `s_estres_p15_triple_bucle_cuadrado.jasb` | Triple bucle 3×5×7; \(t = c + 0.1s + 0.01d\); acumula \(t^2\). | Una línea: `646.3868` (float32; double de referencia ~647.08). |
| `s_estres_p15_malla_comparaciones.jasb` | Malla 50×30; `fa < fb`; acumulador `hits`. | `1500.0000` |
| `s_estres_p15_macro_cascada.jasb` | 4000 llamadas a `macro tick = () => 0.25`; `v = v + tick()`. | `1000.0000` |
| `s_estres_p15_suma_ponderada.jasb` | Suma entera 1..8000; luego `flotante sum = acc * 0.001`. | `32004.0020` |
| `s_estres_p15_hogar_kwh.jasb` | Consumo kWh simulado (3 zonas × 4 semanas × 7 días), precios, IVA acumulado como `total_iva + coste * 0.21` (no usar macro de un argumento tipo `(base) => base * 0.21` en este escenario: bug VM/compilador). | Tres líneas de detalle (sem2 dia3) + resumen: Total sin IVA `80.2404`, IVA `16.8473`, Factura `97.0877`, Pico `6.7200`, cortes `0`. |

Analogía con P1_12: `s_estres_p12_presupuesto_hogar.jasb` cubre el núcleo flecha + texto; aquí el foco es **estabilidad numérica y volumen** en flotante.
