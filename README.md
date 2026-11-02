# Portafolio Proyectos: SQL y Python
En este repositorio encontraran dos proyectos integrales que abarcan desde el modelado relacional y lógica de negocio en bases de datos relacionales SQL, hasta la limpieza, transformación y generación de métricas analíticas en Python.

## Proyecto 1: Gestión de Cartera Crediticia - SQL
- Contexto de Negocio
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
El proyecto fue desarrollado en MySQL utilizando SQL avanzado.

Etapas principales:

1. Análisis exploratorio de la base de datos y creación de función personalizada de clasificación de mora (aging).
2. Construcción de vistas ejecutivas para el monitoreo de cartera y consolidación de clientes.
3. Implementación de un trigger para la auditoría automática de cambios de estado y días de mora.
4. Desarrollo de procedimientos almacenados con gestión transaccional (ACID):
5. registro seguro de pagos y actualización de saldos
6. automatización de resúmenes mensuales
7. Ejecución de consultas analíticas avanzadas (aging de cartera, top de exposición e historial).
   
- Resultados e Insights:
- Tecnologías utilizadas:
MySQL (SQL Avanzado)

## Proyecto 2: Análisis Comercial - Python
- Contexto de Negocio:
Una empresa del sector comercial requiere unificar y sanear su información operativa dispersa en múltiples archivos Excel sin estructura uniforme e inconsistencias en formatos, categorías y registros. La meta del proyecto consiste en procesar y reconstruir los datos, calcular KPIs comerciales, medir el cumplimiento de metas y automatizar la generación de reportes ejecutivos en Excel e imágenes analíticas de forma que se convierta en informacion accionable para la toma de decisiones.

- Fuentes de Datos:
El proyecto integra 6 archivos Excel:
1. 01_ventas.xlsx
2. 02_clientes.xlsx
3. 03_productos.xlsx
4. 04_vendedores.xlsx
5. 05_sucursales.xlsx
6. 06_metas.xlsx

- Proceso de Análisis:
El proyecto fue desarrollado en Python utilizando pandas y matplotlib.

Etapas principales:
1. Carga de múltiples fuentes de datos
2. Diagnóstico de calidad de datos
3. Limpieza y estandarización:
   - normalización de textos
   - homologación de categorías
   - conversión de fechas
4. Cruce de tablas (joins)
5. Construcción de base consolidada
6. Cálculo de KPIs
7. Visualización de resultados

- Resultados e Insights:


- Tecnologías Utilizadas:
1. Pandas
2. Matplotlib
3. Google Colab



