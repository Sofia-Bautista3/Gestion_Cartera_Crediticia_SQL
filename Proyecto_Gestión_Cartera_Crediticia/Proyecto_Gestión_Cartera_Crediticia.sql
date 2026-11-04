-- ============================================================
-- Proyecto FinCore S.A. - Proyecto Avanzado SQL 
-- ============================================================

CREATE DATABASE fincore_sa CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE fincore_sa;

-- ------------------------------------------------------------
-- TABLA: clientes
-- ------------------------------------------------------------
CREATE TABLE clientes (
    id_cliente      INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    documento       VARCHAR(20)  NOT NULL UNIQUE,
    email           VARCHAR(100),
    telefono        VARCHAR(20),
    ciudad          VARCHAR(50),
    segmento        ENUM('Personal','Empresarial') NOT NULL,
    categoria_riesgo CHAR(1)     NOT NULL COMMENT 'A=Excelente, B=Bueno, C=Regular, D=Alto riesgo',
    fecha_alta      DATE         NOT NULL,
    activo          TINYINT(1)   NOT NULL DEFAULT 1
);

-- ------------------------------------------------------------
-- TABLA: productos_credito
-- ------------------------------------------------------------
CREATE TABLE productos_credito (
    id_producto     INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(80)  NOT NULL,
    tipo            ENUM('Personal','Empresarial','Hipotecario','Automotriz') NOT NULL,
    tasa_anual      DECIMAL(5,2) NOT NULL COMMENT 'Tasa nominal anual en %',
    plazo_min_meses INT          NOT NULL,
    plazo_max_meses INT          NOT NULL,
    monto_min       DECIMAL(12,2) NOT NULL,
    monto_max       DECIMAL(12,2) NOT NULL
);

-- ------------------------------------------------------------
-- TABLA: prestamos
-- ------------------------------------------------------------
CREATE TABLE prestamos (
    id_prestamo     INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT           NOT NULL,
    id_producto     INT           NOT NULL,
    monto_otorgado  DECIMAL(12,2) NOT NULL,
    tasa_aplicada   DECIMAL(5,2)  NOT NULL,
    plazo_meses     INT           NOT NULL,
    fecha_otorgamiento DATE       NOT NULL,
    fecha_vencimiento  DATE       NOT NULL,
    cuota_mensual   DECIMAL(10,2) NOT NULL,
    saldo_pendiente DECIMAL(12,2) NOT NULL,
    estado          ENUM('Activo','Cancelado','Vencido','Refinanciado') NOT NULL DEFAULT 'Activo',
    dias_mora       INT           NOT NULL DEFAULT 0,
    FOREIGN KEY (id_cliente)  REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos_credito(id_producto)
);

-- ------------------------------------------------------------
-- TABLA: pagos
-- ------------------------------------------------------------
CREATE TABLE pagos (
    id_pago         INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo     INT           NOT NULL,
    fecha_pago      DATE          NOT NULL,
    monto_pagado    DECIMAL(10,2) NOT NULL,
    tipo_pago       ENUM('Cuota','Prepago','Mora') NOT NULL,
    canal           ENUM('App','Sucursal','Transferencia','Débito Automático') NOT NULL,
    registrado_por  VARCHAR(50)   NOT NULL DEFAULT 'sistema',
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo)
);

-- ------------------------------------------------------------
-- TABLA: auditoria_prestamos (el alumno la llena con trigger)
-- ------------------------------------------------------------
CREATE TABLE auditoria_prestamos (
    id_auditoria    INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo     INT           NOT NULL,
    campo_modificado VARCHAR(50)  NOT NULL,
    valor_anterior  VARCHAR(100),
    valor_nuevo     VARCHAR(100),
    fecha_cambio    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario         VARCHAR(50)   NOT NULL DEFAULT (USER())
);

