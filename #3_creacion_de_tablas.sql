-- ============================================================
-- QUINDIOFLIX - SCRIPT DE CREACIÓN DE TABLAS
-- Universidad del Quindío - Bases de Datos II
-- Versión 2.0 - Corregido y completo
-- ============================================================

-- ============================================================
-- SECCIÓN 1: SECUENCIAS
-- En Oracle no existe AUTO_INCREMENT, se usan secuencias
-- para generar valores automáticos para las PKs.
-- ============================================================

CREATE SEQUENCE SEQ_CIUDAD         START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_DEPARTAMENTO   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PLAN           START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_GENERO         START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_EMPLEADO       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_USUARIO        START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PAGO           START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PERFIL         START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_CONTENIDO      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_TEMPORADA      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_EPISODIO       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_REPRODUCCION   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_CALIFICACION   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_REPORTE        START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- ============================================================
-- SECCIÓN 2: TABLAS DE PARAMETRIZACIÓN Y CATÁLOGOS
-- Tablas base sin dependencias externas. Se crean primero
-- para que las FK de otras tablas puedan referenciarlas.
-- ============================================================

-- Ciudades donde residen los usuarios de la plataforma
CREATE TABLE CIUDAD (
    id_ciudad NUMBER DEFAULT SEQ_CIUDAD.NEXTVAL PRIMARY KEY,
    nombre    VARCHAR2(100) NOT NULL
);

COMMENT ON TABLE  CIUDAD         IS 'Ciudades de residencia de los usuarios';
COMMENT ON COLUMN CIUDAD.id_ciudad IS 'Identificador único de la ciudad';
COMMENT ON COLUMN CIUDAD.nombre    IS 'Nombre de la ciudad (ej: Bogotá, Medellín, Cali)';

-- ------------------------------------------------------------

-- Departamentos internos de la empresa QuindioFlix
CREATE TABLE DEPARTAMENTO (
    id_departamento NUMBER DEFAULT SEQ_DEPARTAMENTO.NEXTVAL PRIMARY KEY,
    nombre          VARCHAR2(100) NOT NULL
);

COMMENT ON TABLE  DEPARTAMENTO               IS 'Departamentos internos de la empresa';
COMMENT ON COLUMN DEPARTAMENTO.id_departamento IS 'Identificador único del departamento';
COMMENT ON COLUMN DEPARTAMENTO.nombre          IS 'Nombre del departamento (ej: Tecnología, Contenido, Soporte)';

-- ------------------------------------------------------------

-- Planes de suscripción disponibles en la plataforma
CREATE TABLE PLAN (
    id_plan       NUMBER DEFAULT SEQ_PLAN.NEXTVAL PRIMARY KEY,
    nombre        VARCHAR2(100) NOT NULL,
    precio        NUMBER(10,2)  NOT NULL,
    max_pantallas NUMBER        NOT NULL,
    calidad       VARCHAR2(10)  NOT NULL,
    max_perfiles  NUMBER        NOT NULL,
    CONSTRAINT chk_plan_calidad   CHECK (calidad IN ('SD', 'HD', '4K')),
    CONSTRAINT chk_plan_precio    CHECK (precio > 0),
    CONSTRAINT chk_plan_pantallas CHECK (max_pantallas > 0),
    CONSTRAINT chk_plan_perfiles  CHECK (max_perfiles > 0)
);

COMMENT ON TABLE  PLAN              IS 'Planes de suscripción: Básico, Estándar, Premium';
COMMENT ON COLUMN PLAN.id_plan       IS 'Identificador único del plan';
COMMENT ON COLUMN PLAN.nombre        IS 'Nombre del plan (Básico, Estándar, Premium)';
COMMENT ON COLUMN PLAN.precio        IS 'Precio mensual en pesos colombianos';
COMMENT ON COLUMN PLAN.max_pantallas IS 'Número máximo de pantallas simultáneas permitidas';
COMMENT ON COLUMN PLAN.calidad       IS 'Calidad de reproducción: SD, HD o 4K';
COMMENT ON COLUMN PLAN.max_perfiles  IS 'Número máximo de perfiles por cuenta';

-- ------------------------------------------------------------

-- Géneros de contenido disponibles en el catálogo
CREATE TABLE GENERO (
    id_genero   NUMBER DEFAULT SEQ_GENERO.NEXTVAL PRIMARY KEY,
    nombre      VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(255)
);

