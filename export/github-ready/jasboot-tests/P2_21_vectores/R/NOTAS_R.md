# P2_21_vectores — notas R

Ejecutar con `.\bin\jb.cmd tests\P2_21_vectores\R\<archivo>.jasb`.

---

## `r_cu_p21_lab_interactivo_vectores.jasb` (manual)

Programa **interactivo** de consola: menú con `entrada_flotante()`, bucle `mientras`, ramas `si`/`sino si` con comparaciones `flotante`, y uso conjunto de `vec2`/`vec3`/`vec4` (constructores, `+`/`-`/`*` escalar, `vec*_longitud`, `vec*_normalizar`, `vec3_dot`, `vec3_cross`, acceso `.x`/`.y`/`.z`/`.w`, `imprimir_flotante`).

- **Opción 1**: longitud y normalizado de un `vec3` (rechazo explícito si la norma es casi cero).
- **Opción 2**: `vec3_dot` y `vec3_cross` entre dos vectores leídos.
- **Opción 3**: distancia euclídea en 2D con `pb - pa` y `vec2_longitud`.
- **Opción 4**: mezcla lineal de dos `vec4` fijos (rojo ↔ azul) con peso `w`.
- **Opción 5**: proyección de `u` sobre un eje (normalización del eje + `dot` + `eje_u * t`).
- **Opción 0**: salida.

No tiene salida fija automatizable: conviene probarlo en terminal interactiva. Tras cada número, pulsar **Enter** (comportamiento de `entrada_flotante`).

---

## `r_cu_p21_vectores_basico.jasb`

Salida esperada (líneas no vacías, en orden):

| Valor | Significado |
|-------|-------------|
| `5.0000` | `vec2_longitud(vec2(3,4))` |
| `32.0000` | `vec3_dot((1,2,3),(4,5,6))` |
| `1.0000` | `vc.z` tras `vec3_cross` de `(1,0,0)` y `(0,1,0)` |
| `1.0000` | `vec4_longitud(qn)` con `qn` normalizado de `(2,0,0,0)` |

Entre medias, `imprimir ""` produce líneas en blanco.

---

## `r_cu_p21_vec2_distancia_movimiento.jasb`

Uso 2D: vector entre puntos `pb - pa` y longitud (distancia); integración explícita `pos = pos + vel * dt`.

| Valor | Significado |
|-------|-------------|
| `5.0000` | Distancia de `(1,2)` a `(4,6)` |
| `1.0000` | `pos.x` tras un paso con `vel=(10,-5)`, `dt=0.1` |
| `-0.5000` | `pos.y` en el mismo paso |

---

## `r_cu_p21_vec3_normal_triangulo.jasb`

Normal de triángulo: aristas `pb-pa` y `pc-pa`, producto vectorial, normalización. Vértices en el plano `z=0` → normal `+Z`.

| Valor | Significado |
|-------|-------------|
| `0.0000` | `n.x` |
| `0.0000` | `n.y` |
| `1.0000` | `n.z` |
| `1.0000` | `vec3_longitud(n)` |

---

## `r_cu_p21_vec3_iluminacion_dot.jasb`

Factor tipo **N·L** (superficie con normal `+Z`): luz frontal da dot 1; luz lateral `+X` da dot 0.

| Valor | Significado |
|-------|-------------|
| `1.0000` | `vec3_dot` con dirección de luz paralela a la normal |
| `0.0000` | `vec3_dot` con luz ortogonal a la normal |

---

## `r_cu_p21_vec3_proyeccion.jasb`

Proyección de `u` sobre un eje normalizado: `t = vec3_dot(u, eje_u)` y `proy = eje_u * t` (paralelo a iluminación / física con componente a lo largo de un eje).

| Valor | Significado |
|-------|-------------|
| `0.0000` | `proy.x` con `u=(5,3,2)` y eje `+Y` |
| `3.0000` | `proy.y` |
| `0.0000` | `proy.z` |

---

## `r_cu_p21_vec4_mezcla_colores.jasb`

Mezcla lineal `w0*c0 + w1*c1` con `w0=w1=0.5`: rojo y verde en `vec4` → amarillo medio.

| Valor | Significado |
|-------|-------------|
| `0.5000` | `mezcla.x` |
| `0.5000` | `mezcla.y` |
| `0.0000` | `mezcla.z` |
| `1.0000` | `mezcla.w` |
