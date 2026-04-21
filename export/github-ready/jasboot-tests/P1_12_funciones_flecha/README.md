# P1_12 — Funciones flecha (`=>`, `macro`)

Batería alineada con el ítem **P1 · 12** del [checklist de catálogo](../../docs/PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md): expresiones `(params) => …`, bloque `=> { … }`, IIFE `((…) => …)(args)` y alias `macro nombre = … => …`.

Guía de lenguaje y regresiones del compilador: [GUIA_P1_12_FLECHAS_Y_MACRO.md](../../docs/PROYECTO/GUIA_P1_12_FLECHAS_Y_MACRO.md).

Las funciones con `funcion` … `fin_funcion` siguen en [tests/P1_11_funcion_retorna_retornar/](../P1_11_funcion_retorna_retornar/).

| Ruta | Rol |
|------|-----|
| `E/` | Errores numerados **`e1.jasb` … `e18.jasb`** (ver `E/NOTAS_E.md`). |
| `R/` | Casos válidos (IIFE, interpolación, `macro`, multilínea). |
| `S/` | Estrés: repetición masiva vía `macro` y escenario **integrado** P0–P1_12 (`s_estres_p12_presupuesto_hogar.jasb`; ver `S/NOTAS_S.md`). |
