CREATE OR REPLACE PROCEDURE CRUD_TRATAMENTO (
    v_operacao          IN VARCHAR2,
    v_id_tratamento     IN c_op_tratamento.id_tratamento%TYPE DEFAULT NULL,
    v_tipo_tratamento   IN c_op_tratamento.tipo_tratamento%TYPE DEFAULT NULL,
    v_dt_inicio_tratamento IN c_op_tratamento.dt_inicio_tratamento%TYPE DEFAULT NULL,
    v_dt_termino_tratamento IN c_op_tratamento.dt_termino_tratamento%TYPE DEFAULT NULL,
    v_descr_tratamento   IN c_op_tratamento.descr_tratamento%TYPE DEFAULT NULL,
    v_id_dentista       IN c_op_tratamento.id_dentista%TYPE DEFAULT NULL,
    v_id_usuario        IN c_op_tratamento.id_usuario%TYPE DEFAULT NULL,
    v_id_notificacao    IN c_op_tratamento.id_notificacao%TYPE DEFAULT NULL,
    v_id_status         IN c_op_tratamento.id_status%TYPE DEFAULT NULL,
    v_id_plano          IN c_op_tratamento.id_plano%TYPE DEFAULT NULL
) IS
    v_mensagem_resposta VARCHAR2(255);
    v_tipo              c_op_tratamento.tipo_tratamento%TYPE;
    v_data_inicio       c_op_tratamento.dt_inicio_tratamento%TYPE;
    v_data_termino     c_op_tratamento.dt_termino_tratamento%TYPE;
    v_descricao         c_op_tratamento.descr_tratamento%TYPE;
    v_id_dentista_out   c_op_tratamento.id_dentista%TYPE;
    v_id_usuario_out    c_op_tratamento.id_usuario%TYPE;
    v_id_notificacao_out c_op_tratamento.id_notificacao%TYPE;
    v_id_status_out     c_op_tratamento.id_status%TYPE;
    v_id_plano_out      c_op_tratamento.id_plano%TYPE;
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_tratamento (
            id_tratamento,
            tipo_tratamento,
            dt_inicio_tratamento,
            dt_termino_tratamento,
            descr_tratamento,
            id_dentista,
            id_usuario,
            id_notificacao,
            id_status,
            id_plano
        ) VALUES (
            v_id_tratamento,
            v_tipo_tratamento,
            v_dt_inicio_tratamento,
            v_dt_termino_tratamento,
            v_descr_tratamento,
            v_id_dentista,
            v_id_usuario,
            v_id_notificacao,
            v_id_status,
            v_id_plano
        );
        v_mensagem_resposta := 'Tratamento inserido com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_tratamento
        SET tipo_tratamento = v_tipo_tratamento,
            dt_inicio_tratamento = v_dt_inicio_tratamento,
            dt_termino_tratamento = v_dt_termino_tratamento,
            descr_tratamento = v_descr_tratamento,
            id_dentista = v_id_dentista,
            id_usuario = v_id_usuario,
            id_notificacao = v_id_notificacao,
            id_status = v_id_status,
            id_plano = v_id_plano
        WHERE id_tratamento = v_id_tratamento;
        v_mensagem_resposta := 'Tratamento atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_tratamento
        WHERE id_tratamento = v_id_tratamento;
        v_mensagem_resposta := 'Tratamento deletado com sucesso.';

    ELSIF v_operacao = 'SELECT' THEN
        SELECT tipo_tratamento, dt_inicio_tratamento, dt_termino_tratamento, descr_tratamento,
               id_dentista, id_usuario, id_notificacao, id_status, id_plano
        INTO v_tipo, v_data_inicio, v_data_termino, v_descricao,
             v_id_dentista_out, v_id_usuario_out, v_id_notificacao_out, v_id_status_out, v_id_plano_out
        FROM c_op_tratamento
        WHERE id_tratamento = v_id_tratamento;

        DBMS_OUTPUT.PUT_LINE('Tratamento encontrado:');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_tratamento);
        DBMS_OUTPUT.PUT_LINE('Tipo de Tratamento: ' || v_tipo);
        DBMS_OUTPUT.PUT_LINE('Data de Início: ' || TO_CHAR(v_data_inicio, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Data de Término: ' || TO_CHAR(v_data_termino, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_descricao);
        DBMS_OUTPUT.PUT_LINE('ID Dentista: ' || v_id_dentista_out);
        DBMS_OUTPUT.PUT_LINE('ID Usuário: ' || v_id_usuario_out);
        DBMS_OUTPUT.PUT_LINE('ID Notificação: ' || v_id_notificacao_out);
        DBMS_OUTPUT.PUT_LINE('ID Status: ' || v_id_status_out);
        DBMS_OUTPUT.PUT_LINE('ID Plano: ' || v_id_plano_out);
        RETURN;

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem_resposta);
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum tratamento encontrado com o ID: ' || v_id_tratamento);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_TRATAMENTO;


BEGIN
    CRUD_TRATAMENTO(
        v_operacao => 'INSERT',
        v_id_tratamento => 12,
        v_tipo_tratamento => 'Limpeza',
        v_dt_inicio_tratamento => SYSDATE,
        v_dt_termino_tratamento => NULL,
        v_descr_tratamento => 'Limpeza dental padrão.',
        v_id_dentista => 10,
        v_id_usuario => 2,
        v_id_notificacao => 11,
        v_id_status => 1,
        v_id_plano => 5
    );
END;


BEGIN
    CRUD_TRATAMENTO(
        v_operacao => 'UPDATE',
        v_id_tratamento => 1,
        v_tipo_tratamento => 'Limpeza Profunda',
        v_dt_inicio_tratamento => SYSDATE,
        v_dt_termino_tratamento => NULL,
        v_descr_tratamento => 'Limpeza dental profunda.',
        v_id_dentista => 101,
        v_id_usuario => 202,
        v_id_notificacao => 11,
        v_id_status => 1,
        v_id_plano => 5
    );
END;


BEGIN
    CRUD_TRATAMENTO(
        v_operacao => 'DELETE',
        v_id_tratamento => 1
    );
END;

BEGIN
    CRUD_TRATAMENTO(
        v_operacao => 'SELECT',
        v_id_tratamento => 1
    );
END;