COMMENT ON TABLE  GENERO            IS 'Géneros disponibles para clasificar el contenido';
COMMENT ON COLUMN GENERO.id_genero   IS 'Identificador único del género';
COMMENT ON COLUMN GENERO.nombre      IS 'Nombre del género (Acción, Comedia, Drama, etc.)';
COMMENT ON COLUMN GENERO.descripcion IS 'Descripción opcional del género';

-- ============================================================
-- SECCIÓN 3: EMPLEADOS Y ORGANIZACIÓN INTERNA
-- ============================================================

-- Empleados de QuindioFlix organizados por departamento.
-- Soporta jerarquía de supervisión (relación reflexiva).
CREATE TABLE EMPLEADO (
    id_empleado       NUMBER DEFAULT SEQ_EMPLEADO.NEXTVAL PRIMARY KEY,
    nombre            VARCHAR2(150) NOT NULL,
    email             VARCHAR2(150) NOT NULL,
    cargo             VARCHAR2(100),
    fecha_contratacion DATE DEFAULT SYSDATE,
    id_departamento   NUMBER,
    id_supervisor     NUMBER,
    CONSTRAINT uq_empleado_email       UNIQUE (email),
    CONSTRAINT fk_empleado_depto       FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTO(id_departamento),
    CONSTRAINT fk_empleado_supervisor  FOREIGN KEY (id_supervisor)   REFERENCES EMPLEADO(id_empleado)
);

COMMENT ON TABLE  EMPLEADO                  IS 'Empleados de QuindioFlix con jerarquía de supervisión';
COMMENT ON COLUMN EMPLEADO.id_empleado       IS 'Identificador único del empleado';
COMMENT ON COLUMN EMPLEADO.nombre            IS 'Nombre completo del empleado';
COMMENT ON COLUMN EMPLEADO.email             IS 'Correo institucional único';
COMMENT ON COLUMN EMPLEADO.cargo             IS 'Cargo o posición del empleado (ej: Analista, Moderador)';
COMMENT ON COLUMN EMPLEADO.fecha_contratacion IS 'Fecha de ingreso a la empresa';
COMMENT ON COLUMN EMPLEADO.id_departamento   IS 'FK al departamento al que pertenece';
COMMENT ON COLUMN EMPLEADO.id_supervisor     IS 'FK al empleado que lo supervisa (relación reflexiva)';

-- ============================================================
-- SECCIÓN 4: USUARIOS, PERFILES Y PAGOS
-- ============================================================

-- Usuarios registrados en la plataforma.
-- Soporta referidos (relación reflexiva id_referido_por).
CREATE TABLE USUARIO (
    id_usuario      NUMBER DEFAULT SEQ_USUARIO.NEXTVAL PRIMARY KEY,
    nombre          VARCHAR2(150) NOT NULL,
    email           VARCHAR2(150) NOT NULL,
    contrasena      VARCHAR2(255) NOT NULL,
    telefono        VARCHAR2(20),
    fecha_nacimiento DATE,
    estado_cuenta   VARCHAR2(20)  DEFAULT 'ACTIVO' NOT NULL,
    fecha_ultimo_pago DATE,
    id_ciudad       NUMBER,
    id_plan         NUMBER,
    id_referido_por NUMBER,
    CONSTRAINT uq_usuario_email      UNIQUE (email),
    CONSTRAINT chk_usuario_estado    CHECK (estado_cuenta IN ('ACTIVO', 'INACTIVO', 'SUSPENDIDO')),
    CONSTRAINT fk_usuario_ciudad     FOREIGN KEY (id_ciudad)       REFERENCES CIUDAD(id_ciudad),
    CONSTRAINT fk_usuario_plan       FOREIGN KEY (id_plan)         REFERENCES PLAN(id_plan),
    CONSTRAINT fk_usuario_referido   FOREIGN KEY (id_referido_por) REFERENCES USUARIO(id_usuario)
);

