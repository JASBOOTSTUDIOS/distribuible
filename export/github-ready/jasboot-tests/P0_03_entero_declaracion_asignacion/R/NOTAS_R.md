# R — Programas válidos (`entero`, `=`), **jbc**

| Archivo | Qué ejercita | Salida esperada (`jbc -e`) |
|---------|----------------|----------------------------|
| `r_ok_basico.jasb` | Inicialización, declaración sin valor y asignación después, suma en inicialización, reasignación con `0 - 1` | `13` (c = a + b con a = 10, b = 3), luego `-1`. |
| `r_muchos_incrementos.jasb` | Bucle `mientras` con muchas reasignaciones `x = x + 7` | Una línea: `140000` (20 000 iteraciones × 7). Comprueba asignación reiterada sin depender aún de precedencia `*`/`+` (P0 #4). |
