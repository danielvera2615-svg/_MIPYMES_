MariaDB [(none)]> CREATE DATABASE Mipymes;
Query OK, 1 row affected (0.002 sec)

MariaDB [(none)]> USE Mipymes;
Database changed
MariaDB [Mipymes]> CREATE TABLE CLIENTE (
    ->     cliente_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     nombre VARCHAR(40) NOT NULL,
    ->     documento VARCHAR(40) NOT NULL,
    ->     telefono VARCHAR(40) NOT NULL,
    ->     email VARCHAR(100) NOT NULL,
    ->
    ->     PRIMARY KEY (cliente_id),
    ->     CONSTRAINT uq_cliente_documento UNIQUE (documento),
    ->     CONSTRAINT uq_cliente_email UNIQUE (email)
    ->
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'CLIENTES REGISTRADOS';
Query OK, 0 rows affected (0.051 sec)

MariaDB [Mipymes]>
MariaDB [Mipymes]> CREATE TABLE CATEGORIA (
    ->     categoria_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     nombre VARCHAR(40) NOT NULL,
    ->     descripcion VARCHAR(100) NOT NULL,
    -> 
    ->     PRIMARY KEY (categoria_id),
    ->     CONSTRAINT uq_categoria_nombre UNIQUE (nombre)
    ->
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'CATEGORIAS DE PRODUCTOS';
Query OK, 0 rows affected (0.045 sec)

MariaDB [Mipymes]> CREATE TABLE PROVEEDOR (
    ->     proveedor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     nombre VARCHAR(100) NOT NULL,
    ->     telefono VARCHAR(40) NOT NULL,
    ->     email VARCHAR(100) NOT NULL,
    ->     direccion VARCHAR(150) NOT NULL,
    -> 
    ->     PRIMARY KEY (proveedor_id),
    ->     CONSTRAINT uq_proveedor_email UNIQUE (email)
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'PROVEEDORES REGISTRADOS';
Query OK, 0 rows affected (0.048 sec)

MariaDB [Mipymes]> CREATE TABLE EMPLEADO (
    ->     empleado_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     nombre VARCHAR(100) NOT NULL,
    ->     rol VARCHAR(40) NOT NULL,
    ->     email VARCHAR(100) NOT NULL,
    ->     activo BOOLEAN NOT NULL DEFAULT TRUE,
    -> 
    ->     PRIMARY KEY (empleado_id),
    ->     CONSTRAINT uq_empleado_email UNIQUE (email)
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'EMPLEADOS REGISTRADOS';
Query OK, 0 rows affected (0.047 sec)

MariaDB [Mipymes]> CREATE TABLE PRODUCTO (
    ->     producto_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     categoria_id INT UNSIGNED NOT NULL,
    ->     proveedor_id INT UNSIGNED NOT NULL,
    ->     sku VARCHAR(40) NOT NULL,
    ->     nombre VARCHAR(100) NOT NULL,
    ->     descripcion VARCHAR(150) NOT NULL,
    ->     precio_compra DECIMAL(20,2) NOT NULL,
    ->     precio_venta DECIMAL(20,2) NOT NULL,
    ->     stock_minimo INT UNSIGNED NOT NULL DEFAULT 0,
    ->     activo BOOLEAN NOT NULL DEFAULT TRUE,
    -> 
    ->     PRIMARY KEY (producto_id),
    ->     CONSTRAINT uq_producto_sku UNIQUE (sku),
    -> 
    ->     FOREIGN KEY (categoria_id)
    ->         REFERENCES CATEGORIA (categoria_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     FOREIGN KEY (proveedor_id)
    ->         REFERENCES PROVEEDOR (proveedor_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     CONSTRAINT chk_producto_precios
    ->         CHECK (precio_compra >= 0 AND precio_venta >= 0)
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'PRODUCTOS DEL INVENTARIO';
Query OK, 0 rows affected (0.057 sec)

MariaDB [Mipymes]> CREATE TABLE COMPRA (
    ->     compra_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     proveedor_id INT UNSIGNED NOT NULL,
    ->     empleado_id INT UNSIGNED NOT NULL,
    ->     fecha DATETIME NOT NULL,
    ->     numero_documento VARCHAR(20) NOT NULL,
    ->     total DECIMAL(20,2) NOT NULL,
    ->     estado VARCHAR(40) NOT NULL,
    -> 
    ->     PRIMARY KEY (compra_id),
    ->     CONSTRAINT uq_compra_documento UNIQUE (numero_documento),
    -> 
    ->     FOREIGN KEY (proveedor_id)
    ->         REFERENCES PROVEEDOR (proveedor_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     FOREIGN KEY (empleado_id)
    ->         REFERENCES EMPLEADO (empleado_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     CONSTRAINT chk_compra_total CHECK (total >= 0)
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'COMPRAS REALIZADAS';
Query OK, 0 rows affected (0.058 sec)

MariaDB [Mipymes]> CREATE TABLE DETALLE_COMPRA (
    ->     detalle_compra_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     compra_id INT UNSIGNED NOT NULL,
    ->     producto_id INT UNSIGNED NOT NULL,
    ->     cantidad INT UNSIGNED NOT NULL,
    ->     costo_unitario DECIMAL(20,2) NOT NULL,
    ->     subtotal DECIMAL(20,2) NOT NULL,
    -> 
    ->     PRIMARY KEY (detalle_compra_id),
    -> 
    ->     FOREIGN KEY (compra_id)
    ->         REFERENCES COMPRA (compra_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     FOREIGN KEY (producto_id)
    ->         REFERENCES PRODUCTO (producto_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     CONSTRAINT chk_detalle_compra_cantidad
    ->         CHECK (cantidad > 0),
    -> 
    ->     CONSTRAINT chk_detalle_compra_costos
    ->         CHECK (costo_unitario >= 0 AND subtotal >= 0)
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'DETALLE DE LAS COMPRAS';
Query OK, 0 rows affected (0.050 sec)

MariaDB [Mipymes]> CREATE TABLE VENTA (
    ->     venta_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     cliente_id INT UNSIGNED NOT NULL,
    ->     empleado_id INT UNSIGNED NOT NULL,
    ->     fecha DATETIME NOT NULL,
    ->     numero_factura VARCHAR(20) NOT NULL,
    ->     subtotal DECIMAL(20,2) NOT NULL,
    ->     impuesto DECIMAL(20,2) NOT NULL,
    ->     total DECIMAL(20,2) NOT NULL,
    ->     estado VARCHAR(40) NOT NULL,
    -> 
    ->     PRIMARY KEY (venta_id),
    ->     CONSTRAINT uq_venta_numero_factura
    ->         UNIQUE (numero_factura),
    -> 
    ->     FOREIGN KEY (cliente_id)
    ->         REFERENCES CLIENTE (cliente_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    ->
    ->     FOREIGN KEY (empleado_id)
    ->         REFERENCES EMPLEADO (empleado_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     CONSTRAINT chk_venta_importes
    ->         CHECK (subtotal >= 0 AND impuesto >= 0 AND total >= 0)
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'VENTAS REALIZADAS';
Query OK, 0 rows affected (0.052 sec)

MariaDB [Mipymes]> CREATE TABLE DETALLE_VENTA (
    ->     detalle_venta_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     venta_id INT UNSIGNED NOT NULL,
    ->     producto_id INT UNSIGNED NOT NULL,
    ->     cantidad INT UNSIGNED NOT NULL,
    ->     precio_unitario DECIMAL(20,2) NOT NULL,
    ->     descuento DECIMAL(20,2) NOT NULL DEFAULT 0,
    ->     subtotal DECIMAL(20,2) NOT NULL,
    -> 
    ->     PRIMARY KEY (detalle_venta_id),
    -> 
    ->     FOREIGN KEY (venta_id)
    ->         REFERENCES VENTA (venta_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     FOREIGN KEY (producto_id)
    ->         REFERENCES PRODUCTO (producto_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     CONSTRAINT chk_detalle_venta_cantidad
    ->         CHECK (cantidad > 0),
    -> 
    ->     CONSTRAINT chk_detalle_venta_importes
    ->         CHECK (
    ->             precio_unitario >= 0
    ->             AND descuento >= 0
    ->             AND subtotal >= 0
    ->             AND descuento <= precio_unitario * cantidad
    ->         )
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'DETALLE DE LAS VENTAS';
Query OK, 0 rows affected (0.043 sec)

MariaDB [Mipymes]> CREATE TABLE PAGO (
    ->     pago_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     venta_id INT UNSIGNED NOT NULL,
    ->     metodo VARCHAR(40) NOT NULL,
    ->     monto DECIMAL(20,2) NOT NULL,
    ->     fecha DATETIME NOT NULL,
    ->     referencia VARCHAR(100),
    -> 
    ->     PRIMARY KEY (pago_id),
    -> 
    ->     FOREIGN KEY (venta_id)
    ->         REFERENCES VENTA (venta_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     CONSTRAINT chk_pago_monto CHECK (monto > 0)
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'PAGOS DE VENTAS';
Query OK, 0 rows affected (0.032 sec)

MariaDB [Mipymes]> CREATE TABLE MOVIMIENTO_INVENTARIO (
    ->     movimiento_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     producto_id INT UNSIGNED NOT NULL,
    ->     empleado_id INT UNSIGNED NOT NULL,
    ->     tipo VARCHAR(40) NOT NULL,
    ->     cantidad INT UNSIGNED NOT NULL,
    ->     fecha DATETIME NOT NULL,
    ->     referencia VARCHAR(100),
    ->     stock_resultante INT UNSIGNED NOT NULL,
    -> 
    ->     PRIMARY KEY (movimiento_id),
    -> 
    ->     FOREIGN KEY (producto_id)
    ->         REFERENCES PRODUCTO (producto_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     FOREIGN KEY (empleado_id)
    ->         REFERENCES EMPLEADO (empleado_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     CONSTRAINT chk_movimiento_cantidad
    ->         CHECK (cantidad > 0),
    -> 
    ->     CONSTRAINT chk_movimiento_tipo
    ->         CHECK (tipo IN ('ENTRADA', 'SALIDA', 'AJUSTE'))
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'MOVIMIENTOS DEL INVENTARIO';
Query OK, 0 rows affected (0.048 sec)

MariaDB [Mipymes]> CREATE TABLE REPORTE_VENTA (
    ->     reporte_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     empleado_id INT UNSIGNED NOT NULL,
    ->     tipo VARCHAR(40) NOT NULL,
    ->     periodo_inicio DATE NOT NULL,
    ->     periodo_fin DATE NOT NULL,
    ->     generado_en DATETIME NOT NULL,
    -> 
    ->     PRIMARY KEY (reporte_id),
    -> 
    ->     FOREIGN KEY (empleado_id)
    ->         REFERENCES EMPLEADO (empleado_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     CONSTRAINT chk_reporte_periodo
    ->         CHECK (periodo_fin >= periodo_inicio)
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'REPORTES DE VENTAS';
Query OK, 0 rows affected (0.046 sec)

MariaDB [Mipymes]> CREATE TABLE FACTURACION (
    ->     facturacion_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ->     venta_id INT UNSIGNED NOT NULL,
    ->     numero_factura VARCHAR(20) NOT NULL,
    ->     fecha_emision DATETIME NOT NULL,
    ->     subtotal DECIMAL(20,2) NOT NULL,
    ->     impuesto DECIMAL(20,2) NOT NULL,
    ->     total DECIMAL(20,2) NOT NULL,
    ->     estado VARCHAR(40) NOT NULL,
    -> 
    ->     PRIMARY KEY (facturacion_id),
    -> 
    ->     CONSTRAINT uq_facturacion_numero
    ->         UNIQUE (numero_factura),
    -> 
    ->     CONSTRAINT uq_facturacion_venta
    ->         UNIQUE (venta_id),
    -> 
    ->     FOREIGN KEY (venta_id)
    ->         REFERENCES VENTA (venta_id)
    ->         ON UPDATE CASCADE ON DELETE RESTRICT,
    -> 
    ->     CONSTRAINT chk_facturacion_importes
    ->         CHECK (subtotal >= 0 AND impuesto >= 0 AND total >= 0)
    -> 
    -> ) ENGINE = InnoDB
    -> DEFAULT CHARSET = utf8mb4
    -> COLLATE = utf8mb4_general_ci
    -> COMMENT = 'FACTURACION DE VENTAS';
Query OK, 0 rows affected (0.047 sec)

CREATE TABLE STOCK_MENSUAL (
    stock_mensual_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    producto_id INT UNSIGNED NOT NULL,
    mes TINYINT UNSIGNED NOT NULL,
    anio YEAR NOT NULL,
    stock_inicial INT UNSIGNED NOT NULL DEFAULT 0,
    entradas INT UNSIGNED NOT NULL DEFAULT 0,
    salidas INT UNSIGNED NOT NULL DEFAULT 0,
    stock_final INT UNSIGNED NOT NULL DEFAULT 0,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (stock_mensual_id),

    CONSTRAINT uq_stock_producto_mes
        UNIQUE (producto_id, mes, anio),

    FOREIGN KEY (producto_id)
        REFERENCES PRODUCTO (producto_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_stock_mes
        CHECK (mes BETWEEN 1 AND 12)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_general_ci
COMMENT = 'REGISTRO MENSUAL DEL STOCK DE PRODUCTOS';

CREATE TABLE VENTAS_MENSUALES (
    venta_mensual_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    mes TINYINT UNSIGNED NOT NULL,
    anio YEAR NOT NULL,
    cantidad_ventas INT UNSIGNED NOT NULL DEFAULT 0,
    total_ventas DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_impuestos DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (venta_mensual_id),

    CONSTRAINT uq_ventas_mes_anio
        UNIQUE (mes, anio),

    CONSTRAINT chk_ventas_mes
        CHECK (mes BETWEEN 1 AND 12)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_general_ci
COMMENT = 'REGISTRO MENSUAL DE VENTAS';

CREATE TABLE ADMINISTRADOR (
    administrador_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    empleado_id INT UNSIGNED NOT NULL,
    nivel_acceso VARCHAR(40) NOT NULL,
    fecha_asignacion DATETIME NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (administrador_id),

    CONSTRAINT uq_administrador_empleado
        UNIQUE (empleado_id),

    FOREIGN KEY (empleado_id)
        REFERENCES EMPLEADO (empleado_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_general_ci
COMMENT = 'ADMINISTRADORES DEL SISTEMA';

CREATE TABLE AUDITOR (
    auditor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    empleado_id INT UNSIGNED NOT NULL,
    tipo_auditoria VARCHAR(50) NOT NULL,
    fecha_asignacion DATETIME NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (auditor_id),

    CONSTRAINT uq_auditor_empleado
        UNIQUE (empleado_id),

    FOREIGN KEY (empleado_id)
        REFERENCES EMPLEADO (empleado_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_general_ci
COMMENT = 'AUDITORES DEL SISTEMA';

GRANT SELECT, INSERT
ON Mipymes.*
TO 'empleado'@'localhost';

GRANT UPDATE
ON Mipymes.*
TO 'empleado'@'localhost';

GRANT DELETE
ON Mipymes.*
TO 'empleado'@'localhost';

SHOW GRANTS FOR 'empleado'@'localhost';

GRANT SELECT, INSERT
ON Mipymes.*
TO 'administrador'@'localhost';

GRANT UPDATE
ON Mipymes.*
TO 'administrador'@'localhost';

GRANT DELETE
ON Mipymes.*
TO 'administrador'@'localhost';

SHOW GRANTS FOR 'administrador'@'localhost';

GRANT SELECT, INSERT
ON Mipymes.*
TO 'auditor'@'localhost';

GRANT UPDATE
ON Mipymes.*
TO 'auditor'@'localhost';

GRANT DELETE
ON Mipymes.*
TO 'auditor'@'localhost';

SHOW GRANTS FOR 'auditor'@'localhost';
