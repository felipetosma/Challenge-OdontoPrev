-- CRUD tabela C_OP_CHECKLIST

CREATE OR REPLACE PROCEDURE CRUD_CHECKLIST (
    v_operacao        IN VARCHAR2,
    v_id_checklist    IN c_op_checklist.id_checklist%TYPE,
    v_nivel           IN c_op_checklist.nivel%TYPE,
    v_escovacao_dentes IN c_op_checklist.escovacao_dentes%TYPE,
    v_fio_dental      IN c_op_checklist.fio_dental%TYPE,
    v_enxaguante_bucal IN c_op_checklist.enxaguante_bucal%TYPE,
    v_id_usuario      IN c_op_usuario.id_usuario%TYPE
) IS
    v_mensagem VARCHAR2(255);
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_checklist (
            id_checklist,
            nivel,
            escovacao_dentes,
            fio_dental,
            enxaguante_bucal,
            id_usuario
        ) VALUES (
            v_id_checklist,
            v_nivel,
            v_escovacao_dentes,
            v_fio_dental,
            v_enxaguante_bucal,
            v_id_usuario
        );
        v_mensagem := 'Checklist inserido com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_checklist
        SET nivel = v_nivel,
            escovacao_dentes = v_escovacao_dentes,
            fio_dental = v_fio_dental,
            enxaguante_bucal = v_enxaguante_bucal
        WHERE id_checklist = v_id_checklist;
        v_mensagem := 'Registro atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_checklist
        WHERE id_checklist = v_id_checklist;
        v_mensagem := 'Registro deletado com sucesso.';

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE ou DELETE.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem);
    COMMIT; -- Confirma as mudanças

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_CHECKLIST;


BEGIN
    CRUD_CHECKLIST(
        v_operacao        => 'INSERT',           
        v_id_checklist    => 11,                      
        v_nivel           => 2,                     
        v_escovacao_dentes => 1,                      
        v_fio_dental      => 1,                     
        v_enxaguante_bucal => 1,   
        v_id_usuario      => 555          
    );
END;

