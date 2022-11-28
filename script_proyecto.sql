

-------Directorios blobs------
create or replace  directory Logos_bomboneria as 'C:\imagenes\';

-------Permisos a usuarios desde system ------------
grant read, write on directory Logos_bomboneria to HANS;


-------Create  types---------
create or replace type dir as object
(calle varchar2(50),
local varchar2(25),
edificio varchar2(25),
numero number,
urbanizacion varchar2(50)
);

create or replace type horario as object
(dia varchar2(20),
horai varchar(10),
horaf varchar(10));

create or replace type horarios_nt as table of horario;

create or replace type telefonos_va as varray(3) of varchar2(25);


create or replace type preciosesp as object
(ingrediente varchar2(50),
precio number);

create or replace type preciosesp_nt as table of preciosesp;


------- CREATE TABLES---------
create table Pais(
    id_pais number,
    nombre  varchar2(50),
    constraint pk_pais primary key (id_pais)
);

create table Ciudad(
    id_ciudad number,
    nombre  varchar2(50),
    pais_id   number,
    constraint pk_ciudad primary key (id_ciudad),
    constraint fk_pais foreign key (pais_id) references Pais(id_pais)
);

create table Bomboneria (
  id_bomboneria number,
  nombre varchar2(100) not null ,
  logo BLOB DEFAULT empty_blob(),
  fecha_fun date not null ,
  direccion dir not null ,
  horas_atencion horarios_nt,
  telefonos telefonos_va,
  email varchar2(50),
  dir_paginaweb varchar2(100),
  precioKg number,
  precios_especiales preciosesp_nt,
  ciudad_id number,
  constraint fk_ciudad Foreign Key (ciudad_id) references Ciudad(id_ciudad),
  constraint pk_bomboneria primary key (id_bomboneria)
)nested table horas_atencion store as horarios_nt_1
 nested table precios_especiales store as preciosesp_nt_1;




