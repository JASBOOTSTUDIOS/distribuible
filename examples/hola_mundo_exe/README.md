# Hola mundo → `.jbo` + `.exe` (launcher)

Jasboot compila **`.jasb` → `.jbo`** (bytecode IR). Ese es el **archivo binario del programa** en el ecosistema Jasboot.

Para obtener un **`.exe` de Windows** que muestre `hola mundo` en consola, este ejemplo añade un **launcher** mínimo en C (`jbo_launcher.c`) que solo ejecuta `jasboot-ir-vm.exe hola_mundo.jbo`.

## Generar artefactos

Desde esta carpeta:

```bat
build_hola_mundo_exe.bat
hola_mundo.exe
```

Requisitos: `jbc.exe` construido, `jasboot-ir-vm.exe` en `sdk-dependiente\jasboot-ir\bin\`, y `gcc` en el PATH.

Si la VM está en otra ruta: `set JASBOOT_VM=C:\ruta\jasboot-ir-vm.exe` antes de `hola_mundo.exe`.

## Archivos

| Archivo | Rol |
|---------|-----|
| `hola_mundo.jasb` | Código fuente Jasboot |
| `hola_mundo.jbo` | Salida binaria del **compilador** Jasboot |
| `jbo_launcher.c` | Stub nativo que localiza VM + `.jbo` |
| `hola_mundo.exe` | PE generado con **gcc** (no con jbc) |
