# Asignación de Rol "Network Contributor" a los NSGs

Este documento describe cómo asignar el rol de **Network Contributor** a las identidades administradas o usuarios en los **Network Security Groups (NSGs)** de Azure. El rol **Network Contributor** permite la gestión de reglas de seguridad, lo que es útil en escenarios de automatización o integración con Logic Apps.

## Permisos Requeridos

Para ejecutar los scripts que asignan el rol de **Network Contributor** a los NSGs, debes contar con los siguientes permisos:

- **Permiso de administrador en la suscripción**: El usuario o identidad debe tener permisos para asignar roles en la suscripción.
- **Acceso a la identidad administrada**: El usuario o identidad debe tener acceso a la identidad administrada de la Logic App para obtener el `ObjectId`.
- **Permiso de "Owner" o "User Access Administrator" en los NSGs**: Debes tener permisos para asignar roles a los **Network Security Groups**.

### Pasos Previos

1. **Iniciar sesión en Azure**: Asegúrate de haber iniciado sesión correctamente en tu cuenta de Azure.
2. **Configurar el grupo de recursos y la suscripción**: Verifica que tienes los permisos adecuados sobre la suscripción y el grupo de recursos.
3. **Obtener el ObjectId de la identidad administrada**: Asegúrate de que la identidad administrada asociada a la Logic App tenga los permisos adecuados.

## Script para Asignar el Rol "Network Contributor"

A continuación, se proporciona el script de PowerShell que asigna el rol "Network Contributor" a la identidad administrada en los NSGs especificados.

```powershell
# Asegúrate de que has iniciado sesión en Azure
Connect-AzAccount -UseDeviceAuthentication

# Configuración inicial
$SubscriptionId = "acd754da-298f-423b-b31e-4973af1e1173"  # ID de tu suscripción
$ResourceGroup = "SentinelIMSSDemo"  # Grupo de recursos donde están los NSGs
$AssigneeObjectId = "925b83b2-967d-4ea9-8321-b59886e14de5"  # ObjectId de la identidad administrada

# Lista de los NSGs
$NSGs = @("AZVMPROXY-nsg", "backend-nsg", "front-nsg")

# Asignar el rol "Network Contributor" a cada NSG
foreach ($NSG in $NSGs) {
    # Crear el scope para cada NSG
    $Scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Network/networkSecurityGroups/$NSG"

    # Asignar el rol usando el ObjectId de la identidad administrada
    New-AzRoleAssignment -ObjectId $AssigneeObjectId -RoleDefinitionName "Network Contributor" -Scope $Scope

    # Confirmar la asignación del rol
    Write-Host "Rol 'Network Contributor' asignado a $AssigneeObjectId en $NSG."
}

Write-Host "Los roles han sido asignados correctamente."

## Instrucciones
1. Instalación de Azure PowerShell: Asegúrate de tener Azure PowerShell instalado. Si no lo tienes, puedes instalarlo siguiendo este enlace[https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-13.0.0]

2. Configuración del Script:

- Cambia los valores de $SubscriptionId, $ResourceGroup, y $AssigneeObjectId según tu entorno de Azure.
- Asegúrate de que los NSGs y la identidad administrada están configurados correctamente en tu entorno de Azure.
3. Ejecuta el Script: Ejecuta el script de PowerShell para asignar el rol de Network Contributor a la identidad administrada en los NSGs especificados.

4. Verificación: Al final del script, se confirmará si los roles fueron asignados correctamente.

## Solución de Problemas
Error: "The term 'New-AzRoleAssignment' is not recognized": Asegúrate de que Azure PowerShell esté instalado correctamente.
Error: "Cannot validate argument on parameter 'ObjectId'": Verifica que el ObjectId de la identidad administrada sea correcto y que tengas permisos para asignar roles.
Si encuentras problemas adicionales, no dudes en revisar los registros de actividad de Azure.