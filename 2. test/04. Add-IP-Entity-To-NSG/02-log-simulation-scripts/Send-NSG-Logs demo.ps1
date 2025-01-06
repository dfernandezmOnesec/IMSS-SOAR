# Configuración
$workspaceId = "e3e00569-dbdb-409a-a5d4-02fcfce1c967"  # ID del área de trabajo
$sharedKey = "H2CVeQLkP/uBN7VLROVt1AoPuFM6tDqt/Bfycq14pS49V0BKuZUpQs0OPF9pQvr5Mv65FTBGMwTcGxWWBPoo7Q=="  # Clave primaria
$logType = "AzureDiagnostics"  # Tipo de log

# Crear el log en formato JSON
$jsonData = @"
[{
    "TimeGenerated": "$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')",
    "Category": "NetworkSecurityGroupEvent",
    "ResourceId": "/subscriptions/acd754da-298f-423b-b31e-4973af1e1173/resourcegroups/sentinelimssdemo/providers/microsoft.network/networksecuritygroups/front-nsg",
    "clientIP_s": "203.0.113.45",
    "OperationName": "FakeOperation",
    "ResultDescription": "Injected Event"
}]
"@
$jsonData = $jsonData -replace "`r`n", ""  # Elimina saltos de línea si existen

# Generar la firma
$date = [System.DateTime]::UtcNow.ToString("r")
$hmacSha256 = New-Object System.Security.Cryptography.HMACSHA256
$hmacSha256.Key = [Convert]::FromBase64String($sharedKey)  # Establecer la clave correctamente

# Crear el StringToSign
$stringToSign = "POST`n" + $jsonData.Length + "`napplication/json`nx-ms-date:$date`n/api/logs"

# Generar la firma
$signature = [Convert]::ToBase64String($hmacSha256.ComputeHash([Text.Encoding]::ASCII.GetBytes($stringToSign)))
$authorization = "SharedKey ${workspaceId}:${signature}"

# Enviar el log
Invoke-RestMethod -Uri ("https://" + $workspaceId + ".ods.opinsights.azure.com/api/logs?api-version=2016-04-01") `
    -Method Post -Headers @{
        "Authorization" = $authorization
        "Content-Type" = "application/json"
        "Log-Type" = $logType
        "x-ms-date" = $date
    } -Body $jsonData
