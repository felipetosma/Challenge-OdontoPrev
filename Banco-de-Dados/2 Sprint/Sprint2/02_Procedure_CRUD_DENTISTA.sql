CREATE OR REPLACE PROCEDURE CRUD_DENTISTA(
    v_operacao          IN VARCHAR2,
    v_id_dentista       IN c_op_dentista.id_dentista%TYPE,
    v_nome_dentista     IN c_op_dentista.nome_dentista%TYPE,
    v_senha_dentista    IN c_op_dentista.senha_dentista%TYPE,
    v_cro               IN c_op_dentista.cro%TYPE,
    v_telefone_dentista IN c_op_dentista.telefone_dentista%TYPE,
    v_email_dentista    IN c_op_dentista.email_dentista%TYPE,
    v_id_especialidade  IN c_op_dentista.id_especialidade%TYPE
) IS
    v_erro_cro VARCHAR2(400);
    v_mensagem VARCHAR2(255);

-- Variáveis para o SELECT
    v_result_nome         c_op_dentista.nome_dentista%TYPE;
    v_result_senha        c_op_dentista.senha_dentista%TYPE;
    v_result_cro          c_op_dentista.cro%TYPE;
    v_result_telefone     c_op_dentista.telefone_dentista%TYPE;
    v_result_email        c_op_dentista.email_dentista%TYPE;
    v_result_especialidade c_op_dentista.id_especialidade%TYPE;

BEGIN
-- Validação do CRO para INSERT e UPDATE
    IF v_operacao = 'INSERT' OR v_operacao = 'UPDATE' THEN
        v_erro_cro := validar_formato_cro(v_cro);

        IF v_erro_cro IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20003, v_erro_cro);
        END IF;
    END IF;

    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_dentista (
            id_dentista,
            nome_dentista,
            senha_dentista,
            cro,
            telefone_dentista,
            email_dentista,
            id_especialidade
        ) VALUES (
            v_id_dentista,
            v_nome_dentista,
            v_senha_dentista,
            v_cro,
            v_telefone_dentista,
            v_email_dentista,
            v_id_especialidade
        );
        v_mensagem := 'Dentista inserido com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_dentista
        SET nome_dentista = v_nome_dentista,
            senha_dentista = v_senha_dentista,
            cro = v_cro,
            telefone_dentista = v_telefone_dentista,
            email_dentista = v_email_dentista,
            id_especialidade = v_id_especialidade
        WHERE id_dentista = v_id_dentista;
        v_mensagem := 'Dentista atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_dentista
        WHERE id_dentista = v_id_dentista;
        v_mensagem := 'Dentista deletado com sucesso.';

    ELSIF v_operacao = 'SELECT' THEN
    
        BEGIN
            SELECT nome_dentista, senha_dentista, cro, telefone_dentista, email_dentista, id_especialidade
            INTO v_result_nome, v_result_senha, v_result_cro, v_result_telefone, v_result_email, v_result_especialidade
            FROM c_op_dentista
            WHERE id_dentista = v_id_dentista;

            DBMS_OUTPUT.PUT_LINE('Nome: ' || v_result_nome);
            DBMS_OUTPUT.PUT_LINE('Senha: ' || v_result_senha);
            DBMS_OUTPUT.PUT_LINE('CRO: ' || v_result_cro);
            DBMS_OUTPUT.PUT_LINE('Telefone: ' || v_result_telefone);
            DBMS_OUTPUT.PUT_LINE('Email: ' || v_result_email);
            DBMS_OUTPUT.PUT_LINE('Especialidade ID: ' || v_result_especialidade);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Dentista não encontrado com o ID especificado.');
        END;

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
    END IF;

    IF v_operacao != 'SELECT' THEN
        DBMS_OUTPUT.PUT_LINE(v_mensagem);
        COMMIT;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
        ROLLBACK;
END CRUD_DENTISTA;

select * from c_op_dentista;