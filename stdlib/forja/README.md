# Forja

**Forja** es el framework principal de Jasboot para construir sistemas monolíticos full-stack, APIs, servicios backend y frontends servidos desde la misma aplicación.

Idea central:

- `jasboot`: lenguaje
- `Forja`: framework
- aplicaciones: monolitos, APIs, microservicios, sistemas

Principios de esta primera base:

- rendimiento primero
- control directo sobre la red nativa
- respuestas HTTP y JSON expresivas
- ruteo simple por metodo y ruta
- frontend y backend en una sola base
- superficie pequena, clara y extensible

Capas actuales:

- `stdlib/forja/identidad.jasb`: identidad del framework y logo oficial
- `stdlib/forja/frontend.jasb`: respuestas HTML y landing principal
- `stdlib/forja/monolito.jasb`: fachada monolitica para frontend + backend
- `stdlib/Estructa/codigo-jasb/ui.jasb`: base de `Estructa`, la capa declarativa en Jasboot para construir pantallas web sin escribir HTML, CSS ni JS manualmente
- `stdlib/Estructa/codigo-jasb/identidad.jasb`: identidad visual y rutas de activos de `Estructa`
- `stdlib/Estructa/img/Estructa-icono.png`: icono oficial de `Estructa`
- `stdlib/http/http_basico.jasb`: primitivas HTTP/HTTPS
- `stdlib/api/api_basica.jasb`: capa API de alto nivel
- `stdlib/forja/forja.jasb`: fachada framework y experiencia de uso

Logo oficial:

- `stdlib/forja/forja-logo.png`

Ejemplo:

```jasb
usar todas de "..\\stdlib\\forja\\forja.jasb"

funcion app(texto solicitud) retorna texto
    si forja_es_get(solicitud, "/salud") entonces
        retornar forja_salud_ok()
    fin_si

    si forja_es_get(solicitud, "/") entonces
        retornar forja_texto("Sistema en produccion")
    fin_si

    retornar forja_no_encontrado()
fin_funcion

principal
    imprimir forja_http("127.0.0.1", 8080, app)
fin_principal
```

Posicionamiento:

- **Forja: donde se construyen sistemas reales**
- **Forja: rendimiento sin concesiones**

Enfoque monolitico:

- una sola aplicacion puede servir landing, vistas HTML, salud y rutas API
- el frontend y el backend comparten el mismo runtime y la misma base Jasboot

Estructa:

- permite describir pantallas con componentes Jasboot como `estructura_titulo`, `estructura_tarjeta`, `estructura_fila`, `estructura_formulario_get` y `estructura_boton`
- expone una modalidad `estructura_http_bucle(...)` para servir apps UI sin escribir HTML/CSS/JS manualmente
- la reactividad basica de la V1 se apoya en estado derivado de la solicitud (`estructura_estado_texto`, `estructura_estado_entero`) y componentes declarativos renderizados por el framework