COMMENT ON TABLE  USUARIO                IS 'Usuarios registrados en la plataforma QuindioFlix';
COMMENT ON COLUMN USUARIO.id_usuario      IS 'Identificador único del usuario';
COMMENT ON COLUMN USUARIO.nombre          IS 'Nombre completo del usuario';
COMMENT ON COLUMN USUARIO.email           IS 'Correo electrónico único usado para el login';
COMMENT ON COLUMN USUARIO.contrasena      IS 'Contraseña hasheada del usuario';
COMMENT ON COLUMN USUARIO.telefono        IS 'Número de contacto del usuario';
COMMENT ON COLUMN USUARIO.fecha_nacimiento IS 'Fecha de nacimiento para validar acceso a contenido por edad';
COMMENT ON COLUMN USUARIO.estado_cuenta   IS 'Estado de la cuenta: ACTIVO, INACTIVO o SUSPENDIDO';
COMMENT ON COLUMN USUARIO.fecha_ultimo_pago IS 'Fecha del último pago exitoso registrado';
COMMENT ON COLUMN USUARIO.id_ciudad       IS 'FK a la ciudad de residencia del usuario';
COMMENT ON COLUMN USUARIO.id_plan         IS 'FK al plan de suscripción activo';
COMMENT ON COLUMN USUARIO.id_referido_por IS 'FK al usuario que lo refirió (relación reflexiva)';

-- ------------------------------------------------------------

-- Registro de pagos mensuales de suscripción
CREATE TABLE PAGO (
    id_pago     NUMBER DEFAULT SEQ_PAGO.NEXTVAL PRIMARY KEY,
    fecha       DATE          DEFAULT SYSDATE,
    monto       NUMBER(10,2)  NOT NULL,
    metodo_pago VARCHAR2(20)  NOT NULL,
    estado      VARCHAR2(20)  NOT NULL,
    id_usuario  NUMBER        NOT NULL,
    CONSTRAINT chk_pago_metodo  CHECK (metodo_pago IN ('TARJETA_CREDITO', 'TARJETA_DEBITO', 'PSE', 'NEQUI', 'DAVIPLATA')),
    CONSTRAINT chk_pago_estado  CHECK (estado IN ('EXITOSO', 'FALLIDO', 'PENDIENTE', 'REEMBOLSADO')),
    CONSTRAINT chk_pago_monto   CHECK (monto > 0),
    CONSTRAINT fk_pago_usuario  FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);

COMMENT ON TABLE  PAGO             IS 'Historial de pagos de suscripción de los usuarios';
COMMENT ON COLUMN PAGO.id_pago     IS 'Identificador único del pago';
COMMENT ON COLUMN PAGO.fecha       IS 'Fecha en que se realizó o intentó el pago';
COMMENT ON COLUMN PAGO.monto       IS 'Monto cobrado en pesos colombianos';
COMMENT ON COLUMN PAGO.metodo_pago IS 'Método usado: TARJETA_CREDITO, TARJETA_DEBITO, PSE, NEQUI, DAVIPLATA';
COMMENT ON COLUMN PAGO.estado      IS 'Estado del pago: EXITOSO, FALLIDO, PENDIENTE, REEMBOLSADO';
COMMENT ON COLUMN PAGO.id_usuario  IS 'FK al usuario que realizó el pago';

-- ------------------------------------------------------------

-- Perfiles dentro de una cuenta de usuario.
-- Cada cuenta puede tener múltiples perfiles según el plan.
CREATE TABLE PERFIL (
    id_perfil   NUMBER DEFAULT SEQ_PERFIL.NEXTVAL PRIMARY KEY,
    nombre      VARCHAR2(100) NOT NULL,
    avatar      VARCHAR2(255),
    tipo_perfil VARCHAR2(20)  NOT NULL,
    id_usuario  NUMBER        NOT NULL,
    CONSTRAINT chk_perfil_tipo    CHECK (tipo_perfil IN ('ADULTO', 'INFANTIL')),
    CONSTRAINT fk_perfil_usuario  FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);

COMMENT ON TABLE  PERFIL             IS 'Perfiles asociados a cada cuenta de usuario';
COMMENT ON COLUMN PERFIL.id_perfil   IS 'Identificador único del perfil';
COMMENT ON COLUMN PERFIL.nombre      IS 'Nombre visible del perfil dentro de la cuenta';
COMMENT ON COLUMN PERFIL.avatar      IS 'URL o referencia al avatar seleccionado';
COMMENT ON COLUMN PERFIL.tipo_perfil IS 'Tipo de perfil: ADULTO o INFANTIL (restringe clasificación de edad)';
COMMENT ON COLUMN PERFIL.id_usuario  IS 'FK al usuario propietario de este perfil';

