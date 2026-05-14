-- ============================================================
-- QUINDIOFLIX - NÚCLEO 3: TRANSACCIONES Y CONCURRENCIA
-- Universidad del Quindío - Bases de Datos II
-- Resultado de Aprendizaje: R.A.1
-- ============================================================
-- Una transacción pasa por estos estados:
--   ACTIVA       → se están ejecutando las operaciones
--   PARCIALMENTE CONFIRMADA → última operación ejecutada, sin COMMIT
--   CONFIRMADA   → COMMIT exitoso, cambios permanentes
--   FALLIDA      → se detectó un error, no se puede continuar
--   ABORTADA     → ROLLBACK ejecutado, cambios revertidos
-- ============================================================

-- ============================================================
-- SECCIÓN 1: TRANSACCIONES CRÍTICAS
-- ============================================================

-- ------------------------------------------------------------
-- 1.1 TRANSACCIÓN: Registro completo de nuevo usuario
-- Operaciones: crear usuario + perfil + primer pago
-- Principio: TODO O NADA — si falla cualquier paso se revierte
-- todo, no quedan registros huérfanos.
--
-- Estados de la transacción:
--   ACTIVA            → desde el primer INSERT
--   PARC. CONFIRMADA  → tras el INSERT de PAGO (antes de COMMIT)
--   CONFIRMADA        → tras COMMIT exitoso
--   FALLIDA/ABORTADA  → si hay error, ROLLBACK deshace todo
-- ------------------------------------------------------------
DECLARE
    -- Variables de entrada
    v_nombre      VARCHAR2(150) := 'Carlos Iván Rueda';
    v_email       VARCHAR2(150) := 'cirueda@gmail.com';
    v_contrasena  VARCHAR2(255) := 'hash_pass_nuevo';
    v_telefono    VARCHAR2(20)  := '3155556677';
    v_fecha_nac   DATE          := DATE '1993-08-20';
    v_id_ciudad   NUMBER        := 3;  -- Cali
    v_id_plan     NUMBER        := 2;  -- Estándar
    v_metodo_pago VARCHAR2(20)  := 'PSE';

    -- Variables de trabajo
    v_nuevo_id    NUMBER;
    v_precio_plan NUMBER;
    v_count_email NUMBER;

    -- Excepción personalizada
    ex_email_existe EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_email_existe, -20001);

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TRANSACCIÓN 1: REGISTRO COMPLETO DE USUARIO ===');
    DBMS_OUTPUT.PUT_LINE('Estado: ACTIVA');

    -- Paso 1: Validar email único
    SELECT COUNT(*) INTO v_count_email
    FROM   USUARIO WHERE UPPER(email) = UPPER(v_email);

    IF v_count_email > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Email ya registrado: ' || v_email);
    END IF;

    -- Paso 2: Obtener precio del plan
    SELECT precio INTO v_precio_plan
    FROM   PLAN WHERE id_plan = v_id_plan;

    -- Paso 3: Insertar USUARIO — transacción ACTIVA
    SELECT SEQ_USUARIO.NEXTVAL INTO v_nuevo_id FROM DUAL;

    INSERT INTO USUARIO (
        id_usuario, nombre, email, contrasena, telefono,
        fecha_nacimiento, estado_cuenta, fecha_ultimo_pago,
        id_ciudad, id_plan, id_referido_por
    ) VALUES (
        v_nuevo_id, v_nombre, v_email, v_contrasena, v_telefono,
        v_fecha_nac, 'ACTIVO', SYSDATE, v_id_ciudad, v_id_plan, NULL
    );
    DBMS_OUTPUT.PUT_LINE('  ✓ Paso 1/3: Usuario insertado (ID: ' || v_nuevo_id || ')');

    -- Paso 4: Insertar PERFIL predeterminado
    INSERT INTO PERFIL (id_perfil, nombre, avatar, tipo_perfil, id_usuario)
    VALUES (SEQ_PERFIL.NEXTVAL, v_nombre, 'avatar_default.png', 'ADULTO', v_nuevo_id);
    DBMS_OUTPUT.PUT_LINE('  ✓ Paso 2/3: Perfil predeterminado creado');

    -- Paso 5: Insertar PAGO inicial — estado PARCIALMENTE CONFIRMADA
    INSERT INTO PAGO (id_pago, fecha, monto, metodo_pago, estado, id_usuario)
    VALUES (SEQ_PAGO.NEXTVAL, SYSDATE, v_precio_plan, v_metodo_pago, 'EXITOSO', v_nuevo_id);
    DBMS_OUTPUT.PUT_LINE('  ✓ Paso 3/3: Primer pago registrado ($' || v_precio_plan || ')');

    DBMS_OUTPUT.PUT_LINE('Estado: PARCIALMENTE CONFIRMADA');

    -- Confirmar toda la transacción — estado CONFIRMADA
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Estado: CONFIRMADA');
    DBMS_OUTPUT.PUT_LINE('✓ Registro completo exitoso. ID usuario: ' || v_nuevo_id);

