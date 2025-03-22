/*1. Obtener la cantidad total de votos por candidato*/
SELECT c.nombre_completo, SUM(v.cantidad) AS total_votos
FROM votos v
JOIN candidatos c ON v.candidato_id = c.documento
GROUP BY c.nombre_completo
ORDER BY total_votos ASC;

/*2. Listar los votantes de una mesa 3*/
SELECT v.documento, v.nombre_completo, v.apellidos, m.numero AS numero_mesa
FROM votantes v
JOIN mesas m ON v.mesa_id = m.id
WHERE m.numero = 3;

/*3. Mostrar el total de votos en cada ciudad*/ 
SELECT lv.ciudad, SUM(v.cantidad) AS total_votos
FROM votos v
JOIN mesas m ON v.mesa_id = m.id
JOIN lugares_votacion lv ON m.lugar_id = lv.id
GROUP BY lv.ciudad
ORDER BY total_votos ASC;

/*4. Obtener los candidatos que han recibido más de 40 votos*/
SELECT c.nombre_completo, SUM(v.cantidad) AS total_votos
FROM votos v
JOIN candidatos c ON v.candidato_id = c.documento
GROUP BY c.nombre_completo
HAVING SUM(v.cantidad) > 40;

/*5. Contar la cantidad de mesas por departamento*/ 
SELECT lv.departamento, COUNT(m.id) AS total_mesas
FROM mesas m
JOIN lugares_votacion lv ON m.lugar_id = lv.id
GROUP BY lv.departamento;

/*6. Listar los jurados que son presidentes de mesa*/ 
SELECT nombre_completo, apellidos, documento, mesa_id
FROM jurados_testigos
WHERE es_presidente = TRUE;

/* 7. Mostrar los responsables de partido y las mesas donde son apoderados*/
SELECT rp.nombre_completo, m.numero AS numero_mesa
FROM apoderados a
JOIN responsables_partido rp ON a.responsable_id = rp.rut
JOIN mesas m ON a.mesa_id = m.id;

/*8. Obtener el total de votantes registrados en el sistema*/
SELECT COUNT(*) AS total_votantes FROM votantes;

/*9. Listar los votantes nacidos después del año 1996*/
SELECT nombre_completo, apellidos, fecha_Nacimiento
FROM votantes
WHERE fecha_Nacimiento > '1996-01-01';

/*10. Mostrar los votantes que votan en Medellín*/ 
SELECT v.documento, v.nombre_completo, lv.nombre AS lugar_votacion, lv.ciudad
FROM votantes v
JOIN lugares_votacion lv ON v.puesto_votacion = lv.id
WHERE lv.ciudad = 'Medellín';

/*1. Mostrar combinaciones entre candidatos y lugares de votación*/ 
SELECT c.nombre_completo AS candidato, lv.nombre AS lugar_votacion
FROM candidatos c
CROSS JOIN lugares_votacion lv;

/* 2. Listar todas las combinaciones posibles entre votantes y jurados_testigos*/
SELECT v.nombre_completo AS votante, j.nombre_completo AS jurado
FROM votantes v
CROSS JOIN jurados_testigos j;

/*1. Vista que muestra los votos por candidato con el total de votos*/ 
CREATE VIEW vista_votos_por_candidato AS
SELECT c.nombre_completo, SUM(v.cantidad) AS total_votos
FROM votos v
JOIN candidatos c ON v.candidato_id = c.documento
GROUP BY c.nombre_completo;

SELECT * FROM vista_votos_por_candidato;

/*2. Vista que muestra los votantes junto con la mesa y ciudad donde votan*/
CREATE VIEW vista_votantes_mesas AS
SELECT v.documento, v.nombre_completo, v.apellidos, m.numero AS numero_mesa, lv.ciudad
FROM votantes v
JOIN mesas m ON v.mesa_id = m.id
JOIN lugares_votacion lv ON m.lugar_id = lv.id;

SELECT * FROM vista_votantes_mesas;

/*1. Evitar que se registren votos negativos*/ 
CREATE TRIGGER check_votos
BEFORE INSERT OR UPDATE ON votos
FOR EACH ROW
BEGIN
    IF NEW.cantidad < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad de votos no puede ser negativa';
    END IF;
END;

/*2. Actualizar automáticamente la cantidad total de votos por mesa en cada inserción*/ 
CREATE TRIGGER update_total_votos
AFTER INSERT ON votos
FOR EACH ROW
UPDATE mesas
SET numero = numero + NEW.cantidad
WHERE id = NEW.mesa_id;

/*1. Función que retorna el total de votos por un candidato */
CREATE OR REPLACE FUNCTION total_votos_candidato(candidato_id_param VARCHAR)
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COALESCE(SUM(cantidad), 0) INTO total
    FROM votos
    WHERE candidato_id = candidato_id_param;

    RETURN total;
END;
$$ LANGUAGE plpgsql;


/*2. Función que obtiene el número de votantes en una mesa específica*/ 
CREATE OR REPLACE FUNCTION total_votantes_mesa(mesa_id_param INT)
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*) INTO total
    FROM votantes
    WHERE mesa_id = mesa_id_param;

    RETURN total;
END;
$$ LANGUAGE plpgsql;


/*1. Procedimiento para obtener los votos por candidato en una mesa*/
CREATE OR REPLACE PROCEDURE obtener_votos_por_candidato(
    IN mesa_id_param INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Selecciona los votos por candidato en la mesa específica
    SELECT c.nombre_completo, v.candidato_id, SUM(v.cantidad) AS total_votos
    FROM votos v
    JOIN candidatos c ON v.candidato_id = c.documento
    WHERE v.mesa_id = mesa_id_param
    GROUP BY c.nombre_completo, v.candidato_id;
END;
$$;

/*2. Procedimiento para registrar un nuevo candidato*/
CREATE OR REPLACE PROCEDURE registrar_candidato(
    IN documento_param VARCHAR(20),
    IN nombre_completo_param VARCHAR(255),
    IN partido_param VARCHAR(100),
    IN departamento_param VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insertar el candidato en la tabla
    INSERT INTO candidatos (documento, nombre_completo, partido, departamento)
    VALUES (documento_param, nombre_completo_param, partido_param, departamento_param);
    
    -- Mensaje de confirmación
    RAISE NOTICE 'Candidato % registrado exitosamente.', nombre_completo_param;
END;
$$;


