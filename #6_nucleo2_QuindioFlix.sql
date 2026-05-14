-- ============================================================
-- QUINDIOFLIX - NÚCLEO 2: PL/SQL
-- Universidad del Quindío - Bases de Datos II
-- Resultado de Aprendizaje: R.A.2
-- ============================================================

-- ============================================================
-- SECCIÓN 1: CURSORES
-- Recorren conjuntos de datos fila por fila para procesamiento
-- detallado que no es posible con SQL puro.
-- ============================================================

-- ------------------------------------------------------------
-- 1.1 Cursor: Usuarios con suscripción vencida
-- Recorre usuarios cuyo último pago fue hace más de 30 días
-- y genera un reporte con nombre, email, plan, días de mora
-- y monto adeudado.
-- ------------------------------------------------------------
DECLARE
    -- Definición del cursor explícito
    CURSOR cur_morosos IS
        SELECT
            u.id_usuario,
            u.nombre,
            u.email,
            u.fecha_ultimo_pago,
            pl.nombre                          AS plan,
            pl.precio                          AS monto_mensual,
            TRUNC(SYSDATE - u.fecha_ultimo_pago) AS dias_mora
        FROM USUARIO u
        JOIN PLAN pl ON u.id_plan = pl.id_plan
        WHERE u.estado_cuenta  = 'ACTIVO'
          AND u.fecha_ultimo_pago IS NOT NULL
          AND SYSDATE - u.fecha_ultimo_pago > 30
        ORDER BY dias_mora DESC;

    -- Variables de trabajo
    v_registro  cur_morosos%ROWTYPE;
    v_contador  NUMBER := 0;
    v_total_deuda NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=================================================');
    DBMS_OUTPUT.PUT_LINE('   REPORTE DE USUARIOS CON SUSCRIPCIÓN VENCIDA   ');
    DBMS_OUTPUT.PUT_LINE('   Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('=================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('NOMBRE', 25) || RPAD('EMAIL', 30) ||
        RPAD('PLAN', 12)   || LPAD('DÍAS MORA', 10) ||
        LPAD('MONTO', 12)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 89, '-'));

    OPEN cur_morosos;
    LOOP
        FETCH cur_morosos INTO v_registro;
        EXIT WHEN cur_morosos%NOTFOUND;

        v_contador   := v_contador + 1;
        v_total_deuda := v_total_deuda + v_registro.monto_mensual;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_registro.nombre,          25) ||
            RPAD(v_registro.email,           30) ||
            RPAD(v_registro.plan,            12) ||
            LPAD(v_registro.dias_mora,       10) ||
            LPAD(TO_CHAR(v_registro.monto_mensual, '$999,999'), 12)
        );
    END LOOP;
    CLOSE cur_morosos;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 89, '-'));
    DBMS_OUTPUT.PUT_LINE('Total usuarios morosos: ' || v_contador);
    DBMS_OUTPUT.PUT_LINE('Deuda total estimada:   $' || TO_CHAR(v_total_deuda, '999,999,999'));
END;
/

-- ------------------------------------------------------------
-- 1.2 Cursor: Actualizar popularidad de contenido
-- Recorre el catálogo, calcula reproducciones completas
-- (avance >= 90%) y actualiza un campo de popularidad.
-- Se agrega columna popularidad si no existe antes de ejecutar.
-- ------------------------------------------------------------

-- Primero agregar la columna popularidad a CONTENIDO (si no existe)
ALTER TABLE CONTENIDO ADD (popularidad NUMBER(10) DEFAULT 0);

DECLARE
    -- Cursor que recorre todo el contenido
    CURSOR cur_contenido IS
        SELECT id_contenido, titulo
        FROM   CONTENIDO
        ORDER BY id_contenido;

    v_id_contenido  CONTENIDO.id_contenido%TYPE;
    v_titulo        CONTENIDO.titulo%TYPE;
    v_completas     NUMBER;
    v_total         NUMBER;
    v_score         NUMBER;
    v_actualizados  NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('================================================');
    DBMS_OUTPUT.PUT_LINE('   ACTUALIZACIÓN DE POPULARIDAD DE CONTENIDO    ');
    DBMS_OUTPUT.PUT_LINE('================================================');

    OPEN cur_contenido;
    LOOP
        FETCH cur_contenido INTO v_id_contenido, v_titulo;
        EXIT WHEN cur_contenido%NOTFOUND;

        -- Contar reproducciones completas (>= 90%)
        SELECT COUNT(*)
        INTO   v_completas
        FROM   REPRODUCCION
        WHERE  id_contenido       = v_id_contenido
          AND  avance_porcentaje >= 90;

        -- Contar total de reproducciones
        SELECT COUNT(*)
        INTO   v_total
        FROM   REPRODUCCION
        WHERE  id_contenido = v_id_contenido;

        -- Score = reproducciones completas * 2 + reproducciones parciales
        v_score := (v_completas * 2) + (v_total - v_completas);

        -- Actualizar campo popularidad
        UPDATE CONTENIDO
        SET    popularidad = v_score
        WHERE  id_contenido = v_id_contenido;

        v_actualizados := v_actualizados + 1;

        IF v_total > 0 THEN
            DBMS_OUTPUT.PUT_LINE(
                RPAD(v_titulo, 35) ||
                ' | Completas: ' || LPAD(v_completas, 3) ||
                ' | Total: '     || LPAD(v_total, 3)     ||
                ' | Score: '     || LPAD(v_score, 4)
            );
        END IF;
    END LOOP;
    CLOSE cur_contenido;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Contenidos actualizados: ' || v_actualizados);
