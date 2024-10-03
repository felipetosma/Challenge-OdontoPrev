-- Este bloco anônimo realiza um UPDATE na tabela c_op_usuario, alterando o nome de um usuário com base no valor de id_usuario. 
-- Uma estrutura de decisão é usada para verificar se o usuário existe antes de realizar a atualização.

DECLARE
    num_id_usuario   NUMBER(30) := &DIGITEOIDDOUSUARIO; 
    novo_nome    VARCHAR2(100) := '&DIGITEONOVONOME'; 
    contador        NUMBER;
BEGIN
-- Verificar se o usuário existe
    SELECT COUNT(*) INTO contador
    FROM c_op_usuario
    WHERE id_usuario = num_id_usuario;

    IF contador > 0 THEN
        -- Se o usuário existir, fazer o UPDATE
        UPDATE c_op_usuario
        SET nome_usuario = novo_nome
        WHERE id_usuario = num_id_usuario;

        DBMS_OUTPUT.PUT_LINE('Usuário de ID ' || num_id_usuario || ' foi atualizado para ' || novo_nome);
    ELSE
        -- Caso o usuário não exista
        DBMS_OUTPUT.PUT_LINE('Usuário com ID ' || num_id_usuario || ' não encontadorrado.');
    END IF;
END;
/


----------------------------------------------------------------------------------------------------------------------------------------------

-- Este bloco irá excluir um dentista da tabela c_op_dentista com base no ID do dentista.

DECLARE
    num_id_dentista  NUMBER(30) := &DIGITEOIDDENTISTA;
    contador  NUMBER;
BEGIN
    -- Verificar se o dentista existe
    SELECT COUNT(*) INTO contador
    FROM c_op_dentista
    WHERE id_dentista = num_id_dentista;

    IF contador > 0 THEN
        DELETE FROM c_op_dentista
        WHERE id_dentista = num_id_dentista;

        DBMS_OUTPUT.PUT_LINE('Dentista de ID ' || num_id_dentista || ' foi excluído com sucesso.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Dentista com ID ' || num_id_dentista || ' não encontadorrado.');
    END IF;
END;
/





