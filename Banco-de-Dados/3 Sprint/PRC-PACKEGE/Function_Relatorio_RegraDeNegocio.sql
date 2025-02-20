/*
Primeiramente define um tipo de tabela que será utilizado para armazenar os resultados,
depois a função gerar_relatorio_agendamentos_dia gera um relatório detalhado sobre tratamentos odontológicos agendados para cada dia, 
unindo dados de várias tabelas e exibindo informações organizadas. 

A função usa PIPELINED para retornar os resultados linha por linha como uma tabela organizada, 
permitindo que outros processos consultem o relatório como uma tabela SQL normal.
*/


CREATE OR REPLACE TYPE relatorio_agendamentos_dia_extendido AS OBJECT (
    data_agendada       DATE,
    dentista            VARCHAR2(100),
    tratamentos_count   NUMBER,
    tipo_tratamento     VARCHAR2(50),
    descr_tratamento    VARCHAR2(255),
    usuario_responsavel VARCHAR2(100)
);

CREATE OR REPLACE TYPE tabela_relatorio_agendamentos_dia_extendido IS TABLE OF relatorio_agendamentos_dia_extendido;


CREATE OR REPLACE FUNCTION gerar_relatorio_agendamentos_dia
RETURN tabela_relatorio_agendamentos_dia_extendido PIPELINED
IS
    -- Variável para armazenar os resultados da função relatorio_tratamentos
    v_tratamentos tratamento_usuario_tab := relatorio_tratamentos();
BEGIN
    FOR r IN (
        SELECT 
            a.data_agendada,
            d.nome_dentista AS dentista,
            COUNT(a.id_agendamento) AS tratamentos_count,
            t.tipo_tratamento,
            t.descr_tratamento,
            t.nome_usuario AS usuario_responsavel
        FROM 
            c_op_agendamento a
        INNER JOIN 
            c_op_dentista d ON a.id_tratamento = d.id_dentista
        INNER JOIN 
            TABLE(v_tratamentos) t ON t.id_tratamento = a.id_tratamento
        GROUP BY 
            a.data_agendada, d.nome_dentista, t.tipo_tratamento, t.descr_tratamento, t.nome_usuario
        ORDER BY 
            a.data_agendada, d.nome_dentista
    ) LOOP
        PIPE ROW (
            relatorio_agendamentos_dia_extendido(
                r.data_agendada,
                r.dentista,
                r.tratamentos_count,
                r.tipo_tratamento,
                r.descr_tratamento,
                r.usuario_responsavel
            )
        );
    END LOOP;
    
    RETURN;
END gerar_relatorio_agendamentos_dia;




SELECT * FROM TABLE(gerar_relatorio_agendamentos_dia);

