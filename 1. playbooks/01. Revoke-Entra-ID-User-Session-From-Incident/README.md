# Revoke-Entra-ID-User-Session-From-Incident

En caso de presentar alguna duda, por favor, ponerse en contacto con dfernandezm@onesec.mx

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Sentinel%2Fmaster%2FPlaybooks%2FAS-Revoke-Azure-AD-User-Session-From-Incident%2Fazuredeploy.json)

Este playbook está diseñado para ejecutarse desde un incidente de Microsoft Sentinel. Buscará los usuarios de Azure AD asociados con las entidades de la cuenta del incidente y revocará sus sesiones. Se agregará al Incidente un comentario indicando los usuarios afectados.

![RevokeUserSession_Demo_1](./images/RevokeUserSession_Demo_1.png)

![RevokeUserSession_Demo_2](./images/RevokeUserSession_Demo_2.png)


### Requisitos

* Tener un rol de grant admin para asignara permisos a la aplicación que se creará más adelante.
* Acceso como Key Vault Administrator para crear y configurar un cliente secreto. 



### Configuración 

Navegue hasta Entra ID registro de aplicaciones:
https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade

Luego, haga click en "**New registration**".
![RevokeUserSession_App_Registration_1](./images/RevokeUserSession_App_1.png)

Ingrese el nombre **AS-Revoke-Entra-ID-User-Session-From-Incident**" y dele click en registrar:

![RevokeUserSession_App_Registration_2](./images/RevokeUserSession_App_2.png)

Una vez que la aplicación se haya registriado, puede dirigirse a la página de "**Overview**". Dejabo de la sección "**Essentials**" , tome nota de "**Application (client) ID**", ya que se necesitará para el despliegue. 

![RevokeUserSession_App_Registration_3](./images/RevokeUserSession_App_3.png)

