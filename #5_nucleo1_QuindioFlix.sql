-- ============================================================
-- QUINDIOFLIX - NÚCLEO 1: CONSULTAS AVANZADAS Y ALMACENAMIENTO
-- Universidad del Quindío - Bases de Datos II
-- Resultado de Aprendizaje: R.A.1
-- ============================================================

-- ============================================================
-- SECCIÓN 1: CONSULTAS PARAMETRIZADAS
-- Uso de variables de sustitución (&, &&, DEFINE)
-- para recibir parámetros del usuario en tiempo de ejecución.
-- ============================================================

-- ------------------------------------------------------------
-- 1.1 Top 10 de contenido más reproducido en una ciudad
-- Parámetro: nombre de la ciudad (Ej: Bogotá, Medellín, Cali)
-- Uso: ejecutar en SQL*Plus o SQL Developer con sustitución
-- ------------------------------------------------------------
SELECT *
FROM (
    SELECT
        c.titulo,
        c.tipo_contenido,
        ci.nombre              AS ciudad,
        COUNT(r.id_reproduccion) AS total_reproducciones,
        ROUND(AVG(r.avance_porcentaje), 2) AS promedio_avance
    FROM REPRODUCCION  r
    JOIN PERFIL        p  ON r.id_perfil    = p.id_perfil
    JOIN USUARIO       u  ON p.id_usuario   = u.id_usuario
    JOIN CIUDAD        ci ON u.id_ciudad    = ci.id_ciudad
    JOIN CONTENIDO     c  ON r.id_contenido = c.id_contenido
    WHERE UPPER(ci.nombre) = UPPER('&nombre_ciudad')
    GROUP BY c.titulo, c.tipo_contenido, ci.nombre
    ORDER BY total_reproducciones DESC
)
WHERE ROWNUM <= 10;

-- ------------------------------------------------------------
-- 1.2 Ingresos por plan de suscripción en un mes y año dado
-- Parámetros: mes (número 1-12) y año (ej: 2026)
-- Uso: &&mes y &&anio usan el mismo valor si se repite
-- ------------------------------------------------------------
DEFINE mes  = &mes_consulta
DEFINE anio = &anio_consulta

SELECT
    pl.nombre                    AS plan,
    COUNT(pg.id_pago)            AS total_pagos,
    SUM(pg.monto)                AS ingresos_totales,
    ROUND(AVG(pg.monto), 2)      AS ingreso_promedio
FROM PAGO pg
JOIN USUARIO u ON pg.id_usuario = u.id_usuario
JOIN PLAN    pl ON u.id_plan    = pl.id_plan
WHERE EXTRACT(MONTH FROM pg.fecha) = &&mes
  AND EXTRACT(YEAR  FROM pg.fecha) = &&anio
  AND pg.estado = 'EXITOSO'
GROUP BY pl.nombre
ORDER BY ingresos_totales DESC;

-- ------------------------------------------------------------
-- 1.3 Calificación promedio por tipo de contenido para un género
-- Parámetro: nombre del género (ej: Terror, Romance, Comedia)
-- ------------------------------------------------------------
SELECT
    c.tipo_contenido,
    g.nombre                    AS genero,
    COUNT(ca.id_calificacion)   AS total_calificaciones,
    ROUND(AVG(ca.estrellas), 2) AS promedio_estrellas,
    MIN(ca.estrellas)           AS min_estrellas,
    MAX(ca.estrellas)           AS max_estrellas
FROM CALIFICACION   ca
JOIN CONTENIDO      c  ON ca.id_contenido = c.id_contenido
JOIN CONTENIDO_GENERO cg ON c.id_contenido = cg.id_contenido
JOIN GENERO         g  ON cg.id_genero    = g.id_genero
WHERE UPPER(g.nombre) = UPPER('&nombre_genero')
GROUP BY c.tipo_contenido, g.nombre
ORDER BY promedio_estrellas DESC;

-- ============================================================
-- SECCIÓN 2: TABLAS DE REFERENCIAS CRUZADAS — PIVOT Y UNPIVOT
-- ============================================================

