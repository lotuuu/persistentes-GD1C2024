USE GD1C2024
GO

CREATE SCHEMA PERSISTENTES
GO


--CREACION DE TABLAS
CREATE PROCEDURE crear_tablas
AS
-- Crear tabla Provincia
CREATE TABLE PERSISTENTES.Provincia
(
	provincia_id INT IDENTITY,
	provincia_nombre nvarchar(255),
	CONSTRAINT PK_Provincia PRIMARY KEY (provincia_id)
)

-- Crear tabla Localidad
CREATE TABLE PERSISTENTES.Localidad
(
	localidad_id INT IDENTITY,
	localidad_provincia INT,
	localidad_nombre nvarchar(255)

		CONSTRAINT PK_Localidad PRIMARY KEY (localidad_id)
)

-- Crear referencia de Localidad a Provincia
ALTER TABLE PERSISTENTES.Localidad
		ADD CONSTRAINT FK_LocalidadProvincia
		FOREIGN KEY (localidad_provincia) REFERENCES PERSISTENTES.Provincia

-- Crear tabla CondicionFiscal
CREATE TABLE PERSISTENTES.CondicionFiscal
(
	condicion_fiscal nvarchar(255) NOT NULL
		CONSTRAINT PK_CondicionFiscal PRIMARY KEY (condicion_fiscal)
)

-- Crear tabla Super
CREATE TABLE PERSISTENTES.Super
(
	super_nro INT IDENTITY,
	super_localidad_id INT,
	super_nombre nvarchar(255),
	super_razon_soc nvarchar(255),
	super_cuit nvarchar(255),
	super_iibb nvarchar(255),
	super_domicilio nvarchar(255),
	super_fecha_ini_actividad datetime,
	super_condicion_fiscal_id nvarchar(255)

		CONSTRAINT PK_Super PRIMARY KEY (super_nro)
)

-- Crear referencia de Super a Localidad
ALTER TABLE PERSISTENTES.Super
		ADD CONSTRAINT FK_SuperLocalidad
		FOREIGN KEY (super_localidad_id) REFERENCES PERSISTENTES.Localidad

-- Crear referencia de Super a CondicionFiscal
ALTER TABLE PERSISTENTES.Super
		ADD CONSTRAINT FK_SuperCondicionFiscal
		FOREIGN KEY (super_condicion_fiscal_id) REFERENCES PERSISTENTES.CondicionFiscal

-- Crear tabla Sucursal
CREATE TABLE PERSISTENTES.Sucursal
(
	sucursal_id INT IDENTITY,
	sucursal_localidad_id INT,
	sucursal_super INT,
	sucursal_nombre nvarchar(255),
	sucursal_direccion nvarchar(255)

		CONSTRAINT PK_Sucursal PRIMARY KEY (sucursal_id)
)

-- Crear referencia de Sucursal a Localidad
ALTER TABLE PERSISTENTES.Sucursal
		ADD CONSTRAINT FK_SucursalLocalidad
		FOREIGN KEY (sucursal_localidad_id) REFERENCES PERSISTENTES.Localidad

-- Crear referencia de Sucursal a Super
ALTER TABLE PERSISTENTES.Sucursal
		ADD CONSTRAINT FK_SucursalSuper
		FOREIGN KEY (sucursal_super) REFERENCES PERSISTENTES.Super

-- Crear tabla TipoCaja
CREATE TABLE PERSISTENTES.TipoCaja
(
	tipo_caja nvarchar(255) NOT NULL

		CONSTRAINT PK_TipoCaja PRIMARY KEY (tipo_caja)
)

-- Crear tabla Caja
CREATE TABLE PERSISTENTES.Caja
(
	caja_nro DECIMAL(18,0) NOT NULL,
	caja_sucursal INT,
	caja_tipo nvarchar(255)

		CONSTRAINT PK_Caja PRIMARY KEY (caja_nro, caja_sucursal)
)

-- Crear referencia de Caja a Sucursal
ALTER TABLE PERSISTENTES.Caja
		ADD CONSTRAINT FK_CajaSucursal
		FOREIGN KEY (caja_sucursal) REFERENCES PERSISTENTES.Sucursal

-- Crear referencia de Caja a TipoCaja
ALTER TABLE PERSISTENTES.Caja
		ADD CONSTRAINT FK_CajaTipo
		FOREIGN KEY (caja_tipo) REFERENCES PERSISTENTES.TipoCaja

-- Crear tabla Empleado
CREATE TABLE PERSISTENTES.Empleado
(
	legajo_empleado INT IDENTITY,
	empleado_sucursal INT,
	empleado_nombre nvarchar(255),
	empleado_apellido nvarchar(255),
	empleado_fecha_registro datetime,
	empleado_telefono DECIMAL(18,0),
	empleado_mail nvarchar(255),
	empleado_fecha_nacimiento DATE,
	empleado_dni DECIMAL(18,0)

		CONSTRAINT PK_Empleado PRIMARY KEY (legajo_empleado)
)

-- Crear referencia de Empleado a Sucursal
ALTER TABLE PERSISTENTES.Empleado
		ADD CONSTRAINT FK_EmpleadoSucursal
		FOREIGN KEY (empleado_sucursal) REFERENCES PERSISTENTES.Sucursal

-- Crear tabla Cliente
CREATE TABLE PERSISTENTES.Cliente
(
	cliente_id INT IDENTITY,
	cliente_nombre nvarchar(255),
	cliente_apellido nvarchar(255),
	cliente_dni DECIMAL(18,0),
	cliente_fecha_registro datetime,
	cliente_telefono DECIMAL(18,0),
	cliente_mail nvarchar(255),
	cliente_fecha_nacimiento DATE,
	cliente_domicilio nvarchar(255),
	cliente_localidad_id INT

		CONSTRAINT PK_Cliente PRIMARY KEY (cliente_id)
)

-- Crear referencia de Cliente a Localidad
ALTER TABLE PERSISTENTES.Cliente
		ADD CONSTRAINT FK_ClienteLocalidad
		FOREIGN KEY (cliente_localidad_id) REFERENCES PERSISTENTES.Localidad

-- Crear tabla TipoComprobante
CREATE TABLE PERSISTENTES.TipoComprobante
(
	tipo_comprobante nvarchar(255) NOT NULL

		CONSTRAINT PK_TipoComprobante PRIMARY KEY (tipo_comprobante)
)

-- Crear tabla Ticket
CREATE TABLE PERSISTENTES.Ticket
(
	ticket_id INT IDENTITY,
	ticket_numero DECIMAL(18,0),
	ticket_caja_nro DECIMAL(18,0),
	ticket_caja_sucursal INT,
	ticket_tipo_comprobante nvarchar(255),
	ticket_empleado INT,
	ticket_fecha_hora datetime,
	ticket_subtotal_productos DECIMAL(18,2),
	ticket_total_descuento DECIMAL(18,2),
	ticket_total_descuento_aplicado_mp DECIMAL(18,2),
	ticket_total_envio DECIMAL(18,2),
	ticket_total_ticket DECIMAL(18,2)

		CONSTRAINT PK_Ticket PRIMARY KEY (ticket_id)
)

