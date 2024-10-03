--Explica��o:
-- Este bloco exibe a quantidade de tratamentos realizados por cada dentista, agrupando e ordenando pelos dentistas.

DECLARE
    v_nome_dentista   VARCHAR2(100);
    v_qtd_tratamentos NUMBER;
BEGIN
    -- Seleciona o primeiro dentista com base na ordena��o por tratamentos (primeiro da lista)
    SELECT
        d.nome_dentista,
        COUNT(t.id_tratamento) AS qtd_tratamentos
    INTO
        v_nome_dentista,
        v_qtd_tratamentos
    FROM
             c_op_dentista d
        INNER JOIN c_op_tratamento t ON d.id_dentista = t.id_dentista
    GROUP BY
        d.nome_dentista
    ORDER BY
        COUNT(t.id_tratamento) DESC;

    -- Exibe o resultado
    dbms_output.put_line('Dentista: '
                         || v_nome_dentista
                         || ' - Tratamentos: '
                         || v_qtd_tratamentos);
END;

------------------------------------------------------------------------------------------------------------------------------------------

-- Esse bloco exibe os tratamentos realizados por cada dentista. O resultado � obtido diretamente.
DECLARE
    v_nome_dentista     VARCHAR2(100);
    v_tipo_tratamento   VARCHAR2(200);
    v_total_tratamentos NUMBER;
BEGIN
    SELECT
        d.nome_dentista,
        t.tipo_tratamento,
        COUNT(t.id_tratamento)
    INTO
        v_nome_dentista,
        v_tipo_tratamento,
        v_total_tratamentos
    FROM
             c_op_dentista d
        INNER JOIN c_op_tratamento t ON d.id_dentista = t.id_dentista
    GROUP BY
        d.nome_dentista,
        t.tipo_tratamento
    ORDER BY
        d.nome_dentista,
        t.tipo_tratamento;

    dbms_output.put_line('Dentista: '
                         || v_nome_dentista
                         || ' | Tratamento: '
                         || v_tipo_tratamento
                         || ' | Total de Tratamentos: '
                         || v_total_tratamentos);

END;


------------------------------------------------------------------------------------------------------------------------------------------

-- Exibe todos os usu�rios (pacientes) com seus dentistas associados. Caso o usu�rio ainda n�o tenha um dentista atribu�do, 
-- o nome do dentista ser� NULL.

DECLARE BEGIN
    dbms_output.put_line('Lista de Usu�rios e seus Dentistas:');
    FOR i IN (
        SELECT
            u.nome_usuario,
            d.nome_dentista
        FROM
            c_op_usuario  u
            LEFT JOIN c_op_dentista d ON u.id_dentista = d.id_dentista
        GROUP BY
            u.nome_usuario,
            d.nome_dentista
        ORDER BY
            u.nome_usuario ASC
    ) LOOP
-- Verifica se o nome do dentista � NULL
        IF i.nome_dentista IS NULL THEN
            dbms_output.put_line('Usu�rio: '
                                 || i.nome_usuario
                                 || ' - Dentista: Sem Dentista Atribu�do');
        ELSE
            dbms_output.put_line('Usu�rio: '
                                 || i.nome_usuario
                                 || ' - Dentista: '
                                 || i.nome_dentista);
        END IF;
    END LOOP;

END;

------------------------------------------------------------------------------------------------------------------------------------------









