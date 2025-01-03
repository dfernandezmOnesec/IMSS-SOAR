# Configuración inicial
$WorkspaceId = "<Tu-Workspace-ID>"  # ID del Log Analytics Workspace
$SharedKey = "<Tu-Primary-Key>"  # Clave primaria del Workspace
$LogType = "<Tu-Tipo-De-Log>"  # Tipo de log personalizado (p. ej., CustomLog)
$TimeStamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")  # Marca de tiempo del log

# Crear el cuerpo del log
$Body = @(
    @{
        "Timestamp" = $TimeStamp
        "Message" = "Test log entry for NSG"  # Mensaje del log
        "Category" = "<Tu-Categoría>"  # Categoría del log (personalizable)
        "clientIP_s" = "<Tu-IP-Ficticia>"  # IP ficticia o real
        "OperationName" = "<Nombre-De-La-Operación>"  # Nombre de la operación
        "ResultDescription" = "<Descripción-Del-Resultado>"  # Resultado del evento
        "ResourceGroup" = "<Tu-Resource-Group>"  # Grupo de recursos
        "SubscriptionId" = "<Tu-Subscription-ID>"  # ID de la suscripción
    }
)

# Convertir el cuerpo del log a formato JSON
$BodyJson = $Body | ConvertTo-Json -Depth 10 -Compress

# Calcular la firma HMAC para autenticación
$Method = "POST"
$ContentType = "application/json"
$Resource = "/api/logs"
$RFC1123Date = (Get-Date).ToUniversalTime().ToString("R")  # Fecha en formato RFC 1123
$ContentLength = $BodyJson.Length
$StringToHash = "$Method`n$ContentLength`n$ContentType`n$RFC1123Date`n$Resource"

# Convertir a bytes y calcular el HMAC
$BytesToHash = [Text.Encoding]::UTF8.GetBytes($StringToHash)
$DecodedKey = [Convert]::FromBase64String($SharedKey)
$Hash = [System.Security.Cryptography.HMACSHA256]::New($DecodedKey).ComputeHash($BytesToHash)
$Signature = [Convert]::ToBase64String($Hash)

# Crear el encabezado de autorización
$Uri = "https://$WorkspaceId.ods.opinsights.azure.com/api/logs?api-version=2016-04-01"
$Headers = @{
    "Content-Type" = $ContentType
    "Authorization" = "SharedKey ${WorkspaceId}:${Signature}"
    "Log-Type" = $LogType
    "x-ms-date" = $RFC1123Date
}

# Enviar los datos al Log Analytics Workspace
$response = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $Headers -Body $BodyJson

# Verificar la respuesta
if ($response -eq $null) {
    Write-Host "Logs enviados correctamente al Workspace: $WorkspaceId" -ForegroundColor Green
} else {
    Write-Host "Error al enviar logs: $($response | ConvertTo-Json -Depth 10)" -ForegroundColor Red
}