-- Crear referencia de Ticket a Caja
ALTER TABLE PERSISTENTES.Ticket
		ADD CONSTRAINT FK_TicketCaja
		FOREIGN KEY (ticket_caja_nro, ticket_caja_sucursal) REFERENCES PERSISTENTES.Caja(caja_nro, caja_sucursal)

-- Crear referencia de Ticket a TipoComprobante
ALTER TABLE PERSISTENTES.Ticket
		ADD CONSTRAINT FK_TicketTipoComprobante
		FOREIGN KEY (ticket_tipo_comprobante) REFERENCES PERSISTENTES.TipoComprobante

-- Crear referencia de Ticket a Empleado
ALTER TABLE PERSISTENTES.Ticket
		ADD CONSTRAINT FK_TicketEmpleado
		FOREIGN KEY (ticket_empleado) REFERENCES PERSISTENTES.Empleado

-- Crear tabla EnvioEstado
CREATE TABLE PERSISTENTES.EnvioEstado
(
	envio_estado nvarchar(255) NOT NULL

		CONSTRAINT PK_EnvioEstado PRIMARY KEY (envio_estado)
)

-- Crear tabla Envio
CREATE TABLE PERSISTENTES.Envio
(
	envio_id INT IDENTITY,
	envio_cliente INT,
	envio_ticket INT,
	envio_fecha_programada datetime,
	envio_hora_inicio DECIMAL(18,0),
	envio_hora_fin DECIMAL(18,0),
	envio_fecha_entrega datetime,
	envio_costo DECIMAL(18,2),
	envio_estado nvarchar(255)

		CONSTRAINT PK_Envio PRIMARY KEY (envio_id)
)

-- Crear referencia de Envio a Cliente
ALTER TABLE PERSISTENTES.Envio
		ADD CONSTRAINT FK_EnvioCliente
		FOREIGN KEY (envio_cliente) REFERENCES PERSISTENTES.Cliente

-- Crear referencia de Envio a Ticket
ALTER TABLE PERSISTENTES.Envio
		ADD CONSTRAINT FK_EnvioTicket
		FOREIGN KEY (envio_ticket) REFERENCES PERSISTENTES.Ticket

-- Crear referencia de Envio a EnvioEstado
ALTER TABLE PERSISTENTES.Envio
		ADD CONSTRAINT FK_EnvioEstado
		FOREIGN KEY (envio_estado) REFERENCES PERSISTENTES.EnvioEstado

-- Crear tabla TipoMedioDePago
CREATE TABLE PERSISTENTES.TipoMedioDePago
(
	tipo_medio_de_pago nvarchar(255) NOT NULL

		CONSTRAINT PK_TipoMedioDePago PRIMARY KEY (tipo_medio_de_pago)
)

-- Crear tabla MedioDePago
CREATE TABLE PERSISTENTES.MedioDePago
(
	medio_de_pago nvarchar(255) NOT NULL,
	medio_de_pago_tipo nvarchar(255)

		CONSTRAINT PK_MedioDePago PRIMARY KEY (medio_de_pago)
)

-- Crear referencia de MedioDePago a TipoMedioDePago
ALTER TABLE PERSISTENTES.MedioDePago
		ADD CONSTRAINT FK_MedioDePagoTipo
		FOREIGN KEY (medio_de_pago_tipo) REFERENCES PERSISTENTES.TipoMedioDePago

-- Crear tabla Descuento
CREATE TABLE PERSISTENTES.Descuento
(
	descuento_codigo DECIMAL(18,0) NOT NULL,
	descuento_descripcion nvarchar(255),
	descuento_fecha_inicio datetime,
	descuento_fecha_fin datetime,
	descuento_porcentaje DECIMAL(18,2),
	descuento_tope DECIMAL(18,2)

		CONSTRAINT PK_Descuento PRIMARY KEY (descuento_codigo)
)

-- Crear tabla Pago
CREATE TABLE PERSISTENTES.Pago
(
	pago_id INT IDENTITY,
	pago_fecha datetime,
	pago_importe DECIMAL(18,2),
	pago_medio_pago nvarchar(255),
	pago_ticket INT,

	CONSTRAINT PK_Pago PRIMARY KEY (pago_id)
)

-- Crear referencia de Pago a MedioDePago
ALTER TABLE PERSISTENTES.Pago
		ADD CONSTRAINT FK_PagoMedioDePago
		FOREIGN KEY (pago_medio_pago) REFERENCES PERSISTENTES.MedioDePago

-- Crear referencia de Pago a Ticket
ALTER TABLE PERSISTENTES.Pago
		ADD CONSTRAINT FK_PagoTicket
		FOREIGN KEY (pago_ticket) REFERENCES PERSISTENTES.Ticket

-- Crear tabla DetallePagoTarjeta
CREATE TABLE PERSISTENTES.DetallePagoTarjeta
(
	detalle_pago_tarjeta_nro nvarchar(50),
	detalle_pago_tarjeta_cuotas DECIMAL(18,0),
	detalle_pago_tarjeta_fecha_vencimiento datetime,
	detalle_pago_cliente INT,
	detalle_pago_id INT,

	CONSTRAINT PK_DetallePago PRIMARY KEY (detalle_pago_id)
)

-- Crear referencia de DetallePagoTarjeta a Cliente
ALTER TABLE PERSISTENTES.DetallePagoTarjeta
		ADD CONSTRAINT FK_DetallePagoTarjetaCliente
		FOREIGN KEY (detalle_pago_cliente) REFERENCES PERSISTENTES.Cliente

-- Crear referencia de DetallePagoTarjeta a Pago
ALTER TABLE PERSISTENTES.DetallePagoTarjeta
		ADD CONSTRAINT FK_DetallePagoTarjetaPago
		FOREIGN KEY (detalle_pago_id) REFERENCES PERSISTENTES.Pago

-- Crear tabla Categoria
CREATE TABLE PERSISTENTES.DescuentoAplicado
(
	descuento_aplicado_descuento DECIMAL(18,0) NOT NULL,
	descuento_aplicado_pago INT NOT NULL,
	descuento_aplicado_cant DECIMAL(18,2)

		CONSTRAINT PK_DescuentoAplicado PRIMARY KEY (descuento_aplicado_descuento, descuento_aplicado_pago)
)

-- Crear referencia de DescuentoAplicado a Descuento
ALTER TABLE PERSISTENTES.DescuentoAplicado
		ADD CONSTRAINT FK_DescuentoAplicadoDescuento
		FOREIGN KEY (descuento_aplicado_descuento) REFERENCES PERSISTENTES.Descuento

