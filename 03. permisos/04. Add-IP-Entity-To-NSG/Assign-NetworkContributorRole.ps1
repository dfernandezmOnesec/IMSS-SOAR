# Iniciar sesion en Azure
Connect-AzAccount -UseDeviceAuthentication


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
