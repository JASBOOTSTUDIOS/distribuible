# Estres: repetir compile+run de nuevas instrucciones de terminal.
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$jbc = Join-Path $root 'bin\jbc.exe'
$casos = @(
    (Join-Path $PSScriptRoot 's_estres_ingreso_inmediato_polling.jasb'),
    (Join-Path $PSScriptRoot 's_estres_limpiar_consola_repetido.jasb'),
    (Join-Path $PSScriptRoot 's_estres_mixto_loop_terminal.jasb')
)
$N = 1
if (-not (Test-Path $jbc)) { throw "No se encontro jbc: $jbc" }
$sw = [System.Diagnostics.Stopwatch]::StartNew()
foreach ($src in $casos) {
    if (-not (Test-Path $src)) { throw "No se encontro caso: $src" }
    for ($k = 1; $k -le $N; $k++) {
        & $jbc $src -e 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Fallo en $src iteracion $k" }
    }
}
$sw.Stop()
Write-Output "casos=$($casos.Count) iteraciones_por_caso=$N tiempo_total_ms=$($sw.ElapsedMilliseconds)"

