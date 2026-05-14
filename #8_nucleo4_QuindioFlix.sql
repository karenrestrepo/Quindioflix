-- ============================================================
-- QUINDIOFLIX - NÚCLEO 4: ÍNDICES Y ANÁLISIS DE RENDIMIENTO
-- Universidad del Quindío - Bases de Datos II
-- Resultado de Aprendizaje: R.A.3
-- ============================================================
-- Un índice es una estructura de datos adicional que Oracle
-- mantiene sincronizada con la tabla para acelerar búsquedas.
-- Sin índice: Oracle hace FULL TABLE SCAN (lee cada fila).
-- Con índice: Oracle hace INDEX RANGE SCAN o INDEX UNIQUE SCAN
--             accediendo directamente a las filas relevantes.
-- Costo: los índices ocupan espacio y ralentizan INSERT/UPDATE/DELETE.
-- Beneficio: aceleran enormemente las consultas de lectura (SELECT).
-- ============================================================

-- ============================================================
-- SECCIÓN 1: CREACIÓN Y ADMINISTRACIÓN DE ÍNDICES
-- ============================================================

-- ------------------------------------------------------------
-- 1.1 Índice compuesto en REPRODUCCION(id_perfil, fecha_hora_inicio)
--
-- JUSTIFICACIÓN:
-- La consulta más frecuente del sistema es el historial de
-- reproducciones de un perfil en un rango de fechas:
--   WHERE id_perfil = X AND fecha_hora_inicio BETWEEN fecha1 AND fecha2
-- Sin índice Oracle haría FULL TABLE SCAN sobre las 200+ filas
-- de REPRODUCCION (que en producción serán millones).
-- El índice compuesto permite INDEX RANGE SCAN filtrando primero
-- por perfil y luego por fecha, evitando leer filas innecesarias.
-- El orden importa: id_perfil primero porque es el filtro más
-- selectivo (reduce drásticamente el conjunto de datos).
-- ------------------------------------------------------------
CREATE INDEX idx_reprod_perfil_fecha
ON REPRODUCCION (id_perfil, fecha_hora_inicio);

-- ------------------------------------------------------------
-- 1.2 Índice único en USUARIO(email)
--
-- JUSTIFICACIÓN:
-- El email se usa en dos operaciones críticas y frecuentes:
--   1. Login: WHERE email = 'usuario@gmail.com' (cada inicio de sesión)
--   2. Validación de duplicados en SP_REGISTRAR_USUARIO
-- Sin índice cada login hace FULL TABLE SCAN sobre USUARIO.
-- Con índice UNIQUE Oracle garantiza unicidad a nivel de estructura
-- (más eficiente que un CHECK constraint) y resuelve el lookup
-- en tiempo O(log n) con B-Tree.
-- NOTA: Ya existe UNIQUE constraint en la tabla, pero el índice
-- explícito permite monitoreo y estadísticas independientes.
-- ------------------------------------------------------------
CREATE UNIQUE INDEX idx_usuario_email
ON USUARIO (email);

-- ------------------------------------------------------------
-- 1.3 Índice compuesto en CONTENIDO(tipo_contenido, anio_lanzamiento)
--
-- JUSTIFICACIÓN:
-- Los reportes de la gerencia y el catálogo de usuarios filtran
-- frecuentemente por tipo y año:
--   WHERE tipo_contenido = 'PELICULA' AND anio_lanzamiento >= 2022
-- También se usa en los PIVOT del Núcleo 1 que agrupan por
-- tipo_contenido. El índice permite INDEX RANGE SCAN en lugar
-- de FULL TABLE SCAN sobre toda la tabla CONTENIDO.
-- tipo_contenido va primero por ser más selectivo como filtro
-- de igualdad; anio_lanzamiento va segundo para filtros de rango.
-- ------------------------------------------------------------
CREATE INDEX idx_contenido_tipo_anio
ON CONTENIDO (tipo_contenido, anio_lanzamiento);

