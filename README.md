# Repositorio **IMSS-SOAR**

Repositorio para la documentación de los playbooks diseñados para **IMSS Bienestar**. Este repositorio contiene herramientas esenciales para la automatización de incidentes de seguridad en **Microsoft Sentinel** y recursos complementarios como scripts de PowerShell para permisos y configuraciones.

## **Descripción General**

Los recursos incluidos en este repositorio están diseñados para mejorar la seguridad, visibilidad y eficiencia operativa mediante la integración de **Microsoft Sentinel** con otros servicios de Azure. Cada playbook aborda un caso de uso específico para garantizar la respuesta y mitigación de incidentes de manera eficiente.

---

## **Contenido del Repositorio**

### 1. **Playbooks**
- **Ubicación:** Carpeta `playbooks/`
- **Descripción:** Automatizaciones diseñadas para casos específicos de uso en **Sentinel**, como:
  - Respuesta ante incidentes.
  - Enriquecimiento de alertas.
  - Notificaciones en tiempo real.

#### **Casos de Uso Implementados**
1. **Revocación de Sesiones en Entra ID**
   - **Descripción:** Revoca las sesiones activas de usuarios sospechosos, invalidando tokens de acceso y cookies.
   - **Permisos Requeridos:** `User.ReadWrite.All`, `Directory.ReadWrite.All`
   - **Beneficio:** Contención inmediata de amenazas.

2. **Respuesta Automática para Azure WAF**
   - **Descripción:** Detecta y bloquea ataques como **SQL Injection** y **XSS**.
   - **Permisos Requeridos:** `Contributor` en Azure WAF.
   - **Beneficio:** Protección avanzada para aplicaciones web.

3. **Enriquecimiento de Alertas DDoS**
   - **Descripción:** Agrega detalles a alertas de mitigación y envía informes automáticos.
   - **Permisos Requeridos:** Permisos de envío en Logic Apps.
   - **Beneficio:** Mejora la respuesta ante ataques de DDoS.

4. **Bloqueo de IPs Sospechosas en NSG**
   - **Descripción:** Agrega direcciones IP maliciosas a reglas de red en NSG.
   - **Permisos Requeridos:** `Network Contributor`
   - **Beneficio:** Monitoreo proactivo del tráfico sospechoso.

5. **Notificaciones en Microsoft Teams**
   - **Descripción:** Envío de tarjetas adaptativas con opciones para gestionar incidentes directamente desde Teams.
   - **Permisos Requeridos:** Conexión a Teams y configuración de canales.
   - **Beneficio:** Eficiencia en la gestión colaborativa.

---

### 2. **Tests**
- **Ubicación:** Carpeta `tests/`
- **Descripción:** Pruebas para asegurar la funcionalidad de los flujos de trabajo creados.
- **Incluye:**
  - Documentación detallada para ejecutar y validar los playbooks.

---

## **Cómo Usar este Repositorio**

### Clonar el Repositorio
1. Usa el siguiente comando para descargar el contenido:
   ```bash
   git clone <repository-url>
   cd <repository-folder>

## Implementar Playbooks desde una Plantilla Personalizada
1. Selecciona un flujo de trabajo en el portal de Azure.
2. Busca "Implementar una plantilla personalizada" y haz clic en "Crear tu propia plantilla".
3. Pega el contenido del flujo de trabajo desde GitHub.
4. Guarda los cambios, completa los datos necesarios y haz clic en "Comprar".
5. Autoriza las conexiones necesarias:
* Edita y autoriza cada conexión desde el recurso creado.
* Completa las credenciales requeridas, como ID del área de trabajo y claves.

## **Cómo Crear y Exportar una Plantilla ARM**

1. Desde Azure, exporta la plantilla del flujo de trabajo deseado.
2. Modifica los parámetros básicos como nombre del playbook y credenciales.
3. Agrega las variables y conexiones necesarias siguiendo esta estructura:

   ```json
   "variables": {
       "AzureADConnectionName": "[concat('azuread-', parameters('PlaybookName'))]",
       "AzureSentinelConnectionName": "[concat('azuresentinel-', parameters('PlaybookName'))]"
   }```
4. Incluye los recursos dependientes en dependsOn:
   ```json
   "dependsOn": [
    "[resourceId('Microsoft.Web/connections', variables('AzureADConnectionName'))]"]```
5. Guarda el archivo como azuredeploy.json

## Notas Finales
Cada carpeta contiene un archivo README.md con instrucciones detalladas.
Todos los playbooks están optimizados para su integración con Azure y Microsoft Sentinel


