-- Active: 1717168467874@@127.0.0.1@5432@universidad


-- 1. Si cada crédito se asocia a 16 horas en las 16 semanas de clase, liste las asignaturas que guardan esa proporción. 

SELECT * 
FROM ingenieria.asignaturas  
WHERE ih * 16 = cred * 16;

-- 2. Listado de estudiantes que no inscribieron materias.

SELECT E.* 
FROM ingenieria.estudiantes E
LEFT JOIN ingenieria.inscribe I ON E.cod_e = I.cod_e
WHERE I.cod_e IS NULL;

-- 3. Liste los libros que ha sacado en préstamo Estudiante 8. 

SELECT L.*
FROM ingenieria.libros L
JOIN ingenieria.presta P ON L.isbn = P.isbn
JOIN ingenieria.estudiantes E ON P.cod_e = E.cod_e
WHERE E.nom_e = 'Estudiante 8';

-- 4. Liste las asignaturas que toma el Estudiante 8.

SELECT A.*
FROM ingenieria.asignaturas A
JOIN ingenieria.inscribe I ON A.cod_a = I.cod_a
JOIN ingenieria.estudiantes E ON I.cod_e = E.cod_e
WHERE E.nom_e = 'Estudiante 8';

-- 5. Liste las asignaturas donde la peor nota de un estudiante haya sido 2.5. 

SELECT *
FROM ingenieria.asignaturas A
NATURAL JOIN ingenieria.inscribe I
WHERE LEAST (I.n1, I.n2, I.n3) = 2.5;

-- 6. Liste los estudiantes que no han devuelto libros prestados. 

SELECT DISTINCT E.cod_e, E.nom_e
FROM ingenieria.estudiantes E
JOIN ingenieria.presta P ON E.cod_e = P.cod_e
WHERE P.fecha_d IS NULL;

-- 7. Liste los libros que no han sido prestados y que son referenciados por asignaturas. 

SELECT L.*
FROM ingenieria.libros L
JOIN ingenieria.referencia R ON L.isbn = R.isbn
LEFT JOIN ingenieria.presta P ON L.isbn = P.isbn
WHERE P.isbn IS NULL;

-- 8. Nombre de los estudiantes y asignatura de aquellos que pasaron el examen, pero que perdieron la asignatura. 

SELECT
    E.nom_e AS Nombre_Estudiante,
    A.nom_a AS Nombre_Asignatura
FROM
    ingenieria.inscribe I
JOIN
    ingenieria.estudiantes E ON I.cod_e = E.cod_e
JOIN
    ingenieria.asignaturas A ON I.cod_a = A.cod_a
WHERE
    I.n3 >= 3.0 AND
    ((I.n1*0.3) + (I.n2*0.3) + (I.n3*0.4)) < 3.0;

-- 9. Determine cuáles son los estudiantes que aprobaron todas las asignaturas que inscribieron. 

SELECT E.nom_e 
FROM ingenieria.estudiantes E 
JOIN ingenieria.inscribe I ON E.cod_e = I.cod_e 
GROUP BY E.cod_e 
HAVING MIN((I.n1*0.3) + (I.n2*0.3) + (I.n3*0.4)) > 2.9;

-- 10. Liste los libros y su respectiva asignatura que los referencia, de aquellos libros que no se han prestado.

SELECT L.titulo, A.nom_a 
FROM ingenieria.libros L 
JOIN ingenieria.Referencia R ON L.isbn = R.isbn 
JOIN ingenieria.asignaturas A ON R.cod_a = A.cod_a 
LEFT JOIN ingenieria.presta P ON L.isbn = P.isbn 
WHERE P.isbn IS NULL;

-- 11. Quiénes tienen la nota más alta en Bases de Datos.

SELECT E.nom_e 
FROM ingenieria.inscribe I 
JOIN ingenieria.estudiantes E ON I.cod_e = E.cod_e 
JOIN ingenieria.asignaturas A ON I.cod_a = A.cod_a 
WHERE A.nom_a = 'Diseño de Bases de Datos' 
ORDER BY GREATEST(I.n1, I.n2, I.n3) DESC;

-- 12. Quienes tienen la nota más baja de todas, en qué asignatura y con cuál profesor.

