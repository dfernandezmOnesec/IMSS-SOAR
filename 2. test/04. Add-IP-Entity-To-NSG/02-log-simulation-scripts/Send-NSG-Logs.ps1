# Configuración inicial
$WorkspaceId = "<WorkspaceId>"  # ID del Workspace            
$SharedKey = "<PrimaryKey>"  # Primary Key del Workspace
$LogType = "<LogType>"  # Tipo de log
$TimeStamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")

# Crear el cuerpo del log con una IP ficticia
$Body = @{
    "Timestamp" = "<Timestamp>"
    "Message" = "<Message>"
    "Category" = "NetworkSecurityGroupEvent"
    "clientIP_s" = "<ClientIP>"  # IP ficticia
    "OperationName" = "NSGRuleEvaluation"
    "ResultDescription" = "Blocked by custom rule"
    "ResourceGroup" = "<ResourceGroup>"
    "SubscriptionId" = "<SubscriptionId>"
}

# Convertir el cuerpo a JSON
$BodyJson = $Body | ConvertTo-Json -Depth 10 -Compress

# Calcular la firma HMAC
$Method = "POST"
$ContentType = "application/json"
$Resource = "/api/logs"
$RFC1123Date = (Get-Date).ToUniversalTime().ToString("R")  # Asegurarse de que esté en formato RFC 1123
$ContentLength = $BodyJson.Length
$StringToHash = "$Method`n$ContentLength`n$ContentType`n$RFC1123Date`n$Resource"

# Convertir a bytes y calcular HMAC
$BytesToHash = [Text.Encoding]::UTF8.GetBytes($StringToHash)
$DecodedKey = [Convert]::FromBase64String($SharedKey)
$Hash = [System.Security.Cryptography.HMACSHA256]::New($DecodedKey).ComputeHash($BytesToHash)
$Signature = [Convert]::ToBase64String($Hash)

# Crear el encabezado de autorización
$Authorization = "SharedKey ${WorkspaceId}:${Signature}"

# Construir el request
$Uri = "https://$WorkspaceId.ods.opinsights.azure.com/api/logs?api-version=2016-04-01"
$Headers = @{
    "Content-Type" = $ContentType
    "Authorization" = $Authorization
    "Log-Type" = $LogType
    "x-ms-date" = $RFC1123Date
}

# Enviar los datos
$response = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $Headers -Body $BodyJson

# Verificar la respuesta
if ($response -eq $null) {
    Write-Host "Logs enviados correctamente al Workspace: $WorkspaceId" -ForegroundColor Green
} else {
    Write-Host "Error al enviar logs: $($response | ConvertTo-Json -Depth 10)" -ForegroundColor Red
}
