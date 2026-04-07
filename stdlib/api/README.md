# API Basica Jasboot

`stdlib/api/api_basica.jasb` es la primera capa de alto nivel para construir APIs sobre la red nativa de Jasboot.

Incluye:

- parseo de metodo, ruta y cuerpo
- coincidencia simple por metodo+ruta
- respuestas HTTP completas de texto y JSON
- adaptadores HTTP y HTTPS para handlers Jasboot

Patron base:

```jasb
usar todas de "..\\stdlib\\api\\api_basica.jasb"

funcion manejar(texto solicitud) retorna texto
    si api_coincide(solicitud, "GET", "/salud") entonces
        retornar api_json_ok("{\"estado\":\"ok\"}")
    fin_si
    retornar api_no_encontrado()
fin_funcion

principal
    imprimir api_http_una_vez("127.0.0.1", 8080, manejar)
fin_principal
```
