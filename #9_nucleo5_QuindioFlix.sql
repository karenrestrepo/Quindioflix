-- ============================================================
-- QUINDIOFLIX - NÚCLEO 5: ADMINISTRACIÓN DE ACCESO A BD
-- Universidad del Quindío - Bases de Datos II
-- Resultado de Aprendizaje: R.A.1
-- ============================================================
-- IMPORTANTE: Este script debe ejecutarse conectado como
-- un usuario con privilegios DBA (ej: SYSTEM o SYS AS SYSDBA).
-- Todos los objetos del proyecto están en el esquema del
-- usuario propietario (asumido como: QUINDIOFLIX_OWNER).
-- Reemplazar QUINDIOFLIX_OWNER por el usuario real del esquema.
-- ============================================================

-- Variable del esquema propietario (ajustar según el ambiente)
-- En SQL*Plus: DEFINE owner = QUINDIOFLIX_OWNER
-- En este script se usa directamente el nombre del esquema.

-- ============================================================
-- SECCIÓN 1: CREACIÓN DE ROLES
-- Un rol agrupa privilegios para asignarlos en bloque a usuarios.
-- ============================================================

-- Eliminar roles si ya existen (para poder re-ejecutar el script)
BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE ROL_ADMIN';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE ROL_ANALISTA';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE ROL_SOPORTE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE ROL_CONTENIDO';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ------------------------------------------------------------
-- ROL_ADMIN: Administrador de la plataforma
-- Acceso total a todas las tablas y procedimientos.
-- Puede crear y eliminar usuarios de la base de datos.
-- ------------------------------------------------------------
CREATE ROLE ROL_ADMIN;

-- CRUD completo en todas las tablas del proyecto
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.CIUDAD           TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.DEPARTAMENTO      TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.PLAN              TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.GENERO            TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.EMPLEADO          TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.USUARIO           TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.PAGO              TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.PERFIL            TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.CONTENIDO         TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.PELICULA          TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.SERIE             TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.DOCUMENTAL        TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.MUSICA            TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.PODCAST           TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.TEMPORADA         TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.EPISODIO          TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.CONTENIDO_GENERO  TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.RELACION_CONTENIDO TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.REPRODUCCION      TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.CALIFICACION      TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.FAVORITO          TO ROL_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.REPORTE           TO ROL_ADMIN;

-- Acceso a vistas materializadas
GRANT SELECT ON QUINDIOFLIX_OWNER.MV_POPULARIDAD_CONTENIDO TO ROL_ADMIN;
GRANT SELECT ON QUINDIOFLIX_OWNER.MV_INGRESOS_MENSUALES    TO ROL_ADMIN;

-- Ejecución de todos los procedimientos y funciones
GRANT EXECUTE ON QUINDIOFLIX_OWNER.SP_REGISTRAR_USUARIO    TO ROL_ADMIN;
GRANT EXECUTE ON QUINDIOFLIX_OWNER.SP_CAMBIAR_PLAN         TO ROL_ADMIN;
GRANT EXECUTE ON QUINDIOFLIX_OWNER.SP_REPORTE_CONSUMO      TO ROL_ADMIN;
GRANT EXECUTE ON QUINDIOFLIX_OWNER.FN_CALCULAR_MONTO       TO ROL_ADMIN;
GRANT EXECUTE ON QUINDIOFLIX_OWNER.FN_CONTENIDO_RECOMENDADO TO ROL_ADMIN;

-- Privilegios de sistema para gestión de usuarios
GRANT CREATE USER     TO ROL_ADMIN;
GRANT DROP USER       TO ROL_ADMIN;
GRANT ALTER USER      TO ROL_ADMIN;
GRANT CREATE SESSION  TO ROL_ADMIN;

-- ------------------------------------------------------------
-- ROL_ANALISTA: Analista de datos / Gerencia
-- Solo lectura en todas las tablas.
-- Puede ejecutar procedimientos de reportes y ver vistas mat.
-- ------------------------------------------------------------
CREATE ROLE ROL_ANALISTA;

-- SELECT en todas las tablas (solo lectura)
GRANT SELECT ON QUINDIOFLIX_OWNER.CIUDAD            TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.DEPARTAMENTO       TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.PLAN               TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.GENERO             TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.EMPLEADO           TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.USUARIO            TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.PAGO               TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.PERFIL             TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.CONTENIDO          TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.PELICULA           TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.SERIE              TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.DOCUMENTAL         TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.MUSICA             TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.PODCAST            TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.TEMPORADA          TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.EPISODIO           TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.CONTENIDO_GENERO   TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.RELACION_CONTENIDO TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.REPRODUCCION       TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.CALIFICACION       TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.FAVORITO           TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.REPORTE            TO ROL_ANALISTA;