END;
/

-- ============================================================
-- SECCIÓN 2: PROCEDIMIENTOS ALMACENADOS
-- Encapsulan lógica de negocio compleja con validaciones,
-- manejo de excepciones y operaciones transaccionales.
-- ============================================================

-- ------------------------------------------------------------
-- 2.1 SP_REGISTRAR_USUARIO
-- Registra un nuevo usuario, crea un perfil predeterminado
-- y registra el primer pago. Si algo falla, hace ROLLBACK total.
-- Parámetros de entrada:
--   p_nombre, p_email, p_contrasena, p_telefono,
--   p_fecha_nac, p_id_ciudad, p_id_plan, p_metodo_pago,
--   p_id_referido_por (opcional, NULL si no tiene referido)
-- Parámetro de salida:
--   p_id_nuevo_usuario: ID del usuario creado
-- ------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_USUARIO (
    p_nombre          IN  USUARIO.nombre%TYPE,
    p_email           IN  USUARIO.email%TYPE,
    p_contrasena      IN  USUARIO.contrasena%TYPE,
    p_telefono        IN  USUARIO.telefono%TYPE,
    p_fecha_nac       IN  USUARIO.fecha_nacimiento%TYPE,
    p_id_ciudad       IN  USUARIO.id_ciudad%TYPE,
    p_id_plan         IN  USUARIO.id_plan%TYPE,
    p_metodo_pago     IN  PAGO.metodo_pago%TYPE,
    p_id_referido_por IN  USUARIO.id_referido_por%TYPE DEFAULT NULL,
    p_id_nuevo_usuario OUT USUARIO.id_usuario%TYPE
) AS
    -- Excepciones personalizadas
    ex_email_duplicado  EXCEPTION;
    ex_plan_invalido    EXCEPTION;
    ex_ciudad_invalida  EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_email_duplicado, -20001);
    PRAGMA EXCEPTION_INIT(ex_plan_invalido,   -20002);
    PRAGMA EXCEPTION_INIT(ex_ciudad_invalida, -20003);

    v_count_email   NUMBER;
    v_count_plan    NUMBER;
    v_count_ciudad  NUMBER;
    v_precio_plan   PLAN.precio%TYPE;
    v_nuevo_id      NUMBER;

BEGIN
    -- Validar que el email no esté registrado
    SELECT COUNT(*) INTO v_count_email
    FROM   USUARIO
    WHERE  UPPER(email) = UPPER(p_email);

    IF v_count_email > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'El email ' || p_email || ' ya está registrado en la plataforma.');
    END IF;

    -- Validar que el plan exista
    SELECT COUNT(*), MAX(precio)
    INTO   v_count_plan, v_precio_plan
    FROM   PLAN
    WHERE  id_plan = p_id_plan;

    IF v_count_plan = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,
            'El plan con ID ' || p_id_plan || ' no existe.');
    END IF;

    -- Validar que la ciudad exista
    SELECT COUNT(*) INTO v_count_ciudad
    FROM   CIUDAD
    WHERE  id_ciudad = p_id_ciudad;

    IF v_count_ciudad = 0 THEN
        RAISE_APPLICATION_ERROR(-20003,
            'La ciudad con ID ' || p_id_ciudad || ' no existe.');
    END IF;

    -- Obtener nuevo ID de usuario
    SELECT SEQ_USUARIO.NEXTVAL INTO v_nuevo_id FROM DUAL;
    p_id_nuevo_usuario := v_nuevo_id;

    -- Insertar usuario
    INSERT INTO USUARIO (
        id_usuario, nombre, email, contrasena, telefono,
        fecha_nacimiento, estado_cuenta, fecha_ultimo_pago,
        id_ciudad, id_plan, id_referido_por
    ) VALUES (
        v_nuevo_id, p_nombre, p_email, p_contrasena, p_telefono,
        p_fecha_nac, 'ACTIVO', SYSDATE,
        p_id_ciudad, p_id_plan, p_id_referido_por
    );

    -- Crear perfil predeterminado (tipo ADULTO por defecto)
    INSERT INTO PERFIL (id_perfil, nombre, avatar, tipo_perfil, id_usuario)
    VALUES (SEQ_PERFIL.NEXTVAL, p_nombre, 'avatar_default.png', 'ADULTO', v_nuevo_id);

    -- Registrar primer pago
    INSERT INTO PAGO (id_pago, fecha, monto, metodo_pago, estado, id_usuario)
    VALUES (SEQ_PAGO.NEXTVAL, SYSDATE, v_precio_plan, p_metodo_pago, 'EXITOSO', v_nuevo_id);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ Usuario registrado exitosamente. ID: ' || v_nuevo_id);

