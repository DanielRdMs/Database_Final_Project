--CREATE DATABASE University;
CREATE SCHEMA ingenieria;
CREATE SCHEMA "Ingenieria de Sistemas";
CREATE SCHEMA "Ingenieria Electronica";
CREATE SCHEMA "Ingenieria Mecanica";
CREATE SCHEMA "Ingenieria Ambiental";
CREATE SCHEMA "Ingenieria Industrial";
CREATE SCHEMA biblioteca;


set search_path = ingenieria, public;
----------------------------------------------------Profesores---------------------------------------------------------------
CREATE TABLE Profesores (
    id_p INT PRIMARY KEY,
    nom_p VARCHAR(100) NOT NULL,
    Profesion VARCHAR(50),
    tel_p INT 
);
COPY ingenieria.profesores (id_p,nom_p,Profesion,tel_p)
FROM 'C:\Users\Public\CSV-OK\Profesores.csv' CSV DELIMITER ';' HEADER;
----------------------------------------------------Carreras-----------------------------------------------------------------
CREATE TABLE Carreras (
    cod_carr int PRIMARY KEY,
    nom_carr VARCHAR(100) NOT NULL
);
COPY ingenieria.carreras (cod_carr, nom_carr)
FROM 'C:\Users\Public\CSV-OK\Carreras.csv' CSV DELIMITER ';' HEADER;

----------------------------------------------------Asignaturas--------------------------------------------------------------
CREATE TABLE Asignaturas (
    cod_a INT PRIMARY KEY,
    nom_a VARCHAR(100) NOT NULL,
    ih INT CHECK (ih >= 0),
    cred INT CHECK (cred >= 0)
);
COPY ingenieria.asignaturas (cod_a,nom_a,ih,cred)
FROM 'C:\Users\Public\CSV-OK\Asignaturas.csv' CSV DELIMITER ';' HEADER;
----------------------------------------------------Estudiantes--------------------------------------------------------------
set search_path = "Ingenieria de Sistemas", public;
CREATE TABLE Estudiantes (
    cod_e int PRIMARY KEY,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(150),
    tel_e VARCHAR(20),
    f_nac DATE,
    cod_carr INT,
    CONSTRAINT fk_estudiantes_carreras FOREIGN KEY (cod_carr) REFERENCES ingenieria.Carreras (cod_carr) ON DELETE CASCADE ON UPDATE CASCADE
);
-------------------------------------------------------Ingenieria Electronica------------------------------------------------
set search_path = "Ingenieria Electronica", public;
CREATE TABLE Estudiantes (
    cod_e int PRIMARY KEY,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(150),
    tel_e VARCHAR(20),
    f_nac DATE,
    cod_carr INT,
    CONSTRAINT fk_estudiantes_carreras FOREIGN KEY (cod_carr) REFERENCES ingenieria.Carreras (cod_carr) ON DELETE CASCADE ON UPDATE CASCADE
);
------------------------------------------------------Ingenieria Mecanica----------------------------------------------------
set search_path = "Ingenieria Mecanica", public;

CREATE TABLE Estudiantes (
    cod_e int PRIMARY KEY,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(150),
    tel_e VARCHAR(20),
    f_nac DATE,
    cod_carr INT,
    CONSTRAINT fk_estudiantes_carreras FOREIGN KEY (cod_carr) REFERENCES ingenieria.Carreras (cod_carr) ON DELETE CASCADE ON UPDATE CASCADE
);
-------------------------------------------------------Ingenieria Ambiental--------------------------------------------------
set search_path = "Ingenieria Ambiental", public;

CREATE TABLE Estudiantes (
    cod_e int PRIMARY KEY,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(150),
    tel_e VARCHAR(20),
    f_nac DATE,
    cod_carr INT,
    CONSTRAINT fk_estudiantes_carreras FOREIGN KEY (cod_carr) REFERENCES ingenieria.Carreras (cod_carr) ON DELETE CASCADE ON UPDATE CASCADE
);
----------------------------------------------------------Ingenieria Industria-----------------------------------------------
set search_path = "Ingenieria Industrial", public;

CREATE TABLE Estudiantes (
    cod_e int PRIMARY KEY,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(150),
    tel_e VARCHAR(20),
    f_nac DATE,
    cod_carr INT,
    CONSTRAINT fk_estudiantes_carreras FOREIGN KEY (cod_carr) REFERENCES ingenieria.Carreras (cod_carr) ON DELETE CASCADE ON UPDATE CASCADE
);

