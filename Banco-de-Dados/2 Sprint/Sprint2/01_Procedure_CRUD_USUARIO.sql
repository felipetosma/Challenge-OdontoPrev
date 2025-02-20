CREATE OR REPLACE PROCEDURE CRUD_USUARIO(
    v_operacao         IN VARCHAR2,
    v_id_usuario       IN c_op_usuario.id_usuario%TYPE,
    v_nome_usuario     IN c_op_usuario.nome_usuario%TYPE,
    v_senha_usuario    IN c_op_usuario.senha_usuario%TYPE,
    v_email_usuario    IN c_op_usuario.email_usuario%TYPE,
    v_nr_carteira      IN c_op_usuario.nr_carteira%TYPE,
    v_telefone_usuario IN c_op_usuario.telefone_usuario%TYPE
) IS
    v_mensagem VARCHAR2(255);
    v_erro_senha VARCHAR2(200);
-- Variáveis para o SELECT
    v_result_nome       c_op_usuario.nome_usuario%TYPE;
    v_result_senha      c_op_usuario.senha_usuario%TYPE;
    v_result_email      c_op_usuario.email_usuario%TYPE;
    v_result_carteira   c_op_usuario.nr_carteira%TYPE;
    v_result_telefone   c_op_usuario.telefone_usuario%TYPE;

BEGIN
-- Validação da senha para INSERT e UPDATE
    IF v_operacao = 'INSERT' OR v_operacao = 'UPDATE' THEN
        v_erro_senha := validar_senha_usuario(
            p_id_usuario       => v_id_usuario,
            p_nome_usuario     => v_nome_usuario,
            p_senha_usuario    => v_senha_usuario,
            p_email_usuario    => v_email_usuario,
            p_nr_carteira      => v_nr_carteira,
            p_telefone_usuario => v_telefone_usuario
        );

        IF v_erro_senha IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20003, v_erro_senha);
        END IF;
    END IF;

    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_usuario (
            id_usuario,
            nome_usuario,
            senha_usuario,
            email_usuario,
            nr_carteira,
            telefone_usuario
        ) VALUES (
            v_id_usuario,
            v_nome_usuario,
            v_senha_usuario,
            v_email_usuario,
            v_nr_carteira,
            v_telefone_usuario
        );
        v_mensagem := 'Usuário inserido com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_usuario
        SET nome_usuario     = v_nome_usuario,
            senha_usuario    = v_senha_usuario,
            email_usuario    = v_email_usuario,
            nr_carteira      = v_nr_carteira,
            telefone_usuario = v_telefone_usuario
        WHERE id_usuario = v_id_usuario;
        v_mensagem := 'Usuário atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_usuario
        WHERE id_usuario = v_id_usuario;
        v_mensagem := 'Usuário deletado com sucesso.';

    ELSIF v_operacao = 'SELECT' THEN
        BEGIN
            SELECT nome_usuario, senha_usuario, email_usuario, nr_carteira, telefone_usuario
            INTO v_result_nome, v_result_senha, v_result_email, v_result_carteira, v_result_telefone
            FROM c_op_usuario
            WHERE id_usuario = v_id_usuario;

            DBMS_OUTPUT.PUT_LINE('Nome: ' || v_result_nome);
            DBMS_OUTPUT.PUT_LINE('Senha: ' || v_result_senha);
            DBMS_OUTPUT.PUT_LINE('Email: ' || v_result_email);
            DBMS_OUTPUT.PUT_LINE('Carteira: ' || v_result_carteira);
            DBMS_OUTPUT.PUT_LINE('Telefone: ' || v_result_telefone);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Usuário não encontrado com o ID especificado.');
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
END CRUD_USUARIO;
