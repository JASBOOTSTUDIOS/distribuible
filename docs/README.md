# Documentación Jasboot

Mapa de la carpeta `docs/`. Las rutas siguientes son relativas al repositorio (`docs/...`).

**Publicación:** la documentación **explicativa** (sin checklists ni catálogo maestro de tests) se publica en [JASBOOTSTUDIOS/JASBOOTSTUDIO](https://github.com/JASBOOTSTUDIOS/JASBOOTSTUDIO). En **este** monorepo se mantienen también los **checklists**, roadmaps tabulados y el catálogo de instrucciones/tests bajo `PROYECTO/` y `TECNICO/SDK/` — uso interno del equipo.

---

## Por área

| Carpeta | Contenido |
|---------|-----------|
| [LENGUAJE/](LENGUAJE/README.md) | Referencia del lenguaje; **capas:** [CAPAS_JMN_MAI_VM_Y_USO.md](LENGUAJE/CAPAS_JMN_MAI_VM_Y_USO.md); **tipos de relación:** [TIPOS_RELACION_JMN.md](LENGUAJE/TIPOS_RELACION_JMN.md) |
| **TECNICO/** | [VM](TECNICO/VM/VM_ESTABLE.md), especificaciones (JMN, NGF, n_grafo) en esta carpeta; subsistema compilador/FFI en [SDK/](TECNICO/SDK/README.md) |
| [PROYECTO/](PROYECTO/) | Estado del proyecto, roadmaps, pipeline OS-IA, contratos runtime, [catálogo de instrucciones y tests](PROYECTO/CHECKLIST_INSTRUCCIONES_JASBOOT_CATALOGO_TESTS.md) |

---

## Entradas en la raíz de `docs/`

- [REFERENCIA_SINTAXIS_MINIMA_V1.md](REFERENCIA_SINTAXIS_MINIMA_V1.md) — resumen corto; **sintaxis completa actual:** [LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md](LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md)
- **[LENGUAJE/CAPAS_JMN_MAI_VM_Y_USO.md](LENGUAJE/CAPAS_JMN_MAI_VM_Y_USO.md)** — capas JMN, VM, MAI, variantes `*_mai`, percepción, rastro; uso y ejemplos (incluye encaje con Neurixis).
- **[LENGUAJE/TIPOS_RELACION_JMN.md](LENGUAJE/TIPOS_RELACION_JMN.md)** — tipos de arista JMN 1–15, alias en texto, máscaras, simetrías en VM y `pensar_siguiente_mai`.

---

## Punto de partida sugerido

1. **Lenguaje:** [LENGUAJE/README.md](LENGUAJE/README.md)  
2. **VM:** [TECNICO/VM/VM_ESTABLE.md](TECNICO/VM/VM_ESTABLE.md)  
3. **Compilador C y capacidades bajas:** [TECNICO/SDK/README.md](TECNICO/SDK/README.md)  
4. **Estado global:** [PROYECTO/ESTADO_PROYECTO_ACTUAL.md](PROYECTO/ESTADO_PROYECTO_ACTUAL.md)

---

*Última actualización del índice: 2026-05-13*
