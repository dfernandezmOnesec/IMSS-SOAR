# Pruebas de Logs para NSG (Network Security Group)

## Objetivo
Este script de PowerShell permite enviar un **log simulado** a **Azure Log Analytics** para evaluar eventos relacionados con un **Network Security Group (NSG)**. En este caso, se simula una IP ficticia (como `192.168.1.100`) que está siendo bloqueada por una regla personalizada en NSG.

## Requisitos
- **Azure Log Analytics Workspace** con las claves necesarias.
- **Azure PowerShell** instalado.

## Configuración

### Paso 1: Obtener las credenciales del Workspace
1. Inicia sesión en **Azure Portal**.
2. Ve a **Log Analytics Workspace**.
3. Copia el **Workspace ID** y la **Primary Key** de tu espacio de trabajo.

### Paso 2: Configuración de los parámetros del log
En el script, reemplaza las siguientes variables con los datos correctos:
- `$WorkspaceId`: ID de tu espacio de trabajo.
- `$SharedKey`: Clave primaria de tu espacio de trabajo.
- `$LogType`: Nombre del tipo de log (se recomienda `CustomLog`).
- `$TimeStamp`: Fecha y hora de la entrada del log.

### Paso 3: Script de PowerShell para Inyectar Logs en NSG

```powershell
# Configuración inicial
$WorkspaceId = "e3e00569-dbdb-409a-a5d4-02fcfce1c967"  # ID del Workspace
$SharedKey = "H2CVeQLkP/uBN7VLROVt1AoPuFM6tDqt/Bfycq14pS49V0BKuZUpQs0OPF9pQvr5Mv65FTBGMwTcGxWWBPoo7Q=="  # Primary Key del Workspace
$LogType = "CustomLog"  # Tipo de log
$TimeStamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")

# Crear el cuerpo del log con una IP ficticia
$Body = @{
    "Timestamp" = "2025-01-03T16:27:02Z"
    "Message" = "Test log from PowerShell"
    "Category" = "NetworkSecurityGroupEvent"
    "clientIP_s" = "192.168.1.100"  # IP ficticia
    "OperationName" = "NSGRuleEvaluation"
    "ResultDescription" = "Blocked by custom rule"
    "ResourceGroup" = "sentinelimssdemo"
    "SubscriptionId" = "acd754da-298f-423b-b31e-4973af1e1173"
}

# Convertir a JSON
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
### Paso 4: Ejecución del Script
1. Ejecuta cada script en Azure Cloud Shell (debe contar con permisos)

### Paso 5: Varificación 
1. Logs de NSG: Después de ejecutar el script, verifica que el log se haya ingresado correctamente en Log Analytics.
2. Revisa las entradas de NSG usando el portal de Azure Sentinel y asegúrate de que el evento de la IP ficticia esté registrado.
