CREATE SCHEMA PERSISTENTES
go


--CREACION DE TABLAS
CREATE PROCEDURE crear_tablas
as
CREATE TABLE PERSISTENTES.Provincia
(
	provincia_id int IDENTITY,
	provincia_nombre nvarchar(255),
	CONSTRAINT PK_Provincia PRIMARY KEY (provincia_id)
)

CREATE TABLE PERSISTENTES.Localidad
(
	localidad_id int IDENTITY,
	localidad_provincia int,
	--hay que chequear las provincias de los clientes que estan vacias
	localidad_nombre nvarchar(255)

		CONSTRAINT PK_Localidad PRIMARY KEY (localidad_id)
)

ALTER TABLE PERSISTENTES.Localidad
		add constraint FK_LocalidadProvincia
		foreign key (localidad_provincia) REFERENCES PERSISTENTES.Provincia

CREATE TABLE PERSISTENTES.CondicionFiscal
(
	condicion_fiscal nvarchar(255) not null
		CONSTRAINT PK_CondicionFiscal PRIMARY KEY (condicion_fiscal)
)

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

ALTER TABLE PERSISTENTES.Super
		add constraint FK_SuperLocalidad
		foreign key (super_localidad_id) REFERENCES PERSISTENTES.Localidad

ALTER TABLE PERSISTENTES.Super
		add constraint FK_SuperCondicionFiscal
		foreign key (super_condicion_fiscal_id) references PERSISTENTES.CondicionFiscal

CREATE TABLE PERSISTENTES.Sucursal
(
	sucursal_id int IDENTITY,
	sucursal_localidad_id int,
	sucursal_super int,
	sucursal_nombre nvarchar(255),
	sucursal_direccion nvarchar(255)

		CONSTRAINT PK_Sucursal PRIMARY KEY (sucursal_id)
)

ALTER TABLE PERSISTENTES.Sucursal
		add constraint FK_SucursalLocalidad
		foreign key (sucursal_localidad_id) REFERENCES PERSISTENTES.Localidad

ALTER TABLE PERSISTENTES.Sucursal
		add constraint FK_SucursalSuper
		foreign key (sucursal_super) REFERENCES PERSISTENTES.Super

CREATE TABLE PERSISTENTES.TipoCaja
(
	tipo_caja nvarchar(255) not null

		CONSTRAINT PK_TipoCaja PRIMARY KEY (tipo_caja)
)

CREATE TABLE PERSISTENTES.Caja
(
	caja_nro decimal(18,0) not null,
	caja_sucursal int,
	caja_tipo nvarchar(255)

		CONSTRAINT PK_Caja PRIMARY KEY (caja_nro, caja_sucursal)
)

ALTER TABLE PERSISTENTES.Caja
		add constraint FK_CajaSucursal
		foreign key (caja_sucursal) REFERENCES PERSISTENTES.Sucursal

ALTER TABLE PERSISTENTES.Caja
		add constraint FK_CajaTipo
		foreign key (caja_tipo) REFERENCES PERSISTENTES.TipoCaja