-- ------------------------------------------------------------
-- 2.1 PIVOT: Usuarios activos por ciudad y plan de suscripción
-- Filas = ciudades | Columnas = planes (Básico, Estándar, Premium)
-- ------------------------------------------------------------
SELECT *
FROM (
    SELECT
        ci.nombre  AS ciudad,
        pl.nombre  AS plan,
        u.id_usuario
    FROM USUARIO u
    JOIN CIUDAD  ci ON u.id_ciudad = ci.id_ciudad
    JOIN PLAN    pl ON u.id_plan   = pl.id_plan
    WHERE u.estado_cuenta = 'ACTIVO'
)
PIVOT (
    COUNT(id_usuario)
    FOR plan IN (
        'Básico'   AS "BASICO",
        'Estándar' AS "ESTANDAR",
        'Premium'  AS "PREMIUM"
    )
)
ORDER BY ciudad;

-- ------------------------------------------------------------
-- 2.2 PIVOT: Total de reproducciones por tipo de contenido y dispositivo
-- Filas = tipo de contenido | Columnas = dispositivos
-- ------------------------------------------------------------
SELECT *
FROM (
    SELECT
        c.tipo_contenido,
        r.dispositivo,
        r.id_reproduccion
    FROM REPRODUCCION r
    JOIN CONTENIDO    c ON r.id_contenido = c.id_contenido
)
PIVOT (
    COUNT(id_reproduccion)
    FOR dispositivo IN (
        'CELULAR'    AS "CELULAR",
        'TABLET'     AS "TABLET",
        'TV'         AS "TV",
        'COMPUTADOR' AS "COMPUTADOR"
    )
)
ORDER BY tipo_contenido;

-- ------------------------------------------------------------
-- 2.3 UNPIVOT: Convertir columnas de dispositivos de vuelta a filas
-- (inverso del PIVOT anterior — útil para análisis posterior)
-- ------------------------------------------------------------
SELECT tipo_contenido, dispositivo, total_reproducciones
FROM (
    SELECT *
    FROM (
        SELECT
            c.tipo_contenido,
            r.dispositivo,
            r.id_reproduccion
        FROM REPRODUCCION r
        JOIN CONTENIDO    c ON r.id_contenido = c.id_contenido
    )
    PIVOT (
        COUNT(id_reproduccion)
        FOR dispositivo IN (
            'CELULAR'    AS "CELULAR",
            'TABLET'     AS "TABLET",
            'TV'         AS "TV",
            'COMPUTADOR' AS "COMPUTADOR"
        )
    )
)
UNPIVOT (
    total_reproducciones
    FOR dispositivo IN (
        "CELULAR"    AS 'CELULAR',
        "TABLET"     AS 'TABLET',
        "TV"         AS 'TV',
        "COMPUTADOR" AS 'COMPUTADOR'
    )
)
ORDER BY tipo_contenido, dispositivo;

-- ============================================================
-- SECCIÓN 3: FUNCIONES AVANZADAS DEL GROUP BY
-- ROLLUP, CUBE y GROUPING SETS
-- ============================================================

-- ------------------------------------------------------------
-- 3.1 ROLLUP: Ingresos por ciudad y plan con subtotales y gran total
-- Genera: detalle (ciudad+plan) → subtotal por ciudad → gran total
-- ------------------------------------------------------------
SELECT
    NVL(ci.nombre,  'TOTAL GENERAL') AS ciudad,
    NVL(pl.nombre,  'TODOS LOS PLANES') AS plan,
    COUNT(pg.id_pago)   AS cantidad_pagos,
    SUM(pg.monto)       AS ingresos_totales,
    GROUPING(ci.nombre) AS es_subtotal_ciudad,  -- 1 cuando es subtotal
    GROUPING(pl.nombre) AS es_gran_total        -- 1 cuando es gran total
FROM PAGO    pg
JOIN USUARIO u  ON pg.id_usuario = u.id_usuario
JOIN CIUDAD  ci ON u.id_ciudad   = ci.id_ciudad
JOIN PLAN    pl ON u.id_plan     = pl.id_plan
WHERE pg.estado = 'EXITOSO'
GROUP BY ROLLUP(ci.nombre, pl.nombre)
ORDER BY
    GROUPING(ci.nombre),
    ci.nombre NULLS LAST,
    GROUPING(pl.nombre),
    pl.nombre NULLS LAST;

