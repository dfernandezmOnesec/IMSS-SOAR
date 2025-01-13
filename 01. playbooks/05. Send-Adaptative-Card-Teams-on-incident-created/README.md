# Enviar tarjeta adaptativa a Teams al crear un incidente

Este playbook se activa al crear un incidente en Microsoft Sentinel y envía una tarjeta adaptativa a un canal de Microsoft Teams. La tarjeta incluye detalles clave del incidente y permite a los respondedores realizar acciones, como actualizar la severidad o el estado del incidente directamente desde Teams.

---

## Características

- **Detalles del incidente:** La tarjeta adaptativa muestra información clave como el título, el ID, la severidad, los proveedores de alertas y las tácticas asociadas al incidente.
- **Acciones desde Teams:** Los usuarios pueden interactuar con la tarjeta adaptativa para:
  - Cambiar la severidad del incidente.
  - Cerrar el incidente indicando la razón.
  - Dejar el incidente abierto.

---

## Despliegue

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Sentinel%2Fmaster%2FPlaybooks%2FSend-Teams-Adaptive-Card-On-Incident-Creation%2Fazuredeploy.json)

---

## Requisitos previos

- **Microsoft Teams:** Un equipo y un canal deben estar configurados para recibir las notificaciones del incidente.
- **Microsoft Sentinel:** Asegúrese de tener configurados los permisos adecuados para que el playbook pueda interactuar con los incidentes.
- **Conexiones requeridas:** Este playbook necesita las siguientes conexiones:
  - **Teams:** Para enviar la tarjeta adaptativa.
  - **Microsoft Sentinel:** Para obtener los datos del incidente.
  - **Office 365 Outlook (opcional):** Si desea enviar correos electrónicos relacionados con los incidentes.

---

## Instrucciones de despliegue

1. Haga clic en el botón **Deploy to Azure** para desplegar el playbook.
2. Rellene los parámetros requeridos, incluyendo:
   - **Team Group ID:** El ID del equipo de Teams donde se enviarán las notificaciones.
   - **Channel ID:** El ID del canal dentro del equipo donde se publicará la tarjeta adaptativa.

   Ejemplo del formulario de despliegue:  
   ![Formulario de despliegue](./Images/Teams_Playbook_Deployment_1.png)

3. Haga clic en **Review + Create** y luego en **Create** para completar el despliegue.

4. Después del despliegue, navegue a la Logic App creada y revise las conexiones configuradas:  
   ![Revisar conexiones](./Images/Teams_Playbook_Deployment_2.png)

---

## Configuración posterior al despliegue

1. **Configurar permisos en Sentinel:**  
   Asigne el rol **Microsoft Sentinel Responder** a la identidad administrada del playbook en el grupo de recursos de Microsoft Sentinel. Esto permite al playbook actualizar el estado de los incidentes.

2. **Configurar permisos en Teams:**  
   Asegúrese de que la conexión de Teams tenga los permisos necesarios para publicar en el equipo y canal configurados.

   Ejemplo de asignación de roles:  
   ![Asignación de roles](./Images/Teams_Playbook_Roles_1.png)

---

Con este playbook configurado, podrá gestionar incidentes de Microsoft Sentinel de forma rápida y eficiente directamente desde Microsoft Teams.