EXCEPTION
    WHEN ex_email_duplicado THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('✗ Error: ' || SQLERRM);
        RAISE;
    WHEN ex_plan_invalido THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('✗ Error: ' || SQLERRM);
        RAISE;
    WHEN ex_ciudad_invalida THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('✗ Error: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('✗ Error inesperado: ' || SQLERRM);
        RAISE;
END SP_REGISTRAR_USUARIO;
/

-- Prueba del procedimiento SP_REGISTRAR_USUARIO
DECLARE
    v_nuevo_id NUMBER;
BEGIN
    SP_REGISTRAR_USUARIO(
        p_nombre          => 'Ana Sofía Méndez',
        p_email           => 'asmendez@gmail.com',
        p_contrasena      => 'hash_test_pass',
        p_telefono        => '3100001234',
        p_fecha_nac       => DATE '1995-06-15',
        p_id_ciudad       => 1,
        p_id_plan         => 2,
        p_metodo_pago     => 'NEQUI',
        p_id_referido_por => NULL,
        p_id_nuevo_usuario => v_nuevo_id
    );
    DBMS_OUTPUT.PUT_LINE('ID asignado: ' || v_nuevo_id);
END;
/

-- ------------------------------------------------------------
-- 2.2 SP_CAMBIAR_PLAN
-- Cambia el plan de suscripción de un usuario.
-- Valida que si baja de plan, no tenga más perfiles
-- de los que permite el nuevo plan.
-- ------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_CAMBIAR_PLAN (
    p_id_usuario IN USUARIO.id_usuario%TYPE,
    p_id_nuevo_plan IN PLAN.id_plan%TYPE
) AS
    ex_usuario_no_existe    EXCEPTION;
    ex_plan_no_existe       EXCEPTION;
    ex_perfiles_excedidos   EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_usuario_no_existe,  -20010);
    PRAGMA EXCEPTION_INIT(ex_plan_no_existe,      -20011);
    PRAGMA EXCEPTION_INIT(ex_perfiles_excedidos,  -20012);

    v_count_usuario     NUMBER;
    v_count_plan        NUMBER;
    v_perfiles_actuales NUMBER;
    v_max_perfiles_nuevo NUMBER;
    v_plan_actual_nombre PLAN.nombre%TYPE;
    v_plan_nuevo_nombre  PLAN.nombre%TYPE;

BEGIN
    -- Validar que el usuario exista
    SELECT COUNT(*) INTO v_count_usuario
    FROM   USUARIO WHERE id_usuario = p_id_usuario;

    IF v_count_usuario = 0 THEN
        RAISE_APPLICATION_ERROR(-20010,
            'El usuario con ID ' || p_id_usuario || ' no existe.');
    END IF;

    -- Validar que el nuevo plan exista
    SELECT COUNT(*), MAX(max_perfiles), MAX(nombre)
    INTO   v_count_plan, v_max_perfiles_nuevo, v_plan_nuevo_nombre
    FROM   PLAN
    WHERE  id_plan = p_id_nuevo_plan;

    IF v_count_plan = 0 THEN
        RAISE_APPLICATION_ERROR(-20011,
            'El plan con ID ' || p_id_nuevo_plan || ' no existe.');
    END IF;

    -- Obtener plan actual del usuario
    SELECT pl.nombre INTO v_plan_actual_nombre
    FROM   USUARIO u JOIN PLAN pl ON u.id_plan = pl.id_plan
    WHERE  u.id_usuario = p_id_usuario;

    -- Contar perfiles actuales del usuario
    SELECT COUNT(*) INTO v_perfiles_actuales
    FROM   PERFIL
    WHERE  id_usuario = p_id_usuario;

    -- Validar que los perfiles actuales no excedan el límite del nuevo plan
    IF v_perfiles_actuales > v_max_perfiles_nuevo THEN
        RAISE_APPLICATION_ERROR(-20012,
            'No es posible cambiar al plan ' || v_plan_nuevo_nombre ||
            '. El usuario tiene ' || v_perfiles_actuales || ' perfil(es) y ' ||
            'el nuevo plan solo permite ' || v_max_perfiles_nuevo || '. ' ||
            'Elimine ' || (v_perfiles_actuales - v_max_perfiles_nuevo) ||
            ' perfil(es) antes de cambiar de plan.');
    END IF;

    -- Realizar el cambio de plan
    UPDATE USUARIO
    SET    id_plan = p_id_nuevo_plan
    WHERE  id_usuario = p_id_usuario;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE(
        '✓ Plan cambiado exitosamente.' ||
        ' Plan anterior: ' || v_plan_actual_nombre ||
        ' → Nuevo plan: '  || v_plan_nuevo_nombre
    );

