-- ============================================================
-- QUINDIOFLIX - SCRIPT DE DATOS DE PRUEBA
-- Universidad del Quindío - Bases de Datos II
-- ============================================================
-- Datos ASIMÉTRICOS: distribución desigual por ciudad, plan,
-- dispositivo y categoría para que PIVOT/ROLLUP/CUBE muestren
-- diferencias reales en los reportes.
-- ============================================================

-- ============================================================
-- SECCIÓN 1: CIUDADES (6 ciudades)
-- ============================================================
INSERT INTO CIUDAD VALUES (SEQ_CIUDAD.NEXTVAL, 'Bogotá');
INSERT INTO CIUDAD VALUES (SEQ_CIUDAD.NEXTVAL, 'Medellín');
INSERT INTO CIUDAD VALUES (SEQ_CIUDAD.NEXTVAL, 'Cali');
INSERT INTO CIUDAD VALUES (SEQ_CIUDAD.NEXTVAL, 'Armenia');
INSERT INTO CIUDAD VALUES (SEQ_CIUDAD.NEXTVAL, 'Barranquilla');
INSERT INTO CIUDAD VALUES (SEQ_CIUDAD.NEXTVAL, 'Manizales');

-- ============================================================
-- SECCIÓN 2: DEPARTAMENTOS INTERNOS (5)
-- ============================================================
INSERT INTO DEPARTAMENTO VALUES (SEQ_DEPARTAMENTO.NEXTVAL, 'Tecnología');
INSERT INTO DEPARTAMENTO VALUES (SEQ_DEPARTAMENTO.NEXTVAL, 'Contenido');
INSERT INTO DEPARTAMENTO VALUES (SEQ_DEPARTAMENTO.NEXTVAL, 'Marketing');
INSERT INTO DEPARTAMENTO VALUES (SEQ_DEPARTAMENTO.NEXTVAL, 'Soporte');
INSERT INTO DEPARTAMENTO VALUES (SEQ_DEPARTAMENTO.NEXTVAL, 'Finanzas');

-- ============================================================
-- SECCIÓN 3: PLANES DE SUSCRIPCIÓN (3)
-- Básico=1, Estándar=2, Premium=3
-- ============================================================
INSERT INTO PLAN VALUES (SEQ_PLAN.NEXTVAL, 'Básico',   14900, 1, 'SD', 2);
INSERT INTO PLAN VALUES (SEQ_PLAN.NEXTVAL, 'Estándar', 24900, 2, 'HD', 3);
INSERT INTO PLAN VALUES (SEQ_PLAN.NEXTVAL, 'Premium',  34900, 4, '4K', 5);

-- ============================================================
-- SECCIÓN 4: GÉNEROS (10)
-- ============================================================
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Acción',         'Películas y series de acción y aventura');
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Comedia',        'Contenido humorístico y entretenimiento ligero');
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Drama',          'Contenido dramático y emotivo');
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Suspenso',       'Contenido de thriller y suspenso');
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Romance',        'Historias de amor y relaciones');
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Ciencia Ficción','Mundos futuristas y tecnología avanzada');
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Terror',         'Contenido de miedo y horror');
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Documental',     'Contenido informativo y de no ficción');
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Infantil',       'Contenido apto para niños');
INSERT INTO GENERO VALUES (SEQ_GENERO.NEXTVAL, 'Musical',        'Contenido musical y de entretenimiento');

-- ============================================================
-- SECCIÓN 5: EMPLEADOS (12)
-- Primero los jefes (sin supervisor), luego el resto.
-- Depto: 1=Tecnología 2=Contenido 3=Marketing 4=Soporte 5=Finanzas
-- ============================================================

-- Jefes de departamento (sin supervisor)
INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Carlos Mendoza',   'cmendoza@quindioflix.com',   'Jefe de Tecnología', DATE '2020-01-15', 1, NULL);

INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Laura Vargas',     'lvargas@quindioflix.com',    'Jefe de Contenido',  DATE '2020-02-01', 2, NULL);

INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Ricardo Gómez',   'rgomez@quindioflix.com',     'Jefe de Soporte',    DATE '2020-03-10', 4, NULL);

-- Empleados de Contenido (publican contenido en la plataforma)
INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Andrés Torres',   'atorres@quindioflix.com',    'Analista de Contenido', DATE '2021-01-10', 2, 2);

INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'María López',     'mlopez@quindioflix.com',     'Gestora de Catálogo',  DATE '2021-06-15', 2, 2);

INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Felipe Ríos',     'frios@quindioflix.com',      'Editor de Contenido',  DATE '2022-03-01', 2, 2);

-- Empleados de Soporte (moderadores que resuelven reportes)
INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Daniela Cruz',    'dcruz@quindioflix.com',      'Moderadora Senior',    DATE '2021-04-20', 4, 3);

INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Juan Herrera',    'jherrera@quindioflix.com',   'Moderador Junior',     DATE '2022-08-01', 4, 3);

-- Empleados de Tecnología
INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Sofía Peña',      'spena@quindioflix.com',      'Desarrolladora Backend', DATE '2021-09-15', 1, 1);

INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Camilo Soto',     'csoto@quindioflix.com',      'DBA Oracle',             DATE '2022-01-10', 1, 1);

-- Empleados de Marketing y Finanzas
INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Valentina Mora',  'vmora@quindioflix.com',      'Analista de Marketing',  DATE '2022-05-01', 3, NULL);

INSERT INTO EMPLEADO (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADO.NEXTVAL, 'Luis Castillo',   'lcastillo@quindioflix.com',  'Contador',               DATE '2021-11-20', 5, NULL);

-- ============================================================
-- SECCIÓN 6: USUARIOS (30)
-- Distribución ASIMÉTRICA:
--   Bogotá(1): 12 usuarios | Medellín(2): 8 | Cali(3): 5
--   Armenia(4): 3 | Barranquilla(5): 2
-- Planes: Básico(1): 10 | Estándar(2): 12 | Premium(3): 8
-- Los primeros 5 usuarios se insertan sin referido,
-- luego se agregan referidos para probar esa relación.
-- ============================================================

-- Bogotá - Plan Premium (ids 1-4)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Alejandro Restrepo', 'arestrepo@gmail.com', 'hash_pass_1', '3001112233', DATE '1990-05-12', 'ACTIVO', DATE '2026-04-01', 1, 3, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Juliana Martínez', 'jmartinez@gmail.com', 'hash_pass_2', '3002223344', DATE '1988-11-20', 'ACTIVO', DATE '2026-04-05', 1, 3, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Sebastián Díaz', 'sdiaz@gmail.com', 'hash_pass_3', '3003334455', DATE '1995-03-08', 'ACTIVO', DATE '2026-04-10', 1, 3, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Valentina Castro', 'vcastro@gmail.com', 'hash_pass_4', '3004445566', DATE '1992-07-30', 'ACTIVO', DATE '2026-04-02', 1, 3, NULL);

-- Bogotá - Plan Estándar (ids 5-9)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Camila Rojas', 'crojas@gmail.com', 'hash_pass_5', '3005556677', DATE '1997-01-15', 'ACTIVO', DATE '2026-04-08', 1, 2, 1);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Nicolás Herrera', 'nherrera@gmail.com', 'hash_pass_6', '3006667788', DATE '1993-09-22', 'ACTIVO', DATE '2026-04-12', 1, 2, 1);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Isabella Vargas', 'ivargas@gmail.com', 'hash_pass_7', '3007778899', DATE '1999-12-05', 'ACTIVO', DATE '2026-03-15', 1, 2, 2);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Mateo Gutiérrez', 'mgutierrez@gmail.com', 'hash_pass_8', '3008889900', DATE '1991-06-18', 'ACTIVO', DATE '2026-04-20', 1, 2, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Sara Moreno', 'smoreno@gmail.com', 'hash_pass_9', '3009990011', DATE '1996-04-25', 'INACTIVO', DATE '2026-02-01', 1, 2, NULL);

-- Bogotá - Plan Básico (ids 10-12)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Daniel Ospina', 'dospina@gmail.com', 'hash_pass_10', '3010001122', DATE '2000-08-14', 'ACTIVO', DATE '2026-04-15', 1, 1, 3);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Luisa Fernández', 'lfernandez@gmail.com', 'hash_pass_11', '3011112233', DATE '2001-02-28', 'ACTIVO', DATE '2026-04-18', 1, 1, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Tomás Pérez', 'tperez@gmail.com', 'hash_pass_12', '3012223344', DATE '1998-10-10', 'ACTIVO', DATE '2026-04-22', 1, 1, NULL);

-- Medellín - Plan Premium (ids 13-15)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Paula Agudelo', 'pagudelo@gmail.com', 'hash_pass_13', '3013334455', DATE '1987-03-17', 'ACTIVO', DATE '2026-04-03', 2, 3, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Andrés Londoño', 'alondono@gmail.com', 'hash_pass_14', '3014445566', DATE '1985-07-09', 'ACTIVO', DATE '2026-04-07', 2, 3, 13);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Manuela Ríos', 'mrios@gmail.com', 'hash_pass_15', '3015556677', DATE '1994-11-03', 'ACTIVO', DATE '2026-04-14', 2, 3, NULL);

-- Medellín - Plan Estándar (ids 16-18)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Santiago Velásquez', 'svelasquez@gmail.com', 'hash_pass_16', '3016667788', DATE '1990-01-27', 'ACTIVO', DATE '2026-04-09', 2, 2, 13);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Natalia Álvarez', 'nalvarez@gmail.com', 'hash_pass_17', '3017778899', DATE '1993-05-14', 'ACTIVO', DATE '2026-04-16', 2, 2, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Esteban Cano', 'ecano@gmail.com', 'hash_pass_18', '3018889900', DATE '1989-08-31', 'SUSPENDIDO', DATE '2026-01-10', 2, 2, NULL);

