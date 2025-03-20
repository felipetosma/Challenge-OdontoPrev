SET SERVEROUTPUT ON

CREATE TABLE c_op_auditoria (
    id_auditoria       NUMBER(30) PRIMARY KEY,
    nome_tabela        VARCHAR2(30) NOT NULL,
    operacao           VARCHAR2(10) NOT NULL,
    id_registro        NUMBER(30) NOT NULL,
    usuario_db         VARCHAR2(30) NOT NULL,
    data_operacao      TIMESTAMP NOT NULL,
    detalhes_antigos   CLOB,
    detalhes_novos     CLOB
);

CREATE SEQUENCE seq_auditoria
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE PROCEDURE registra_auditoria (
    p_nome_tabela      IN VARCHAR2,
    p_operacao         IN VARCHAR2,
    p_id_registro      IN NUMBER,
    p_detalhes_antigos IN CLOB DEFAULT NULL,
    p_detalhes_novos   IN CLOB DEFAULT NULL
) AS
BEGIN
    INSERT INTO c_op_auditoria (
        id_auditoria,
        nome_tabela,
        operacao,
        id_registro,
        usuario_db,
        data_operacao,
        detalhes_antigos,
        detalhes_novos
    ) VALUES (
        seq_auditoria.NEXTVAL,
        p_nome_tabela,
        p_operacao,
        p_id_registro,
        USER,
        SYSTIMESTAMP,
        p_detalhes_antigos,
        p_detalhes_novos
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao registrar auditoria: ' || SQLERRM);
        ROLLBACK;
END;
/

CREATE OR REPLACE FUNCTION registro_para_json (
    p_tipo IN VARCHAR2,
    p_id IN NUMBER,
    p_nome IN VARCHAR2,
    p_email IN VARCHAR2 DEFAULT NULL,
    p_outros IN VARCHAR2 DEFAULT NULL
) RETURN CLOB AS
    v_json CLOB;
BEGIN
    v_json := '{' ||
              '"id":"' || p_id || '",' ||
              '"nome":"' || p_nome || '",' ||
              '"email":"' || NVL(p_email, '') || '",' ||
              '"outros":"' || NVL(p_outros, '') || '"' ||
              '}';
    RETURN v_json;
END;
/


-- TRIGGER PARA A TABELA DE USU�RIO
CREATE OR REPLACE TRIGGER trg_auditoria_usuario
AFTER INSERT OR UPDATE OR DELETE ON c_op_usuario
FOR EACH ROW
DECLARE
    v_old_dados CLOB;
    v_new_dados CLOB;
BEGIN
    CASE
        WHEN INSERTING THEN
            v_new_dados := registro_para_json('USUARIO', :NEW.id_usuario, :NEW.nome_usuario, 
                                              :NEW.email_usuario, 'NrCarteira: ' || :NEW.nr_carteira);
            registra_auditoria('C_OP_USUARIO', 'INSERT', :NEW.id_usuario, NULL, v_new_dados);
            
        WHEN UPDATING THEN
            v_old_dados := registro_para_json('USUARIO', :OLD.id_usuario, :OLD.nome_usuario, 
                                              :OLD.email_usuario, 'NrCarteira: ' || :OLD.nr_carteira);
            v_new_dados := registro_para_json('USUARIO', :NEW.id_usuario, :NEW.nome_usuario, 
                                              :NEW.email_usuario, 'NrCarteira: ' || :NEW.nr_carteira);
            registra_auditoria('C_OP_USUARIO', 'UPDATE', :OLD.id_usuario, v_old_dados, v_new_dados);
            
        WHEN DELETING THEN
            v_old_dados := registro_para_json('USUARIO', :OLD.id_usuario, :OLD.nome_usuario, 
                                              :OLD.email_usuario, 'NrCarteira: ' || :OLD.nr_carteira);
            registra_auditoria('C_OP_USUARIO', 'DELETE', :OLD.id_usuario, v_old_dados, NULL);
    END CASE;
END;
/

-- TRIGGER PARA A TABELA DE DENTISTA
CREATE OR REPLACE TRIGGER trg_auditoria_dentista
AFTER INSERT OR UPDATE OR DELETE ON c_op_dentista
FOR EACH ROW
DECLARE
    v_old_dados CLOB;
    v_new_dados CLOB;
BEGIN
    CASE
        WHEN INSERTING THEN
            v_new_dados := registro_para_json('DENTISTA', :NEW.id_dentista, :NEW.nome_dentista, 
                                              :NEW.email_dentista, 'CRO: ' || :NEW.cro);
            registra_auditoria('C_OP_DENTISTA', 'INSERT', :NEW.id_dentista, NULL, v_new_dados);
            
        WHEN UPDATING THEN
            v_old_dados := registro_para_json('DENTISTA', :OLD.id_dentista, :OLD.nome_dentista, 
                                              :OLD.email_dentista, 'CRO: ' || :OLD.cro);
            v_new_dados := registro_para_json('DENTISTA', :NEW.id_dentista, :NEW.nome_dentista, 
                                              :NEW.email_dentista, 'CRO: ' || :NEW.cro);
            registra_auditoria('C_OP_DENTISTA', 'UPDATE', :OLD.id_dentista, v_old_dados, v_new_dados);
            
        WHEN DELETING THEN
            v_old_dados := registro_para_json('DENTISTA', :OLD.id_dentista, :OLD.nome_dentista, 
                                              :OLD.email_dentista, 'CRO: ' || :OLD.cro);
            registra_auditoria('C_OP_DENTISTA', 'DELETE', :OLD.id_dentista, v_old_dados, NULL);
    END CASE;
END;
/

-- TRIGGER PARA A TABELA DE TRATAMENTO
CREATE OR REPLACE TRIGGER trg_auditoria_tratamento
AFTER INSERT OR UPDATE OR DELETE ON c_op_tratamento
FOR EACH ROW
DECLARE
    v_old_dados CLOB;
    v_new_dados CLOB;
    v_old_details VARCHAR2(500);
    v_new_details VARCHAR2(500);
BEGIN
    IF INSERTING OR UPDATING THEN
        v_new_details := 'Tipo: ' || :NEW.tipo_tratamento || 
                         ', In�cio: ' || TO_CHAR(:NEW.dt_inicio_tratamento, 'DD/MM/YYYY') || 
                         ', Dentista: ' || :NEW.id_dentista || 
                         ', Usu�rio: ' || :NEW.id_usuario;
    END IF;
    
    IF UPDATING OR DELETING THEN
        v_old_details := 'Tipo: ' || :OLD.tipo_tratamento || 
                         ', In�cio: ' || TO_CHAR(:OLD.dt_inicio_tratamento, 'DD/MM/YYYY') || 
                         ', Dentista: ' || :OLD.id_dentista || 
                         ', Usu�rio: ' || :OLD.id_usuario;
    END IF;
    
    CASE
        WHEN INSERTING THEN
            v_new_dados := registro_para_json('TRATAMENTO', :NEW.id_tratamento, :NEW.tipo_tratamento, 
                                              NULL, v_new_details);
            registra_auditoria('C_OP_TRATAMENTO', 'INSERT', :NEW.id_tratamento, NULL, v_new_dados);
            
        WHEN UPDATING THEN
            v_old_dados := registro_para_json('TRATAMENTO', :OLD.id_tratamento, :OLD.tipo_tratamento, 
                                              NULL, v_old_details);
            v_new_dados := registro_para_json('TRATAMENTO', :NEW.id_tratamento, :NEW.tipo_tratamento, 
                                              NULL, v_new_details);
            registra_auditoria('C_OP_TRATAMENTO', 'UPDATE', :OLD.id_tratamento, v_old_dados, v_new_dados);
            
        WHEN DELETING THEN
            v_old_dados := registro_para_json('TRATAMENTO', :OLD.id_tratamento, :OLD.tipo_tratamento, 
                                              NULL, v_old_details);
            registra_auditoria('C_OP_TRATAMENTO', 'DELETE', :OLD.id_tratamento, v_old_dados, NULL);
    END CASE;
END;
/

-- TESTE DAS TRIGGERS:
----------------------------------------------------------------------------------------------------------------------

INSERT INTO c_op_usuario (id_usuario, nome_usuario, senha_usuario, email_usuario, nr_carteira, telefone_usuario)
VALUES (65, 'Jota Santos', 'senha5548', 'joao.silva@email.com', '98653-CNEN', 1199998888);

UPDATE c_op_usuario
SET nome_usuario = 'Jota Santos da Silva',  -- Atualizando o nome para incluir sobrenome completo
    senha_usuario = 'SenhaSegura2025!',     -- Atualizando para uma senha mais segura
    email_usuario = 'jota.santos@outlook.com',  -- Mudando o email para outro provedor
    telefone_usuario = 11987654321          -- Atualizando o n�mero de telefone
WHERE id_usuario = 65;

----------------------------------------------------------------------------------------------------------------------

INSERT INTO c_op_dentista (id_dentista, nome_dentista, senha_dentista, cro, telefone_dentista, email_dentista, id_especialidade)
VALUES (31, 'Dr. Carlos Ferreira', 'senha789', '85632SP', 1155554444, 'carlos.ferreira@clinica.com', 2);

UPDATE c_op_dentista
SET nome_dentista = 'Dr. Carlos Ferreira Mendes',  -- Atualizando nome completo
    cro = '85452SP',                           -- Atualizando CRO com especialidade
    telefone_dentista = 11991234567,              -- Atualizando para n�mero celular
    email_dentista = 'dr.carlos@clinicadental.com.br',  -- Atualizando email profissional
    id_especialidade = 3                          -- Mudando especialidade
WHERE id_dentista = 31;

----------------------------------------------------------------------------------------------------------------------

INSERT INTO c_op_tratamento (id_tratamento, tipo_tratamento, dt_inicio_tratamento, dt_termino_tratamento, 
                            descr_tratamento, id_dentista, id_usuario, id_notificacao, id_status, id_plano)
VALUES (31, 'Canal', TO_DATE('2025-03-01', 'YYYY-MM-DD'), NULL, 
        'Tratamento de canal no dente 26', 31, 65, 11, 1, 1);

UPDATE c_op_tratamento
SET dt_termino_tratamento = TO_DATE('2025-03-20', 'YYYY-MM-DD'),  -- Definindo data de t�rmino
    descr_tratamento = 'Tratamento de canal no dente 26 conclu�do com sucesso. Paciente relatou melhora significativa.',  -- Detalhando descri��o
    id_status = 2  -- Alterando status (assumindo que 2 seja "Conclu�do")
WHERE id_tratamento = 31;

----------------------------------------------------------------------------------------------------------------------
        
SELECT
    id_auditoria,
    nome_tabela,
    operacao,
    id_registro,
    usuario_db,
    TO_CHAR(data_operacao, 'DD/MM/YYYY HH24:MI:SS.FF') as data_hora,
    detalhes_antigos,
    detalhes_novos
FROM c_op_auditoria
ORDER BY data_operacao DESC;
