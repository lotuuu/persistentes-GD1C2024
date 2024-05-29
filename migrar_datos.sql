CREATE PROCEDURE migrar_datos
AS
--Provincia
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


--Localidad
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

--TipoCaja
INSERT INTO PERSISTENTES.TipoCaja
	(tipo_caja)
SELECT DISTINCT CAJA_TIPO
FROM [GD1C2024].[gd_esquema].[Maestra]
WHERE CAJA_TIPO IS NOT NULL

--EnvioEstado
INSERT INTO PERSISTENTES.EnvioEstado
	(envio_estado)
SELECT DISTINCT ENVIO_ESTADO
FROM GD1C2024.gd_esquema.Maestra
WHERE ENVIO_ESTADO IS NOT NULL

--TipoComprobante
INSERT INTO PERSISTENTES.TipoComprobante
	(tipo_comprobante)
select distinct TICKET_TIPO_COMPROBANTE
FROM [GD1C2024].[gd_esquema].[Maestra]
WHERE TICKET_TIPO_COMPROBANTE IS NOT NULL

--CondicionFiscal
INSERT INTO PERSISTENTES.CondicionFiscal
select distinct SUPER_CONDICION_FISCAL
from [GD1C2024].[gd_esquema].[Maestra]
WHERE SUPER_CONDICION_FISCAL IS NOT NULL

--Marca
INSERT INTO PERSISTENTES.Marca
select distinct PRODUCTO_MARCA
from [GD1C2024].[gd_esquema].[Maestra]
WHERE PRODUCTO_MARCA IS NOT NULL

--TipoMedioDePago
INSERT INTO PERSISTENTES.TipoMedioDePago
	(tipo_medio_de_pago)
SELECT DISTINCT PAGO_TIPO_MEDIO_PAGO
FROM GD1C2024.gd_esquema.Maestra
WHERE PAGO_TIPO_MEDIO_PAGO IS NOT NULL

--MedioDePago
INSERT INTO PERSISTENTES.MedioDePago
	(medio_de_pago, medio_de_pago_tipo)
SELECT DISTINCT maestra_medio_de_pago, nueva_tipo_medio_de_pago
FROM (
        SELECT maestra.PAGO_MEDIO_PAGO AS maestra_medio_de_pago, nueva_tipo_medio_de_pago_t.tipo_medio_de_pago AS nueva_tipo_medio_de_pago
	FROM GD1C2024.gd_esquema.Maestra maestra LEFT JOIN PERSISTENTES.TipoMedioDePago nueva_tipo_medio_de_pago_t
		on nueva_tipo_medio_de_pago_t.tipo_medio_de_pago = maestra.PAGO_TIPO_MEDIO_PAGO
	WHERE PAGO_MEDIO_PAGO IS NOT NULL 
        ) AS MedioDePago;


--Descuento
INSERT INTO PERSISTENTES.Descuento
	(descuento_codigo, descuento_descripcion, descuento_fecha_inicio, descuento_fecha_fin, descuento_porcentaje, descuento_tope)
select distinct DESCUENTO_CODIGO, DESCUENTO_DESCRIPCION, DESCUENTO_FECHA_FIN, DESCUENTO_FECHA_INICIO, DESCUENTO_PORCENTAJE_DESC, DESCUENTO_TOPE
from [GD1C2024].[gd_esquema].[Maestra]
where DESCUENTO_CODIGO is not null

--Super
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

--Sucursal
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

--Caja
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

--Empleado
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


--Ticket
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


--INSERT INTO PERSISTENTES.Pago
--	(pago_fecha, pago_importe, pago_medio_pago, pago_ticket)
--SELECT DISTINCT maestra_pago_fecha, maestra_pago_importe, nueva_pago_medio_pago, nueva_pago_ticket
--from (
--	select maestra.PAGO_FECHA as maestra_pago_fecha,
--		maestra.PAGO_IMPORTE as maestra_pago_importe,
--		nueva_MedioDePago_t.medio_de_pago nueva_pago_medio_pago,
--		nueva_Ticket_t.ticket_id nueva_pago_ticket
--	from [GD1C2024].[gd_esquema].[Maestra]
--		LEFT JOIN PERSISTENTES.Ticket nueva_Ticket_t on nueva_Ticket_t.ticket_numero = maestra.TICKET_NUMERO
--		LEFT JOIN PERSISTENTES.MedioDePago nueva_MedioDePago_t on nueva_MedioDePago_t.medio_de_pago = maestra.PAGO_MEDIO_PAGO
--	where maestra.PAGO_FECHA is not null and maestra.PAGO_IMPORTE is not null and maestra.PAGO_MEDIO_PAGO is not null and maestra.TICKET_NUMERO is not null
--) as Pago

--Cliente
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


--PromoAplicada
--INSERT INTO PERSISTENTES.PromoAplicada
--	(promo_aplicada_descuento)
--SELECT distinct PROMO_APLICADA_DESCUENTO
--from [GD1C2024].[gd_esquema].[Maestra]
--where PROMO_APLICADA_DESCUENTO is not null



--Promocion 
--Falta agregar al insert promo_aplicada_id
INSERT INTO PERSISTENTES.Promocion
	(
	promo_codigo,
	promocion_descripcion,
	promocion_fecha_inicio,
	promocion_fecha_fin)
select distinct
	maestra_promo_codigo,
	maestra_promocion_descripcion,
	maestra_promocion_fecha_inicio,
	maestra_promocion_fecha_fin
