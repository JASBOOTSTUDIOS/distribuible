# Organización en proyectos GitHub (sin basura)

Guía para partir el ecosistema Jasboot en **repositorios independientes**, con límites claros y sin artefactos innecesarios.

**Exportación automática:** `.\scripts\limpiar-para-github.ps1` (limpia y regenera `export\github-ready`) o `.\scripts\preparar-repos-github.ps1`. **Commits Git independientes** (un repo por carpeta): `.\scripts\commit-repos-independientes.ps1`. Detalle: [PUBLICACION_GITHUB.md](./PUBLICACION_GITHUB.md).

---

## 1. Mapa de repos recomendados (mínimo limpio)

| Repo sugerido | Origen en este árbol | Qué es | Depende de |
|---------------|----------------------|--------|------------|
| **`jasboot-compiler`** | `sdk-dependiente/jas-compiler-c/` | Compilador **jbc** (C): `.jasb` → `.jbo`. | Nada del monolito (árbol autocontenido salvo `bin/` de salida). |
| **`jasboot-vm`** | `sdk-dependiente/jasboot-ir/` | Formato IR, lector y **VM** (`jasboot-ir-vm`). | **`jasboot-jmn-core`** (ver abajo). |
| **`jasboot-jmn-core`** | **`sdk-dependiente/jasboot-jmn-core/`** | JMN + `platform_compat`; la VM lo detecta o usa `JASBOOT_JMN_ROOT`. | Nada. |
| **`jasboot-tests`** | `tests/` | Suite funcional / estrés del lenguaje. | En CI: instalar o compilar `jbc` + `jasboot-ir-vm` (artefactos o submódulos). |
| **`jasboot-docs`** (opcional) | `docs/LENGUAJE/`, `docs/TECNICO/`, `docs/PROYECTO/` (lo que quieras versionar) | Especificación y guías. | Ninguna pieza ejecutable obligatoria. |

Con **tres repos C** queda cerrado el toolchain: **`jasboot-jmn-core`** → **`jasboot-vm`**, y **`jasboot-compiler`** aparte. Librerías grandes en **`.jasb`** o extensiones de editor pueden vivir en **repos aparte** si las necesitas; no forman parte del núcleo de este árbol.

---

## 2. Qué NO subir (basura habitual)

En **cada** repo, mantener un `.gitignore` que cubra al menos:

- Binarios: `*.exe`, `*.o`, `*.obj`, `*.a`, `*.lib`, `*.dll`, `*.so`, `*.dylib`
- Carpetas de build: `build/`, `dist/`, `out/`, `.vs/`, `x64/`, `Debug/`, `Release/`
- Artefactos de compilación Jasboot: `*.jbo` (salvo si un test **muy** concreto los fija como fixtures; lo normal es generarlos en CI)
- Python: `__pycache__/`, `.venv/`, `venv/`
- Node (extensión): `node_modules/`, `.npm/`, paquetes empaquetados `.vsix` si los generas localmente y no los quieres en git
- IDE/OS: `.idea/`, `.DS_Store`, `Thumbs.db`
- Carpetas de trabajo del monolito que no pertenecen al repo extraído: `temp_work/`, `publish/` masiva, dumps de datos

**Regla:** el repo debe contener **fuente + scripts de build + README + licencia**; los binarios se publican en *Releases* o se construyen en CI.

---

## 3. Qué queda fuera del repo “solo lenguaje”

Este monorepo se ha reducido al **toolchain + tests + docs**. Cualquier capa extra (cursos, APIs de producto, extensiones de editor, librerías `.jasb` masivas) conviene versionarla en **otros repositorios** si la retomas.

| Ruta / tema | Nota |
|-------------|------|
| `bin/` en la raíz | Salida de build; no commitear binarios salvo política explícita; regenerar con `build.bat` / `build_vm.bat`. |
| Librerías `.jasb` grandes | Repo dedicado de solo fuente y tests si hace falta. |

---

## 4. Cómo enlazar repos (sin duplicar basura)

1. **`jasboot-vm`** declara dependencia de **`jasboot-jmn-core`**:
   - **Submódulo Git** en una ruta fija (p. ej. `third_party/jasboot-jmn-core`), **o**
   - **Paquete** con versión etiquetada y script de clone en `README`.

2. **`build_vm.bat`** y el `Makefile` de `jasboot-ir`: por defecto usan **`sdk-dependiente/jasboot-jmn-core`**; en otro layout define **`JASBOOT_JMN_ROOT`** (Windows) o **`JMN_PKG`** al invocar `make`.

3. **`jasboot-tests`**: en GitHub Actions (o similar), checkout de `jasboot-compiler` y `jasboot-vm` (o descarga de releases), compilar, poner `jbc` y `jasboot-ir-vm` en `PATH` y ejecutar la cascada / `jbc -e`.

---

## 5. Si prefieres un solo repo (menos mantenimiento)

Un **monorepo** `jasboot` con:

- `packages/compiler-c`, `packages/jasboot-ir`, `packages/jmn-core`, `packages/tests`, `docs/`
- Un **`.gitignore` único** fuerte en la raíz
- CI por carpeta

sigue siendo “limpio” si **nunca** commiteas `bin/`, `node_modules`, objetos ni temporales. Los “repos independientes” son sobre todo para **permisos, releases y ciclos de versión** distintos.

---

## 6. Orden práctico para crearlos en GitHub

1. Crear **`jasboot-jmn-core`** (solo JMN + `platform_compat`), etiqueta `v0.1.0`.
2. Crear **`jasboot-vm`**, enlazar JMN, comprobar `build_vm.bat` / `make`.
3. Crear **`jasboot-compiler`**, comprobar `build.bat`.
4. Crear **`jasboot-tests`** y cablear CI.
5. Opcional: **`jasboot-docs`** (y otros repos de aplicación o librería `.jasb` si los creas).

---

*Documento de referencia para partir el monolito; las rutas son relativas al repositorio actual `jasboot`.*
