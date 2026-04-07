# Jasboot

Lenguaje **`.jasb`** con compilador en C (**jbc**), IR y máquina virtual (**jasboot-ir-vm**). Este repositorio concentra el **toolchain mínimo**, la suite **`tests/`** y la documentación técnica en **`docs/`**.

## Inicio rápido (Windows)

1. Compilar **jbc:** `sdk-dependiente\jas-compiler-c\build.bat` (deja `bin\jbc.exe`).
2. Compilar la **VM:** `sdk-dependiente\jasboot-ir\build_vm.bat` (deja `sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe`).
3. Ejecutar un programa: `bin\jb.cmd ruta\archivo.jasb` (genera `build\archivo.jbo` y lo ejecuta).

## Estructura

| Ruta | Rol |
|------|-----|
| `sdk-dependiente/jas-compiler-c/` | Compilador **jbc** (`.jasb` → `.jbo`). |
| `sdk-dependiente/jasboot-ir/` | IR, lector y VM. |
| `sdk-dependiente/jasboot-jmn-core/` | JMN + `platform_compat` (build de la VM). |
| `sdk-dependiente/jas-runtime/` | Runtime auxiliar en C. |
| `bin/` | `jb.cmd`, `jbc.cmd`, binarios copiados por los scripts de build. |
| `tests/` | Pruebas funcionales y cascadas. |
| `docs/` | Lenguaje, VM/SDK y notas de proyecto. |
| `scripts/` | Export limpio a GitHub (`sincronizar-export-repos-oficiales.ps1`, `preparar-repos-github.ps1`, …). |

## Documentación

- Índice: [docs/README.md](docs/README.md)
- VM estable: [docs/TECNICO/VM/VM_ESTABLE.md](docs/TECNICO/VM/VM_ESTABLE.md)
- Publicar repos: [docs/PROYECTO/PUBLICACION_GITHUB.md](docs/PROYECTO/PUBLICACION_GITHUB.md)