-- Medellín - Plan Básico (ids 19-20)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Carolina Zapata', 'czapata@gmail.com', 'hash_pass_19', '3019990011', DATE '2002-04-19', 'ACTIVO', DATE '2026-04-21', 2, 1, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'David Salazar', 'dsalazar@gmail.com', 'hash_pass_20', '3020001122', DATE '1997-12-08', 'ACTIVO', DATE '2026-04-25', 2, 1, 19);

-- Cali - Plan Estándar (ids 21-23)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Ximena Córdoba', 'xcordoba@gmail.com', 'hash_pass_21', '3021112233', DATE '1991-09-16', 'ACTIVO', DATE '2026-04-11', 3, 2, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Jorge Lozano', 'jlozano@gmail.com', 'hash_pass_22', '3022223344', DATE '1986-02-23', 'ACTIVO', DATE '2026-04-06', 3, 2, 21);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Paola Muñoz', 'pmunoz@gmail.com', 'hash_pass_23', '3023334455', DATE '1999-06-07', 'ACTIVO', DATE '2026-04-19', 3, 2, NULL);

-- Cali - Plan Básico (ids 24-25)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Rodrigo Silva', 'rsilva@gmail.com', 'hash_pass_24', '3024445566', DATE '1994-12-01', 'ACTIVO', DATE '2026-04-17', 3, 1, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Gloria Patiño', 'gpatino@gmail.com', 'hash_pass_25', '3025556677', DATE '1988-04-11', 'INACTIVO', DATE '2026-01-28', 3, 1, NULL);

-- Armenia - Plan Estándar (ids 26-27)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Julián Ramírez', 'jramirez@gmail.com', 'hash_pass_26', '3026667788', DATE '1996-08-24', 'ACTIVO', DATE '2026-04-13', 4, 2, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Lina Betancourt', 'lbetancourt@gmail.com', 'hash_pass_27', '3027778899', DATE '1993-03-05', 'ACTIVO', DATE '2026-04-23', 4, 2, 26);

-- Armenia - Plan Básico (id 28)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Héctor Cardona', 'hcardona@gmail.com', 'hash_pass_28', '3028889900', DATE '1984-07-19', 'ACTIVO', DATE '2026-04-26', 4, 1, NULL);

-- Barranquilla - Plan Premium y Básico (ids 29-30)
INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Adriana Polo', 'apolo@gmail.com', 'hash_pass_29', '3029990011', DATE '1990-10-30', 'ACTIVO', DATE '2026-04-04', 5, 3, NULL);

INSERT INTO USUARIO (id_usuario, nombre, email, contrasena, telefono, fecha_nacimiento, estado_cuenta, fecha_ultimo_pago, id_ciudad, id_plan, id_referido_por)
VALUES (SEQ_USUARIO.NEXTVAL, 'Mauricio Blanco', 'mblanco@gmail.com', 'hash_pass_30', '3030001122', DATE '1987-01-14', 'ACTIVO', DATE '2026-04-24', 5, 1, 29);

-- ============================================================
-- SECCIÓN 7: PERFILES (55 perfiles)
-- Plan Básico: hasta 2 perfiles | Estándar: 3 | Premium: 5
-- ============================================================

-- Usuarios Premium de Bogotá (hasta 5 perfiles c/u)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Alejandro',  'avatar_01.png', 'ADULTO',   1);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Niños',      'avatar_kid.png','INFANTIL',  1);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Juliana',    'avatar_02.png', 'ADULTO',   2);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Trabajo',    'avatar_03.png', 'ADULTO',   2);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Sebastián',  'avatar_04.png', 'ADULTO',   3);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Valentina',  'avatar_05.png', 'ADULTO',   4);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Familia V',  'avatar_06.png', 'INFANTIL',  4);
-- Usuarios Estándar de Bogotá (hasta 3 perfiles)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Camila',     'avatar_07.png', 'ADULTO',   5);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Nicolás',    'avatar_08.png', 'ADULTO',   6);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Compañero',  'avatar_09.png', 'ADULTO',   6);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Isabella',   'avatar_10.png', 'ADULTO',   7);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Mateo',      'avatar_11.png', 'ADULTO',   8);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Sara',       'avatar_12.png', 'ADULTO',   9);
-- Usuarios Básico de Bogotá (hasta 2 perfiles)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Daniel',     'avatar_13.png', 'ADULTO',   10);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Luisa',      'avatar_14.png', 'ADULTO',   11);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Tomás',      'avatar_15.png', 'ADULTO',   12);
-- Medellín - Premium
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Paula',      'avatar_16.png', 'ADULTO',   13);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Hijos P',    'avatar_kid.png','INFANTIL',  13);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Andrés L',   'avatar_17.png', 'ADULTO',   14);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Esposa',     'avatar_18.png', 'ADULTO',   14);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Manuela',    'avatar_19.png', 'ADULTO',   15);
-- Medellín - Estándar
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Santiago',   'avatar_20.png', 'ADULTO',   16);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Pareja S',   'avatar_21.png', 'ADULTO',   16);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Natalia',    'avatar_22.png', 'ADULTO',   17);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Esteban',    'avatar_23.png', 'ADULTO',   18);
-- Medellín - Básico
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Carolina',   'avatar_24.png', 'ADULTO',   19);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'David',      'avatar_25.png', 'ADULTO',   20);
-- Cali - Estándar
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Ximena',     'avatar_26.png', 'ADULTO',   21);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Hijos X',    'avatar_kid.png','INFANTIL',  21);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Jorge',      'avatar_27.png', 'ADULTO',   22);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Paola',      'avatar_28.png', 'ADULTO',   23);
-- Cali - Básico
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Rodrigo',    'avatar_29.png', 'ADULTO',   24);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Gloria',     'avatar_30.png', 'ADULTO',   25);
-- Armenia
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Julián',     'avatar_31.png', 'ADULTO',   26);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Pareja J',   'avatar_36.png', 'ADULTO',   26); -- Estándar: cupo para 3
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Lina',       'avatar_32.png', 'ADULTO',   27);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Pareja L',   'avatar_37.png', 'ADULTO',   27); -- Estándar: cupo para 3
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Héctor',     'avatar_33.png', 'ADULTO',   28);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Hijos H',    'avatar_kid.png','INFANTIL',  28); -- Básico: cupo para 2
-- Barranquilla
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Adriana',    'avatar_34.png', 'ADULTO',   29);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Hijos A',    'avatar_kid.png','INFANTIL',  29);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Trabajo A',  'avatar_38.png', 'ADULTO',   29); -- Premium: cupo para 5
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Mauricio',   'avatar_35.png', 'ADULTO',   30);
-- Perfiles extra para completar mínimo de 50 (usuarios con cupo disponible)
-- Usuario 1 Premium Bogotá (tiene 2, puede tener 5)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Trabajo A',  'avatar_39.png', 'ADULTO',   1);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Invitado A', 'avatar_40.png', 'ADULTO',   1);
-- Usuario 13 Premium Medellín (tiene 2, puede tener 5)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Trabajo P',  'avatar_41.png', 'ADULTO',   13);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Invitado P', 'avatar_42.png', 'ADULTO',   13);
-- Usuario 14 Premium Medellín (tiene 2, puede tener 5)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Hijo A',     'avatar_kid.png','INFANTIL',  14);
-- Usuario 15 Premium Medellín (tiene 1, puede tener 5)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Pareja M',   'avatar_43.png', 'ADULTO',   15);
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Hijos M',    'avatar_kid.png','INFANTIL',  15);
-- Usuario 5 Estándar Bogotá (tiene 1, puede tener 3)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Pareja C',   'avatar_44.png', 'ADULTO',   5);
-- Usuario 16 Estándar Medellín (tiene 2, puede tener 3)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Hijos S',    'avatar_kid.png','INFANTIL',  16);
-- Usuario 21 Estándar Cali (tiene 2, puede tener 3)
INSERT INTO PERFIL VALUES (SEQ_PERFIL.NEXTVAL, 'Trabajo X',  'avatar_45.png', 'ADULTO',   21);

-- ============================================================
-- SECCIÓN 8: CONTENIDO (42 registros)
-- Tipos: PELICULA(15) SERIE(10) DOCUMENTAL(6) MUSICA(6) PODCAST(5)
-- Publicado por empleados de Contenido: ids 4, 5, 6
-- ============================================================

