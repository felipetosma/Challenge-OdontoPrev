----------------------------------------------------------------------------------------------------------------------------------------------
-- BLOCOS ANÔNIMOS PL/SQL
----------------------------------------------------------------------------------------------------------------------------------------------


SET SERVEROUTPUT ON;

------------------------------------------------------------------------------------------------------------------------------------------
-- 1- Seleciona o nome do usuário com mais tratamentos e o total de tratamentos, exibindo o resultado com DBMS_OUTPUT.PUT_LINE.

DECLARE
    nomeusuario      VARCHAR2(100);
    totaltratamentos NUMBER;
BEGIN
    SELECT
        u.nome_usuario,
        COUNT(t.id_tratamento)
    INTO
        nomeusuario,
        totaltratamentos
    FROM
        c_op_usuario    u
        LEFT JOIN c_op_tratamento t ON u.id_usuario = t.id_usuario
    GROUP BY
        u.nome_usuario
    ORDER BY
        COUNT(t.id_tratamento) DESC
    FETCH FIRST 1 ROW ONLY;

    dbms_output.put_line('Usuário com mais tratamentos: '
                         || nomeusuario
                         || ' | Total: '
                         || totaltratamentos);
END;
------------------------------------------------------------------------------------------------------------------------------------------

-- 2- Seleciona o dentista com mais tratamentos e exibe o nome do dentista junto com o total de tratamentos.

DECLARE
    v_nome_dentista     VARCHAR2(100);
    v_total_tratamentos NUMBER;
BEGIN
    SELECT
        d.nome_dentista,
        COUNT(t.id_tratamento)
    INTO
        v_nome_dentista,
        v_total_tratamentos
    FROM
        c_op_tratamento t
        RIGHT JOIN c_op_dentista   d ON t.id_dentista = d.id_dentista
    GROUP BY
        d.nome_dentista
    ORDER BY
        COUNT(t.id_tratamento) DESC
    FETCH FIRST 1 ROW ONLY;

    dbms_output.put_line('Dentista com mais tratamentos: '
                         || v_nome_dentista
                         || ' | Total: '
                         || v_total_tratamentos);
END;

------------------------------------------------------------------------------------------------------------------------------------------

-- 3- Usa um loop FOR para exibir o nome de cada dentista e o número de tratamentos associados, iterando sobre os resultados da consulta.

DECLARE BEGIN
    FOR rec IN (
        SELECT
            d.nome_dentista,
            COUNT(t.id_tratamento) AS qtd_tratamentos
        FROM
                 c_op_dentista d
            INNER JOIN c_op_tratamento t ON d.id_dentista = t.id_dentista
        GROUP BY
            d.nome_dentista
        ORDER BY
            d.nome_dentista
    ) LOOP
        dbms_output.put_line('Dentista: '
                             || rec.nome_dentista
                             || ' | Tratamentos: '
                             || rec.qtd_tratamentos);
    END LOOP;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Nenhum dentista encontrado.');
END;



----------------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE E DELETE
----------------------------------------------------------------------------------------------------------------------------------------------


-- 1- Realiza um UPDATE na tabela c_op_usuario, alterando o nome de um usuário com base no valor de id_usuario. 
-- Uma estrutura de decisão é usada para verificar se o usuário existe antes de realizar a atualização.

DECLARE
    num_id_usuario NUMBER(30) := &digiteoiddousuario;
    novo_nome      VARCHAR2(100) := '&DIGITEONOVONOME';
    contador       NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO contador
    FROM
        c_op_usuario
    WHERE
        id_usuario = num_id_usuario;

    IF contador > 0 THEN
        UPDATE c_op_usuario
        SET
            nome_usuario = novo_nome
        WHERE
            id_usuario = num_id_usuario;

        dbms_output.put_line('Usuário de ID '
                             || num_id_usuario
                             || ' foi atualizado para '
                             || novo_nome);
    ELSE
        dbms_output.put_line('Usuário com ID '
                             || num_id_usuario
                             || ' não encontadorrado.');
    END IF;

END;
----------------------------------------------------------------------------------------------------------------------------------------------

-- 2- Realiza a exclusão de um registro na tabela c_op_checklist com base no id_usuario fornecido por um input.

DECLARE
    v_id_usuario NUMBER(30) := &digiteoiddousuario;
    v_contador   NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_contador
    FROM
        c_op_checklist
    WHERE
        id_usuario = v_id_usuario;

    IF v_contador > 0 THEN
        DELETE FROM c_op_checklist
        WHERE
            id_usuario = v_id_usuario;

        dbms_output.put_line('Checklists do usuário de ID '
                             || v_id_usuario
                             || ' foram excluídos com sucesso.');
    ELSE
        dbms_output.put_line('Nenhum checklist encontrado para o usuário com ID '
                             || v_id_usuario
                             || '.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Ocorreu um erro durante a exclusão: ' || sqlerrm);
END;

