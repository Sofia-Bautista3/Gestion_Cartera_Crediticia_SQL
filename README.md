## Proyecto: Gestión de Cartera Crediticia - SQL

# Contexto de Negocio:
   
Una empresa dedicada a la concesión de préstamos requería una infraestructura de base de datos robusta para:
1. Monitorear el estado global de su cartera crediticia en tiempo real.
2. Detectar de manera automatizada a clientes en morosidad.
3. Registrar transacciones de pago garantizando la integridad de los saldos.
4. Auditar cambios de estado y generar cierres contables/mensuales de forma automática.

#
# Fuentes de Datos:

El proyecto trabaja sobre el esquema relacional fincore_sa, estructurado en las siguientes tablas clave:

1. clientes: Información demográfica e identificación del cliente.
2. productos_credito: Tipos de financiamiento, tasas y plazos.
3. prestamos: Contratos activos, montos otorgados, saldos pendientes, días de mora y estado.
4. pagos: Historial transaccional de abonado.
5. auditoria_prestamos: Tabla destino para trazabilidad de cambios de estado.
6. resumen_mensual: Tabla agregada para métricas ejecutivas de cierre mensual.

#    
# Procesos de Análisis:
  
El proyecto fue desarrollado en MySQL utilizando SQL avanzado. Etapas principales:

1. Análisis exploratorio de la base de datos y creación de función personalizada de clasificación de mora (aging).
2. Construcción de vistas ejecutivas para el monitoreo de cartera y consolidación de clientes.
3. Implementación de un trigger para la auditoría automática de cambios de estado y días de mora.
4. Desarrollo de procedimientos almacenados con gestión transaccional (ACID) para el registro de pagos, generación de resumen mensual y refinanciamiento de prestamos.
5. Ejecución de consultas analíticas avanzadas (aging de cartera, top de exposición e historial).
   
#
# Resultados e Insights:

**1. Aging de Cartera:**

De un total de  $712,200  en cartera viva (créditos activos y vencidos),  $696,500  se encuentran operando estrictamente Al Día (representando el  97.80%  del portafolio). Demostrando a nivel directivo que a pesar de tener un segmento de riesgo diversificado (incluyendo perfiles C y D), los mecanismos de otorgamiento y control implementados en la base de datos mantienen la gran mayoría de los recursos generando rendimientos de forma limpia.

Además, la Mora Crítica (+90 días) se ha reducido y contenido de manera excepcional a solo 2.20%  ($15,700), lo que evidencia que el riesgo de pérdida severa está perfectamente acotado y no compromete la liquidez de la institución.

<img width="465" height="224" alt="01_Resultado del aging de cartera" src="https://github.com/user-attachments/assets/a0d3e2a4-8a3e-492d-bc0b-c1a2c901b48e" />

**2. Top Exposición Crediticia:**

<img width="547" height="270" alt="02_Top 5 de exposicion crediticia" src="https://github.com/user-attachments/assets/38fee45b-8c9c-45b4-9038-74fef1fed290" />

El top de exposición crediticia revela que el 78.63%  de la cartera activa se concentra en solo 5 clientes. Así mismo,  se evidencia una alta concentración en los dos principales clientes, ambos clasificados en Categoría de Riesgo A y B (Excelente / Bueno), operando estrictamente Al Día.

#
# Recomendaciones:
- Priorizar gestión de cobranza sobre los préstamos en mora grave antes de que pasen a crítica. 
- Se sugiere implementar un seguimiento de cupos de crédito y límites de exposición única para evitar elevar el riesgo de liquidez ante eventuales variaciones en la capacidad de pago de los grandes deudores.   

#
# Tecnologías utilizadas:
  
MySQL (SQL Avanzado)

