# R — Programas válidos (`usar`), **jbc**

| Archivo | Qué ejercita | Salida esperada (`jbc -e`) |
|---------|----------------|----------------------------|
| `r_usar_un_modulo.jasb` | `usar todas de` + función `enviar` del módulo | `42` |
| `r_usar_cadena_imports.jasb` | Principal → `usar todas de` anidado → símbolos `enviar` en cadena | `31` (`10*3+1`) |
| `r_mod_export.jasb` | Módulo auxiliar: `enviar funcion doble`, `funcion triple` sin `enviar` | (no es entrypoint obligatorio) |
| `r_usar_named_de.jasb` | `usar { doble } de "r_mod_export.jasb"` | `40` |
| `r_usar_todo_de_export.jasb` | `usar todo de "r_mod_export.jasb"` (solo símbolos `enviar`) | `6` (`doble(3)`) |

Medición: `Measure-Command { & bin\jbc.exe tests\P1_14_usar_modulos\R\r_usar_cadena_imports.jasb -e }` desde la raíz del repo.
