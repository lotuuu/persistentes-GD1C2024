use GD1C2024
go

create table PERSISTENTES.BI_tiempo
(
	tiempo_id int identity,
	tiempo_anio int,
	tiempo_cuatrimestre int,
	tiempo_mes int

	constraint PK_BI_tiempo PRIMARY KEY (tiempo_id)
)

create table PERSISTENTES.BI_rangoEtario
(
	rangoEtario_id int identity,
	rangoEtario_descripcion nvarchar(60)
	constraint PK_BI_rangoEtario PRIMARY KEY (rangoEtario_id)
)

create table PERSISTENTES.BI_ubicacion
(
	ubicacion_id int identity,
	ubicacion_provincia int,
	ubicacion_localidad int,
	ubicacion_nombre nvarchar(255)

	constraint PK_BI_ubicacion PRIMARY KEY (ubicacion_id)
)

create table PERSISTENTES.BI_turno
(
	turno_id int identity,
	turno_descripcion char(60)

	constraint PK_BI_turno PRIMARY KEY (turno_id)
)

create table PERSISTENTES.BI_tipoCaja
(
	tipo_caja nvarchar(255) NOT NULL

	constraint PK_BI_tipoCaja primary key (tipo_caja)
)

create table PERSISTENTES.BI_hechos_ventas
(
	hechosVenta_id int identity,
	hechosVenta_tiempo_id int not null,
	hechosVenta_ubicacion_id int not null,
	hechosVenta_turno_id int not null,
	hechosVenta_tipo_caja nvarchar(255) not null,
	hechosVenta_rangoEtario_id int not null,
	hechosVenta_importe decimal(18,2),
	hechosVenta_cantidad_unidades decimal(18,0),
	hechosVenta_descuento decimal(18,0)

	constraint PK_BI_hechosVentas primary key (hechosVenta_id)
)

ALTER TABLE PERSISTENTES.BI_hechos_ventas
	add constraint FK_hechosVentas_tiempo
	foreign key (hechosVenta_tiempo_id) references PERSISTENTES.BI_tiempo

ALTER TABLE PERSISTENTES.BI_hechos_ventas
	add constraint FK_hechosVentas_ubicacion
	foreign key (hechosVenta_ubicacion_id) references PERSISTENTES.BI_ubicacion

ALTER TABLE PERSISTENTES.BI_hechos_ventas
	add constraint FK_hechosVentas_turno
	foreign key (hechosVenta_turno_id) references PERSISTENTES.BI_turno

ALTER TABLE PERSISTENTES.BI_hechos_ventas
	add constraint FK_hechosVentas_tipoCaja
	foreign key (hechosVenta_tipo_caja) references PERSISTENTES.BI_tipoCaja

ALTER TABLE PERSISTENTES.BI_hechos_ventas
	add constraint FK_hechosVentas_rangoEtario
	foreign key (hechosVenta_rangoEtario_id) references PERSISTENTES.BI_rangoEtario

create table PERSISTENTES.BI_sucursal
(
	sucursal_id int identity,
	sucursal_nombre nvarchar(255),
	sucursal_ubicacion_id int not null

	constraint PK_BI_sucursal primary key (sucursal_id)
)

alter table PERSISTENTES.BI_sucursal
	add constraint FK_BI_sucursal_ubicacion
	foreign key (sucursal_ubicacion_id) references PERSISTENTES.BI_ubicacion

create table PERSISTENTES.BI_hechos_envios
(
	hechosEnvios_id int identity,
	hechosEnvios_tiempo_id int not null,
	hechosEnvios_ubicacion_id int not null,
	hechosEnvios_rangoEtario_id int not null,
	hechosEnvios_estado bit,
	hechosEnvios_sucursal_id int not null,
	hechosEnvios_costo_envio decimal(18,2)

	constraint PK_BI_hechosEnvios primary key (hechosEnvios_id)
)

alter table PERSISTENTES.BI_hechos_envios
	add constraint FK_hechosEnvios_tiempo
	foreign key (hechosEnvios_tiempo_id) references PERSISTENTES.BI_tiempo

alter table PERSISTENTES.BI_hechos_envios
	add constraint FK_hechosEnvios_ubicacion
	foreign key (hechosEnvios_ubicacion_id) references PERSISTENTES.BI_ubicacion