-- Crear referencia de DescuentoAplicado a Pago
ALTER TABLE PERSISTENTES.DescuentoAplicado
		ADD CONSTRAINT FK_DescuentoAplicadoPago
		FOREIGN KEY (descuento_aplicado_pago) REFERENCES PERSISTENTES.Pago

-- Crear tabla Marca
CREATE TABLE PERSISTENTES.Marca
(
	marca_id INT IDENTITY,
	marca_nombre nvarchar(255)

		CONSTRAINT PK_Marca PRIMARY KEY (marca_id)
)

-- Crear tabla Categoria
CREATE TABLE PERSISTENTES.Categoria
(
	categoria_id INT IDENTITY,
	categoria_nombre nvarchar(255),
	categoria_madre INT NULL

		CONSTRAINT PK_Categoria PRIMARY KEY (categoria_id)
)

-- Crear referencia de Categoria a Categoria (subcategorias)
ALTER TABLE PERSISTENTES.Categoria
		ADD CONSTRAINT FK_Categoria
		FOREIGN KEY (categoria_madre) REFERENCES PERSISTENTES.Categoria

-- Crear tabla Producto
CREATE TABLE PERSISTENTES.Producto
(
	producto_id INT IDENTITY,
	producto_nombre nvarchar(255),
	producto_marca_id INT,
	producto_descripcion nvarchar(255),
	producto_precio DECIMAL(18,2),
	producto_categoria INT

		CONSTRAINT PK_Producto PRIMARY KEY (producto_id)
)

-- Crear referencia de Producto a Marca
ALTER TABLE PERSISTENTES.Producto
		ADD CONSTRAINT FK_ProductoMarca
		FOREIGN KEY (producto_marca_id) REFERENCES PERSISTENTES.Marca

-- Crear referencia de Producto a Categoria
ALTER TABLE PERSISTENTES.Producto
	ADD CONSTRAINT FK_ProductoCategoria
	FOREIGN KEY (producto_categoria) REFERENCES PERSISTENTES.Categoria

-- Crear tabla TicketDetalle
CREATE TABLE PERSISTENTES.TicketDetalle
(
	ticket_det_id INT IDENTITY,
	ticket_det_ticket INT,
	ticket_det_producto INT,
	ticket_det_cantidad DECIMAL(18,0),
	ticket_det_total DECIMAL(18,2),
	ticket_det_precio DECIMAL(18,2)

		CONSTRAINT PK_TicketDetalle PRIMARY KEY (ticket_det_id)
)

-- Crear referencia de TicketDetalle a Ticket
ALTER TABLE PERSISTENTES.TicketDetalle
		ADD CONSTRAINT FK_ticketDetalleTicket
		FOREIGN KEY (ticket_det_ticket) REFERENCES PERSISTENTES.Ticket

-- Crear referencia de TicketDetalle a Producto
ALTER TABLE PERSISTENTES.TicketDetalle
		ADD CONSTRAINT FK_TicketDetalleProducto
		FOREIGN KEY (ticket_det_producto) REFERENCES PERSISTENTES.Producto

-- Crear tabla DescuentoAplicado
CREATE TABLE PERSISTENTES.Promocion
(
	promo_codigo DECIMAL(18,0) NOT NULL,
	--	promo_aplicada_id INT,
	promocion_descripcion nvarchar(255),
	promocion_fecha_inicio datetime,
	promocion_fecha_fin datetime

		CONSTRAINT PK_Promocion PRIMARY KEY (promo_codigo)
)

-- Crear tabla PromoAplicada
CREATE TABLE PERSISTENTES.PromoAplicada
(
	promo_aplicada_id INT IDENTITY,
	promo_aplicada_ticketDet INT,
	promo_aplicada_descuento DECIMAL(18,2),
	promo_promocion DECIMAL(18,0)

		CONSTRAINT PK_PromoAplicada PRIMARY KEY (promo_aplicada_id)
)

-- Crear referencia de PromoAplicada a TicketDetalle
ALTER TABLE PERSISTENTES.PromoAplicada
		ADD CONSTRAINT FK_PromoAplicadaTicketDet
		FOREIGN KEY (promo_aplicada_ticketDet) REFERENCES PERSISTENTES.TicketDetalle

-- Crear referencia de PromoAplicada a Promocion
ALTER TABLE PERSISTENTES.PromoAplicada
		ADD CONSTRAINT FK_PromoAplicadaPromocion
		FOREIGN KEY (promo_promocion) REFERENCES PERSISTENTES.Promocion

-- Crear tabla Regla
CREATE TABLE PERSISTENTES.Regla
(
	regla_id INT IDENTITY,
	regla_promocion DECIMAL(18,0),
	regla_aplica_misma_marca DECIMAL(18,0),
	regla_aplica_mismo_prod DECIMAL(18,0),
	regla_cant_aplica_descuento DECIMAL(18,0),
	regla_cant_aplicable_regla DECIMAL(18,0),
	regla_cant_max_prod DECIMAL(18,0),
	regla_descripcion nvarchar(255),
	regla_descuento_aplicable_prod DECIMAL(18,2)

		CONSTRAINT PK_Regla PRIMARY KEY (regla_id)
)

-- Crear referencia de Regla a Promocion
ALTER TABLE PERSISTENTES.Regla
		ADD CONSTRAINT FK_ReglaPromocion
		FOREIGN KEY (regla_promocion) REFERENCES PERSISTENTES.Promocion

-- Crear tabla DescuentoAplicado
CREATE TABLE PERSISTENTES.PromocionPorProducto
(
	promo_codigo DECIMAL(18,0) NOT NULL,
	producto_id INT NOT NULL

		CONSTRAINT PK_PromocionPorProducto PRIMARY KEY (promo_codigo, producto_id)
)

-- Crear referencia de PromocionPorProducto a Promocion
ALTER TABLE PERSISTENTES.PromocionPorProducto
		ADD CONSTRAINT FK_PromocionPorProductoPromo 
		FOREIGN KEY (promo_codigo) REFERENCES PERSISTENTES.Promocion

-- Crear referencia de PromocionPorProducto a Producto
ALTER TABLE PERSISTENTES.PromocionPorProducto
		ADD CONSTRAINT FK_PromocionPorProductoProd 
		FOREIGN KEY (producto_id) REFERENCES PERSISTENTES.Producto

-- Crear tabla SubcategoriaCategoria
CREATE TABLE PERSISTENTES.SubcategoriaCategoria
(
	PRODUCTO_SUB_CATEGORIA NVARCHAR(255),
	PRODUCTO_CATEGORIA NVARCHAR(255)
)
GO

-------MIGRACION DE TABLAS
CREATE PROCEDURE migrar_datos
AS
-- Migrar datos de la tabla Maestra a Provincia
INSERT INTO PERSISTENTES.Provincia
	(provincia_nombre)