-- === PELÍCULAS (15) ===
INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'El Último Vuelo', 2022, INTERVAL '0 02:08:00' DAY TO SECOND, 'Un piloto debe salvar su avión en medio de una tormenta perfecta.', '+13', DATE '2023-01-10', 0, 'PELICULA', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Amor en Bogotá', 2021, INTERVAL '0 01:45:00' DAY TO SECOND, 'Una historia de amor que nace en el caos de la capital colombiana.', '+7', DATE '2023-02-15', 1, 'PELICULA', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'La Sombra del Cartel', 2023, INTERVAL '0 02:20:00' DAY TO SECOND, 'Un detective infiltrado descubre una red criminal en la ciudad.', '+16', DATE '2023-03-20', 0, 'PELICULA', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Galaxia Sin Nombre', 2022, INTERVAL '0 02:35:00' DAY TO SECOND, 'En el año 3000, una nave explora los confines del universo.', '+13', DATE '2023-04-05', 1, 'PELICULA', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Abuela Chef', 2020, INTERVAL '0 01:30:00' DAY TO SECOND, 'Una abuela decide abrir el mejor restaurante de su pueblo.', 'TP', DATE '2023-05-01', 0, 'PELICULA', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'El Exorcismo', 2023, INTERVAL '0 01:55:00' DAY TO SECOND, 'Un sacerdote enfrenta la presencia más oscura de su carrera.', '+18', DATE '2023-06-15', 0, 'PELICULA', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Ríos de Fuego', 2021, INTERVAL '0 02:10:00' DAY TO SECOND, 'Bomberos colombianos luchan contra incendios forestales.', '+7', DATE '2023-07-20', 1, 'PELICULA', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'El Tiempo Detenido', 2024, INTERVAL '0 01:50:00' DAY TO SECOND, 'Un científico descubre cómo congelar el tiempo pero pierde el control.', '+13', DATE '2024-01-10', 1, 'PELICULA', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Mariposas Negras', 2022, INTERVAL '0 01:40:00' DAY TO SECOND, 'Un thriller psicológico sobre obsesión y manipulación.', '+16', DATE '2024-02-05', 0, 'PELICULA', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Fiesta en el Barrio', 2023, INTERVAL '0 01:35:00' DAY TO SECOND, 'Una comedia sobre un barrio que organiza la mejor fiesta del año.', 'TP', DATE '2024-03-01', 1, 'PELICULA', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Código Rojo', 2024, INTERVAL '0 02:00:00' DAY TO SECOND, 'Hackers colombianos intentan detener un ciberataque masivo.', '+13', DATE '2024-04-10', 1, 'PELICULA', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'La Montaña Azul', 2020, INTERVAL '0 01:25:00' DAY TO SECOND, 'Una expedición a los Andes revela un antiguo secreto.', '+7', DATE '2024-05-15', 0, 'PELICULA', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Sin Salida', 2023, INTERVAL '0 01:58:00' DAY TO SECOND, 'Cinco extraños quedan atrapados en un bunker subterráneo.', '+16', DATE '2024-06-01', 0, 'PELICULA', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'El Gran Robo', 2024, INTERVAL '0 02:15:00' DAY TO SECOND, 'Un grupo de ladrones planea el robo más audaz de la historia.', '+13', DATE '2024-07-20', 1, 'PELICULA', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Sueños de Papel', 2021, INTERVAL '0 01:42:00' DAY TO SECOND, 'Una escritora encuentra inspiración en las cartas de un desconocido.', '+7', DATE '2024-08-10', 0, 'PELICULA', 4);

-- Registro en tabla hija PELICULA
INSERT INTO PELICULA VALUES (1);
INSERT INTO PELICULA VALUES (2);
INSERT INTO PELICULA VALUES (3);
INSERT INTO PELICULA VALUES (4);
INSERT INTO PELICULA VALUES (5);
INSERT INTO PELICULA VALUES (6);
INSERT INTO PELICULA VALUES (7);
INSERT INTO PELICULA VALUES (8);
INSERT INTO PELICULA VALUES (9);
INSERT INTO PELICULA VALUES (10);
INSERT INTO PELICULA VALUES (11);
INSERT INTO PELICULA VALUES (12);
INSERT INTO PELICULA VALUES (13);
INSERT INTO PELICULA VALUES (14);
INSERT INTO PELICULA VALUES (15);

-- === SERIES (10, ids 16-25) ===
INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'La Casa de la Selva', 2022, NULL, 'Una familia se pierde en el Amazonas y debe sobrevivir.', '+13', DATE '2023-01-20', 1, 'SERIE', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Narco Code', 2021, NULL, 'Serie sobre agentes que descifran comunicaciones del narcotráfico.', '+16', DATE '2023-02-10', 0, 'SERIE', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Risas en Familia', 2020, NULL, 'Sitcom sobre una familia colombiana de tres generaciones.', 'TP', DATE '2023-03-05', 1, 'SERIE', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Dimensión Paralela', 2023, NULL, 'Científica viaja a mundos alternativos buscando a su familia perdida.', '+13', DATE '2023-04-15', 1, 'SERIE', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'El Consultor', 2022, NULL, 'Un consultor corporativo con oscuros secretos toma el control de una empresa.', '+16', DATE '2023-05-20', 0, 'SERIE', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Amor Digital', 2024, NULL, 'Jóvenes navegan el amor en la era de las redes sociales.', '+13', DATE '2024-01-25', 1, 'SERIE', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Los Invisibles', 2023, NULL, 'Drama sobre personas sin hogar en Bogotá que forman una comunidad.', '+7', DATE '2024-02-15', 1, 'SERIE', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Pesadillas', 2023, NULL, 'Antología de terror psicológico colombiano.', '+18', DATE '2024-03-10', 0, 'SERIE', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Fútbol en el Alma', 2022, NULL, 'Un equipo de barrio sueña con llegar a la primera división.', 'TP', DATE '2024-04-05', 1, 'SERIE', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'La Investigadora', 2024, NULL, 'Una periodista investiga casos de corrupción poniendo su vida en riesgo.', '+16', DATE '2024-05-20', 1, 'SERIE', 4);

INSERT INTO SERIE VALUES (16);
INSERT INTO SERIE VALUES (17);
INSERT INTO SERIE VALUES (18);
INSERT INTO SERIE VALUES (19);
INSERT INTO SERIE VALUES (20);
INSERT INTO SERIE VALUES (21);
INSERT INTO SERIE VALUES (22);
INSERT INTO SERIE VALUES (23);
INSERT INTO SERIE VALUES (24);
INSERT INTO SERIE VALUES (25);

-- === DOCUMENTALES (6, ids 26-31) ===
INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Selva Viva', 2022, INTERVAL '0 01:30:00' DAY TO SECOND, 'Exploración de la biodiversidad del Amazonas colombiano.', 'TP', DATE '2023-02-01', 1, 'DOCUMENTAL', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Economía del Café', 2021, INTERVAL '0 01:15:00' DAY TO SECOND, 'Cómo el café transformó la economía del Eje Cafetero.', 'TP', DATE '2023-04-10', 0, 'DOCUMENTAL', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Fronteras Invisibles', 2023, INTERVAL '0 01:45:00' DAY TO SECOND, 'Migrantes venezolanos y su integración en Colombia.', '+7', DATE '2023-06-20', 1, 'DOCUMENTAL', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Oceanos en Peligro', 2022, INTERVAL '0 01:20:00' DAY TO SECOND, 'El impacto humano en los ecosistemas marinos colombianos.', 'TP', DATE '2023-08-15', 0, 'DOCUMENTAL', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Historia del Vallenato', 2024, INTERVAL '0 01:10:00' DAY TO SECOND, 'Orígenes y evolución del género musical más representativo de Colombia.', 'TP', DATE '2024-02-20', 1, 'DOCUMENTAL', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Los Niños de la Paz', 2023, INTERVAL '0 01:35:00' DAY TO SECOND, 'Infancia en zonas de posconflicto en Colombia.', '+7', DATE '2024-04-30', 1, 'DOCUMENTAL', 6);

INSERT INTO DOCUMENTAL VALUES (26);
INSERT INTO DOCUMENTAL VALUES (27);
INSERT INTO DOCUMENTAL VALUES (28);
INSERT INTO DOCUMENTAL VALUES (29);
INSERT INTO DOCUMENTAL VALUES (30);
INSERT INTO DOCUMENTAL VALUES (31);

-- === MÚSICA (6, ids 32-37) ===
INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Tropical Hits 2024', 2024, INTERVAL '0 01:05:00' DAY TO SECOND, 'Compilado de los mejores éxitos tropicales del año.', 'TP', DATE '2024-01-15', 0, 'MUSICA', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Rock Andino', 2023, INTERVAL '0 00:58:00' DAY TO SECOND, 'Fusión de rock con ritmos andinos colombianos.', '+7', DATE '2024-02-10', 1, 'MUSICA', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Salsa Caleña Clásica', 2022, INTERVAL '0 01:12:00' DAY TO SECOND, 'Los clásicos de la salsa caleña para bailar sin parar.', 'TP', DATE '2024-03-05', 0, 'MUSICA', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Urbano Colombiano', 2024, INTERVAL '0 00:52:00' DAY TO SECOND, 'Lo mejor del reggaeton y trap colombiano del momento.', '+13', DATE '2024-04-01', 1, 'MUSICA', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Vallenato Eterno', 2023, INTERVAL '0 01:20:00' DAY TO SECOND, 'Los vallenatos más queridos de todos los tiempos.', 'TP', DATE '2024-05-10', 0, 'MUSICA', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Jazz Bogotano', 2024, INTERVAL '0 00:48:00' DAY TO SECOND, 'Artistas de jazz emergentes de la escena bogotana.', 'TP', DATE '2024-06-15', 1, 'MUSICA', 6);

INSERT INTO MUSICA VALUES (32);
INSERT INTO MUSICA VALUES (33);
INSERT INTO MUSICA VALUES (34);
INSERT INTO MUSICA VALUES (35);
INSERT INTO MUSICA VALUES (36);
INSERT INTO MUSICA VALUES (37);

-- === PODCASTS (5, ids 38-42) ===
INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Emprendimiento Hoy', 2023, NULL, 'Historias de emprendedores colombianos que transformaron sus ideas.', 'TP', DATE '2023-03-01', 1, 'PODCAST', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Crimen Verdadero CO', 2022, NULL, 'Investigación de los casos criminales más impactantes de Colombia.', '+16', DATE '2023-05-10', 0, 'PODCAST', 5);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Ciencia Para Todos', 2024, NULL, 'Divulgación científica en español para toda la familia.', 'TP', DATE '2024-01-20', 1, 'PODCAST', 6);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Bienestar Mental', 2023, NULL, 'Psicólogos colombianos hablan sobre salud mental y autocuidado.', '+7', DATE '2024-03-15', 1, 'PODCAST', 4);

INSERT INTO CONTENIDO (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, tipo_contenido, id_empleado_publica)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Historia Colombia', 2022, NULL, 'Episodios que revelan la historia oculta de Colombia.', '+7', DATE '2024-05-01', 0, 'PODCAST', 5);

INSERT INTO PODCAST VALUES (38);
INSERT INTO PODCAST VALUES (39);
INSERT INTO PODCAST VALUES (40);
INSERT INTO PODCAST VALUES (41);
INSERT INTO PODCAST VALUES (42);

-- ============================================================
-- SECCIÓN 9: TEMPORADAS (15) Y EPISODIOS (50)
-- Series: 16-25 | Podcasts: 38-42
-- ============================================================

