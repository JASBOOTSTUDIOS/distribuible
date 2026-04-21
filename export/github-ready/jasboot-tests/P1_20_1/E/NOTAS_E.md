# P1_20_1 — notas E

Hay **28** archivos `e_cu_p1201_*.jasb`. Todos deben **fallar al compilar** (`bin\jbc.cmd …`, código ≠ 0). Cada `.jasb` lleva en cabecera un comentario `# E: …` con la descripción del error.

| Archivo | Error que ejemplifica |
|---------|------------------------|
| `e_cu_p1201_funcion_nombre_sin_contexto.jasb` | Nombre de función global como valor en asignación a `entero`. |
| `e_cu_p1201_flotante_funcion_global.jasb` | Mismo identificador de función global en contexto `flotante`. |
| `e_cu_p1201_texto_funcion_global.jasb` | Mismo caso con destino `texto`. |
| `e_cu_p1201_suma_con_funcion_global.jasb` | Función global como operando de `+` sin ser llamada ni valor `funcion`. |
| `e_cu_p1201_imprimir_funcion_global.jasb` | `imprimir` con identificador de función global sin contexto permitido. |
| `e_cu_p1201_ternario_rama_funcion_global.jasb` | Rama del ternario que debería ser `entero` pero es nombre de función global. |
| `e_cu_p1201_si_condicion_funcion_global.jasb` | Condición de `si … entonces` con nombre de función global (no llamada). |
| `e_cu_p1201_mientras_condicion_funcion_global.jasb` | Condición de `mientras … hacer` con nombre de función global. |
| `e_cu_p1201_nested_funcion_en_principal.jasb` | Definición `funcion nombre(` dentro de `principal`. |
| `e_cu_p1201_nested_funcion_en_otra_funcion.jasb` | Definición anidada `funcion nombre(` dentro de otra función. |
| `e_cu_p1201_fin_funcion_faltante.jasb` | Función global sin `fin_funcion` antes de `principal`. |
| `e_cu_p1201_funcion_global_sin_nombre.jasb` | `funcion` sin identificador de nombre antes de `(`. |
| `e_cu_p1201_nombre_funcion_global_reservado.jasb` | Función global con nombre reservado (`mientras`). |
| `e_cu_p1201_param_funcion_tipo_invalido_en_firma.jasb` | Token inválido como tipo de parámetro (`fin_funcion`). |
| `e_cu_p1201_parametro_reservado_y.jasb` | Parámetro llamado `y` (palabra reservada). |
| `e_cu_p1201_retornar_funcion_desde_firma_entero.jasb` | `retorna entero` pero `retornar` de un valor de tipo `funcion`. |
| `e_cu_p1201_funcion_orden_superior_sin_retornar.jasb` | Función con `retorna entero` y cuerpo sin ningún `retornar`. |
| `e_cu_p1201_retornar_fuera_de_funcion.jasb` | `retornar` en `principal`. |
| `e_cu_p1201_llamada_variable_entero.jasb` | Sintaxis de llamada `x(...)` con `x` variable `entero`. |
| `e_cu_p1201_llamada_funcion_inexistente.jasb` | Llamada a función no definida. |
| `e_cu_p1201_macro_flecha_sobran_argumentos.jasb` | Macro flecha: más argumentos en la llamada que parámetros. |
| `e_cu_p1201_macro_flecha_faltan_argumentos.jasb` | Macro flecha: menos argumentos que parámetros. |
| `e_cu_p1201_iife_arity_incorrecta.jasb` | IIFE `((…) => …)(…)` con aridad incorrecta. |
| `e_cu_p1201_lambda_cuerpo_vacio.jasb` | Flecha sin expresión ni bloque antes del `)` de cierre. |
| `e_cu_p1201_llamar_sin_forma_llamada.jasb` | `llamar` no seguido de `nombre( … )`. |
| `e_cu_p1201_duplicar_variable_funcion_local.jasb` | Dos `funcion f` en el mismo bloque. |
| `e_cu_p1201_interpolacion_param_funcion.jasb` | Texto `"${f}"` con `f` de tipo `funcion` (no interpolable; antes se veía un entero engañoso). |
| `e_cu_p1201_imprimir_variable_funcion.jasb` | `imprimir h` con `h` variable `funcion` sin llamada `h(...)`. |

Comprobación rápida (PowerShell, desde la raíz del repo):

```powershell
Get-ChildItem tests\P1_20_1\E\e_cu_p1201*.jasb | ForEach-Object {
  & .\bin\jbc.cmd $_.FullName 2>$null
  if ($LASTEXITCODE -eq 0) { Write-Host "COMPILO (mal): $($_.Name)" }
}
```
