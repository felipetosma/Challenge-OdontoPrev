--Explica��o:
-- Este bloco exibe a quantidade de tratamentos realizados por cada dentista, agrupando e ordenando pelos dentistas.

DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Dentistas e a quantidade de tratamentos realizados:');
    FOR i IN (
        SELECT d.nome_dentista, COUNT(t.id_tratamento) AS qtd_tratamentos
        FROM c_op_dentista d
        INNER JOIN c_op_tratamento t ON d.id_dentista = t.id_dentista
        GROUP BY d.nome_dentista
        ORDER BY qtd_tratamentos DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Dentista: ' || i.nome_dentista || ' - Tratamentos: ' || i.qtd_tratamentos);
    END LOOP;
END;

------------------------------------------------------------------------------------------------------------------------------------------

-- Este bloco exibe todos os usu�rios (pacientes) com seus dentistas associados. Caso o usu�rio ainda n�o tenha um dentista atribu�do, 
-- o nome do dentista ser� NULL.

DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Lista de Usu�rios e seus Dentistas:');
    FOR i IN (
        SELECT u.nome_usuario, d.nome_dentista
        FROM c_op_usuario u
        LEFT JOIN c_op_dentista d ON u.id_dentista = d.id_dentista
        GROUP BY u.nome_usuario, d.nome_dentista
        ORDER BY u.nome_usuario ASC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Usu�rio: ' || i.nome_usuario || ' - Dentista: ' || i.nome_dentista);
    END LOOP;
END;
/


------------------------------------------------------------------------------------------------------------------------------------------

-- Este bloco exibe a quantidade de agendamentos por plano de sa�de. Mesmo planos sem agendamentos ser�o exibidos.

DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Agendamentos por Plano de Sa�de:');
    FOR i IN (
        SELECT p.nome_plano, COUNT(a.id_agendamento) AS qtd_agendamentos
        FROM c_op_plano_de_saude p
        RIGHT JOIN c_op_usuario u ON p.id_plano = u.id_plano
        LEFT JOIN c_op_agendamento a ON u.id_usuario = a.id_usuario
        GROUP BY p.nome_plano
        ORDER BY qtd_agendamentos DESC
    )
    LOOP
        IF i.nome_plano IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Plano de Sa�de: Sem plano associado - Agendamentos: ' || i.qtd_agendamentos);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Plano de Sa�de: ' || i.nome_plano || ' - Agendamentos: ' || i.qtd_agendamentos);
        END IF;
    END LOOP;
END;
/



-- Este bloco exibe a quantidade de agendamentos agrupados pelo status do tratamento (conclu�do, em andamento, cancelado, etc.), 
-- agrupando pelo status e ordenando pela quantidade de agendamentos.