-- Acceso a vistas materializadas (reportes precalculados)
GRANT SELECT ON QUINDIOFLIX_OWNER.MV_POPULARIDAD_CONTENIDO TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.MV_INGRESOS_MENSUALES    TO ROL_ANALISTA;

-- Solo puede ejecutar el procedimiento de reporte (no los de modificación)
GRANT EXECUTE ON QUINDIOFLIX_OWNER.SP_REPORTE_CONSUMO       TO ROL_ANALISTA;
GRANT EXECUTE ON QUINDIOFLIX_OWNER.FN_CALCULAR_MONTO        TO ROL_ANALISTA;
GRANT EXECUTE ON QUINDIOFLIX_OWNER.FN_CONTENIDO_RECOMENDADO TO ROL_ANALISTA;

-- Privilegio de conexión
GRANT CREATE SESSION TO ROL_ANALISTA;

-- ------------------------------------------------------------
-- ROL_SOPORTE: Soporte al cliente
-- Acceso limitado a tablas de usuarios y pagos.
-- Puede consultar datos de clientes y cambiar planes.
-- NO puede ver contenido interno ni datos de empleados.
-- ------------------------------------------------------------
CREATE ROLE ROL_SOPORTE;

-- Solo lectura en tablas de clientes
GRANT SELECT ON QUINDIOFLIX_OWNER.USUARIO  TO ROL_SOPORTE;
GRANT SELECT ON QUINDIOFLIX_OWNER.PERFIL   TO ROL_SOPORTE;
GRANT SELECT ON QUINDIOFLIX_OWNER.PLAN     TO ROL_SOPORTE;
GRANT SELECT ON QUINDIOFLIX_OWNER.CIUDAD   TO ROL_SOPORTE;

-- Lectura y escritura en PAGOS (para registrar pagos manuales)
GRANT SELECT, INSERT, UPDATE ON QUINDIOFLIX_OWNER.PAGO TO ROL_SOPORTE;

-- Lectura y gestión de REPORTES (los moderadores de soporte los resuelven)
GRANT SELECT, UPDATE ON QUINDIOFLIX_OWNER.REPORTE TO ROL_SOPORTE;

-- Puede cambiar el plan de un usuario (atención al cliente)
GRANT EXECUTE ON QUINDIOFLIX_OWNER.SP_CAMBIAR_PLAN TO ROL_SOPORTE;

-- Privilegio de conexión
GRANT CREATE SESSION TO ROL_SOPORTE;

-- ------------------------------------------------------------
-- ROL_CONTENIDO: Gestor del catálogo de contenido
-- CRUD completo en tablas de contenido y estructura.
-- Lectura en reproducciones y calificaciones para análisis.
-- NO puede ver datos de usuarios, pagos ni empleados.
-- ------------------------------------------------------------
CREATE ROLE ROL_CONTENIDO;

-- CRUD en tablas de catálogo
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.CONTENIDO          TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.PELICULA           TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.SERIE              TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.DOCUMENTAL         TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.MUSICA             TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.PODCAST            TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.TEMPORADA          TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.EPISODIO           TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.GENERO             TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.CONTENIDO_GENERO   TO ROL_CONTENIDO;
GRANT SELECT, INSERT, UPDATE, DELETE ON QUINDIOFLIX_OWNER.RELACION_CONTENIDO TO ROL_CONTENIDO;

-- Solo lectura en tablas de consumo (para ver métricas del catálogo)
GRANT SELECT ON QUINDIOFLIX_OWNER.REPRODUCCION TO ROL_CONTENIDO;
GRANT SELECT ON QUINDIOFLIX_OWNER.CALIFICACION TO ROL_CONTENIDO;
GRANT SELECT ON QUINDIOFLIX_OWNER.FAVORITO     TO ROL_CONTENIDO;

-- Vista materializada de popularidad (útil para gestionar el catálogo)
GRANT SELECT ON QUINDIOFLIX_OWNER.MV_POPULARIDAD_CONTENIDO TO ROL_CONTENIDO;

-- Privilegio de conexión
GRANT CREATE SESSION TO ROL_CONTENIDO;

-- ============================================================
-- SECCIÓN 2: CREACIÓN DE PERFILES DE RECURSO (PROFILE)
-- Limitan el uso de recursos del sistema por sesión.
-- ============================================================

