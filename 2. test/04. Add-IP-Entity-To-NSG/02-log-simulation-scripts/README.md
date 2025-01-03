# Script para Pruebas de Logs en Azure Log Analytics

## Descripción

Este script en PowerShell envía logs simulados a un **Log Analytics Workspace** en Azure. Está diseñado para probar integraciones personalizadas y validar eventos, como aquellos relacionados con un **Network Security Group (NSG)** o cualquier otro recurso.

---

## Requisitos

1. **Log Analytics Workspace** configurado:
   - Necesitas el **Workspace ID** y la **Primary Key**.
   - Estos valores se obtienen desde el portal de Azure, en la sección **Agent instructions** de tu Workspace.
2. **PowerShell instalado**:
   - Compatible con PowerShell 5.1 o superior.
3. **Conexión a Internet** para enviar los logs.

---

## Configuración

### Paso 1: Obtener Credenciales
1. Accede a tu **Log Analytics Workspace** en el portal de Azure.
2. Copia:
   - **Workspace ID**.
   - **Primary Key**.

### Paso 2: Configurar el Script
1. Abre el archivo del script.
2. Reemplaza las siguientes variables con tus valores:
   - `$WorkspaceId`: ID del Workspace.
   - `$SharedKey`: Clave primaria del Workspace.
   - `$LogType`: Nombre del tipo de log (p. ej., `CustomLog`).
   - Campos del cuerpo (`$Body`):
     - `clientIP_s`: Una IP ficticia o real.
     - `OperationName`: Nombre de la operación a simular.
     - `ResourceGroup`: Grupo de recursos relacionado.
     - `SubscriptionId`: ID de la suscripción de Azure.

---

## Ejecución

1. Guarda el script en un archivo `.ps1` (por ejemplo, `SendLogsToWorkspace.ps1`).
2. Abre una terminal de PowerShell con los permisos necesarios.
3. Ejecuta el script:
   ```bash
   ./SendLogsToWorkspace.ps1
