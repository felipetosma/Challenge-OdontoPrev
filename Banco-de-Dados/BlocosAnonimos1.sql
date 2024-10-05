SET SERVEROUTPUT ON;
--Explicação:
-- Este bloco exibe a quantidade de tratamentos realizados por cada dentista, agrupando e ordenando pelos dentistas.

DECLARE
    v_nome_dentista   VARCHAR2(100):= '&DIGITEONOVONOME';
    v_qtd_tratamentos NUMBER;
BEGIN
    -- Seleciona o primeiro dentista com base na ordenação por tratamentos (primeiro da lista)
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

-- Esse bloco exibe os tratamentos realizados por cada dentista. O resultado é obtido diretamente.
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

-- Exibe todos os usuários (pacientes) com seus dentistas associados. Caso o usuário ainda não tenha um dentista atribuído, 
-- o nome do dentista será NULL.

DECLARE BEGIN
    dbms_output.put_line('Lista de Usuários e seus Dentistas:');
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
-- Verifica se o nome do dentista é NULL
        IF i.nome_dentista IS NULL THEN
            dbms_output.put_line('Usuário: '
                                 || i.nome_usuario
                                 || ' - Dentista: Sem Dentista Atribuído');
        ELSE
            dbms_output.put_line('Usuário: '
                                 || i.nome_usuario
                                 || ' - Dentista: '
                                 || i.nome_dentista);
        END IF;
    END LOOP;

END;

------------------------------------------------------------------------------------------------------------------------------------------

DECLARE
    v_nome_dentista   VARCHAR2(100) := '&DIGITE_O_NOME_DO_DENTISTA';
    v_qtd_tratamentos NUMBER;
BEGIN
    SELECT
        COUNT(t.id_tratamento)
    INTO
        v_qtd_tratamentos
    FROM
        c_op_dentista d
        INNER JOIN c_op_tratamento t ON d.id_dentista = t.id_dentista
    WHERE
        LOWER(d.nome_dentista) = LOWER(v_nome_dentista);

    IF v_qtd_tratamentos IS NOT NULL THEN
        dbms_output.put_line('Dentista: '
                             || v_nome_dentista
                             || ' - Tratamentos: '
                             || v_qtd_tratamentos);
    ELSE
        dbms_output.put_line('Nenhum dentista encontrado com o nome: ' || v_nome_dentista);
    END IF;

END;



----------------------------------------------------------------

DECLARE
    v_nome_usuario VARCHAR2(100);
    v_total_tratamentos NUMBER;
    v_tipo_status VARCHAR2(50);
BEGIN
    SELECT 
        u.nome_usuario,
        COUNT(t.id_tratamento),
        MAX(s.tipo_status)
    INTO 
        v_nome_usuario,
        v_total_tratamentos,
        v_tipo_status
    FROM 
        c_op_usuario u
        LEFT JOIN c_op_tratamento t ON u.id_usuario = t.id_usuario
        LEFT JOIN c_op_status s ON t.id_status = s.id_status
    GROUP BY 
        u.nome_usuario
    ORDER BY 
        COUNT(t.id_tratamento) DESC
    FETCH FIRST 1 ROW ONLY;

    DBMS_OUTPUT.PUT_LINE('Usuário com mais tratamentos: ' || v_nome_usuario || 
                         ' | Total de Tratamentos: ' || v_total_tratamentos ||
                         ' | Status mais recente: ' || NVL(v_tipo_status, 'N/A'));
END;


----------------------------------------------------------------
