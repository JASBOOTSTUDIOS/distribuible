# VM estable del proyecto

**VM oficial y estable para producción (v1.0):** la **VM IR** del directorio `jasboot-ir/`.

---

## Identificación

| Concepto | Valor |
|----------|--------|
| **Nombre** | jasboot-ir-vm |
| **Binario Windows** | `jasboot-ir-vm.exe` |
| **Binario Unix** | `jasboot-ir-vm` |
| **Ruta preferida** | `sdk-dependiente/jasboot-ir/bin/jasboot-ir-vm.exe` (o `jasboot-ir-vm` en Linux/macOS) |
| **Respaldo** | `bin/jasboot-ir-vm.exe`, luego `bin/jasboot.exe` |

---

## Rol

- Ejecuta el **IR binario** (`.jbo`) generado por el compilador C (`jbc`, `sdk-dependiente/jas-compiler-c`).
- Es la VM que usa:
  - el comando **jbp** (ejecutar, test),
  - la **suite oficial de tests** (`jbp test`),
  - la **guía de inicio rápido** y la documentación de **distribución y entorno**.

Pila estable: **`.jasb` → compilador Python → `.jbo` → jasboot-ir-vm**.

---

## Construcción

- **Windows:** desde `sdk-dependiente/jasboot-ir/`, ejecutar `build_vm.bat` (requiere `gcc` y **`sdk-dependiente/jasboot-jmn-core/`**, o **`JASBOOT_JMN_ROOT`** apuntando a ese paquete).
- **Linux/macOS:** desde `sdk-dependiente/jasboot-ir/`, ejecutar `make`.

---

## Uso

- **`bin/jb.cmd archivo.jasb [args]`** — Compila y ejecuta un programa Jasboot. Usa jbc (compilador C) + jasboot-ir-vm.
- Pila estable: **`.jasb` → jbc (compilador C) → `.jbo` → jasboot-ir-vm**.