-----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Por carrera ------------------------------------------------
set search_path = "Ingenieria de Sistemas", public;
COPY Estudiantes (cod_e,nom_e,dir_e,tel_e,cod_carr,f_nac)
FROM 'C:\Users\Public\CSV-OK\Estudiantes_Sistemas.csv'DELIMITER ';' CSV HEADER;

set search_path = "Ingenieria Ambiental", public;
COPY Estudiantes (cod_e,nom_e,dir_e,tel_e,cod_carr,f_nac)
FROM 'C:\Users\Public\CSV-OK\Estudiantes_Ambiental.csv' DELIMITER ';' CSV HEADER;

set search_path = "Ingenieria Mecanica", public;
COPY Estudiantes (cod_e,nom_e,dir_e,tel_e,cod_carr,f_nac)
FROM 'C:\Users\Public\CSV-OK\Estudiantes_Mecanica.csv' DELIMITER ';' CSV HEADER;

set search_path = "Ingenieria Electronica", public;
COPY Estudiantes (cod_e,nom_e,dir_e,tel_e,cod_carr,f_nac)
FROM 'C:\Users\Public\CSV-OK\Estudiantes_Electronica.csv' DELIMITER ';' CSV HEADER;

set search_path = "Ingenieria Industrial", public;
COPY Estudiantes (cod_e,nom_e,dir_e,tel_e,cod_carr,f_nac)
FROM 'C:\Users\Public\CSV-OK\Estudiantes_Industrial.csv' DELIMITER ';' CSV HEADER;
-----------------------------------------------------------------------------------------------------------------------------
set search_path = Ingenieria, public;
CREATE VIEW estudiantes_fac as
SELECT * FROM "Ingenieria Ambiental".estudiantes
UNION 
SELECT * FROM "Ingenieria Electronica".estudiantes
UNION
SELECT * FROM "Ingenieria Mecanica".estudiantes
UNION
SELECT * FROM "Ingenieria de Sistemas".estudiantes
UNION
SELECT * FROM "Ingenieria Industrial".estudiantes
ORDER BY cod_e;


set search_path = Ingenieria, public;
CREATE Table estudiantes as
select * from estudiantes_fac 
order by cod_e;
ALTER TABLE estudiantes 
ADD PRIMARY KEY (cod_e),
add CONSTRAINT fk_estudiantes_carreras FOREIGN KEY (cod_carr) REFERENCES ingenieria.Carreras (cod_carr) ON DELETE CASCADE ON UPDATE CASCADE;
-----------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Imparte (
    id_p INT,
    cod_a INT,
    grupo VARCHAR(10),
    horario VARCHAR(50),
    PRIMARY KEY (id_p, cod_a, grupo),
    CONSTRAINT fk_imparte_profesores FOREIGN KEY (id_p) REFERENCES Profesores (id_p) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_imparte_asignaturas FOREIGN KEY (cod_a) REFERENCES Asignaturas (cod_a) ON DELETE CASCADE ON UPDATE CASCADE
);
COPY ingenieria.imparte (id_p,cod_a,grupo,horario)
FROM 'C:\Users\Public\CSV-OK\Imparte.csv' CSV DELIMITER ';' HEADER;
-----------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Inscribe (
    cod_e INT,
    id_p INT,
    cod_a INT,    
    grupo INT,
    n1 DECIMAL(2,1) CHECK (n1 >= 0 AND n1 <= 5),
    n2 DECIMAL(2,1) CHECK (n2 >= 0 AND n2 <= 5),
    n3 DECIMAL(2,1) CHECK (n3 >= 0 AND n3 <= 5),
    PRIMARY KEY (cod_e, cod_a, id_p, grupo),
    CONSTRAINT fk_inscribe_estudiantes FOREIGN KEY (cod_e) REFERENCES estudiantes (cod_e) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_inscribe_asignaturas FOREIGN KEY (cod_a) REFERENCES Asignaturas (cod_a) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_inscribe_profesores FOREIGN KEY (id_p) REFERENCES Profesores (id_p) ON DELETE CASCADE ON UPDATE CASCADE
);
COPY ingenieria.inscribe (cod_e,id_p,cod_a,grupo,n1,n2,n3)
FROM 'C:\Users\Public\CSV-OK\Inscribe.csv' CSV DELIMITER ';' HEADER;
-------------------------------------------------------- Biblioteca -------------------------------------------------

set search_path = biblioteca, public;

