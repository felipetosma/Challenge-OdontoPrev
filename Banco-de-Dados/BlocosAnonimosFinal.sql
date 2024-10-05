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
             c_op_dentista d
        INNER JOIN c_op_tratamento t ON d.id_dentista = t.id_dentista
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

DECLARE 
BEGIN
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
