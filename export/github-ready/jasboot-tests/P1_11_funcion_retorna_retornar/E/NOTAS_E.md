# E — funcion/retorna/retornar

- `e_retornar_fuera_funcion.jasb`: debe fallar por usar `retornar` fuera de una funcion.
- `e_funcion_sin_fin.jasb`: debe fallar por bloque `funcion` sin `fin_funcion`.
- `e_funcion_parametro_sin_nombre.jasb`: falta nombre de parametro en firma.
- `e_funcion_parametro_sin_tipo.jasb`: falta tipo de parametro en firma.
- `e_funcion_parentesis_sin_cierre.jasb`: firma con `(` sin `)`.
- `e_funcion_con_nombre_reservado.jasb`: nombre de funcion usando palabra reservada.
- `e_funcion_parametro_reservado.jasb`: parametro usando palabra reservada.
- `e_funcion_cuerpo_vacio_incompleto.jasb`: cierre de programa incompleto tras declarar funcion.
- `e_retornar_en_principal_despues_de_codigo.jasb`: `retornar` invalido en `principal` despues de sentencias previas.
- `e_retornar_en_bloque_si_en_principal.jasb`: `retornar` dentro de `si` pero fuera de funcion.
- `e_retornar_en_mientras_en_principal.jasb`: `retornar` dentro de bucle fuera de funcion.
- `e_funcion_anidada_no_permitida.jasb`: declaracion de funcion dentro de `principal`.
- `e_funcion_sin_retorna_tipo.jasb`: declaracion de funcion sin nombre (firma invalida).
- `e_fin_funcion_sin_apertura.jasb`: `fin_funcion` sin `funcion` previa.