SELECT DISTINCT provincia_nombre
FROM (
				SELECT DISTINCT SUPER_PROVINCIA AS provincia_nombre
		FROM [GD1C2024].[gd_esquema].[Maestra]
		WHERE SUPER_PROVINCIA IS NOT NULL
	UNION
		SELECT DISTINCT CLIENTE_PROVINCIA AS provincia_nombre
		FROM [GD1C2024].[gd_esquema].[Maestra]
		WHERE CLIENTE_PROVINCIA IS NOT NULL
	UNION
		SELECT DISTINCT SUCURSAL_PROVINCIA AS provincia_nombre
		FROM [GD1C2024].[gd_esquema].[Maestra]
		WHERE SUCURSAL_PROVINCIA IS NOT NULL
	) AS Provincia


-- Migrar datos de la tabla Maestra a Localidad
INSERT INTO PERSISTENTES.Localidad
	(localidad_nombre, localidad_provincia)
SELECT DISTINCT maestra_localidad_nombre, nueva_provincia_id
FROM (
																							SELECT maestra.SUCURSAL_LOCALIDAD AS maestra_localidad_nombre, nueva_provincia_t.provincia_id nueva_provincia_id
		FROM GD1C2024.gd_esquema.Maestra maestra LEFT JOIN PERSISTENTES.Provincia nueva_provincia_t ON nueva_provincia_t.provincia_nombre = maestra.SUCURSAL_PROVINCIA
		WHERE SUCURSAL_LOCALIDAD IS NOT NULL
	UNION
		SELECT maestra.SUPER_LOCALIDAD AS maestra_localidad_nombre, nueva_provincia_t.provincia_id nueva_provincia_id
		FROM GD1C2024.gd_esquema.Maestra maestra LEFT JOIN PERSISTENTES.Provincia nueva_provincia_t ON nueva_provincia_t.provincia_nombre = maestra.SUPER_PROVINCIA
		WHERE SUPER_LOCALIDAD IS NOT NULL
	UNION
		SELECT maestra.CLIENTE_LOCALIDAD AS maestra_localidad_nombre, nueva_provincia_t.provincia_id nueva_provincia_id
		FROM GD1C2024.gd_esquema.Maestra maestra LEFT JOIN PERSISTENTES.Provincia nueva_provincia_t ON nueva_provincia_t.provincia_nombre = maestra.CLIENTE_PROVINCIA
		WHERE CLIENTE_LOCALIDAD IS NOT NULL
		) AS Localidad;

-- Migrar datos de la tabla Maestra a TipoCaja
INSERT INTO PERSISTENTES.TipoCaja
	(tipo_caja)
SELECT DISTINCT CAJA_TIPO
FROM [GD1C2024].[gd_esquema].[Maestra]
WHERE CAJA_TIPO IS NOT NULL

-- Migrar datos de la tabla Maestra a TipoMedioDePago
INSERT INTO PERSISTENTES.EnvioEstado
	(envio_estado)
SELECT DISTINCT ENVIO_ESTADO
FROM GD1C2024.gd_esquema.Maestra
WHERE ENVIO_ESTADO IS NOT NULL

-- Migra datos de la tabla Maestra a TipoMedioDePago
INSERT INTO PERSISTENTES.TipoComprobante
	(tipo_comprobante)
SELECT DISTINCT TICKET_TIPO_COMPROBANTE
FROM [GD1C2024].[gd_esquema].[Maestra]
WHERE TICKET_TIPO_COMPROBANTE IS NOT NULL

-- Migrar datos de la tabla Maestra a CondicionFiscal
INSERT INTO PERSISTENTES.CondicionFiscal
SELECT DISTINCT SUPER_CONDICION_FISCAL
FROM [GD1C2024].[gd_esquema].[Maestra]
WHERE SUPER_CONDICION_FISCAL IS NOT NULL

-- Migrar datos de la tabla Maestra a Marca
INSERT INTO PERSISTENTES.Marca
SELECT DISTINCT PRODUCTO_MARCA
FROM [GD1C2024].[gd_esquema].[Maestra]
WHERE PRODUCTO_MARCA IS NOT NULL

-- Migrar datos de la tabla Maestra a TipoMedioDePago
INSERT INTO PERSISTENTES.TipoMedioDePago
	(tipo_medio_de_pago)
SELECT DISTINCT PAGO_TIPO_MEDIO_PAGO
FROM GD1C2024.gd_esquema.Maestra
WHERE PAGO_TIPO_MEDIO_PAGO IS NOT NULL

-- Migrar datos de la tabla Maestra a MedioDePago
INSERT INTO PERSISTENTES.MedioDePago
	(medio_de_pago, medio_de_pago_tipo)
SELECT DISTINCT maestra_medio_de_pago, nueva_tipo_medio_de_pago
FROM (
        SELECT maestra.PAGO_MEDIO_PAGO AS maestra_medio_de_pago, nueva_tipo_medio_de_pago_t.tipo_medio_de_pago AS nueva_tipo_medio_de_pago
	FROM GD1C2024.gd_esquema.Maestra maestra LEFT JOIN PERSISTENTES.TipoMedioDePago nueva_tipo_medio_de_pago_t
		ON nueva_tipo_medio_de_pago_t.tipo_medio_de_pago = maestra.PAGO_TIPO_MEDIO_PAGO
	WHERE PAGO_MEDIO_PAGO IS NOT NULL 
		) AS MedioDePago;


-- Migrar datos de la tabla Maestra a Descuento
INSERT INTO PERSISTENTES.Descuento
	(descuento_codigo, descuento_descripcion, descuento_fecha_inicio, descuento_fecha_fin, descuento_porcentaje, descuento_tope)
SELECT DISTINCT DESCUENTO_CODIGO, DESCUENTO_DESCRIPCION, DESCUENTO_FECHA_FIN, DESCUENTO_FECHA_INICIO, DESCUENTO_PORCENTAJE_DESC, DESCUENTO_TOPE
FROM [GD1C2024].[gd_esquema].[Maestra]
WHERE DESCUENTO_CODIGO IS NOT NULL

-- Migrar datos de la tabla Maestra a Super
INSERT INTO PERSISTENTES.Super
	(super_nombre, super_razon_soc, super_cuit, super_iibb, super_domicilio, super_fecha_ini_actividad, super_condicion_fiscal_id, super_localidad_id)
SELECT DISTINCT maestra_super_nombre, maestra_super_razon_soc, maestra_super_cuit, maestra_super_iibb, maestra_super_domicilio, maestra_super_fecha_ini_actividad, nueva_condicion_fiscal, nueva_localidad_id
FROM (
		SELECT maestra.SUPER_NOMBRE AS maestra_super_nombre,
		maestra.SUPER_RAZON_SOC AS maestra_super_razon_soc,
		maestra.SUPER_CUIT AS maestra_super_cuit,
		maestra.SUPER_IIBB AS maestra_super_iibb,
		maestra.SUPER_DOMICILIO AS maestra_super_domicilio,
		maestra.SUPER_FECHA_INI_ACTIVIDAD AS maestra_super_fecha_ini_actividad,
		nueva_condicion_fiscal_t.condicion_fiscal nueva_condicion_fiscal,
		nueva_Localidad_t.localidad_id nueva_localidad_id
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.CondicionFiscal nueva_condicion_fiscal_t ON nueva_condicion_fiscal_t.condicion_fiscal = maestra.SUPER_CONDICION_FISCAL
		LEFT JOIN PERSISTENTES.Localidad nueva_Localidad_t ON nueva_Localidad_t.localidad_nombre = maestra.SUPER_LOCALIDAD
	WHERE SUPER_NOMBRE IS NOT NULL
	) AS Super