-- ------------------------------------------------------------
-- TABLA: resumen_mensual (el alumno la llena con procedimiento)
-- ------------------------------------------------------------
CREATE TABLE resumen_mensual (
    id_resumen      INT AUTO_INCREMENT PRIMARY KEY,
    anio            INT           NOT NULL,
    mes             INT           NOT NULL,
    total_prestamos INT           NOT NULL DEFAULT 0,
    monto_total_otorgado DECIMAL(14,2) NOT NULL DEFAULT 0,
    total_pagos_recibidos DECIMAL(14,2) NOT NULL DEFAULT 0,
    prestamos_vencidos   INT       NOT NULL DEFAULT 0,
    tasa_morosidad  DECIMAL(5,2)  NOT NULL DEFAULT 0,
    fecha_generacion DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_anio_mes (anio, mes)
);

-- ============================================================
-- INSERTS
-- ============================================================

INSERT INTO productos_credito (nombre, tipo, tasa_anual, plazo_min_meses, plazo_max_meses, monto_min, monto_max) VALUES
('Crédito Personal Flex',    'Personal',     28.00,  6,  48,   1000.00,  50000.00),
('Crédito Personal Plus',    'Personal',     22.00, 12,  60,   5000.00,  80000.00),
('Crédito Empresarial Básico','Empresarial', 18.00, 12,  36,  10000.00, 200000.00),
('Crédito Empresarial Pro',  'Empresarial',  15.50, 24,  72,  50000.00, 500000.00),
('Crédito Hipotecario',      'Hipotecario',  12.00, 60, 240, 100000.00,1000000.00),
('Crédito Automotriz',       'Automotriz',   19.50, 24,  72,   8000.00, 120000.00);

INSERT INTO clientes (nombre, documento, email, telefono, ciudad, segmento, categoria_riesgo, fecha_alta) VALUES
-- Categoría A (excelente) — 6 clientes
('Carlos Méndez Torres',     'DNI-10234567', 'cmendez@email.com',    '555-1001', 'Ciudad de México', 'Personal',    'A', '2021-03-15'),
('Laura Ramírez Vega',       'DNI-10234568', 'lramirez@email.com',   '555-1002', 'Guadalajara',      'Personal',    'A', '2021-05-20'),
('Inversiones GHL S.A.',     'RUC-20512345', 'contacto@ghl.com',     '555-2001', 'Monterrey',        'Empresarial', 'A', '2020-11-10'),
('Distribuidora Pacífico',   'RUC-20512346', 'dpacif@empresa.com',   '555-2002', 'Ciudad de México', 'Empresarial', 'A', '2021-01-08'),
('Miguel Ángel Fuentes',     'DNI-10234571', 'mfuentes@email.com',   '555-1005', 'Puebla',           'Personal',    'A', '2022-02-14'),
('Sofía Castillo Herrera',   'DNI-10234572', 'scastillo@email.com',  '555-1006', 'Guadalajara',      'Personal',    'A', '2022-07-30'),
-- Categoría B (bueno) — 6 clientes
('Roberto Silva Pardo',      'DNI-10234569', 'rsilva@email.com',     '555-1003', 'Monterrey',        'Personal',    'B', '2021-08-12'),
('Ana Patricia Ochoa',       'DNI-10234570', 'apochoa@email.com',    '555-1004', 'Puebla',           'Personal',    'B', '2022-01-25'),
('Tech Solutions MX S.A.',   'RUC-20512347', 'info@techsol.com',     '555-2003', 'Ciudad de México', 'Empresarial', 'B', '2021-06-18'),
('Constructora Norteña',     'RUC-20512348', 'cnortena@empresa.com', '555-2004', 'Monterrey',        'Empresarial', 'B', '2021-09-05'),
('Diego Hernández Cruz',     'DNI-10234575', 'dhernandez@email.com', '555-1009', 'Ciudad de México', 'Personal',    'B', '2022-04-10'),
('Valentina Torres Ruiz',    'DNI-10234576', 'vtorres@email.com',    '555-1010', 'Guadalajara',      'Personal',    'B', '2022-09-22'),
-- Categoría C (regular) — 5 clientes
('Jorge Luis Paredes',       'DNI-10234573', 'jparedes@email.com',   '555-1007', 'Ciudad de México', 'Personal',    'C', '2022-03-18'),
('Importadora del Centro',   'RUC-20512349', 'imp.centro@emp.com',   '555-2005', 'Puebla',           'Empresarial', 'C', '2022-05-30'),
('Patricia Morales Díaz',    'DNI-10234577', 'pmorales@email.com',   '555-1011', 'Monterrey',        'Personal',    'C', '2022-11-05'),
('Comercial Rápida S.R.L.',  'RUC-20512351', 'crapida@empresa.com',  '555-2007', 'Ciudad de México', 'Empresarial', 'C', '2023-01-20'),
('Fernando López Salinas',   'DNI-10234579', 'flopez@email.com',     '555-1013', 'Puebla',           'Personal',    'C', '2023-03-08'),
-- Categoría D (alto riesgo) — 3 clientes
('Elena Gutiérrez Blanco',   'DNI-10234574', 'egutierrez@email.com', '555-1008', 'Guadalajara',      'Personal',    'D', '2022-06-05'),
('Servicios Omega Ltda.',     'RUC-20512350', 'omega@empresa.com',    '555-2006', 'Ciudad de México', 'Empresarial', 'D', '2022-08-15'),
('Andrés Ramírez Soto',      'DNI-10234578', 'aramirez@email.com',   '555-1012', 'Monterrey',        'Personal',    'D', '2022-12-12');