-- Aquí crea las tablas asociadas a la parte de la biblioteca (libros, autores, ejemplares, escribre, presta).
CREATE TABLE Libros (
    isbn int PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    edicion INT CHECK (edicion > 0)
);
COPY biblioteca.libros (isbn,titulo,edicion)
FROM 'C:\Users\Public\CSV-OK\Libros.csv' CSV DELIMITER ';' HEADER;

CREATE TABLE Autores (
    id_a INT PRIMARY KEY,
    nom_a VARCHAR(100) NOT NULL
);
COPY biblioteca.autores (id_a,nom_a)
FROM 'C:\Users\Public\CSV-OK\Autores.csv' CSV DELIMITER ';' HEADER;

CREATE TABLE Escribe (
    isbn INT,
    id_a INT,
    PRIMARY KEY (isbn, id_a),
    CONSTRAINT fk_escribe_libros FOREIGN KEY (isbn) REFERENCES Libros (isbn) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_escribe_autores FOREIGN KEY (id_a) REFERENCES Autores (id_a) ON DELETE CASCADE ON UPDATE CASCADE
);
COPY biblioteca.escribe (isbn,id_a)
FROM 'C:\Users\Public\CSV-OK\Escribe.csv' CSV DELIMITER ';' HEADER;

CREATE TABLE Ejemplares (
    num_ej INT,
    isbn INT,  
    PRIMARY KEY (isbn, num_ej),
    CONSTRAINT fk_ejemplares_libros FOREIGN KEY (isbn) REFERENCES Libros (isbn) ON DELETE CASCADE ON UPDATE CASCADE
);
COPY biblioteca.ejemplares (num_ej,isbn)
FROM 'C:\Users\Public\CSV-OK\Ejemplares.csv' CSV DELIMITER ';' HEADER;

CREATE TABLE Presta (
    cod_e INT,
    isbn INT,
    num_ej INT,
    fecha_p DATE,
    fecha_d DATE,
    PRIMARY KEY (cod_e, isbn, num_ej, fecha_p),
    CONSTRAINT fk_presta_estudiantes FOREIGN KEY (cod_e) REFERENCES ingenieria.estudiantes (cod_e) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_presta_ejemplares FOREIGN KEY (isbn, num_ej) REFERENCES Ejemplares (isbn, num_ej) ON DELETE CASCADE ON UPDATE CASCADE
);
COPY biblioteca.presta (cod_e,isbn,num_ej,fecha_p,fecha_d)
FROM 'C:\Users\Public\CSV-OK\Presta.csv' CSV DELIMITER ';' HEADER;

-----------------------------------------------------------------------------------------------------------------------------
set search_path = ingenieria, public;
CREATE TABLE Referencia (
    cod_a INT,
    isbn INT,
    PRIMARY KEY (cod_a, isbn),
    CONSTRAINT fk_referencia_asignaturas FOREIGN KEY (cod_a) REFERENCES Asignaturas (cod_a) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_referencia_libros FOREIGN KEY (isbn) REFERENCES biblioteca.Libros (isbn) ON DELETE CASCADE ON UPDATE CASCADE
);
COPY ingenieria.referencia (cod_a,isbn)
FROM 'C:\Users\Public\CSV-OK\Referencia.csv' CSV DELIMITER ';' HEADER;

