# Publicar proyectos Jasboot en GitHub (limpio)

## Opción A — Copia dedicada (recomendada para el primer push)

Desde la raíz del monorepo:

```powershell
# Recomendado: borra logs/objetos sueltos en sdk-dependiente y regenera export\
.\scripts\limpiar-para-github.ps1
.\scripts\limpiar-para-github.ps1 -IncludeTests -IncludeDocs
```

Commits **Git independientes** (un `.git` por carpeta bajo `export/github-ready`):

```powershell
.\scripts\preparar-repos-github.ps1
.\scripts\commit-repos-independientes.ps1 -Message "chore: snapshot"
# Opcional: -RunPreparar para copiar y commitear en un solo paso
```

Solo copia sin limpiar fuentes:

```powershell
.\scripts\preparar-repos-github.ps1
.\scripts\preparar-repos-github.ps1 -IncludeTests -IncludeDocs
```

Se crea **`export/github-ready/`** (ignorada por git en la raíz del monorepo) con subcarpetas:

| Carpeta generada | Contenido origen | Nombre sugerido en GitHub |
|------------------|------------------|---------------------------|
| `jasboot-jmn-core` | `sdk-dependiente/jasboot-jmn-core/` | `jasboot-jmn-core` |
| `jasboot-compiler` | `sdk-dependiente/jas-compiler-c/` | `jasboot-compiler` |
| `jasboot-ir` | `sdk-dependiente/jasboot-ir/` | `jasboot-ir` |
| `jas-runtime` | `sdk-dependiente/jas-runtime/` | `jas-runtime` |
| `jasboot-tests` | `tests/` | solo con `-IncludeTests` |
| `jasboot-docs` | `docs/` | solo con `-IncludeDocs` |
| `sdk-dependiente` | `sdk-dependiente/` (árbol completo) | con **`-SdkDependienteUnificado`** (reemplaza las cuatro filas partidas de arriba en esa ejecución) |

El script usa **robocopy** y excluye `.git`, `node_modules`, `build`, `bin`, `*.o`, `*.exe`, `*.jbo`, etc.

Luego, en cada subcarpeta: `git init`, `git add .`, `git commit`, `git remote add`, `git push`.

### Mantener actualizados los repos oficiales (SDK + tests + docs)

Si en GitHub usas el repo único **[sdk-dependiente](https://github.com/JASBOOTSTUDIOS/sdk-dependiente)** (compilador, VM, JMN, `vscode-jasboot`, etc.) más **tests** y **docs** en repos aparte:

```powershell
.\scripts\sincronizar-export-repos-oficiales.ps1
```

Equivale a limpiar artefactos locales y ejecutar `preparar-repos-github.ps1 -SdkDependienteUnificado -IncludeTests -IncludeDocs`.

Después, en cada clon que ya tenga `git remote` apuntando al repo correcto:

```powershell
cd export\github-ready\sdk-dependiente
git add -A
git status
git commit -m "sync: monorepo jasboot"
git push

cd ..\jasboot-tests
# mismo patrón…

cd ..\jasboot-docs
# mismo patrón…
```

**JASBOOTSTUDIO** (documentación pública con otra estructura de carpetas) no se genera con estos scripts: sincronízala desde `JASBOOTSTUDIO-ws` o merge manual según vuestra política. Las carpetas `tests-ws/` y `JASBOOTSTUDIO-ws/` en el monorepo son espejos de trabajo opcionales; la fuente de verdad para tests y docs “de equipo” sigue siendo `tests/` y `docs/` en la raíz del monorepo.

Para commitear el export en un solo paso (recrear copia + `git add`/`commit` en cada subcarpeta con `.git`):

```powershell
.\scripts\commit-repos-independientes.ps1 -RunPreparar -PrepararIncludeTests -PrepararIncludeDocs -PrepararSdkUnificado -Message "chore: sync monorepo"
```

---

## Opción B — `git subtree` (mantener un solo repo y publicar ramas)

Sin carpeta `export/`, desde la raíz del monorepo con historial unificado:

```bash
git subtree split -P sdk-dependiente/jasboot-jmn-core -b publish-jmn
git push origin publish-jmn:main --force
```

Ajusta `-P` a la ruta real (por ejemplo `sdk-dependiente/jas-compiler-c`). Útil si ya tienes todo en un solo Git y quieres **sincronizar** un subárbol a otro remoto.

---

## Dependencias entre repos

1. **`jasboot-jmn-core`** — primero; no depende de otros.
2. **`jasboot-compiler`** — independiente del JMN del monorepo (lleva su propia copia bajo `src/memoria_neuronal` si aplica al compilador).
3. **`jasboot-ir`** — al compilar necesita **`JASBOOT_JMN_ROOT`** (Windows) o **`JMN_PKG`** con `make`, apuntando al clon de `jasboot-jmn-core`.

---

## Qué no subir nunca

- `node_modules/`, `build/`, `bin/*.exe`, `*.o`, `*.jbo`, `.vs/`, entornos virtuales.
- Cada paquete ya incluye o puede incluir un **`.gitignore`** acorde; el script de exportación filtra lo habitual.

---

## Referencia

- [ORGANIZACION_REPOS_GITHUB.md](./ORGANIZACION_REPOS_GITHUB.md) — mapa conceptual de repos.