-- Migrar datos de la tabla Maestra a Sucursal
INSERT INTO PERSISTENTES.Sucursal
	(sucursal_nombre, sucursal_direccion, sucursal_localidad_id, sucursal_super)
SELECT DISTINCT maestra_sucursal_nombre, maestra_sucursal_direccion, nueva_localidad_id, nueva_super_id
FROM (
		SELECT maestra.SUCURSAL_NOMBRE AS maestra_sucursal_nombre,
		maestra.SUCURSAL_DIRECCION AS maestra_sucursal_direccion,
		nueva_Localidad_t.localidad_id nueva_localidad_id,
		nueva_Super_t.super_nro nueva_super_id
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Localidad nueva_Localidad_t ON nueva_Localidad_t.localidad_nombre = maestra.SUCURSAL_LOCALIDAD
		LEFT JOIN PERSISTENTES.Super nueva_Super_t ON nueva_Super_t.super_nombre = maestra.SUPER_NOMBRE
	WHERE SUCURSAL_NOMBRE IS NOT NULL
	) AS Sucursal

-- Migrar datos de la tabla Maestra a Caja
INSERT INTO PERSISTENTES.Caja
	(caja_nro, caja_sucursal, caja_tipo)
SELECT DISTINCT maestra_caja_nro, nueva_sucursal_id, nueva_caja_tipo_id
FROM (
        SELECT maestra.CAJA_NUMERO AS maestra_caja_nro,
		nueva_Sucursal_t.sucursal_id nueva_sucursal_id,
		nueva_CajaTipo_t.tipo_caja nueva_caja_tipo_id
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Sucursal nueva_Sucursal_t ON nueva_Sucursal_t.sucursal_nombre = maestra.SUCURSAL_NOMBRE
		LEFT JOIN PERSISTENTES.TipoCaja nueva_CajaTipo_t ON nueva_CajaTipo_t.tipo_caja = maestra.CAJA_TIPO
	WHERE CAJA_NUMERO IS NOT NULL OR CAJA_TIPO IS NOT NULL
    ) AS Caja

--Migrar datos de la tabla Maestra a Empleado
INSERT INTO PERSISTENTES.Empleado
	(empleado_nombre, empleado_apellido, empleado_fecha_registro, empleado_telefono, empleado_mail, empleado_fecha_nacimiento, empleado_dni, empleado_sucursal)
SELECT DISTINCT maestra_empleado_nombre, maestra_empleado_apellido, maestra_empleado_fecha_registro, maestra_empleado_telefono, maestra_empleado_mail, maestra_empleado_fecha_nacimiento,
	maestra_empleado_dni, nueva_sucursal_id
FROM (
			SELECT maestra.EMPLEADO_NOMBRE AS maestra_empleado_nombre,
		maestra.EMPLEADO_APELLIDO AS maestra_empleado_apellido,
		maestra.EMPLEADO_FECHA_REGISTRO AS maestra_empleado_fecha_registro,
		maestra.EMPLEADO_TELEFONO AS maestra_empleado_telefono,
		maestra.EMPLEADO_MAIL AS maestra_empleado_mail,
		maestra.empleado_fecha_nacimiento AS maestra_empleado_fecha_nacimiento,
		maestra.EMPLEADO_DNI AS maestra_empleado_dni,
		nueva_Sucursal_t.sucursal_id nueva_sucursal_id
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Sucursal nueva_Sucursal_t ON nueva_Sucursal_t.sucursal_nombre = maestra.SUCURSAL_NOMBRE
	WHERE EMPLEADO_NOMBRE IS NOT NULL
		) AS Empleado

-- Migrar datos de la tabla Maestra a Ticket
INSERT INTO PERSISTENTES.Ticket
	(ticket_numero, ticket_fecha_hora, ticket_subtotal_productos, ticket_total_descuento, ticket_total_descuento_aplicado_mp, ticket_total_envio,
	ticket_total_ticket, ticket_caja_nro, ticket_caja_sucursal, ticket_empleado, ticket_tipo_comprobante)
SELECT DISTINCT maestra_ticket_numero, maestra_ticket_fecha_hora, maestra_ticket_subtotal_productos, maestra_ticket_total_descuento, maestra_ticket_total_descuento_aplicado_mp,
	maestra_ticket_total_envio, maestra_ticket_total_ticket, nueva_ticket_caja_nro, nueva_ticket_caja_sucursal, nueva_ticket_empleado, nueva_ticket_tipo_comprobante
FROM (
		SELECT maestra.TICKET_NUMERO AS maestra_ticket_numero,
		maestra.TICKET_FECHA_HORA AS maestra_ticket_fecha_hora,
		maestra.TICKET_SUBTOTAL_PRODUCTOS AS maestra_ticket_subtotal_productos,
		maestra.TICKET_TOTAL_DESCUENTO_APLICADO AS maestra_ticket_total_descuento,
		maestra.TICKET_TOTAL_DESCUENTO_APLICADO_MP AS maestra_ticket_total_descuento_aplicado_mp,
		maestra.TICKET_TOTAL_ENVIO AS maestra_ticket_total_envio,
		maestra.TICKET_TOTAL_TICKET AS maestra_ticket_total_ticket,
		nueva_Caja_t.caja_nro AS nueva_ticket_caja_nro,
		nueva_Caja_t.caja_sucursal AS nueva_ticket_caja_sucursal,
		nueva_Empleado_t.legajo_empleado AS nueva_ticket_empleado,
		nueva_TipoComprobate_t.tipo_comprobante AS nueva_ticket_tipo_comprobante
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Empleado nueva_Empleado_t ON nueva_Empleado_t.empleado_dni = maestra.EMPLEADO_DNI
		LEFT JOIN PERSISTENTES.TipoComprobante nueva_TipoComprobate_t ON nueva_TipoComprobate_t.tipo_comprobante = maestra.TICKET_TIPO_COMPROBANTE
		LEFT JOIN PERSISTENTES.Caja nueva_caja_t ON nueva_Caja_t.caja_nro = maestra.CAJA_NUMERO AND nueva_Caja_t.caja_sucursal = (
			SELECT sucursal_id
			FROM PERSISTENTES.Sucursal
			WHERE sucursal_nombre = maestra.SUCURSAL_NOMBRE
		)
	WHERE maestra.TICKET_NUMERO IS NOT NULL AND maestra.EMPLEADO_DNI IS NOT NULL
	) AS Ticket