-- ------------------------------------------------------------
-- 1.4 Índice en PAGO(id_usuario, fecha, estado)
--
-- JUSTIFICACIÓN:
-- El cursor de morosos (Núcleo 2) y los reportes financieros
-- ejecutan constantemente consultas como:
--   WHERE id_usuario = X AND estado = 'EXITOSO'
--   WHERE EXTRACT(MONTH FROM fecha) = M AND EXTRACT(YEAR FROM fecha) = Y
-- Sin índice cada cálculo de monto adeudado recorre toda la tabla
-- PAGO que en producción tendrá registros de años de historial.
-- El índice sobre (id_usuario, fecha) cubre ambos patrones:
-- búsqueda por usuario + filtro por fecha en rango.
-- Incluir estado permite INDEX SKIP SCAN para filtros de estado.
-- ------------------------------------------------------------
CREATE INDEX idx_pago_usuario_fecha
ON PAGO (id_usuario, fecha, estado);

-- ------------------------------------------------------------
-- 1.5 Índice en CALIFICACION(id_contenido, estrellas)
--
-- JUSTIFICACIÓN (índice adicional a elección):
-- La vista materializada MV_POPULARIDAD_CONTENIDO calcula
-- AVG(estrellas) agrupando por id_contenido. Sin índice
-- Oracle recorre toda CALIFICACION para cada contenido.
-- Con este índice la operación GROUP BY id_contenido puede
-- resolverse con INDEX FULL SCAN SIN acceder a la tabla,
-- ya que ambas columnas (id_contenido y estrellas) están
-- en el índice (índice cubriente / covering index).
-- También acelera consultas como:
--   WHERE id_contenido = X AND estrellas >= 4  (contenido bien calificado)
-- ------------------------------------------------------------
CREATE INDEX idx_calificacion_contenido_estrellas
ON CALIFICACION (id_contenido, estrellas);

-- ============================================================
-- SECCIÓN 2: ANÁLISIS DE RENDIMIENTO — EXPLAIN PLAN
-- Se muestra el plan ANTES y DESPUÉS de crear el índice más
-- representativo para demostrar la mejora en costo y acceso.
-- ============================================================

-- ------------------------------------------------------------
-- 2.1 Consulta de análisis:
-- Historial de reproducciones de un perfil en el último mes.
-- Esta es la consulta más frecuente del sistema y la que más
-- se beneficia del índice compuesto idx_reprod_perfil_fecha.
-- ------------------------------------------------------------

-- ============================================================
-- PASO A: ELIMINAR el índice temporalmente para ver el plan SIN índice
-- ============================================================
DROP INDEX idx_reprod_perfil_fecha;

-- Generar estadísticas actualizadas de la tabla
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'REPRODUCCION');

-- EXPLAIN PLAN — SIN ÍNDICE
-- Oracle usará FULL TABLE SCAN (TABLE ACCESS FULL)
EXPLAIN PLAN
SET STATEMENT_ID = 'SIN_INDICE'
FOR
SELECT
    r.id_reproduccion,
    r.fecha_hora_inicio,
    r.dispositivo,
    r.avance_porcentaje,
    c.titulo,
    c.tipo_contenido
FROM REPRODUCCION r
JOIN CONTENIDO    c ON r.id_contenido = c.id_contenido
WHERE r.id_perfil         = 1
  AND r.fecha_hora_inicio >= TIMESTAMP '2026-04-01 00:00:00'
  AND r.fecha_hora_inicio <  TIMESTAMP '2026-05-01 00:00:00'
ORDER BY r.fecha_hora_inicio;

-- Mostrar el plan SIN índice
SELECT plan_table_output
FROM TABLE(
    DBMS_XPLAN.DISPLAY(
        'PLAN_TABLE',
        'SIN_INDICE',
        'ALL'
    )
);

/*
RESULTADO ESPERADO SIN ÍNDICE:
---------------------------------------------------------------------------
| Id | Operation                    | Name         | Rows | Cost (%CPU) |
---------------------------------------------------------------------------
|  0 | SELECT STATEMENT             |              |    8 |      6 (17) |
|  1 |  SORT ORDER BY               |              |    8 |      6 (17) |
|  2 |   NESTED LOOPS               |              |    8 |      5  (0) |
|  3 |    NESTED LOOPS              |              |    8 |      5  (0) |
|  4 |     TABLE ACCESS FULL        | REPRODUCCION |  200 |      3  (0) |  ← PROBLEMA
|  5 |     INDEX UNIQUE SCAN        | SYS_C...     |    1 |      0  (0) |
|  6 |    TABLE ACCESS BY INDEX ROWID | CONTENIDO  |    1 |      0  (0) |
---------------------------------------------------------------------------
Nota: TABLE ACCESS FULL en REPRODUCCION — lee las 200 filas completas
      para encontrar las 8 del perfil 1 en abril. En producción con
      millones de registros esto sería extremadamente costoso.
*/

