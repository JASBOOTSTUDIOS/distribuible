# Benchmarks Red Nativa

Casos de red nativa sobre la base `bytes` + `tcp` + `tls`, separados por familia metodologica para no mezclar niveles de trabajo.

Incluye:

- Familia `http_https_alto_nivel`:
- `http_loopback_cliente.jasb`
- `https_loopback_cliente.jasb`
- `http_servidor_jasboot_100.jasb`
- `https_servidor_jasboot_100.jasb`
- `http_servidor_node.js` y `https_servidor_node.js`
- `http_cliente_externo.js` y `https_cliente_externo.js`
- Familia `tls_crudo`:
- `tls_loopback_cliente.jasb`
- `tls_loopback_cliente.js`
- `tls_servidor_jasboot_100.jasb`
- `tls_servidor_node.js`
- `tls_cliente_externo.js`

Resultados validados actualmente (`5` rondas por caso, `100` requests por ronda):

| Familia | Caso | Jasboot avg ms | Node/V8 avg ms | Ganador |
| --- | ---: | ---: | --- |
| `http_https_alto_nivel` | `http_loopback_cliente` | `65.992` | `192.028` | `Jasboot` |
| `http_https_alto_nivel` | `https_loopback_cliente` | `207.410` | `287.084` | `Jasboot` |
| `http_https_alto_nivel` | `http_servidor_loopback` | `86.710` | `127.888` | `Jasboot` |
| `http_https_alto_nivel` | `https_servidor_loopback` | `392.112` | `344.860` | `Node/V8` |
| `tls_crudo` | `tls_crudo_cliente` | `229.170` | `316.765` | `Jasboot` |

Lectura rapida:

- La tabla principal ya no mezcla `tls_crudo` con `https_alto_nivel`.
- `tls_crudo_cliente` ya quedo validado como familia separada.
- `tls_crudo_servidor` sigue pendiente de consolidar en `run.ps1`; hoy falla en la automatizacion del arranque del puerto `18447`.
- Las comparaciones historicas anteriores que mezclaban `tls.createServer`, `https.createServer` y variantes de trabajo por request no deben usarse como referencia final.

Notas:

- La VM alterna `jasboot-ir-vm-net.exe` se esta usando para validar la capa de red mientras el binario principal queda desbloqueado.
- HTTPS cliente ya funciona contra hosts externos compatibles con el backend TLS cargado dinamicamente.
- El servidor HTTP actual es sincronico y atiende una conexion por vez.