from (
	select
		Maestra.PROMO_CODIGO as maestra_promo_codigo,
		Maestra.PROMOCION_DESCRIPCION as maestra_promocion_descripcion,
		Maestra.PROMOCION_FECHA_INICIO as maestra_promocion_fecha_inicio,
		Maestra.PROMOCION_FECHA_FIN as maestra_promocion_fecha_fin
	from [GD1C2024].[gd_esquema].[Maestra]
		left join PERSISTENTES.PromoAplicada nueva_promo_aplicada on nueva_promo_aplicada.promo_aplicada_descuento = Maestra.PROMO_APLICADA_DESCUENTO
	where Maestra.PROMO_CODIGO is not null
	) as Promocion

	--DEJO COMENTADO PARA GUARDAR EL CODIGO
----Categoria
--INSERT INTO PERSISTENTES.Categoria
--	(categoria_nombre)
--SELECT distinct PRODUCTO_CATEGORIA
--from [GD1C2024].[gd_esquema].[Maestra]
--where PRODUCTO_CATEGORIA is not null
----Subcategoria
--INSERT INTO PERSISTENTES.Categoria
--	(categoria_nombre, categoria_madre)
--select distinct PRODUCTO_SUB_CATEGORIA, c.categoria_id
--from [GD1C2024].[gd_esquema].[Maestra]
--	join PERSISTENTES.Categoria c on c.categoria_nombre = PRODUCTO_CATEGORIA

--Categoria
	insert into PERSISTENTES.Categoria(categoria_nombre)
	SELECT distinct PRODUCTO_CATEGORIA from [GD1C2024].[gd_esquema].[Maestra]
	where PRODUCTO_CATEGORIA is not null


INSERT INTO PERSISTENTES.SubcategoriaCategoria (PRODUCTO_SUB_CATEGORIA, PRODUCTO_CATEGORIA)
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

--subcategoria
	insert into PERSISTENTES.Categoria(categoria_nombre, categoria_madre)
	select distinct PRODUCTO_SUB_CATEGORIA, c.categoria_id
	from PERSISTENTES.SubcategoriaCategoria
	join PERSISTENTES.Categoria c on c.categoria_nombre = PRODUCTO_CATEGORIA

--Producto
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
go

--TicketDetalle
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
			nueva_ticket_t.ticket_caja_sucursal = (select sucursal_id from PERSISTENTES.Sucursal where sucursal_nombre = maestra.SUCURSAL_NOMBRE) and
			nueva_ticket_t.ticket_tipo_comprobante = maestra.TICKET_TIPO_COMPROBANTE and
			nueva_ticket_t.ticket_total_ticket = Maestra.TICKET_TOTAL_TICKET
		LEFT JOIN PERSISTENTES.Producto nueva_Producto_t on nueva_Producto_t.producto_nombre = maestra.PRODUCTO_NOMBRE and
		nueva_Producto_t.producto_marca_id = (select marca_id from PERSISTENTES.Marca where marca_nombre = maestra.PRODUCTO_MARCA)
		and nueva_Producto_t.producto_precio = TICKET_DET_PRECIO
	where maestra.TICKET_NUMERO is not null and maestra.PRODUCTO_NOMBRE is not null
	) as TicketDetalle

--INSERT INTO PERSISTENTES.Regla
--    (regla_nombre, regla_descripcion, regla_fecha_inicio, regla_fecha_fin, regla_porcentaje, regla_tope)
--SELECT distinct
--    maestra_regla_nombre,
--    maestra_regla_descripcion,
--    maestra_regla_fecha_inicio,
--    maestra_regla_fecha_fin,
--    maestra_regla_porcentaje,
--    maestra_regla_tope
--from (
--    select
--        Maestra.REGLA_NOMBRE as maestra_regla_nombre,
--        Maestra.REGLA_DESCRIPCION as maestra_regla_descripcion,
--        Maestra.REGLA_FECHA_INICIO as maestra_regla_fecha_inicio,
--        Maestra.REGLA_FECHA_FIN as maestra_regla_fecha_fin,
--        Maestra.REGLA_PORCENTAJE as maestra_regla_porcentaje,
--        Maestra.REGLA_TOPE as maestra_regla_tope
--    from gd_esquema.Maestra
--    where Maestra.REGLA_NOMBRE is not null
--    ) as Regla

--envio
	INSERT INTO PERSISTENTES.Envio(envio_costo, envio_fecha_programada, envio_hora_inicio, envio_hora_fin, envio_fecha_entrega, envio_cliente, envio_estado, envio_ticket)
		select distinct maestra_envio_costo, maestra_envio_fecha_programada, maestra_envio_hora_inicio, maestra_envio_hora_fin, maestra_envio_fecha_entrega, nueva_envio_cliente_id, 
						nueva_envio_estado, nueva_envio_ticket_id
		from (
			select	maestra.ENVIO_COSTO as maestra_envio_costo,
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
				and nueva_envio_ticket_t.ticket_caja_sucursal = (select sucursal_id from PERSISTENTES.Sucursal s where s.sucursal_nombre = maestra.SUCURSAL_NOMBRE)
				--and nueva_envio_ticket_t.ticket_empleado = (select legajo_empleado from PERSISTENTES.Empleado e where e.empleado_dni = maestra.EMPLEADO_DNI)
				--and nueva_envio_ticket_t.ticket_fecha_hora = maestra.TICKET_FECHA_HORA
				and nueva_envio_ticket_t.ticket_total_envio = Maestra.TICKET_TOTAL_ENVIO
			where maestra.ENVIO_COSTO is not null
		) as Envio


EXEC migrar_datos
go
