# Configuración inicial
$resourceGroup = "<ResourceGroup>"  # Nombre del grupo de recursos
$applicationGatewayName = "<ApplicationGatewayName>"  # Nombre de tu Application Gateway
$wafUrl = "<WAFUrl>"  # URL protegida por el WAF

# Payload malicioso típico de SQL Injection
$sqlInjectionPayload = "' OR '1'='1' -- "

# Construir la solicitud
$body = @{
    input = $sqlInjectionPayload
}

# Convertir el cuerpo a formato JSON
$jsonBody = $body | ConvertTo-Json -Depth 10

# Configurar la solicitud HTTP POST
$headers = @{
    "Content-Type" = "application/json"
}

# Enviar la solicitud al WAF y capturar la respuesta
try {
    Write-Host "Enviando prueba de SQL Injection al WAF..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri $wafUrl -Method Post -Body $jsonBody -Headers $headers
    Write-Host "Respuesta del servidor:" -ForegroundColor Green
    Write-Host $response
} catch {
    Write-Host "Bloqueo detectado por el WAF o error en la solicitud:" -ForegroundColor Red
    Write-Host $_.Exception.Message
}

# Verificar logs del WAF (opcional)
Write-Host "Verificando logs de WAF (si tienes permisos para acceder al recurso)..." -ForegroundColor Cyan
$wafLogs = Get-AzApplicationGatewayWebApplicationFirewallLog -ResourceGroupName $resourceGroup -ApplicationGatewayName $applicationGatewayName

# Mostrar los logs relevantes
if ($wafLogs) {
    Write-Host "Últimos registros de WAF:" -ForegroundColor Green
    $wafLogs | Format-Table
} else {
    Write-Host "No se encontraron registros recientes en el WAF." -ForegroundColor Yellow
}
