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
    -- Variáveis para SELECT
    v_result_nivel          c_op_checklist.nivel%TYPE;
    v_result_escovacao      c_op_checklist.escovacao_dentes%TYPE;
    v_result_fio_dental     c_op_checklist.fio_dental%TYPE;
    v_result_enxaguante     c_op_checklist.enxaguante_bucal%TYPE;
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

    ELSIF v_operacao = 'SELECT' THEN
        BEGIN
            SELECT nivel, escovacao_dentes, fio_dental, enxaguante_bucal
            INTO v_result_nivel, v_result_escovacao, v_result_fio_dental, v_result_enxaguante
            FROM c_op_checklist
            WHERE id_checklist = v_id_checklist;

            DBMS_OUTPUT.PUT_LINE('Nível: ' || v_result_nivel);
            DBMS_OUTPUT.PUT_LINE('Escovação: ' || v_result_escovacao);
            DBMS_OUTPUT.PUT_LINE('Fio Dental: ' || v_result_fio_dental);
            DBMS_OUTPUT.PUT_LINE('Enxaguante Bucal: ' || v_result_enxaguante);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Checklist não encontrado com o ID especificado.');
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
END CRUD_CHECKLIST;


