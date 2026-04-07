$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$repo = Split-Path -Parent $root
$jbc = Join-Path $repo "sdk-dependiente\jas-compiler-c\bin\jbc.exe"
$vmMain = Join-Path $repo "sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm.exe"
$vmTrace = Join-Path $repo "sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm-trace.exe"
$buildDir = Join-Path $PSScriptRoot "build"
$tsBuildDir = Join-Path $PSScriptRoot "build-ts"
$cBuildDir = Join-Path $PSScriptRoot "build-c"

New-Item -ItemType Directory -Force $buildDir | Out-Null
New-Item -ItemType Directory -Force $tsBuildDir | Out-Null
New-Item -ItemType Directory -Force $cBuildDir | Out-Null

$vm = if ((Test-Path $vmTrace) -and ((Get-Item $vmTrace).LastWriteTimeUtc -gt (Get-Item $vmMain).LastWriteTimeUtc)) {
    $vmTrace
} else {
    $vmMain
}

$cases = @(
    @{
        Name = "cpu_sum_loop"
        Category = "int_cpu"
        Jasb = Join-Path $PSScriptRoot "cpu_sum_loop.jasb"
        Jbo = Join-Path $buildDir "cpu_sum_loop.jbo"
        Py = Join-Path $PSScriptRoot "python_cpu_sum_loop.py"
        Ts = Join-Path $PSScriptRoot "ts_cpu_sum_loop.ts"
        TsJs = Join-Path $tsBuildDir "ts_cpu_sum_loop.js"
        C = Join-Path $PSScriptRoot "c_cpu_sum_loop.c"
        CExe = Join-Path $cBuildDir "cpu_sum_loop.exe"
    },
    @{
        Name = "mat4_identity"
        Category = "float_math"
        Jasb = Join-Path $repo "tests\P2_22_mat4\S\s_estres_p22_mat4_mul_mil.jasb"
        Jbo = Join-Path $buildDir "mat4_identity.jbo"
        Py = Join-Path $PSScriptRoot "python_mat4_identity.py"
        Ts = Join-Path $PSScriptRoot "ts_mat4_identity.ts"
        TsJs = Join-Path $tsBuildDir "ts_mat4_identity.js"
        C = Join-Path $PSScriptRoot "c_mat4_identity.c"
        CExe = Join-Path $cBuildDir "mat4_identity.exe"
    },
    @{
        Name = "text_concat_length"
        Category = "text_utils"
        Jasb = Join-Path $PSScriptRoot "text_concat_length.jasb"
        Jbo = Join-Path $buildDir "text_concat_length.jbo"
        Py = Join-Path $PSScriptRoot "python_text_concat_length.py"
        Ts = Join-Path $PSScriptRoot "ts_text_concat_length.ts"
        TsJs = Join-Path $tsBuildDir "ts_text_concat_length.js"
        C = Join-Path $PSScriptRoot "c_text_concat_length.c"
        CExe = Join-Path $cBuildDir "text_concat_length.exe"
    },
    @{
        Name = "extraer_subtexto_bucle_bench"
        Category = "text_substring"
        Jasb = Join-Path $PSScriptRoot "extraer_subtexto_bucle_bench.jasb"
        Jbo = Join-Path $buildDir "extraer_subtexto_bucle_bench.jbo"
        Py = Join-Path $PSScriptRoot "python_extraer_subtexto_bucle.py"
        Ts = Join-Path $PSScriptRoot "ts_extraer_subtexto_bucle.ts"
        TsJs = Join-Path $tsBuildDir "ts_extraer_subtexto_bucle.js"
        C = Join-Path $PSScriptRoot "c_extraer_subtexto_bucle.c"
        CExe = Join-Path $cBuildDir "extraer_subtexto_bucle_bench.exe"
    },
    @{
        Name = "text_search_triple"
        Category = "text_search"
        Jasb = Join-Path $PSScriptRoot "text_search_triple.jasb"
        Jbo = Join-Path $buildDir "text_search_triple.jbo"
        Py = Join-Path $PSScriptRoot "python_text_search_triple.py"
        Ts = Join-Path $PSScriptRoot "ts_text_search_triple.ts"
        TsJs = Join-Path $tsBuildDir "ts_text_search_triple.js"
        C = Join-Path $PSScriptRoot "c_text_search_triple.c"
        CExe = Join-Path $cBuildDir "text_search_triple.exe"
    },
    @{
        Name = "function_call_loop"
        Category = "function_calls"
        Jasb = Join-Path $PSScriptRoot "function_call_loop.jasb"
        Jbo = Join-Path $buildDir "function_call_loop.jbo"
        Py = Join-Path $PSScriptRoot "python_function_call_loop.py"
        Ts = Join-Path $PSScriptRoot "ts_function_call_loop.ts"
        TsJs = Join-Path $tsBuildDir "ts_function_call_loop.js"
        C = Join-Path $PSScriptRoot "c_function_call_loop.c"
        CExe = Join-Path $cBuildDir "function_call_loop.exe"
    }
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

function Invoke-CompileTs {
    param(
        [string]$Source,
        [string]$TargetDir
    )

    npx -y -p typescript tsc $Source --target ES2020 --module commonjs --outDir $TargetDir *> $null
    if ($LASTEXITCODE -ne 0) {
        throw "Fallo compilando TypeScript $Source"
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

function Invoke-CollectOutput {
    param(
        [scriptblock]$Action
    )

    $lines = & $Action
    if ($LASTEXITCODE -ne 0) {
        throw "La ejecución devolvió código $LASTEXITCODE"
    }
    return (($lines | ForEach-Object { "$_" }) -join "`n").TrimEnd()
}

function Invoke-AverageMs {
    param(
        [scriptblock]$Action,
        [int]$Repeats = 5
    )

    $sum = 0.0
    for ($i = 0; $i -lt $Repeats; $i++) {
        $sum += (Measure-Command { & $Action | Out-Null }).TotalMilliseconds
        if ($LASTEXITCODE -ne 0) {
            throw "La ejecución devolvió código $LASTEXITCODE"
        }
    }
    return [Math]::Round($sum / $Repeats, 2)
}

$results = @()

foreach ($case in $cases) {
    Invoke-CompileJasb -Source $case.Jasb -Target $case.Jbo
    Invoke-CompileTs -Source $case.Ts -TargetDir $tsBuildDir
    Invoke-CompileC -Source $case.C -Target $case.CExe

    $jasbootOut = Invoke-CollectOutput { & $vm $case.Jbo }
    $pythonOut = Invoke-CollectOutput { python $case.Py }
    $tsOut = Invoke-CollectOutput { node $case.TsJs }
    $cOut = Invoke-CollectOutput { & $case.CExe }

    if ($jasbootOut -ne $pythonOut) {
        throw "La salida no coincide en $($case.Name). Jasboot=[$jasbootOut] Python=[$pythonOut]"
    }
    if ($jasbootOut -ne $tsOut) {
        throw "La salida no coincide en $($case.Name). Jasboot=[$jasbootOut] TypeScript=[$tsOut]"
    }
    if ($jasbootOut -ne $cOut) {
        throw "La salida no coincide en $($case.Name). Jasboot=[$jasbootOut] C=[$cOut]"
    }

    $jasbootMs = Invoke-AverageMs { & $vm $case.Jbo }
    $pythonMs = Invoke-AverageMs { python $case.Py }
    $tsMs = Invoke-AverageMs { node $case.TsJs }
    $cMs = Invoke-AverageMs { & $case.CExe }

    $winner = "jasboot"
    $best = $jasbootMs
    if ($pythonMs -lt $best) {
        $winner = "python"
        $best = $pythonMs
    }
    if ($tsMs -lt $best) {
        $winner = "typescript"
        $best = $tsMs
    }
    if ($cMs -lt $best) {
        $winner = "c"
        $best = $cMs
    }

    $results += [pscustomobject]@{
        Categoria = $case.Category
        Caso = $case.Name
        JasbootMs = $jasbootMs
        PythonMs = $pythonMs
        TypeScriptMs = $tsMs
        CMs = $cMs
        Ganador = $winner
    }
}

$results | Sort-Object Categoria, Caso | Format-Table -AutoSize

""
"Resumen por categoria:"

$summary = foreach ($group in ($results | Group-Object Categoria)) {
    [pscustomobject]@{
        Categoria = $group.Name
        Casos = [int]$group.Count
        JasbootWins = [int](($group.Group | Where-Object { $_.Ganador -eq "jasboot" }).Count)
        PythonWins = [int](($group.Group | Where-Object { $_.Ganador -eq "python" }).Count)
        TypeScriptWins = [int](($group.Group | Where-Object { $_.Ganador -eq "typescript" }).Count)
        CWins = [int](($group.Group | Where-Object { $_.Ganador -eq "c" }).Count)
    }
}

$summary | Sort-Object Categoria | Format-Table -AutoSize
