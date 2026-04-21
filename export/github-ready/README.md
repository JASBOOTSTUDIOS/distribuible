# Export listo para GitHub

Copias generadas por `scripts/preparar-repos-github.ps1` (o `scripts/limpiar-para-github.ps1` para limpiar antes). No edites aqui a mano.

## Publicar un repo (PowerShell)

    cd jasboot-jmn-core
    git init -b main
    git add .
    git commit -m "Initial import"
    git remote add origin https://github.com/TU_USUARIO/TU_REPO.git
    git push -u origin main

Repite en cada subcarpeta (jasboot-compiler, jasboot-ir, jas-runtime, etc.).

## Orden recomendado

1. Con **`-SdkDependienteUnificado`**: solo **sdk-dependiente** (incluye jas-compiler-c, jasboot-ir, jmn-core, jas-runtime, vscode-jasboot, scripts).
2. Sin ese flag: **jasboot-jmn-core**, **jasboot-compiler**, **jasboot-ir**, **jas-runtime** por separado.
3. **jasboot-tests** / **jasboot-docs** con `-IncludeTests` / `-IncludeDocs`.

En el monorepo: `docs/PROYECTO/PUBLICACION_GITHUB.md` (subtree y buenas practicas).
