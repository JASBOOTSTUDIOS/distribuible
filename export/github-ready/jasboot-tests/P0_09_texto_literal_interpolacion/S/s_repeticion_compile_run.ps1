# Estrés: N ciclos jbc -e sobre programa con interpolacion ${} (bin\jbc.exe).
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$jbc = Join-Path $root 'bin\jbc.exe'
$src = Join-Path $PSScriptRoot '..\R\r_muchos_imprimir_interp.jasb'
$N = 80
if (-not (Test-Path $jbc)) { throw "No se encontro jbc: $jbc" }
if (-not (Test-Path $src)) { throw "No se encontro: $src" }
$sw = [System.Diagnostics.Stopwatch]::StartNew()
for ($k = 1; $k -le $N; $k++) {
    & $jbc $src -e 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Fallo en iteracion $k" }
}
$sw.Stop()
Write-Output "iteraciones=$N tiempo_total_ms=$($sw.ElapsedMilliseconds)"