-- ============================================================
-- PASO B: RECREAR el índice y analizar el plan CON índice
-- ============================================================
CREATE INDEX idx_reprod_perfil_fecha
ON REPRODUCCION (id_perfil, fecha_hora_inicio);

-- Actualizar estadísticas para que Oracle reconozca el nuevo índice
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'REPRODUCCION');
EXEC DBMS_STATS.GATHER_INDEX_STATS(USER, 'IDX_REPROD_PERFIL_FECHA');

-- EXPLAIN PLAN — CON ÍNDICE
-- Oracle usará INDEX RANGE SCAN (mucho más eficiente)
EXPLAIN PLAN
SET STATEMENT_ID = 'CON_INDICE'
FOR
SELECT
    r.id_reproduccion,
    r.fecha_hora_inicio,
    r.dispositivo,
    r.avance_porcentaje,
    c.titulo,
    c.tipo_contenido
FROM REPRODUCCION r
JOIN CONTENIDO    c ON r.id_contenido = c.id_contenido
WHERE r.id_perfil         = 1
  AND r.fecha_hora_inicio >= TIMESTAMP '2026-04-01 00:00:00'
  AND r.fecha_hora_inicio <  TIMESTAMP '2026-05-01 00:00:00'
ORDER BY r.fecha_hora_inicio;

-- Mostrar el plan CON índice
SELECT plan_table_output
FROM TABLE(
    DBMS_XPLAN.DISPLAY(
        'PLAN_TABLE',
        'CON_INDICE',
        'ALL'
    )
);

/*
RESULTADO ESPERADO CON ÍNDICE:
---------------------------------------------------------------------------
| Id | Operation                     | Name                    | Rows | Cost |
---------------------------------------------------------------------------
|  0 | SELECT STATEMENT              |                         |    8 |   3  |
|  1 |  SORT ORDER BY                |                         |    8 |   3  |
|  2 |   NESTED LOOPS                |                         |    8 |   2  |
|  3 |    NESTED LOOPS               |                         |    8 |   2  |
|  4 |     INDEX RANGE SCAN          | IDX_REPROD_PERFIL_FECHA |    8 |   1  | ← MEJORA
|  5 |     TABLE ACCESS BY INDEX ROWID | REPRODUCCION          |    1 |   0  |
|  6 |    TABLE ACCESS BY INDEX ROWID | CONTENIDO              |    1 |   0  |
---------------------------------------------------------------------------
Nota: INDEX RANGE SCAN — Oracle solo lee las 8 filas del perfil 1
      en el rango de fechas, sin tocar el resto de la tabla.
      Costo reducido de 6 a 3 (50% de mejora).
      En producción con millones de filas la diferencia sería
      de segundos vs milisegundos.
*/

-- ------------------------------------------------------------
-- 2.2 Comparación directa de costos — ambos planes en una sola vista
-- ------------------------------------------------------------
SELECT
    statement_id          AS escenario,
    operation,
    options,
    object_name           AS objeto,
    cardinality           AS filas_estimadas,
    cost                  AS costo_estimado,
    cpu_cost,
    io_cost
FROM plan_table
WHERE statement_id IN ('SIN_INDICE', 'CON_INDICE')
ORDER BY statement_id, id;

-- ------------------------------------------------------------
-- 2.3 Análisis adicional: índice cubriente en CALIFICACION
-- Demostrar que idx_calificacion_contenido_estrellas permite
-- resolver el GROUP BY SIN acceder a la tabla base.
-- ------------------------------------------------------------

EXPLAIN PLAN
SET STATEMENT_ID = 'COVERING_INDEX'
FOR
SELECT
    id_contenido,
    COUNT(*)             AS total_calificaciones,
    ROUND(AVG(estrellas), 2) AS promedio_estrellas,
    MIN(estrellas)       AS min_estrellas,
    MAX(estrellas)       AS max_estrellas
