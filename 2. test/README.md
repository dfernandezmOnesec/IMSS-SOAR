# Permisos Requeridos para Ejecutar Pruebas de NSG y WAF

Este documento describe los permisos y roles necesarios para ejecutar las pruebas de inyección de logs en **Network Security Group (NSG)** y **Web Application Firewall (WAF)** en Azure, así como para interactuar con **Azure Sentinel** y **Log Analytics Workspace**.

## Permisos Requeridos para Ejecutar las Pruebas

### 1. **Acceso a Log Analytics Workspace**
Para escribir logs en **Log Analytics** y realizar consultas, el usuario debe contar con los siguientes permisos:

#### Roles requeridos:
- **Log Analytics Contributor**: Permite leer y escribir registros en el **Log Analytics Workspace**.
- **Contributor** o **Owner**: Proporciona permisos más amplios para gestionar recursos dentro del **Log Analytics Workspace**.

### 2. **Acceso para Consultar Logs y Visualización**
Para visualizar los logs generados, se necesitan permisos adicionales para consultar los registros y generar informes en **Azure Sentinel**:

#### Roles requeridos:
- **Log Analytics Reader**: Permite consultar y visualizar los datos dentro del **Log Analytics Workspace**.
- **Security Reader**: Permite visualizar los registros de seguridad dentro de **Azure Sentinel**.
- **Azure Sentinel Contributor**: Permite gestionar **Azure Sentinel** e interactuar con los logs y alertas.
- **Security Administrator**: Permite configurar reglas de seguridad en **Azure Sentinel**, incluidas las reglas de **NSG** y **WAF**.

### 3. **Permisos para Modificar y Gestionar NSG y WAF**
Para poder crear o simular incidentes de seguridad relacionados con **NSG** y **WAF**, se requieren permisos para gestionar y configurar estos servicios.

#### Roles requeridos para **NSG**:
- **Network Contributor**: Permite gestionar los **Network Security Groups (NSG)**.
- **Owner** o **Contributor** en el **resource group** que contiene el **NSG**: Permite modificar las configuraciones de seguridad de **NSG**.

#### Roles requeridos para **WAF**:
- **Contributor** o **Owner** en el **Application Gateway**: Permite modificar la configuración del **Web Application Firewall** en un **Application Gateway**.
- **Security Administrator**: Permite gestionar configuraciones de **WAF** y otros servicios de seguridad.

### 4. **Acceso al Portal de Azure**
Los siguientes roles son necesarios si los usuarios necesitan acceder al portal de **Azure** para visualizar o gestionar los recursos:

#### Roles requeridos:
- **Reader**: Permite visualizar los recursos en Azure, como las configuraciones del **NSG** y **WAF**, pero no permite modificaciones.

### 5. **Permisos para Ejecutar Scripts de PowerShell**
El usuario debe tener acceso al **Azure PowerShell** y los permisos necesarios para interactuar con los servicios de **Azure**.

#### Roles requeridos:
- **Azure PowerShell User**: Permite ejecutar comandos de PowerShell en Azure.
- **User** con permisos para autenticarse y ejecutar scripts, como `Get-AzApplicationGatewayWebApplicationFirewallLog` y otros comandos de Azure.

---

## Resumen de los Roles y Permisos Necesarios

| **Recurso/Acción**                  | **Roles Requeridos**                                        |
|-------------------------------------|------------------------------------------------------------|
| **Azure Sentinel / Log Analytics**  | Log Analytics Contributor, Security Reader, Azure Sentinel Contributor |
| **Consulta de Logs**                | Log Analytics Reader, Security Reader                      |
| **Escribir Logs en Log Analytics**  | Log Analytics Contributor, Contributor/Owner en el workspace |
| **Gestionar NSG (Network Security Group)** | Network Contributor, Owner/Contributor en el resource group |
| **Gestionar WAF (Web Application Firewall)** | Contributor/Owner en el Application Gateway, Security Administrator |
| **Ejecutar Scripts de PowerShell**  | Azure PowerShell User, permisos para ejecutar scripts     |

---

## Recomendaciones de Asignación de Roles

1. **Azure Sentinel Contributor** o **Owner**: Si el objetivo es gestionar todo el ciclo de vida de las alertas, playbooks y reglas de **Azure Sentinel**.
2. **Log Analytics Contributor**: Si solo necesitas enviar y leer logs en el **Log Analytics Workspace**.
3. **Network Contributor** y **Application Gateway Contributor**: Para gestionar y probar **NSG** y **WAF** respectivamente.

Asegúrate de asignar estos roles al **principal** (usuario o servicio) que ejecutará los scripts y gestionará los logs de seguridad.