alter table PERSISTENTES.BI_hechos_envios
	add constraint FK_hechosEnvios_rangoEtario
	foreign key (hechosEnvios_rangoEtario_id) references PERSISTENTES.BI_rangoEtario

alter table PERSISTENTES.BI_hechos_envios
	add constraint FK_hechosEnvios_sucursal
	foreign key (hechosEnvios_sucursal_id) references PERSISTENTES.BI_sucursal

create table PERSISTENTES.BI_medioDePago
(
	medio_de_pago nvarchar(255) not null,
	tipo_medio_de_pago nvarchar(255)

	constraint PK_BI_medioDePago primary key (medio_de_pago)
)

create table PERSISTENTES.BI_hechos_pagos
(
	hechosPagos_id int identity,
	hechosPagos_tiempo_id int not null,
	hechosPagos_rangoEtario_id int not null,
	hechosPagos_sucursal_id int not null,
	hechosPagos_importe decimal(18,2),
	hechosPagos_cantidad_cuotas decimal(18,0),
--	hechosPagos_enCuotas bit,
	hechosPagos_cantidad_descontada decimal(18,2),
	hechosPagos_medioDePago nvarchar(255) not null

	constraint PK_BI_hechosPagos primary key (hechosPagos_id)
)

alter table PERSISTENTES.BI_hechos_pagos
	add constraint FK_hechosPagos_tiempo
	foreign key (hechosPagos_tiempo_id) references PERSISTENTES.BI_tiempo

alter table PERSISTENTES.BI_hechos_pagos
	add constraint FK_hechosPagos_rangoEtario
	foreign key (hechosPagos_rangoEtario_id) references PERSISTENTES.BI_rangoEtario

alter table PERSISTENTES.BI_hechos_pagos
	add constraint FK_hechosPagos_sucursal
	foreign key (hechosPagos_sucursal_id) references PERSISTENTES.BI_sucursal

alter table PERSISTENTES.BI_hechos_pagos
	add constraint FK_hechosPagos_medioDePago
	foreign key (hechosPagos_medioDePago) references PERSISTENTES.BI_medioDePago

--MIGRACION

--tiempo
insert into PERSISTENTES.BI_tiempo
	(tiempo_anio,tiempo_cuatrimestre,tiempo_mes)
select distinct year(ticket_fecha_hora), 
case	when month(ticket_fecha_hora) = 1 or month(ticket_fecha_hora) = 2 or month(ticket_fecha_hora) = 3 or month(ticket_fecha_hora) = 4
		then 1
		when month(ticket_fecha_hora) = 5 or month(ticket_fecha_hora) = 6 or month(ticket_fecha_hora) = 7 or month(ticket_fecha_hora) = 8
		then 2
		else 3
		end,
month(ticket_fecha_hora)
from PERSISTENTES.Ticket

--Tipo Caja
insert into PERSISTENTES.BI_tipoCaja (tipo_caja)
select distinct tipo_caja from PERSISTENTES.TipoCaja

--Rango Etario
insert into PERSISTENTES.BI_rangoEtario
	(rangoEtario_descripcion)
select '<25'

insert into PERSISTENTES.BI_rangoEtario
	(rangoEtario_descripcion)
select '25-35'

insert into PERSISTENTES.BI_rangoEtario
	(rangoEtario_descripcion)
select '35-50'

insert into PERSISTENTES.BI_rangoEtario
	(rangoEtario_descripcion)
select '>50'

insert into PERSISTENTES.BI_rangoEtario
	(rangoEtario_descripcion)
select 'no se sabe'

--ubicacion
insert into PERSISTENTES.BI_ubicacion
	(ubicacion_localidad,ubicacion_provincia,ubicacion_nombre)
select distinct localidad_id, localidad_provincia,localidad_nombre from PERSISTENTES.Localidad

--turno

insert into PERSISTENTES.BI_turno
	(turno_descripcion)
select '08:00 - 12:00'

insert into PERSISTENTES.BI_turno
	(turno_descripcion)
select '12:00 - 16:00'

insert into PERSISTENTES.BI_turno
	(turno_descripcion)