-- ------------------------------------------------------------
-- 3.2 CUBE: Reproducciones por tipo de contenido y dispositivo
-- Genera TODAS las combinaciones posibles de agrupación:
-- detalle, por tipo, por dispositivo, gran total
-- ------------------------------------------------------------
SELECT
    NVL(c.tipo_contenido, 'TODOS LOS TIPOS') AS tipo_contenido,
    NVL(r.dispositivo,    'TODOS LOS DISP.') AS dispositivo,
    COUNT(r.id_reproduccion)                 AS total_reproducciones,
    ROUND(AVG(r.avance_porcentaje), 2)       AS promedio_avance,
    GROUPING(c.tipo_contenido) AS g_tipo,
    GROUPING(r.dispositivo)    AS g_disp
FROM REPRODUCCION r
JOIN CONTENIDO    c ON r.id_contenido = c.id_contenido
GROUP BY CUBE(c.tipo_contenido, r.dispositivo)
ORDER BY
    GROUPING(c.tipo_contenido),
    c.tipo_contenido NULLS LAST,
    GROUPING(r.dispositivo),
    r.dispositivo NULLS LAST;

-- ------------------------------------------------------------
-- 3.3 GROUPING SETS: Solo totales por tipo de contenido y por ciudad
-- Sin el detalle cruzado — más limpio para reportes ejecutivos
-- ------------------------------------------------------------
SELECT
    NVL(c.tipo_contenido, '—') AS tipo_contenido,
    NVL(ci.nombre,         '—') AS ciudad,
    COUNT(r.id_reproduccion)   AS total_reproducciones,
    CASE
        WHEN GROUPING(c.tipo_contenido) = 0 AND GROUPING(ci.nombre) = 1
            THEN 'SUBTOTAL POR TIPO'
        WHEN GROUPING(c.tipo_contenido) = 1 AND GROUPING(ci.nombre) = 0
            THEN 'SUBTOTAL POR CIUDAD'
        ELSE 'DETALLE'
    END AS nivel_agrupacion
FROM REPRODUCCION r
JOIN CONTENIDO    c  ON r.id_contenido = c.id_contenido
JOIN PERFIL       p  ON r.id_perfil    = p.id_perfil
JOIN USUARIO      u  ON p.id_usuario   = u.id_usuario
JOIN CIUDAD       ci ON u.id_ciudad    = ci.id_ciudad
GROUP BY GROUPING SETS (
    (c.tipo_contenido),   -- Total por tipo de contenido
    (ci.nombre)           -- Total por ciudad
)
ORDER BY nivel_agrupacion, tipo_contenido, ciudad;

-- ============================================================
-- SECCIÓN 4: VISTAS MATERIALIZADAS
-- Precalculan resultados costosos para acelerar reportes.
-- Requieren permisos: GRANT CREATE MATERIALIZED VIEW TO usuario;
-- ============================================================

-- ------------------------------------------------------------
-- 4.1 Vista materializada: Popularidad por contenido
-- Precalcula total de reproducciones y calificación promedio.
-- Base para el reporte "Contenido Más Popular".
-- Se refresca bajo demanda (ON DEMAND) para control manual.
-- ------------------------------------------------------------
CREATE MATERIALIZED VIEW MV_POPULARIDAD_CONTENIDO
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    c.id_contenido,
    c.titulo,
    c.tipo_contenido,
    c.clasificacion_edad,
    c.es_original,
    COUNT(DISTINCT r.id_reproduccion)      AS total_reproducciones,
    COUNT(DISTINCT ca.id_calificacion)     AS total_calificaciones,
    ROUND(AVG(ca.estrellas), 2)            AS promedio_estrellas,
    COUNT(CASE WHEN r.avance_porcentaje >= 90 THEN 1 END) AS vistas_completas,
    COUNT(DISTINCT f.id_perfil)            AS total_favoritos
FROM CONTENIDO    c
LEFT JOIN REPRODUCCION  r  ON c.id_contenido = r.id_contenido
LEFT JOIN CALIFICACION  ca ON c.id_contenido = ca.id_contenido
LEFT JOIN FAVORITO      f  ON c.id_contenido = f.id_contenido
GROUP BY
    c.id_contenido, c.titulo, c.tipo_contenido,
    c.clasificacion_edad, c.es_original;

-- Uso de la vista materializada en un reporte
-- Top 10 contenido más popular
SELECT
    titulo,
    tipo_contenido,
    total_reproducciones,
    promedio_estrellas,
    vistas_completas,
    total_favoritos
FROM MV_POPULARIDAD_CONTENIDO
ORDER BY total_reproducciones DESC, promedio_estrellas DESC
FETCH FIRST 10 ROWS ONLY;

