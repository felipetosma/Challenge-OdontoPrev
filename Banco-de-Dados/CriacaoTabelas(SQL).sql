
DROP TABLE c_op_agendamento CASCADE CONSTRAINTS;

DROP TABLE c_op_checklist CASCADE CONSTRAINTS;

DROP TABLE c_op_dentista CASCADE CONSTRAINTS;

DROP TABLE c_op_dentista_plano CASCADE CONSTRAINTS;

DROP TABLE c_op_especialidade CASCADE CONSTRAINTS;

DROP TABLE c_op_notificacao CASCADE CONSTRAINTS;

DROP TABLE c_op_plano_de_saude CASCADE CONSTRAINTS;

DROP TABLE c_op_status CASCADE CONSTRAINTS;

DROP TABLE c_op_tipo_plano CASCADE CONSTRAINTS;

DROP TABLE c_op_tratamento CASCADE CONSTRAINTS;

DROP TABLE c_op_usuario CASCADE CONSTRAINTS;

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_usuario (
    id_usuario       NUMBER(30) NOT NULL,
    nome_usuario     VARCHAR2(100) NOT NULL,
    senha_usuario    VARCHAR2(20) NOT NULL,
    email_usuario    VARCHAR2(50) NOT NULL,
    nr_carteira      VARCHAR2(50) NOT NULL,
    telefone_usuario NUMBER(15) NOT NULL
);

ALTER TABLE c_op_usuario ADD CONSTRAINT c_op_usuario_pk PRIMARY KEY ( id_usuario );

ALTER TABLE c_op_usuario ADD CONSTRAINT c_op_usuario_nr_carteira_un UNIQUE ( nr_carteira );

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_especialidade (
    id_especialidade    NUMBER(30) NOT NULL,
    tipo_especialidade  VARCHAR2(100) NOT NULL,
    descr_especialidade VARCHAR2(300)
);

ALTER TABLE c_op_especialidade ADD CONSTRAINT c_op_especialidade_pk PRIMARY KEY ( id_especialidade );



-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_checklist (
    id_checklist            NUMBER(30) NOT NULL,
    nivel                   NUMBER(30) NOT NULL,
    escovacao_dentes        NUMBER(30),
    fio_dental              NUMBER(30),
    enxaguante_bucal        NUMBER(30),
    id_usuario              NUMBER(30) NOT NULL
);

CREATE UNIQUE INDEX c_op_checklist__idx ON
    c_op_checklist (
        id_usuario
    ASC );

ALTER TABLE c_op_checklist ADD CONSTRAINT c_op_checklist_pk PRIMARY KEY ( id_checklist );

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_dentista (
    id_dentista       NUMBER(30) NOT NULL,
    nome_dentista     VARCHAR2(100) NOT NULL,
    senha_dentista    VARCHAR2(20) NOT NULL,
    cro               VARCHAR2(20) NOT NULL,
    telefone_dentista NUMBER(15) NOT NULL,
    email_dentista    VARCHAR2(50) NOT NULL,
    id_especialidade  NUMBER(30) NOT NULL
);

ALTER TABLE c_op_dentista ADD CONSTRAINT c_op_dentista_pk PRIMARY KEY ( id_dentista );

ALTER TABLE c_op_dentista ADD CONSTRAINT c_op_dentista_cro_un UNIQUE ( cro );

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_status (
    id_status    NUMBER(30) NOT NULL,
    tipo_status  VARCHAR2(50) NOT NULL,
    descr_status VARCHAR2(300) NOT NULL
);

ALTER TABLE c_op_status ADD CONSTRAINT c_op_status_pk PRIMARY KEY ( id_status );

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_tipo_plano (
    id_tipo_plano    NUMBER(30) NOT NULL,
    nome_tipo_plano  VARCHAR2(100) NOT NULL,
    descr_tipo_plano VARCHAR2(300)
);

ALTER TABLE c_op_tipo_plano ADD CONSTRAINT c_op_tipo_plano_pk PRIMARY KEY ( id_tipo_plano );

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_plano_de_saude (
    id_plano       NUMBER(30) NOT NULL,
    nome_plano     VARCHAR2(100) NOT NULL,
    telefone_plano NUMBER(15) NOT NULL,
    email_plano    VARCHAR2(50),
    id_tipo_plano  NUMBER(30) NOT NULL
);

