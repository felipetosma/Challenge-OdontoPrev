CREATE OR REPLACE PROCEDURE CRUD_NOTIFICACAO (
    v_operacao        IN VARCHAR2,
    v_id_notificacao   IN c_op_notificacao.id_notificacao%TYPE DEFAULT NULL,
    v_mensagem        IN c_op_notificacao.mensagem%TYPE DEFAULT NULL,
    v_data_envio      IN c_op_notificacao.data_envio%TYPE DEFAULT NULL,
    v_leitura         IN c_op_notificacao.leitura%TYPE DEFAULT NULL
) IS
    v_mensagem_resposta VARCHAR2(255);
    v_msg c_op_notificacao.mensagem%TYPE;
    v_data c_op_notificacao.data_envio%TYPE;
    v_leitura_status c_op_notificacao.leitura%TYPE;
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_notificacao (
            id_notificacao,
            mensagem,
            data_envio,
            leitura
        ) VALUES (
            v_id_notificacao,
            v_mensagem,
            v_data_envio,
            v_leitura
        );
        v_mensagem_resposta := 'Notificação inserida com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_notificacao
        SET mensagem = v_mensagem,
            data_envio = v_data_envio,
            leitura = v_leitura
        WHERE id_notificacao = v_id_notificacao;
        v_mensagem_resposta := 'Notificação atualizada com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_notificacao
        WHERE id_notificacao = v_id_notificacao;
        v_mensagem_resposta := 'Notificação deletada com sucesso.';

    ELSIF v_operacao = 'SELECT' THEN
        SELECT mensagem, data_envio, leitura
        INTO v_msg, v_data, v_leitura_status
        FROM c_op_notificacao
        WHERE id_notificacao = v_id_notificacao;

        DBMS_OUTPUT.PUT_LINE('Notificação encontrada:');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_notificacao);
        DBMS_OUTPUT.PUT_LINE('Mensagem: ' || v_msg);
        DBMS_OUTPUT.PUT_LINE('Data de Envio: ' || TO_CHAR(v_data, 'DD/MM/YYYY HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('Leitura: ' || v_leitura_status);
        RETURN;

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem_resposta);
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma notificação encontrada com o ID: ' || v_id_notificacao);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_NOTIFICACAO;


BEGIN
    CRUD_NOTIFICACAO(
        v_operacao => 'INSERT',
        v_id_notificacao => 11,
        v_mensagem => 'Notificação de teste.',
        v_data_envio => SYSDATE,
        v_leitura => 'N'
    );
END;


BEGIN
    CRUD_NOTIFICACAO(
        v_operacao => 'UPDATE',
        v_id_notificacao => 1,
        v_mensagem => 'Mensagem atualizada.',
        v_data_envio => SYSDATE,
        v_leitura => 'Y'
    );
END;


BEGIN
    CRUD_NOTIFICACAO(
        v_operacao => 'DELETE',
        v_id_notificacao => 1
    );
END;


BEGIN
    CRUD_NOTIFICACAO(
        v_operacao => 'SELECT',
        v_id_notificacao => 1
    );
END;

