# Windows App Simple

Ejemplo de app nativa de Windows con:

- `stdlib/windows/ui.jasb` — primitivas (colores, marco, responsivo, etc.)
- `stdlib/windows/windows_disenio.jasb` — componentes compuestos (hero, tarjeta, formulario, botones, panel lateral, navbar, lista, modal)
- `jasboot_win32_bridge.dll` — puente Win32

## Construccion de la DLL y herramientas

`jbc -e` pone el directorio de trabajo de la VM en la carpeta del `.jasb`, por lo que las rutas en `ui.jasb` (`sdk-dependiente/...`) no encontraban la DLL. **Arreglo:** la VM vuelve a intentar la carga con `JASBOOT_REPO_ROOT` (la fija `jbc` al ejecutar y tambien `run-jasb.cjs`). Tras actualizar el arbol, recompila **VM** y **jbc** una vez:

```bat
cd sdk-dependiente\jasboot-ir
build_vm.bat
cd ..\jas-compiler-c
build.bat
cd ..\jasboot-win32-bridge
build.bat
```

## Ejecucion del ejemplo

```powershell
node .\.vscode\run-jasb.cjs "C:\src\jasboot\examples\windows_app_simple\app.jasb"
```

## Uso de modulos

En el programa principal, **antes** de importar `windows_disenio.jasb` hay que fusionar toda la capa base:

```jasb
usar todas de "../../stdlib/windows/ui.jasb"

usar { ... } de "../../stdlib/windows/windows_disenio.jasb"
```

Asi las funciones internas de `windows_disenio.jasb` resuelven `windows_*` del mismo programa.

## Que hace el ejemplo

- panel lateral oscuro con marca
- barra superior (`windows_navbar_crear`) con marca y botones/enlaces de ejemplo
- bloque hero (titulo + subtitulo)
- tarjeta con resumen
- campo de formulario (etiqueta + entrada)
- boton primario y secundario con estilos predefinidos
- dos filas de lista (`windows_lista_item_crear`)
- modal compuesto (capa + hoja + boton) creado **al final** para quedar encima en orden Z; el bucle usa `windows_ejecutar_paso` + `windows_boton_pulsado` (`stdlib/windows/ui.jasb`) para reaccionar en Jasboot: **Mostrar aviso** abre el modal y **Cerrar** lo oculta con `windows_visible`.

La DLL ya no muestra `MessageBox` al pulsar botones; los clics quedan en `windows_boton_pulsado` para que el programa los gestione. `windows_ejecutar` sigue disponible como bucle bloqueante sin despacho de clics a Jasboot.