-- Temporadas de La Casa de la Selva (id_contenido=16)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 16);
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 2, 16);
-- Temporadas de Narco Code (id_contenido=17)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 17);
-- Temporadas de Risas en Familia (id_contenido=18)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 18);
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 2, 18);
-- Temporadas de Dimensión Paralela (id_contenido=19)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 19);
-- Temporadas de El Consultor (id_contenido=20)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 20);
-- Temporadas de Amor Digital (id_contenido=21)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 21);
-- Podcast: Emprendimiento Hoy (id_contenido=38)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 38);
-- Podcast: Crimen Verdadero CO (id_contenido=39)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 39);
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 2, 39);
-- Podcast: Ciencia Para Todos (id_contenido=40)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 40);
-- Podcast: Bienestar Mental (id_contenido=41)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 41);
-- Podcast: Historia Colombia (id_contenido=42)
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 1, 42);
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 2, 42);
INSERT INTO TEMPORADA VALUES (SEQ_TEMPORADA.NEXTVAL, 3, 42);

-- Episodios de La Casa de la Selva T1 (id_temporada=1): 5 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'La Llegada',       INTERVAL '0 00:45:00' DAY TO SECOND, 1);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'Sin Señal',         INTERVAL '0 00:42:00' DAY TO SECOND, 1);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Primeras Noches',   INTERVAL '0 00:47:00' DAY TO SECOND, 1);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 4, 'El Río Habla',      INTERVAL '0 00:44:00' DAY TO SECOND, 1);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 5, 'Encontrados',       INTERVAL '0 00:50:00' DAY TO SECOND, 1);

-- Episodios de La Casa de la Selva T2 (id_temporada=2): 4 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'Regreso',           INTERVAL '0 00:46:00' DAY TO SECOND, 2);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'Nuevos Peligros',   INTERVAL '0 00:43:00' DAY TO SECOND, 2);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'La Tribu',          INTERVAL '0 00:48:00' DAY TO SECOND, 2);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 4, 'Desafíos',          INTERVAL '0 00:51:00' DAY TO SECOND, 2);

-- Episodios de Narco Code T1 (id_temporada=3): 5 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'El Código',         INTERVAL '0 00:55:00' DAY TO SECOND, 3);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'Infiltración',      INTERVAL '0 00:52:00' DAY TO SECOND, 3);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Doble Juego',       INTERVAL '0 00:58:00' DAY TO SECOND, 3);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 4, 'La Traición',       INTERVAL '0 00:53:00' DAY TO SECOND, 3);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 5, 'Sin Retorno',       INTERVAL '0 01:00:00' DAY TO SECOND, 3);

-- Episodios de Risas en Familia T1 (id_temporada=4): 4 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'La Reunión',        INTERVAL '0 00:25:00' DAY TO SECOND, 4);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'El Cumpleaños',     INTERVAL '0 00:24:00' DAY TO SECOND, 4);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Malentendidos',     INTERVAL '0 00:26:00' DAY TO SECOND, 4);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 4, 'La Sorpresa',       INTERVAL '0 00:25:00' DAY TO SECOND, 4);

-- Episodios de Risas en Familia T2 (id_temporada=5): 4 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'Año Nuevo',         INTERVAL '0 00:27:00' DAY TO SECOND, 5);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'El Vecino',         INTERVAL '0 00:25:00' DAY TO SECOND, 5);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Vacaciones',        INTERVAL '0 00:26:00' DAY TO SECOND, 5);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 4, 'Final de Año',      INTERVAL '0 00:28:00' DAY TO SECOND, 5);

-- Episodios de Dimensión Paralela T1 (id_temporada=6): 4 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'El Portal',         INTERVAL '0 00:48:00' DAY TO SECOND, 6);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'Mundo Espejo',      INTERVAL '0 00:46:00' DAY TO SECOND, 6);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'La Versión',        INTERVAL '0 00:50:00' DAY TO SECOND, 6);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 4, 'Colapso',           INTERVAL '0 00:52:00' DAY TO SECOND, 6);

-- Episodios de El Consultor T1 (id_temporada=7): 4 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'El Contrato',       INTERVAL '0 00:50:00' DAY TO SECOND, 7);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'Las Reglas',        INTERVAL '0 00:47:00' DAY TO SECOND, 7);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Poder Oculto',      INTERVAL '0 00:49:00' DAY TO SECOND, 7);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 4, 'El Precio',         INTERVAL '0 00:53:00' DAY TO SECOND, 7);

-- Episodios de Amor Digital T1 (id_temporada=8): 4 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'Match Perfecto',    INTERVAL '0 00:40:00' DAY TO SECOND, 8);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'Primera Cita',      INTERVAL '0 00:38:00' DAY TO SECOND, 8);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Likes y Mentiras',  INTERVAL '0 00:42:00' DAY TO SECOND, 8);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 4, 'Desconectados',     INTERVAL '0 00:44:00' DAY TO SECOND, 8);

-- Episodios de Podcast Emprendimiento Hoy T1 (id_temporada=9): 4 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'Desde Cero',        INTERVAL '0 00:55:00' DAY TO SECOND, 9);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'El Fracaso Exitoso',INTERVAL '0 00:48:00' DAY TO SECOND, 9);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Financiamiento',    INTERVAL '0 00:52:00' DAY TO SECOND, 9);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 4, 'Crecer Sin Morir',  INTERVAL '0 00:50:00' DAY TO SECOND, 9);

-- Episodios de Podcast Ciencia Para Todos T1 (id_temporada=12): 3 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'El Big Bang',           INTERVAL '0 00:45:00' DAY TO SECOND, 12);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'La Célula',             INTERVAL '0 00:42:00' DAY TO SECOND, 12);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Inteligencia Artificial', INTERVAL '0 00:48:00' DAY TO SECOND, 12);

-- Episodios de Podcast Bienestar Mental T1 (id_temporada=13): 3 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'Ansiedad y Estrés',    INTERVAL '0 00:50:00' DAY TO SECOND, 13);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'Duelo y Pérdida',      INTERVAL '0 00:47:00' DAY TO SECOND, 13);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Autocuidado',           INTERVAL '0 00:52:00' DAY TO SECOND, 13);

-- Episodios de Podcast Historia Colombia T1 (id_temporada=14): 3 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'La Independencia',     INTERVAL '0 00:55:00' DAY TO SECOND, 14);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'La Violencia',         INTERVAL '0 00:58:00' DAY TO SECOND, 14);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'El Frente Nacional',   INTERVAL '0 00:53:00' DAY TO SECOND, 14);

-- Episodios de Podcast Crimen Verdadero CO T1 (id_temporada=10): 3 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'El Caso Molina',    INTERVAL '0 01:05:00' DAY TO SECOND, 10);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'Sin Testigos',      INTERVAL '0 00:58:00' DAY TO SECOND, 10);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'La Confesión',      INTERVAL '0 01:02:00' DAY TO SECOND, 10);

-- Episodios de Podcast Crimen Verdadero CO T2 (id_temporada=11): 3 eps
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 1, 'Caso Sin Resolver', INTERVAL '0 01:08:00' DAY TO SECOND, 11);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 2, 'El Testigo Clave',  INTERVAL '0 00:55:00' DAY TO SECOND, 11);
INSERT INTO EPISODIO VALUES (SEQ_EPISODIO.NEXTVAL, 3, 'Veredicto Final',   INTERVAL '0 01:00:00' DAY TO SECOND, 11);

