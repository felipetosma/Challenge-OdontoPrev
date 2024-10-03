-- Este bloco an�nimo realiza um UPDATE na tabela c_op_usuario, alterando o nome de um usu�rio com base no valor de id_usuario. 
-- Uma estrutura de decis�o � usada para verificar se o usu�rio existe antes de realizar a atualiza��o.

DECLARE
    v_id_usuario   NUMBER := 101; -- Vari�vel para o ID do usu�rio
    v_novo_nome    VARCHAR2(100) := 'Nome Atualizado'; -- Novo nome do usu�rio
BEGIN
    -- Verificar se o usu�rio existe
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM c_op_usuario
        WHERE id_usuario = v_id_usuario;

        IF v_count > 0 THEN
            -- Se o usu�rio existir, fazer o UPDATE
            UPDATE c_op_usuario
            SET nome_usuario = v_novo_nome
            WHERE id_usuario = v_id_usuario;

            DBMS_OUTPUT.PUT_LINE('Usu�rio de ID ' || v_id_usuario || ' foi atualizado para ' || v_novo_nome);
        ELSE
            -- Caso o usu�rio n�o exista
            DBMS_OUTPUT.PUT_LINE('Usu�rio com ID ' || v_id_usuario || ' n�o encontrado.');
        END IF;
    END;
END;

----------------------------------------------------------------------------------------------------------------------------------------------

-- Este bloco realiza um DELETE na tabela c_op_agendamento, removendo um agendamento com base no valor de id_agendamento. 
-- A opera��o de remo��o s� � feita se o agendamento for encontrado.

DECLARE
    v_id_agendamento NUMBER := 205; -- Vari�vel para o ID do agendamento a ser deletado
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
            -- Caso o agendamento n�o exista
            DBMS_OUTPUT.PUT_LINE('Agendamento com ID ' || v_id_agendamento || ' n�o encontrado.');
        END IF;
    END;
END;
/