-- Migrar datos de la tabla Maestra a Pago
INSERT INTO PERSISTENTES.Pago
	(pago_fecha, pago_importe, pago_medio_pago, pago_ticket)
SELECT DISTINCT maestra_pago_fecha, maestra_pago_importe, nueva_pago_medio_pago, nueva_pago_ticket
FROM (
	SELECT maestra.PAGO_FECHA AS maestra_pago_fecha,
		maestra.PAGO_IMPORTE AS maestra_pago_importe,
		nueva_MedioDePago_t.medio_de_pago nueva_pago_medio_pago,
		nueva_Ticket_t.ticket_id AS nueva_pago_ticket
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Ticket nueva_Ticket_t ON nueva_Ticket_t.ticket_numero = maestra.TICKET_NUMERO AND
			nueva_Ticket_t.ticket_tipo_comprobante = maestra.TICKET_TIPO_COMPROBANTE AND
			nueva_Ticket_t.ticket_caja_sucursal = (SELECT sucursal_id
			FROM PERSISTENTES.Sucursal
			WHERE sucursal_nombre = maestra.SUCURSAL_NOMBRE)
			AND nueva_ticket_t.ticket_total_ticket = maestra.PAGO_IMPORTE
		LEFT JOIN PERSISTENTES.MedioDePago nueva_MedioDePago_t ON nueva_MedioDePago_t.medio_de_pago = maestra.PAGO_MEDIO_PAGO
	WHERE maestra.PAGO_FECHA IS NOT NULL AND maestra.PAGO_IMPORTE IS NOT NULL AND maestra.PAGO_MEDIO_PAGO IS NOT NULL AND maestra.TICKET_NUMERO IS NOT NULL
) AS Pago

--Migrar datos de la tabla Maestra a DetallePagoTarjeta
INSERT INTO PERSISTENTES.DetallePagoTarjeta
	(detalle_pago_id, detalle_pago_tarjeta_cuotas, detalle_pago_tarjeta_nro, detalle_pago_tarjeta_fecha_vencimiento, detalle_pago_cliente)
SELECT DISTINCT nueva_pago_id, maestra_detalle_pago_tarjeta_cuotas, maestra_detalle_pago_tarjeta_nro, nueva_detalle_pago_tarjeta_fecha_vencimiento, nueva_detalle_pago_cliente
FROM (
		SELECT nueva_Pago_t.pago_id AS nueva_pago_id,
		maestra.PAGO_TARJETA_CUOTAS AS maestra_detalle_pago_tarjeta_cuotas,
		maestra.PAGO_TARJETA_NRO AS maestra_detalle_pago_tarjeta_nro,
		maestra.PAGO_TARJETA_FECHA_VENC AS nueva_detalle_pago_tarjeta_fecha_vencimiento,
		nueva_Cliente_t.cliente_id AS nueva_detalle_pago_cliente
	FROM [GD1C2024].[gd_esquema].[Maestra] maestra
		LEFT JOIN PERSISTENTES.Pago nueva_Pago_t ON nueva_Pago_t.pago_fecha = maestra.PAGO_FECHA AND nueva_Pago_t.pago_importe = maestra.PAGO_IMPORTE AND nueva_Pago_t.pago_medio_pago = maestra.PAGO_MEDIO_PAGO
		LEFT JOIN PERSISTENTES.Ticket nueva_Ticket_t ON nueva_Ticket_t.ticket_id = nueva_Pago_t.pago_ticket
		LEFT JOIN PERSISTENTES.Envio nueva_Envio_t ON nueva_Envio_t.envio_ticket = nueva_Ticket_t.ticket_id
		LEFT JOIN PERSISTENTES.Cliente nueva_Cliente_t ON nueva_Envio_t.envio_ticket = nueva_Cliente_t.cliente_id
	WHERE maestra.PAGO_TARJETA_CUOTAS IS NOT NULL AND maestra.PAGO_TARJETA_NRO IS NOT NULL AND maestra.PAGO_TARJETA_FECHA_VENC IS NOT NULL
	) AS DetallePagoTarjeta

-- Migrar datos de la tabla Maestra a Cliente
INSERT INTO PERSISTENTES.Cliente
	(cliente_nombre, cliente_apellido, cliente_dni, cliente_fecha_registro, cliente_telefono, cliente_mail,cliente_fecha_nacimiento, cliente_domicilio, cliente_localidad_id)
SELECT DISTINCT maestra_cliente_nombre, maestra_cliente_apellido, maestra_cliente_dni, maestra_cliente_fecha_registro, maestra_cliente_telefono, maestra_cliente_mail, maestra_cliente_fecha_nacimiento,
	maestra_cliente_domicilio, nueva_localidad_id
FROM (
		SELECT maestra.CLIENTE_NOMBRE AS maestra_cliente_nombre,
		maestra.CLIENTE_APELLIDO AS maestra_cliente_apellido,
		maestra.CLIENTE_DNI AS maestra_cliente_dni,
		maestra.CLIENTE_FECHA_REGISTRO AS maestra_cliente_fecha_registro,
		maestra.CLIENTE_TELEFONO AS maestra_cliente_telefono,
		maestra.CLIENTE_MAIL AS maestra_cliente_mail,
		maestra.CLIENTE_FECHA_NACIMIENTO AS maestra_cliente_fecha_nacimiento,
		maestra.CLIENTE_DOMICILIO AS maestra_cliente_domicilio,
		nueva_localidad_t.localidad_id AS nueva_localidad_id
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Localidad nueva_localidad_t ON nueva_localidad_t.localidad_nombre = maestra.CLIENTE_LOCALIDAD AND nueva_localidad_t.localidad_provincia = (
			SELECT provincia_id
			FROM PERSISTENTES.Provincia
			WHERE provincia_nombre = maestra.CLIENTE_PROVINCIA
		)
	WHERE maestra.CLIENTE_DNI IS NOT NULL
	) AS Cliente

-- Migrar datos de la tabla Maestra a DescuentoAplicado
INSERT INTO PERSISTENTES.DescuentoAplicado
	(
	descuento_aplicado_descuento,
	descuento_aplicado_pago,
	descuento_aplicado_cant)
SELECT DISTINCT
	maestra_descuento_aplicado_descuento,
	maestra_descuento_aplicado_pago,
	maestra_descuento_aplicado_cant
FROM (
		SELECT
		nuevo_descuento.descuento_codigo AS maestra_descuento_aplicado_descuento,
		nuevo_pago.pago_id AS maestra_descuento_aplicado_pago,
		Maestra.PAGO_DESCUENTO_APLICADO AS maestra_descuento_aplicado_cant
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Descuento nuevo_descuento ON nuevo_descuento.descuento_codigo = Maestra.DESCUENTO_CODIGO
		LEFT JOIN PERSISTENTES.Pago nuevo_pago ON nuevo_pago.pago_importe = Maestra.PAGO_IMPORTE
	WHERE Maestra.DESCUENTO_CODIGO IS NOT NULL AND Maestra.PAGO_IMPORTE IS NOT NULL
	) AS DescuentoAplicado


