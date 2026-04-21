$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$repo = Split-Path -Parent $root
$jbc = Join-Path $repo "sdk-dependiente\jas-compiler-c\bin\jbc.exe"
$vmMain = Join-Path $repo "sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe"
$vmTrace = Join-Path $repo "sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm-trace.exe"
$buildDir = Join-Path $PSScriptRoot "build"
$cBuildDir = Join-Path $PSScriptRoot "build-c"
$tmpDir = Join-Path $PSScriptRoot "tmp"

New-Item -ItemType Directory -Force $buildDir | Out-Null
New-Item -ItemType Directory -Force $cBuildDir | Out-Null
New-Item -ItemType Directory -Force $tmpDir | Out-Null

$vm = if ((Test-Path $vmTrace) -and ((Get-Item $vmTrace).LastWriteTimeUtc -gt (Get-Item $vmMain).LastWriteTimeUtc)) {
    $vmTrace
} else {
    $vmMain
}

$d8 = $env:JASBOOT_D8
if (-not $d8) {
    try {
        $cmd = Get-Command d8 -ErrorAction Stop
        if ($cmd) {
            $d8 = $cmd.Source
        }
    } catch {
        $d8 = $null
    }
}
if (-not $d8) {
    $jsvuV8 = Join-Path $HOME ".jsvu\\bin\\v8.cmd"
    if (Test-Path $jsvuV8) {
        $d8 = $jsvuV8
    }
}

function New-Case {
    param(
        [string]$Name,
        [string]$Category,
        [string]$Jasb,
        [string]$Jbo,
        [string]$Js,
        [string]$D8Js,
        [string]$C,
        [string]$CExe,
        [string]$WorkingDir,
        [bool]$EnableD8 = $true
    )

    [pscustomobject]@{
        Name = $Name
        Category = $Category
        Jasb = $Jasb
        Jbo = $Jbo
        Js = $Js
        D8Js = $D8Js
        C = $C
        CExe = $CExe
        WorkingDir = $WorkingDir
        EnableD8 = $EnableD8
    }
}

$cases = @(
    (New-Case -Name "collections_large" -Category "collections" -Jasb (Join-Path $PSScriptRoot "collections_large.jasb") -Jbo (Join-Path $buildDir "collections_large.jbo") -Js (Join-Path $PSScriptRoot "collections_large.js") -D8Js (Join-Path $PSScriptRoot "collections_large.js") -C (Join-Path $PSScriptRoot "collections_large.c") -CExe (Join-Path $cBuildDir "collections_large.exe") -WorkingDir $PSScriptRoot),
    (New-Case -Name "records_walk" -Category "objects" -Jasb (Join-Path $PSScriptRoot "records_walk.jasb") -Jbo (Join-Path $buildDir "records_walk.jbo") -Js (Join-Path $PSScriptRoot "records_walk.js") -D8Js (Join-Path $PSScriptRoot "records_walk.js") -C (Join-Path $PSScriptRoot "records_walk.c") -CExe (Join-Path $cBuildDir "records_walk.exe") -WorkingDir $PSScriptRoot),
    (New-Case -Name "array_heavy_numeric" -Category "arrays" -Jasb (Join-Path $PSScriptRoot "array_heavy_numeric.jasb") -Jbo (Join-Path $buildDir "array_heavy_numeric.jbo") -Js (Join-Path $PSScriptRoot "array_heavy_numeric.js") -D8Js (Join-Path $PSScriptRoot "array_heavy_numeric.js") -C (Join-Path $PSScriptRoot "array_heavy_numeric.c") -CExe (Join-Path $cBuildDir "array_heavy_numeric.exe") -WorkingDir $PSScriptRoot),
    (New-Case -Name "string_realistic_pipeline" -Category "strings" -Jasb (Join-Path $PSScriptRoot "string_realistic_pipeline.jasb") -Jbo (Join-Path $buildDir "string_realistic_pipeline.jbo") -Js (Join-Path $PSScriptRoot "string_realistic_pipeline.js") -D8Js (Join-Path $PSScriptRoot "string_realistic_pipeline.js") -C (Join-Path $PSScriptRoot "string_realistic_pipeline.c") -CExe (Join-Path $cBuildDir "string_realistic_pipeline.exe") -WorkingDir $PSScriptRoot),
    (New-Case -Name "native_io_roundtrip" -Category "io" -Jasb (Join-Path $PSScriptRoot "native_io_roundtrip.jasb") -Jbo (Join-Path $buildDir "native_io_roundtrip.jbo") -Js (Join-Path $PSScriptRoot "native_io_roundtrip.js") -D8Js (Join-Path $PSScriptRoot "native_io_roundtrip.d8.js") -C (Join-Path $PSScriptRoot "native_io_roundtrip.c") -CExe (Join-Path $cBuildDir "native_io_roundtrip.exe") -WorkingDir $tmpDir -EnableD8 $false),
    (New-Case -Name "json_roundtrip" -Category "json" -Jasb (Join-Path $PSScriptRoot "json_roundtrip.jasb") -Jbo (Join-Path $buildDir "json_roundtrip.jbo") -Js (Join-Path $PSScriptRoot "json_roundtrip.js") -D8Js (Join-Path $PSScriptRoot "json_roundtrip.js") -C (Join-Path $PSScriptRoot "json_roundtrip.c") -CExe (Join-Path $cBuildDir "json_roundtrip.exe") -WorkingDir $PSScriptRoot),
    (New-Case -Name "closures_recursion" -Category "closures" -Jasb (Join-Path $PSScriptRoot "closures_recursion.jasb") -Jbo (Join-Path $buildDir "closures_recursion.jbo") -Js (Join-Path $PSScriptRoot "closures_recursion.js") -D8Js (Join-Path $PSScriptRoot "closures_recursion.js") -C (Join-Path $PSScriptRoot "closures_recursion.c") -CExe (Join-Path $cBuildDir "closures_recursion.exe") -WorkingDir $PSScriptRoot)
)

