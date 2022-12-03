

-------Directorios blobs------

create or replace  directory DIR_LOGO as 'C:\imagenes\logo_bomboneria\';
create or replace  directory Chocolates  as 'C:\imagenes\chocolates\';
create or replace  directory Logos_productor_cho as 'C:\imagenes\logo_productor_cho\';
create or replace  directory Logos_productor_cacao  as 'C:\imagenes\logo_productor_cacao\';

-------Permisos a usuarios desde system ------------

grant read, write on directory DIR_LOGO to HANS;
grant read, write on directory Chocolates to HANS;
grant read, write on directory Logos_productor_cacao to HANS;
grant read, write on directory Logos_productor_cho to HANS;

-------Create  types---------
create or replace type dir as object
(calle varchar2(50),
local varchar2(25),
edificio varchar2(25),
numero number,
urbanizacion varchar2(50)
);

create or replace type clasificacion as object
(tipo varchar2(25),
nombre varchar2(25),
descripcion varchar2(250)
);

create or replace type horario as object
(dia varchar2(20),
horai varchar(10),
horaf varchar(10));

create or replace type horarios_nt as table of horario;

create or replace type preciosesp as object
(ingrediente varchar2(50),
precio real);

create or replace type preciosesp_nt as table of preciosesp;


create or replace type votos as object
(total real,
 mes number,
 anios number);

create or replace type votos_nt as table of votos;

create or replace type detalles as object
(cantkg real,
 tipo_precio real);

create or replace type detalles_nt as table of detalles;

create or replace type temperatura_fundicion as object
(tipo varchar2(25),
 rangosupc real,
 rangoinfc real,
 rangosupf real,
 rangoinff real);

create or replace type temperaturas_nt as table of temperatura_fundicion;


create or replace type lote as object
(nro_lote number,
 fecha_vencimiento date);

create or replace type lote_nt as table of lote;

create or replace type envio as object
(fecha date,
 kg real);

create or replace type envio_nt as table of envio;
----- varrays--------

create or replace type telefonos_va as varray(3) of varchar2(25);
create or replace type ingredientes_va as varray(2) of varchar2(25);

------- CREATE TABLES---------

create table Pais(
    id_pais number,
    nombre  varchar2(50) not null ,
    constraint pk_pais primary key (id_pais)
);

create table Ciudad(
    id_ciudad number,
    nombre  varchar2(50) not null,
    pais_id   number not null,
    constraint pk_ciudad primary key (id_ciudad,pais_id),
    constraint fk_pais foreign key (pais_id) references Pais(id_pais)
);

create table Bomboneria (
  id_bomboneria number,
  nombre varchar2(100) not null ,
  logo BFILE,
  fecha_fun date not null ,
  direccion dir not null,
  horas_atencion horarios_nt,
  telefonos telefonos_va,
  email varchar2(50),
  dir_paginaweb varchar2(100),
  precioKg number,
  precios_especiales preciosesp_nt,
  ciudad_id number not null,
  pais_id number not null,
  constraint fk_ciudad Foreign Key (ciudad_id,pais_id) references Ciudad(id_ciudad,pais_id),
  constraint pk_bomboneria primary key (id_bomboneria)
)nested table horas_atencion store as horarios_nt_1
 nested table precios_especiales store as preciosesp_nt_1;

create table Catalogo_Bombones (
    id_bombon number,
    nombre_chocolate varchar2(50) not null ,
    tipo_chocolate varchar2(50) not null ,
    descripcion_bombon varchar2(150) not null ,
    nombre_coleccion varchar2(50),
    id_bomboneria number not null,
    img BFILE,
    ingredientes ingredientes_va,
    votos votos_nt,
    constraint pk_catalogo primary key (id_bombon,id_bomboneria),
    constraint fk_bomboneria foreign key (id_bomboneria) references Bomboneria(id_bomboneria)
)nested table votos store as  votos_nt_1;


