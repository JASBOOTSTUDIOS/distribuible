@echo off
echo === CORRIGIENDO IMPORTACIONES EN LIBRERÍA ANALÍTICA-NEURONAL ===
echo.

REM Corregir archivos principales
echo Corrigiendo: visualizacion\graficos_analiticos.jasb
powershell "(Get-Content 'visualizacion\graficos_analiticos.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'visualizacion\graficos_analiticos.jasb'"

echo Corrigiendo: prediccion\modelos_prediccion.jasb
powershell "(Get-Content 'prediccion\modelos_prediccion.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'prediccion\modelos_prediccion.jasb'"

echo Corrigiendo: metricas\metricas_regresion.jasb
powershell "(Get-Content 'metricas\metricas_regresion.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'metricas\metricas_regresion.jasb'"

echo Corrigiendo: metricas\metricas_clasificacion.jasb
powershell "(Get-Content 'metricas\metricas_clasificacion.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'metricas\metricas_clasificacion.jasb'"

echo Corrigiendo: metricas\metricas_clustering.jasb
powershell "(Get-Content 'metricas\metricas_clustering.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'metricas\metricas_clustering.jasb'"

echo Corrigiendo: validacion\split_datos.jasb
powershell "(Get-Content 'validacion\split_datos.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'validacion\split_datos.jasb'"

echo Corrigiendo: validacion\cross_validation.jasb
powershell "(Get-Content 'validacion\cross_validation.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'validacion\cross_validation.jasb'"

echo Corrigiendo: preprocesamiento\normalizacion.jasb
powershell "(Get-Content 'preprocesamiento\normalizacion.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'preprocesamiento\normalizacion.jasb'"

echo Corrigiendo: machine_learning\arboles_decision.jasb
powershell "(Get-Content 'machine_learning\arboles_decision.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'machine_learning\arboles_decision.jasb'"

echo Corrigiendo: machine_learning\random_forest.jasb
powershell "(Get-Content 'machine_learning\random_forest.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'machine_learning\random_forest.jasb'"

echo Corrigiendo: series_temporales\arima.jasb
powershell "(Get-Content 'series_temporales\arima.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'series_temporales\arima.jasb'"

echo Corrigiendo: machine_learning\gradient_boosting.jasb
powershell "(Get-Content 'machine_learning\gradient_boosting.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'machine_learning\gradient_boosting.jasb'"

echo Corrigiendo: machine_learning\redes_neuronales.jasb
powershell "(Get-Content 'machine_learning\redes_neuronales.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'machine_learning\redes_neuronales.jasb'"

echo Corrigiendo: preprocesamiento\seleccion_features.jasb
powershell "(Get-Content 'preprocesamiento\seleccion_features.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'preprocesamiento\seleccion_features.jasb'"

echo Corrigiendo: machine_learning\clustering_avanzado.jasb
powershell "(Get-Content 'machine_learning\clustering_avanzado.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'machine_learning\clustering_avanzado.jasb'"

echo Corrigiendo: preprocesamiento\reduccion_dim.jasb
powershell "(Get-Content 'preprocesamiento\reduccion_dim.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'preprocesamiento\reduccion_dim.jasb'"

echo Corrigiendo: machine_learning\svm.jasb
powershell "(Get-Content 'machine_learning\svm.jasb') -replace 'usar todas de', 'usar { AnalizadorBase } de' | Set-Content 'machine_learning\svm.jasb'"

echo.
echo === CORRECCIÓN COMPLETADA ===
pause