FROM CALIFICACION
GROUP BY id_contenido
ORDER BY promedio_estrellas DESC;

SELECT plan_table_output
FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE', 'COVERING_INDEX', 'ALL'));

/*
RESULTADO ESPERADO:
Con idx_calificacion_contenido_estrellas Oracle puede resolver
toda la consulta leyendo solo el índice (INDEX FAST FULL SCAN),
sin necesidad de acceder a la tabla CALIFICACION.
Esto se llama "índice cubriente" (covering index) porque contiene
todas las columnas necesarias para la consulta.
*/

-- ============================================================
-- SECCIÓN 3: ADMINISTRACIÓN Y MONITOREO DE ÍNDICES
-- ============================================================

-- Ver todos los índices creados para las tablas del proyecto
SELECT
    index_name,
    table_name,
    index_type,
    uniqueness,
    status,
    num_rows,
    leaf_blocks,
    clustering_factor
FROM user_indexes
WHERE table_name IN (
    'REPRODUCCION', 'USUARIO', 'CONTENIDO',
    'PAGO', 'CALIFICACION', 'PERFIL', 'FAVORITO'
)
ORDER BY table_name, index_name;

-- Ver columnas de cada índice
SELECT
    index_name,
    table_name,
    column_name,
    column_position,
    descend
FROM user_ind_columns
WHERE table_name IN (
    'REPRODUCCION', 'USUARIO', 'CONTENIDO',
    'PAGO', 'CALIFICACION'
)
ORDER BY index_name, column_position;

-- Verificar uso real de los índices
-- (requiere que el monitoreo esté activado)
ALTER INDEX idx_reprod_perfil_fecha              MONITORING USAGE;
ALTER INDEX idx_usuario_email                    MONITORING USAGE;
ALTER INDEX idx_contenido_tipo_anio              MONITORING USAGE;
ALTER INDEX idx_pago_usuario_fecha               MONITORING USAGE;
ALTER INDEX idx_calificacion_contenido_estrellas MONITORING USAGE;

-- Ejecutar algunas consultas para generar uso de los índices...
SELECT * FROM REPRODUCCION WHERE id_perfil = 1;
SELECT * FROM USUARIO WHERE email = 'arestrepo@gmail.com';
SELECT * FROM CONTENIDO WHERE tipo_contenido = 'PELICULA' AND anio_lanzamiento = 2023;
SELECT * FROM PAGO WHERE id_usuario = 1 AND estado = 'EXITOSO';

-- Ver si los índices fueron usados
SELECT index_name, table_name, status, uniqueness
FROM user_indexes
WHERE index_name IN (
    'IDX_REPROD_PERFIL_FECHA',
    'IDX_CONTENIDO_TIPO_ANIO',
    'IDX_PAGO_USUARIO_FECHA',
    'IDX_CALIFICACION_CONTENIDO_ESTRELLAS'
);
-- Reconstruir índice si está fragmentado (mantenimiento)
-- Se recomienda cuando CLUSTERING_FACTOR > 10x NUM_ROWS
ALTER INDEX idx_reprod_perfil_fecha REBUILD;

-- Desactivar monitoreo tras la demostración
ALTER INDEX idx_reprod_perfil_fecha              NOMONITORING USAGE;
ALTER INDEX idx_usuario_email                    NOMONITORING USAGE;
ALTER INDEX idx_contenido_tipo_anio              NOMONITORING USAGE;
ALTER INDEX idx_pago_usuario_fecha               NOMONITORING USAGE;
ALTER INDEX idx_calificacion_contenido_estrellas NOMONITORING USAGE;

-- ============================================================
-- FIN DEL SCRIPT NÚCLEO 4
-- Elementos implementados:
--   5 índices creados y justificados:
--     idx_reprod_perfil_fecha              (compuesto)
--     idx_usuario_email                    (único)
--     idx_contenido_tipo_anio              (compuesto)
--     idx_pago_usuario_fecha               (compuesto)
--     idx_calificacion_contenido_estrellas (cubriente)
--   Análisis EXPLAIN PLAN antes y después del índice principal
--   Comparación directa de costos en PLAN_TABLE
--   Demostración de índice cubriente en CALIFICACION
--   Consultas de administración y monitoreo de índices
-- ============================================================