-- Eliminar perfiles si ya existen
BEGIN
    EXECUTE IMMEDIATE 'DROP PROFILE PERFIL_ADMIN CASCADE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP PROFILE PERFIL_USUARIO_NORMAL CASCADE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ------------------------------------------------------------
-- PERFIL para usuarios administradores
-- Límites relajados: más sesiones, más tiempo de inactividad
-- ------------------------------------------------------------
CREATE PROFILE PERFIL_ADMIN LIMIT
    SESSIONS_PER_USER        3          -- Máx 3 sesiones simultáneas
    CPU_PER_SESSION          UNLIMITED  -- Sin límite de CPU por sesión
    CPU_PER_CALL             6000       -- 60 segundos por llamada SQL
    CONNECT_TIME             480        -- 8 horas máx de conexión
    IDLE_TIME                60         -- 60 min de inactividad antes de desconectar
    LOGICAL_READS_PER_SESSION UNLIMITED -- Sin límite de lecturas lógicas
    FAILED_LOGIN_ATTEMPTS    5          -- 5 intentos fallidos antes de bloquear
    PASSWORD_LOCK_TIME       1/24       -- Bloqueado 1 hora tras intentos fallidos
    PASSWORD_LIFE_TIME       90         -- Contraseña expira cada 90 días
    PASSWORD_REUSE_TIME      365        -- No reusar contraseñas del último año
    PASSWORD_REUSE_MAX       5          -- No reusar las últimas 5 contraseñas
    PASSWORD_VERIFY_FUNCTION DEFAULT;   -- Función de verificación por defecto

-- ------------------------------------------------------------
-- PERFIL para usuarios normales (analistas, soporte, contenido)
-- Límites más estrictos para proteger recursos del servidor
-- ------------------------------------------------------------
CREATE PROFILE PERFIL_USUARIO_NORMAL LIMIT
    SESSIONS_PER_USER        2          -- Máx 2 sesiones simultáneas
    CPU_PER_SESSION          UNLIMITED
    CPU_PER_CALL             3000       -- 30 segundos por llamada SQL
    CONNECT_TIME             240        -- 4 horas máx de conexión
    IDLE_TIME                20         -- 20 min de inactividad antes de desconectar
    LOGICAL_READS_PER_SESSION 1000000  -- Máx 1 millón de lecturas lógicas
    FAILED_LOGIN_ATTEMPTS    3          -- 3 intentos fallidos antes de bloquear
    PASSWORD_LOCK_TIME       1/48       -- Bloqueado 30 min tras intentos fallidos
    PASSWORD_LIFE_TIME       60         -- Contraseña expira cada 60 días
    PASSWORD_REUSE_TIME      180        -- No reusar contraseñas de los últimos 6 meses
    PASSWORD_REUSE_MAX       3          -- No reusar las últimas 3 contraseñas
    PASSWORD_VERIFY_FUNCTION DEFAULT;

-- ============================================================
-- SECCIÓN 3: CREACIÓN DE USUARIOS ORACLE
-- Un usuario por cada rol definido
-- ============================================================

-- Eliminar usuarios si ya existen (para re-ejecución)
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_admin     CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_analista  CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_soporte   CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_contenido CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Usuario administrador
CREATE USER usr_admin
    IDENTIFIED BY Admin_QFlix2024#
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS
    PROFILE PERFIL_ADMIN
    ACCOUNT UNLOCK;

-- Usuario analista de datos / gerencia
CREATE USER usr_analista
    IDENTIFIED BY Analista_QFlix2024#
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 10M ON USERS
    PROFILE PERFIL_USUARIO_NORMAL
    ACCOUNT UNLOCK;

-- Usuario de soporte al cliente
CREATE USER usr_soporte
    IDENTIFIED BY Soporte_QFlix2024#
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 10M ON USERS
    PROFILE PERFIL_USUARIO_NORMAL
    ACCOUNT UNLOCK;

-- Usuario gestor de contenido
CREATE USER usr_contenido
    IDENTIFIED BY Contenido_QFlix2024#
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 50M ON USERS
    PROFILE PERFIL_USUARIO_NORMAL
    ACCOUNT UNLOCK;

-- ============================================================
-- SECCIÓN 4: ASIGNACIÓN DE ROLES A USUARIOS (GRANT)
-- ============================================================

GRANT ROL_ADMIN    TO usr_admin    WITH ADMIN OPTION;
GRANT ROL_ANALISTA TO usr_analista;
GRANT ROL_SOPORTE  TO usr_soporte;
GRANT ROL_CONTENIDO TO usr_contenido;