select '16:00 - 20:00'

insert into PERSISTENTES.BI_turno
	(turno_descripcion)
select 'otros'

--BI_hechos_ventas
insert into PERSISTENTES.BI_hechos_ventas
	(hechosVenta_tiempo_id,hechosVenta_ubicacion_id,hechosVenta_turno_id,hechosVenta_tipo_caja,hechosVenta_rangoEtario_id,hechosVenta_importe,
	hechosVenta_cantidad_unidades,hechosVenta_descuento)

select distinct  
	(select tiempo_id from PERSISTENTES.BI_tiempo where tiempo_anio = year(ticket_fecha_hora) and tiempo_mes = MONTH(ticket_fecha_hora)),
	(select distinct ubicacion_id from PERSISTENTES.BI_ubicacion where sucursal_localidad_id = ubicacion_localidad),
	(select case	when datepart(hour,ticket_fecha_hora) >= 8 and datepart(hour,ticket_fecha_hora) < 12
					then 1
					when datepart(hour,ticket_fecha_hora) >= 12 and datepart(hour,ticket_fecha_hora) < 16
					then 2
					when datepart(hour,ticket_fecha_hora) >= 16 and datepart(hour,ticket_fecha_hora) < 20
					then 3
					else 4
					end),
	(select distinct tipo_caja from PERSISTENTES.BI_tipoCaja where tipo_caja = caja_tipo),
	(select case	when datediff(year,empleado_fecha_nacimiento,GETDATE()) < 25
					then 1
					when datediff(year,empleado_fecha_nacimiento,GETDATE()) >= 25 and datediff(year,empleado_fecha_nacimiento,GETDATE()) < 35
					then 2
					when datediff(year,empleado_fecha_nacimiento,GETDATE()) >= 35 and datediff(year,empleado_fecha_nacimiento,GETDATE()) < 50
					then 3
					else 4
					end
					from PERSISTENTES.Empleado where legajo_empleado = ticket_empleado),
	ticket_total_ticket,
	(select sum(ticket_det_cantidad) from PERSISTENTES.TicketDetalle where ticket_det_ticket = ticket_id),
	ticket_total_descuento
from PERSISTENTES.Ticket
join PERSISTENTES.Caja on caja_nro = ticket_caja_nro and caja_sucursal = ticket_caja_sucursal
join PERSISTENTES.Sucursal on caja_sucursal = sucursal_id

--SUCURSAL
insert into PERSISTENTES.BI_sucursal
	(sucursal_nombre, sucursal_ubicacion_id)
select distinct sucursal_nombre, ubicacion_id
from PERSISTENTES.Sucursal
join PERSISTENTES.BI_ubicacion on ubicacion_localidad = sucursal_localidad_id

--hechos envios
insert into PERSISTENTES.BI_hechos_envios
	(hechosEnvios_tiempo_id,hechosEnvios_ubicacion_id,hechosEnvios_rangoEtario_id,hechosEnvios_estado,hechosEnvios_sucursal_id,hechosEnvios_costo_envio)
select 
	(select tiempo_id from PERSISTENTES.BI_tiempo where tiempo_anio = year(envio_fecha_programada) and tiempo_mes = month(envio_fecha_programada)),
	(select ubicacion_id from PERSISTENTES.BI_ubicacion where ubicacion_localidad = cliente_localidad_id),
	(case	when datediff(year,cliente_fecha_nacimiento,GETDATE()) < 25
					then 1
					when datediff(year,cliente_fecha_nacimiento,GETDATE()) >= 25 and datediff(year,cliente_fecha_nacimiento,GETDATE()) < 35
					then 2
					when datediff(year,cliente_fecha_nacimiento,GETDATE()) >= 35 and datediff(year,cliente_fecha_nacimiento,GETDATE()) < 50
					then 3
					else 4
					end),
	case	when envio_estado = 'finalizado'
			then 1
			else 0
			end,
	(select bi.sucursal_id from PERSISTENTES.BI_sucursal bi
	join PERSISTENTES.Sucursal s on s.sucursal_nombre = bi.sucursal_nombre
	where s.sucursal_id = ticket_caja_sucursal),
	envio_costo
