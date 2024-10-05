-----------------------------------------------------------------------------------------------------------------------------------------------
-- CRIAÇÃO DE TABELAS SQL
----------------------------------------------------------------------------------------------------------------------------------------------

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

COMMIT;
----------------------------------------------------------------------------------------------------------------------------------------------
-- BLOCOS ANÔNIMOS PL/SQL
----------------------------------------------------------------------------------------------------------------------------------------------


SET SERVEROUTPUT ON;

------------------------------------------------------------------------------------------------------------------------------------------
-- 1- Seleciona o nome do usuário com mais tratamentos e o total de tratamentos, exibindo o resultado com DBMS_OUTPUT.PUT_LINE.

DECLARE
    nomeusuario      VARCHAR2(100);
    totaltratamentos NUMBER;
BEGIN
    SELECT
        u.nome_usuario,
        COUNT(t.id_tratamento)
    INTO
        nomeusuario,
        totaltratamentos
    FROM
        c_op_usuario    u
        LEFT JOIN c_op_tratamento t ON u.id_usuario = t.id_usuario
    GROUP BY
        u.nome_usuario
    ORDER BY
        COUNT(t.id_tratamento) DESC
    FETCH FIRST 1 ROW ONLY;

    dbms_output.put_line('Usuário com mais tratamentos: '
                         || nomeusuario
                         || ' | Total: '
                         || totaltratamentos);
END;
------------------------------------------------------------------------------------------------------------------------------------------

-- 2- Seleciona o dentista com mais tratamentos e exibe o nome do dentista junto com o total de tratamentos.

DECLARE
    v_nome_dentista     VARCHAR2(100);
    v_total_tratamentos NUMBER;
BEGIN
    SELECT
        d.nome_dentista,
        COUNT(t.id_tratamento)
    INTO
        v_nome_dentista,
        v_total_tratamentos
    FROM
        c_op_tratamento t
        RIGHT JOIN c_op_dentista   d ON t.id_dentista = d.id_dentista
    GROUP BY
        d.nome_dentista
    ORDER BY
        COUNT(t.id_tratamento) DESC
    FETCH FIRST 1 ROW ONLY;

    dbms_output.put_line('Dentista com mais tratamentos: '
                         || v_nome_dentista
                         || ' | Total: '
                         || v_total_tratamentos);
END;

------------------------------------------------------------------------------------------------------------------------------------------

-- 3- Usa um loop FOR para exibir o nome de cada dentista e o número de tratamentos associados, iterando sobre os resultados da consulta.

DECLARE BEGIN
    FOR rec IN (
        SELECT
            d.nome_dentista,
            COUNT(t.id_tratamento) AS qtd_tratamentos
        FROM
                 c_op_dentista d
            INNER JOIN c_op_tratamento t ON d.id_dentista = t.id_dentista
        GROUP BY
            d.nome_dentista
        ORDER BY
            d.nome_dentista
    ) LOOP
        dbms_output.put_line('Dentista: '
                             || rec.nome_dentista
                             || ' | Tratamentos: '
                             || rec.qtd_tratamentos);
    END LOOP;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Nenhum dentista encontrado.');
END;

COMMIT;

----------------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE E DELETE
----------------------------------------------------------------------------------------------------------------------------------------------


-- 1- Realiza um UPDATE na tabela c_op_usuario, alterando o nome de um usuário com base no valor de id_usuario. 
-- Uma estrutura de decisão é usada para verificar se o usuário existe antes de realizar a atualização.

DECLARE
    num_id_usuario NUMBER(30) := &digiteoiddousuario;
    novo_nome      VARCHAR2(100) := '&DIGITEONOVONOME';
    contador       NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO contador
    FROM
        c_op_usuario
    WHERE
        id_usuario = num_id_usuario;

    IF contador > 0 THEN
        UPDATE c_op_usuario
        SET
            nome_usuario = novo_nome
        WHERE
            id_usuario = num_id_usuario;

        dbms_output.put_line('Usuário de ID '
                             || num_id_usuario
                             || ' foi atualizado para '
                             || novo_nome);
    ELSE
        dbms_output.put_line('Usuário com ID '
                             || num_id_usuario
                             || ' não encontadorrado.');
    END IF;

END;
----------------------------------------------------------------------------------------------------------------------------------------------

-- 2- Realiza a exclusão de um registro na tabela c_op_checklist com base no id_usuario fornecido por um input.

DECLARE
    v_id_usuario NUMBER(30) := &digiteoiddousuario;
    v_contador   NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_contador
    FROM
        c_op_checklist
    WHERE
        id_usuario = v_id_usuario;

    IF v_contador > 0 THEN
        DELETE FROM c_op_checklist
        WHERE
            id_usuario = v_id_usuario;

        dbms_output.put_line('Checklists do usuário de ID '
                             || v_id_usuario
                             || ' foram excluídos com sucesso.');
    ELSE
        dbms_output.put_line('Nenhum checklist encontrado para o usuário com ID '
                             || v_id_usuario
                             || '.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Ocorreu um erro durante a exclusão: ' || sqlerrm);
END;

COMMIT;