DROP TABLE c_op_usuario CASCADE CONSTRAINTS;

DROP TABLE c_op_dentista CASCADE CONSTRAINTS;

DROP TABLE c_op_plano_de_saude CASCADE CONSTRAINTS;

DROP TABLE c_op_dentista_planosaude CASCADE CONSTRAINTS;

DROP TABLE c_op_agendamento CASCADE CONSTRAINTS;

DROP TABLE c_op_notificacao CASCADE CONSTRAINTS;

DROP TABLE c_op_tratamento CASCADE CONSTRAINTS;

DROP TABLE c_op_checklist CASCADE CONSTRAINTS;

-------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE c_op_usuario (
    id_usuario     NUMBER(30) NOT NULL,
    nome_usuario   VARCHAR2(100) NOT NULL,
    senha_usuario  VARCHAR2(20) NOT NULL,
    email_usuario  VARCHAR2(50) NOT NULL,
    nr_carteira    VARCHAR2(100) NOT NULL,
    id_dentista    NUMBER(30) NOT NULL,
    id_plano       NUMBER(30) NOT NULL,
    id_notificacao NUMBER(30) NOT NULL
)
LOGGING;

CREATE UNIQUE INDEX c_op_usuario__idx ON
    c_op_usuario (
        id_notificacao
    ASC );

ALTER TABLE c_op_usuario ADD CONSTRAINT c_op_usuario_pk PRIMARY KEY ( id_usuario );

ALTER TABLE c_op_usuario ADD CONSTRAINT c_op_usuario__un UNIQUE ( nr_carteira );