-- ============================================================
-- SECCIÓN 10: GÉNEROS POR CONTENIDO
-- ============================================================
-- Películas
INSERT INTO CONTENIDO_GENERO VALUES (1,  1); -- El Último Vuelo: Acción
INSERT INTO CONTENIDO_GENERO VALUES (1,  4); -- El Último Vuelo: Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (2,  5); -- Amor en Bogotá: Romance
INSERT INTO CONTENIDO_GENERO VALUES (2,  3); -- Amor en Bogotá: Drama
INSERT INTO CONTENIDO_GENERO VALUES (3,  4); -- La Sombra del Cartel: Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (3,  3); -- La Sombra del Cartel: Drama
INSERT INTO CONTENIDO_GENERO VALUES (4,  6); -- Galaxia Sin Nombre: Ciencia Ficción
INSERT INTO CONTENIDO_GENERO VALUES (4,  1); -- Galaxia Sin Nombre: Acción
INSERT INTO CONTENIDO_GENERO VALUES (5,  2); -- Abuela Chef: Comedia
INSERT INTO CONTENIDO_GENERO VALUES (5,  9); -- Abuela Chef: Infantil
INSERT INTO CONTENIDO_GENERO VALUES (6,  7); -- El Exorcismo: Terror
INSERT INTO CONTENIDO_GENERO VALUES (7,  1); -- Ríos de Fuego: Acción
INSERT INTO CONTENIDO_GENERO VALUES (7,  3); -- Ríos de Fuego: Drama
INSERT INTO CONTENIDO_GENERO VALUES (8,  6); -- El Tiempo Detenido: Ciencia Ficción
INSERT INTO CONTENIDO_GENERO VALUES (8,  4); -- El Tiempo Detenido: Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (9,  4); -- Mariposas Negras: Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (9,  7); -- Mariposas Negras: Terror
INSERT INTO CONTENIDO_GENERO VALUES (10, 2); -- Fiesta en el Barrio: Comedia
INSERT INTO CONTENIDO_GENERO VALUES (11, 1); -- Código Rojo: Acción
INSERT INTO CONTENIDO_GENERO VALUES (11, 6); -- Código Rojo: Ciencia Ficción
INSERT INTO CONTENIDO_GENERO VALUES (12, 1); -- La Montaña Azul: Acción
INSERT INTO CONTENIDO_GENERO VALUES (13, 4); -- Sin Salida: Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (14, 1); -- El Gran Robo: Acción
INSERT INTO CONTENIDO_GENERO VALUES (14, 4); -- El Gran Robo: Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (15, 5); -- Sueños de Papel: Romance
INSERT INTO CONTENIDO_GENERO VALUES (15, 3); -- Sueños de Papel: Drama
-- Series
INSERT INTO CONTENIDO_GENERO VALUES (16, 1); -- La Casa de la Selva: Acción
INSERT INTO CONTENIDO_GENERO VALUES (16, 3); -- La Casa de la Selva: Drama
INSERT INTO CONTENIDO_GENERO VALUES (17, 4); -- Narco Code: Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (18, 2); -- Risas en Familia: Comedia
INSERT INTO CONTENIDO_GENERO VALUES (18, 9); -- Risas en Familia: Infantil
INSERT INTO CONTENIDO_GENERO VALUES (19, 6); -- Dimensión Paralela: Ciencia Ficción
INSERT INTO CONTENIDO_GENERO VALUES (20, 4); -- El Consultor: Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (20, 3); -- El Consultor: Drama
INSERT INTO CONTENIDO_GENERO VALUES (21, 5); -- Amor Digital: Romance
INSERT INTO CONTENIDO_GENERO VALUES (22, 3); -- Los Invisibles: Drama
INSERT INTO CONTENIDO_GENERO VALUES (23, 7); -- Pesadillas: Terror
INSERT INTO CONTENIDO_GENERO VALUES (24, 3); -- Fútbol en el Alma: Drama
INSERT INTO CONTENIDO_GENERO VALUES (25, 4); -- La Investigadora: Suspenso
-- Documentales
INSERT INTO CONTENIDO_GENERO VALUES (26, 8); -- Selva Viva: Documental
INSERT INTO CONTENIDO_GENERO VALUES (27, 8); -- Economía del Café: Documental
INSERT INTO CONTENIDO_GENERO VALUES (28, 8); -- Fronteras Invisibles: Documental
INSERT INTO CONTENIDO_GENERO VALUES (29, 8); -- Oceanos en Peligro: Documental
INSERT INTO CONTENIDO_GENERO VALUES (30, 8); -- Historia del Vallenato: Documental
INSERT INTO CONTENIDO_GENERO VALUES (30,10); -- Historia del Vallenato: Musical
INSERT INTO CONTENIDO_GENERO VALUES (31, 8); -- Los Niños de la Paz: Documental
-- Música
INSERT INTO CONTENIDO_GENERO VALUES (32,10); -- Tropical Hits 2024: Musical
INSERT INTO CONTENIDO_GENERO VALUES (33,10); -- Rock Andino: Musical
INSERT INTO CONTENIDO_GENERO VALUES (34,10); -- Salsa Caleña Clásica: Musical
INSERT INTO CONTENIDO_GENERO VALUES (35,10); -- Urbano Colombiano: Musical
INSERT INTO CONTENIDO_GENERO VALUES (36,10); -- Vallenato Eterno: Musical
INSERT INTO CONTENIDO_GENERO VALUES (37,10); -- Jazz Bogotano: Musical
-- Podcasts
INSERT INTO CONTENIDO_GENERO VALUES (38, 8); -- Emprendimiento Hoy: Documental
INSERT INTO CONTENIDO_GENERO VALUES (39, 4); -- Crimen Verdadero CO: Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (40, 8); -- Ciencia Para Todos: Documental
INSERT INTO CONTENIDO_GENERO VALUES (41, 8); -- Bienestar Mental: Documental
INSERT INTO CONTENIDO_GENERO VALUES (42, 8); -- Historia Colombia: Documental

-- ============================================================
-- SECCIÓN 11: RELACIONES ENTRE CONTENIDOS
-- ============================================================
INSERT INTO RELACION_CONTENIDO VALUES (4, 8,  'secuela');          -- Galaxia Sin Nombre → El Tiempo Detenido
INSERT INTO RELACION_CONTENIDO VALUES (3, 17, 'spin-off');         -- La Sombra del Cartel → Narco Code
INSERT INTO RELACION_CONTENIDO VALUES (1, 7,  'remake');           -- El Último Vuelo → Ríos de Fuego
INSERT INTO RELACION_CONTENIDO VALUES (9, 6,  'version extendida');-- Mariposas Negras → El Exorcismo

-- ============================================================
-- SECCIÓN 12: PAGOS (80)
-- Historial de varios meses, estados variados.
-- ============================================================

-- Pagos exitosos recientes (últimos 3 meses)
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-01', 34900, 'TARJETA_CREDITO', 'EXITOSO', 1);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-05', 34900, 'PSE',             'EXITOSO', 2);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-10', 34900, 'NEQUI',           'EXITOSO', 3);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-02', 34900, 'TARJETA_DEBITO',  'EXITOSO', 4);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-08', 24900, 'DAVIPLATA',       'EXITOSO', 5);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-12', 24900, 'PSE',             'EXITOSO', 6);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-15', 24900, 'TARJETA_CREDITO', 'EXITOSO', 7);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-20', 24900, 'NEQUI',           'EXITOSO', 8);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-15', 14900, 'DAVIPLATA',       'EXITOSO', 10);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-18', 14900, 'PSE',             'EXITOSO', 11);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-22', 14900, 'TARJETA_DEBITO',  'EXITOSO', 12);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-03', 34900, 'TARJETA_CREDITO', 'EXITOSO', 13);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-07', 34900, 'PSE',             'EXITOSO', 14);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-14', 34900, 'NEQUI',           'EXITOSO', 15);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-09', 24900, 'DAVIPLATA',       'EXITOSO', 16);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-16', 24900, 'TARJETA_CREDITO', 'EXITOSO', 17);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-21', 14900, 'PSE',             'EXITOSO', 19);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-25', 14900, 'NEQUI',           'EXITOSO', 20);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-11', 24900, 'TARJETA_DEBITO',  'EXITOSO', 21);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-06', 24900, 'TARJETA_CREDITO', 'EXITOSO', 22);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-19', 24900, 'PSE',             'EXITOSO', 23);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-17', 14900, 'DAVIPLATA',       'EXITOSO', 24);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-13', 24900, 'NEQUI',           'EXITOSO', 26);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-23', 24900, 'TARJETA_CREDITO', 'EXITOSO', 27);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-26', 14900, 'PSE',             'EXITOSO', 28);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-04', 34900, 'TARJETA_DEBITO',  'EXITOSO', 29);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-24', 14900, 'NEQUI',           'EXITOSO', 30);

-- Pagos del mes anterior (marzo 2026)
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-01', 34900, 'TARJETA_CREDITO', 'EXITOSO', 1);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-05', 34900, 'PSE',             'EXITOSO', 2);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-10', 34900, 'NEQUI',           'EXITOSO', 3);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-02', 34900, 'TARJETA_DEBITO',  'EXITOSO', 4);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-08', 24900, 'DAVIPLATA',       'EXITOSO', 5);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-12', 24900, 'PSE',             'EXITOSO', 6);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-20', 24900, 'TARJETA_CREDITO', 'EXITOSO', 8);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-15', 14900, 'DAVIPLATA',       'EXITOSO', 10);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-03', 34900, 'TARJETA_CREDITO', 'EXITOSO', 13);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-07', 34900, 'PSE',             'EXITOSO', 14);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-09', 24900, 'DAVIPLATA',       'EXITOSO', 16);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-11', 24900, 'TARJETA_CREDITO', 'EXITOSO', 21);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-13', 24900, 'NEQUI',           'EXITOSO', 26);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-03-04', 34900, 'TARJETA_DEBITO',  'EXITOSO', 29);

-- Pagos fallidos o pendientes (datos asimétricos para reportes)
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-01', 24900, 'PSE',             'FALLIDO',   9);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-28', 14900, 'NEQUI',           'FALLIDO',  25);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-10', 24900, 'TARJETA_CREDITO', 'REEMBOLSADO', 18);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-27', 34900, 'PSE',             'PENDIENTE',  1);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-04-28', 24900, 'DAVIPLATA',       'PENDIENTE',  6);

-- Pagos de febrero 2026
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-01', 34900, 'TARJETA_CREDITO', 'EXITOSO', 1);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-05', 34900, 'PSE',             'EXITOSO', 2);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-10', 34900, 'NEQUI',           'EXITOSO', 3);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-02', 34900, 'TARJETA_DEBITO',  'EXITOSO', 4);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-08', 24900, 'DAVIPLATA',       'EXITOSO', 5);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-15', 14900, 'DAVIPLATA',       'EXITOSO', 10);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-03', 34900, 'TARJETA_CREDITO', 'EXITOSO', 13);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-07', 34900, 'PSE',             'EXITOSO', 14);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-11', 24900, 'TARJETA_CREDITO', 'EXITOSO', 21);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-02-04', 34900, 'TARJETA_DEBITO',  'EXITOSO', 29);

-- Completando hasta 80 pagos con histórico enero 2026
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-01', 34900, 'TARJETA_CREDITO', 'EXITOSO', 1);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-05', 34900, 'PSE',             'EXITOSO', 2);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-10', 34900, 'NEQUI',           'EXITOSO', 3);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-02', 34900, 'TARJETA_DEBITO',  'EXITOSO', 4);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-08', 24900, 'DAVIPLATA',       'EXITOSO', 5);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-15', 14900, 'DAVIPLATA',       'EXITOSO', 10);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-03', 34900, 'TARJETA_CREDITO', 'EXITOSO', 13);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-07', 34900, 'PSE',             'EXITOSO', 14);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-11', 24900, 'TARJETA_CREDITO', 'EXITOSO', 21);
INSERT INTO PAGO VALUES (SEQ_PAGO.NEXTVAL, DATE '2026-01-04', 34900, 'TARJETA_DEBITO',  'EXITOSO', 29);

-- ============================================================
-- SECCIÓN 13: REPRODUCCIONES (200)
-- Distribución ASIMÉTRICA por dispositivo, ciudad y contenido
-- para que los reportes PIVOT/CUBE muestren diferencias reales.
-- NOTA: los id_episodio NULL corresponden a películas/música.
-- ============================================================