from PERSISTENTES.Envio
join PERSISTENTES.Cliente on cliente_id = envio_cliente
join PERSISTENTES.Ticket on ticket_id = envio_ticket

--medioDePago
insert into PERSISTENTES.BI_medioDePago
	(medio_de_pago,tipo_medio_de_pago)
select medio_de_pago, medio_de_pago_tipo from PERSISTENTES.MedioDePago

--BI_hechos_Pagos
insert into PERSISTENTES.BI_hechos_pagos
	(hechosPagos_tiempo_id,hechosPagos_rangoEtario_id,hechosPagos_sucursal_id,hechosPagos_importe,hechosPagos_cantidad_cuotas,hechosPagos_cantidad_descontada,hechosPagos_medioDePago)
select  
	(select tiempo_id from PERSISTENTES.BI_tiempo where tiempo_anio = year(pago_fecha) and MONTH(pago_fecha) = tiempo_mes),
	case	when cliente_id is NULL
			then 5
			when datediff(year,cliente_fecha_nacimiento,GETDATE()) < 25
			then 1
			when datediff(year,cliente_fecha_nacimiento,GETDATE()) >= 25 and datediff(year,cliente_fecha_nacimiento,GETDATE()) < 35
			then 2
			when datediff(year,cliente_fecha_nacimiento,GETDATE()) >= 35 and datediff(year,cliente_fecha_nacimiento,GETDATE()) < 50
			then 3
			else 4
			end,
	(select bi.sucursal_id from PERSISTENTES.BI_sucursal bi
	join PERSISTENTES.Sucursal s on s.sucursal_nombre = bi.sucursal_nombre
	where s.sucursal_id = ticket_caja_sucursal),
	pago_importe,
	(select	case	when detalle_pago_tarjeta_cuotas is null
					then 0
					else detalle_pago_tarjeta_cuotas
					end
	from PERSISTENTES.DetallePagoTarjeta
	right join PERSISTENTES.Pago on pago_id = detalle_pago_id
	where p.pago_id = pago_id),
	descuento_aplicado_cant,
	p.pago_medio_pago
from PERSISTENTES.Pago p
join PERSISTENTES.Ticket on ticket_id = pago_ticket
left join PERSISTENTES.Envio on envio_ticket = ticket_id
left join PERSISTENTES.Cliente on cliente_id = envio_cliente
join PERSISTENTES.DescuentoAplicado on descuento_aplicado_pago = pago_id
join PERSISTENTES.BI_medioDePago mp on mp.medio_de_pago = p.pago_medio_pago
--join PERSISTENTES.Cliente on cliente_id = 


go
/*1. Ticket Promedio mensual. Valor promedio de las ventas (en $) seg�n la
localidad, a�o y mes. Se calcula en funci�n de la sumatoria del importe de las
ventas sobre el total de las mismas.*/

create view PERSISTENTES.Ticket_Promedio_Mensual
as
select tiempo_anio,tiempo_mes,ubicacion_nombre, 
sum(hechosVenta_importe) / (select sum(hechosVenta_importe) from PERSISTENTES.BI_hechos_ventas) as Promedio_de_ventas
from PERSISTENTES.BI_hechos_ventas
join PERSISTENTES.BI_tiempo on tiempo_id = hechosVenta_tiempo_id
join PERSISTENTES.BI_ubicacion on hechosVenta_ubicacion_id = ubicacion_id
group by tiempo_anio,tiempo_mes,ubicacion_nombre
go
--select * from PERSISTENTES.Ticket_Promedio_Mensual

/*2. Cantidad unidades promedio. Cantidad promedio de art�culos que se venden
en funci�n de los tickets seg�n el turno para cada cuatrimestre de cada a�o. Se
obtiene sumando la cantidad de art�culos de todos los tickets correspondientes
sobre la cantidad de tickets. Si un producto tiene m�s de una unidad en un ticket,
para el indicador se consideran todas las unidades.*/
go
create view PERSISTENTES.Cantidad_Unidades_Promedio
as
select turno_descripcion, tiempo_cuatrimestre, tiempo_anio, 
sum(hechosVenta_cantidad_unidades) / (select count(*) from PERSISTENTES.BI_hechos_ventas) as Cantidad_unidades_promedio
from PERSISTENTES.BI_hechos_ventas
join PERSISTENTES.BI_turno on turno_id = hechosVenta_turno_id
join PERSISTENTES.BI_tiempo on tiempo_id = hechosVenta_tiempo_id
group by turno_descripcion, tiempo_cuatrimestre, tiempo_anio
go
--select * from PERSISTENTES.Cantidad_Unidades_Promedio
go