------------------------------------------------------------------------------------------------------
CREATE TABLE c_op_dentista (
    id_dentista    NUMBER(30) NOT NULL,
    nome_dentista  VARCHAR2(100) NOT NULL,
    senha_dentista VARCHAR2(20) NOT NULL,
    especialidade  VARCHAR2(200) NOT NULL,
    cro            VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE c_op_dentista ADD CONSTRAINT c_op_dentista_pk PRIMARY KEY ( id_dentista );

ALTER TABLE c_op_dentista ADD CONSTRAINT c_op_dentista__un UNIQUE ( cro );

------------------------------------------------------------------------------------------------------
CREATE TABLE c_op_plano_de_saude (
    id_plano   NUMBER(30) NOT NULL,
    nome_plano VARCHAR2(100) NOT NULL,
    descricao  VARCHAR2(300)
)
LOGGING;

ALTER TABLE c_op_plano_de_saude ADD CONSTRAINT c_op_plano_de_saude_pk PRIMARY KEY ( id_plano );


------------------------------------------------------------------------------------------------------
CREATE TABLE c_op_dentista_planosaude (
    id_plano    NUMBER(30) NOT NULL,
    id_dentista NUMBER(30) NOT NULL
)
LOGGING;

ALTER TABLE c_op_dentista_planosaude ADD CONSTRAINT c_op_dentista_planosaude_pk PRIMARY KEY ( id_plano, id_dentista );

------------------------------------------------------------------------------------------------------
CREATE TABLE c_op_agendamento (
    id_agendamento        NUMBER(30) NOT NULL,
    data_agendada         DATE NOT NULL,
    horario_agendado      DATE NOT NULL,
    status_tratamento     VARCHAR2(20) NOT NULL,
    descricao_agendamento VARCHAR2(300),
    id_dentista           NUMBER(30) NOT NULL,
    id_usuario            NUMBER(30) NOT NULL
)
LOGGING;

ALTER TABLE c_op_agendamento ADD CONSTRAINT c_op_agendamento_pk PRIMARY KEY ( id_agendamento );

------------------------------------------------------------------------------------------------------
CREATE TABLE c_op_notificacao (
    id_notificacao   NUMBER(30) NOT NULL,
    mensagem         VARCHAR2(350) NOT NULL,
    tipo_notificacao VARCHAR2(200) NOT NULL,
    data_envio       DATE,
    leitura          CHAR(1)
)
LOGGING;

ALTER TABLE c_op_notificacao ADD CONSTRAINT c_op_notificacao_pk PRIMARY KEY ( id_notificacao );


------------------------------------------------------------------------------------------------------
CREATE TABLE c_op_tratamento (
    id_tratamento         NUMBER(30) NOT NULL,
    tipo_tratamento       VARCHAR2(200) NOT NULL,
    dt_inicio_tratamento  DATE NOT NULL,
    dt_termino_tratamento DATE NOT NULL,
    descricao_tratamento  VARCHAR2(300),
    status_tratamento     VARCHAR2(20) NOT NULL,
    id_dentista           NUMBER(30) NOT NULL,
    id_usuario            NUMBER(30) NOT NULL
)
LOGGING;

ALTER TABLE c_op_tratamento ADD CONSTRAINT c_op_tratamento_pk PRIMARY KEY ( id_tratamento );

------------------------------------------------------------------------------------------------------

CREATE TABLE c_op_checklist (
    id_checklist     NUMBER(30) NOT NULL,
    nivel            NUMBER(38),
    escovacao_dentes NUMBER(38),
    fio_dental       NUMBER(38),
    enxaguante_bucal NUMBER(38),
    id_usuario       NUMBER(30) NOT NULL
)
LOGGING;

CREATE UNIQUE INDEX c_op_checklist__idx ON
    c_op_checklist (
        id_usuario
    ASC );

ALTER TABLE c_op_checklist ADD CONSTRAINT c_op_checklist_pk PRIMARY KEY ( id_checklist );

------------------------------------------------------------------------------------------------------

ALTER TABLE c_op_agendamento
    ADD CONSTRAINT agendamento_dentista_fk FOREIGN KEY ( id_dentista )
        REFERENCES c_op_dentista ( id_dentista )
    NOT DEFERRABLE;

 
ALTER TABLE c_op_agendamento
    ADD CONSTRAINT agendamento_usuario_fk FOREIGN KEY ( id_usuario )
        REFERENCES c_op_usuario ( id_usuario )
    NOT DEFERRABLE;

ALTER TABLE c_op_checklist
    ADD CONSTRAINT checklist_usuario_fk FOREIGN KEY ( id_usuario )
        REFERENCES c_op_usuario ( id_usuario )
    NOT DEFERRABLE;


ALTER TABLE c_op_tratamento
    ADD CONSTRAINT tratamento_dentista_fk FOREIGN KEY ( id_dentista )
        REFERENCES c_op_dentista ( id_dentista )
    NOT DEFERRABLE;


ALTER TABLE c_op_tratamento
    ADD CONSTRAINT tratamento_usuario_fk FOREIGN KEY ( id_usuario )
        REFERENCES c_op_usuario ( id_usuario )
    NOT DEFERRABLE;

ALTER TABLE c_op_usuario
    ADD CONSTRAINT usuario_dentista_fk FOREIGN KEY ( id_dentista )
        REFERENCES c_op_dentista ( id_dentista )
    NOT DEFERRABLE;

 
ALTER TABLE c_op_usuario
    ADD CONSTRAINT usuario_notificacao_fk FOREIGN KEY ( id_notificacao )
        REFERENCES c_op_notificacao ( id_notificacao )
    NOT DEFERRABLE;


ALTER TABLE c_op_usuario
    ADD CONSTRAINT usuario_plano_de_saude_fk FOREIGN KEY ( id_plano )
        REFERENCES c_op_plano_de_saude ( id_plano )
    NOT DEFERRABLE;

ALTER TABLE c_op_dentista_planosaude
    ADD CONSTRAINT dentista_planosaude_fk FOREIGN KEY ( id_dentista )
        REFERENCES c_op_dentista ( id_dentista )
    NOT DEFERRABLE;


ALTER TABLE c_op_dentista_planosaude
    ADD CONSTRAINT planosaude_dentista_fk FOREIGN KEY ( id_plano )
        REFERENCES c_op_plano_de_saude ( id_plano )
    NOT DEFERRABLE;

------------------------------------------------------------------------------------------------------

