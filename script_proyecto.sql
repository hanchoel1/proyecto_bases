

------

-------Directorios blobs------

create or replace  directory Logos_bomboneria as 'C:\imagenes\logo_bomboneria\';
create or replace  directory Chocolates  as 'C:\imagenes\chocolates\';
create or replace  directory Logos_productor_cho as 'C:\imagenes\logo_productor_cho\';
create or replace  directory Logos_productor_cacao  as 'C:\imagenes\logo_productor_cacao\';

-------Permisos a usuarios desde system ------------

grant read, write on directory Logos_bomboneria to HANS;
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

create or replace type horario as object
(dia varchar2(20),
horai varchar(10),
horaf varchar(10));

create or replace type horarios_nt as table of horario;

create or replace type preciosesp as object
(ingrediente varchar2(50),
precio number);

create or replace type preciosesp_nt as table of preciosesp;


create or replace type votos as object
(total number,
 mes number,
 anios number);

create or replace type votos_nt as table of votos;
----- varrays--------

create or replace type telefonos_va as varray(3) of varchar2(25);
create or replace type ingredientes_va as varray(2) of varchar2(25);

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
  logo BFILE,
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

create table Catalogo_Bombones (
    id_bombon number,
    nombre_chocolate varchar2(50) not null ,
    tipo_chocolate varchar2(50) not null ,
    descripcion_bombon varchar2(150) not null ,
    nombre_coleccion varchar2(50),
    id_bomboneria number,
    img BFILE,
    ingredientes ingredientes_va,
    votos votos_nt,
    constraint pk_catalogo primary key (id_bombon),
    constraint fk_bomboneria foreign key (id_bomboneria) references BOMBONERIA(id_bomboneria)
)nested table votos store as  votos_nt_1;