EXCEPTION
    WHEN ex_usuario_no_existe   THEN ROLLBACK; DBMS_OUTPUT.PUT_LINE('✗ ' || SQLERRM); RAISE;
    WHEN ex_plan_no_existe      THEN ROLLBACK; DBMS_OUTPUT.PUT_LINE('✗ ' || SQLERRM); RAISE;
    WHEN ex_perfiles_excedidos  THEN ROLLBACK; DBMS_OUTPUT.PUT_LINE('✗ ' || SQLERRM); RAISE;
    WHEN OTHERS                 THEN ROLLBACK; DBMS_OUTPUT.PUT_LINE('✗ Error: ' || SQLERRM); RAISE;
END SP_CAMBIAR_PLAN;
/

-- Prueba: cambio válido (usuario 12 tiene 1 perfil, plan Básico máx 2, baja bien)
BEGIN SP_CAMBIAR_PLAN(12, 1); END;
/

-- Prueba: cambio inválido (usuario 1 tiene 4 perfiles, plan Básico solo permite 2)
BEGIN SP_CAMBIAR_PLAN(1, 1); END;
/

-- ------------------------------------------------------------
-- 2.3 SP_REPORTE_CONSUMO
-- Genera reporte detallado de reproducciones de un usuario
-- en un rango de fechas, agrupado por perfil y tipo de contenido,
-- con totales de tiempo consumido.
-- ------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_REPORTE_CONSUMO (
    p_id_usuario    IN USUARIO.id_usuario%TYPE,
    p_fecha_inicio  IN DATE,
    p_fecha_fin     IN DATE
) AS
    v_nombre_usuario USUARIO.nombre%TYPE;
    v_count_usuario  NUMBER;

    CURSOR cur_consumo IS
        SELECT
            p.nombre                                    AS perfil,
            p.tipo_perfil,
            c.titulo,
            c.tipo_contenido,
            r.dispositivo,
            r.avance_porcentaje,
            r.fecha_hora_inicio,
            -- Calcular minutos consumidos
            ROUND(
                (EXTRACT(HOUR   FROM (r.fecha_hora_fin - r.fecha_hora_inicio)) * 60 +
                 EXTRACT(MINUTE FROM (r.fecha_hora_fin - r.fecha_hora_inicio))),
                0
            ) AS minutos_vistos
        FROM REPRODUCCION r
        JOIN PERFIL       p  ON r.id_perfil    = p.id_perfil
        JOIN CONTENIDO    c  ON r.id_contenido = c.id_contenido
        WHERE p.id_usuario  = p_id_usuario
          AND TRUNC(r.fecha_hora_inicio) BETWEEN p_fecha_inicio AND p_fecha_fin
          AND r.fecha_hora_fin IS NOT NULL
        ORDER BY p.nombre, r.fecha_hora_inicio;

    v_perfil_actual   VARCHAR2(100) := '';
    v_total_minutos   NUMBER := 0;
    v_total_reprod    NUMBER := 0;
    v_gran_total_min  NUMBER := 0;
    v_gran_total_rep  NUMBER := 0;