-- Migrar datos de la tabla Maestra a Categoria
INSERT INTO PERSISTENTES.Categoria
	(categoria_nombre)
SELECT DISTINCT PRODUCTO_CATEGORIA
FROM [GD1C2024].[gd_esquema].[Maestra]
WHERE PRODUCTO_CATEGORIA IS NOT NULL

-- Migrar datos de la tabla Maestra a SubcategoriaCategoria
INSERT INTO PERSISTENTES.SubcategoriaCategoria
	(PRODUCTO_SUB_CATEGORIA, PRODUCTO_CATEGORIA)
SELECT DISTINCT PRODUCTO_SUB_CATEGORIA, PRODUCTO_CATEGORIA
FROM (
	SELECT PRODUCTO_SUB_CATEGORIA, PRODUCTO_CATEGORIA, COUNT(*) AS cantidad
	FROM [GD1C2024].[gd_esquema].[Maestra]
	WHERE PRODUCTO_SUB_CATEGORIA IS NOT NULL AND PRODUCTO_CATEGORIA IS NOT NULL
	GROUP BY PRODUCTO_SUB_CATEGORIA, PRODUCTO_CATEGORIA
	) AS subConsulta
WHERE cantidad = (
	SELECT MAX(cantidad)
FROM (	SELECT COUNT(*) AS cantidad
	FROM [GD1C2024].[gd_esquema].[Maestra]
	WHERE PRODUCTO_SUB_CATEGORIA = subConsulta.PRODUCTO_SUB_CATEGORIA AND PRODUCTO_CATEGORIA IS NOT NULL
	GROUP BY PRODUCTO_CATEGORIA
			) AS otraConsulta
	)

-- Migrar datos de la tabla Maestra a Categoria (subcategorias)
INSERT INTO PERSISTENTES.Categoria
	(categoria_nombre, categoria_madre)
SELECT DISTINCT PRODUCTO_SUB_CATEGORIA, c.categoria_id
FROM PERSISTENTES.SubcategoriaCategoria
	JOIN PERSISTENTES.Categoria c ON c.categoria_nombre = PRODUCTO_CATEGORIA

--Migrar datos de la tabla Maestra a Producto
INSERT INTO PERSISTENTES.Producto
	(producto_nombre, producto_descripcion, producto_precio, producto_marca_id, producto_categoria)
SELECT DISTINCT maestra_producto_nombre, maestra_producto_descripcion, maestra_producto_precio, nueva_producto_marca, nueva_producto_categoria
FROM (
		SELECT maestra.PRODUCTO_NOMBRE AS maestra_producto_nombre,
		maestra.PRODUCTO_DESCRIPCION AS maestra_producto_descripcion,
		maestra.PRODUCTO_PRECIO AS maestra_producto_precio,
		nueva_producto_marca_t.marca_id AS nueva_producto_marca,
		nueva_producto_categoria_t.categoria_id AS nueva_producto_categoria
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Marca nueva_producto_marca_t ON nueva_producto_marca_t.marca_nombre = PRODUCTO_MARCA
		LEFT JOIN PERSISTENTES.Categoria nueva_producto_categoria_t ON nueva_producto_categoria_t.categoria_nombre = maestra.PRODUCTO_SUB_CATEGORIA
	WHERE PRODUCTO_NOMBRE IS NOT NULL
	) AS Producto

--Migrar datos de la tabla Maestra a TicketDetalle
INSERT INTO PERSISTENTES.TicketDetalle
	(ticket_det_ticket, ticket_det_producto, ticket_det_cantidad, ticket_det_total, ticket_det_precio)
SELECT DISTINCT nueva_ticket_detalle_ticket, nueva_ticket_detalle_producto, maestra_ticket_detalle_cantidad, maestra_ticket_detalle_subtotal, maestra_ticket_detalle_precio_unitario
FROM (
		SELECT nueva_Ticket_t.ticket_id AS nueva_ticket_detalle_ticket,
		nueva_Producto_t.producto_id AS nueva_ticket_detalle_producto,
		maestra.TICKET_DET_CANTIDAD AS maestra_ticket_detalle_cantidad,
		maestra.TICKET_DET_TOTAL AS maestra_ticket_detalle_subtotal,
		maestra.TICKET_DET_PRECIO AS maestra_ticket_detalle_precio_unitario
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Ticket nueva_Ticket_t ON nueva_Ticket_t.ticket_numero = maestra.TICKET_NUMERO AND
			nueva_ticket_t.ticket_caja_sucursal = (SELECT sucursal_id
			FROM PERSISTENTES.Sucursal
			WHERE sucursal_nombre = maestra.SUCURSAL_NOMBRE) AND
			nueva_ticket_t.ticket_tipo_comprobante = maestra.TICKET_TIPO_COMPROBANTE AND
			nueva_ticket_t.ticket_total_ticket = Maestra.TICKET_TOTAL_TICKET
		LEFT JOIN PERSISTENTES.Producto nueva_Producto_t ON nueva_Producto_t.producto_nombre = maestra.PRODUCTO_NOMBRE AND
			nueva_Producto_t.producto_marca_id = (SELECT marca_id
			FROM PERSISTENTES.Marca
			WHERE marca_nombre = maestra.PRODUCTO_MARCA)
			AND nueva_Producto_t.producto_precio = TICKET_DET_PRECIO
	WHERE maestra.TICKET_NUMERO IS NOT NULL AND maestra.PRODUCTO_NOMBRE IS NOT NULL
	) AS TicketDetalle


--Migrar datos de la tabla Maestra a Envio
INSERT INTO PERSISTENTES.Envio
	(envio_costo, envio_fecha_programada, envio_hora_inicio, envio_hora_fin, envio_fecha_entrega, envio_cliente, envio_estado, envio_ticket)
SELECT DISTINCT maestra_envio_costo, maestra_envio_fecha_programada, maestra_envio_hora_inicio, maestra_envio_hora_fin, maestra_envio_fecha_entrega, nueva_envio_cliente_id,
	nueva_envio_estado, nueva_envio_ticket_id
