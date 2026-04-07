# Estándar de organización y estructura de proyectos Jasboot

Este documento define una **convención de carpetas y archivos** para que los programas y bibliotecas Jasboot escalen con claridad de propósito. Es independiente del dominio (juegos, IA, utilidades): el dominio se refleja en **nombres y subcarpetas bajo `src/`**, no en saltarse el esqueleto base.

---

## Objetivos

- Localizar en segundos: código fuente, datos, pruebas, artefactos de compilación y documentación del paquete.
- Facilitar `usar` con rutas predecibles y pocos niveles de `../`.
- Permitir CI, empaquetado y onboarding sin reglas implícitas.

---

## Layout canónico (paquete aplicación o biblioteca)

Ruta base: directorio raíz del paquete (donde vive `principal.jasb` o donde se invoca `jbc`).

```
<paquete>/
├── principal.jasb              # Punto de entrada (opcional si solo es biblioteca)
├── README.md                    # Qué es el paquete, cómo compilar y ejecutar
│
├── src/                         # Todo el código Jasboot reutilizable por dominio
│   ├── <dominio-o-capa>/        # Ej.: memoria/, ui/, red/, nucleo/
│   │   └── *.jasb
│   └── ...
│
├── tests/                       # Pruebas automáticas (.jasb o runners)
│   ├── golden/                  # Opcional: salidas esperadas
│   └── ...
│
├── data/                        # Datos runtime: .jmn, seeds, corpus, config estática
│   └── ...
│
├── build/                       # Opcional: .jbo y basura de compilación (gitignore)
│   └── ...
│
├── scripts/                     # Opcional: PowerShell/sh que llaman a jbc u host
│   └── ...
│
└── docs/                        # Documentación del paquete (no sustituye docs globales del repo)
    ├── README.md                # Índice del paquete
    ├── arquitectura/            # Diseño propio del paquete
    ├── desarrollo/              # Planes y checklists del paquete
    └── guias/                   # Guías de uso
```

### Reglas del layout

| Ruta | Propósito | No incluir aquí |
|------|-----------|------------------|
| `src/` | Módulos compilados vía `usar` y lógica compartida | `principal` monolítico de miles de líneas sin partir |
| `tests/` | Casos de regresión, goldens, repros mínimos | datos de producción pesados |
| `data/` | Archivos que el programa lee/escribe por ruta conocida | secretos sin cifrar |
| `build/` o `out/` | Salida de `jbc` (`.jbo`) | fuente |
| `docs/` | Texto del equipo sobre **este** paquete | la referencia sintáctica global del repo (mantener en `docs/LENGUAJE` raíz si es central) |

Si el paquete es **solo biblioteca** (sin ejecutable propio), se omite `principal.jasb` y el README indica qué módulo importar desde otros paquetes.

---

## Convenciones de nombres

### Carpetas

- **Minúsculas**, palabras separadas por **guión**: `memoria-neuronal`, `lobulo-frontal`.
- Un solo concepto por nivel: evitar `src/misc/`; preferir `src/util/` o nombre concreto.
- Profundidad habitual: **2–4 niveles** bajo `src/`; más niveles solo si reflejan contenedor estable (por ejemplo capa → submódulo).

### Archivos `.jasb`

- **Minúsculas**, **guión** entre palabras: `secuencias_memoria.jasb` y `guardar_informacion.jasb` son aceptables si ya existen; para **nuevo** código se recomienda **kebab-case consistente** en todo el paquete: `secuencias-memoria.jasb`, `guardar-informacion.jasb`.
- Un archivo principal por **unidad de responsabilidad** (una familia de funciones o un subsistema pequeño). Evitar archivos de varios miles de líneas sin partición.

### Punto de entrada

- Nombre fijo recomendado: **`principal.jasb`** en la raíz del paquete, para que herramientas y documentación no busquen variantes.

---

## Módulos y `usar`

- Las rutas en `usar` son **relativas al archivo que compila**; al mover archivos hay que actualizar `usar`.
- Desde `tests/foo.jasb`, la convención es subir hasta `src/` con un número fijo de segmentos, por ejemplo: `usar "../src/memoria/secuencias-memoria.jasb"`.
- Evitar cadenas de `../../../../..`; si aparece, considerar **aplacar tests** o un directorio intermedio bajo `tests/suites/<area>/`.

No hay hoy un “sistema de paquetes con nombre absoluto” estándar en el toolchain: la **previsibilidad de carpetas** reduce el dolor de rutas relativas.

---

## Perfiles de proyecto

### Perfil A — Aplicación clásica

- `principal.jasb` + `src/` por capas (`nucleo/`, `adaptadores/`, `dominio/`).
- `data/` para persitencia y seeds.
- `tests/` con goldens si hay salida estable.

### Perfil B — Biblioteca reutilizable

- Sin `principal.jasb` o con `ejemplos/principal-demo.jasb` aparte.
- API pública documentada en `docs/` y en comentarios de cabecera de los `.jasb` de `src/`.

### Perfil C — Dominio fijo (paquetes grandes en `.jasb`)

Estructura por **metáfora o mapa del dominio** bajo `src/` (por ejemplo etapas de pipeline o submódulos temáticos), **siempre** manteniendo `tests/`, `data/` y `docs/` como arriba. Si el paquete crece mucho, conviene **repo Git propio** con el mismo esqueleto (`src/`, `tests/`, `docs/`).

---

## Artefactos y control de versiones

- Incluir en **`.gitignore`**: `build/`, `*.jbo`, bases generadas `data/*.jmn` si son effímeras, salidas de tests temporales.
- Versionar: fuente `.jasb`, `data/` de ejemplo pequeño, goldens, `docs/` del paquete.

---

## Checklist para un paquete nuevo

- [ ] Existen `src/`, `tests/`, `data/` (aunque `data/` esté vacío con un `.gitkeep`).
- [ ] `README.md` en raíz con comando mínimo de compilación y ejecución.
- [ ] `principal.jasb` (si aplica) delega en `src/` y no concentra todo el sistema.
- [ ] Convención de nombres (carpetas + archivos) documentada en una línea en el README.
- [ ] Rutas `usar` revisables sin más de dos o tres `../` desde cada zona (`tests` vs `src`).

---

## Antipatrones

- Mezclar docenas de `.jasb` sueltos en la raíz del paquete sin `src/`.
- Duplicar la misma lógica en `tests/` y `src/` sin extraer módulo común.
- Depender de rutas absolutas de máquina en el código fuente.
- Crecer `docs/` sin índice (`docs/README.md`) cuando hay más de tres documentos.

---

## Relación con el resto del repositorio Jasboot

- **Sintaxis y semántica** del lenguaje: `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md`.
- **Tests de producción del lenguaje** (VM/compilador): `docs/PROYECTO/CHECKLIST_TESTS_PRODUCCION_JASBOOT.md`.
- Este estándar aplica a **cada paquete** Jasboot; no reemplaza las guías internas de un proyecto específico, las **complementa** con un esqueleto común.

---

*Convención propuesta para el ecosistema Jasboot; ajustar versiones y fechas cuando el equipo apruebe desviaciones documentadas.*