Luego, puedes agregar permisos en el registro de la aplicación. [Microsoft Graph API revokeSignInSessions endpoint](https://learn.microsoft.com/en-us/graph/api/user-revokesigninsessions?view=graph-rest-1.0&tabs=http). Desde el menú lateral, de click en "**API permissions**", debajo de la sección "**Manage**". Después, haga click en  "**Add a permission**".


![RevokeUserSession_App_Registration_4](./images/RevokeUserSession_App_4.png)

Desde el panel de   "**Select an API**", haga click en "**Microsoft APIs**", luego busque "**Microsoft Graph**" y agregue la opción. 

![RevokeUserSession_App_Registration_5](./images/RevokeUserSession_App_5.png)

Ingrese en "**Application permissions**" y busque "**User.ReadWrite.All**". Luego, haga click en "**Add permissions**".

![RevokeUserSession_App_Registration_6](./images/RevokeUserSession_App_6.png)

Asigue el consentimiento del permiso a través de "**Grant admin consent for (name)**".

![RevokeUserSession_App_Registration_7](./images/RevokeUserSession_App_7.png)

En seguida, genere un cliente secreto. Desde el menú izquierdo, haga click en  "**Certificates & secrets**", debajo de la sección "**Manage**". Luego, haga click en "**New client secret**". Ingrese la información en la descripción y seleccione la temporalidad de la fecha de expiración y de click en "**Add**".
 ![RevokeUserSession_App_Registration_8](./images/RevokeUserSession_App_8.png)

Copie el valor generado del secreto, luego lo necesitara para [Create an Azure Key Vault Secret](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/AS-MDE-Isolate-Machine#create-an-azure-key-vault-secret).
![RevokeUserSession_App_Registration_9](./images/RevokeUserSession_App_Registration_9.png)

#### Crear un  Azure Key Vault Secret
Navegue hasta la página de Azure Key Vaults 

https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.KeyVault%2Fvaults

A continuación, creará un Key Vault o usará uno existente y en la opción del menú "**Secrets**", encontrará abajo la opción de "**Settings**". Haga click en "**Generate/Import**".

![RevokeUserSession_Key_Vault_1](./images/RevokeUserSession_Key_Vault_1.png)

Escoja el nombre del secreto, como por ejemplo "**AS-Revoke-Entra-ID-User-Session**", e ingrese el secreto cliente copiándolo de [previous section](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/AS-MDE-Isolate-Machine#create-an-app-registration). Luego de ver todas las configuraciones haga click en "**Create**". 

![RevokeUserSession_Key_Vault_Access_2](./images/RevokeUserSession_Key_Vault_2.png)


Una vez añadido el secreto en el baúl, navegue hasta "**Access policies**". Mantenga la pestaña abierta, ya que necesitará returnar más adelante, luego de desplegar el playbook. [Granting Access to Azure Key Vault](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/AS-MDE-Isolate-Machine#granting-access-to-azure-key-vault).

![RevokeUserSession_Key_Vault_Access_3](./images/RevokeUserSession_Key_Vault_3.png)

### Despligue

Haga click en el siguiente botón [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Sentinel%2Fmaster%2FPlaybooks%2FAS-Revoke-Azure-AD-User-Session-From-Incident%2Fazuredeploy.json)

En la sección de **Project Details**:

* Seleccione la subscripción y el grupo de recursos.

En la sección **Instance Details**

* **Playbook Name**: Puede dejar  "**AS-Revoke-Entra-ID-User-Session-From-Incident**" o si desea puede cambiarlo. 
*  **Client ID**: Ingrese el (client) ID de su aplicación referenciado anteriormentee [Create an App Registration](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/AS-Revoke-Azure-AD-User-Session-From-Incident#create-an-app-registration).
* **Key Vault Name**: Ingrese el nombre del Key Vault Name mencionado en [Create an Azure Key Vault Secret](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/AS-Revoke-Azure-AD-User-Session-From-Incident#create-an-azure-key-vault-secret).
* **Secret Name**: Ingrese el nombre del key vault Secret creado en [Create an Azure Key Vault Secret](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/AS-Revoke-Azure-AD-User-Session-From-Incident#create-an-azure-key-vault-secret).

Revise de nuevo la información y de click en "**Review + create**"

![RevokeUserSession_Deploy_1](./images/RevokeUserSession_Deploy_1.png)

Una vez que el recursos fue validad, de click en "**Create**".

![RevokeUserSession_Deploy_2](./images/RevokeUserSession_Deploy_2.png)

Los recursos puede que tomen al rededor de un minuto desplegando. Una vez que el despliegue está listo, expanda la información en "**Deployment details**" 

Haga click en su correspondiente Logic App. 
![RevokeUserSession_Deploy_3](./images/RevokeUserSession_Deploy_3.png)


### Acceso a Azure Key Vault

Luego de que su Logic App despligue correctamente, se creará una conección al key vault creado, para lo cuál necesitará el acceso para tener acceso al registro de la aplicación. 

En el "**Access policies**" del key vault creado, haga click en "**Create**".
![RevokeUserSession_Key_Vault_Access_1](./images/RevokeUserSession_Key_Vault_Access_1.png)

Seleccione el checkbox de "**Get**"  debajo de "**Secret permissions**", y haga click en "**Next**".
![RevokeUserSession_Key_Vault_Access_2](./images/RevokeUserSession_Key_Vault_Access_2.png)

Pegue "**AS-MDE-Isolate-Machine** dentro del buscador y seleccione su logic app. 

![RevokeUserSession_Key_Vault_Access_3](./images/RevokeUserSession_Key_Vault_Access_3.png)

Luego en la sección de "**Review + create**" , haga click en "**Create**".

![RevokeUserSession_Key_Vault_Access_4](./images/RevokeUserSession_Key_Vault_Access_4.png)




### Microsoft Sentinel Contributor Role
Abra otra pestaña en su navegador e ingrese al workspace de su Microsoft Sentinel. 
https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.OperationalInsights%2Fworkspaces

Seleccione el  "**Access control (IAM)**" y haga click en "**Add role assignment**".
![RevokeUserSession_Add_Contributor_Role_1](./images/RevokeUserSession__1%20(1).png)

Seleccione el rol de "**Microsoft Sentinel Contributor**", luego haga click en  "**Next**".
![RevokeUserSession_Add_Contributor_Role_2](./images/RevokeUserSession__1%20(2).png)

Seleccione la opción de "**Managed identity**" y luego haga click en "**Select Members**". Debajo de la subscripción de la logic app seleccione "**Managed identity**" y escoja la logic app creada. 

![RevokeUserSession_Add_Contributor_Role_3](./images/RevokeUserSession__1%20(3).png)

Continue y haga click en "**Review + assign**
![RevokeUserSession_Add_Contributor_Role_4](./images/RevokeUserSession__1%20(4).png)

