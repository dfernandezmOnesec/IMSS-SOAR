# Sentinel Playbook - Bloqueo de IP en Azure WAF

## Introducción

Las aplicaciones web son cada vez más objetivo de ataques maliciosos que explotan vulnerabilidades comunes, como inyección SQL (SQLi) y scripting entre sitios (XSS). Azure Web Application Firewall (WAF) es un servicio nativo de la nube que protege aplicaciones web frente a estos ataques. Al integrar Azure WAF con Microsoft Sentinel, podemos automatizar la detección y respuesta a amenazas, reduciendo la necesidad de intervención manual.

Este Playbook de Logic Apps para Sentinel permite agregar direcciones IP de origen, detectadas a través de incidentes de Sentinel, a una regla personalizada de WAF para bloquearlas automáticamente.

---

## Botones de Despliegue

### Nuevo Template V2 (Mejoras: Manejo de múltiples IPs y duplicados)
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Network-Security%2Fmaster%2FAzure%2520WAF%2FPlaybook%2520-%2520WAF%2520Sentinel%2520Playbook%2520Block%2520IP%2520-%2520New%2FtemplateV2.json)

### Template V1 (Versión anterior)
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Network-Security%2Fmaster%2FAzure%2520WAF%2FPlaybook%2520-%2520WAF%2520Sentinel%2520Playbook%2520Block%2520IP%2520-%2520New%2Ftemplate.json)

Este nuevo Playbook es compatible con políticas WAF de Front Door Standard/Premium y App Gateway.

---

## Configuración de Detección y Respuesta

1. **Crear una Regla Analítica en Sentinel**:
   - Usa una plantilla de detección (SQLi o XSS) desde la pestaña Analítica en Sentinel.
   - Configura el intervalo de consulta, umbral de alertas y ajustes de incidentes según sea necesario.
   

2. **Automatizar Respuesta**:
   - Crea una regla de automatización para ejecutar el Playbook y bloquear la IP del atacante en la política de WAF.

3. **Permisos del Playbook**:
   - Proporciona permisos al Playbook en los recursos App Gateway/Front Door relacionados con las políticas WAF. Esto incluye:
     - Autorizar la conexión API `azuresentinel-Block-IPAzureWAF`.
     - Asignar una Identidad Administrada al Playbook con permisos de "Colaborador".

---

## Flujo de Trabajo del Playbook

1. Un atacante intenta explotar una aplicación web protegida por Azure WAF.
2. El tráfico se registra en los logs de Azure WAF y se ingiere en Sentinel.
3. La regla analítica detecta el patrón del ataque y genera un incidente.
4. La regla de automatización ejecuta el Playbook configurado.
5. El Playbook crea una regla personalizada llamada `SentinelBlockIP` en la política WAF, bloqueando la IP de origen del atacante.
6. Los intentos futuros desde esta IP serán bloqueados por el WAF.


---

## Contribuciones

Este proyecto acepta contribuciones y sugerencias. Para más detalles, consulta nuestro [Código de Conducta](https://opensource.microsoft.com/codeofconduct/) y la [Licencia de Contribuciones de Microsoft](https://cla.opensource.microsoft.com).

Si tienes preguntas o comentarios adicionales, contacta con [opencode@microsoft.com](mailto:opencode@microsoft.com).

---

## Conclusión

El Playbook `Block-IPAzureWAF` simplifica la configuración de detección y respuesta automatizadas para ataques como SQLi y XSS en Azure WAF, mejorando significativamente la postura de seguridad al bloquear tráfico malicioso antes de que alcance las reglas del motor de WAF.