function Invoke-CompileJasb {
    param(
        [string]$Source,
        [string]$Target
    )

    & $jbc $Source -o $Target -e | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Fallo compilando $Source"
    }
}

function Invoke-CompileC {
    param(
        [string]$Source,
        [string]$Target
    )

    gcc -O3 $Source -o $Target
    if ($LASTEXITCODE -ne 0) {
        throw "Fallo compilando C $Source"
    }
}

function Invoke-InWorkingDir {
    param(
        [string]$Dir,
        [scriptblock]$Action
    )

    Push-Location $Dir
    try {
        & $Action
    } finally {
        Pop-Location
    }
}

function Invoke-CollectOutput {
    param(
        [string]$Dir,
        [scriptblock]$Action
    )

    $lines = Invoke-InWorkingDir -Dir $Dir -Action $Action
    if ($LASTEXITCODE -ne 0) {
        throw "La ejecución devolvió código $LASTEXITCODE"
    }
    return (($lines | ForEach-Object { "$_" }) -join "`n").TrimEnd()
}

function Invoke-AverageMs {
    param(
        [string]$Dir,
        [scriptblock]$Action,
        [int]$Repeats = 5
    )

    $sum = 0.0
    for ($i = 0; $i -lt $Repeats; $i++) {
        $sum += (Measure-Command { Invoke-InWorkingDir -Dir $Dir -Action $Action | Out-Null }).TotalMilliseconds
        if ($LASTEXITCODE -ne 0) {
            throw "La ejecución devolvió código $LASTEXITCODE"
        }
    }
    return [Math]::Round($sum / $Repeats, 2)
}

$results = @()
$d8Installed = [bool]$d8

foreach ($case in $cases) {
    $d8Available = $d8Installed -and $case.EnableD8
    Invoke-CompileJasb -Source $case.Jasb -Target $case.Jbo
    Invoke-CompileC -Source $case.C -Target $case.CExe

    $jasbootOut = Invoke-CollectOutput -Dir $case.WorkingDir -Action { & $vm $case.Jbo }
    $nodeOut = Invoke-CollectOutput -Dir $case.WorkingDir -Action { node $case.Js }
    $cOut = Invoke-CollectOutput -Dir $case.WorkingDir -Action { & $case.CExe }
    $d8Out = $null

    if ($d8Available) {
        $d8Out = Invoke-CollectOutput -Dir $case.WorkingDir -Action { & $d8 $case.D8Js }
    }

    if ($jasbootOut -ne $nodeOut) {
        throw "La salida no coincide en $($case.Name). Jasboot=[$jasbootOut] Node=[$nodeOut]"
    }
    if ($jasbootOut -ne $cOut) {
        throw "La salida no coincide en $($case.Name). Jasboot=[$jasbootOut] C=[$cOut]"
    }
    if ($d8Available -and $jasbootOut -ne $d8Out) {
        throw "La salida no coincide en $($case.Name). Jasboot=[$jasbootOut] d8=[$d8Out]"
    }

    $jasbootMs = Invoke-AverageMs -Dir $case.WorkingDir -Action { & $vm $case.Jbo }
    $nodeMs = Invoke-AverageMs -Dir $case.WorkingDir -Action { node $case.Js }
    $cMs = Invoke-AverageMs -Dir $case.WorkingDir -Action { & $case.CExe }
    $d8Ms = $null

    if ($d8Available) {
        $d8Ms = Invoke-AverageMs -Dir $case.WorkingDir -Action { & $d8 $case.D8Js }
    }
    $d8Value = $null
    if ($d8Available) {
        $d8Value = $d8Ms
    }

    $winner = "jasboot"
    $best = $jasbootMs
    if ($nodeMs -lt $best) {
        $winner = "node"
        $best = $nodeMs
    }
    if ($d8Available -and $d8Ms -lt $best) {
        $winner = "d8"
        $best = $d8Ms
    }
    if ($cMs -lt $best) {
        $winner = "c"
        $best = $cMs
    }

    $results += [pscustomobject]@{
        Categoria = $case.Category
        Caso = $case.Name
        JasbootMs = $jasbootMs
        NodeMs = $nodeMs
        D8Ms = $d8Value
        CMs = $cMs
        Ganador = $winner
    }
}

if (-not $d8Installed) {
    Write-Host "Aviso: no se encontró d8. Usa `$env:JASBOOT_D8='ruta\\a\\d8.exe'` para habilitar la comparación directa con V8."
    Write-Host ""
}
if ($d8Installed) {
    Write-Host "Nota: `native_io_roundtrip` no se compara con d8 porque el shell de V8 no expone una API de escritura de archivos equivalente a Node."
    Write-Host ""
}

$results | Sort-Object Categoria, Caso | Format-Table -AutoSize

""
"Resumen por categoria:"

$summary = foreach ($group in ($results | Group-Object Categoria)) {
    $jasbootWins = 0
    $nodeWins = 0
    $d8Wins = 0
    $cWins = 0
    foreach ($entry in $group.Group) {
        switch ("$($entry.Ganador)") {
            "jasboot" { $jasbootWins++ }
            "node" { $nodeWins++ }
            "d8" { $d8Wins++ }
            "c" { $cWins++ }
        }
    }
    [pscustomobject]@{
        Categoria = $group.Name
        Casos = [int]$group.Count
        JasbootWins = [int]$jasbootWins
        NodeWins = [int]$nodeWins
        D8Wins = [int]$d8Wins
        CWins = [int]$cWins
    }
}

$summary | Sort-Object Categoria | Format-Table -AutoSize