SELECT E.nom_e, A.nom_a, P.nom_p, LEAST(I.n1, I.n2, I.n3) AS nota_minima 
FROM ingenieria.inscribe I 
JOIN ingenieria.estudiantes E ON I.cod_e = E.cod_e 
JOIN ingenieria.asignaturas A ON I.cod_a = A.cod_a 
JOIN ingenieria.profesores P ON I.id_p = P.id_p 
ORDER BY nota_minima ASC;

-- 13. Quién es el estudiante que más libros diferentes ha sacado en préstamo. 

SELECT E.nom_e 
FROM ingenieria.presta P 
JOIN ingenieria.estudiantes E ON P.cod_e = E.cod_e 
GROUP BY E.cod_e 
ORDER BY COUNT(DISTINCT P.isbn) DESC 
LIMIT 1;

-- 14. Cuál es el profesor con el mayor porcentaje de pérdida por parte de sus estudiantes.

SELECT Profesores.nom_p, (SUM(CASE WHEN ((inscribe.n1*0.3) + (inscribe.n2*0.3) + (inscribe.n3*0.4)) < 3.0 THEN 1 ELSE 0 END) * 100.0 / COUNT(Inscribe.cod_e))
	AS porcentaje_perdida FROM ingenieria.profesores
JOIN ingenieria.imparte ON Profesores.id_p = Imparte.id_p
JOIN ingenieria.inscribe ON Imparte.id_p = Inscribe.id_p AND Imparte.cod_a = Inscribe.cod_a AND Imparte.grupo = Inscribe.grupo
GROUP BY Profesores.nom_p
ORDER BY porcentaje_perdida DESC
LIMIT 1;

-- 15. Nombre del autor referenciado por más asignaturas diferentes.
	
SELECT Autores.nom_a, COUNT(DISTINCT Referencia.cod_a) AS num_asignaturas FROM ingenieria.autores
JOIN ingenieria.escribe ON Autores.id_a = Escribe.id_a
JOIN ingenieria.libros ON Escribe.isbn = Libros.isbn
JOIN ingenieria.referencia ON Libros.isbn = Referencia.isbn
GROUP BY Autores.nom_a
ORDER BY num_asignaturas DESC
LIMIT 1;

-- 16. Nombre de los estudiantes que tienen el promedio de notas mayor a 4.0.

SELECT Estudiantes.nom_e FROM ingenieria.estudiantes
JOIN ingenieria.inscribe ON Estudiantes.cod_e = Inscribe.cod_e
GROUP BY Estudiantes.nom_e
HAVING AVG((inscribe.n1*0.3) + (inscribe.n2*0.3) + (inscribe.n3*0.4)) > 4.0;

-- 17. Cuál es el libro que más veces se ha prestado.
	
SELECT Libros.titulo, COUNT(*) AS num_prestamos FROM ingenieria.libros
JOIN ingenieria.presta ON Libros.isbn = Presta.isbn
GROUP BY Libros.titulo
ORDER BY num_prestamos DESC
LIMIT 1;

-- 18. Título del libro con mayor cantidad de ejemplares.

SELECT Libros.titulo, COUNT(*) AS num_ejemplares FROM ingenieria.libros
JOIN ingenieria.ejemplares ON Libros.isbn = Ejemplares.isbn
GROUP BY Libros.titulo
ORDER BY num_ejemplares DESC
LIMIT 1;

-- 19. Cuál es el profesor que imparte más asignaturas diferentes.

SELECT Profesores.nom_p, COUNT(DISTINCT Imparte.cod_a) AS num_asignaturas FROM ingenieria.profesores
JOIN ingenieria.imparte ON Profesores.id_p = Imparte.id_p
GROUP BY Profesores.nom_p
ORDER BY num_asignaturas DESC
LIMIT 1;

-- 20.Liste los estudiantes que pertenecen al grupo que tiene el mejor promedio de todos.

SELECT Estudiantes.cod_e, Estudiantes.nom_e FROM ingenieria.inscribe
JOIN ingenieria.estudiantes ON Inscribe.cod_e = Estudiantes.cod_e
WHERE Inscribe.grupo = (
    SELECT grupo FROM ingenieria.inscribe
    GROUP BY grupo
    ORDER BY AVG((inscribe.n1*0.3) + (inscribe.n2*0.3) + (inscribe.n3*0.4)) DESC
    LIMIT 1);

-- 21.Cuál es la carrera con el mayor porcentaje de estudiantes que pierden alguna asignatura.

