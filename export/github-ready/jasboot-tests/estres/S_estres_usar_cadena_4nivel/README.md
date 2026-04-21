# S — estrés `usar` / `enviar` (cadena ≥ 4 niveles)

Prueba de carga que combina:

- **Cadena lineal de 4 módulos**: `pkg/l1` → `l2` → `l3` → `l4` (cada uno con `usar todas de "../…"`).
- **Import nominal adicional** en el entrypoint: `usar { hoja_mix } de "pkg/l4/cap_l4.jasb"` (misma hoja por **dos caminos** de fusión).
- **Instrucciones**: `bit_shl`, `bit_shr`, `<<`, muchas llamadas a `funcion` exportadas y **350k** iteraciones.

## Ejecutar

Desde la raíz del repo (ruta al main):

```powershell
.\bin\jb.cmd tests\S_estres_usar_cadena_4nivel\s_estres_usar_main.jasb
```

Los `usar` usan rutas **relativas al archivo** que contiene la directiva (véase P1_14).

## Árbol

```
S_estres_usar_cadena_4nivel/
  s_estres_usar_main.jasb
  pkg/l1/cap_l1.jasb
  pkg/l2/cap_l2.jasb
  pkg/l3/cap_l3.jasb
  pkg/l4/cap_l4.jasb
```

Ver `NOTAS_S.md` para salida esperada.