INSERT INTO prestamos (id_cliente, id_producto, monto_otorgado, tasa_aplicada, plazo_meses, fecha_otorgamiento, fecha_vencimiento, cuota_mensual, saldo_pendiente, estado, dias_mora) VALUES
-- Préstamos ACTIVOS
(1,  2, 45000.00, 22.00, 36, '2023-01-10', '2026-01-10', 1672.00, 28000.00, 'Activo', 0),
(2,  1, 15000.00, 28.00, 24, '2023-03-15', '2025-03-15',  820.00,  6500.00, 'Activo', 0),
(3,  4,180000.00, 15.50, 60, '2022-06-01', '2027-06-01', 4320.00,130000.00, 'Activo', 0),
(4,  3, 90000.00, 18.00, 36, '2023-02-20', '2026-02-20', 3250.00, 62000.00, 'Activo', 0),
(5,  6, 35000.00, 19.50, 48, '2023-05-10', '2027-05-10', 1050.00, 28000.00, 'Activo', 0),
(6,  2, 25000.00, 22.00, 24, '2023-07-01', '2025-07-01', 1285.00, 15000.00, 'Activo', 0),
(7,  1, 20000.00, 28.00, 36, '2022-11-15', '2025-11-15',  855.00, 12000.00, 'Activo', 0),
(8,  2, 30000.00, 22.00, 36, '2023-04-20', '2026-04-20', 1115.00, 22500.00, 'Activo', 0),
(9,  3, 75000.00, 18.00, 24, '2023-06-01', '2025-06-01', 3740.00, 45000.00, 'Activo', 0),
(10, 4,250000.00, 15.50, 72, '2022-09-10', '2028-09-10', 5100.00,200000.00, 'Activo', 0),
(11, 1, 12000.00, 28.00, 18, '2023-08-05', '2025-02-05',  820.00,  7000.00, 'Activo', 0),
(12, 2, 18000.00, 22.00, 24, '2023-09-12', '2025-09-12',  925.00, 12000.00, 'Activo', 0),
(5,  5,200000.00, 12.00,120, '2022-04-01', '2032-04-01', 2860.00,175000.00, 'Activo', 0),
-- Préstamos VENCIDOS (para ejercicios de mora y aging)
(13, 1, 10000.00, 28.00, 12, '2022-08-01', '2023-08-01',  960.00,  8500.00, 'Vencido', 95),
(18, 1,  8000.00, 28.00, 12, '2022-10-15', '2023-10-15',  768.00,  7200.00, 'Vencido',180),
(19, 3, 55000.00, 18.00, 24, '2021-12-01', '2023-12-01', 2740.00, 40000.00, 'Vencido', 62),
-- Préstamos CANCELADOS
(1,  1, 10000.00, 28.00, 12, '2022-01-01', '2023-01-01',  955.00,     0.00, 'Cancelado', 0),
(2,  6, 20000.00, 19.50, 24, '2021-06-01', '2023-06-01', 1015.00,     0.00, 'Cancelado', 0),
(3,  3, 50000.00, 18.00, 18, '2021-03-01', '2022-09-01', 3180.00,     0.00, 'Cancelado', 0),
-- Préstamos REFINANCIADOS
(14, 3, 40000.00, 18.00, 24, '2022-07-01', '2024-07-01', 1990.00, 18000.00, 'Refinanciado', 0),
(20, 2, 22000.00, 22.00, 24, '2022-09-01', '2024-09-01', 1130.00, 10000.00, 'Refinanciado', 0);

