CREATE OR REPLACE PROCEDURE CRUD_AGENDAMENTO (
    v_operacao        IN VARCHAR2,
    v_id_agendamento   IN c_op_agendamento.id_agendamento%TYPE DEFAULT NULL,
    v_data_agendada    IN c_op_agendamento.data_agendada%TYPE DEFAULT NULL,
    v_horario_agendado IN c_op_agendamento.horario_agendado%TYPE DEFAULT NULL,
    v_id_status        IN c_op_agendamento.id_status%TYPE DEFAULT NULL,
    v_id_tratamento    IN c_op_agendamento.id_tratamento%TYPE DEFAULT NULL
) IS
    v_mensagem_resposta VARCHAR2(255);
    v_data_agendada_out c_op_agendamento.data_agendada%TYPE;
    v_horario_agendado_out c_op_agendamento.horario_agendado%TYPE;
    v_id_status_out     c_op_agendamento.id_status%TYPE;
    v_id_tratamento_out c_op_agendamento.id_tratamento%TYPE;
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_agendamento (
            id_agendamento,
            data_agendada,
            horario_agendado,
            id_status,
            id_tratamento
        ) VALUES (
            v_id_agendamento,
            v_data_agendada,
            v_horario_agendado,
            v_id_status,
            v_id_tratamento
        );
        v_mensagem_resposta := 'Agendamento inserido com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_agendamento
        SET data_agendada = v_data_agendada,
            horario_agendado = v_horario_agendado,
            id_status = v_id_status,
            id_tratamento = v_id_tratamento
        WHERE id_agendamento = v_id_agendamento;
        v_mensagem_resposta := 'Agendamento atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_agendamento
        WHERE id_agendamento = v_id_agendamento;
        v_mensagem_resposta := 'Agendamento deletado com sucesso.';

    ELSIF v_operacao = 'SELECT' THEN
        SELECT data_agendada, horario_agendado, id_status, id_tratamento
        INTO v_data_agendada_out, v_horario_agendado_out, v_id_status_out, v_id_tratamento_out
        FROM c_op_agendamento
        WHERE id_agendamento = v_id_agendamento;

        DBMS_OUTPUT.PUT_LINE('Agendamento encontrado:');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_agendamento);
        DBMS_OUTPUT.PUT_LINE('Data Agendada: ' || TO_CHAR(v_data_agendada_out, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Horário Agendado: ' || TO_CHAR(v_horario_agendado_out, 'HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('ID Status: ' || v_id_status_out);
        DBMS_OUTPUT.PUT_LINE('ID Tratamento: ' || v_id_tratamento_out);
        RETURN;

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem_resposta);
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum agendamento encontrado com o ID: ' || v_id_agendamento);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_AGENDAMENTO;


BEGIN
    CRUD_AGENDAMENTO(
        v_operacao => 'INSERT',
        v_id_agendamento => 11,
        v_data_agendada => TO_DATE('2024-11-10', 'YYYY-MM-DD'),
        v_horario_agendado => TO_DATE('2024-11-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        v_id_status => 1,
        v_id_tratamento => 12
    );
END;


BEGIN
    CRUD_AGENDAMENTO(
        v_operacao => 'UPDATE',
        v_id_agendamento => 1,
        v_data_agendada => TO_DATE('2024-11-12', 'YYYY-MM-DD'),
        v_horario_agendado => TO_DATE('2024-11-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        v_id_status => 2,
        v_id_tratamento => 3
    );
END;


BEGIN
    CRUD_AGENDAMENTO(
        v_operacao => 'DELETE',
        v_id_agendamento => 1
    );
END;


BEGIN
    CRUD_AGENDAMENTO(
        v_operacao => 'SELECT',
        v_id_agendamento => 1
    );
END;