create table FACTURA_BOMBONERIA (
    id_factura number,
    total_monto real,
    total_peso real,
    fecha date,
    detalles detalles_nt,
    id_bomboneria number not null,
    constraint pk_factura primary key (id_factura,id_bomboneria),
    constraint fk_bomboneria2 foreign key (id_bomboneria) references Bomboneria(id_bomboneria)
)nested table detalles store as  detalles_nt_1;


create table PROVEEDOR_CACAO (
    id_proveedor_cacao number,
    mombre varchar2(50) not null ,
    logo bfile,
    mision_proposito varchar2(500) not null,
    id_pais number not null ,
    constraint pk_proveedor_cacao primary key (id_proveedor_cacao),
    constraint fk_proveedor_cacao foreign key (id_pais) references Pais(id_pais)
);

create table CONTRATO (
    id_contrato number ,
    estatus_contrato varchar2(50) not null ,
    fecha_creacion date,
    monto_total_importacion real not null,
    id_proveedor number not null,
    id_bomboneria number not null,
    constraint pk_contrato primary key (id_contrato,id_proveedor,id_bomboneria),
    constraint  fk1_contrato foreign key (id_proveedor) references PROVEEDOR_CACAO(id_proveedor_cacao),
    constraint fk2_contrato foreign key (id_bomboneria) references Bomboneria(id_bomboneria)
);

create table TIPO_CACAO(
    id_tipocacao number,
    nombre_variedad varchar2(50) not null,
    tipo varchar2(20) not null,
    descripcion varchar2(250) not null,
    id_pais number,
    constraint pk_tipo_cacao primary key (id_tipocacao),
    constraint fk1 foreign key (id_pais) references Pais(id_pais)
);

create table PROVEEDOR_CHOCOLATE (
    id_proveedor_cho number,
    mombre varchar2(50) not null ,
    logo bfile,
    mision_proposito varchar2(500) not null,
    id_pais number,
    constraint pk_proveedor_cho primary key (id_proveedor_cho),
    constraint fk_proveedor_cho foreign key (id_pais) references Pais(id_pais)
);

create table CATALOGO_CHOCOLATE (
    id_chocolate number,
    nombre varchar2(50) not null,
    temperatura_fundicion temperaturas_nt,
    usos varchar2(250) not null,
    tipo varchar2(50) not null,
    porce_cacao number,
    porce_matnteca number,
    clasificacion clasificacion,
    id_proveedor number,
    constraint pk primary key (id_proveedor,id_chocolate),
    constraint fk foreign key (id_proveedor) references PROVEEDOR_CHOCOLATE(id_proveedor_cho)
)nested table temperatura_fundicion store as tem_nt_1;


create table PRESENTACION(
    id_presentacion number,
    tipo_presentacion varchar2(25),
    foto bfile,
    peso_gramos real,
    id_proveedor_cho number,
    id_chocolate number,
    constraint pk_presentacion primary key (id_proveedor_cho,id_chocolate,id_presentacion),
    constraint fk_presentacion foreign key (id_proveedor_cho,id_chocolate) references CATALOGO_CHOCOLATE(id_proveedor,id_chocolate)

);

create table CATALOGO_CACAO(
    id_proveedor_cacao number,
    id_tipocacao number,
    descripcion_regional varchar2(250),
    constraint pk_ca_ca primary key (id_proveedor_cacao,id_tipocacao),
    constraint fk_ca_ca1 foreign key (id_tipocacao) references TIPO_CACAO(id_tipocacao),
    constraint fk_ca_ca2 foreign key (id_proveedor_cacao) references PROVEEDOR_CACAO(id_proveedor_cacao)
);