INSERT INTO pagos (id_prestamo, fecha_pago, monto_pagado, tipo_pago, canal) VALUES
-- Pagos del préstamo 1 (Carlos Méndez)
(1, '2023-02-10', 1672.00, 'Cuota', 'Débito Automático'),
(1, '2023-03-10', 1672.00, 'Cuota', 'Débito Automático'),
(1, '2023-04-10', 1672.00, 'Cuota', 'Débito Automático'),
(1, '2023-05-10', 1672.00, 'Cuota', 'Débito Automático'),
(1, '2023-06-10', 1672.00, 'Cuota', 'Débito Automático'),
(1, '2023-07-10', 1672.00, 'Cuota', 'Débito Automático'),
-- Pagos del préstamo 2 (Laura Ramírez)
(2, '2023-04-15',  820.00, 'Cuota', 'App'),
(2, '2023-05-15',  820.00, 'Cuota', 'App'),
(2, '2023-06-15',  820.00, 'Cuota', 'App'),
(2, '2023-07-15',  820.00, 'Cuota', 'App'),
(2, '2023-08-15',  820.00, 'Cuota', 'App'),
-- Pagos del préstamo 3 (Inversiones GHL)
(3, '2022-07-01', 4320.00, 'Cuota', 'Transferencia'),
(3, '2022-08-01', 4320.00, 'Cuota', 'Transferencia'),
(3, '2022-09-01', 4320.00, 'Cuota', 'Transferencia'),
(3, '2022-10-01', 4320.00, 'Cuota', 'Transferencia'),
(3, '2022-11-01', 4320.00, 'Cuota', 'Transferencia'),
(3, '2022-12-01', 4320.00, 'Cuota', 'Transferencia'),
(3, '2023-01-01', 4320.00, 'Cuota', 'Transferencia'),
(3, '2023-02-01', 4320.00, 'Cuota', 'Transferencia'),
(3, '2023-03-01', 4320.00, 'Cuota', 'Transferencia'),
-- Pagos del préstamo 7 (Roberto Silva)
(7, '2022-12-15',  855.00, 'Cuota', 'Sucursal'),
(7, '2023-01-15',  855.00, 'Cuota', 'Sucursal'),
(7, '2023-02-15',  855.00, 'Cuota', 'Sucursal'),
(7, '2023-03-15',  855.00, 'Cuota', 'Sucursal'),
-- Prepago del préstamo 5
(5, '2023-10-15', 5000.00, 'Prepago', 'Transferencia'),
-- Pagos con mora (préstamos vencidos)
(14, '2023-09-20',  960.00, 'Cuota', 'Sucursal'),
(14, '2023-09-20',  150.00, 'Mora',  'Sucursal'),
(15, '2024-04-10',  768.00, 'Cuota', 'App'),
(15, '2024-04-10',  220.00, 'Mora',  'App'),
-- Pagos del préstamo 17 (Cancelado — Laura)
(17, '2021-07-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2021-08-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2021-09-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2021-10-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2021-11-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2021-12-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2022-01-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2022-02-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2022-03-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2022-04-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2022-05-01', 1015.00, 'Cuota', 'Débito Automático'),
(17, '2022-06-01', 1015.00, 'Cuota', 'Débito Automático'),
-- Pagos del préstamo 9 (Tech Solutions)
(9, '2023-07-01', 3740.00, 'Cuota', 'Transferencia'),
(9, '2023-08-01', 3740.00, 'Cuota', 'Transferencia'),
(9, '2023-09-01', 3740.00, 'Cuota', 'Transferencia'),
(9, '2023-10-01', 3740.00, 'Cuota', 'Transferencia'),
(9, '2023-11-01', 3740.00, 'Cuota', 'Transferencia'),
(9, '2023-12-01', 3740.00, 'Cuota', 'Transferencia');


