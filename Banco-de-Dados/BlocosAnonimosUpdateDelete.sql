-- Este bloco anônimo realiza um UPDATE na tabela c_op_usuario, alterando o nome de um usuário com base no valor de id_usuario. 
-- Uma estrutura de decisão é usada para verificar se o usuário existe antes de realizar a atualização.

DECLARE
    v_id_usuario   NUMBER := 101; -- Variável para o ID do usuário
    v_novo_nome    VARCHAR2(100) := 'Nome Atualizado'; -- Novo nome do usuário
BEGIN
    -- Verificar se o usuário existe
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM c_op_usuario
        WHERE id_usuario = v_id_usuario;

        IF v_count > 0 THEN
            -- Se o usuário existir, fazer o UPDATE
            UPDATE c_op_usuario
            SET nome_usuario = v_novo_nome
            WHERE id_usuario = v_id_usuario;

            DBMS_OUTPUT.PUT_LINE('Usuário de ID ' || v_id_usuario || ' foi atualizado para ' || v_novo_nome);
        ELSE
            -- Caso o usuário não exista
            DBMS_OUTPUT.PUT_LINE('Usuário com ID ' || v_id_usuario || ' não encontrado.');
        END IF;
    END;
END;

----------------------------------------------------------------------------------------------------------------------------------------------

-- Este bloco realiza um DELETE na tabela c_op_agendamento, removendo um agendamento com base no valor de id_agendamento. 
-- A operação de remoção só é feita se o agendamento for encontrado.

DECLARE
    v_id_agendamento NUMBER := 205; -- Variável para o ID do agendamento a ser deletado
BEGIN
    -- Verificar se o agendamento existe
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM c_op_agendamento
        WHERE id_agendamento = v_id_agendamento;

        IF v_count > 0 THEN
            -- Se o agendamento existir, fazer o DELETE
            DELETE FROM c_op_agendamento
            WHERE id_agendamento = v_id_agendamento;

            DBMS_OUTPUT.PUT_LINE('Agendamento de ID ' || v_id_agendamento || ' foi removido.');
        ELSE
            -- Caso o agendamento não exista
            DBMS_OUTPUT.PUT_LINE('Agendamento com ID ' || v_id_agendamento || ' não encontrado.');
        END IF;
    END;
END;
/




