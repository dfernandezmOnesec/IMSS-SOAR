# Enviar Logs a Log Analytics Workspace

## Descripción

Este script en PowerShell permite enviar logs personalizados al Log Analytics Workspace de Azure. Los datos se registran en una tabla basada en el tipo de log definido (`LogType`).

## Requisitos

1. **Log Analytics Workspace configurado**:
   - ID del Workspace.
   - Clave primaria del Workspace.
2. **Azure PowerShell** instalado.
3. **Conexión a Internet** para enviar los datos al Workspace.

## Configuración

1. Reemplaza los siguientes valores en el script:
   - `<Your-Workspace-Id>`: El ID de tu Log Analytics Workspace.
   - `<Your-Primary-Key>`: La clave primaria de tu Workspace.
   - `<LogType>`: El tipo de log que deseas registrar (por ejemplo, `CustomLogs`).
   - `<Your-Log-Message>`, `<Your-Category>`, `<Your-Client-IP>`, etc.: Detalles específicos del log que deseas enviar.

2. Guarda el script en un archivo `.ps1` (por ejemplo, `SendLogsTemplate.ps1`).

## Ejecución

1. Abre una terminal de PowerShell con permisos administrativos.
2. Ejecuta el script:
   ```bash
   ./SendLogsTemplate.ps1

## Validación 
1. Ve al Log Analytics Workspace y consulta el siguiente query:

```kql
search *
| where TimeGenerated > ago(1h)
| sort by TimeGenerated desc
```

## Solución de Problemas
Problemas de conectividad:

Usa ping para verificar el acceso al endpoint del Workspace:
```bash
ping <Workspace-ID>.ods.opinsights.azure.com
```