EXCEPTION
    WHEN ex_email_existe THEN
        -- Estado: FALLIDA → ABORTADA
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Estado: FALLIDA → ABORTADA');
        DBMS_OUTPUT.PUT_LINE('✗ Error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('  Todos los cambios fueron revertidos.');
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Estado: FALLIDA → ABORTADA');
        DBMS_OUTPUT.PUT_LINE('✗ Plan no encontrado. ROLLBACK ejecutado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Estado: FALLIDA → ABORTADA');
        DBMS_OUTPUT.PUT_LINE('✗ Error inesperado: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('  ROLLBACK ejecutado. Ningún cambio fue guardado.');
END;
/

-- ------------------------------------------------------------
-- 1.2 TRANSACCIÓN: Renovación mensual masiva
-- Procesa el cobro mensual de todos los usuarios activos.
-- Usa SAVEPOINT para que si falla un usuario individual,
-- solo se revierte su pago sin afectar los anteriores.
--
-- Estados:
--   ACTIVA           → inicio del loop
--   SAVEPOINT        → antes de cada usuario (punto de recuperación)
--   PARC. CONFIRMADA → pago del usuario insertado, antes de continuar
--   CONFIRMADA       → COMMIT al final del batch completo
--   ABORTADA PARCIAL → ROLLBACK TO SAVEPOINT si falla un usuario
-- ------------------------------------------------------------
DECLARE
    CURSOR cur_usuarios_activos IS
        SELECT
            u.id_usuario,
            u.nombre,
            u.email,
            u.fecha_ultimo_pago,
            pl.precio,
            pl.nombre AS plan
        FROM USUARIO u
        JOIN PLAN    pl ON u.id_plan = pl.id_plan
        WHERE u.estado_cuenta = 'ACTIVO'
          AND (u.fecha_ultimo_pago IS NULL
               OR MONTHS_BETWEEN(SYSDATE, u.fecha_ultimo_pago) >= 1)
        ORDER BY u.id_usuario;

    v_procesados  NUMBER := 0;
    v_fallidos    NUMBER := 0;
    v_total_cobrado NUMBER := 0;
    v_monto_cobrar  NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TRANSACCIÓN 2: RENOVACIÓN MENSUAL MASIVA ===');
    DBMS_OUTPUT.PUT_LINE('Estado: ACTIVA');
    DBMS_OUTPUT.PUT_LINE('Inicio: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));

    FOR reg IN cur_usuarios_activos LOOP

        -- SAVEPOINT antes de procesar cada usuario
        -- Si falla este usuario, solo se revierte su operación
        SAVEPOINT sp_usuario;
        DBMS_OUTPUT.PUT_LINE('► Procesando: ' || reg.nombre || ' [' || reg.plan || ']');

        BEGIN
            -- Calcular monto con posibles descuentos
            v_monto_cobrar := FN_CALCULAR_MONTO(reg.id_usuario);

            IF v_monto_cobrar IS NULL THEN
                v_monto_cobrar := reg.precio;  -- Sin descuento si falla la función
            END IF;

            -- Registrar el pago del mes
            INSERT INTO PAGO (id_pago, fecha, monto, metodo_pago, estado, id_usuario)
            VALUES (
                SEQ_PAGO.NEXTVAL,
                SYSDATE,
                v_monto_cobrar,
                'TARJETA_CREDITO',  -- Método predeterminado para cobro automático
                'EXITOSO',
                reg.id_usuario
            );

            -- Actualizar fecha de último pago
            UPDATE USUARIO
            SET    fecha_ultimo_pago = SYSDATE
            WHERE  id_usuario = reg.id_usuario;

            v_procesados    := v_procesados + 1;
            v_total_cobrado := v_total_cobrado + v_monto_cobrar;

            DBMS_OUTPUT.PUT_LINE(
                '  ✓ Cobro exitoso: $' || v_monto_cobrar ||
                ' (base: $' || reg.precio || ')'
            );

            -- Estado: PARCIALMENTE CONFIRMADA para este usuario
            -- El COMMIT global se hace al final del loop

        EXCEPTION
            WHEN OTHERS THEN
                -- Revertir SOLO este usuario, continuar con el siguiente
                ROLLBACK TO SAVEPOINT sp_usuario;
                v_fallidos := v_fallidos + 1;
                DBMS_OUTPUT.PUT_LINE(
                    '  ✗ Falló cobro de ' || reg.nombre ||
                    '. Revertido. Error: ' || SQLERRM
                );
        END;

    END LOOP;

    -- Confirmar todos los pagos exitosos del batch — estado CONFIRMADA
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
    DBMS_OUTPUT.PUT_LINE('Estado: CONFIRMADA');
    DBMS_OUTPUT.PUT_LINE('Usuarios procesados: ' || v_procesados);
    DBMS_OUTPUT.PUT_LINE('Usuarios fallidos:   ' || v_fallidos);
    DBMS_OUTPUT.PUT_LINE('Total cobrado:       $' || TO_CHAR(v_total_cobrado, '999,999,999'));

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Estado: FALLIDA → ABORTADA (error global)');
        DBMS_OUTPUT.PUT_LINE('✗ Error crítico: ' || SQLERRM);
END;
/

-- ------------------------------------------------------------
-- 1.3 TRANSACCIÓN: Eliminación completa de cuenta
-- Elimina en cascada: calificaciones → favoritos →
-- reproducciones → perfiles → pagos → usuario.
-- Principio: TODO O NADA — si falla cualquier eliminación,
-- se revierte todo para preservar integridad referencial.
--
-- Estados:
--   ACTIVA           → primer DELETE
--   PARC. CONFIRMADA → todos los DELETEs ejecutados, antes de COMMIT
--   CONFIRMADA       → COMMIT exitoso
--   FALLIDA/ABORTADA → ROLLBACK si algo falla
-- ------------------------------------------------------------
DECLARE
    v_id_usuario    NUMBER := 30;  -- Usuario a eliminar (Mauricio Blanco)
    v_nombre        VARCHAR2(150);
    v_count         NUMBER;

    -- Contadores para el reporte
    v_cal_eliminadas  NUMBER := 0;
    v_fav_eliminados  NUMBER := 0;
    v_rep_eliminadas  NUMBER := 0;
    v_per_eliminados  NUMBER := 0;
    v_pag_eliminados  NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TRANSACCIÓN 3: ELIMINACIÓN COMPLETA DE CUENTA ===');

    -- Verificar que el usuario existe
    SELECT COUNT(*), MAX(nombre)
    INTO   v_count, v_nombre
    FROM   USUARIO WHERE id_usuario = v_id_usuario;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20060, 'Usuario ' || v_id_usuario || ' no existe.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Eliminando cuenta de: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Estado: ACTIVA');

    -- Paso 1: Eliminar CALIFICACIONES de todos los perfiles del usuario
    DELETE FROM CALIFICACION
    WHERE  id_perfil IN (
        SELECT id_perfil FROM PERFIL WHERE id_usuario = v_id_usuario
    );
    v_cal_eliminadas := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('  ✓ Calificaciones eliminadas: ' || v_cal_eliminadas);

    -- Paso 2: Eliminar FAVORITOS de todos los perfiles del usuario
    DELETE FROM FAVORITO
    WHERE  id_perfil IN (
        SELECT id_perfil FROM PERFIL WHERE id_usuario = v_id_usuario
    );
    v_fav_eliminados := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('  ✓ Favoritos eliminados: ' || v_fav_eliminados);

    -- Paso 3: Eliminar REPRODUCCIONES de todos los perfiles del usuario
    DELETE FROM REPRODUCCION
    WHERE  id_perfil IN (
        SELECT id_perfil FROM PERFIL WHERE id_usuario = v_id_usuario
    );
    v_rep_eliminadas := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('  ✓ Reproducciones eliminadas: ' || v_rep_eliminadas);

    -- Paso 4: Eliminar REPORTES generados por los perfiles del usuario
    DELETE FROM REPORTE
    WHERE  id_perfil_informa IN (
        SELECT id_perfil FROM PERFIL WHERE id_usuario = v_id_usuario
    );
    DBMS_OUTPUT.PUT_LINE('  ✓ Reportes generados eliminados: ' || SQL%ROWCOUNT);

    -- Paso 5: Eliminar PERFILES del usuario
    DELETE FROM PERFIL WHERE id_usuario = v_id_usuario;
    v_per_eliminados := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('  ✓ Perfiles eliminados: ' || v_per_eliminados);

    -- Paso 6: Eliminar PAGOS del usuario
    DELETE FROM PAGO WHERE id_usuario = v_id_usuario;
    v_pag_eliminados := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('  ✓ Pagos eliminados: ' || v_pag_eliminados);

    -- Paso 7: Limpiar referencia de usuarios que este usuario refirió
    UPDATE USUARIO SET id_referido_por = NULL
    WHERE  id_referido_por = v_id_usuario;
    DBMS_OUTPUT.PUT_LINE('  ✓ Referencias de referido limpiadas: ' || SQL%ROWCOUNT);

    -- Paso 8: Eliminar el USUARIO — estado PARCIALMENTE CONFIRMADA
    DELETE FROM USUARIO WHERE id_usuario = v_id_usuario;
    DBMS_OUTPUT.PUT_LINE('  ✓ Usuario eliminado.');
    DBMS_OUTPUT.PUT_LINE('Estado: PARCIALMENTE CONFIRMADA');

    -- Confirmar eliminación completa — estado CONFIRMADA
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Estado: CONFIRMADA');
    DBMS_OUTPUT.PUT_LINE('✓ Cuenta de ' || v_nombre || ' eliminada completamente.');

EXCEPTION
    WHEN OTHERS THEN
        -- Revertir ABSOLUTAMENTE todo — estado ABORTADA
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Estado: FALLIDA → ABORTADA');
        DBMS_OUTPUT.PUT_LINE('✗ Error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('  ROLLBACK ejecutado. La cuenta NO fue eliminada.');
END;
/

-- ============================================================
-- SECCIÓN 2: CONCURRENCIA DE DATOS
-- Demostración de bloqueo con SELECT FOR UPDATE.
--
-- ESCENARIO: Dos sesiones intentan cambiar el plan del mismo
-- usuario (id_usuario = 1) al mismo tiempo.
--
-- INSTRUCCIONES PARA REPRODUCIR EN SQL DEVELOPER:
--   1. Abrir dos conexiones independientes (Sesión A y Sesión B)
--   2. Ejecutar el bloque de Sesión A primero
--   3. Sin hacer COMMIT en A, ejecutar el bloque de Sesión B
--   4. Observar que B queda BLOQUEADA esperando a A
--   5. Hacer COMMIT o ROLLBACK en A y ver cómo B continúa
-- ============================================================

-- ------------------------------------------------------------
-- DOCUMENTACIÓN DEL ESCENARIO DE CONCURRENCIA
-- ------------------------------------------------------------
/*
  PROBLEMA SIN CONTROL DE CONCURRENCIA (lectura sucia):
  -------------------------------------------------------
  Tiempo | Sesión A                        | Sesión B
  -------|----------------------------------|---------------------------
  T1     | SELECT id_plan FROM USUARIO      |
         | WHERE id_usuario = 1;            |
         | → retorna plan 3 (Premium)       |
  T2     |                                  | SELECT id_plan FROM USUARIO
         |                                  | WHERE id_usuario = 1;
         |                                  | → también retorna plan 3
  T3     | UPDATE USUARIO SET id_plan = 2   |
         | WHERE id_usuario = 1;            |
         | (sin COMMIT todavía)             |
  T4     |                                  | UPDATE USUARIO SET id_plan = 1
         |                                  | WHERE id_usuario = 1;
         |                                  | → sobrescribe el cambio de A!
  T5     | COMMIT;                          |
  T6     |                                  | COMMIT;
  RESULTADO: Plan quedó en 1 (Básico), se perdió el cambio de A.
  Esto es una ACTUALIZACIÓN PERDIDA (Lost Update).

  SOLUCIÓN CON SELECT FOR UPDATE:
  --------------------------------
  SELECT FOR UPDATE bloquea la fila seleccionada, impidiendo que
  otra sesión la modifique hasta que la primera haga COMMIT o ROLLBACK.
  Oracle implementa bloqueo pesimista a nivel de fila.

  Tiempo | Sesión A                        | Sesión B
  -------|----------------------------------|---------------------------
  T1     | SELECT id_plan FROM USUARIO      |
         | WHERE id_usuario = 1             |
         | FOR UPDATE;                      |
         | → obtiene LOCK en la fila        |
  T2     |                                  | SELECT id_plan FROM USUARIO
         |                                  | WHERE id_usuario = 1
         |                                  | FOR UPDATE;
         |                                  | → BLOQUEADA (espera a A)
  T3     | UPDATE USUARIO SET id_plan = 2   |
         | WHERE id_usuario = 1;            |
  T4     | COMMIT;  ← libera el LOCK        |
  T5     |                                  | ← Se desbloquea, obtiene LOCK
         |                                  | Relee: plan = 2 (Estándar)
         |                                  | Valida sus reglas de negocio
         |                                  | UPDATE USUARIO SET id_plan = 1
         |                                  | WHERE id_usuario = 1;
  T6     |                                  | COMMIT;
  RESULTADO: Cambios aplicados en orden correcto, sin pérdidas.
*/

-- ------------------------------------------------------------
-- SESIÓN A — Ejecutar primero (NO hacer COMMIT aún)
-- ------------------------------------------------------------
-- Este bloque simula que la Sesión A quiere cambiar el plan
-- del usuario 1 a Estándar (plan 2).
-- Usar NOWAIT para no esperar si ya hay un lock (en sesión B).
-- ------------------------------------------------------------

-- *** EJECUTAR EN SESIÓN A ***
DECLARE
    v_id_plan_actual  PLAN.id_plan%TYPE;
    v_nombre_plan     PLAN.nombre%TYPE;
    v_perfiles_count  NUMBER;
    v_max_perfiles    NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== SESIÓN A: Iniciando cambio de plan ===');

    -- Bloquear la fila del usuario para edición exclusiva
    -- NOWAIT lanza error inmediato si otro ya tiene el lock
    SELECT u.id_plan
    INTO   v_id_plan_actual
    FROM   USUARIO u
    WHERE  u.id_usuario = 4
    FOR UPDATE NOWAIT;

    DBMS_OUTPUT.PUT_LINE('Sesión A: Lock obtenido sobre usuario 4.');
    DBMS_OUTPUT.PUT_LINE('Sesión A: Plan actual = ' || v_id_plan_actual);

    -- Validar perfiles antes de cambiar
    SELECT COUNT(*) INTO v_perfiles_count
    FROM   PERFIL WHERE id_usuario = 4;

    SELECT max_perfiles, nombre INTO v_max_perfiles, v_nombre_plan
    FROM   PLAN WHERE id_plan = 2;  -- Plan Estándar

    IF v_perfiles_count > v_max_perfiles THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Sesión A: ✗ No se puede cambiar. Perfiles excedidos.');
    ELSE
        UPDATE USUARIO SET id_plan = 2 WHERE id_usuario = 4;
        DBMS_OUTPUT.PUT_LINE('Sesión A: Plan actualizado a Estándar.');
        DBMS_OUTPUT.PUT_LINE('Sesión A: Esperando antes de COMMIT...');
        -- En demo real: NO ejecutar el COMMIT de inmediato,
        -- ir a la Sesión B y ejecutar su bloque primero.
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Sesión A: COMMIT realizado. Lock liberado.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -54 THEN
            DBMS_OUTPUT.PUT_LINE('Sesión A: ✗ Recurso ocupado por otra sesión (ORA-00054).');
        ELSE
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Sesión A: ✗ Error: ' || SQLERRM);
        END IF;
END;
/

-- ------------------------------------------------------------
-- SESIÓN B — Ejecutar mientras A tiene el lock (antes de su COMMIT)
-- ------------------------------------------------------------
-- Este bloque simula que la Sesión B también quiere cambiar
-- el plan del mismo usuario 1 a Básico (plan 1).
-- Quedará BLOQUEADA hasta que A haga COMMIT o ROLLBACK.
-- ------------------------------------------------------------

-- *** EJECUTAR EN SESIÓN B (mientras A no ha hecho COMMIT) ***
DECLARE
    v_id_plan_actual NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== SESIÓN B: Intentando cambio de plan ===');

    -- WAIT 10 espera máximo 10 segundos antes de fallar
    -- En un sistema real se usaría sin WAIT (bloqueo indefinido)
    SELECT id_plan
    INTO   v_id_plan_actual
    FROM   USUARIO
    WHERE  id_usuario = 4
    FOR UPDATE WAIT 10;

    -- Este punto solo se alcanza cuando A libera el lock
    DBMS_OUTPUT.PUT_LINE('Sesión B: Lock obtenido (A ya hizo COMMIT).');
    DBMS_OUTPUT.PUT_LINE('Sesión B: Plan actual (después de A) = ' || v_id_plan_actual);

    -- Sesión B aplica su propio cambio sobre el estado actualizado
    UPDATE USUARIO SET id_plan = 1 WHERE id_usuario = 4;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Sesión B: Cambio a Básico aplicado y confirmado.');

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -30006 THEN
            DBMS_OUTPUT.PUT_LINE('Sesión B: ✗ Tiempo de espera agotado (10s). ORA-30006.');
            DBMS_OUTPUT.PUT_LINE('Sesión B: La Sesión A sigue con el lock activo.');
        ELSE
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Sesión B: ✗ Error: ' || SQLERRM);
        END IF;
END;
/

-- ------------------------------------------------------------
-- Verificar el estado final del usuario después de ambas sesiones
-- ------------------------------------------------------------
SELECT
    u.id_usuario,
    u.nombre,
    pl.nombre    AS plan_actual,
    u.estado_cuenta
FROM USUARIO u
JOIN PLAN    pl ON u.id_plan = pl.id_plan
WHERE u.id_usuario = 1;

-- ------------------------------------------------------------
-- Vista de bloqueos activos en Oracle (ejecutar durante la demo)
-- Muestra qué sesiones tienen locks y cuáles están esperando.
-- Requiere permisos de DBA o V$SESSION visible.
-- ------------------------------------------------------------
SELECT
    s.sid,
    s.serial#,
    s.username,
    s.status,
    l.type           AS tipo_lock,
    l.lmode          AS modo_lock,   -- 0=ninguno 1=null 2=RS 3=RX 4=S 5=SRX 6=X
    l.request        AS modo_solicitado,
    l.block          AS bloqueando_otros
FROM v$lock    l
JOIN v$session s ON l.sid = s.sid
WHERE l.type IN ('TM', 'TX')  -- TM=tabla TX=transacción
  AND s.username IS NOT NULL
ORDER BY l.block DESC, s.sid;

-- ============================================================
-- FIN DEL SCRIPT NÚCLEO 3
-- Elementos implementados:
--   Transacción 1: Registro completo (usuario+perfil+pago) — TODO O NADA
--   Transacción 2: Renovación mensual con SAVEPOINT por usuario
--   Transacción 3: Eliminación de cuenta en cascada — TODO O NADA
--   Escenario de concurrencia: SELECT FOR UPDATE con SESIÓN A y B
--   Documentación de estados de transacción en cada bloque
-- ============================================================