-- Perfil 1 (Alejandro - Bogotá Premium): 8 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-01 20:00:00', TIMESTAMP '2026-04-01 22:08:00', 'TV',         100, 1, 1,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-03 21:00:00', TIMESTAMP '2026-04-03 22:45:00', 'TV',         100, 1, 4,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-05 19:30:00', TIMESTAMP '2026-04-05 20:15:00', 'TV',         45,  1, 16, 1);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-06 20:00:00', TIMESTAMP '2026-04-06 20:45:00', 'TV',         100, 1, 16, 2);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-08 21:30:00', TIMESTAMP '2026-04-08 22:20:00', 'COMPUTADOR', 100, 1, 16, 3);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-10 20:00:00', TIMESTAMP '2026-04-10 21:00:00', 'TV',         90,  1, 17, 10);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-12 22:00:00', TIMESTAMP '2026-04-12 22:50:00', 'COMPUTADOR', 100, 1, 19, 25);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-15 20:00:00', TIMESTAMP '2026-04-15 21:10:00', 'TV',         100, 1, 8,  NULL);

-- Perfil 2 (Niños - Bogotá Premium infantil): 4 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-02 15:00:00', TIMESTAMP '2026-04-02 16:30:00', 'TV',         100, 2, 5,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-07 16:00:00', TIMESTAMP '2026-04-07 16:25:00', 'TABLET',     100, 2, 18, 15);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-09 15:30:00', TIMESTAMP '2026-04-09 15:55:00', 'TABLET',     100, 2, 18, 16);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-14 16:00:00', TIMESTAMP '2026-04-14 16:26:00', 'TV',         100, 2, 18, 17);

-- Perfil 3 (Juliana - Bogotá Premium): 6 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-01 22:00:00', TIMESTAMP '2026-04-01 23:45:00', 'COMPUTADOR', 100, 3, 2,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-04 21:00:00', TIMESTAMP '2026-04-04 22:40:00', 'COMPUTADOR', 100, 3, 3,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-06 20:30:00', TIMESTAMP '2026-04-06 22:10:00', 'CELULAR',    95,  3, 9,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-11 21:00:00', TIMESTAMP '2026-04-11 21:50:00', 'COMPUTADOR', 100, 3, 20, 30);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-13 22:00:00', TIMESTAMP '2026-04-13 22:50:00', 'COMPUTADOR', 100, 3, 20, 31);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-16 21:30:00', TIMESTAMP '2026-04-16 22:15:00', 'COMPUTADOR', 75,  3, 20, 32);

-- Perfil 5 (Camila - Bogotá Estándar): 6 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-02 20:00:00', TIMESTAMP '2026-04-02 21:35:00', 'CELULAR',    100, 5, 2,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-05 21:00:00', TIMESTAMP '2026-04-05 23:00:00', 'CELULAR',    100, 5, 4,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-08 20:30:00', TIMESTAMP '2026-04-08 21:00:00', 'CELULAR',    50,  5, 21, 33);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-10 21:00:00', TIMESTAMP '2026-04-10 21:44:00', 'CELULAR',    100, 5, 21, 34);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-12 20:00:00', TIMESTAMP '2026-04-12 20:42:00', 'TV',         100, 5, 21, 35);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-14 22:00:00', TIMESTAMP '2026-04-14 23:50:00', 'TV',         100, 5, 8,  NULL);

-- Perfil 8 (Camila cuenta 5 - Bogotá Estándar): 5 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-03 20:00:00', TIMESTAMP '2026-04-03 21:30:00', 'TV',         100, 8, 15, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-07 21:00:00', TIMESTAMP '2026-04-07 22:05:00', 'TV',         100, 8, 1,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-09 22:00:00', TIMESTAMP '2026-04-09 22:50:00', 'CELULAR',    100, 8, 22, 22);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-11 20:00:00', TIMESTAMP '2026-04-11 20:50:00', 'CELULAR',    100, 8, 22, 23);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-15 21:30:00', TIMESTAMP '2026-04-15 22:15:00', 'TABLET',     80,  8, 38, 37);

-- Perfil 9 (Nicolás - Bogotá Estándar): 5 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-01 20:30:00', TIMESTAMP '2026-04-01 22:30:00', 'COMPUTADOR', 100, 9, 11, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-04 21:00:00', TIMESTAMP '2026-04-04 22:00:00', 'COMPUTADOR', 90,  9, 19, 26);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-06 20:00:00', TIMESTAMP '2026-04-06 21:00:00', 'COMPUTADOR', 100, 9, 19, 27);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-10 22:00:00', TIMESTAMP '2026-04-10 22:50:00', 'TV',         100, 9, 16, 4);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-13 20:00:00', TIMESTAMP '2026-04-13 21:58:00', 'TV',         100, 9, 8,  NULL);

-- Perfil 11 (Isabella - Bogotá Estándar): 4 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-02 21:00:00', TIMESTAMP '2026-04-02 22:40:00', 'CELULAR',    100, 11, 15, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-05 20:00:00', TIMESTAMP '2026-04-05 21:00:00', 'CELULAR',    55,  11, 3,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-08 21:00:00', TIMESTAMP '2026-04-08 21:42:00', 'TABLET',     100, 11, 21, 34);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-12 22:00:00', TIMESTAMP '2026-04-12 22:44:00', 'TABLET',     100, 11, 21, 35);

-- Perfil 14 (Daniel - Bogotá Básico): 4 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-03 22:00:00', TIMESTAMP '2026-04-03 23:35:00', 'CELULAR',    100, 14, 1,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-07 20:00:00', TIMESTAMP '2026-04-07 22:15:00', 'TV',         100, 14, 14, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-10 21:00:00', TIMESTAMP '2026-04-10 21:55:00', 'CELULAR',    100, 14, 39, 40);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-14 20:00:00', TIMESTAMP '2026-04-14 21:00:00', 'CELULAR',    85,  14, 39, 41);

-- Perfil 17 (Paula - Medellín Premium): 7 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-01 21:00:00', TIMESTAMP '2026-04-01 23:21:00', 'TV',         100, 17, 3,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-03 20:00:00', TIMESTAMP '2026-04-03 22:10:00', 'TV',         100, 17, 7,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-05 21:00:00', TIMESTAMP '2026-04-05 22:55:00', 'TV',         100, 17, 11, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-07 20:30:00', TIMESTAMP '2026-04-07 21:25:00', 'TV',         100, 17, 17, 12);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-09 21:00:00', TIMESTAMP '2026-04-09 21:55:00', 'TV',         100, 17, 17, 13);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-11 20:00:00', TIMESTAMP '2026-04-11 21:52:00', 'TV',         100, 17, 13, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-13 22:00:00', TIMESTAMP '2026-04-13 23:38:00', 'COMPUTADOR', 100, 17, 25, 29);

-- Perfil 18 (Niños Medellín Premium infantil): 4 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-02 15:00:00', TIMESTAMP '2026-04-02 16:30:00', 'TV',         100, 18, 5,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-06 16:00:00', TIMESTAMP '2026-04-06 16:25:00', 'TABLET',     100, 18, 18, 18);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-10 15:30:00', TIMESTAMP '2026-04-10 15:55:00', 'TABLET',     100, 18, 18, 19);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-13 16:00:00', TIMESTAMP '2026-04-13 17:30:00', 'TV',         100, 18, 10, NULL);

-- Perfil 21 (Manuela - Medellín Premium): 5 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-02 21:00:00', TIMESTAMP '2026-04-02 22:50:00', 'COMPUTADOR', 100, 21, 9,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-05 20:30:00', TIMESTAMP '2026-04-05 22:05:00', 'COMPUTADOR', 100, 21, 2,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-08 21:00:00', TIMESTAMP '2026-04-08 21:50:00', 'CELULAR',    100, 21, 16, 5);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-11 22:00:00', TIMESTAMP '2026-04-11 22:43:00', 'CELULAR',    100, 21, 16, 6);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-14 21:00:00', TIMESTAMP '2026-04-14 21:46:00', 'CELULAR',    100, 21, 16, 7);

-- Perfil 22 (Santiago - Medellín Estándar): 5 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-03 20:00:00', TIMESTAMP '2026-04-03 22:15:00', 'TV',         100, 22, 14, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-06 21:00:00', TIMESTAMP '2026-04-06 22:58:00', 'TV',         100, 22, 11, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-09 20:00:00', TIMESTAMP '2026-04-09 21:00:00', 'TV',         90,  22, 25, 29);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-12 21:00:00', TIMESTAMP '2026-04-12 21:53:00', 'COMPUTADOR', 100, 22, 20, 30);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-15 20:00:00', TIMESTAMP '2026-04-15 21:05:00', 'COMPUTADOR', 100, 22, 40, 45);

-- Perfil 24 (Natalia - Medellín Estándar): 4 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-04 21:00:00', TIMESTAMP '2026-04-04 22:42:00', 'CELULAR',    100, 24, 15, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-08 20:00:00', TIMESTAMP '2026-04-08 21:30:00', 'CELULAR',    100, 24, 7,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-11 21:00:00', TIMESTAMP '2026-04-11 21:40:00', 'TABLET',     100, 24, 41, 46);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-14 22:00:00', TIMESTAMP '2026-04-14 22:48:00', 'TABLET',     100, 24, 41, 47);

-- Perfil 26 (Carolina - Medellín Básico): 4 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-05 21:00:00', TIMESTAMP '2026-04-05 22:20:00', 'CELULAR',    100, 26, 12, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-09 20:00:00', TIMESTAMP '2026-04-09 21:35:00', 'CELULAR',    100, 26, 2,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-12 21:30:00', TIMESTAMP '2026-04-12 22:30:00', 'CELULAR',    70,  26, 39, 43);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-15 22:00:00', TIMESTAMP '2026-04-15 22:55:00', 'CELULAR',    100, 26, 39, 44);