-- EXPLORACION DB
SELECT "clientes" AS TABLAS, COUNT(*) AS Total_registros FROM clientes
UNION ALL SELECT "productos_credito", COUNT(*) FROM  productos_credito
UNION ALL SELECT "prestamos", COUNT(*) FROM prestamos
UNION ALL SELECT "pagos", COUNT(*) FROM pagos;

-- DISTRIBUCION DE PRESTAMOS POR ESTADO
SELECT estado, COUNT(*) AS cantidad, SUM(saldo_pendiente) AS total
FROM prestamos
GROUP BY estado;

-- CLASIFICACION DE MORA
DELIMITER //
CREATE FUNCTION fn_clasificar_mora (p_dias_mora INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
	DECLARE categoria_aging VARCHAR(50);
	IF p_dias_mora = 0 THEN
		SET categoria_aging = "Al Dia";
	ELSEIF p_dias_mora BETWEEN 1 AND 30 THEN
		SET categoria_aging = "Mora Temprana";
	ELSEIF p_dias_mora BETWEEN 31 AND 60 THEN 
		SET categoria_aging = "Mora Media";
	ELSEIF p_dias_mora BETWEEN 61 AND 90 THEN
		SET categoria_aging = "Mora Grave";
	ELSE 
		SET categoria_aging = "Mora Critica";
	END IF;
    RETURN categoria_aging;
END //
DELIMITER ;

SELECT id_prestamo, dias_mora, fn_clasificar_mora(dias_mora) AS categoria_aging
FROM prestamos
WHERE estado = "Vencido";
    
-- VISTAS DE ANALISIS --
-- 1. Estado de cartera --

CREATE VIEW vw_estado_cartera AS 
SELECT p.id_prestamo, c.nombre AS cliente, c.documento, c.segmento, c.categoria_riesgo,
pc.nombre AS producto, pc.tipo, p.monto_otorgado, p.saldo_pendiente, ROUND((p.saldo_pendiente/p.monto_otorgado)*100,2) AS ptc_saldo_pendiente,
p.tasa_aplicada, p.plazo_meses, p.cuota_mensual, p.estado, p.dias_mora, fn_clasificar_mora(dias_mora) AS clasificacion_mora,
p.fecha_otorgamiento, p.fecha_vencimiento
FROM prestamos p
JOIN clientes c ON c.id_cliente = p.id_cliente
JOIN productos_credito pc ON pc.id_producto = p.id_producto;

-- 2. Resumen clientes --

CREATE VIEW vw_resumen_clientes AS
SELECT c.id_cliente, c.nombre AS cliente, COUNT(p.id_prestamo) AS total_prestamos,
IFNULL(SUM(p.monto_otorgado),0) AS total_otorgado,      -- En caso que el monto, saldo o dias de mora sean nulos lo remplaza por 0
IFNULL(SUM(p.saldo_pendiente),0) AS consolidado_saldo_pendiente,
IFNULL(MAX(p.dias_mora),0) AS max_dias_mora,
CASE 
WHEN MAX(p.dias_mora)>0 THEN 'Sí'
ELSE 'No' 
    END AS mora_activa
FROM clientes c
LEFT JOIN prestamos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre;

SELECT * FROM vw_estado_cartera;
SELECT * FROM vw_resumen_clientes;

-- TRIGGER DE AUDITORIA

DELIMITER //
CREATE TRIGGER trg_auditoria_estado
AFTER UPDATE 
ON prestamos
FOR EACH ROW
BEGIN
	IF NEW.estado <> OLD.estado THEN
		INSERT INTO  auditoria_prestamos (id_prestamo, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (NEW.id_prestamo, "estado", OLD.estado, NEW.estado);
	END IF;
    
    IF NEW.dias_mora <> OLD.dias_mora THEN
		INSERT INTO auditoria_prestamos (id_prestamo, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (NEW.id_prestamo, "dias_mora", OLD.dias_mora, NEW.dias_mora);
	END IF;
END//
DELIMITER ;
        
-- Pruebas - Validacion funcionalidad Trigger 

START TRANSACTION;
UPDATE prestamos
SET estado = "Vencido",
dias_mora = 35
WHERE id_prestamo = 2;
SELECT * FROM prestamos;
SELECT * FROM auditoria_prestamos;
ROLLBACK;

-- PROCEDIMIENTOS ALMACENADOS --
-- 1. Registro pagos --

DELIMITER //
CREATE PROCEDURE sp_registrar_pago (IN p_id_prestamo INT, IN p_monto DECIMAL(10,2),
	IN p_tipo_pago ENUM('Cuota','Prepago','Mora'),
	IN p_canal ENUM('App','Sucursal','Transferencia','Débito Automático'))
BEGIN
	DECLARE v_estado VARCHAR(50);
    DECLARE v_saldo DECIMAL(12,2);
    DECLARE v_nuevo_saldo DECIMAL(12,2);
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION    -- En caso de ocurrir un error ejecuta ROLLBACK y devuelve el error
    BEGIN 
		ROLLBACK;
        RESIGNAL;
	END;
    START TRANSACTION;
    SELECT estado, saldo_pendiente INTO v_estado, v_saldo
    FROM prestamos WHERE id_prestamo = p_id_prestamo;
    
    IF v_estado IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El prestamo especificado no existe';
    ELSEIF v_estado IN ('Refinanciado', 'Cancelado') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El prestamo especificado no permite cambios';
	END IF;
    
    INSERT INTO pagos (id_prestamo, fecha_pago, monto_pagado, tipo_pago, canal)
    VALUES (p_id_prestamo, CURDATE(), p_monto, p_tipo_pago, p_canal);
    
    SET v_nuevo_saldo = GREATEST(0, v_saldo - p_monto);      -- Si el pago es mayor al saldo pendiente el saldo queda en 0
    IF v_nuevo_saldo = 0 THEN
		UPDATE prestamos
        SET saldo_pendiente = 0, estado = 'Cancelado', dias_mora = 0
        WHERE id_prestamo = p_id_prestamo;
	ELSE
		UPDATE prestamos
        SET saldo_pendiente = v_nuevo_saldo
        WHERE id_prestamo = p_id_prestamo;
	END IF;
    COMMIT;
END //
DELIMITER ;

CALL sp_registrar_pago (3, 80000,'Cuota','Transferencia');
SELECT id_prestamo, saldo_pendiente, estado
FROM prestamos
WHERE id_prestamo = 3;
SELECT * FROM pagos;

CALL sp_registrar_pago (2, 6500,'Cuota','App');
SELECT id_prestamo, saldo_pendiente, estado
FROM prestamos
WHERE id_prestamo = 2;
SELECT * FROM pagos;

-- 2. Generacion resumen mensual --

DELIMITER //
CREATE PROCEDURE sp_generar_resumen_mensual ( IN p_anio INT, IN p_mes INT)
BEGIN 
	DECLARE v_total_prestamos INT;
    DECLARE v_monto_total DECIMAL (14, 2);
    DECLARE v_total_pagos_recibidos DECIMAL(14, 2);
    DECLARE v_tasa_morosidad DECIMAL (5, 2);
    DECLARE v_saldo_vencido DECIMAL(12,2);
    DECLARE v_saldo_total DECIMAL(12,2);
    DECLARE v_prestamos_vencidos INT;
    
    SELECT COUNT(*), IFNULL(SUM(monto_otorgado), 0)     
    INTO v_total_prestamos, v_monto_total
    FROM prestamos
    WHERE YEAR(fecha_otorgamiento) = p_anio AND MONTH(fecha_otorgamiento) = p_mes;
    
    SELECT IFNULL(SUM(monto_pagado), 0)
    INTO v_total_pagos_recibidos
    FROM pagos
    WHERE YEAR(fecha_pago) = p_anio AND MONTH(fecha_pago) = p_mes;
    
    SELECT COUNT(*)
    INTO v_prestamos_vencidos
    FROM prestamos
    WHERE estado='Vencido' AND YEAR(fecha_vencimiento) = p_anio AND MONTH(fecha_vencimiento) = p_mes;
    
    SELECT IFNULL(SUM(CASE WHEN estado = 'Vencido' THEN saldo_pendiente ELSE 0 END), 0),
    IFNULL(SUM(saldo_pendiente), 0)
    INTO v_saldo_vencido, v_saldo_total
    FROM prestamos;
    
    IF v_saldo_total > 0 THEN
     SET v_tasa_morosidad = (v_saldo_vencido / v_saldo_total) * 100;
	ELSE 
	 SET v_tasa_morosidad = 0;
    END IF;
    
    INSERT INTO resumen_mensual (anio, mes, total_prestamos, monto_total_otorgado, total_pagos_recibidos, prestamos_vencidos, tasa_morosidad)
    VALUES (p_anio, p_mes, v_total_prestamos, v_monto_total, v_total_pagos_recibidos, v_prestamos_vencidos, v_tasa_morosidad)
	ON DUPLICATE KEY UPDATE   -- Si el modulo se ejucuta para un mes existente esta clausula actualiza los valores
    total_prestamos = VALUES(total_prestamos),
	monto_total_otorgado = VALUES(monto_total_otorgado),
	total_pagos_recibidos = VALUES(total_pagos_recibidos),
    prestamos_vencidos = VALUES(prestamos_vencidos),
	tasa_morosidad = VALUES(tasa_morosidad);
END//
DELIMITER ;

CALL sp_generar_resumen_mensual (2023, 7);
SELECT * FROM resumen_mensual;

-- 3. Refinanciacion prestamo --
DELIMITER //
CREATE PROCEDURE sp_refinanciar_prestamo (IN p_id_prestamo INT, IN p_nuevo_plazo INT, p_nueva_tasa DECIMAL(5,2))
BEGIN
	DECLARE v_id_cliente INT;
    DECLARE v_id_producto INT;
    DECLARE v_saldo DECIMAL(12,2);
    DECLARE v_estado VARCHAR(20);
	DECLARE v_nueva_cuota DECIMAL(10,2);
    DECLARE v_factor_tiempo DECIMAL (12,8);
    DECLARE v_tasa_mensual DECIMAL (18,8);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION    -- En caso de ocurrir un error ejecuta ROLLBACK y devuelve el error
    BEGIN 
		ROLLBACK;
        RESIGNAL;
	END;
    START TRANSACTION;
    SELECT id_cliente, id_producto, saldo_pendiente, estado
    INTO v_id_cliente, v_id_producto, v_saldo, v_estado
    FROM prestamos
    WHERE id_prestamo = p_id_prestamo;
    
    
    IF v_estado IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El prestamo especificado no existe';
    ELSEIF v_estado IN ('Refinanciado', 'Cancelado') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El prestamo especificado no permite cambios';
	END IF;
    
    SET v_tasa_mensual = (p_nueva_tasa/100) / 12;
    SET v_factor_tiempo = POWER(1 + v_tasa_mensual, p_nuevo_plazo);
    SET v_nueva_cuota = v_saldo * ( (v_tasa_mensual * v_factor_tiempo) / (v_factor_tiempo - 1) );
    
    UPDATE prestamos
    SET estado = 'Refinanciado', saldo_pendiente = 0
    WHERE id_prestamo = p_id_prestamo;
    
    INSERT INTO prestamos (id_cliente, id_producto, monto_otorgado, tasa_aplicada, plazo_meses, fecha_otorgamiento, fecha_vencimiento, cuota_mensual, saldo_pendiente, estado, dias_mora)
    VALUES (v_id_cliente, v_id_producto, v_saldo, p_nueva_tasa, p_nuevo_plazo, CURDATE(), DATE_ADD(CURDATE(), INTERVAL p_nuevo_plazo MONTH), v_nueva_cuota, v_saldo, 'Activo', 0);
    
    COMMIT;
END //
DELIMITER ;

CALL sp_refinanciar_prestamo (16, 36, 20.00);
SELECT * FROM prestamos;

-- ANALISIS AVANZADO DE CARTERA -- 
-- 1. Aging de cartera
SELECT 
    fn_clasificar_mora(dias_mora) AS tramo_mora,
    COUNT(*) AS cantidad_creditos,
    SUM(saldo_pendiente) AS saldo_en_riesgo,
    ROUND((SUM(saldo_pendiente) / (SELECT SUM(saldo_pendiente) FROM prestamos WHERE estado IN ('Activo', 'Vencido'))) * 100, 2) AS pct_del_total
FROM prestamos
WHERE estado IN ('Activo', 'Vencido')
GROUP BY tramo_mora
ORDER BY MAX(dias_mora) ASC;

-- 2. Top 5 de exposicion crediticia
WITH totalesclientes AS (
SELECT id_cliente, SUM(saldo_pendiente) AS saldo_cliente  -- Tabla temporal con la informacion de los clientes
FROM prestamos
WHERE estado IN ('Activo','Vencido')
GROUP BY id_cliente),
promediogeneral AS (SELECT AVG(saldo_cliente) AS avg_saldo FROM totalesclientes)

SELECT 
    c.nombre AS cliente,
    tc.saldo_cliente,
    ROUND(pg.avg_saldo, 2) AS promedio_cartera,
    ROUND(tc.saldo_cliente - pg.avg_saldo, 2) AS diferencia_vs_promedio
FROM totalesclientes tc
JOIN clientes c ON tc.id_cliente = c.id_cliente
CROSS JOIN promediogeneral pg     -- Pega el valor del promedio general a cada fila para poder realizar la comparacion
ORDER BY tc.saldo_cliente DESC
LIMIT 5;

-- 3. Historial de pagos completo 
CREATE INDEX idx_pagos_orden_prestamo 
ON pagos (fecha_pago DESC, id_pago DESC, id_prestamo);

SELECT p.id_pago, c.nombre AS cliente, c.categoria_riesgo, pc.nombre AS producto, pr.monto_otorgado, p.monto_pagado,
pr.estado, p.fecha_pago, p.tipo_pago, p.canal, p.registrado_por
FROM pagos P FORCE INDEX (idx_pagos_orden_prestamo)
JOIN prestamos pr ON p.id_prestamo = pr.id_prestamo
JOIN clientes c ON c.id_cliente = pr.id_cliente
JOIN productos_credito pc ON pc.id_producto = pr.id_producto
ORDER BY p.fecha_pago DESC, p.id_pago DESC
LIMIT 20;

-- 4. Reporte ejecutivo 
SELECT 
    segmento,
    categoria_riesgo,
    COUNT(*) AS total_creditos,
    ROUND(AVG(monto_otorgado), 2) AS monto_promedio,
    SUM(CASE WHEN estado = 'Vencido' THEN 1 ELSE 0 END) AS creditos_vencidos,
    ROUND((SUM(CASE WHEN estado = 'Vencido' THEN saldo_pendiente ELSE 0 END) / SUM(saldo_pendiente)) * 100, 2) AS pct_cartera_en_riesgo
FROM vw_estado_cartera
GROUP BY segmento, categoria_riesgo
ORDER BY segmento, categoria_riesgo;

