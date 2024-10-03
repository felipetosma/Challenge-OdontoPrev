-- Este bloco an�nimo realiza um UPDATE na tabela c_op_usuario, alterando o nome de um usu�rio com base no valor de id_usuario. 
-- Uma estrutura de decis�o � usada para verificar se o usu�rio existe antes de realizar a atualiza��o.

DECLARE
    num_id_usuario   NUMBER(30) := &DIGITEOIDDOUSUARIO; 
    novo_nome    VARCHAR2(100) := '&DIGITEONOVONOME'; 
    contador        NUMBER;
BEGIN
-- Verificar se o usu�rio existe
    SELECT COUNT(*) INTO contador
    FROM c_op_usuario
    WHERE id_usuario = num_id_usuario;

    IF contador > 0 THEN
        -- Se o usu�rio existir, fazer o UPDATE
        UPDATE c_op_usuario
        SET nome_usuario = novo_nome
        WHERE id_usuario = num_id_usuario;

        DBMS_OUTPUT.PUT_LINE('Usu�rio de ID ' || num_id_usuario || ' foi atualizado para ' || novo_nome);
    ELSE
        -- Caso o usu�rio n�o exista
        DBMS_OUTPUT.PUT_LINE('Usu�rio com ID ' || num_id_usuario || ' n�o encontadorrado.');
    END IF;
END;
/


----------------------------------------------------------------------------------------------------------------------------------------------

-- Este bloco ir� excluir um dentista da tabela c_op_dentista com base no ID do dentista.

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

        DBMS_OUTPUT.PUT_LINE('Dentista de ID ' || num_id_dentista || ' foi exclu�do com sucesso.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Dentista com ID ' || num_id_dentista || ' n�o encontadorrado.');
    END IF;
END;
/