/*

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- VISTAS -----------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
set search_path = ingenieria, public;

-- Vista que permite consultar la información del profesor
create view info_profesores as 
select *
from profesores
where id_p::text=current_user;
-- Aquí id_p::text=current_user compara si el valor de la columna id_p (convertido a texto) es igual 
-- al nombre del usuario actualmente conectado. Si es así, la fila correspondiente se incluirá en la vista info_profesores.

-- Vista que permite consultar la lista de estudiantes de sus cursos (para el profesor)
create view lista_estudiantes as
select cod_a, nom_a, grupo, cod_e, nom_e, n1, n2, n3, 
(COALESCE(n1,0)*.35+COALESCE(n2,0)*.35+COALESCE(n3,0)*.3)::real as definitiva
from estudiantes_fac natural join inscribe natural join asignaturas
where id_p::TEXT = current_user
order by cod_a, grupo, cod_e;

-- Aquí la función COALESCE() se usa para sustituir NULL por un 0.
-- Nótese que estudiantes_fac es una vista que reune a todos los estudiantes de la facultad de ingeniería.

-------------------------------------------------------- Biblioteca -------------------------------------------------

set search_path = biblioteca, public;

-- Vista para consultar la tabla escribe en la facultad de ingeniería
CREATE VIEW consulta_escribe AS
SELECT * from autores natural join libros natural join escribe
ORDER BY id_a,isbn;

---------------------------------------- Para usuario Admin (User postgres) -----------------------------------------

-- Estas vistas las definimos para el usuario Admin de la base de datos en general.
set search_path = ingenieria, public;

-- Vista para la lista de asignaturas con estudiantes
CREATE VIEW listado_facultad_asig AS
SELECT cod_a, nom_a, grupo, cod_e, nom_e FROM ingenieria.estudiantes_fac natural join ingenieria.inscribe natural join ingenieria.asignaturas
ORDER BY cod_a,nom_a,grupo;



---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- ROLES ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

-- Rol estudiantes
create role estudiantesIng;
grant usage on schema ingenieria to estudiantesIng;
grant select on ingenieria.notasEstud to estudiantesIng; -- notasEstud es una vista

-- Rol profesores
create role profesoresIng;
grant usage on schema ingenieria to profesoresIng; 
grant select, update (profesion, nom_p, dir_p, tel_p) on ingenieria.info_profesores to profesoresIng; -- infoProfesores es una vista

-------------------------------------------------------- Biblioteca -------------------------------------------------
set search_path = biblioteca, public;

create user bibliotecau with password 'bibliotecau';
grant usage on schema biblioteca to bibliotecau;
grant usage on schema ingenieria to bibliotecau;		  

GRANT SELECT ON ingenieria.estudiantes_fac TO bibliotecau;
GRANT SELECT ON biblioteca.presta TO bibliotecau;

GRANT USAGE ON SCHEMA biblioteca to profesoresIng;
GRANT SELECT ON biblioteca.autores TO profesoresIng;
GRANT SELECT ON biblioteca.libros TO profesoresIng;

GRANT USAGE ON SCHEMA biblioteca to estudiantesIng;
GRANT SELECT ON biblioteca.autores TO estudiantesIng;

---------------------------------------------------------------------------------------------------------------------
------------------------------------------ TRIGGERS Y PROCEDIMIENTOS ------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

-- Funcion para crear los usuarios de estudiantes
CREATE OR REPLACE FUNCTION crear_usuarios() RETURNS void AS
$BODY$
DECLARE f ingenieria.estudiantes_fac%rowtype;
DECLARE r ingenieria.profesores%rowtype;
BEGIN
	FOR f IN SELECT * FROM ingenieria.estudiantes_fac
	LOOP
		if (f.cod_e::text not in (select usename from pg_user)) then
			execute 'create user "'||f.cod_e||'" with password '||''''||f.cod_e||'''';
			execute 'grant estudiantesIng to "'||f.cod_e||'"'; 
		end if;
	END LOOP;
	FOR r IN SELECT * FROM ingenieria.profesores
	LOOP
		if (r.id_p::text not in (select usename from pg_user)) then
			execute 'create user "'||r.id_p||'" with password '||''''||r.id_p||'''';
			execute 'grant profesoresIng to "'||r.id_p||'"'; 
		end if;
	END LOOP;
RETURN;
END
$BODY$
LANGUAGE 'plpgsql' ;

-- Funcion que permite al profesor actualizar unicamente las notas de sus estudiantes 
create or replace function update_est() returns trigger as $update_est$
declare
begin
  update ingenieria.inscribe set 
  n1 = NEW.n1, n2 = NEW.n2, n3 = NEW.n3 
  where cod_e = OLD.cod_e and cod_a = OLD.cod_a and cod_e in (select cod_e from ingenieria.lista_estudiantes where id_p::text = current_user);
  RETURN NEW;
end;
$update_est$
language plpgsql;

-- Trigger asociado al update sobre inscribe
create trigger update_est_trg
instead of update on lista_estudiantes
for each row execute procedure update_est();
								 
-- Validacion insert en Inscribe
CREATE OR REPLACE FUNCTION insert_inscribe() RETURNS
TRIGGER AS $insert_inscribe$
BEGIN
	IF (new.cod_e in (select cod_e from ingenieria.estudiantes_fac)) THEN
		RETURN NEW;
	ELSE 
		RETURN NULL;
	END IF;
END;
$insert_inscribe$ LANGUAGE plpgsql;

-- Trigger asociado al insert en la tabla inscribe
CREATE TRIGGER insert_inscribe_trg BEFORE
UPDATE OR INSERT
ON inscribe FOR EACH row
EXECUTE PROCEDURE insert_inscribe();
		
--*************************************************--
					  
-- Ejecutar
set search_path = ingenieria, public;
select crear_usuarios();

*/