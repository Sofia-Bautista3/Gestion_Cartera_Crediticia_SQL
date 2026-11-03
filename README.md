## Proyecto: Gestión de Cartera Crediticia - SQL
- Contexto de Negocio:
   
Una empresa dedica a la conseción de prestamos requería una infraestructura de base de datos robusta para:
1. Monitorear el estado global de su cartera crediticia en tiempo real.
2. Detectar de manera automatizada a clientes en morosidad.
3. Registrar transacciones de pago garantizando la integridad de los saldos.
4. Auditar cambios de estado y generar cierres contables/mensuales de forma automática.

- Fuentes de Datos:

El proyecto trabaja sobre el esquema relacional fincore_sa, estructurado en las siguientes tablas clave:
1. clientes: Información demográfica e identificación del cliente.
2. productos_credito: Tipos de financiamiento, tasas y plazos.
3. prestamos: Contratos activos, montos otorgados, saldos pendientes, días de mora y estado.
4. pagos: Historial transaccional de abonado.
5. auditoria_prestamos: Tabla destino para trazabilidad de cambios de estado.
6. resumen_mensual: Tabla agregada para métricas ejecutivas de cierre mensual.
    
- Procesos de Análisis:
  
El proyecto fue desarrollado en MySQL utilizando SQL avanzado. Etapas principales:

1. Análisis exploratorio de la base de datos y creación de función personalizada de clasificación de mora (aging).
2. Construcción de vistas ejecutivas para el monitoreo de cartera y consolidación de clientes.
3. Implementación de un trigger para la auditoría automática de cambios de estado y días de mora.
4. Desarrollo de procedimientos almacenados con gestión transaccional (ACID):
5. registro seguro de pagos y actualización de saldos
6. automatización de resúmenes mensuales
7. Ejecución de consultas analíticas avanzadas (aging de cartera, top de exposición e historial).
   
- Resultados e Insights:
1. Concentración del Riesgo (Aging): La segmentación por aging permitió identificar qué porcentaje del saldo total se encuentra retenido en Mora Crítica (+90 días) frente a mora temprana.
2. Top Exposición Crediticia: Un número reducido de clientes (Top 5) concentra una fracción desproporcionada del saldo pendiente global al compararse contra el promedio de la cartera.
3. Eficiencia en Consultas: Sin indexación adecuada, las consultas analíticas multi-tabla ejecutaban recorridos completos de tabla (Full Table Scans); la creación de índices redujo el costo computacional a búsquedas directas por clave.   
- Tecnologías utilizadas:
  
MySQL (SQL Avanzado)

