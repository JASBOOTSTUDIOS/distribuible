# Estres P1 · 17 (entrada filtrada + catalogo P0–P1_16)

## `s_estres_p17_entrada_filtrada_catalogo.jasb`

Integra, en un solo ejecutable:

- **Modulos (`P1_14`):** `usar todas de` (beta con alpha transitivo), `usar todo de` (gamma), `usar { mod_delta_fn, DELTA_BIAS } de` (delta), `activar_modulo todas de` (epsilon). Archivos en esta misma carpeta: `mod_p17_alpha.jasb` … `mod_p17_epsilon.jasb`.
- **Funciones / `llamar` / macros / bucles / `romper` / `continuar` / `hacer`–`mientras` / `si`–`sino`–`cuando` / ternario / bool.**
- **Flotantes y conversiones:** `convertir_flotante`, `convertir_entero`, `str_desde_numero`.
- **Filtrado (logica alineada con R/):** `contiene_texto` + `codigo_caracter` sobre una tecla sintetica (`"5"`).
- **IO inmediato (acotado, sin bloqueo en stdin vacio):** 8× `percibir_teclado()`, 6× `ingreso_inmediato`; las longitudes se suman al checksum (con stdin vacio suelen ser 0).

**Referencia de salida (VM con `--continuo`, sin entrada por teclado):**

- Tras `limpiar_consola`, aparece una linea con `P17_FPU` y el flotante acumulado (`3.0000` con la semantica actual de `imprimir_flotante`).
- La ultima linea debe ser:

```text
P17_CHECKSUM = 12119
```

- En la salida intermedia debe aparecer `bandera=ok`.

Para recompilar y ejecutar desde la raiz del repo:

```powershell
.\bin\jb.cmd tests\P1_17_entrada_filtrada\S\s_estres_p17_entrada_filtrada_catalogo.jasb
```

Si el checksum cambia tras tocar el compilador o la VM, actualice este archivo y el comentario del propio `.jasb`.

## `entrada_flotante()` (linea completa + digitos)

No se incluye en este estres para evitar bloqueos sin stdin; el caso dedicado sigue siendo **`R/r_entrada_flotante_nativa.jasb`** (tuberia o teclado).