-- ============================================================
-- SECCIÓN 5: CONTENIDO MULTIMEDIA
-- Se usa herencia por tabla (tabla padre CONTENIDO +
-- tablas hijas por subtipo). El discriminador tipo_contenido
-- en CONTENIDO indica el subtipo activo.
-- ============================================================

-- Tabla padre del catálogo de contenido multimedia
CREATE TABLE CONTENIDO (
    id_contenido       NUMBER DEFAULT SEQ_CONTENIDO.NEXTVAL PRIMARY KEY,
    titulo             VARCHAR2(200) NOT NULL,
    anio_lanzamiento   NUMBER(4),
    duracion           INTERVAL DAY TO SECOND,
    sinopsis           CLOB,
    clasificacion_edad VARCHAR2(10)  NOT NULL,
    fecha_agregado     DATE          DEFAULT SYSDATE,
    es_original        NUMBER(1)     DEFAULT 0 NOT NULL,
    tipo_contenido     VARCHAR2(20)  NOT NULL,
    id_empleado_publica NUMBER,
    CONSTRAINT chk_contenido_clasificacion CHECK (clasificacion_edad IN ('TP', '+7', '+13', '+16', '+18')),
    CONSTRAINT chk_contenido_original      CHECK (es_original IN (0, 1)),
    CONSTRAINT chk_contenido_tipo          CHECK (tipo_contenido IN ('PELICULA', 'SERIE', 'DOCUMENTAL', 'MUSICA', 'PODCAST')),
    CONSTRAINT fk_contenido_empleado       FOREIGN KEY (id_empleado_publica) REFERENCES EMPLEADO(id_empleado)
);

COMMENT ON TABLE  CONTENIDO                    IS 'Catálogo general de contenido multimedia de la plataforma';
COMMENT ON COLUMN CONTENIDO.id_contenido        IS 'Identificador único del contenido';
COMMENT ON COLUMN CONTENIDO.titulo              IS 'Título del contenido';
COMMENT ON COLUMN CONTENIDO.anio_lanzamiento    IS 'Año de estreno o lanzamiento original';
COMMENT ON COLUMN CONTENIDO.duracion            IS 'Duración total (para películas, música y episodios sueltos)';
COMMENT ON COLUMN CONTENIDO.sinopsis            IS 'Descripción o sinopsis del contenido';
COMMENT ON COLUMN CONTENIDO.clasificacion_edad  IS 'Clasificación de edad: TP, +7, +13, +16, +18';
COMMENT ON COLUMN CONTENIDO.fecha_agregado      IS 'Fecha en que fue agregado al catálogo de QuindioFlix';
COMMENT ON COLUMN CONTENIDO.es_original         IS '1 si es producción original de QuindioFlix, 0 si es externo';
COMMENT ON COLUMN CONTENIDO.tipo_contenido      IS 'Discriminador de subtipo: PELICULA, SERIE, DOCUMENTAL, MUSICA, PODCAST';
COMMENT ON COLUMN CONTENIDO.id_empleado_publica IS 'FK al empleado de Contenido responsable de publicarlo';

-- Subtipo: Película (sin temporadas ni episodios)
CREATE TABLE PELICULA (
    id_contenido NUMBER PRIMARY KEY,
    CONSTRAINT fk_pelicula_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE
);
COMMENT ON TABLE PELICULA IS 'Subtipos de contenido: películas. Hereda de CONTENIDO.';

-- Subtipo: Serie (tiene temporadas y episodios)
CREATE TABLE SERIE (
    id_contenido NUMBER PRIMARY KEY,
    CONSTRAINT fk_serie_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE
);
COMMENT ON TABLE SERIE IS 'Subtipo de contenido: series con temporadas y episodios. Hereda de CONTENIDO.';

-- Subtipo: Documental
CREATE TABLE DOCUMENTAL (
    id_contenido NUMBER PRIMARY KEY,
    CONSTRAINT fk_documental_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE
);
COMMENT ON TABLE DOCUMENTAL IS 'Subtipo de contenido: documentales. Hereda de CONTENIDO.';

-- Subtipo: Música
CREATE TABLE MUSICA (
    id_contenido NUMBER PRIMARY KEY,
    CONSTRAINT fk_musica_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE
);
COMMENT ON TABLE MUSICA IS 'Subtipo de contenido: álbumes o pistas musicales. Hereda de CONTENIDO.';