BEGIN
    -- Validar usuario
    SELECT COUNT(*), MAX(nombre)
    INTO   v_count_usuario, v_nombre_usuario
    FROM   USUARIO
    WHERE  id_usuario = p_id_usuario;

    IF v_count_usuario = 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Usuario con ID ' || p_id_usuario || ' no existe.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('================================================');
    DBMS_OUTPUT.PUT_LINE('   REPORTE DE CONSUMO - ' || v_nombre_usuario);
    DBMS_OUTPUT.PUT_LINE('   Período: ' || TO_CHAR(p_fecha_inicio,'DD/MM/YYYY') ||
                         ' al '         || TO_CHAR(p_fecha_fin,   'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('================================================');

    FOR reg IN cur_consumo LOOP
        -- Detectar cambio de perfil para imprimir subtotal
        IF reg.perfil <> v_perfil_actual THEN
            IF v_perfil_actual <> '' THEN
                DBMS_OUTPUT.PUT_LINE(
                    '  Subtotal ' || v_perfil_actual ||
                    ': ' || v_total_reprod || ' reproducciones | ' ||
                    v_total_minutos || ' minutos'
                );
                DBMS_OUTPUT.PUT_LINE('  ' || RPAD('-', 60, '-'));
            END IF;
            v_perfil_actual := reg.perfil;
            v_total_minutos := 0;
            v_total_reprod  := 0;
            DBMS_OUTPUT.PUT_LINE('► Perfil: ' || reg.perfil || ' [' || reg.tipo_perfil || ']');
        END IF;

        v_total_minutos  := v_total_minutos  + NVL(reg.minutos_vistos, 0);
        v_total_reprod   := v_total_reprod   + 1;
        v_gran_total_min := v_gran_total_min + NVL(reg.minutos_vistos, 0);
        v_gran_total_rep := v_gran_total_rep + 1;

        DBMS_OUTPUT.PUT_LINE(
            '  ' || TO_CHAR(reg.fecha_hora_inicio, 'DD/MM HH24:MI') ||
            ' | ' || RPAD(reg.titulo, 30) ||
            ' | ' || RPAD(reg.tipo_contenido, 10) ||
            ' | ' || RPAD(reg.dispositivo, 10) ||
            ' | ' || reg.avance_porcentaje || '%' ||
            ' | ' || NVL(reg.minutos_vistos, 0) || ' min'
        );
    END LOOP;

    -- Subtotal del último perfil
    IF v_perfil_actual <> '' THEN
        DBMS_OUTPUT.PUT_LINE(
            '  Subtotal ' || v_perfil_actual ||
            ': ' || v_total_reprod || ' reproducciones | ' ||
            v_total_minutos || ' minutos'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('================================================');
    DBMS_OUTPUT.PUT_LINE('TOTAL: ' || v_gran_total_rep || ' reproducciones | ' ||
                         v_gran_total_min || ' minutos (' ||
                         ROUND(v_gran_total_min / 60, 1) || ' horas)');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ Error: ' || SQLERRM);
        RAISE;
END SP_REPORTE_CONSUMO;
/

-- Prueba del reporte de consumo para el usuario 1
BEGIN
    SP_REPORTE_CONSUMO(1, DATE '2026-04-01', DATE '2026-04-30');
END;
/

-- ============================================================
-- SECCIÓN 3: FUNCIONES
-- Retornan un valor calculado. Se pueden usar dentro de SQL.
-- ============================================================

-- ------------------------------------------------------------
-- 3.1 FN_CALCULAR_MONTO
-- Calcula el monto a cobrar en el próximo mes considerando:
--   - Plan actual del usuario
--   - Descuento por antigüedad:
--       > 12 meses: 10% de descuento
--       > 24 meses: 15% de descuento
--   - Descuento adicional si tiene referido activo
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION FN_CALCULAR_MONTO (
    p_id_usuario IN USUARIO.id_usuario%TYPE
) RETURN NUMBER AS
    v_precio_plan    PLAN.precio%TYPE;
    v_fecha_primer_pago DATE;
    v_meses_antiguedad NUMBER;
    v_tiene_referido NUMBER;
    v_descuento      NUMBER := 0;
    v_monto_final    NUMBER;

BEGIN
    -- Obtener precio del plan actual
    SELECT pl.precio
    INTO   v_precio_plan
    FROM   USUARIO u
    JOIN   PLAN    pl ON u.id_plan = pl.id_plan
    WHERE  u.id_usuario = p_id_usuario;

    -- Calcular antigüedad en meses desde el primer pago exitoso
    SELECT MONTHS_BETWEEN(SYSDATE, MIN(fecha))
    INTO   v_meses_antiguedad
    FROM   PAGO
    WHERE  id_usuario = p_id_usuario
      AND  estado     = 'EXITOSO';

    -- Aplicar descuento por antigüedad
    IF v_meses_antiguedad > 24 THEN
        v_descuento := 0.15;  -- 15% por más de 2 años
    ELSIF v_meses_antiguedad > 12 THEN
        v_descuento := 0.10;  -- 10% por más de 1 año
    END IF;

    -- Verificar si tiene referido activo (descuento adicional 5%)
    SELECT COUNT(*)
    INTO   v_tiene_referido
    FROM   USUARIO referido
    WHERE  referido.id_referido_por = p_id_usuario
      AND  referido.estado_cuenta   = 'ACTIVO';

    IF v_tiene_referido > 0 THEN
        v_descuento := v_descuento + 0.05;
    END IF;

    -- Calcular monto final con descuento aplicado
    v_monto_final := ROUND(v_precio_plan * (1 - v_descuento), 2);

    RETURN v_monto_final;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END FN_CALCULAR_MONTO;
/

-- Prueba: ver monto a cobrar para todos los usuarios activos
SELECT
    u.id_usuario,
    u.nombre,
    pl.nombre                       AS plan,
    pl.precio                       AS precio_base,
    FN_CALCULAR_MONTO(u.id_usuario) AS monto_proximo_cobro,
    pl.precio - FN_CALCULAR_MONTO(u.id_usuario) AS descuento_aplicado
FROM USUARIO u
JOIN PLAN    pl ON u.id_plan = pl.id_plan
WHERE u.estado_cuenta = 'ACTIVO'
ORDER BY u.id_usuario;

-- ------------------------------------------------------------
-- 3.2 FN_CONTENIDO_RECOMENDADO
-- Retorna el título del contenido más afín al perfil
-- basándose en los géneros que más ha reproducido.
-- Excluye contenido que el perfil ya reprodujo.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION FN_CONTENIDO_RECOMENDADO (
    p_id_perfil IN PERFIL.id_perfil%TYPE
) RETURN VARCHAR2 AS
    v_titulo_recomendado CONTENIDO.titulo%TYPE;

BEGIN
    -- Busca el contenido con más géneros en común con los
    -- géneros favoritos del perfil, que no haya visto aún.
    SELECT titulo INTO v_titulo_recomendado
    FROM (
        SELECT
            c.titulo,
            -- Score: cuántos géneros del contenido coinciden
            -- con los géneros más reproducidos por el perfil
            COUNT(cg.id_genero) AS score_coincidencia
        FROM CONTENIDO c
        JOIN CONTENIDO_GENERO cg ON c.id_contenido = cg.id_contenido
        WHERE
            -- Género está en los más reproducidos por el perfil
            cg.id_genero IN (
                SELECT cg2.id_genero
                FROM REPRODUCCION  r2
                JOIN CONTENIDO_GENERO cg2 ON r2.id_contenido = cg2.id_contenido
                WHERE r2.id_perfil = p_id_perfil
                GROUP BY cg2.id_genero
                ORDER BY COUNT(*) DESC
                FETCH FIRST 3 ROWS ONLY
            )
            -- Contenido que el perfil NO ha reproducido aún
            AND c.id_contenido NOT IN (
                SELECT DISTINCT id_contenido
                FROM   REPRODUCCION
                WHERE  id_perfil = p_id_perfil
            )
        GROUP BY c.titulo
        ORDER BY score_coincidencia DESC, DBMS_RANDOM.VALUE
    )
    WHERE ROWNUM = 1;

    RETURN v_titulo_recomendado;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Sin recomendaciones disponibles';
    WHEN OTHERS THEN
        RETURN 'Error al calcular recomendación';
END FN_CONTENIDO_RECOMENDADO;
/

-- Prueba: recomendaciones para varios perfiles
SELECT
    p.id_perfil,
    p.nombre                              AS perfil,
    u.nombre                              AS usuario,
    FN_CONTENIDO_RECOMENDADO(p.id_perfil) AS contenido_recomendado
FROM PERFIL  p
JOIN USUARIO u ON p.id_usuario = u.id_usuario
WHERE p.id_perfil IN (1, 3, 5, 9, 17, 22, 28)
ORDER BY p.id_perfil;

-- ============================================================
-- SECCIÓN 4: EXCEPCIONES
-- Las excepciones personalizadas ya están definidas dentro de
-- SP_REGISTRAR_USUARIO y SP_CAMBIAR_PLAN (sección 2).
-- Aquí se incluyen pruebas explícitas para demostrarlas.
-- Ir a Ver -> salida DBMS -> + (para ver el mensaje capturado)
-- ============================================================

-- ------------------------------------------------------------
-- 4.1 Prueba de excepción: email ya registrado (código -20001)
-- ------------------------------------------------------------
DECLARE
    v_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba: email duplicado ---');
    SP_REGISTRAR_USUARIO(
        p_nombre           => 'Copia de Alejandro',
        p_email            => 'arestrepo@gmail.com',  -- Ya existe
        p_contrasena       => 'pass_test',
        p_telefono         => '3190000000',
        p_fecha_nac        => DATE '1990-01-01',
        p_id_ciudad        => 1,
        p_id_plan          => 1,
        p_metodo_pago      => 'PSE',
        p_id_referido_por  => NULL,
        p_id_nuevo_usuario => v_id
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Excepción capturada correctamente.');
        DBMS_OUTPUT.PUT_LINE('Código: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Mensaje: ' || SQLERRM);
END;
/

-- ------------------------------------------------------------
-- 4.2 Prueba de excepción: perfiles excedidos al bajar de plan (código -20012)
-- ------------------------------------------------------------
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba: perfiles exceden el nuevo plan ---');
    -- Usuario 1 tiene 4 perfiles, plan Básico permite solo 2
    SP_CAMBIAR_PLAN(1, 1);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Excepción capturada correctamente.');
        DBMS_OUTPUT.PUT_LINE('Código: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Mensaje: ' || SQLERRM);
END;
/

-- ============================================================
-- SECCIÓN 5: DISPARADORES (TRIGGERS)
-- Se ejecutan automáticamente ante eventos DML.
-- ============================================================

-- ------------------------------------------------------------
-- 5.1 Trigger: Verificar cuenta activa antes de reproducir
-- Nivel de fila — BEFORE INSERT en REPRODUCCION
-- Rechaza la inserción si el usuario tiene cuenta inactiva.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_verificar_cuenta_activa
BEFORE INSERT ON REPRODUCCION
FOR EACH ROW
DECLARE
    v_estado_cuenta USUARIO.estado_cuenta%TYPE;
BEGIN
    -- Obtener el estado de la cuenta del usuario dueño del perfil
    SELECT u.estado_cuenta
    INTO   v_estado_cuenta
    FROM   PERFIL p
    JOIN   USUARIO u ON p.id_usuario = u.id_usuario
    WHERE  p.id_perfil = :NEW.id_perfil;

    IF v_estado_cuenta <> 'ACTIVO' THEN
        RAISE_APPLICATION_ERROR(-20030,
            'No se puede registrar la reproducción. ' ||
            'La cuenta del usuario está en estado: ' || v_estado_cuenta ||
            '. Solo cuentas ACTIVO pueden reproducir contenido.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20031,
            'El perfil con ID ' || :NEW.id_perfil || ' no existe.');
END trg_verificar_cuenta_activa;
/

-- ------------------------------------------------------------
-- 5.2 Trigger: Límite de perfiles por plan
-- Nivel de fila — BEFORE INSERT en PERFIL
-- Rechaza si el usuario ya alcanzó el máximo de perfiles
-- que permite su plan.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_limite_perfiles_plan
BEFORE INSERT ON PERFIL
FOR EACH ROW
DECLARE
    v_perfiles_actuales NUMBER;
    v_max_perfiles      PLAN.max_perfiles%TYPE;
    v_nombre_plan       PLAN.nombre%TYPE;
BEGIN
    -- Obtener cuántos perfiles tiene ya el usuario
    SELECT COUNT(*)
    INTO   v_perfiles_actuales
    FROM   PERFIL
    WHERE  id_usuario = :NEW.id_usuario;

    -- Obtener el máximo permitido según el plan del usuario
    SELECT pl.max_perfiles, pl.nombre
    INTO   v_max_perfiles, v_nombre_plan
    FROM   USUARIO u
    JOIN   PLAN    pl ON u.id_plan = pl.id_plan
    WHERE  u.id_usuario = :NEW.id_usuario;

    IF v_perfiles_actuales >= v_max_perfiles THEN
        RAISE_APPLICATION_ERROR(-20040,
            'El usuario ya tiene ' || v_perfiles_actuales || ' perfil(es). ' ||
            'El plan ' || v_nombre_plan || ' permite máximo ' ||
            v_max_perfiles || ' perfil(es). ' ||
            'Actualice su plan para agregar más perfiles.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20041,
            'No se encontró información del plan para el usuario ID: ' || :NEW.id_usuario);
END trg_limite_perfiles_plan;
/

-- ------------------------------------------------------------
-- 5.3 Trigger: Calificación solo si reprodujo al menos 50%
-- Nivel de fila — BEFORE INSERT en CALIFICACION
-- Verifica que el perfil haya reproducido el contenido
-- con avance >= 50% antes de permitir la calificación.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_calificacion_requiere_reproduccion
BEFORE INSERT ON CALIFICACION
FOR EACH ROW
DECLARE
    v_max_avance NUMBER;
BEGIN
    -- Buscar la reproducción con mayor avance del perfil sobre ese contenido
    SELECT NVL(MAX(avance_porcentaje), 0)
    INTO   v_max_avance
    FROM   REPRODUCCION
    WHERE  id_perfil    = :NEW.id_perfil
      AND  id_contenido = :NEW.id_contenido;

    IF v_max_avance < 50 THEN
        RAISE_APPLICATION_ERROR(-20050,
            'No se puede calificar el contenido. ' ||
            'El perfil debe haber reproducido al menos el 50% del contenido. ' ||
            'Avance máximo registrado: ' || v_max_avance || '%.');
    END IF;
END trg_calificacion_requiere_reproduccion;
/

-- ------------------------------------------------------------
-- 5.4 Trigger: Activar cuenta tras pago exitoso
-- Nivel de sentencia — AFTER INSERT en PAGOS
-- Después de insertar pagos exitosos, actualiza estado_cuenta
-- y fecha_ultimo_pago de los usuarios correspondientes.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_activar_cuenta_tras_pago
AFTER INSERT ON PAGO
DECLARE
BEGIN
    -- Actualizar estado y fecha de pago para todos los usuarios
    -- que acaban de recibir un pago EXITOSO
    -- (el trigger de sentencia procesa todos los INSERTs del batch)
    UPDATE USUARIO u
    SET
        estado_cuenta    = 'ACTIVO',
        fecha_ultimo_pago = SYSDATE
    WHERE id_usuario IN (
        SELECT DISTINCT p.id_usuario
        FROM   PAGO p
        WHERE  p.estado = 'EXITOSO'
          AND  TRUNC(p.fecha) = TRUNC(SYSDATE)
    );

    DBMS_OUTPUT.PUT_LINE(
        '✓ Trigger activado: ' || SQL%ROWCOUNT ||
        ' cuenta(s) actualizadas a ACTIVO.'
    );
END trg_activar_cuenta_tras_pago;
/

-- ============================================================
-- PRUEBAS DE TRIGGERS
-- ============================================================

-- Prueba trigger 5.1: intentar reproducir con cuenta INACTIVA
-- (usuario 9 tiene estado INACTIVO)
DECLARE
    v_id_perfil NUMBER;
BEGIN
    SELECT id_perfil INTO v_id_perfil
    FROM   PERFIL WHERE id_usuario = 9 AND ROWNUM = 1;

    DBMS_OUTPUT.PUT_LINE('--- Prueba trigger cuenta inactiva ---');
    INSERT INTO REPRODUCCION
        (id_reproduccion, fecha_hora_inicio, dispositivo, avance_porcentaje, id_perfil, id_contenido)
    VALUES
        (SEQ_REPRODUCCION.NEXTVAL, CURRENT_TIMESTAMP, 'TV', 0, v_id_perfil, 1);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger activo. Error: ' || SQLERRM);
END;
/

-- Prueba trigger 5.2: intentar agregar perfil excediendo el plan
-- (usuario 28 tiene plan Básico, máx 2 perfiles, ya tiene 2)
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba trigger límite perfiles ---');
    INSERT INTO PERFIL (id_perfil, nombre, avatar, tipo_perfil, id_usuario)
    VALUES (SEQ_PERFIL.NEXTVAL, 'Perfil Extra', 'avatar_x.png', 'ADULTO', 28);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger activo. Error: ' || SQLERRM);
END;
/

-- Prueba trigger 5.3: intentar calificar sin haber visto el contenido
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba trigger calificación sin reproducción ---');
    -- Perfil 1 intenta calificar contenido 27 que nunca reprodujo
    INSERT INTO CALIFICACION (id_calificacion, estrellas, resena, fecha, id_perfil, id_contenido)
    VALUES (SEQ_CALIFICACION.NEXTVAL, 5, 'Sin haberlo visto', SYSDATE, 1, 27);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger activo. Error: ' || SQLERRM);
END;
/

-- Prueba trigger 5.4: insertar pago exitoso y verificar activación de cuenta
-- (usuario 25 tiene estado INACTIVO)
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba trigger activar cuenta tras pago ---');
    INSERT INTO PAGO (id_pago, fecha, monto, metodo_pago, estado, id_usuario)
    VALUES (SEQ_PAGO.NEXTVAL, SYSDATE, 14900, 'NEQUI', 'EXITOSO', 25);
    COMMIT;

    -- Verificar que la cuenta quedó ACTIVO
    DECLARE
        v_estado VARCHAR2(20);
    BEGIN
        SELECT estado_cuenta INTO v_estado FROM USUARIO WHERE id_usuario = 25;
        DBMS_OUTPUT.PUT_LINE('Estado cuenta usuario 25: ' || v_estado);
    END;
END;
/

-- ============================================================
-- FIN DEL SCRIPT NÚCLEO 2
-- Elementos implementados:
--   2 cursores explícitos (morosos + actualizar popularidad)
--   3 procedimientos almacenados (registrar, cambiar plan, reporte)
--   2 funciones (calcular monto, contenido recomendado)
--   2 bloques de prueba de excepciones personalizadas
--   4 triggers (cuenta activa, límite perfiles, calificación, pago)
-- ============================================================
