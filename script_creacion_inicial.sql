use GD1C2024
go

CREATE SCHEMA PERSISTENTES
go


--CREACION DE TABLAS
CREATE PROCEDURE crear_tablas
as
-- Crear tabla Provincia
CREATE TABLE PERSISTENTES.Provincia
(
	provincia_id int IDENTITY,
	provincia_nombre nvarchar(255),
	CONSTRAINT PK_Provincia PRIMARY KEY (provincia_id)
)

-- Crear tabla Localidad
CREATE TABLE PERSISTENTES.Localidad
(
	localidad_id int IDENTITY,
	localidad_provincia int,
	localidad_nombre nvarchar(255)

		CONSTRAINT PK_Localidad PRIMARY KEY (localidad_id)
)

-- Crear referencia de Localidad a Provincia
ALTER TABLE PERSISTENTES.Localidad
		add constraint FK_LocalidadProvincia
		foreign key (localidad_provincia) REFERENCES PERSISTENTES.Provincia

-- Crear tabla CondicionFiscal
CREATE TABLE PERSISTENTES.CondicionFiscal
(
	condicion_fiscal nvarchar(255) not null
		CONSTRAINT PK_CondicionFiscal PRIMARY KEY (condicion_fiscal)
)

-- Crear tabla Super
CREATE TABLE PERSISTENTES.Super
(
	super_nro int IDENTITY,
	super_localidad_id int,
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
		add constraint FK_SuperLocalidad
		foreign key (super_localidad_id) REFERENCES PERSISTENTES.Localidad

-- Crear referencia de Super a CondicionFiscal
ALTER TABLE PERSISTENTES.Super
		add constraint FK_SuperCondicionFiscal
		foreign key (super_condicion_fiscal_id) references PERSISTENTES.CondicionFiscal

-- Crear tabla Sucursal
CREATE TABLE PERSISTENTES.Sucursal
(
	sucursal_id int IDENTITY,
	sucursal_localidad_id int,
	sucursal_super int,
	sucursal_nombre nvarchar(255),
	sucursal_direccion nvarchar(255)

		CONSTRAINT PK_Sucursal PRIMARY KEY (sucursal_id)
)

-- Crear referencia de Sucursal a Localidad
ALTER TABLE PERSISTENTES.Sucursal
		add constraint FK_SucursalLocalidad
		foreign key (sucursal_localidad_id) REFERENCES PERSISTENTES.Localidad

-- Crear referencia de Sucursal a Super
ALTER TABLE PERSISTENTES.Sucursal
		add constraint FK_SucursalSuper
		foreign key (sucursal_super) REFERENCES PERSISTENTES.Super

-- Crear tabla TipoCaja
CREATE TABLE PERSISTENTES.TipoCaja
(
	tipo_caja nvarchar(255) not null

		CONSTRAINT PK_TipoCaja PRIMARY KEY (tipo_caja)
)

-- Crear tabla Caja
CREATE TABLE PERSISTENTES.Caja
(
	caja_nro decimal(18,0) not null,
	caja_sucursal int,
	caja_tipo nvarchar(255)

		CONSTRAINT PK_Caja PRIMARY KEY (caja_nro, caja_sucursal)
)

-- Crear referencia de Caja a Sucursal
ALTER TABLE PERSISTENTES.Caja
		add constraint FK_CajaSucursal
		foreign key (caja_sucursal) REFERENCES PERSISTENTES.Sucursal

-- Crear referencia de Caja a TipoCaja
ALTER TABLE PERSISTENTES.Caja
		add constraint FK_CajaTipo
		foreign key (caja_tipo) REFERENCES PERSISTENTES.TipoCaja

-- Crear tabla Empleado
CREATE TABLE PERSISTENTES.Empleado
(
	legajo_empleado int IDENTITY,
	empleado_sucursal int,
	empleado_nombre nvarchar(255),
	empleado_apellido nvarchar(255),
	empleado_fecha_registro datetime,
	empleado_telefono decimal(18,0),
	empleado_mail nvarchar(255),
	empleado_fecha_nacimiento date,
	empleado_dni decimal(18,0)

		CONSTRAINT PK_Empleado PRIMARY KEY (legajo_empleado)
)

-- Crear referencia de Empleado a Sucursal
ALTER TABLE PERSISTENTES.Empleado
		add constraint FK_EmpleadoSucursal
		foreign key (empleado_sucursal) REFERENCES PERSISTENTES.Sucursal

-- Crear tabla Cliente
CREATE TABLE PERSISTENTES.Cliente
(
	cliente_id int IDENTITY,
	cliente_nombre nvarchar(255),
	cliente_apellido nvarchar(255),
	cliente_dni decimal(18,0),
	cliente_fecha_registro datetime,
	cliente_telefono decimal(18,0),
	cliente_mail nvarchar(255),
	cliente_fecha_nacimiento date,
	cliente_domicilio nvarchar(255),
	cliente_localidad_id int

		CONSTRAINT PK_Cliente PRIMARY KEY (cliente_id)
)

-- Crear referencia de Cliente a Localidad
ALTER TABLE PERSISTENTES.Cliente
		add constraint FK_ClienteLocalidad
		foreign key (cliente_localidad_id) REFERENCES PERSISTENTES.Localidad

-- Crear tabla TipoComprobante
create table PERSISTENTES.TipoComprobante
(
	tipo_comprobante nvarchar(255) not null

		constraint PK_TipoComprobante PRIMARY KEY (tipo_comprobante)
)

-- Crear tabla Ticket
create table PERSISTENTES.Ticket
(
	ticket_id int IDENTITY,
	ticket_numero decimal(18,0),
	ticket_caja_nro decimal(18,0),
	ticket_caja_sucursal int,
	ticket_tipo_comprobante nvarchar(255),
	ticket_empleado int,
	ticket_fecha_hora datetime,
	ticket_subtotal_productos decimal(18,2),
	ticket_total_descuento decimal(18,2),
	ticket_total_descuento_aplicado_mp decimal(18,2),
	ticket_total_envio decimal(18,2),
	ticket_total_ticket decimal(18,2)

		constraint PK_Ticket PRIMARY KEY (ticket_id)
)

-- Crear referencia de Ticket a Caja
alter table PERSISTENTES.Ticket
		add constraint FK_TicketCaja
		foreign key (ticket_caja_nro, ticket_caja_sucursal) references PERSISTENTES.Caja(caja_nro, caja_sucursal)

-- Crear referencia de Ticket a TipoComprobante
alter table PERSISTENTES.Ticket
		add constraint FK_TicketTipoComprobante
		foreign key (ticket_tipo_comprobante) references PERSISTENTES.TipoComprobante

-- Crear referencia de Ticket a Empleado
alter table PERSISTENTES.Ticket
		add constraint FK_TicketEmpleado
		foreign key (ticket_empleado) references PERSISTENTES.Empleado

-- Crear tabla EnvioEstado
create table PERSISTENTES.EnvioEstado
(
	envio_estado nvarchar(255) not null

		constraint PK_EnvioEstado PRIMARY KEY (envio_estado)
)

-- Crear tabla Envio
create table PERSISTENTES.Envio
(
	envio_id int IDENTITY,
	envio_cliente int,
	envio_ticket int,
	envio_fecha_programada datetime,
	envio_hora_inicio decimal(18,0),
	envio_hora_fin decimal(18,0),
	envio_fecha_entrega datetime,
	envio_costo decimal(18,2),
	envio_estado nvarchar(255)

		constraint PK_Envio PRIMARY KEY (envio_id)
)

-- Crear referencia de Envio a Cliente
alter table PERSISTENTES.Envio
		add constraint FK_EnvioCliente
		foreign key (envio_cliente) references PERSISTENTES.Cliente

-- Crear referencia de Envio a Ticket
alter table PERSISTENTES.Envio
		add constraint FK_EnvioTicket
		foreign key (envio_ticket) references PERSISTENTES.Ticket

-- Crear referencia de Envio a EnvioEstado
alter table PERSISTENTES.Envio
		add constraint FK_EnvioEstado
		foreign key (envio_estado) references PERSISTENTES.EnvioEstado

-- Crear tabla TipoMedioDePago
create table PERSISTENTES.TipoMedioDePago
(
	tipo_medio_de_pago nvarchar(255) not null

		constraint PK_TipoMedioDePago PRIMARY KEY (tipo_medio_de_pago)
)

-- Crear tabla MedioDePago
create table PERSISTENTES.MedioDePago
(
	medio_de_pago nvarchar(255) not null,
	medio_de_pago_tipo nvarchar(255)

		constraint PK_MedioDePago PRIMARY KEY (medio_de_pago)
)

-- Crear referencia de MedioDePago a TipoMedioDePago
alter table PERSISTENTES.MedioDePago
		add constraint FK_MedioDePagoTipo
		foreign key (medio_de_pago_tipo) references PERSISTENTES.TipoMedioDePago

-- Crear tabla Descuento
create table PERSISTENTES.Descuento
(
	descuento_codigo decimal(18,0) not null,
	descuento_descripcion nvarchar(255),
	descuento_fecha_inicio datetime,
	descuento_fecha_fin datetime,
	descuento_porcentaje decimal(18,2),
	descuento_tope decimal(18,2)

		constraint PK_Descuento PRIMARY KEY (descuento_codigo)
)

-- Crear tabla Pago
create table PERSISTENTES.Pago
(
	pago_id int IDENTITY,
	pago_fecha datetime,
	pago_importe decimal(18,2),
	pago_medio_pago nvarchar(255),
	pago_ticket int,

	constraint PK_Pago PRIMARY KEY (pago_id)
)

-- Crear referencia de Pago a MedioDePago
alter table PERSISTENTES.Pago
		add constraint FK_PagoMedioDePago
		foreign key (pago_medio_pago) references PERSISTENTES.MedioDePago

-- Crear referencia de Pago a Ticket
alter table PERSISTENTES.Pago
		add constraint FK_PagoTicket
		foreign key (pago_ticket) references PERSISTENTES.Ticket

-- Crear tabla DetallePagoTarjeta
create table PERSISTENTES.DetallePagoTarjeta
(
	detalle_pago_tarjeta_nro nvarchar(50),
	detalle_pago_tarjeta_cuotas decimal(18,0),
	detalle_pago_tarjeta_fecha_vencimiento datetime,
	detalle_pago_cliente int,
	detalle_pago_id int,

	constraint PK_DetallePago PRIMARY KEY (detalle_pago_id)
)

-- Crear referencia de DetallePagoTarjeta a Cliente
alter table PERSISTENTES.DetallePagoTarjeta
		add constraint FK_DetallePagoTarjetaCliente
		foreign key (detalle_pago_cliente) references PERSISTENTES.Cliente

-- Crear referencia de DetallePagoTarjeta a Pago
alter table PERSISTENTES.DetallePagoTarjeta
		add constraint FK_DetallePagoTarjetaPago
		foreign key (detalle_pago_id) references PERSISTENTES.Pago

-- Crear tabla Categoria
create table PERSISTENTES.DescuentoAplicado
(
	descuento_aplicado_descuento decimal(18,0) not null,
	descuento_aplicado_pago int not null,
	descuento_aplicado_cant decimal(18,2)

		constraint PK_DescuentoAplicado primary key (descuento_aplicado_descuento, descuento_aplicado_pago)
)

-- Crear referencia de DescuentoAplicado a Descuento
alter table PERSISTENTES.DescuentoAplicado
		add constraint FK_DescuentoAplicadoDescuento
		foreign key (descuento_aplicado_descuento) references PERSISTENTES.Descuento

-- Crear referencia de DescuentoAplicado a Pago
alter table PERSISTENTES.DescuentoAplicado
		add constraint FK_DescuentoAplicadoPago
		foreign key (descuento_aplicado_pago) references PERSISTENTES.Pago

-- Crear tabla Marca
create table PERSISTENTES.Marca
(
	marca_id int IDENTITY,
	marca_nombre nvarchar(255)

		constraint PK_Marca PRIMARY KEY (marca_id)
)

-- Crear tabla Categoria
create table PERSISTENTES.Categoria
(
	categoria_id int IDENTITY,
	categoria_nombre nvarchar(255),
	categoria_madre int null

		constraint PK_Categoria PRIMARY KEY (categoria_id)
)

-- Crear referencia de Categoria a Categoria (subcategorias)
alter table PERSISTENTES.Categoria
		add constraint FK_Categoria
		foreign key (categoria_madre) references PERSISTENTES.Categoria

-- Crear tabla Producto
create table PERSISTENTES.Producto
(
	producto_id int IDENTITY,
	producto_nombre nvarchar(255),
	producto_marca_id int,
	producto_descripcion nvarchar(255),
	producto_precio decimal(18,2),
	producto_categoria int

		constraint PK_Producto PRIMARY KEY (producto_id)
)

-- Crear referencia de Producto a Marca
alter table PERSISTENTES.Producto
		add constraint FK_ProductoMarca
		foreign key (producto_marca_id) references PERSISTENTES.Marca

-- Crear referencia de Producto a Categoria
alter table PERSISTENTES.Producto
	add constraint FK_ProductoCategoria
	foreign key (producto_categoria) references PERSISTENTES.Categoria

-- Crear tabla TicketDetalle
create table PERSISTENTES.TicketDetalle
(
	ticket_det_id int IDENTITY,
	ticket_det_ticket int,
	ticket_det_producto int,
	ticket_det_cantidad decimal(18,0),
	ticket_det_total decimal(18,2),
	ticket_det_precio decimal(18,2)

		constraint PK_TicketDetalle PRIMARY KEY (ticket_det_id)
)

-- Crear referencia de TicketDetalle a Ticket
alter table PERSISTENTES.TicketDetalle
		add constraint FK_ticketDetalleTicket
		foreign key (ticket_det_ticket) references PERSISTENTES.Ticket

-- Crear referencia de TicketDetalle a Producto
alter table PERSISTENTES.TicketDetalle
		add constraint FK_TicketDetalleProducto
		foreign key (ticket_det_producto) references PERSISTENTES.Producto

-- Crear tabla DescuentoAplicado
create table PERSISTENTES.Promocion
(
	promo_codigo decimal(18,0) not null,
	--	promo_aplicada_id int,
	promocion_descripcion nvarchar(255),
	promocion_fecha_inicio datetime,
	promocion_fecha_fin datetime

		constraint PK_Promocion PRIMARY KEY (promo_codigo)
)

-- Crear tabla PromoAplicada
create table PERSISTENTES.PromoAplicada
(
	promo_aplicada_id int IDENTITY,
	promo_aplicada_ticketDet int,
	promo_aplicada_descuento decimal(18,2),
	promo_promocion decimal(18,0)

		constraint PK_PromoAplicada PRIMARY KEY (promo_aplicada_id)
)

-- Crear referencia de PromoAplicada a TicketDetalle
alter table PERSISTENTES.PromoAplicada
		add constraint FK_PromoAplicadaTicketDet
		foreign key (promo_aplicada_ticketDet) references PERSISTENTES.TicketDetalle

-- Crear referencia de PromoAplicada a Promocion
alter table PERSISTENTES.PromoAplicada
		add constraint FK_PromoAplicadaPromocion
		foreign key (promo_promocion) references PERSISTENTES.Promocion

-- Crear tabla Regla
create table PERSISTENTES.Regla
(
	regla_id int IDENTITY,
	regla_promocion decimal(18,0),
	regla_aplica_misma_marca decimal(18,0),
	regla_aplica_mismo_prod decimal(18,0),
	regla_cant_aplica_descuento decimal(18,0),
	regla_cant_aplicable_regla decimal(18,0),
	regla_cant_max_prod decimal(18,0),
	regla_descripcion nvarchar(255),
	regla_descuento_aplicable_prod decimal(18,2)

		constraint PK_Regla PRIMARY KEY (regla_id)
)

-- Crear referencia de Regla a Promocion
alter table PERSISTENTES.Regla
		add constraint FK_ReglaPromocion
		foreign key (regla_promocion) references PERSISTENTES.Promocion

-- Crear tabla DescuentoAplicado
create table PERSISTENTES.PromocionPorProducto
(
	promo_codigo decimal(18,0) not null,
	producto_id int not null

		constraint PK_PromocionPorProducto PRIMARY KEY (promo_codigo, producto_id)
)

-- Crear referencia de PromocionPorProducto a Promocion
alter table PERSISTENTES.PromocionPorProducto
		add constraint FK_PromocionPorProductoPromo 
		foreign key (promo_codigo) references PERSISTENTES.Promocion

-- Crear referencia de PromocionPorProducto a Producto
alter table PERSISTENTES.PromocionPorProducto
		add constraint FK_PromocionPorProductoProd 
		foreign key (producto_id) references PERSISTENTES.Producto

-- Crear tabla SubcategoriaCategoria
CREATE TABLE PERSISTENTES.SubcategoriaCategoria
(
	PRODUCTO_SUB_CATEGORIA NVARCHAR(255),
	PRODUCTO_CATEGORIA NVARCHAR(255)
)
go

-------MIGRACION DE TABLAS
CREATE PROCEDURE migrar_datos
AS
-- Migrar datos de la tabla Maestra a Provincia
INSERT INTO PERSISTENTES.Provincia
	(provincia_nombre)
select distinct provincia_nombre
from (
														SELECT DISTINCT SUPER_PROVINCIA as provincia_nombre
		FROM [GD1C2024].[gd_esquema].[Maestra]
		WHERE SUPER_PROVINCIA IS NOT NULL
	union
		SELECT DISTINCT CLIENTE_PROVINCIA as provincia_nombre
		FROM [GD1C2024].[gd_esquema].[Maestra]
		where CLIENTE_PROVINCIA is not null
	union
		select DISTINCT SUCURSAL_PROVINCIA as provincia_nombre
		FROM [GD1C2024].[gd_esquema].[Maestra]
		where SUCURSAL_PROVINCIA is not null
	) as Provincia


-- Migrar datos de la tabla Maestra a Localidad
INSERT INTO PERSISTENTES.Localidad
	(localidad_nombre, localidad_provincia)
SELECT DISTINCT maestra_localidad_nombre, nueva_provincia_id
FROM (
														SELECT maestra.SUCURSAL_LOCALIDAD AS maestra_localidad_nombre, nueva_provincia_t.provincia_id nueva_provincia_id
		FROM GD1C2024.gd_esquema.Maestra maestra LEFT JOIN PERSISTENTES.Provincia nueva_provincia_t on nueva_provincia_t.provincia_nombre = maestra.SUCURSAL_PROVINCIA
		WHERE SUCURSAL_LOCALIDAD IS NOT NULL
	UNION
		SELECT maestra.SUPER_LOCALIDAD AS maestra_localidad_nombre, nueva_provincia_t.provincia_id nueva_provincia_id
		FROM GD1C2024.gd_esquema.Maestra maestra LEFT JOIN PERSISTENTES.Provincia nueva_provincia_t on nueva_provincia_t.provincia_nombre = maestra.SUPER_PROVINCIA
		WHERE SUPER_LOCALIDAD IS NOT NULL
	UNION
		SELECT maestra.CLIENTE_LOCALIDAD AS maestra_localidad_nombre, nueva_provincia_t.provincia_id nueva_provincia_id
		FROM GD1C2024.gd_esquema.Maestra maestra LEFT JOIN PERSISTENTES.Provincia nueva_provincia_t on nueva_provincia_t.provincia_nombre = maestra.CLIENTE_PROVINCIA
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
select distinct TICKET_TIPO_COMPROBANTE
FROM [GD1C2024].[gd_esquema].[Maestra]
WHERE TICKET_TIPO_COMPROBANTE IS NOT NULL

-- Migrar datos de la tabla Maestra a CondicionFiscal
INSERT INTO PERSISTENTES.CondicionFiscal
select distinct SUPER_CONDICION_FISCAL
from [GD1C2024].[gd_esquema].[Maestra]
WHERE SUPER_CONDICION_FISCAL IS NOT NULL

-- Migrar datos de la tabla Maestra a Marca
INSERT INTO PERSISTENTES.Marca
select distinct PRODUCTO_MARCA
from [GD1C2024].[gd_esquema].[Maestra]
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
		on nueva_tipo_medio_de_pago_t.tipo_medio_de_pago = maestra.PAGO_TIPO_MEDIO_PAGO
	WHERE PAGO_MEDIO_PAGO IS NOT NULL 
		) AS MedioDePago;


-- Migrar datos de la tabla Maestra a Descuento
INSERT INTO PERSISTENTES.Descuento
	(descuento_codigo, descuento_descripcion, descuento_fecha_inicio, descuento_fecha_fin, descuento_porcentaje, descuento_tope)
select distinct DESCUENTO_CODIGO, DESCUENTO_DESCRIPCION, DESCUENTO_FECHA_FIN, DESCUENTO_FECHA_INICIO, DESCUENTO_PORCENTAJE_DESC, DESCUENTO_TOPE
from [GD1C2024].[gd_esquema].[Maestra]
where DESCUENTO_CODIGO is not null

-- Migrar datos de la tabla Maestra a Super
INSERT INTO PERSISTENTES.Super
	(super_nombre, super_razon_soc, super_cuit, super_iibb, super_domicilio, super_fecha_ini_actividad, super_condicion_fiscal_id, super_localidad_id)
select distinct maestra_super_nombre, maestra_super_razon_soc, maestra_super_cuit, maestra_super_iibb, maestra_super_domicilio, maestra_super_fecha_ini_actividad, nueva_condicion_fiscal, nueva_localidad_id
from (
		SELECT maestra.SUPER_NOMBRE as maestra_super_nombre,
		maestra.SUPER_RAZON_SOC as maestra_super_razon_soc,
		maestra.SUPER_CUIT as maestra_super_cuit,
		maestra.SUPER_IIBB as maestra_super_iibb,
		maestra.SUPER_DOMICILIO as maestra_super_domicilio,
		maestra.SUPER_FECHA_INI_ACTIVIDAD as maestra_super_fecha_ini_actividad,
		nueva_condicion_fiscal_t.condicion_fiscal nueva_condicion_fiscal,
		nueva_Localidad_t.localidad_id nueva_localidad_id
	from [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.CondicionFiscal nueva_condicion_fiscal_t on nueva_condicion_fiscal_t.condicion_fiscal = maestra.SUPER_CONDICION_FISCAL
		LEFT JOIN PERSISTENTES.Localidad nueva_Localidad_t on nueva_Localidad_t.localidad_nombre = maestra.SUPER_LOCALIDAD
	WHERE SUPER_NOMBRE is not null
	) AS Super

-- Migrar datos de la tabla Maestra a Sucursal
INSERT INTO PERSISTENTES.Sucursal
	(sucursal_nombre, sucursal_direccion, sucursal_localidad_id, sucursal_super)
select distinct maestra_sucursal_nombre, maestra_sucursal_direccion, nueva_localidad_id, nueva_super_id
from (
		SELECT maestra.SUCURSAL_NOMBRE as maestra_sucursal_nombre,
		maestra.SUCURSAL_DIRECCION as maestra_sucursal_direccion,
		nueva_Localidad_t.localidad_id nueva_localidad_id,
		nueva_Super_t.super_nro nueva_super_id
	from [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Localidad nueva_Localidad_t on nueva_Localidad_t.localidad_nombre = maestra.SUCURSAL_LOCALIDAD
		LEFT JOIN PERSISTENTES.Super nueva_Super_t on nueva_Super_t.super_nombre = maestra.SUPER_NOMBRE
	WHERE SUCURSAL_NOMBRE IS NOT NULL
	) as Sucursal

-- Migrar datos de la tabla Maestra a Caja
INSERT INTO PERSISTENTES.Caja
	(caja_nro, caja_sucursal, caja_tipo)
select distinct maestra_caja_nro, nueva_sucursal_id, nueva_caja_tipo_id
from (
        select maestra.CAJA_NUMERO as maestra_caja_nro,
		nueva_Sucursal_t.sucursal_id nueva_sucursal_id,
		nueva_CajaTipo_t.tipo_caja nueva_caja_tipo_id
	from [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Sucursal nueva_Sucursal_t on nueva_Sucursal_t.sucursal_nombre = maestra.SUCURSAL_NOMBRE
		LEFT JOIN PERSISTENTES.TipoCaja nueva_CajaTipo_t on nueva_CajaTipo_t.tipo_caja = maestra.CAJA_TIPO
	where CAJA_NUMERO is not null or CAJA_TIPO is not null
    ) as Caja

--Migrar datos de la tabla Maestra a Empleado
INSERT INTO PERSISTENTES.Empleado
	(empleado_nombre, empleado_apellido, empleado_fecha_registro, empleado_telefono, empleado_mail, empleado_fecha_nacimiento, empleado_dni, empleado_sucursal)
select distinct maestra_empleado_nombre, maestra_empleado_apellido, maestra_empleado_fecha_registro, maestra_empleado_telefono, maestra_empleado_mail, maestra_empleado_fecha_nacimiento,
	maestra_empleado_dni, nueva_sucursal_id
from (
			select maestra.EMPLEADO_NOMBRE as maestra_empleado_nombre,
		maestra.EMPLEADO_APELLIDO as maestra_empleado_apellido,
		maestra.EMPLEADO_FECHA_REGISTRO as maestra_empleado_fecha_registro,
		maestra.EMPLEADO_TELEFONO as maestra_empleado_telefono,
		maestra.EMPLEADO_MAIL as maestra_empleado_mail,
		maestra.empleado_fecha_nacimiento as maestra_empleado_fecha_nacimiento,
		maestra.EMPLEADO_DNI as maestra_empleado_dni,
		nueva_Sucursal_t.sucursal_id nueva_sucursal_id
	from [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Sucursal nueva_Sucursal_t on nueva_Sucursal_t.sucursal_nombre = maestra.SUCURSAL_NOMBRE
	where EMPLEADO_NOMBRE is not null
		) as Empleado

-- Migrar datos de la tabla Maestra a Ticket
INSERT INTO PERSISTENTES.Ticket
	(ticket_numero, ticket_fecha_hora, ticket_subtotal_productos, ticket_total_descuento, ticket_total_descuento_aplicado_mp, ticket_total_envio,
	ticket_total_ticket, ticket_caja_nro, ticket_caja_sucursal, ticket_empleado, ticket_tipo_comprobante)
SELECT distinct maestra_ticket_numero, maestra_ticket_fecha_hora, maestra_ticket_subtotal_productos, maestra_ticket_total_descuento, maestra_ticket_total_descuento_aplicado_mp,
	maestra_ticket_total_envio, maestra_ticket_total_ticket, nueva_ticket_caja_nro, nueva_ticket_caja_sucursal, nueva_ticket_empleado, nueva_ticket_tipo_comprobante
from (
		select maestra.TICKET_NUMERO as maestra_ticket_numero,
		maestra.TICKET_FECHA_HORA as maestra_ticket_fecha_hora,
		maestra.TICKET_SUBTOTAL_PRODUCTOS as maestra_ticket_subtotal_productos,
		maestra.TICKET_TOTAL_DESCUENTO_APLICADO as maestra_ticket_total_descuento,
		maestra.TICKET_TOTAL_DESCUENTO_APLICADO_MP as maestra_ticket_total_descuento_aplicado_mp,
		maestra.TICKET_TOTAL_ENVIO as maestra_ticket_total_envio,
		maestra.TICKET_TOTAL_TICKET as maestra_ticket_total_ticket,
		nueva_Caja_t.caja_nro as nueva_ticket_caja_nro,
		nueva_Caja_t.caja_sucursal as nueva_ticket_caja_sucursal,
		nueva_Empleado_t.legajo_empleado as nueva_ticket_empleado,
		nueva_TipoComprobate_t.tipo_comprobante as nueva_ticket_tipo_comprobante
	from [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Empleado nueva_Empleado_t on nueva_Empleado_t.empleado_dni = maestra.EMPLEADO_DNI
		LEFT JOIN PERSISTENTES.TipoComprobante nueva_TipoComprobate_t on nueva_TipoComprobate_t.tipo_comprobante = maestra.TICKET_TIPO_COMPROBANTE
		LEFT JOIN PERSISTENTES.Caja nueva_caja_t on nueva_Caja_t.caja_nro = maestra.CAJA_NUMERO and nueva_Caja_t.caja_sucursal = (
			select sucursal_id
			from PERSISTENTES.Sucursal
			where sucursal_nombre = maestra.SUCURSAL_NOMBRE
		)
	where maestra.TICKET_NUMERO is not null and maestra.EMPLEADO_DNI is not null
	) as Ticket

-- Migrar datos de la tabla Maestra a Pago
INSERT INTO PERSISTENTES.Pago
	(pago_fecha, pago_importe, pago_medio_pago, pago_ticket)
SELECT DISTINCT maestra_pago_fecha, maestra_pago_importe, nueva_pago_medio_pago, nueva_pago_ticket
from (
	select maestra.PAGO_FECHA as maestra_pago_fecha,
		maestra.PAGO_IMPORTE as maestra_pago_importe,
		nueva_MedioDePago_t.medio_de_pago nueva_pago_medio_pago,
		nueva_Ticket_t.ticket_id as nueva_pago_ticket
	from [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Ticket nueva_Ticket_t on nueva_Ticket_t.ticket_numero = maestra.TICKET_NUMERO and
			nueva_Ticket_t.ticket_tipo_comprobante = maestra.TICKET_TIPO_COMPROBANTE and
			nueva_Ticket_t.ticket_caja_sucursal = (select sucursal_id
			from PERSISTENTES.Sucursal
			where sucursal_nombre = maestra.SUCURSAL_NOMBRE)
			and nueva_ticket_t.ticket_total_ticket = maestra.PAGO_IMPORTE
		LEFT JOIN PERSISTENTES.MedioDePago nueva_MedioDePago_t on nueva_MedioDePago_t.medio_de_pago = maestra.PAGO_MEDIO_PAGO
	where maestra.PAGO_FECHA is not null and maestra.PAGO_IMPORTE is not null and maestra.PAGO_MEDIO_PAGO is not null and maestra.TICKET_NUMERO is not null
) as Pago

--Migrar datos de la tabla Maestra a DetallePagoTarjeta
INSERT INTO PERSISTENTES.DetallePagoTarjeta
	(detalle_pago_id, detalle_pago_tarjeta_cuotas, detalle_pago_tarjeta_nro, detalle_pago_tarjeta_fecha_vencimiento, detalle_pago_cliente)
SELECT distinct nueva_pago_id, maestra_detalle_pago_tarjeta_cuotas, maestra_detalle_pago_tarjeta_nro, nueva_detalle_pago_tarjeta_fecha_vencimiento, nueva_detalle_pago_cliente
FROM (
		SELECT nueva_Pago_t.pago_id as nueva_pago_id,
		maestra.PAGO_TARJETA_CUOTAS as maestra_detalle_pago_tarjeta_cuotas,
		maestra.PAGO_TARJETA_NRO as maestra_detalle_pago_tarjeta_nro,
		maestra.PAGO_TARJETA_FECHA_VENC as nueva_detalle_pago_tarjeta_fecha_vencimiento,
		nueva_Cliente_t.cliente_id as nueva_detalle_pago_cliente
	FROM [GD1C2024].[gd_esquema].[Maestra] maestra
		LEFT JOIN PERSISTENTES.Pago nueva_Pago_t on nueva_Pago_t.pago_fecha = maestra.PAGO_FECHA and nueva_Pago_t.pago_importe = maestra.PAGO_IMPORTE and nueva_Pago_t.pago_medio_pago = maestra.PAGO_MEDIO_PAGO
		LEFT JOIN PERSISTENTES.Ticket nueva_Ticket_t on nueva_Ticket_t.ticket_id = nueva_Pago_t.pago_ticket
		LEFT JOIN PERSISTENTES.Envio nueva_Envio_t on nueva_Envio_t.envio_ticket = nueva_Ticket_t.ticket_id
		LEFT JOIN PERSISTENTES.Cliente nueva_Cliente_t on nueva_Envio_t.envio_ticket = nueva_Cliente_t.cliente_id
	WHERE maestra.PAGO_TARJETA_CUOTAS IS NOT NULL AND maestra.PAGO_TARJETA_NRO IS NOT NULL AND maestra.PAGO_TARJETA_FECHA_VENC IS NOT NULL
	) as DetallePagoTarjeta

-- Migrar datos de la tabla Maestra a Cliente
INSERT into PERSISTENTES.Cliente
	(cliente_nombre, cliente_apellido, cliente_dni, cliente_fecha_registro, cliente_telefono, cliente_mail,cliente_fecha_nacimiento, cliente_domicilio, cliente_localidad_id)
SELECT distinct maestra_cliente_nombre, maestra_cliente_apellido, maestra_cliente_dni, maestra_cliente_fecha_registro, maestra_cliente_telefono, maestra_cliente_mail, maestra_cliente_fecha_nacimiento,
	maestra_cliente_domicilio, nueva_localidad_id
from (
		select maestra.CLIENTE_NOMBRE as maestra_cliente_nombre,
		maestra.CLIENTE_APELLIDO as maestra_cliente_apellido,
		maestra.CLIENTE_DNI as maestra_cliente_dni,
		maestra.CLIENTE_FECHA_REGISTRO as maestra_cliente_fecha_registro,
		maestra.CLIENTE_TELEFONO as maestra_cliente_telefono,
		maestra.CLIENTE_MAIL as maestra_cliente_mail,
		maestra.CLIENTE_FECHA_NACIMIENTO as maestra_cliente_fecha_nacimiento,
		maestra.CLIENTE_DOMICILIO as maestra_cliente_domicilio,
		nueva_localidad_t.localidad_id as nueva_localidad_id
	from [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Localidad nueva_localidad_t on nueva_localidad_t.localidad_nombre = maestra.CLIENTE_LOCALIDAD and nueva_localidad_t.localidad_provincia = (
			select provincia_id
			from PERSISTENTES.Provincia
			where provincia_nombre = maestra.CLIENTE_PROVINCIA
		)
	where maestra.CLIENTE_DNI is not null
	) as Cliente

-- Migrar datos de la tabla Maestra a DescuentoAplicado
INSERT INTO PERSISTENTES.DescuentoAplicado
	(
	descuento_aplicado_descuento,
	descuento_aplicado_pago,
	descuento_aplicado_cant)
select distinct
	maestra_descuento_aplicado_descuento,
	maestra_descuento_aplicado_pago,
	maestra_descuento_aplicado_cant
from (
		select
		nuevo_descuento.descuento_codigo as maestra_descuento_aplicado_descuento,
		nuevo_pago.pago_id as maestra_descuento_aplicado_pago,
		Maestra.PAGO_DESCUENTO_APLICADO as maestra_descuento_aplicado_cant
	from [GD1C2024].[gd_esquema].[Maestra]
		left join PERSISTENTES.Descuento nuevo_descuento on nuevo_descuento.descuento_codigo = Maestra.DESCUENTO_CODIGO
		left join PERSISTENTES.Pago nuevo_pago on nuevo_pago.pago_importe = Maestra.PAGO_IMPORTE
	where Maestra.DESCUENTO_CODIGO is not null and Maestra.PAGO_IMPORTE is not null
	) as DescuentoAplicado


-- Migrar datos de la tabla Maestra a Categoria
insert into PERSISTENTES.Categoria
	(categoria_nombre)
SELECT distinct PRODUCTO_CATEGORIA
from [GD1C2024].[gd_esquema].[Maestra]
where PRODUCTO_CATEGORIA is not null

-- Migrar datos de la tabla Maestra a SubcategoriaCategoria
INSERT INTO PERSISTENTES.SubcategoriaCategoria
	(PRODUCTO_SUB_CATEGORIA, PRODUCTO_CATEGORIA)
SELECT DISTINCT PRODUCTO_SUB_CATEGORIA, PRODUCTO_CATEGORIA
FROM (
	SELECT PRODUCTO_SUB_CATEGORIA, PRODUCTO_CATEGORIA, COUNT(*) as cantidad
	FROM [GD1C2024].[gd_esquema].[Maestra]
	WHERE PRODUCTO_SUB_CATEGORIA IS NOT NULL AND PRODUCTO_CATEGORIA IS NOT NULL
	GROUP BY PRODUCTO_SUB_CATEGORIA, PRODUCTO_CATEGORIA
	) as subConsulta
where cantidad = (
	select max(cantidad)
from (	select count(*) as cantidad
	from [GD1C2024].[gd_esquema].[Maestra]
	where PRODUCTO_SUB_CATEGORIA = subConsulta.PRODUCTO_SUB_CATEGORIA and PRODUCTO_CATEGORIA is not null
	group by PRODUCTO_CATEGORIA
			) as otraConsulta
	)

-- Migrar datos de la tabla Maestra a Categoria (subcategorias)
insert into PERSISTENTES.Categoria
	(categoria_nombre, categoria_madre)
select distinct PRODUCTO_SUB_CATEGORIA, c.categoria_id
from PERSISTENTES.SubcategoriaCategoria
	join PERSISTENTES.Categoria c on c.categoria_nombre = PRODUCTO_CATEGORIA

--Migrar datos de la tabla Maestra a Producto
INSERT INTO PERSISTENTES.Producto
	(producto_nombre, producto_descripcion, producto_precio, producto_marca_id, producto_categoria)
select distinct maestra_producto_nombre, maestra_producto_descripcion, maestra_producto_precio, nueva_producto_marca, nueva_producto_categoria
from (
		select maestra.PRODUCTO_NOMBRE as maestra_producto_nombre,
		maestra.PRODUCTO_DESCRIPCION as maestra_producto_descripcion,
		maestra.PRODUCTO_PRECIO as maestra_producto_precio,
		nueva_producto_marca_t.marca_id as nueva_producto_marca,
		nueva_producto_categoria_t.categoria_id as nueva_producto_categoria
	from [GD1C2024].[gd_esquema].[Maestra]
		left join PERSISTENTES.Marca nueva_producto_marca_t on nueva_producto_marca_t.marca_nombre = PRODUCTO_MARCA
		left join PERSISTENTES.Categoria nueva_producto_categoria_t on nueva_producto_categoria_t.categoria_nombre = maestra.PRODUCTO_SUB_CATEGORIA
	where PRODUCTO_NOMBRE is not null
	) as Producto

--Migrar datos de la tabla Maestra a TicketDetalle
INSERT INTO PERSISTENTES.TicketDetalle
	(ticket_det_ticket, ticket_det_producto, ticket_det_cantidad, ticket_det_total, ticket_det_precio)
SELECT distinct nueva_ticket_detalle_ticket, nueva_ticket_detalle_producto, maestra_ticket_detalle_cantidad, maestra_ticket_detalle_subtotal, maestra_ticket_detalle_precio_unitario
from (
		SELECT nueva_Ticket_t.ticket_id as nueva_ticket_detalle_ticket,
		nueva_Producto_t.producto_id as nueva_ticket_detalle_producto,
		maestra.TICKET_DET_CANTIDAD as maestra_ticket_detalle_cantidad,
		maestra.TICKET_DET_TOTAL as maestra_ticket_detalle_subtotal,
		maestra.TICKET_DET_PRECIO as maestra_ticket_detalle_precio_unitario
	from [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Ticket nueva_Ticket_t on nueva_Ticket_t.ticket_numero = maestra.TICKET_NUMERO and
			nueva_ticket_t.ticket_caja_sucursal = (select sucursal_id
			from PERSISTENTES.Sucursal
			where sucursal_nombre = maestra.SUCURSAL_NOMBRE) and
			nueva_ticket_t.ticket_tipo_comprobante = maestra.TICKET_TIPO_COMPROBANTE and
			nueva_ticket_t.ticket_total_ticket = Maestra.TICKET_TOTAL_TICKET
		LEFT JOIN PERSISTENTES.Producto nueva_Producto_t on nueva_Producto_t.producto_nombre = maestra.PRODUCTO_NOMBRE and
			nueva_Producto_t.producto_marca_id = (select marca_id
			from PERSISTENTES.Marca
			where marca_nombre = maestra.PRODUCTO_MARCA)
			and nueva_Producto_t.producto_precio = TICKET_DET_PRECIO
	where maestra.TICKET_NUMERO is not null and maestra.PRODUCTO_NOMBRE is not null
	) as TicketDetalle


--Migrar datos de la tabla Maestra a Envio
INSERT INTO PERSISTENTES.Envio
	(envio_costo, envio_fecha_programada, envio_hora_inicio, envio_hora_fin, envio_fecha_entrega, envio_cliente, envio_estado, envio_ticket)
select distinct maestra_envio_costo, maestra_envio_fecha_programada, maestra_envio_hora_inicio, maestra_envio_hora_fin, maestra_envio_fecha_entrega, nueva_envio_cliente_id,
	nueva_envio_estado, nueva_envio_ticket_id
from (
			select maestra.ENVIO_COSTO as maestra_envio_costo,
		maestra.ENVIO_FECHA_PROGRAMADA as maestra_envio_fecha_programada,
		maestra.ENVIO_HORA_INICIO as maestra_envio_hora_inicio,
		maestra.ENVIO_HORA_FIN as  maestra_envio_hora_fin,
		maestra.ENVIO_FECHA_ENTREGA as maestra_envio_fecha_entrega,
		nueva_envio_cliente_t.cliente_id as nueva_envio_cliente_id,
		nueva_envio_estado_t.envio_estado as nueva_envio_estado,
		nueva_envio_ticket_t.ticket_id as nueva_envio_ticket_id
	from [GD1C2024].[gd_esquema].[Maestra]
		LEFT JOIN PERSISTENTES.Cliente nueva_envio_cliente_t on nueva_envio_cliente_t.cliente_dni = maestra.CLIENTE_DNI
		LEFT JOIN PERSISTENTES.EnvioEstado nueva_envio_estado_t on nueva_envio_estado_t.envio_estado = maestra.ENVIO_ESTADO
		LEFT JOIN PERSISTENTES.Ticket nueva_envio_ticket_t on nueva_envio_ticket_t.ticket_numero = maestra.TICKET_NUMERO and nueva_envio_ticket_t.ticket_tipo_comprobante = maestra.TICKET_TIPO_COMPROBANTE
			and nueva_envio_ticket_t.ticket_caja_sucursal = (select sucursal_id
			from PERSISTENTES.Sucursal s
			where s.sucursal_nombre = maestra.SUCURSAL_NOMBRE)
			and nueva_envio_ticket_t.ticket_total_envio = Maestra.TICKET_TOTAL_ENVIO
	where maestra.ENVIO_COSTO is not null
		) as Envio

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
insert into PERSISTENTES.Regla
	(regla_aplica_misma_marca, regla_aplica_mismo_prod,regla_cant_aplica_descuento,regla_cant_aplicable_regla,regla_cant_max_prod,regla_descripcion,regla_descuento_aplicable_prod,regla_promocion)
select distinct
	maestra.REGLA_APLICA_MISMA_MARCA,
	maestra.REGLA_APLICA_MISMO_PROD,
	maestra.REGLA_CANT_APLICA_DESCUENTO,
	maestra.REGLA_CANT_APLICABLE_REGLA,
	maestra.REGLA_CANT_MAX_PROD,
	maestra.REGLA_DESCRIPCION,
	maestra.REGLA_DESCUENTO_APLICABLE_PROD,
	nueva_regla_promocion.promo_codigo
from [GD1C2024].[gd_esquema].[Maestra]
	join PERSISTENTES.Promocion nueva_regla_promocion on nueva_regla_promocion.promo_codigo = maestra.PROMO_CODIGO
where maestra.PROMO_CODIGO is not null

-- Migra datos de la tabla Maestra a PromoAplicada
INSERT INTO PERSISTENTES.PromoAplicada
	(promo_aplicada_ticketDet, promo_aplicada_descuento,promo_promocion)
select distinct nuevo_detalle_ticket_promo_aplicada_ticketDet, maestra_promo_aplicada_descuento, nueva_promo_promocion
from (
		SELECT nuevo_detalle_ticket.ticket_det_id AS nuevo_detalle_ticket_promo_aplicada_ticketDet,
		Maestra.PROMO_APLICADA_DESCUENTO AS maestra_promo_aplicada_descuento,
		nueva_promo_promocion_t.promo_codigo as nueva_promo_promocion
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
				AND t.ticket_tipo_comprobante = Maestra.TICKET_TIPO_COMPROBANTE and t.ticket_caja_sucursal = (SELECT sucursal_id
				FROM PERSISTENTES.Sucursal s
				WHERE s.sucursal_nombre = Maestra.SUCURSAL_NOMBRE)
				AND t.ticket_total_ticket = Maestra.TICKET_TOTAL_TICKET
    )
		join PERSISTENTES.Promocion nueva_promo_promocion_t on nueva_promo_promocion_t.promo_codigo = maestra.PROMO_CODIGO
	WHERE Maestra.TICKET_NUMERO IS NOT NULL AND Maestra.TICKET_DET_PRECIO IS NOT NULL AND Maestra.TICKET_DET_TOTAL IS NOT NULL AND Maestra.PROMO_APLICADA_DESCUENTO IS NOT NULL
	) as PromoAplicada

-- Migrar datos de la tabla Maestra a PromocionPorProducto
insert into PERSISTENTES.PromocionPorProducto
	(promo_codigo,producto_id)
select distinct nueva_promo_codigo, nueva_producto_id
from (
		select nueva_promo_t.promo_codigo as nueva_promo_codigo,
		nueva_producto_t.producto_id as nueva_producto_id
	from [GD1C2024].[gd_esquema].[Maestra]
		left join PERSISTENTES.Promocion nueva_promo_t on nueva_promo_t.promo_codigo = maestra.PROMO_CODIGO
		left join PERSISTENTES.Producto nueva_producto_t on nueva_producto_t.producto_nombre = maestra.PRODUCTO_NOMBRE and
			nueva_producto_t.producto_marca_id = (select marca_id
			from PERSISTENTES.Marca
			where marca_nombre = maestra.PRODUCTO_MARCA) and
			nueva_producto_t.producto_precio = maestra.PRODUCTO_PRECIO
	where maestra.PRODUCTO_NOMBRE is not null and maestra.PROMO_CODIGO is not null
	) as PromocionPorProducto
go


--------EJECUCION
execute crear_tablas;

execute migrar_datos;
