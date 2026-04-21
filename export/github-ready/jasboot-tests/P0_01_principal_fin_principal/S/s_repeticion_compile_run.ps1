# Estrés: N ciclos compilar + ejecutar con el compilador estable CLI jbc (bin\jbc.exe).
# Programa mínimo: principal / fin_principal (ver ..\R\r_baseline_minimo.jasb).
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$jbc = Join-Path $root 'bin\jbc.exe'
$src = Join-Path $PSScriptRoot '..\R\r_baseline_minimo.jasb'
$out = Join-Path $env:TEMP 'jasboot_p0_01_stress.jbo'
$N = 200
if (-not (Test-Path $jbc)) { throw "No se encontró jbc: $jbc" }
$sw = [System.Diagnostics.Stopwatch]::StartNew()
for ($k = 1; $k -le $N; $k++) {
    & $jbc $src -o $out -e | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Fallo en iteración $k" }
}
$sw.Stop()
Write-Output "iteraciones=$N tiempo_total_ms=$($sw.ElapsedMilliseconds)"
