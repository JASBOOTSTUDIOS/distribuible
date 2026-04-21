# P1_20_1 — notas S

- `s_estres_p1201_llamadas_indirectas.jasb`: tres bloques, tres líneas de salida:
  1. **3000** — bucle `aplicar(inc, acc)` (indirecto vía parámetro a global).
  2. **65536** — `h = duplicar` y 16× `aplicar(h, acc)` desde `acc = 1` (2^16).
  3. **107** — una llamada `aplicar(g, 100)` con `g` lambda `(t) => t + 7`.

Notas:

- Bucles largos solo con variable `funcion` apuntando a **lambda** pueden provocar desbordamiento de pila en la VM actual; el estrés masivo usa punteros a **globales**.
- Tras muchas llamadas anidadas, conviene **volver a asignar** `h = duplicar` justo antes del segundo bucle: si `h` se inicializa una sola vez al inicio de `principal`, el valor almacenado puede quedar incorrecto tras miles de `aplicar(inc, acc)` (posible solapamiento o bug de frame en el compilador/VM).

Integración grande (`tests/estres/`): [tests/estres/P1_20_1_banco_sim_ordensuperior/banco_sim_ordensuperior.jasb](../../estres/P1_20_1_banco_sim_ordensuperior/banco_sim_ordensuperior.jasb) — simulación tipo cajero con `aplicar_mov`, `encadenar_mov` (dos callbacks), bucle de micro-depósitos, lambda de bonus y `elegir_por_parity`. Salidas: `700`, `550`, `450`, `550`, `575`, `13`, `8`, y `P1_20_1 banco+rifa HOF OK`. **Límite:** el compilador admite como máximo **4 parámetros** por función; el retiro encadenado usa `200` fijo en el cuerpo (documentado en el `.jasb`).
