# Estrés: compilar y ejecutar varias veces cada s_produccion_*.jasb de P0_01 a P0_09.
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..\..\..')
$jbc = Join-Path $root 'bin\jbc.exe'
$rels = @(
    'tests\P0_01_principal_fin_principal\S\s_produccion_linea_base.jasb',
    'tests\P0_02_imprimir_literal_expresion\S\s_produccion_tormenta_imprimir.jasb',
    'tests\P0_03_entero_declaracion_asignacion\S\s_produccion_churn_asignaciones.jasb',
    'tests\P0_04_aritmetica_enteros\S\s_produccion_hotpath_aritmetica.jasb',
    'tests\P0_05_comparaciones\S\s_produccion_matriz_comparaciones.jasb',
    'tests\P0_06_condicionales_sino_cuando\S\s_produccion_arbol_si_cuando.jasb',
    'tests\P0_07_mientras\S\s_produccion_triple_bucle_checksum.jasb',
    'tests\P0_08_romper_continuar\S\s_produccion_grilla_busqueda.jasb',
    'tests\P0_09_texto_literal_interpolacion\S\s_produccion_interp_multihueco.jasb',
    'tests\P0_estres_produccion_P01_P09_integracion\S\s_integracion_catalogo_P01_P09.jasb'
)
# P0_02 imprime miles de lineas: pocos ciclos por defecto.
$N = 3
if (-not (Test-Path $jbc)) { throw "No se encontro jbc: $jbc" }
$sw = [System.Diagnostics.Stopwatch]::StartNew()
foreach ($rel in $rels) {
    $path = Join-Path $root $rel
    if (-not (Test-Path $path)) { throw "Falta archivo: $path" }
    for ($k = 1; $k -le $N; $k++) {
        & $jbc $path -e 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Fallo $rel iteracion $k (exit $LASTEXITCODE)" }
    }
}
$sw.Stop()
Write-Output "archivos=$($rels.Count) ciclos_por_archivo=$N tiempo_total_ms=$($sw.ElapsedMilliseconds)"