-- ------------------------------------------------------------
-- 4.2 Vista materializada: Ingresos mensuales por ciudad y plan
-- Base para el reporte financiero mensual de la gerencia.
-- Se refresca automáticamente cada día a medianoche (NEXT).
-- ------------------------------------------------------------
CREATE MATERIALIZED VIEW MV_INGRESOS_MENSUALES
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    EXTRACT(YEAR  FROM pg.fecha)  AS anio,
    EXTRACT(MONTH FROM pg.fecha)  AS mes,
    ci.nombre                     AS ciudad,
    pl.nombre                     AS plan,
    COUNT(pg.id_pago)             AS total_pagos,
    SUM(pg.monto)                 AS ingresos_totales,
    COUNT(DISTINCT u.id_usuario)  AS usuarios_facturados,
    COUNT(CASE WHEN pg.estado = 'FALLIDO'    THEN 1 END) AS pagos_fallidos,
    COUNT(CASE WHEN pg.estado = 'REEMBOLSADO' THEN 1 END) AS pagos_reembolsados
FROM PAGO    pg
JOIN USUARIO u  ON pg.id_usuario = u.id_usuario
JOIN CIUDAD  ci ON u.id_ciudad   = ci.id_ciudad
JOIN PLAN    pl ON u.id_plan     = pl.id_plan
GROUP BY
    EXTRACT(YEAR  FROM pg.fecha),
    EXTRACT(MONTH FROM pg.fecha),
    ci.nombre,
    pl.nombre;

-- Uso de la vista materializada en un reporte financiero
-- Ingresos del mes de abril 2026
SELECT
    ciudad,
    plan,
    total_pagos,
    ingresos_totales,
    usuarios_facturados,
    pagos_fallidos
FROM MV_INGRESOS_MENSUALES
WHERE anio = 2026 AND mes = 4
ORDER BY ingresos_totales DESC;

-- Refrescar manualmente las vistas materializadas
-- (ejecutar cuando los datos base hayan cambiado)
EXEC DBMS_MVIEW.REFRESH('MV_POPULARIDAD_CONTENIDO', 'C');
EXEC DBMS_MVIEW.REFRESH('MV_INGRESOS_MENSUALES',    'C');

-- ============================================================
-- SECCIÓN 5: FRAGMENTACIÓN DE TABLAS — TABLESPACES Y DATAFILES
-- Se fragmenta REPRODUCCION por rango de fechas.
-- Justificación: REPRODUCCION es la tabla más grande y de mayor
-- crecimiento. Separar por año permite:
--   1. Consultas históricas sin tocar datos actuales.
--   2. Mantenimiento parcial (backup/purga) por año.
--   3. Mejor rendimiento en consultas con filtro de fecha.
-- ============================================================

-- ------------------------------------------------------------
-- 5.1 Crear tablespaces separados por año
-- Cada año tiene su propio datafile en disco.
-- AUTOEXTEND ON permite crecer automáticamente hasta el límite.
-- ------------------------------------------------------------

-- Tablespace para reproducciones del año 2024
CREATE TABLESPACE TS_REPROD_2024
DATAFILE 'ts_reprod_2024.dbf'
SIZE 50M
AUTOEXTEND ON NEXT 10M MAXSIZE 200M
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace para reproducciones del año 2025
CREATE TABLESPACE TS_REPROD_2025
DATAFILE 'ts_reprod_2025.dbf'
SIZE 100M
AUTOEXTEND ON NEXT 20M MAXSIZE 500M
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace para reproducciones del año 2026 (activo)
CREATE TABLESPACE TS_REPROD_2026
DATAFILE 'ts_reprod_2026.dbf'
SIZE 200M
AUTOEXTEND ON NEXT 50M MAXSIZE 2000M
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace para datos futuros (2027 en adelante)
CREATE TABLESPACE TS_REPROD_FUTURE
DATAFILE 'ts_reprod_future.dbf'
SIZE 100M
AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