FROM (
			SELECT maestra.ENVIO_COSTO AS maestra_envio_costo,
		maestra.ENVIO_FECHA_PROGRAMADA AS maestra_envio_fecha_programada,
		maestra.ENVIO_HORA_INICIO AS maestra_envio_hora_inicio,
		maestra.ENVIO_HORA_FIN AS  maestra_envio_hora_fin,
		maestra.ENVIO_FECHA_ENTREGA AS maestra_envio_fecha_entrega,
		nueva_envio_cliente_t.cliente_id AS nueva_envio_cliente_id,
		nueva_envio_estado_t.envio_estado AS nueva_envio_estado,
		nueva_envio_ticket_t.ticket_id AS nueva_envio_ticket_id
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Cliente nueva_envio_cliente_t ON nueva_envio_cliente_t.cliente_dni = maestra.CLIENTE_DNI
		LEFT JOIN PERSISTENTES.EnvioEstado nueva_envio_estado_t ON nueva_envio_estado_t.envio_estado = maestra.ENVIO_ESTADO
		LEFT JOIN PERSISTENTES.Ticket nueva_envio_ticket_t ON nueva_envio_ticket_t.ticket_numero = maestra.TICKET_NUMERO AND nueva_envio_ticket_t.ticket_tipo_comprobante = maestra.TICKET_TIPO_COMPROBANTE
			AND nueva_envio_ticket_t.ticket_caja_sucursal = (SELECT sucursal_id
			FROM PERSISTENTES.Sucursal s
			WHERE s.sucursal_nombre = maestra.SUCURSAL_NOMBRE)
			AND nueva_envio_ticket_t.ticket_total_envio = Maestra.TICKET_TOTAL_ENVIO
	WHERE maestra.ENVIO_COSTO IS NOT NULL
		) AS Envio

-- Migrar datos de la tabla Maestra a Promocion
INSERT INTO PERSISTENTES.Promocion
	(promo_codigo, promocion_descripcion, promocion_fecha_inicio, promocion_fecha_fin)
SELECT DISTINCT
	Maestra.PROMO_CODIGO,
	Maestra.PROMOCION_DESCRIPCION,
	Maestra.PROMOCION_FECHA_INICIO,
	Maestra.PROMOCION_FECHA_FIN
FROM [GD1C2024].[gd_esquema].[Maestra] Maestra
WHERE Maestra.PROMO_CODIGO IS NOT NULL


-- Migrar datos de la tabla Maestra a Regla
INSERT INTO PERSISTENTES.Regla
	(regla_aplica_misma_marca, regla_aplica_mismo_prod,regla_cant_aplica_descuento,regla_cant_aplicable_regla,regla_cant_max_prod,regla_descripcion,regla_descuento_aplicable_prod,regla_promocion)
SELECT DISTINCT
	maestra.REGLA_APLICA_MISMA_MARCA,
	maestra.REGLA_APLICA_MISMO_PROD,
	maestra.REGLA_CANT_APLICA_DESCUENTO,
	maestra.REGLA_CANT_APLICABLE_REGLA,
	maestra.REGLA_CANT_MAX_PROD,
	maestra.REGLA_DESCRIPCION,
	maestra.REGLA_DESCUENTO_APLICABLE_PROD,
	nueva_regla_promocion.promo_codigo
FROM [GD1C2024].[gd_esquema].[Maestra]
	JOIN PERSISTENTES.Promocion nueva_regla_promocion ON nueva_regla_promocion.promo_codigo = maestra.PROMO_CODIGO
WHERE maestra.PROMO_CODIGO IS NOT NULL

-- Migra datos de la tabla Maestra a PromoAplicada
INSERT INTO PERSISTENTES.PromoAplicada
	(promo_aplicada_ticketDet, promo_aplicada_descuento,promo_promocion)
SELECT DISTINCT nuevo_detalle_ticket_promo_aplicada_ticketDet, maestra_promo_aplicada_descuento, nueva_promo_promocion
FROM (
		SELECT nuevo_detalle_ticket.ticket_det_id AS nuevo_detalle_ticket_promo_aplicada_ticketDet,
		Maestra.PROMO_APLICADA_DESCUENTO AS maestra_promo_aplicada_descuento,
		nueva_promo_promocion_t.promo_codigo AS nueva_promo_promocion
	FROM [GD1C2024].[gd_esquema].[Maestra]
		JOIN PERSISTENTES.TicketDetalle nuevo_detalle_ticket ON nuevo_detalle_ticket.ticket_det_cantidad = Maestra.TICKET_DET_CANTIDAD
			AND nuevo_detalle_ticket.ticket_det_precio = Maestra.TICKET_DET_PRECIO AND nuevo_detalle_ticket.ticket_det_total = Maestra.TICKET_DET_TOTAL
			AND nuevo_detalle_ticket.ticket_det_producto = (SELECT producto_id
			FROM PERSISTENTES.Producto p
			WHERE p.producto_nombre = Maestra.PRODUCTO_NOMBRE
				AND p.producto_marca_id = (SELECT marca_id
				FROM PERSISTENTES.Marca m
				WHERE m.marca_nombre = Maestra.PRODUCTO_MARCA)
				AND p.producto_precio = Maestra.PRODUCTO_PRECIO
    )
			AND nuevo_detalle_ticket.ticket_det_ticket = (SELECT ticket_id
			FROM PERSISTENTES.Ticket t
			WHERE t.ticket_numero = Maestra.TICKET_NUMERO
				AND t.ticket_tipo_comprobante = Maestra.TICKET_TIPO_COMPROBANTE AND t.ticket_caja_sucursal = (SELECT sucursal_id
				FROM PERSISTENTES.Sucursal s
				WHERE s.sucursal_nombre = Maestra.SUCURSAL_NOMBRE)
				AND t.ticket_total_ticket = Maestra.TICKET_TOTAL_TICKET
    )
		JOIN PERSISTENTES.Promocion nueva_promo_promocion_t ON nueva_promo_promocion_t.promo_codigo = maestra.PROMO_CODIGO
	WHERE Maestra.TICKET_NUMERO IS NOT NULL AND Maestra.TICKET_DET_PRECIO IS NOT NULL AND Maestra.TICKET_DET_TOTAL IS NOT NULL AND Maestra.PROMO_APLICADA_DESCUENTO IS NOT NULL
	) AS PromoAplicada

-- Migrar datos de la tabla Maestra a PromocionPorProducto
INSERT INTO PERSISTENTES.PromocionPorProducto
	(promo_codigo,producto_id)
SELECT DISTINCT nueva_promo_codigo, nueva_producto_id
FROM (
		SELECT nueva_promo_t.promo_codigo AS nueva_promo_codigo,
		nueva_producto_t.producto_id AS nueva_producto_id
	FROM [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Promocion nueva_promo_t ON nueva_promo_t.promo_codigo = maestra.PROMO_CODIGO
		LEFT JOIN PERSISTENTES.Producto nueva_producto_t ON nueva_producto_t.producto_nombre = maestra.PRODUCTO_NOMBRE AND
			nueva_producto_t.producto_marca_id = (SELECT marca_id
			FROM PERSISTENTES.Marca
			WHERE marca_nombre = maestra.PRODUCTO_MARCA) AND
			nueva_producto_t.producto_precio = maestra.PRODUCTO_PRECIO
	WHERE maestra.PRODUCTO_NOMBRE IS NOT NULL AND maestra.PROMO_CODIGO IS NOT NULL
	) AS PromocionPorProducto
GO


--------EJECUCION
EXECUTE crear_tablas;

EXECUTE migrar_datos;