ALTER TABLE c_op_plano_de_saude ADD CONSTRAINT c_op_plano_de_saude_pk PRIMARY KEY ( id_plano );

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_dentista_plano (
    id_plano    NUMBER(30) NOT NULL,
    id_dentista NUMBER(30) NOT NULL
);

ALTER TABLE c_op_dentista_plano ADD CONSTRAINT c_op_dentista_plano_pk PRIMARY KEY ( id_plano, id_dentista );

-------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE c_op_notificacao (
    id_notificacao NUMBER(30) NOT NULL,
    mensagem       VARCHAR2(300) NOT NULL,
    data_envio     DATE NOT NULL,
    leitura        CHAR(1) NOT NULL
);

ALTER TABLE c_op_notificacao ADD CONSTRAINT c_op_notificacao_pk PRIMARY KEY ( id_notificacao );

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_tratamento (
    id_tratamento         NUMBER(30) NOT NULL,
    tipo_tratamento       VARCHAR2(200) NOT NULL,
    dt_inicio_tratamento  DATE NOT NULL,
    dt_termino_tratamento DATE,
    descr_tratamento      VARCHAR2(300),
    id_dentista           NUMBER(30) NOT NULL,
    id_usuario            NUMBER(30) NOT NULL,
    id_notificacao        NUMBER(30) NOT NULL,
    id_status             NUMBER(30) NOT NULL,
    id_plano              NUMBER(30) NOT NULL
);



ALTER TABLE c_op_tratamento ADD CONSTRAINT c_op_tratamento_pk PRIMARY KEY ( id_tratamento );

-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_agendamento (
    id_agendamento   NUMBER(30) NOT NULL,
    data_agendada    DATE NOT NULL,
    horario_agendado DATE NOT NULL,
    id_status        NUMBER(30) NOT NULL,
    id_tratamento    NUMBER(30) NOT NULL
);



ALTER TABLE c_op_agendamento ADD CONSTRAINT c_op_agendamento_pk PRIMARY KEY ( id_agendamento );


-------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE c_op_agendamento
    ADD CONSTRAINT agendamento_status_fk FOREIGN KEY ( id_status )
        REFERENCES c_op_status ( id_status );

ALTER TABLE c_op_dentista_plano
    ADD CONSTRAINT c_op_dentista_fk FOREIGN KEY ( id_dentista )
        REFERENCES c_op_dentista ( id_dentista );

ALTER TABLE c_op_dentista_plano
    ADD CONSTRAINT c_op_plano_de_saude_fk FOREIGN KEY ( id_plano )
        REFERENCES c_op_plano_de_saude ( id_plano );

ALTER TABLE c_op_checklist
    ADD CONSTRAINT checklist_usuario_fk FOREIGN KEY ( id_usuario )
        REFERENCES c_op_usuario ( id_usuario );

ALTER TABLE c_op_dentista
    ADD CONSTRAINT dentista_especialidade_fk FOREIGN KEY ( id_especialidade )
        REFERENCES c_op_especialidade ( id_especialidade );

ALTER TABLE c_op_plano_de_saude
    ADD CONSTRAINT plano_tipo_plano_fk FOREIGN KEY ( id_tipo_plano )
        REFERENCES c_op_tipo_plano ( id_tipo_plano );

ALTER TABLE c_op_agendamento
    ADD CONSTRAINT agendamento_tratamento_fk FOREIGN KEY ( id_tratamento )
        REFERENCES c_op_tratamento ( id_tratamento );

ALTER TABLE c_op_tratamento
    ADD CONSTRAINT tratamento_dentista_fk FOREIGN KEY ( id_dentista )
        REFERENCES c_op_dentista ( id_dentista );

ALTER TABLE c_op_tratamento
    ADD CONSTRAINT tratamento_notificacao_fk FOREIGN KEY ( id_notificacao )
        REFERENCES c_op_notificacao ( id_notificacao );

ALTER TABLE c_op_tratamento
    ADD CONSTRAINT tratamento_plano_fk FOREIGN KEY ( id_plano )
        REFERENCES c_op_plano_de_saude ( id_plano );

ALTER TABLE c_op_tratamento
    ADD CONSTRAINT tratamento_status_fk FOREIGN KEY ( id_status )
        REFERENCES c_op_status ( id_status );

ALTER TABLE c_op_tratamento
    ADD CONSTRAINT tratamento_usuario_fk FOREIGN KEY ( id_usuario )
        REFERENCES c_op_usuario ( id_usuario );