-- ------------------------------------------------------------
-- 5.2 Tabla REPRODUCCION_PART con particionamiento por rango
-- Esta tabla reemplaza a REPRODUCCION con particiones físicas
-- almacenadas en tablespaces distintos según el año.
-- ------------------------------------------------------------
CREATE TABLE REPRODUCCION_PART (
    id_reproduccion   NUMBER        NOT NULL,
    fecha_hora_inicio TIMESTAMP     DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_hora_fin    TIMESTAMP,
    dispositivo       VARCHAR2(20)  NOT NULL,
    avance_porcentaje NUMBER(5,2)   DEFAULT 0,
    id_perfil         NUMBER        NOT NULL,
    id_contenido      NUMBER        NOT NULL,
    id_episodio       NUMBER,
    CONSTRAINT pk_reprod_part    PRIMARY KEY (id_reproduccion, fecha_hora_inicio),
    CONSTRAINT chk_rp_dispositivo CHECK (dispositivo IN ('CELULAR', 'TABLET', 'TV', 'COMPUTADOR')),
    CONSTRAINT chk_rp_avance      CHECK (avance_porcentaje BETWEEN 0 AND 100)
)
PARTITION BY RANGE (fecha_hora_inicio) (
    -- Reproducciones del año 2024
    PARTITION reprod_2024
        VALUES LESS THAN (TIMESTAMP '2025-01-01 00:00:00')
        TABLESPACE TS_REPROD_2024,
    -- Reproducciones del año 2025
    PARTITION reprod_2025
        VALUES LESS THAN (TIMESTAMP '2026-01-01 00:00:00')
        TABLESPACE TS_REPROD_2025,
    -- Reproducciones del año 2026
    PARTITION reprod_2026
        VALUES LESS THAN (TIMESTAMP '2027-01-01 00:00:00')
        TABLESPACE TS_REPROD_2026,
    -- Reproducciones futuras (2027 en adelante)
    PARTITION reprod_future
        VALUES LESS THAN (MAXVALUE)
        TABLESPACE TS_REPROD_FUTURE
);

-- ------------------------------------------------------------
-- 5.3 Migrar datos existentes de REPRODUCCION a REPRODUCCION_PART
-- ------------------------------------------------------------
INSERT INTO REPRODUCCION_PART
    (id_reproduccion, fecha_hora_inicio, fecha_hora_fin,
     dispositivo, avance_porcentaje, id_perfil, id_contenido, id_episodio)
SELECT
    id_reproduccion, fecha_hora_inicio, fecha_hora_fin,
    dispositivo, avance_porcentaje, id_perfil, id_contenido, id_episodio
FROM REPRODUCCION;

COMMIT;

-- ------------------------------------------------------------
-- 5.4 Verificar particiones creadas y su distribución
-- Muestra cuántos registros quedaron en cada partición/tablespace
-- ------------------------------------------------------------
SELECT
    partition_name,
    tablespace_name,
    num_rows,
    high_value
FROM user_tab_partitions
WHERE table_name = 'REPRODUCCION_PART'
ORDER BY partition_position;

-- Contar registros por partición directamente
SELECT 'reprod_2024' AS particion, COUNT(*) AS registros FROM REPRODUCCION_PART PARTITION (reprod_2024)
UNION ALL
SELECT 'reprod_2025',              COUNT(*)               FROM REPRODUCCION_PART PARTITION (reprod_2025)
UNION ALL
SELECT 'reprod_2026',              COUNT(*)               FROM REPRODUCCION_PART PARTITION (reprod_2026)
UNION ALL
SELECT 'reprod_future',            COUNT(*)               FROM REPRODUCCION_PART PARTITION (reprod_future);

-- ------------------------------------------------------------
-- 5.5 Demostración de PARTITION PRUNING
-- Oracle solo accede a la partición de 2026, ignora el resto.
-- Verificar con EXPLAIN PLAN que aparezca "PARTITION RANGE SINGLE"
-- ------------------------------------------------------------
EXPLAIN PLAN FOR
SELECT
    id_reproduccion,
    dispositivo,
    avance_porcentaje,
    id_perfil,
    id_contenido
FROM REPRODUCCION_PART
WHERE fecha_hora_inicio >= TIMESTAMP '2026-01-01 00:00:00'
  AND fecha_hora_inicio <  TIMESTAMP '2027-01-01 00:00:00';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- ============================================================
-- FIN DEL SCRIPT NÚCLEO 1
-- Elementos implementados:
--   3 consultas parametrizadas (& y DEFINE)
--   2 PIVOT + 1 UNPIVOT
--   1 ROLLUP | 1 CUBE | 1 GROUPING SETS
--   2 vistas materializadas (MV_POPULARIDAD_CONTENIDO, MV_INGRESOS_MENSUALES)
--   4 tablespaces + fragmentación de REPRODUCCION por año
-- ============================================================
