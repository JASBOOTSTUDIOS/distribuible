$testFolders = Get-ChildItem -Path tests -Filter R -Directory -Recurse
$totalTests = 0
$passedTests = 0
$failedTests = @()

foreach ($folder in $testFolders) {
    if ($folder.FullName -like "*P1_18_ingresar_texto*") {
        # Skip interactive tests for now
        continue
    }
    
    $jasbFiles = Get-ChildItem -Path $folder.FullName -Filter *.jasb
    foreach ($file in $jasbFiles) {
        $totalTests++
        Write-Host "Running $($file.FullName)..." -NoNewline
        
        $output = & bin\jb.cmd $file.FullName 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host " [PASS]" -ForegroundColor Green
            $passedTests++
        } else {
            Write-Host " [FAIL]" -ForegroundColor Red
            $failedTests += $file.FullName
        }
    }
}

Write-Host "`nSummary:"
Write-Host "Total Tests: $totalTests"
Write-Host "Passed: $passedTests" -ForegroundColor Green
Write-Host "Failed: $($failedTests.Count)" -ForegroundColor Red

if ($failedTests.Count -gt 0) {
    Write-Host "`nFailed Tests List:"
    foreach ($f in $failedTests) {
        Write-Host " - $f"
    }
    exit 1
} else {
    exit 0
}
