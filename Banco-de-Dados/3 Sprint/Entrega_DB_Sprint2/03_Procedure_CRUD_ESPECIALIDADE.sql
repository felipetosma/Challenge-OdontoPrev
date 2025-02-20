-- CRUD tabela C_OP_ESPECIALIDADE

CREATE OR REPLACE PROCEDURE CRUD_ESPECIALIDADE (
    v_operacao           IN VARCHAR2,
    v_id_especialidade   IN c_op_especialidade.id_especialidade%TYPE,
    v_tipo_especialidade IN c_op_especialidade.tipo_especialidade%TYPE,
    v_descr_especialidade IN c_op_especialidade.descr_especialidade%TYPE
) IS
    v_mensagem VARCHAR2(255);
    -- Variáveis para SELECT
    v_result_tipo      c_op_especialidade.tipo_especialidade%TYPE;
    v_result_descr     c_op_especialidade.descr_especialidade%TYPE;
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_especialidade (
            id_especialidade,
            tipo_especialidade,
            descr_especialidade
        ) VALUES (
            v_id_especialidade,
            v_tipo_especialidade,
            v_descr_especialidade
        );
        v_mensagem := 'Especialidade inserida com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_especialidade
        SET tipo_especialidade = v_tipo_especialidade,
            descr_especialidade = v_descr_especialidade
        WHERE id_especialidade = v_id_especialidade;
        v_mensagem := 'Especialidade atualizada com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_especialidade
        WHERE id_especialidade = v_id_especialidade;
        v_mensagem := 'Especialidade deletada com sucesso.';

    ELSIF v_operacao = 'SELECT' THEN
        BEGIN
            SELECT tipo_especialidade, descr_especialidade
            INTO v_result_tipo, v_result_descr
            FROM c_op_especialidade
            WHERE id_especialidade = v_id_especialidade;

            DBMS_OUTPUT.PUT_LINE('Tipo: ' || v_result_tipo);
            DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_result_descr);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Especialidade não encontrada com o ID especificado.');
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
END CRUD_ESPECIALIDADE;