-- Subtipo: Podcast (tiene temporadas y episodios)
CREATE TABLE PODCAST (
    id_contenido NUMBER PRIMARY KEY,
    CONSTRAINT fk_podcast_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE
);
COMMENT ON TABLE PODCAST IS 'Subtipo de contenido: podcasts con temporadas y episodios. Hereda de CONTENIDO.';

-- ============================================================
-- SECCIÓN 6: ESTRUCTURA DE SERIES Y PODCASTS
-- Las series y podcasts se organizan en temporadas,
-- cada temporada contiene episodios.
-- ============================================================

CREATE TABLE TEMPORADA (
    id_temporada     NUMBER DEFAULT SEQ_TEMPORADA.NEXTVAL PRIMARY KEY,
    numero_temporada NUMBER NOT NULL,
    id_contenido     NUMBER NOT NULL,
    CONSTRAINT uq_temporada_numero     UNIQUE (id_contenido, numero_temporada),
    CONSTRAINT fk_temporada_contenido  FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE
);

COMMENT ON TABLE  TEMPORADA                 IS 'Temporadas de series y podcasts';
COMMENT ON COLUMN TEMPORADA.id_temporada    IS 'Identificador único de la temporada';
COMMENT ON COLUMN TEMPORADA.numero_temporada IS 'Número de la temporada (1, 2, 3...)';
COMMENT ON COLUMN TEMPORADA.id_contenido    IS 'FK al contenido (serie o podcast) al que pertenece';

-- ------------------------------------------------------------

CREATE TABLE EPISODIO (
    id_episodio     NUMBER DEFAULT SEQ_EPISODIO.NEXTVAL PRIMARY KEY,
    numero_episodio NUMBER        NOT NULL,
    titulo          VARCHAR2(200),
    duracion        INTERVAL DAY TO SECOND,
    id_temporada    NUMBER        NOT NULL,
    CONSTRAINT uq_episodio_numero     UNIQUE (id_temporada, numero_episodio),
    CONSTRAINT fk_episodio_temporada  FOREIGN KEY (id_temporada) REFERENCES TEMPORADA(id_temporada) ON DELETE CASCADE
);

COMMENT ON TABLE  EPISODIO                IS 'Episodios de cada temporada';
COMMENT ON COLUMN EPISODIO.id_episodio    IS 'Identificador único del episodio';
COMMENT ON COLUMN EPISODIO.numero_episodio IS 'Número del episodio dentro de la temporada';
COMMENT ON COLUMN EPISODIO.titulo         IS 'Título del episodio';
COMMENT ON COLUMN EPISODIO.duracion       IS 'Duración del episodio';
COMMENT ON COLUMN EPISODIO.id_temporada   IS 'FK a la temporada a la que pertenece';

-- ============================================================
-- SECCIÓN 7: TABLAS PUENTE (RELACIONES N:M)
-- ============================================================

-- Un contenido puede pertenecer a varios géneros y
-- un género puede clasificar varios contenidos.
CREATE TABLE CONTENIDO_GENERO (
    id_contenido NUMBER,
    id_genero    NUMBER,
    PRIMARY KEY (id_contenido, id_genero),
    CONSTRAINT fk_cg_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE,
    CONSTRAINT fk_cg_genero    FOREIGN KEY (id_genero)    REFERENCES GENERO(id_genero)    ON DELETE CASCADE
);

COMMENT ON TABLE CONTENIDO_GENERO IS 'Relación N:M entre contenido y géneros. Un contenido puede tener múltiples géneros.';

-- ------------------------------------------------------------

-- Relaciones entre contenidos: secuelas, precuelas,
-- remakes, spin-offs, versiones extendidas, etc.
-- Es una relación reflexiva N:M sobre CONTENIDO.
CREATE TABLE RELACION_CONTENIDO (
    id_origen      NUMBER,
    id_destino     NUMBER,
    tipo_relacion  VARCHAR2(100),
    PRIMARY KEY (id_origen, id_destino),
    CONSTRAINT fk_rc_origen  FOREIGN KEY (id_origen)  REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE,
    CONSTRAINT fk_rc_destino FOREIGN KEY (id_destino) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE,
    CONSTRAINT chk_rc_no_self CHECK (id_origen <> id_destino)
);

