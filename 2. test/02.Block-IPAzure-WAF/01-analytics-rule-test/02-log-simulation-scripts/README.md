# Pruebas de Logs para WAF (Web Application Firewall)

## Objetivo
Este script de PowerShell permite enviar un **log simulado** a **Azure Log Analytics** con el propósito de probar la **detección de ataques** de **SQL Injection** a una aplicación protegida por **Web Application Firewall (WAF)** de Azure. La prueba simula una **inyección SQL** utilizando una **IP ficticia**.

## Requisitos
- **Azure Log Analytics Workspace** con las claves necesarias.
- **Azure PowerShell** instalado.
- **Aplicación protegida por WAF** en Azure.

## Configuración

### Paso 1: Obtener las credenciales del Workspace
1. Inicia sesión en **Azure Portal**.
2. Ve a **Log Analytics Workspace**.
3. Copia el **Workspace ID** y la **Primary Key** de tu espacio de trabajo.

### Paso 2: Configurar el nombre de la aplicación protegida por WAF
En el script, reemplaza las siguientes variables con los datos correctos:
- `$resourceGroup`: Nombre del grupo de recursos.
- `$applicationGatewayName`: Nombre del Application Gateway.
- `$wafUrl`: URL protegida por el WAF.

### Paso 3: Script de PowerShell para Inyectar Logs en WAF

```powershell
# Configuración inicial
$resourceGroup = "sentinelimssdemo" # Nombre de tu grupo de recursos
$applicationGatewayName = "MiApplicationGateway" # Nombre de tu Application Gateway
$wafUrl = "https://tuaplicacion.azurewebsites.net/path" # URL protegida por el WAF

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
Write-Host "Verificando logs de WAF..." -ForegroundColor Cyan
$wafLogs = Get-AzApplicationGatewayWebApplicationFirewallLog -ResourceGroupName $resourceGroup -ApplicationGatewayName $applicationGatewayName

# Mostrar los logs relevantes
if ($wafLogs) {
    Write-Host "Últimos registros de WAF:" -ForegroundColor Green
    $wafLogs | Format-Table
} else {
    Write-Host "No se encontraron registros recientes en el WAF." -ForegroundColor Yellow
}

### Paso 4: Ejecución del Script
1. Ejecuta cada script en Azure Cloud Shell (debe contar con permisos)

### Paso 5: Varificación 
1. Si el WAF detecta el ataque, el sistema debería bloquear la IP y registrarlo en los logs.
2. Revisa los logs usando Get-AzApplicationGatewayWebApplicationFirewallLog para ver si la inyección SQL fue bloqueada.