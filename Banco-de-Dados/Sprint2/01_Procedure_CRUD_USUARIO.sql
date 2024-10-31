--  Procedures para Operações CRUD

-- CRUD tabela C_OP_USUARIO
CREATE OR REPLACE PROCEDURE CRUD_USUARIO (
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
BEGIN
-- Validação de senha usando a função de validação
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

-- Inserts
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

-- Updates
    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_usuario
        SET nome_usuario     = v_nome_usuario,
            senha_usuario    = v_senha_usuario,
            email_usuario    = v_email_usuario,
            nr_carteira      = v_nr_carteira,
            telefone_usuario = v_telefone_usuario
        WHERE id_usuario = v_id_usuario;
        v_mensagem := 'Usuário atualizado com sucesso.';

-- Deletes
    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_usuario
        WHERE id_usuario = v_id_usuario;
        v_mensagem := 'Usuário deletado com sucesso.';

-- Tratamento de operação inválida
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE ou DELETE.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem);
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_USUARIO;


BEGIN
    CRUD_USUARIO(
        v_operacao         => 'INSERT',
        v_id_usuario       => 666,
        v_nome_usuario     => 'Felipe Amador',
        v_senha_usuario    => 'SenhaSegura4545',
        v_email_usuario    => 'rapha.amador@email.com',
        v_nr_carteira      => '12548844',
        v_telefone_usuario => 11994151589
    );
END;


