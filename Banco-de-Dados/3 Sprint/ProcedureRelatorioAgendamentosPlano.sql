CREATE OR REPLACE PROCEDURE prc_relatorio_agendamentos_plano IS
    -- Declaração do cursor
    CURSOR c_agendamentos IS
        SELECT 
            p.nome_plano,
            tp.nome_tipo_plano,
            COUNT(a.id_agendamento) as total_agendamentos,
            d.nome_dentista,
            CASE 
                WHEN COUNT(a.id_agendamento) > 10 THEN 'Alto Volume'
                WHEN COUNT(a.id_agendamento) > 5 THEN 'Volume Médio'
                ELSE 'Baixo Volume'
            END as categoria_volume
        FROM c_op_plano_de_saude p
        INNER JOIN c_op_tipo_plano tp ON p.id_tipo_plano = tp.id_tipo_plano
        INNER JOIN c_op_tratamento t ON t.id_plano = p.id_plano
        LEFT JOIN c_op_agendamento a ON a.id_tratamento = t.id_tratamento
        LEFT JOIN c_op_dentista d ON t.id_dentista = d.id_dentista
        GROUP BY p.nome_plano, tp.nome_tipo_plano, d.nome_dentista
        ORDER BY total_agendamentos DESC;

    -- Variáveis para armazenar os dados do cursor
    v_nome_plano c_op_plano_de_saude.nome_plano%TYPE;
    v_tipo_plano c_op_tipo_plano.nome_tipo_plano%TYPE;
    v_total NUMBER;
    v_dentista c_op_dentista.nome_dentista%TYPE;
    v_categoria VARCHAR2(20);

BEGIN
    -- Abre o cursor
    OPEN c_agendamentos;
    
    -- Cabeçalho do relatório
    DBMS_OUTPUT.PUT_LINE('=== RELATÓRIO DE AGENDAMENTOS POR PLANO ===');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    -- Loop através dos resultados
    LOOP
        FETCH c_agendamentos INTO v_nome_plano, v_tipo_plano, v_total, v_dentista, v_categoria;
        EXIT WHEN c_agendamentos%NOTFOUND;
        
        -- Formatação e exibição dos dados
        DBMS_OUTPUT.PUT_LINE(
            'Plano: ' || UPPER(v_nome_plano) || 
            ' | Tipo: ' || v_tipo_plano ||
            ' | Total Agendamentos: ' || v_total ||
            ' | Dentista: ' || NVL(v_dentista, 'Não atribuído') ||
            ' | Categoria: ' || v_categoria
        );
    END LOOP;
    
    -- Fecha o cursor
    CLOSE c_agendamentos;
END prc_relatorio_agendamentos_plano;
/


SET SERVEROUTPUT ON;
BEGIN
    prc_relatorio_agendamentos_plano;
END;
/