/*3. Porcentaje anual de ventas registradas por rango etario del empleado seg�n el
tipo de caja para cada cuatrimestre. Se calcula tomando la cantidad de ventas
correspondientes sobre el total de ventas anual.*/

create view PERSISTENTES.Porcentaje_Anual_Ventas
as
select tiempo_anio, tiempo_cuatrimestre, rangoEtario_descripcion,tipo_caja,
count(hechosVenta_id)*100.0 / (select count(hechosVenta_id) from PERSISTENTES.BI_hechos_ventas) porcentaje_de_ventas
from PERSISTENTES.BI_hechos_ventas
join PERSISTENTES.BI_tiempo on tiempo_id = hechosVenta_tiempo_id
join PERSISTENTES.BI_tipoCaja on tipo_caja = hechosVenta_tipo_caja
join PERSISTENTES.BI_rangoEtario on rangoEtario_id = hechosVenta_rangoEtario_id
group by tiempo_anio, tiempo_cuatrimestre, rangoEtario_descripcion, tipo_caja
go

--select * from PERSISTENTES.Porcentaje_Anual_Ventas

/*4. Cantidad de ventas registradas por turno para cada localidad seg�n el mes de
cada a�o.*/

create view PERSISTENTES.Cantidad_De_Ventas
as
select turno_descripcion, tiempo_mes, ubicacion_nombre, count(hechosVenta_id) cantidad_de_ventas from PERSISTENTES.BI_hechos_ventas
join PERSISTENTES.BI_turno on turno_id = hechosVenta_turno_id
join PERSISTENTES.BI_ubicacion on hechosVenta_ubicacion_id = ubicacion_id
join PERSISTENTES.BI_tiempo on tiempo_id = hechosVenta_tiempo_id
group by turno_descripcion, tiempo_mes, ubicacion_nombre
go

--select * from PERSISTENTES.Cantidad_De_Ventas

/*5. Porcentaje de descuento aplicados en funci�n del total de los tickets seg�n el
mes de cada a�o.*/

create view PERSISTENTES.Porcentaje_Descuento_Aplicado
as
select tiempo_anio, tiempo_mes, sum(hechosVenta_descuento)*100.0 / (select sum(hechosVenta_descuento) from PERSISTENTES.BI_hechos_ventas) Porcentaje_De_Descuento_Aplicado
from PERSISTENTES.BI_hechos_ventas
join PERSISTENTES.BI_tiempo on tiempo_id = hechosVenta_tiempo_id
group by tiempo_anio, tiempo_mes
go

--select * from PERSISTENTES.Porcentaje_Descuento_Aplicado

/*6. Las tres categor�as de productos con mayor descuento aplicado a partir de
promociones para cada cuatrimestre de cada a�o.*/

--TODO

/*7. Porcentaje de cumplimiento de env�os en los tiempos programados por
sucursal por a�o/mes (desv�o)*/

create view PERSISTENTES.Porcentaje_De_Cumplimiento_Envios
as
select tiempo_anio, tiempo_mes, sucursal_nombre, 
	count(hechosEnvios_estado)*100.0 / 
	(select count(*) from PERSISTENTES.BI_hechos_envios
	join PERSISTENTES.BI_tiempo on tiempo_id = hechosEnvios_tiempo_id
	join PERSISTENTES.BI_sucursal on sucursal_id = hechosEnvios_sucursal_id
	where tiempo_anio = bt.tiempo_anio and tiempo_mes = bt.tiempo_mes and bs.sucursal_nombre = sucursal_nombre
	) porcentaje_de_cumplimiento 
from PERSISTENTES.BI_hechos_envios he
join PERSISTENTES.BI_tiempo bt on tiempo_id = hechosEnvios_tiempo_id
join PERSISTENTES.BI_sucursal bs on sucursal_id = hechosEnvios_sucursal_id
where hechosEnvios_estado = 1
group by tiempo_anio, tiempo_mes, sucursal_nombre
go


