# Estructa App Simple

Ejemplo minimo de app web escrita solo con Jasboot usando `Estructa`.

Que muestra:

- componentes declarativos como `estructura_titulo`, `estructura_tarjeta`, `estructura_fila` y `estructura_formulario_get`
- estado basico derivado de la solicitud mediante `estructura_estado_texto` y `estructura_estado_entero`
- integracion con rutas UI, salud y API dentro de la misma app

Ejecucion:

```powershell
node .\.vscode\run-jasb.cjs .\examples\forja_ui_app_simple\app.jasb
```

Rutas:

- `http://127.0.0.1:18200/`
- `http://127.0.0.1:18200/api/info`
- `http://127.0.0.1:18200/salud`