-- Activar el rol por defecto al conectarse
ALTER USER usr_admin     DEFAULT ROLE ROL_ADMIN;
ALTER USER usr_analista  DEFAULT ROLE ROL_ANALISTA;
ALTER USER usr_soporte   DEFAULT ROLE ROL_SOPORTE;
ALTER USER usr_contenido DEFAULT ROLE ROL_CONTENIDO;

-- ============================================================
-- SECCIÓN 5: VISTAS PARA OCULTAR DATOS SENSIBLES (CRUD)
-- Corresponde al punto 4 del documento (Análisis de Vistas).
-- Las vistas protegen columnas sensibles y simplifican reportes.
-- ============================================================

-- ------------------------------------------------------------
-- Vista que oculta datos sensibles de USUARIO
-- Soporte y Analistas ven esta vista, no la tabla directa.
-- Se ocultan: contrasena, fecha_nacimiento
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW VW_USUARIOS_PUBLICO AS
SELECT
    u.id_usuario,
    u.nombre,
    u.email,
    u.telefono,
    u.estado_cuenta,
    u.fecha_ultimo_pago,
    c.nombre    AS ciudad,
    pl.nombre   AS plan,
    CASE
        WHEN u.id_referido_por IS NOT NULL THEN 'Sí'
        ELSE 'No'
    END          AS tiene_referido
FROM USUARIO u
JOIN CIUDAD  c  ON u.id_ciudad = c.id_ciudad
JOIN PLAN    pl ON u.id_plan   = pl.id_plan;

-- Otorgar acceso a la vista (no a la tabla directa)
GRANT SELECT ON QUINDIOFLIX_OWNER.VW_USUARIOS_PUBLICO TO ROL_SOPORTE;
GRANT SELECT ON QUINDIOFLIX_OWNER.VW_USUARIOS_PUBLICO TO ROL_ANALISTA;

-- ------------------------------------------------------------
-- Vista de reporte: contenido más popular con métricas completas
-- Combina datos de CONTENIDO, REPRODUCCION y CALIFICACION.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW VW_REPORTE_POPULARIDAD AS
SELECT
    c.id_contenido,
    c.titulo,
    c.tipo_contenido,
    c.clasificacion_edad,
    c.anio_lanzamiento,
    c.es_original,
    e.nombre                             AS publicado_por,
    COUNT(DISTINCT r.id_reproduccion)    AS total_reproducciones,
    COUNT(DISTINCT ca.id_calificacion)   AS total_calificaciones,
    ROUND(AVG(ca.estrellas), 2)          AS promedio_estrellas,
    COUNT(CASE WHEN r.avance_porcentaje >= 90 THEN 1 END) AS vistas_completas,
    COUNT(DISTINCT f.id_perfil)          AS en_favoritos
FROM CONTENIDO   c
LEFT JOIN EMPLEADO      e  ON c.id_empleado_publica = e.id_empleado
LEFT JOIN REPRODUCCION  r  ON c.id_contenido = r.id_contenido
LEFT JOIN CALIFICACION  ca ON c.id_contenido = ca.id_contenido
LEFT JOIN FAVORITO      f  ON c.id_contenido = f.id_contenido
GROUP BY
    c.id_contenido, c.titulo, c.tipo_contenido,
    c.clasificacion_edad, c.anio_lanzamiento,
    c.es_original, e.nombre;

GRANT SELECT ON QUINDIOFLIX_OWNER.VW_REPORTE_POPULARIDAD TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.VW_REPORTE_POPULARIDAD TO ROL_CONTENIDO;
GRANT SELECT ON QUINDIOFLIX_OWNER.VW_REPORTE_POPULARIDAD TO ROL_ADMIN;

-- ------------------------------------------------------------
-- Vista de reporte financiero mensual para gerencia
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW VW_REPORTE_FINANCIERO AS
SELECT
    EXTRACT(YEAR  FROM pg.fecha) AS anio,
    EXTRACT(MONTH FROM pg.fecha) AS mes,
    c.nombre                     AS ciudad,
    pl.nombre                    AS plan,
    pg.estado,
    COUNT(pg.id_pago)            AS cantidad_transacciones,
    SUM(pg.monto)                AS monto_total,
    AVG(pg.monto)                AS monto_promedio
