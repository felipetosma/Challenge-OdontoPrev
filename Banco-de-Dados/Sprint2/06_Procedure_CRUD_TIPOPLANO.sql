--Set SERVEROUTPUT on;

CREATE OR REPLACE PROCEDURE CRUD_TIPO_PLANO (
    v_operacao       IN VARCHAR2,
    v_id_tipo_plano  IN c_op_tipo_plano.id_tipo_plano%TYPE,
    v_nome_tipo_plano IN c_op_tipo_plano.nome_tipo_plano%TYPE,
    v_descr_tipo_plano IN c_op_tipo_plano.descr_tipo_plano%TYPE
) IS
    v_mensagem VARCHAR2(255);
    -- Variáveis para SELECT
    v_result_nome    c_op_tipo_plano.nome_tipo_plano%TYPE;
    v_result_descr   c_op_tipo_plano.descr_tipo_plano%TYPE;
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_tipo_plano (
            id_tipo_plano,
            nome_tipo_plano,
            descr_tipo_plano
        ) VALUES (
            v_id_tipo_plano,
            v_nome_tipo_plano,
            v_descr_tipo_plano
        );
        v_mensagem := 'Tipo de plano inserido com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_tipo_plano
        SET nome_tipo_plano = v_nome_tipo_plano,
            descr_tipo_plano = v_descr_tipo_plano
        WHERE id_tipo_plano = v_id_tipo_plano;
        v_mensagem := 'Registro atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_tipo_plano
        WHERE id_tipo_plano = v_id_tipo_plano;
        v_mensagem := 'Registro deletado com sucesso.';

    ELSIF v_operacao = 'SELECT' THEN
        BEGIN
            SELECT nome_tipo_plano, descr_tipo_plano
            INTO v_result_nome, v_result_descr
            FROM c_op_tipo_plano
            WHERE id_tipo_plano = v_id_tipo_plano;

            DBMS_OUTPUT.PUT_LINE('Nome: ' || v_result_nome);
            DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_result_descr);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Tipo de plano não encontrado com o ID especificado.');
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
END CRUD_TIPO_PLANO;






