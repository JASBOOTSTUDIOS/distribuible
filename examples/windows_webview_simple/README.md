# Windows WebView simple



Ventana nativa con **Microsoft Edge WebView2** embebido: muestra una URL en el area cliente.



## Requisitos



1. **Runtime WebView2** ( habitual en Windows 11; en Windows 10 suele instalarse con Edge). Si falta: [Distribución del controlador webview2](https://developer.microsoft.com/microsoft-edge/webview2/).

2. **Cabeceras y loader** del paquete NuGet `Microsoft.Web.WebView2` en:

   `sdk-dependiente/jasboot-win32-bridge/third_party/webview2_pkg/`  

   Si no existe `build/native/include/WebView2.h`, descarga el `.nupkg` y extráelo ahí (o revisa el mensaje de `build.bat`).

3. Compilar la DLL (usa **gcc** + **g++**):



```bat

cd sdk-dependiente\jasboot-win32-bridge

build.bat

```



Esto genera `bin/jasboot_win32_bridge.dll` y copia `WebView2Loader.dll` junto a ella.



## Ejecutar



Mismo flujo que otros ejemplos Windows (`jbc -e` con `JASBOOT_REPO_ROOT` o `run-jasb.cjs` desde la raíz del repo).



API en `stdlib/windows/ui.jasb`: **`windows_webview(app, direccion_url)`** devuelve un control al que puedes aplicar `windows_marco`, `windows_responsivo`, etc.



## Contenido local



Para cargar un `file:///...` o `http://127.0.0.1:...` basta con pasar esa cadena a `windows_webview`.