COMMENT ON TABLE  RELACION_CONTENIDO               IS 'Relaciones entre contenidos: secuela, precuela, remake, spin-off, etc.';
COMMENT ON COLUMN RELACION_CONTENIDO.id_origen      IS 'FK al contenido de origen de la relación';
COMMENT ON COLUMN RELACION_CONTENIDO.id_destino     IS 'FK al contenido destino de la relación';
COMMENT ON COLUMN RELACION_CONTENIDO.tipo_relacion  IS 'Tipo: secuela, precuela, remake, spin-off, versión extendida, etc.';

-- ============================================================
-- SECCIÓN 8: INTERACCIONES Y CONSUMO
-- Registro de todo lo que hace un perfil en la plataforma.
-- ============================================================

-- Cada vez que un perfil reproduce contenido queda registrado.
-- Si el contenido es de una serie/podcast, se registra el episodio.
CREATE TABLE REPRODUCCION (
    id_reproduccion   NUMBER DEFAULT SEQ_REPRODUCCION.NEXTVAL PRIMARY KEY,
    fecha_hora_inicio TIMESTAMP     DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_hora_fin    TIMESTAMP,
    dispositivo       VARCHAR2(20)  NOT NULL,
    avance_porcentaje NUMBER(5,2)   DEFAULT 0,
    id_perfil         NUMBER        NOT NULL,
    id_contenido      NUMBER        NOT NULL,
    id_episodio       NUMBER,
    CONSTRAINT chk_rep_dispositivo CHECK (dispositivo IN ('CELULAR', 'TABLET', 'TV', 'COMPUTADOR')),
    CONSTRAINT chk_rep_avance      CHECK (avance_porcentaje BETWEEN 0 AND 100),
    CONSTRAINT fk_rep_perfil       FOREIGN KEY (id_perfil)    REFERENCES PERFIL(id_perfil)       ON DELETE CASCADE,
    CONSTRAINT fk_rep_contenido    FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE,
    CONSTRAINT fk_rep_episodio     FOREIGN KEY (id_episodio)  REFERENCES EPISODIO(id_episodio)
);

COMMENT ON TABLE  REPRODUCCION                   IS 'Registro de cada reproducción realizada por un perfil';
COMMENT ON COLUMN REPRODUCCION.id_reproduccion   IS 'Identificador único de la reproducción';
COMMENT ON COLUMN REPRODUCCION.fecha_hora_inicio IS 'Fecha y hora de inicio de la reproducción';
COMMENT ON COLUMN REPRODUCCION.fecha_hora_fin    IS 'Fecha y hora de fin (NULL si no terminó)';
COMMENT ON COLUMN REPRODUCCION.dispositivo       IS 'Dispositivo usado: CELULAR, TABLET, TV, COMPUTADOR';
COMMENT ON COLUMN REPRODUCCION.avance_porcentaje IS 'Porcentaje del contenido visto (0-100)';
COMMENT ON COLUMN REPRODUCCION.id_perfil         IS 'FK al perfil que realizó la reproducción';
COMMENT ON COLUMN REPRODUCCION.id_contenido      IS 'FK al contenido reproducido';
COMMENT ON COLUMN REPRODUCCION.id_episodio       IS 'FK al episodio reproducido (NULL si no es serie/podcast)';

-- ------------------------------------------------------------

-- Calificaciones de contenido por perfil.
-- Un perfil solo puede calificar un contenido una vez.
CREATE TABLE CALIFICACION (
    id_calificacion NUMBER DEFAULT SEQ_CALIFICACION.NEXTVAL PRIMARY KEY,
    estrellas       NUMBER(1)    NOT NULL,
    resena          CLOB,
    fecha           DATE         DEFAULT SYSDATE,
    id_perfil       NUMBER       NOT NULL,
    id_contenido    NUMBER       NOT NULL,
    CONSTRAINT uq_calificacion_perfil_cont UNIQUE (id_perfil, id_contenido),
    CONSTRAINT chk_cal_estrellas           CHECK (estrellas BETWEEN 1 AND 5),
    CONSTRAINT fk_cal_perfil               FOREIGN KEY (id_perfil)    REFERENCES PERFIL(id_perfil)       ON DELETE CASCADE,
    CONSTRAINT fk_cal_contenido            FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE
);

