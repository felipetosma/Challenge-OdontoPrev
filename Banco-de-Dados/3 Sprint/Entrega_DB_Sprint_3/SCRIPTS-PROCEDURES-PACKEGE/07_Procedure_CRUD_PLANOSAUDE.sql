set SERVEROUTPUT on;

CREATE OR REPLACE PROCEDURE CRUD_PLANO_SAUDE (
    v_operacao        IN VARCHAR2,
    v_id_plano        IN c_op_plano_de_saude.id_plano%TYPE DEFAULT NULL,
    v_nome_plano      IN c_op_plano_de_saude.nome_plano%TYPE DEFAULT NULL,
    v_telefone_plano   IN c_op_plano_de_saude.telefone_plano%TYPE DEFAULT NULL,
    v_email_plano     IN c_op_plano_de_saude.email_plano%TYPE DEFAULT NULL,
    v_id_tipo_plano   IN c_op_plano_de_saude.id_tipo_plano%TYPE DEFAULT NULL
) IS
    v_mensagem VARCHAR2(255);
    v_nome c_op_plano_de_saude.nome_plano%TYPE;
    v_telefone c_op_plano_de_saude.telefone_plano%TYPE;
    v_email c_op_plano_de_saude.email_plano%TYPE;
    v_tipo_plano c_op_plano_de_saude.id_tipo_plano%TYPE;
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_plano_de_saude (
            id_plano,
            nome_plano,
            telefone_plano,
            email_plano,
            id_tipo_plano
        ) VALUES (
            v_id_plano,
            v_nome_plano,
            v_telefone_plano,
            v_email_plano,
            v_id_tipo_plano
        );
        v_mensagem := 'Plano de saúde inserido com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_plano_de_saude
        SET nome_plano = v_nome_plano,
            telefone_plano = v_telefone_plano,
            email_plano = v_email_plano,
            id_tipo_plano = v_id_tipo_plano
        WHERE id_plano = v_id_plano;
        v_mensagem := 'Plano de saúde atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_plano_de_saude
        WHERE id_plano = v_id_plano;
        v_mensagem := 'Plano de saúde deletado com sucesso.';

    ELSIF v_operacao = 'SELECT' THEN
        SELECT nome_plano, telefone_plano, email_plano, id_tipo_plano
        INTO v_nome, v_telefone, v_email, v_tipo_plano
        FROM c_op_plano_de_saude
        WHERE id_plano = v_id_plano;

        DBMS_OUTPUT.PUT_LINE('Plano de saúde encontrado:');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_plano);
        DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome);
        DBMS_OUTPUT.PUT_LINE('Telefone: ' || v_telefone);
        DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
        DBMS_OUTPUT.PUT_LINE('Tipo de Plano ID: ' || v_tipo_plano);
        RETURN;

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem);
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum plano de saúde encontrado com o ID: ' || v_id_plano);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_PLANO_SAUDE;




BEGIN
    CRUD_PLANO_SAUDE(
        v_operacao => 'SELECT',
        v_id_plano => 10
    );
END;

BEGIN
    CRUD_PLANO_SAUDE(
        v_operacao => 'DELETE',
        v_id_plano => 10
    );
END;

