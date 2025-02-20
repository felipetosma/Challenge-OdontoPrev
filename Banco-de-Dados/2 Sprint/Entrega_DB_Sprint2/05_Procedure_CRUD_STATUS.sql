CREATE OR REPLACE PROCEDURE CRUD_STATUS (
    v_operacao      IN VARCHAR2,
    v_id_status     IN c_op_status.id_status%TYPE,
    v_tipo_status   IN c_op_status.tipo_status%TYPE,
    v_descr_status  IN c_op_status.descr_status%TYPE
) IS
    v_mensagem VARCHAR2(255);
    -- Variáveis para SELECT
    v_result_tipo     c_op_status.tipo_status%TYPE;
    v_result_descr    c_op_status.descr_status%TYPE;
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_status (
            id_status,
            tipo_status,
            descr_status
        ) VALUES (
            v_id_status,
            v_tipo_status,
            v_descr_status
        );
        v_mensagem := 'Status inserido com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_status
        SET tipo_status = v_tipo_status,
            descr_status = v_descr_status
        WHERE id_status = v_id_status;
        v_mensagem := 'Registro atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_status
        WHERE id_status = v_id_status;
        v_mensagem := 'Registro deletado com sucesso.';

    ELSIF v_operacao = 'SELECT' THEN
        BEGIN
            SELECT tipo_status, descr_status
            INTO v_result_tipo, v_result_descr
            FROM c_op_status
            WHERE id_status = v_id_status;

            DBMS_OUTPUT.PUT_LINE('Tipo: ' || v_result_tipo);
            DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_result_descr);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Status não encontrado com o ID especificado.');
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
END CRUD_STATUS;



BEGIN
    CRUD_STATUS(
        v_operacao      => 'INSERT',
        v_id_status     => 11,               -- Exemplo de ID para o status
        v_tipo_status   => 'Aguardando confirmação',         -- Exemplo de tipo de status
        v_descr_status  => 'Esperando a confirmação do dentista ou clinica'   -- Exemplo de descrição do status
    );
END;