create table HISTORICO_PRECIO(
    id_historico number,
    fechai date not null ,
    fechaf date,
    precio real not null,
    id_proveedor_cho number,
    id_chocolate number,
    id_presentacion number,
    id_proveedor_cacao number,
    id_tipo_cacao number,
    constraint pk_historico primary key (id_historico),
    constraint fk_historico1 foreign key (id_proveedor_cho,id_chocolate,id_presentacion) references PRESENTACION(id_presentacion,id_chocolate,id_proveedor_cho),
    constraint fk_historico2 foreign key (id_proveedor_cacao,id_tipo_cacao) references CATALOGO_CACAO(id_proveedor_cacao,id_tipocacao),
    CONSTRAINT arco CHECK ( ( ( id_proveedor_cho IS NOT NULL ) AND ( id_chocolate IS NOT NULL ) AND (id_presentacion IS NOT NULL) AND ( id_proveedor_cacao IS NULL ) AND (id_tipo_cacao IS NULL))
                                 OR ( ( id_proveedor_cacao IS NOT NULL ) AND ( id_tipo_cacao IS NOT NULL ) AND ( id_proveedor_cho IS NULL ) AND ( id_chocolate IS NULL ) AND (id_presentacion IS NULL) ) )
);

create table PEDIDO(
    id_pedido number,
    fecha_emi date not null ,
    estatus varchar2(25) not null ,
    fecha_deseada date not null,
    fecha_envio_est date,
    fecha_envio_real date,
    id_proveedor_cho number not null,
    id_bomboneria number not null,
    constraint pk_pedido primary key(id_pedido,id_proveedor_cho,id_bomboneria),
    constraint fk1_pedido foreign key (id_proveedor_cho) references PROVEEDOR_CHOCOLATE(id_proveedor_cho),
    constraint fk2_pedido foreign key (id_bomboneria) references Bomboneria(id_bomboneria)
);

create table FACTURA_PEDIDO (
    nro_factura number,
    total real not null,
    fecha_emi date not null,
    id_pedido number not null,
    id_proveedor_cho number not null,
    id_bomboneria number not null,
    constraint unique_factura unique (id_pedido,id_proveedor_cho,id_bomboneria),
    constraint pk_factura_p primary key (nro_factura),
    constraint  fk_factura_p foreign key (id_pedido,id_bomboneria,id_proveedor_cho) references PEDIDO(id_pedido,id_bomboneria,id_proveedor_cho)
);

create table PAGO(
    id_pago number,
    fecha date not null,
    monto real not null,
    id_factura number not null,
   constraint pk_pago primary key (id_pago,id_factura),
   constraint  fk_pago foreign key (id_factura) references  FACTURA_PEDIDO(nro_factura)
);

create table DETALLE_PEDIDO (
    id_det_pedido number,
    cantidad number not null,
    id_pedido number,
    id_proveedor_cho_pedido number,
    id_bomboneria number,
    id_presentacion number not null,
    id_chocolate number not null,
    id_proveedor_cho_presentacion number not null,
    constraint pk_detalle_pedido primary key(id_det_pedido,id_pedido,id_proveedor_cho_pedido,id_bomboneria),
    constraint fk1_detalle_pedido foreign key (id_pedido,id_proveedor_cho_pedido,id_bomboneria) references PEDIDO(id_pedido,id_proveedor_cho,id_bomboneria),
    constraint fk2_detalle_pedido foreign key (id_presentacion,id_chocolate,id_proveedor_cho_presentacion) references PRESENTACION(id_presentacion,id_chocolate,id_proveedor_cho)

);

create table DETALLE_FACTURA_PEDIDO(
    id_det_factura number,
    lotes lote_nt ,
    id_nrofactura number,
    id_det_pedido number not null,
    id_pedido number not null ,
    id_proveedor_cho_pedido number not null ,
    id_bomboneria number not null,
    constraint pk_detalle_fa primary key (id_det_factura,id_nrofactura),
    constraint fk1_detalle_fa foreign key (id_nrofactura) references  FACTURA_PEDIDO(nro_factura),
    constraint fk2_detalle_fa foreign key (id_det_pedido,id_pedido,id_proveedor_cho_pedido,id_bomboneria) references DETALLE_PEDIDO(id_det_pedido,id_pedido,id_proveedor_cho_pedido,id_bomboneria),
    constraint unique_detalle_fa unique (id_det_pedido,id_pedido,id_proveedor_cho_pedido,id_bomboneria)
)nested table lotes store as lotes_nt_1;