COMMENT ON TABLE  CALIFICACION                IS 'Calificaciones y reseñas de contenido por perfil (1 por perfil/contenido)';
COMMENT ON COLUMN CALIFICACION.id_calificacion IS 'Identificador único de la calificación';
COMMENT ON COLUMN CALIFICACION.estrellas       IS 'Puntuación de 1 a 5 estrellas';
COMMENT ON COLUMN CALIFICACION.resena          IS 'Reseña escrita opcional';
COMMENT ON COLUMN CALIFICACION.fecha           IS 'Fecha en que se realizó la calificación';
COMMENT ON COLUMN CALIFICACION.id_perfil       IS 'FK al perfil que calificó';
COMMENT ON COLUMN CALIFICACION.id_contenido    IS 'FK al contenido calificado';

-- ------------------------------------------------------------

-- Lista de favoritos por perfil
CREATE TABLE FAVORITO (
    id_perfil      NUMBER,
    id_contenido   NUMBER,
    fecha_agregado DATE DEFAULT SYSDATE,
    PRIMARY KEY (id_perfil, id_contenido),
    CONSTRAINT fk_fav_perfil    FOREIGN KEY (id_perfil)    REFERENCES PERFIL(id_perfil)       ON DELETE CASCADE,
    CONSTRAINT fk_fav_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE
);

COMMENT ON TABLE  FAVORITO               IS 'Lista personal de contenido favorito por perfil';
COMMENT ON COLUMN FAVORITO.id_perfil     IS 'FK al perfil dueño de la lista';
COMMENT ON COLUMN FAVORITO.id_contenido  IS 'FK al contenido marcado como favorito';
COMMENT ON COLUMN FAVORITO.fecha_agregado IS 'Fecha en que el contenido fue agregado a favoritos';

-- ------------------------------------------------------------

-- Reportes de contenido inapropiado.
-- Los resuelve un empleado del área de Soporte.
CREATE TABLE REPORTE (
    id_reporte             NUMBER DEFAULT SEQ_REPORTE.NEXTVAL PRIMARY KEY,
    descripcion            CLOB         NOT NULL,
    estado                 VARCHAR2(20) DEFAULT 'PENDIENTE' NOT NULL,
    fecha_reporte          DATE         DEFAULT SYSDATE,
    fecha_resolucion       DATE,
    id_perfil_informa      NUMBER       NOT NULL,
    id_contenido_reportado NUMBER       NOT NULL,
    id_empleado_resuelve   NUMBER,
    CONSTRAINT chk_reporte_estado    CHECK (estado IN ('PENDIENTE', 'RESUELTO', 'RECHAZADO')),
    CONSTRAINT fk_rpt_perfil         FOREIGN KEY (id_perfil_informa)      REFERENCES PERFIL(id_perfil),
    CONSTRAINT fk_rpt_cont_reportado FOREIGN KEY (id_contenido_reportado) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT fk_rpt_empleado       FOREIGN KEY (id_empleado_resuelve)   REFERENCES EMPLEADO(id_empleado)
);

COMMENT ON TABLE  REPORTE                       IS 'Reportes de contenido inapropiado realizados por perfiles';
COMMENT ON COLUMN REPORTE.id_reporte             IS 'Identificador único del reporte';
COMMENT ON COLUMN REPORTE.descripcion            IS 'Descripción del motivo del reporte';
COMMENT ON COLUMN REPORTE.estado                 IS 'Estado: PENDIENTE, RESUELTO o RECHAZADO';
COMMENT ON COLUMN REPORTE.fecha_reporte          IS 'Fecha en que se creó el reporte';
COMMENT ON COLUMN REPORTE.fecha_resolucion       IS 'Fecha en que fue resuelto o rechazado (NULL si está pendiente)';
COMMENT ON COLUMN REPORTE.id_perfil_informa      IS 'FK al perfil que generó el reporte';
COMMENT ON COLUMN REPORTE.id_contenido_reportado IS 'FK al contenido reportado';
COMMENT ON COLUMN REPORTE.id_empleado_resuelve   IS 'FK al empleado de Soporte que resolvió el reporte';

-- ============================================================
-- FIN DEL SCRIPT
-- Tablas creadas: 20
-- Secuencias creadas: 14
-- ============================================================
