# **README: Asignación de Rol "Network Contributor" a Identidad Administrada en Varios NSGs**

## **Descripción**
Este script de PowerShell permite asignar el rol **Network Contributor** a una **identidad administrada** en varios **Network Security Groups (NSGs)** dentro de diferentes **grupos de recursos** en una suscripción de Azure.

## **Requisitos**
- **Permisos**: El usuario que ejecute este script debe tener permisos para asignar roles en Azure, específicamente el rol de **Owner** o **User Access Administrator**.
- **Identidad Administrada**: Asegúrate de tener una **identidad administrada** disponible en Azure. Esto puede ser la identidad asociada a una máquina virtual o a un servicio que utilice una identidad administrada.
- **Módulo Az**: Este script requiere el módulo `Az` de PowerShell. Si no lo tienes instalado, puedes hacerlo con el siguiente comando:
  
  ```powershell
  Install-Module -Name Az -AllowClobber -Force -Scope CurrentUser

-Autenticación en Azure: Debes iniciar sesión en Azure con el siguiente comando:
```powershell
Connect-AzAccount -UseDeviceAuthentication

```

## **Uso del script**
1. Configura las Variables:

$resourceGroupNames: Una lista de los grupos de recursos que contienen los NSGs.
$managedIdentityId: El ID de la identidad administrada a la que se le asignará el rol.
$roleName: El nombre del rol a asignar. En este caso, "Network Contributor".
2. Ejecutar el Script:

El script recorrerá cada grupo de recursos en $resourceGroupNames y asignará el rol de Network Contributor a la identidad administrada en cada NSG dentro de esos grupos de recursos.
3. Resultado:

El script imprimirá en la consola un mensaje indicando que el rol ha sido asignado con éxito a cada NSG.

## Script de PowerShell
```powershell
# Configurar las variables necesarias
$resourceGroupNames = @("ResourceGroup1", "ResourceGroup2", "ResourceGroup3")  # Nombres de los grupos de recursos
$managedIdentityId = "<ManagedIdentityId>"  # ID de la identidad administrada
$roleName = "Network Contributor"  # Nombre del rol que se asignará

# Recorremos cada grupo de recursos
foreach ($resourceGroup in $resourceGroupNames) {
    # Obtener todos los NSG en el grupo de recursos
    $nsgs = Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup

    # Recorremos cada NSG en el grupo de recursos
    foreach ($nsg in $nsgs) {
        # Asignar el rol de "Network Contributor" a la identidad administrada para el NSG
        New-AzRoleAssignment -ObjectId $managedIdentityId `
                             -RoleDefinitionName $roleName `
                             -Scope $nsg.Id
        
        Write-Host "Rol 'Network Contributor' asignado a la identidad administrada en NSG: $($nsg.Name) en el grupo de recursos: $resourceGroup" -ForegroundColor Green
    }
}
```
## Ejemplo de Ejecución
```powershell
PS C:\> .\Assign-NetworkContributorRole.ps1
```
## Consideraciones
Asegúrate de que la identidad administrada tenga los permisos necesarios para interactuar con los recursos de Azure.
Este script asigna el rol de Network Contributor en el nivel de cada NSG, lo que permite a la identidad administrada gestionar configuraciones de seguridad en esos NSGs.
## Permisos requeridos
Permisos Requeridos
Asignación de roles: El usuario que ejecute este script debe tener el permiso adecuado para asignar roles en la suscripción de Azure.

Roles necesarios:

Owner o User Access Administrator en la suscripción o en el grupo de recursos.