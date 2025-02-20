/*
Primeiramente define um tipo de tabela que será utilizado para armazenar os resultados da função,
a função relatorio_tratamentos irá executar a consulta e retornar os dados no formato de tabela, 
juntando as tabelas C_OP_USUARIO + C_OP_TRATAMENTO.
*/

CREATE OR REPLACE TYPE tratamento_usuario_rec AS OBJECT (
    id_tratamento         NUMBER(30),
    tipo_tratamento       VARCHAR2(200),
    dt_inicio_tratamento  DATE,
    dt_termino_tratamento DATE,
    descr_tratamento      VARCHAR2(300),
    nome_usuario          VARCHAR2(100)
);

CREATE OR REPLACE TYPE tratamento_usuario_tab AS TABLE OF tratamento_usuario_rec;


CREATE OR REPLACE FUNCTION relatorio_tratamentos
RETURN tratamento_usuario_tab IS
    v_result tratamento_usuario_tab := tratamento_usuario_tab(); -- Inicializa a tabela

    -- Declaração do cursor
    CURSOR c_tratamentos IS
        SELECT t.id_tratamento,
               t.tipo_tratamento,
               t.dt_inicio_tratamento,
               t.dt_termino_tratamento,
               t.descr_tratamento,
               u.nome_usuario
        FROM c_op_tratamento t
        JOIN c_op_usuario u ON t.id_usuario = u.id_usuario;

BEGIN
    -- Itera sobre o cursor
    FOR rec IN c_tratamentos LOOP
        v_result.EXTEND; -- Aumenta o tamanho da tabela
        v_result(v_result.COUNT) := tratamento_usuario_rec(
            rec.id_tratamento,
            rec.tipo_tratamento,
            rec.dt_inicio_tratamento,
            rec.dt_termino_tratamento,
            rec.descr_tratamento,
            rec.nome_usuario
        );
    END LOOP;

    RETURN v_result; -- Retorna a tabela
END relatorio_tratamentos;


--Bloco para chamar a função criada e exibir os dados do relatório da tabela C_OP_USUARIO + C_OP_TRATAMENTO

DECLARE
    v_relatorio tratamento_usuario_tab;
BEGIN
    v_relatorio := relatorio_tratamentos;

    FOR i IN 1 .. v_relatorio.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID Tratamento: ' || v_relatorio(i).id_tratamento);
        DBMS_OUTPUT.PUT_LINE('Tipo de Tratamento: ' || v_relatorio(i).tipo_tratamento);
        DBMS_OUTPUT.PUT_LINE('Nome do Usuário: ' || v_relatorio(i).nome_usuario);
        DBMS_OUTPUT.PUT_LINE('Data de Início: ' || TO_CHAR(v_relatorio(i).dt_inicio_tratamento, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Data de Término: ' || TO_CHAR(v_relatorio(i).dt_termino_tratamento, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_relatorio(i).descr_tratamento);
        DBMS_OUTPUT.PUT_LINE('---------------------------');
    END LOOP;
END;