FROM PAGO    pg
JOIN USUARIO u  ON pg.id_usuario = u.id_usuario
JOIN CIUDAD  c  ON u.id_ciudad   = c.id_ciudad
JOIN PLAN    pl ON u.id_plan     = pl.id_plan
GROUP BY
    EXTRACT(YEAR  FROM pg.fecha),
    EXTRACT(MONTH FROM pg.fecha),
    c.nombre, pl.nombre, pg.estado;

GRANT SELECT ON QUINDIOFLIX_OWNER.VW_REPORTE_FINANCIERO TO ROL_ANALISTA;
GRANT SELECT ON QUINDIOFLIX_OWNER.VW_REPORTE_FINANCIERO TO ROL_ADMIN;

-- ------------------------------------------------------------
-- Vista de gestión de reportes para el equipo de soporte
-- Muestra solo los reportes PENDIENTES con datos útiles
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW VW_REPORTES_PENDIENTES AS
SELECT
    r.id_reporte,
    r.descripcion,
    r.estado,
    r.fecha_reporte,
    p.nombre    AS perfil_que_reporta,
    u.nombre    AS usuario_que_reporta,
    u.email     AS email_usuario,
    c.titulo    AS contenido_reportado,
    c.tipo_contenido
FROM REPORTE   r
JOIN PERFIL    p  ON r.id_perfil_informa      = p.id_perfil
JOIN USUARIO   u  ON p.id_usuario             = u.id_usuario
JOIN CONTENIDO c  ON r.id_contenido_reportado = c.id_contenido
WHERE r.estado = 'PENDIENTE'
ORDER BY r.fecha_reporte ASC;

GRANT SELECT ON QUINDIOFLIX_OWNER.VW_REPORTES_PENDIENTES TO ROL_SOPORTE;
GRANT SELECT ON QUINDIOFLIX_OWNER.VW_REPORTES_PENDIENTES TO ROL_ADMIN;

-- ============================================================
-- SECCIÓN 6: DEMOSTRACIÓN DE RESTRICCIÓN DE ACCESO
-- Probar que cada usuario SOLO puede hacer lo que su rol permite.
-- ============================================================

-- ------------------------------------------------------------
-- 6.1 Demostración ROL_ANALISTA: puede hacer SELECT, no INSERT
-- ------------------------------------------------------------
-- Conectarse como usr_analista y ejecutar:

-- PERMITIDO: consulta de datos
-- SELECT * FROM QUINDIOFLIX_OWNER.USUARIO;         → FUNCIONA
-- SELECT * FROM QUINDIOFLIX_OWNER.MV_INGRESOS_MENSUALES; → FUNCIONA

-- NO PERMITIDO: modificación de datos
-- INSERT INTO QUINDIOFLIX_OWNER.USUARIO VALUES(...); → ERROR ORA-01031
-- UPDATE QUINDIOFLIX_OWNER.PLAN SET precio = 0;      → ERROR ORA-01031
-- DELETE FROM QUINDIOFLIX_OWNER.CONTENIDO WHERE ...  → ERROR ORA-01031

-- ------------------------------------------------------------
-- 6.2 Demostración ROL_SOPORTE: puede ver usuarios, no puede ver EMPLEADO
-- ------------------------------------------------------------
-- Conectarse como usr_soporte y ejecutar:

-- PERMITIDO
-- SELECT * FROM QUINDIOFLIX_OWNER.USUARIO;          → FUNCIONA
-- SELECT * FROM QUINDIOFLIX_OWNER.PAGO;             → FUNCIONA
-- EXEC QUINDIOFLIX_OWNER.SP_CAMBIAR_PLAN(1, 2);     → FUNCIONA

-- NO PERMITIDO
-- SELECT * FROM QUINDIOFLIX_OWNER.EMPLEADO;         → ERROR ORA-00942
-- SELECT * FROM QUINDIOFLIX_OWNER.CONTENIDO;        → ERROR ORA-00942
-- DELETE FROM QUINDIOFLIX_OWNER.PAGO WHERE ...;     → ERROR ORA-01031

-- ------------------------------------------------------------
-- 6.3 Demostración ROL_CONTENIDO: puede gestionar catálogo, no usuarios
-- ------------------------------------------------------------
-- Conectarse como usr_contenido y ejecutar:

-- PERMITIDO
-- INSERT INTO QUINDIOFLIX_OWNER.CONTENIDO(...) VALUES (...); → FUNCIONA
-- UPDATE QUINDIOFLIX_OWNER.EPISODIO SET titulo = '...' WHERE ...; → FUNCIONA
-- SELECT * FROM QUINDIOFLIX_OWNER.REPRODUCCION;     → FUNCIONA (solo lectura)

