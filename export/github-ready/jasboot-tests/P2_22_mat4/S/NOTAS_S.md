# P2_22_mat4 — notas S

## `s_estres_p22_mat4_mul_mil.jasb`

- Bucle **50 000** iteraciones; cada una hace dos `mat4_mul` encadenados con la identidad (`ac` y `tmp` alternando productos que siguen siendo **I**).
- Salida esperada (línea no vacía): **`1.0000`** (`ac.e0` de la identidad).

Ejecutar: `.\bin\jb.cmd tests\P2_22_mat4\S\s_estres_p22_mat4_mul_mil.jasb`

---

## `s_estres_p22_escena_mvp_vertices.jasb` (escena tipo gráficos)

Simula un **pipeline MVP** sobre una **rejilla de vértices** homogéneos (como muestreo de posiciones en clip/espacio de trabajo):

- **Modelo**: rotación en **Y** (matriz escrita por `e0`…`e15`) × traslación.
- **Vista** y **proyección** (escala diagonal + traslación “cámara”).
- **`mat4_mul`** encadenado → **MVP**; **`mat4_transpuesta`** de la rotación; **`mat4_inversa`** + **`mat4_mul`** para comprobar **R·R⁻¹** (suma de la traza aproximada al inicio del checksum).
- **Bucles `mientras` anidados** con **límites en `flotante`** (~**777** vértices).
- Cada vértice: **`vec4`**, **`mat4_mul_vec4`**, rama **`si`/`sino`** según `clip.x` vs `clip.y`, acumulado en **`suma`**.
- Cierre: un **`mat4_mul(mvp, rotᵀ)`** y pequeña corrección al checksum.

**Salida esperada** (una línea numérica, luego línea en blanco): **`46.6915`** (float32; `cos`/`sin` en float32 pueden diferir ligeramente de literales fijos; recalibrar con `jb.cmd` si cambia el runtime). La rotación usa **`ang = 0.65`**, **`co = cos(ang)`**, **`sn = sin(ang)`**.

Ejecutar: `.\bin\jb.cmd tests\P2_22_mat4\S\s_estres_p22_escena_mvp_vertices.jasb`