--select * from PERSISTENTES.Porcentaje_De_Cumplimiento_Envios

/*8. Cantidad de env�os por rango etario de clientes para cada cuatrimestre de
cada a�o.*/

create view PERSISTENTES.Cantidad_De_Envios
as
select tiempo_anio, tiempo_cuatrimestre, rangoEtario_descripcion,
	count(*) cantidad_de_envios
from PERSISTENTES.BI_hechos_envios
join PERSISTENTES.BI_rangoEtario on hechosEnvios_rangoEtario_id = rangoEtario_id
join PERSISTENTES.BI_tiempo on hechosEnvios_tiempo_id = tiempo_id
group by tiempo_anio,tiempo_cuatrimestre,rangoEtario_descripcion
go
--select * from PERSISTENTES.Cantidad_De_Envios

/*9. Las 5 localidades (tomando la localidad del cliente) con mayor costo de env�o.*/

create view PERSISTENTES.Localidades_con_mayor_costo_envios
as
select top 5 ubicacion_nombre from PERSISTENTES.BI_hechos_envios
join PERSISTENTES.BI_ubicacion on ubicacion_id = hechosEnvios_ubicacion_id
group by ubicacion_nombre
order by sum(hechosEnvios_costo_envio) desc
go
--select * from PERSISTENTES.Localidades_con_mayor_costo_envios

/*10. Las 3 sucursales con el mayor importe de pagos en cuotas, seg�n el medio de
pago, mes y a�o. Se calcula sumando los importes totales de todas las ventas en
cuotas.*/

create view PERSISTENTES.Sucursales_con_mayor_importe
as
select top 3 sucursal_nombre,tiempo_anio,tiempo_mes,hechosPagos_medioDePago
from PERSISTENTES.BI_hechos_pagos
join PERSISTENTES.BI_sucursal on sucursal_id = hechosPagos_sucursal_id
join PERSISTENTES.BI_tiempo on tiempo_id = hechosPagos_tiempo_id
join PERSISTENTES.BI_medioDePago on medio_de_pago = hechosPagos_medioDePago
where hechosPagos_cantidad_cuotas != 0
group by sucursal_nombre,tiempo_anio,hechosPagos_medioDePago,tiempo_mes
order by sum(hechosPagos_importe) desc
go

--select * from PERSISTENTES.Sucursales_con_mayor_importe

/*11. Promedio de importe de la cuota en funci�n del rango etareo del cliente.*/

create view PERSISTENTES.Promedio_Importe_Cuota
as
select rangoEtario_descripcion, sum(hechosPagos_importe/hechosPagos_cantidad_cuotas)/count(hechosPagos_importe) as Promedio_De_Importe_De_La_Cuota
from PERSISTENTES.BI_hechos_pagos
join PERSISTENTES.BI_rangoEtario on hechosPagos_rangoEtario_id = rangoEtario_id
where hechosPagos_cantidad_cuotas != 0
group by rangoEtario_descripcion
go

--select * from PERSISTENTES.Promedio_Importe_Cuota

/*12. Porcentaje de descuento aplicado por cada medio de pago en funci�n del valor
de total de pagos sin el descuento, por cuatrimestre. Es decir, total de descuentos
sobre el total de pagos m�s el total de descuentos.*/

create view PERSISTENTES.Porcentaje_Descuento_Aplicado_Pagos
as
select medio_de_pago, tiempo_cuatrimestre,  
	sum(hechosPagos_cantidad_descontada)*100.0/ sum(hechosPagos_cantidad_descontada+hechosPagos_importe) porcentaje_descuento_aplicado

--	(select sum(hechosPagos_cantidad_descontada) from PERSISTENTES.BI_hechos_pagos) 
from PERSISTENTES.BI_hechos_pagos
join PERSISTENTES.BI_medioDePago on medio_de_pago = hechosPagos_medioDePago
join PERSISTENTES.BI_tiempo on tiempo_id = hechosPagos_tiempo_id
group by medio_de_pago, tiempo_cuatrimestre
go

--select * from PERSISTENTES.Porcentaje_Descuento_Aplicado_Pagos