-- Perfil 28 (Ximena - Cali Estándar): 6 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-01 20:00:00', TIMESTAMP '2026-04-01 21:35:00', 'TV',         100, 28, 2,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-04 21:00:00', TIMESTAMP '2026-04-04 22:20:00', 'TV',         100, 28, 12, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-07 20:30:00', TIMESTAMP '2026-04-07 21:15:00', 'TV',         100, 28, 22, 22);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-10 21:00:00', TIMESTAMP '2026-04-10 21:55:00', 'TV',         100, 28, 22, 23);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-13 20:00:00', TIMESTAMP '2026-04-13 21:40:00', 'COMPUTADOR', 100, 28, 23, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-15 21:30:00', TIMESTAMP '2026-04-15 22:15:00', 'COMPUTADOR', 70,  28, 24, 22);

-- Perfil 29 (Niños Cali Estándar infantil): 3 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-03 15:00:00', TIMESTAMP '2026-04-03 16:30:00', 'TV',         100, 29, 5,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-08 16:00:00', TIMESTAMP '2026-04-08 16:26:00', 'TABLET',     100, 29, 18, 20);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-12 15:30:00', TIMESTAMP '2026-04-12 17:00:00', 'TV',         100, 29, 10, NULL);

-- Perfil 30 (Jorge - Cali Estándar): 4 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-02 21:00:00', TIMESTAMP '2026-04-02 23:15:00', 'COMPUTADOR', 100, 30, 14, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-06 20:00:00', TIMESTAMP '2026-04-06 22:00:00', 'COMPUTADOR', 100, 30, 11, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-10 21:30:00', TIMESTAMP '2026-04-10 22:28:00', 'COMPUTADOR', 100, 30, 25, 29);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-14 22:00:00', TIMESTAMP '2026-04-14 22:55:00', 'CELULAR',    80,  30, 40, 45);

-- Perfil 31 (Paola - Cali Estándar): 4 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-03 21:00:00', TIMESTAMP '2026-04-03 22:42:00', 'CELULAR',    100, 31, 15, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-07 20:00:00', TIMESTAMP '2026-04-07 21:30:00', 'CELULAR',    100, 31, 7,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-11 21:30:00', TIMESTAMP '2026-04-11 22:10:00', 'TABLET',     100, 31, 41, 46);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-15 22:00:00', TIMESTAMP '2026-04-15 22:50:00', 'TABLET',     100, 31, 38, 37);

-- Perfil 34 (Julián - Armenia Estándar): 5 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-02 20:00:00', TIMESTAMP '2026-04-02 21:58:00', 'TV',         100, 34, 4,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-05 21:00:00', TIMESTAMP '2026-04-05 23:00:00', 'TV',         100, 34, 3,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-08 20:30:00', TIMESTAMP '2026-04-08 21:23:00', 'COMPUTADOR', 100, 34, 17, 12);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-11 21:00:00', TIMESTAMP '2026-04-11 22:00:00', 'COMPUTADOR', 80,  34, 42, 51);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-14 20:00:00', TIMESTAMP '2026-04-14 21:35:00', 'TV',         100, 34, 1,  NULL);

-- Perfil 38 (Adriana - Barranquilla Premium): 6 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-01 21:00:00', TIMESTAMP '2026-04-01 23:20:00', 'TV',         100, 38, 3,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-04 20:00:00', TIMESTAMP '2026-04-04 22:00:00', 'TV',         100, 38, 11, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-07 21:00:00', TIMESTAMP '2026-04-07 22:50:00', 'TV',         100, 38, 13, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-10 22:00:00', TIMESTAMP '2026-04-10 22:55:00', 'COMPUTADOR', 100, 38, 25, 29);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-13 21:00:00', TIMESTAMP '2026-04-13 21:55:00', 'COMPUTADOR', 100, 38, 20, 31);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-15 20:00:00', TIMESTAMP '2026-04-15 21:40:00', 'TV',         100, 38, 26, NULL);

-- Perfil 40 (Mauricio - Barranquilla Básico): 4 reproducciones
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-03 21:00:00', TIMESTAMP '2026-04-03 22:15:00', 'CELULAR',    100, 40, 12, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-07 20:00:00', TIMESTAMP '2026-04-07 21:42:00', 'CELULAR',    100, 40, 15, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-11 21:30:00', TIMESTAMP '2026-04-11 22:35:00', 'CELULAR',    100, 40, 39, 43);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-04-14 22:00:00', TIMESTAMP '2026-04-14 23:00:00', 'CELULAR',    80,  40, 39, 44);

-- Reproducciones adicionales para completar 200 con más variedad
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-15 20:00:00', TIMESTAMP '2026-03-15 22:00:00', 'TV',         100, 1,  6,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-16 21:00:00', TIMESTAMP '2026-03-16 22:35:00', 'TV',         100, 17, 1,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-17 20:30:00', TIMESTAMP '2026-03-17 22:30:00', 'COMPUTADOR', 100, 3,  4,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-18 21:00:00', TIMESTAMP '2026-03-18 22:00:00', 'CELULAR',    100, 9,  11, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-19 22:00:00', TIMESTAMP '2026-03-19 23:20:00', 'TV',         100, 22, 7,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-20 20:00:00', TIMESTAMP '2026-03-20 21:40:00', 'COMPUTADOR', 100, 28, 15, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-21 21:00:00', TIMESTAMP '2026-03-21 22:15:00', 'CELULAR',    100, 38, 14, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-22 20:30:00', TIMESTAMP '2026-03-22 22:05:00', 'TV',         100, 5,  3,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-23 21:00:00', TIMESTAMP '2026-03-23 22:35:00', 'TV',         100, 21, 9,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-24 20:00:00', TIMESTAMP '2026-03-24 21:50:00', 'COMPUTADOR', 100, 34, 8,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-25 22:00:00', TIMESTAMP '2026-03-25 22:47:00', 'CELULAR',    100, 26, 16, 1);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-26 21:00:00', TIMESTAMP '2026-03-26 22:00:00', 'TV',         90,  1,  17, 10);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-27 20:00:00', TIMESTAMP '2026-03-27 21:45:00', 'TABLET',     100, 24, 2,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-28 21:30:00', TIMESTAMP '2026-03-28 22:28:00', 'CELULAR',    100, 30, 19, 25);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-29 20:00:00', TIMESTAMP '2026-03-29 21:42:00', 'TV',         100, 11, 15, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-30 21:00:00', TIMESTAMP '2026-03-30 22:00:00', 'COMPUTADOR', 100, 14, 11, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-31 20:30:00', TIMESTAMP '2026-03-31 22:15:00', 'TV',         100, 3,  7,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-10 21:00:00', TIMESTAMP '2026-03-10 22:05:00', 'CELULAR',    100, 31, 12, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-11 20:00:00', TIMESTAMP '2026-03-11 21:50:00', 'TABLET',     100, 9,  13, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-03-12 22:00:00', TIMESTAMP '2026-03-12 22:50:00', 'TV',         100, 17, 17, 14);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-02-10 21:00:00', TIMESTAMP '2026-02-10 22:20:00', 'TV',         100, 1,  4,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-02-12 20:00:00', TIMESTAMP '2026-02-12 21:58:00', 'COMPUTADOR', 100, 22, 1,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-02-14 21:30:00', TIMESTAMP '2026-02-14 23:05:00', 'TV',         100, 38, 3,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-02-16 20:00:00', TIMESTAMP '2026-02-16 21:40:00', 'CELULAR',    100, 5,  15, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-02-18 22:00:00', TIMESTAMP '2026-02-18 22:55:00', 'COMPUTADOR', 100, 9,  16, 5);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-01-05 21:00:00', TIMESTAMP '2026-01-05 22:50:00', 'TV',         100, 17, 11, NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-01-10 20:30:00', TIMESTAMP '2026-01-10 22:30:00', 'COMPUTADOR', 100, 1,  8,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-01-15 21:00:00', TIMESTAMP '2026-01-15 22:00:00', 'TV',         100, 28, 1,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-01-20 20:00:00', TIMESTAMP '2026-01-20 21:35:00', 'CELULAR',    100, 3,  2,  NULL);
INSERT INTO REPRODUCCION VALUES (SEQ_REPRODUCCION.NEXTVAL, TIMESTAMP '2026-01-25 22:00:00', TIMESTAMP '2026-01-25 22:48:00', 'CELULAR',    100, 34, 38, 37);

