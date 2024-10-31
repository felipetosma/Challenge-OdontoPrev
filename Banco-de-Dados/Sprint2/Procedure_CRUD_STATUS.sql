-- CRUD tabela C_OP_STATUS

CREATE OR REPLACE PROCEDURE CRUD_STATUS (
    v_operacao      IN VARCHAR2,
    v_id_status     IN c_op_status.id_status%TYPE,
    v_tipo_status   IN c_op_status.tipo_status%TYPE,
    v_descr_status  IN c_op_status.descr_status%TYPE
) IS
    v_mensagem VARCHAR2(255);
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

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE ou DELETE.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem);
    COMMIT; -- Confirma as mudanças

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_STATUS;


BEGIN
    CRUD_STATUS(
        v_operacao      => 'INSERT',   
        v_id_status     => 11,                     
        v_tipo_status   => 'Aguardando confirmação do denttista',    
        v_descr_status  => 'O status está ativo.'   
    );
END;

