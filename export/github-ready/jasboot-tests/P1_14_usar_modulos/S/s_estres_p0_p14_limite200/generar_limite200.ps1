# Genera 200 modulos hoja (4 niveles: p/d0/d1/d2/) + p/hub.jasb con 200 usar y run_all.
# Ejecutar desde esta carpeta: powershell -ExecutionPolicy Bypass -File .\generar_limite200.ps1
$ErrorActionPreference = "Stop"
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
function Write-Utf8NoBom($Path, [string]$Text) {
    [System.IO.File]::WriteAllText($Path, $Text, $utf8NoBom)
}

$root = $PSScriptRoot
$n = 200
$leafDir = Join-Path $root "p\d0\d1\d2"
New-Item -ItemType Directory -Force -Path $leafDir | Out-Null

for ($i = 0; $i -lt $n; $i++) {
    $name = "{0:D3}" -f $i
    $path = Join-Path $leafDir "m_$name.jasb"
    $body = @"
// Hoja $i / $n ; ruta p/d0/d1/d2/ (4 carpetas bajo la raiz del estres).
enviar constante entero E_$name = $i
enviar funcion g_$name() retorna entero
    retornar $i
fin_funcion
"@
    Write-Utf8NoBom $path $body
}

$hub = New-Object System.Text.StringBuilder
[void]$hub.AppendLine("// Hub: $n directivas usar { g_XXX } de (cada hoja sigue exportando E_XXX + g_XXX = $n*2 enviar en disco).")
for ($i = 0; $i -lt $n; $i++) {
    $name = "{0:D3}" -f $i
    [void]$hub.AppendLine("usar { g_$name } de `"d0/d1/d2/m_$name.jasb`"")
}
[void]$hub.AppendLine("")
[void]$hub.AppendLine("enviar funcion run_all() retorna entero")
[void]$hub.AppendLine("    entero s = 0")
for ($i = 0; $i -lt $n; $i++) {
    $name = "{0:D3}" -f $i
    [void]$hub.AppendLine("    s = s + llamar g_$name()")
}
[void]$hub.AppendLine("    retornar s")
[void]$hub.AppendLine("fin_funcion")

$hubPath = Join-Path $root "p\hub.jasb"
Write-Utf8NoBom $hubPath $hub.ToString()
Write-Host "OK: $n hojas + hub -> $hubPath"