-- ============================================================
-- SECCIÓN 14: CALIFICACIONES (60)
-- Solo perfiles que hayan reproducido >= 50% el contenido
-- ============================================================
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Excelente película, muy emocionante',    DATE '2026-04-02',  1,  1);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Bonita historia de amor bogotana',       DATE '2026-04-02',  3,  2);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Muy buena, suspenso increíble',          DATE '2026-04-05',  3,  3);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Ciencia ficción de primer nivel',        DATE '2026-04-04',  1,  4);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Divertida y apta para toda la familia',  DATE '2026-04-03',  2,  5);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 3, 'Interesante pero predecible',            DATE '2026-04-06',  5,  3);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Increíble serie colombiana',             DATE '2026-04-07',  1, 16);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Muy entretenida temporada 1',            DATE '2026-04-08', 21, 16);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'La mejor serie narco que he visto',      DATE '2026-04-09', 17, 17);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Me hizo reír todo el tiempo',            DATE '2026-04-10',  2, 18);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Muy buena ciencia ficción local',        DATE '2026-04-11',  9, 19);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 3, 'Regular, esperaba más del final',        DATE '2026-04-12',  3, 20);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Historia de amor muy real y bonita',     DATE '2026-04-13',  5, 21);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Me identifico mucho con los personajes', DATE '2026-04-14', 11, 21);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Documental imprescindible',              DATE '2026-04-04', 17, 26);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Muy informativo sobre el café',          DATE '2026-04-06', 22, 27);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Conmovedor y necesario',                 DATE '2026-04-08', 38, 28);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Excelente música tropical',              DATE '2026-04-03', 32, 32);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'El vallenato en su máxima expresión',    DATE '2026-04-09', 36, 36);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Podcast muy útil para emprendedores',    DATE '2026-04-12', 22, 38);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Adictivo, lo escuché de corrido',        DATE '2026-04-11', 14, 39);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Muy buena divulgación científica',       DATE '2026-04-14', 31, 40);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Necesario para la salud mental',         DATE '2026-04-15', 24, 41);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Colombia tiene mucha historia',          DATE '2026-04-16', 34, 42);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Ríos de Fuego me dejó sin palabras',     DATE '2026-04-05',  1,  7);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'El tiempo detenido, muy original',       DATE '2026-04-07',  9,  8);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 2, 'No me gustó el final',                   DATE '2026-04-08',  3,  9);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Muy divertida para toda la familia',     DATE '2026-04-06',  2, 10);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Código Rojo, buen thriller tecnológico', DATE '2026-04-08',  9, 11);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 3, 'La Montaña Azul: bonita pero corta',     DATE '2026-04-07', 28, 12);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Sin Salida es terrorífico',              DATE '2026-04-06', 17, 13);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'El Gran Robo colombiano, fantástico',    DATE '2026-04-08', 22, 14);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Sueños de papel es muy romántica',       DATE '2026-04-05', 11, 15);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Selva Viva: naturaleza increíble',       DATE '2026-04-10', 38, 26);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Océanos en Peligro: muy necesario',      DATE '2026-04-12', 30, 29);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Historia del Vallenato imperdible',      DATE '2026-04-14', 38, 30);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 3, 'Rock Andino: interesante fusión',        DATE '2026-04-07', 34, 33);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Salsa caleña pura',                      DATE '2026-04-09', 28, 34);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Urbano colombiano suena muy bien',       DATE '2026-04-11', 22, 35);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Jazz Bogotano de alta calidad',          DATE '2026-04-13', 17, 37);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Los Invisibles: drama social real',      DATE '2026-04-10', 30, 22);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Pesadillas: terror psicológico top',     DATE '2026-04-12',  1, 23);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Fútbol en el Alma muy emotivo',          DATE '2026-04-14', 18, 24);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'La Investigadora: suspenso real',        DATE '2026-04-13', 17, 25);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'El Último Vuelo muy emocionante',        DATE '2026-04-03', 14,  1);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Galaxia Sin Nombre es espectacular',     DATE '2026-04-04', 38,  4);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 3, 'Abuela Chef entretenida',                DATE '2026-04-05', 29,  5);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'El Exorcismo me aterró',                 DATE '2026-04-06', 40,  6);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Mariposas Negras muy oscuro',            DATE '2026-04-07', 26,  9);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Fiesta en el Barrio alegra el día',      DATE '2026-04-08', 36, 10);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Dimensión Paralela innovadora',          DATE '2026-04-09', 30, 19);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'El Consultor: drama corporativo top',    DATE '2026-04-10', 17, 20);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Amor Digital muy actual',                DATE '2026-04-11',  8, 21);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 3, 'Fronteras Invisibles: tema difícil',     DATE '2026-04-12', 31, 28);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Los Niños de la Paz me hizo llorar',     DATE '2026-04-13', 28, 31);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Casa de la Selva: aventura real',        DATE '2026-04-12',  9, 16);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Crimen Verdadero adictivo',              DATE '2026-04-14', 40, 39);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Ciencia Para Todos muy claro',           DATE '2026-04-15', 26, 40);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Bienestar Mental cambió mi perspectiva', DATE '2026-04-16', 34, 41);
INSERT INTO CALIFICACION VALUES (SEQ_CALIFICACION.NEXTVAL, 4, 'Historia Colombia muy reveladora',       DATE '2026-04-16', 40, 42);

-- ============================================================
-- SECCIÓN 15: FAVORITOS (40)
-- ============================================================
INSERT INTO FAVORITO VALUES (1,  1,  DATE '2026-04-02');
INSERT INTO FAVORITO VALUES (1,  4,  DATE '2026-04-04');
INSERT INTO FAVORITO VALUES (1,  16, DATE '2026-04-07');
INSERT INTO FAVORITO VALUES (1,  23, DATE '2026-04-13');
INSERT INTO FAVORITO VALUES (3,  2,  DATE '2026-04-02');
INSERT INTO FAVORITO VALUES (3,  3,  DATE '2026-04-05');
INSERT INTO FAVORITO VALUES (3,  20, DATE '2026-04-12');
INSERT INTO FAVORITO VALUES (5,  2,  DATE '2026-04-03');
INSERT INTO FAVORITO VALUES (5,  21, DATE '2026-04-11');
INSERT INTO FAVORITO VALUES (5,  8,  DATE '2026-04-15');
INSERT INTO FAVORITO VALUES (8,  15, DATE '2026-04-04');
INSERT INTO FAVORITO VALUES (8,  22, DATE '2026-04-10');
INSERT INTO FAVORITO VALUES (9,  11, DATE '2026-04-02');
INSERT INTO FAVORITO VALUES (9,  19, DATE '2026-04-07');
INSERT INTO FAVORITO VALUES (11, 15, DATE '2026-04-03');
INSERT INTO FAVORITO VALUES (11, 21, DATE '2026-04-09');
INSERT INTO FAVORITO VALUES (14, 1,  DATE '2026-04-04');
INSERT INTO FAVORITO VALUES (14, 39, DATE '2026-04-11');
INSERT INTO FAVORITO VALUES (17, 3,  DATE '2026-04-02');
INSERT INTO FAVORITO VALUES (17, 7,  DATE '2026-04-04');
INSERT INTO FAVORITO VALUES (17, 25, DATE '2026-04-14');
INSERT INTO FAVORITO VALUES (21, 9,  DATE '2026-04-03');
INSERT INTO FAVORITO VALUES (21, 16, DATE '2026-04-09');
INSERT INTO FAVORITO VALUES (22, 14, DATE '2026-04-04');
INSERT INTO FAVORITO VALUES (22, 11, DATE '2026-04-07');
INSERT INTO FAVORITO VALUES (24, 15, DATE '2026-04-05');
INSERT INTO FAVORITO VALUES (24, 41, DATE '2026-04-12');
INSERT INTO FAVORITO VALUES (26, 12, DATE '2026-04-06');
INSERT INTO FAVORITO VALUES (26, 39, DATE '2026-04-13');
INSERT INTO FAVORITO VALUES (28, 2,  DATE '2026-04-02');
INSERT INTO FAVORITO VALUES (28, 22, DATE '2026-04-08');
INSERT INTO FAVORITO VALUES (30, 14, DATE '2026-04-03');
INSERT INTO FAVORITO VALUES (30, 25, DATE '2026-04-11');
INSERT INTO FAVORITO VALUES (31, 15, DATE '2026-04-04');
INSERT INTO FAVORITO VALUES (31, 41, DATE '2026-04-12');
INSERT INTO FAVORITO VALUES (34, 4,  DATE '2026-04-03');
INSERT INTO FAVORITO VALUES (34, 17, DATE '2026-04-09');
INSERT INTO FAVORITO VALUES (38, 3,  DATE '2026-04-02');
INSERT INTO FAVORITO VALUES (38, 25, DATE '2026-04-11');
INSERT INTO FAVORITO VALUES (40, 39, DATE '2026-04-12');

-- ============================================================
-- SECCIÓN 16: REPORTES (10)
-- ============================================================
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'Contenido con lenguaje inapropiado para menores', 'RESUELTO',  DATE '2026-03-10', DATE '2026-03-12', 5,  6,  7);
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'Escena de violencia extrema sin aviso previo',    'RESUELTO',  DATE '2026-03-15', DATE '2026-03-17', 9,  23, 8);
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'Audio no sincronizado con el video',              'RECHAZADO', DATE '2026-03-20', DATE '2026-03-21', 11, 9,  7);
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'Título engañoso, no corresponde al contenido',   'RESUELTO',  DATE '2026-04-01', DATE '2026-04-03', 14, 13, 8);
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'Clasificación de edad incorrecta',                'PENDIENTE', NULL,             NULL, 17, 20, NULL);
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'Contenido promociona actividades ilegales',       'PENDIENTE', NULL,             NULL, 22, 17, NULL);
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'Subtítulos en español incorrectos',               'RESUELTO',  DATE '2026-04-08', DATE '2026-04-09', 24, 3,  7);
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'El podcast tiene música de fondo que molesta',    'RECHAZADO', DATE '2026-04-10', DATE '2026-04-11', 26, 39, 8);
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'Imagen inapropiada en la miniatura',              'RESUELTO',  DATE '2026-04-12', DATE '2026-04-14', 28, 6,  7);
INSERT INTO REPORTE VALUES (SEQ_REPORTE.NEXTVAL, 'Episodio duplicado en la plataforma',             'PENDIENTE', NULL,             NULL, 34, 16, NULL);

-- ============================================================
-- CONFIRMAR TODOS LOS CAMBIOS
-- ============================================================
COMMIT;

-- ============================================================
-- FIN DEL SCRIPT DE DATOS DE PRUEBA
-- Registros insertados:
--   CIUDAD: 6 | DEPARTAMENTO: 5 | PLAN: 3 | GENERO: 10
--   EMPLEADO: 12 | USUARIO: 30 | PERFIL: 60 | PAGO: 80
--   CONTENIDO: 42 | PELICULA: 15 | SERIE: 10 | DOCUMENTAL: 6
--   MUSICA: 6 | PODCAST: 5 | TEMPORADA: 15 | EPISODIO: 50
--   CONTENIDO_GENERO: 55 | RELACION_CONTENIDO: 4
--   REPRODUCCION: 200 | CALIFICACION: 60 | FAVORITO: 40
--   REPORTE: 10
-- ============================================================