CREATE TABLE PERSISTENTES.Empleado
(
	legajo_empleado int IDENTITY,
	--es creado por nosotros o ya dado por el sistema?
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

ALTER TABLE PERSISTENTES.Empleado
		add constraint FK_EmpleadoSucursal
		foreign key (empleado_sucursal) REFERENCES PERSISTENTES.Sucursal

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

ALTER TABLE PERSISTENTES.Cliente
		add constraint FK_ClienteLocalidad
		foreign key (cliente_localidad_id) REFERENCES PERSISTENTES.Localidad

create table PERSISTENTES.TipoComprobante
(
	tipo_comprobante nvarchar(255) not null

		constraint PK_TipoComprobante PRIMARY KEY (tipo_comprobante)
)

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

alter table PERSISTENTES.Ticket
		add constraint FK_TicketCaja
		foreign key (ticket_caja_nro, ticket_caja_sucursal) references PERSISTENTES.Caja(caja_nro, caja_sucursal)

alter table PERSISTENTES.Ticket
		add constraint FK_TicketTipoComprobante
		foreign key (ticket_tipo_comprobante) references PERSISTENTES.TipoComprobante

alter table PERSISTENTES.Ticket
		add constraint FK_TicketEmpleado
		foreign key (ticket_empleado) references PERSISTENTES.Empleado

create table PERSISTENTES.EnvioEstado
(
	envio_estado nvarchar(255) not null

		constraint PK_EnvioEstado PRIMARY KEY (envio_estado)
)

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

alter table PERSISTENTES.Envio
		add constraint FK_EnvioCliente
		foreign key (envio_cliente) references PERSISTENTES.Cliente

alter table PERSISTENTES.Envio
		add constraint FK_EnvioTicket
		foreign key (envio_ticket) references PERSISTENTES.Ticket

alter table PERSISTENTES.Envio
		add constraint FK_EnvioEstado
		foreign key (envio_estado) references PERSISTENTES.EnvioEstado

create table PERSISTENTES.TipoMedioDePago
(
	tipo_medio_de_pago nvarchar(255) not null

		constraint PK_TipoMedioDePago PRIMARY KEY (tipo_medio_de_pago)
)

create table PERSISTENTES.MedioDePago
(
	medio_de_pago nvarchar(255) not null,
	medio_de_pago_tipo nvarchar(255)

		constraint PK_MedioDePago PRIMARY KEY (medio_de_pago)
)

alter table PERSISTENTES.MedioDePago
		add constraint FK_MedioDePagoTipo
		foreign key (medio_de_pago_tipo) references PERSISTENTES.TipoMedioDePago

create table PERSISTENTES.Descuento
(
	descuento_codigo decimal(18,0) not null,
	--	descuento_medio_pago nvarchar(255) not null,                       --en el der lo desconectamos
	descuento_descripcion nvarchar(255),
	descuento_fecha_inicio datetime,
	descuento_fecha_fin datetime,
	descuento_porcentaje decimal(18,2),
	descuento_tope decimal(18,2)

		constraint PK_Descuento PRIMARY KEY (descuento_codigo)
)

--	alter table PERSISTENTES.Descuento
--		add constraint FK_DescuentoMedioPago
--		foreign key (descuento_medio_pago) references PERSISTENTES.MedioDePago

create table PERSISTENTES.Pago
(
	pago_id int IDENTITY,
	pago_fecha datetime,
	pago_importe decimal(18,2),
	pago_medio_pago nvarchar(255),
	--	pago_descuento_aplicado decimal(18,2),
	pago_ticket int,
	--	pago_descuento decimal not null --no existe mas

	constraint PK_Pago PRIMARY KEY (pago_id)
)

alter table PERSISTENTES.Pago
		add constraint FK_PagoMedioDePago
		foreign key (pago_medio_pago) references PERSISTENTES.MedioDePago

alter table PERSISTENTES.Pago
		add constraint FK_PagoTicket
		foreign key (pago_ticket) references PERSISTENTES.Ticket


create table PERSISTENTES.DetallePagoTarjeta
(
	detalle_pago_tarjeta_nro nvarchar(50),
	detalle_pago_tarjeta_cuotas decimal(18,0),
	detalle_pago_tarjeta_fecha_vencimiento datetime,
	detalle_pago_cliente int,
	detalle_pago_id int,

	constraint PK_DetallePago PRIMARY KEY (detalle_pago_id)
)

alter table PERSISTENTES.DetallePagoTarjeta
		add constraint FK_DetallePagoTarjetaCliente
		foreign key (detalle_pago_cliente) references PERSISTENTES.Cliente

alter table PERSISTENTES.DetallePagoTarjeta
		add constraint FK_DetallePagoTarjetaPago
		foreign key (detalle_pago_id) references PERSISTENTES.Pago

create table PERSISTENTES.DescuentoAplicado
(
	descuento_aplicado_descuento decimal(18,0) not null,
	descuento_aplicado_pago int not null,
	descuento_aplicado_cant decimal(18,2)

		constraint PK_DescuentoAplicado primary key (descuento_aplicado_descuento, descuento_aplicado_pago)
)

alter table PERSISTENTES.DescuentoAplicado
		add constraint FK_DescuentoAplicadoDescuento
		foreign key (descuento_aplicado_descuento) references PERSISTENTES.Descuento

alter table PERSISTENTES.DescuentoAplicado
		add constraint FK_DescuentoAplicadoPago
		foreign key (descuento_aplicado_pago) references PERSISTENTES.Pago

create table PERSISTENTES.Marca
(
	marca_id int IDENTITY,
	marca_nombre nvarchar(255)

		constraint PK_Marca PRIMARY KEY (marca_id)
)

create table PERSISTENTES.Categoria
(
	categoria_id int IDENTITY,
	categoria_nombre nvarchar(255),
	categoria_madre int null

		constraint PK_Categoria PRIMARY KEY (categoria_id)
)

alter table PERSISTENTES.Categoria
		add constraint FK_Categoria
		foreign key (categoria_madre) references PERSISTENTES.Categoria

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


alter table PERSISTENTES.Producto
		add constraint FK_ProductoMarca
		foreign key (producto_marca_id) references PERSISTENTES.Marca

alter table PERSISTENTES.Producto
	add constraint FK_ProductoCategoria
	foreign key (producto_categoria) references PERSISTENTES.Categoria

--create table PERSISTENTES.ProductoPorCategoria
--(
--	producto_id int not null,
--	categoria_id int not null

--		constraint PK_ProductoPorCategoria PRIMARY KEY (producto_id, categoria_id)
--)

--alter table PERSISTENTES.ProductoPorCategoria
--		add constraint FK_ProductoPorCategoriaProducto
--		foreign key (producto_id) references PERSISTENTES.Producto

--alter table PERSISTENTES.ProductoPorCategoria
--		add constraint FK_ProductoPorCategoriaCategoria
--		foreign key (categoria_id) references PERSISTENTES.Categoria


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

alter table PERSISTENTES.TicketDetalle
		add constraint FK_ticketDetalleTicket
		foreign key (ticket_det_ticket) references PERSISTENTES.Ticket

alter table PERSISTENTES.TicketDetalle
		add constraint FK_TicketDetalleProducto
		foreign key (ticket_det_producto) references PERSISTENTES.Producto


create table PERSISTENTES.Promocion
(
	promo_codigo decimal(18,0) not null,
--	promo_aplicada_id int,
	promocion_descripcion nvarchar(255),
	promocion_fecha_inicio datetime,
	promocion_fecha_fin datetime

		constraint PK_Promocion PRIMARY KEY (promo_codigo)
)

create table PERSISTENTES.PromoAplicada
(
	promo_aplicada_id int IDENTITY,
	promo_aplicada_ticketDet int,
	promo_aplicada_descuento decimal(18,2),
	promo_promocion decimal(18,0)

		constraint PK_PromoAplicada PRIMARY KEY (promo_aplicada_id)
)

alter table PERSISTENTES.PromoAplicada
		add constraint FK_PromoAplicadaTicketDet
		foreign key (promo_aplicada_ticketDet) references PERSISTENTES.TicketDetalle

alter table PERSISTENTES.PromoAplicada
		add constraint FK_PromoAplicadaPromocion
		foreign key (promo_promocion) references PERSISTENTES.Promocion




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

alter table PERSISTENTES.Regla
		add constraint FK_ReglaPromocion
		foreign key (regla_promocion) references PERSISTENTES.Promocion

create table PERSISTENTES.PromocionPorProducto
(
	promo_codigo decimal(18,0) not null,
	producto_id int not null

		constraint PK_PromocionPorProducto PRIMARY KEY (promo_codigo, producto_id)
)

alter table PERSISTENTES.PromocionPorProducto
		add constraint FK_PromocionPorProductoPromo 
		foreign key (promo_codigo) references PERSISTENTES.Promocion

alter table PERSISTENTES.PromocionPorProducto
		add constraint FK_PromocionPorProductoProd 
		foreign key (producto_id) references PERSISTENTES.Producto

CREATE TABLE PERSISTENTES.SubcategoriaCategoria (
    PRODUCTO_SUB_CATEGORIA NVARCHAR(255),
    PRODUCTO_CATEGORIA NVARCHAR(255))


go

EXEC crear_tablas
go
