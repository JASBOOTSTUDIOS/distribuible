# Estrés P0–P1_14 + 200 módulos (`s_estres_p0_p14_limite200`)

## Generar fuentes

Los 200 `.jasb` hoja y `p/hub.jasb` se generan con PowerShell (UTF-8 **sin BOM**):

```powershell
cd tests\P1_14_usar_modulos\S\s_estres_p0_p14_limite200
powershell -ExecutionPolicy Bypass -File .\generar_limite200.ps1
```

## Estructura

- **4 niveles de carpetas** bajo la raíz del estrés: `p/d0/d1/d2/m_XXX.jasb`.
- **400 `enviar` en disco**: cada hoja exporta `E_XXX` (constante) y `g_XXX` (función). El hub solo hace `usar { g_XXX } de` para no fusionar 200 constantes al main (evita ruido de avisos).
- **200 directivas `usar` + 1 función exportada `run_all`** en `p/hub.jasb` (200 llamadas a `g_000`…`g_199`).
- **Main** (`s_estres_p0_p14_limite200.jasb`): mismo bloque P0/P1 que `s_estres_p14_catalogo_p01_p14.jasb` más `llamar run_all()`; importa beta/gamma y `run_all`.

## Referencia `jbc -e` (desde esta carpeta)

- `run_all` = suma 0..199 = **19900**
- `checksum` total esperado: **107433**
- `estado = listo`, `bandera = ok`, `fib10 = 55`

## Dependencias

- `../s_mod_estres_beta.jasb`, `../s_mod_estres_gamma.jasb` (misma carpeta `S/` que el catálogo P14).

## Notas

- Si al compilar `p/hub.jasb` “no existe `run_all`”, suele ser **BOM** al inicio del archivo: el script actual escribe sin BOM.
- Compilación de este estrés carga **201 módulos** (200 hojas + hub) además de beta/gamma; útil para medir tiempo y memoria del compilador.