SELECT Carreras.nom_carr, 
	(SUM(CASE WHEN ((inscribe.n1*0.3) + (inscribe.n2*0.3) + (inscribe.n3*0.4)) < 3.0 THEN 1 ELSE 0 END) * 100.0 / COUNT(Estudiantes.cod_e)) 
	AS porcentaje_perdida FROM ingenieria.carreras
JOIN ingenieria.estudiantes ON Carreras.cod_carr = Estudiantes.cod_carr
JOIN ingenieria.inscribe ON Estudiantes.cod_e = Inscribe.cod_e
GROUP BY Carreras.nom_carr
ORDER BY porcentaje_perdida DESC
LIMIT 1;

-- 22. Nombre del profesor que tiene el mayor número de estudiantes que ve simultáneamente más de una asignatura con él.

SELECT Profesores.nom_p, COUNT(DISTINCT Inscribe.cod_e) AS num_estudiantes FROM ingenieria.profesores
JOIN ingenieria.imparte ON Profesores.id_p = Imparte.id_p
JOIN ingenieria.inscribe ON Imparte.cod_a = Inscribe.cod_a AND Imparte.grupo = Inscribe.grupo
WHERE Inscribe.cod_e IN (
    SELECT cod_e FROM ingenieria.inscribe
    WHERE id_p = Profesores.id_p
    GROUP BY cod_e
    HAVING COUNT(DISTINCT cod_a) > 1
)
GROUP BY Profesores.nom_p
ORDER BY num_estudiantes DESC
LIMIT 1;

-- 23. Cuál asignatura tiene el promedio más bajo por grupo en la carrera de Ingeniería de Sistemas. 
-- Asuma que si hay estudiantes de Ingeniería de Sistemas el grupo es de Ingeniería de Sistemas.

SELECT Asignaturas.nom_a, Imparte.grupo, AVG((Inscribe.n1 + Inscribe.n2 + Inscribe.n3) / 3.0) 
	AS promedio_grupo FROM ingenieria.asignaturas
JOIN ingenieria.inscribe ON Asignaturas.cod_a = Inscribe.cod_a
JOIN ingenieria.estudiantes ON Inscribe.cod_e = Estudiantes.cod_e
JOIN ingenieria.carreras ON Estudiantes.cod_carr = Carreras.cod_carr
JOIN ingenieria.imparte ON Inscribe.cod_a = Imparte.cod_a AND Inscribe.grupo = Imparte.grupo
WHERE Carreras.nom_carr = 'Ingeniería de Sistemas'
GROUP BY Asignaturas.nom_a, Imparte.grupo
ORDER BY promedio_grupo ASC
LIMIT 1;

-- 24. Liste los estudiantes que son más exitosos (pasaron todas las asignaturas y tienen el mejor promedio) 
-- incluyendo la carrera a la que pertenece.

SELECT Estudiantes.cod_e, Estudiantes.nom_e, Carreras.nom_carr, AVG((Inscribe.n1 + Inscribe.n2 + Inscribe.n3) / 3.0) 
	AS promedio FROM ingenieria.estudiantes
JOIN ingenieria.inscribe ON Estudiantes.cod_e = Inscribe.cod_e
JOIN ingenieria.carreras ON Estudiantes.cod_carr = Carreras.cod_carr
GROUP BY Estudiantes.cod_e, Estudiantes.nom_e, Carreras.nom_carr
HAVING MIN((Inscribe.n1 + Inscribe.n2 + Inscribe.n3) / 3.0) >= 3.0
ORDER BY promedio DESC
LIMIT 1;

-- 25. Liste los profesores que sólo imparten asignaturas a estudiantes de una sola carrera. 
-- Incluya el nombre de la carrera a la lista.

SELECT Profesores.nom_p, Carreras.nom_carr FROM ingenieria.profesores
JOIN ingenieria.imparte ON Profesores.id_p = Imparte.id_p
JOIN ingenieria.inscribe ON Imparte.cod_a = Inscribe.cod_a AND Imparte.grupo = Inscribe.grupo
JOIN ingenieria.estudiantes ON Inscribe.cod_e = Estudiantes.cod_e
JOIN ingenieria.carreras ON Estudiantes.cod_carr = Carreras.cod_carr
GROUP BY Profesores.nom_p, Carreras.nom_carr
HAVING COUNT(DISTINCT Estudiantes.cod_carr) = 1;