-- NO PERMITIDO
-- SELECT * FROM QUINDIOFLIX_OWNER.USUARIO;          → ERROR ORA-00942
-- DELETE FROM QUINDIOFLIX_OWNER.REPRODUCCION ...;   → ERROR ORA-01031
-- EXEC QUINDIOFLIX_OWNER.SP_REGISTRAR_USUARIO(...); → ERROR ORA-00904

-- ------------------------------------------------------------
-- 6.4 Prueba de bloqueo por intentos fallidos
-- Tras 3 intentos fallidos, PERFIL_USUARIO_NORMAL bloquea la cuenta
-- ------------------------------------------------------------
-- Ejecutar desde sqlplus con credenciales incorrectas:
-- CONNECT usr_soporte/ClaveIncorrecta  → ERROR ORA-01017 (intento 1)
-- CONNECT usr_soporte/ClaveIncorrecta  → ERROR ORA-01017 (intento 2)
-- CONNECT usr_soporte/ClaveIncorrecta  → ERROR ORA-01017 (intento 3)
-- CONNECT usr_soporte/Soporte_QFlix2024# → ERROR ORA-28000 (cuenta bloqueada)

-- Desbloquear manualmente (ejecutar como DBA):
-- ALTER USER usr_soporte ACCOUNT UNLOCK;

-- ============================================================
-- SECCIÓN 7: CONSULTAS DE VERIFICACIÓN DE SEGURIDAD
-- Para auditar el esquema de acceso implementado
-- ============================================================

-- Ver todos los roles del sistema
SELECT role, password_required, authentication_type
FROM dba_roles
WHERE role IN ('ROL_ADMIN', 'ROL_ANALISTA', 'ROL_SOPORTE', 'ROL_CONTENIDO')
ORDER BY role;

-- Ver privilegios de objeto asignados a cada rol
SELECT
    grantee,
    table_name,
    privilege,
    grantable
FROM dba_tab_privs
WHERE grantee IN ('ROL_ADMIN', 'ROL_ANALISTA', 'ROL_SOPORTE', 'ROL_CONTENIDO')
ORDER BY grantee, table_name, privilege;

-- Ver los usuarios Oracle creados y su estado
SELECT
    username,
    account_status,
    profile,
    default_tablespace,
    created,
    lock_date,
    expiry_date
FROM dba_users
WHERE username IN ('USR_ADMIN', 'USR_ANALISTA', 'USR_SOPORTE', 'USR_CONTENIDO')
ORDER BY username;

-- Ver qué roles tiene cada usuario
SELECT
    grantee   AS usuario,
    granted_role AS rol,
    default_role,
    admin_option
FROM dba_role_privs
WHERE grantee IN ('USR_ADMIN', 'USR_ANALISTA', 'USR_SOPORTE', 'USR_CONTENIDO')
ORDER BY grantee;

-- Ver los perfiles y sus límites definidos
SELECT
    profile,
    resource_name,
    limit
FROM dba_profiles
WHERE profile IN ('PERFIL_ADMIN', 'PERFIL_USUARIO_NORMAL')
ORDER BY profile, resource_name;

-- Matriz de acceso: qué puede hacer cada rol sobre cada tabla
SELECT
    tp.grantee       AS rol,
    tp.table_name    AS tabla,
    LISTAGG(tp.privilege, ', ') WITHIN GROUP (ORDER BY tp.privilege) AS privilegios
FROM dba_tab_privs tp
WHERE tp.grantee IN ('ROL_ADMIN', 'ROL_ANALISTA', 'ROL_SOPORTE', 'ROL_CONTENIDO')
  AND tp.owner = 'QUINDIOFLIX_OWNER'
GROUP BY tp.grantee, tp.table_name
ORDER BY tp.grantee, tp.table_name;

-- ============================================================
-- FIN DEL SCRIPT NÚCLEO 5
-- Elementos implementados:
--   4 roles: ROL_ADMIN, ROL_ANALISTA, ROL_SOPORTE, ROL_CONTENIDO
--   2 perfiles de recurso: PERFIL_ADMIN, PERFIL_USUARIO_NORMAL
--   4 usuarios Oracle: usr_admin, usr_analista, usr_soporte, usr_contenido
--   GRANT de privilegios por rol
--   4 vistas para ocultar datos y reportes (punto 4 del documento)
--   Demostración documentada de restricción de acceso por rol
--   Consultas de auditoría y verificación del esquema de seguridad
-- ============================================================
