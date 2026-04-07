$testDirs = Get-ChildItem -Path tests -Include R, S -Directory -Recurse
$totalTests = 0
$passedTests = 0
$failedTests = @()

# Escenarios de estrés adicionales en la raíz de tests
$extraDirs = Get-ChildItem -Path tests\estres -Directory

$allDirs = $testDirs + $extraDirs

foreach ($folder in $allDirs) {
    if ($folder.FullName -like "*P1_18_ingresar_texto*" -or $folder.FullName -like "*P1_17_entrada_filtrada*") {
        # Saltar interactivos
        continue
    }
    
    $jasbFiles = Get-ChildItem -Path $folder.FullName -Filter *.jasb
    foreach ($file in $jasbFiles) {
        $totalTests++
        Write-Host "Probando: $($file.FullName)..." -NoNewline
        
        # Ejecutamos con jb.cmd
        $output = & bin\jb.cmd $file.FullName 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host " [OK]" -ForegroundColor Green
            $passedTests++
        } else {
            Write-Host " [ERROR]" -ForegroundColor Red
            $failedTests += $file.FullName
        }
    }
}

Write-Host "`n========================================"
Write-Host "RESUMEN DE ROBUSTEZ"
Write-Host "========================================"
Write-Host "Total de pruebas: $totalTests"
Write-Host "Exitosas: $passedTests" -ForegroundColor Green
Write-Host "Fallidas: $($failedTests.Count)" -ForegroundColor Red

if ($failedTests.Count -gt 0) {
    Write-Host "`nLista de fallos:"
    foreach ($f in $failedTests) {
        Write-Host " - $f"
    }
    exit 1
} else {
    Write-Host "`n¡Todas las baterías superadas con éxito!" -ForegroundColor Cyan
    exit 0
}
