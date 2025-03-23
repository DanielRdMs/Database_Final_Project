-- Active: 1717168467874@@127.0.0.1@5432@universidad
-- DROP DATABASE IF EXISTS universidad;
-- DROP SCHEMA ingenieria CASCADE;
-- CREATE DATABASE universidad;

CREATE SCHEMA ingenieria;

SHOW search_path;

SET search_path TO ingenieria;

CREATE TABLE Carreras (
    cod_carr int PRIMARY KEY,
    nom_carr VARCHAR(100) NOT NULL
);

CREATE TABLE Estudiantes (
    cod_e int PRIMARY KEY,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(150),
    tel_e VARCHAR(20),
    f_nac DATE,
    cod_carr INT,
    CONSTRAINT fk_estudiantes_carreras FOREIGN KEY (cod_carr) REFERENCES Carreras (cod_carr) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Asignaturas (
    cod_a INT PRIMARY KEY,
    nom_a VARCHAR(100) NOT NULL,
    ih INT CHECK (ih >= 0),
    cred INT CHECK (cred >= 0)
);

CREATE TABLE Profesores (
    id_p INT PRIMARY KEY,
    nom_p VARCHAR(100) NOT NULL,
    Profesion VARCHAR(50),
    tel_p INT 
);

CREATE TABLE Libros (
    isbn int PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    edicion INT CHECK (edicion > 0)
);

CREATE TABLE Autores (
    id_a INT PRIMARY KEY,
    nom_a VARCHAR(100) NOT NULL
);

CREATE TABLE Escribe (
    isbn INT,
    id_a INT,
    PRIMARY KEY (isbn, id_a),
    CONSTRAINT fk_escribe_libros FOREIGN KEY (isbn) REFERENCES Libros (isbn) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_escribe_autores FOREIGN KEY (id_a) REFERENCES Autores (id_a) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Ejemplares (
    num_ej INT,
    isbn INT,  
    PRIMARY KEY (isbn, num_ej),
    CONSTRAINT fk_ejemplares_libros FOREIGN KEY (isbn) REFERENCES Libros (isbn) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Imparte (
    id_p INT,
    cod_a INT,
    grupo VARCHAR(10),
    horario VARCHAR(50),
    PRIMARY KEY (id_p, cod_a, grupo),
    CONSTRAINT fk_imparte_profesores FOREIGN KEY (id_p) REFERENCES Profesores (id_p) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_imparte_asignaturas FOREIGN KEY (cod_a) REFERENCES Asignaturas (cod_a) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Inscribe (
    cod_e INT,
    id_p INT,
    cod_a INT,    
    grupo VARCHAR(10),
    n1 DECIMAL(2,1) CHECK (n1 >= 0 AND n1 <= 5),
    n2 DECIMAL(2,1) CHECK (n2 >= 0 AND n2 <= 5),
    n3 DECIMAL(2,1) CHECK (n3 >= 0 AND n3 <= 5),
    PRIMARY KEY (cod_e, cod_a, id_p, grupo),
    CONSTRAINT fk_inscribe_estudiantes FOREIGN KEY (cod_e) REFERENCES Estudiantes (cod_e) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_inscribe_asignaturas FOREIGN KEY (cod_a) REFERENCES Asignaturas (cod_a) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_inscribe_profesores FOREIGN KEY (id_p) REFERENCES Profesores (id_p) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Presta (
    cod_e INT,
    isbn INT,
    num_ej INT,
    fecha_p DATE,
    fecha_d DATE,
    PRIMARY KEY (cod_e, isbn, num_ej, fecha_p),
    CONSTRAINT fk_presta_estudiantes FOREIGN KEY (cod_e) REFERENCES Estudiantes (cod_e) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_presta_ejemplares FOREIGN KEY (isbn, num_ej) REFERENCES Ejemplares (isbn, num_ej) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Referencia (
    cod_a INT,
    isbn INT,
    PRIMARY KEY (cod_a, isbn),
    CONSTRAINT fk_referencia_asignaturas FOREIGN KEY (cod_a) REFERENCES Asignaturas (cod_a) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_referencia_libros FOREIGN KEY (isbn) REFERENCES Libros (isbn) ON DELETE CASCADE ON UPDATE CASCADE
);


------------------------------------------------------Inseción de datos-----------------------------------------------------
--Carreras
COPY ingenieria.carreras (cod_carr, nom_carr)
FROM 'C:\Users\Public\CSV-OK\Carreras.csv' CSV DELIMITER ';' HEADER;

--Estudiantes
COPY ingenieria.estudiantes (cod_e,nom_e,dir_e,tel_e,cod_carr,f_nac)
FROM 'C:\Users\Public\CSV-OK\Estudiantes.csv' CSV DELIMITER ';' HEADER;

--Asignaturas
COPY ingenieria.asignaturas (cod_a,nom_a,ih,cred)
FROM 'C:\Users\Public\CSV-OK\Asignaturas.csv' CSV DELIMITER ';' HEADER;

--Profesores
COPY ingenieria.profesores (id_p,nom_p,Profesion,tel_p)
FROM 'C:\Users\Public\CSV-OK\Profesores.csv' CSV DELIMITER ';' HEADER;

--Libros
COPY ingenieria.libros (isbn,titulo,edicion)
FROM 'C:\Users\Public\CSV-OK\Libros.csv' CSV DELIMITER ';' HEADER;

--Autores
COPY ingenieria.autores (id_a,nom_a)
FROM 'C:\Users\Public\CSV-OK\Autores.csv' CSV DELIMITER ';' HEADER;

--Escribe
COPY ingenieria.escribe (isbn,id_a)
FROM 'C:\Users\Public\CSV-OK\Escribe.csv' CSV DELIMITER ';' HEADER;

--Ejemplares
COPY ingenieria.ejemplares (num_ej,isbn)
FROM 'C:\Users\Public\CSV-OK\Ejemplares.csv' CSV DELIMITER ';' HEADER;

--Imparte
COPY ingenieria.imparte (id_p,cod_a,grupo,horario)
FROM 'C:\Users\Public\CSV-OK\Imparte.csv' CSV DELIMITER ';' HEADER;

--Inscribe
COPY ingenieria.inscribe (cod_e,id_p,cod_a,grupo,n1,n2,n3)
FROM 'C:\Users\Public\CSV-OK\Inscribe.csv' CSV DELIMITER ';' HEADER;

--Presta
COPY ingenieria.presta (cod_e,isbn,num_ej,fecha_p,fecha_d)
FROM 'C:\Users\Public\CSV-OK\Presta.csv' CSV DELIMITER ';' HEADER;

--Referencia
COPY ingenieria.referencia (cod_a,isbn)
FROM 'C:\Users\Public\CSV-OK\Referencia.csv' CSV DELIMITER ';' HEADER;