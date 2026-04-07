# App Simple Forja

Ejemplo minimo para probar el framework **Forja** en modo monolito.

Rutas:

- `/` landing frontend de Forja
- `/salud` respuesta de salud del framework
- `/api/hola` API JSON simple
- `/api/info` informacion basica del monolito

Ejecutar:

```powershell
cd C:\src\jasboot
node .\.vscode\run-jasb.cjs .\examples\forja_app_simple\app.jasb
```

Luego abre:

- `http://127.0.0.1:18100/`
- `http://127.0.0.1:18100/salud`
- `http://127.0.0.1:18100/api/hola`
- `http://127.0.0.1:18100/api/info`
