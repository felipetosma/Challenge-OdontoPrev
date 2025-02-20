CREATE OR REPLACE PROCEDURE prc_relatorio_tratamentos_dentista IS
    -- Declaração do cursor
    CURSOR c_tratamentos IS
    SELECT
        d.nome_dentista,
        e.tipo_especialidade,
        COUNT(t.id_tratamento)                                       AS total_tratamentos,
        round(AVG(t.dt_termino_tratamento - t.dt_inicio_tratamento)) AS media_dias_tratamento,
        p.nome_plano,
        CASE
            WHEN e.tipo_especialidade IS NULL THEN
                'Especialidade não cadastrada'
            WHEN dp.id_dentista IS NULL THEN
                'Especialidade não coberta pelo plano'
            ELSE
                'Especialidade válida'
        END                                                          AS status_especialidade
    FROM
             c_op_dentista d
        INNER JOIN c_op_tratamento     t ON d.id_dentista = t.id_dentista
        INNER JOIN c_op_plano_de_saude p ON t.id_plano = p.id_plano
        LEFT JOIN c_op_especialidade  e ON d.id_especialidade = e.id_especialidade
        LEFT JOIN c_op_dentista_plano dp ON ( d.id_dentista = dp.id_dentista
                                              AND t.id_plano = dp.id_plano )
    WHERE
        t.dt_termino_tratamento IS NOT NULL
    GROUP BY
        d.nome_dentista,
        e.tipo_especialidade,
        p.nome_plano,
        CASE
                WHEN e.tipo_especialidade IS NULL THEN
                    'Especialidade não cadastrada'
                WHEN dp.id_dentista IS NULL THEN
                    'Especialidade não coberta pelo plano'
                ELSE
                    'Especialidade válida'
        END
    ORDER BY
        total_tratamentos DESC,
        media_dias_tratamento;

    -- Variáveis para armazenar os dados do cursor
    v_nome_dentista        c_op_dentista.nome_dentista%TYPE;
    v_especialidade        c_op_especialidade.tipo_especialidade%TYPE;
    v_total                NUMBER;
    v_media                NUMBER;
    v_plano                c_op_plano_de_saude.nome_plano%TYPE;
    v_status_especialidade VARCHAR2(100);
BEGIN
    -- Abre o cursor
    OPEN c_tratamentos;
    
    -- Cabeçalho do relatório
    dbms_output.put_line('=== RELATÓRIO DE TRATAMENTOS POR DENTISTA E ESPECIALIDADE ===');
    dbms_output.put_line('--------------------------------------------------------');
    
    -- Loop através dos resultados
    LOOP
        FETCH c_tratamentos INTO
            v_nome_dentista,
            v_especialidade,
            v_total,
            v_media,
            v_plano,
            v_status_especialidade;
        EXIT WHEN c_tratamentos%notfound;
        
        -- Formatação e exibição dos dados
        dbms_output.put_line('Dentista: '
                             || v_nome_dentista
                             || ' | Especialidade: '
                             || nvl(v_especialidade, 'Não especificada')
                             || ' | Plano: '
                             || v_plano
                             || ' | Status: '
                             || v_status_especialidade
                             || ' | Total Tratamentos: '
                             || v_total
                             || ' | Média Dias: '
                             || v_media);

    END LOOP;
    
    -- Fecha o cursor
    CLOSE c_tratamentos;
END prc_relatorio_tratamentos_dentista;
/


SET SERVEROUTPUT ON;
BEGIN
    prc_relatorio_tratamentos_dentista;
END;
/