create table RESTRINCCIONES_POR_PAIS(
    id_restrinccion number,
    descripcion varchar2(250),
    id_pais number,
    id_proveedor_cho number,
    id_chocolate number,
    id_presentacion number,
    id_proveedor_cacao number,
    constraint pk_restrinciones primary key (id_restrinccion,id_pais),
    constraint fk1_res_pre foreign key (id_proveedor_cho,id_chocolate,id_presentacion) references PRESENTACION(id_presentacion,id_chocolate,id_proveedor_cho),
    constraint fk2_res_pro foreign key (id_proveedor_cacao) references PROVEEDOR_CACAO(id_proveedor_cacao),
    constraint arc_restrinccion check ( ((id_proveedor_cacao IS NOT NULL) AND (id_proveedor_cho IS NULL) AND (id_chocolate IS NULL) AND
             (id_presentacion IS NULL) )OR ((id_proveedor_cacao IS NULL) AND (id_proveedor_cho IS NOT NULL ) AND (id_chocolate IS NOT NULL) AND (id_presentacion IS NOT NULL)))


);

create table PROVEEDOR_TIPO_CACAO(
    id_proveedor_cho number,
    id_tipo_cacao number,
    constraint pk_pro_tipo primary key (id_proveedor_cho,id_tipo_cacao),
    constraint fk1_pro_tipo foreign key (id_proveedor_cho) references PROVEEDOR_CHOCOLATE(id_proveedor_cho),
    constraint fk2_pro_tipo foreign key (id_tipo_cacao) references TIPO_CACAO(id_tipocacao)
);


create table DETALLE_CONTRATO(
    id_contrato            number,
    id_proveedor_cacao_con number,
    id_bomboneria          number,
    volumen_peso_kg        real   not null,
    frecuencia_meses       number not null,
    envios                 envio_nt,
    id_proveedor_cacao_catafk      not null,
    id_tipocacaofk             not null,
    constraint pk_det_cont primary key (id_contrato, id_proveedor_cacao_con, id_bomboneria),
    constraint fk1_det_cont foreign key (id_contrato, id_proveedor_cacao_con, id_bomboneria) references CONTRATO (id_contrato, id_proveedor, id_bomboneria),
    constraint fk2_det_cont foreign key (id_proveedor_cacao_catafk, id_tipocacaofk) references CATALOGO_CACAO (id_proveedor_cacao, id_tipocacao)
)nested table envios store as envio_nt_1;


create table CONDICION_PAGO_ENV(
    id_condicion number,
    tipo varchar2(25) not null,
    porcen_recargoenvio number,
    cantcuotas number,
    contadoenvio varchar2(15),
    contadoanteenvio varchar2(15),
    id_proveedor_chofk number,
    id_proveedor_cacaofk number,
    constraint pk_condicion primary key (id_condicion),
    constraint fk_condicion1 foreign key (id_proveedor_chofk) references PROVEEDOR_CHOCOLATE(id_proveedor_cho),
    constraint fk_condicion2 foreign key (id_proveedor_cacaofk) references PROVEEDOR_CACAO(id_proveedor_cacao),
    constraint arco_condicion check ( ((id_proveedor_chofk is not null) and (id_proveedor_cacaofk is null ) )or(
                                      (id_proveedor_chofk is null) and (id_proveedor_cacaofk is not null )))


);










----- inserts manuales  -------------
insert into PAIS(id_pais, nombre) values (1,'venezuela');
insert into CIUDAD(id_ciudad, nombre, pais_id) values (1,'caracas',1);



insert into BOMBONERIA(id_bomboneria, nombre, logo, fecha_fun, direccion, horas_atencion, telefonos, email, dir_paginaweb, precioKg, precios_especiales, ciudad_id) values (1,'zisnella',bfilename('DIR_LOGO','img2.png'),TO_DATE('1989-12-09','YYYY-MM-DD'),null,null,null,null,null,12,null,1);
commit;
delete from BOMBONERIA where id_bomboneria = 1;
commit;

select * from BOMBONERIA;





