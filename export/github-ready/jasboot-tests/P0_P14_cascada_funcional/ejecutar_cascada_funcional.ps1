# Cascada funcional P0_01..P0_10 y P1_11..P1_14 (+ integracion P01-P09 en P0_estres_produccion_*).
# Ejecuta cada .jasb nominal con jbc -e desde el directorio del archivo (rutas relativas de usar).
#
# Uso (desde cualquier cwd):
#   .\ejecutar_cascada_funcional.ps1
#   .\ejecutar_cascada_funcional.ps1 -SkipLimite200
#   .\ejecutar_cascada_funcional.ps1 -IncludeInteractive
#
# Codigo de salida: 0 si todos pasan; distinto de 0 si falla algun jbc.
#
# Nota: dentro de una funcion, "return" dentro de ForEach-Object sale de TODA la funcion
# (no solo de la iteracion). Por eso aqui se usan bucles foreach + continue.

[CmdletBinding()]
param(
    [switch] $SkipLimite200,
    [switch] $IncludeInteractive
)

$ErrorActionPreference = 'Stop'

$here = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $here '..\..')).Path
$testsRoot = Join-Path $repoRoot 'tests'

$jbc = $env:JASBOOT_JBC
if (-not $jbc) {
    $jbc = Join-Path $repoRoot 'bin\jbc.exe'
}
if (-not (Test-Path -LiteralPath $jbc)) {
    Write-Error "No se encontro jbc.exe. Compila sdk-dependiente\jas-compiler-c\build.bat o define JASBOOT_JBC."
    exit 2
}

$vmExe = Join-Path $repoRoot 'sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe'
$vmTrace = Join-Path $repoRoot 'sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm-trace.exe'
if (-not (Test-Path -LiteralPath $vmExe) -and -not (Test-Path -LiteralPath $vmTrace)) {
    Write-Warning "VM no encontrada en sdk-dependiente\jasboot-ir\bin\. Ejecuta build_vm.bat antes."
}

$interactiveSkip = @(
    's_gusanito_interactivo_colision.jasb',
    's_prueba_ingreso_inmediato_limpiar.jasb'
)

function Test-SNominalFileName {
    param([string] $Name)
    if ($Name -eq 'main.jasb') { return $true }
    if ($Name -match '^(s_produccion|s_estres|s_integracion|s_caos|s_cuatro|s_condicion|s_mientras_|s_pesadilla|s_profundidad|s_redeclaracion|s_flecha)') {
        return $true
    }
    if ($Name -eq 's_gusanito_demo.jasb') { return $true }
    return $false
}

function Get-CascadaCandidates {
    param([string] $PackageDir)

    $list = New-Object 'System.Collections.Generic.List[string]'

    foreach ($sub in @('R', 'N')) {
        $p = Join-Path $PackageDir $sub
        if (-not (Test-Path -LiteralPath $p)) { continue }
        foreach ($f in (Get-ChildItem -LiteralPath $p -Filter '*.jasb' -File)) {
            [void]$list.Add($f.FullName)
        }
    }

    $sRoot = Join-Path $PackageDir 'S'
    if (-not (Test-Path -LiteralPath $sRoot)) {
        return ,$list.ToArray()
    }

    foreach ($f in (Get-ChildItem -LiteralPath $sRoot -Filter '*.jasb' -File)) {
        $n = $f.Name
        if ($n -like 's_mod_*') { continue }
        if (Test-SNominalFileName -Name $n) { [void]$list.Add($f.FullName) }
    }

    foreach ($d in (Get-ChildItem -LiteralPath $sRoot -Directory)) {
        $same = Join-Path $d.FullName ($d.Name + '.jasb')
        if (Test-Path -LiteralPath $same) { [void]$list.Add($same) }

        if ($d.Name -like 's_estres_*') {
            foreach ($f in (Get-ChildItem -LiteralPath $d.FullName -Filter '*.jasb' -File)) {
                if ($f.Name.StartsWith('_')) { continue }
                if ($f.FullName -eq $same) { continue }
                [void]$list.Add($f.FullName)
            }
        }

        if ($d.Name -eq 'casos_usar_enviar') {
            foreach ($f in (Get-ChildItem -LiteralPath $d.FullName -Filter 'cu_*.jasb' -File)) {
                [void]$list.Add($f.FullName)
            }
        }
    }

    return ,$list.ToArray()
}

$prefixes = @(
    'P0_01', 'P0_02', 'P0_03', 'P0_04', 'P0_05', 'P0_06', 'P0_07', 'P0_08', 'P0_09', 'P0_10',
    'P1_11', 'P1_12', 'P1_13', 'P1_14'
)

$packageDirs = New-Object 'System.Collections.Generic.List[string]'
foreach ($pref in $prefixes) {
    foreach ($dir in (Get-ChildItem -LiteralPath $testsRoot -Directory | Where-Object { $_.Name -like ($pref + '_*') } | Sort-Object Name)) {
        [void]$packageDirs.Add($dir.FullName)
    }
}

$estresIntegracion = Join-Path $testsRoot 'P0_estres_produccion_P01_P09_integracion'
if (Test-Path -LiteralPath $estresIntegracion) {
    [void]$packageDirs.Add($estresIntegracion)
}

$all = New-Object 'System.Collections.Generic.List[string]'
foreach ($dir in $packageDirs) {
    foreach ($f in (Get-CascadaCandidates -PackageDir $dir)) {
        [void]$all.Add($f)
    }
}

$unique = $all | Sort-Object -Unique

$toRun = New-Object 'System.Collections.Generic.List[string]'
foreach ($path in $unique) {
    $leaf = Split-Path -Leaf $path
    if (-not $IncludeInteractive -and ($interactiveSkip -contains $leaf)) {
        continue
    }
    if ($SkipLimite200 -and $leaf -eq 's_estres_p0_p14_limite200.jasb') {
        continue
    }
    [void]$toRun.Add($path)
}

$ordered = @($toRun | Sort-Object { $_ })

Write-Host "Cascada funcional: $($ordered.Count) archivos .jasb (repo $repoRoot)"
if ($SkipLimite200) { Write-Host '(omitido s_estres_p0_p14_limite200.jasb)' }
if (-not $IncludeInteractive) { Write-Host '(omitidos interactivos: ' ($interactiveSkip -join ', ') ')' }

$fail = 0
$ok = 0
$i = 0
foreach ($file in $ordered) {
    $i++
    $dir = Split-Path -Parent $file
    $name = Split-Path -Leaf $file
    $rel = $file.Substring($repoRoot.Length).TrimStart('\', '/')
    Write-Host "[$i/$($ordered.Count)] $rel" -ForegroundColor Cyan
    Push-Location -LiteralPath $dir
    try {
        & $jbc $name -e 2>&1 | ForEach-Object { Write-Host $_ }
        if ($LASTEXITCODE -ne 0) {
            Write-Host "FALLO (exit $LASTEXITCODE): $rel" -ForegroundColor Red
            $fail++
        }
        else {
            $ok++
        }
    }
    catch {
        Write-Host "EXCEPCION: $_" -ForegroundColor Red
        $fail++
    }
    finally {
        Pop-Location
    }
}

Write-Host "----"
Write-Host "OK: $ok  Fallos: $fail  Total: $($ordered.Count)"
if ($fail -gt 0) { exit 1 }
exit 0
