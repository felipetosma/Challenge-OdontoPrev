-- CRUD tabela C_OP_DENTISTA
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE CRUD_DENTISTA(
    v_operacao          IN VARCHAR2,
    v_id_dentista       IN c_op_dentista.id_dentista%TYPE,
    v_nome_dentista     IN c_op_dentista.nome_dentista%TYPE,
    v_senha_dentista    IN c_op_dentista.senha_dentista%TYPE,
    v_cro               IN c_op_dentista.cro%TYPE,
    v_telefone_dentista IN c_op_dentista.telefone_dentista%TYPE,
    v_email_dentista    IN c_op_dentista.email_dentista%TYPE,
    v_id_especialidade  IN c_op_dentista.id_especialidade%TYPE
) IS
    v_erro_cro VARCHAR2(400);
    v_mensagem VARCHAR2(255);
BEGIN
-- Validação do CRO utilizando a função de validação
    v_erro_cro := validar_formato_cro(v_cro);
    
-- Verifica se há erro no CRO
    IF v_erro_cro IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20003, v_erro_cro);
    END IF;

    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_dentista (
            id_dentista,
            nome_dentista,
            senha_dentista,
            cro,
            telefone_dentista,
            email_dentista,
            id_especialidade
        ) VALUES (
            v_id_dentista,
            v_nome_dentista,
            v_senha_dentista,
            v_cro,
            v_telefone_dentista,
            v_email_dentista,
            v_id_especialidade
        );
        v_mensagem := 'Dentista inserido com sucesso.';
    
    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_dentista
        SET nome_dentista = v_nome_dentista,
            senha_dentista = v_senha_dentista,
            cro = v_cro,
            telefone_dentista = v_telefone_dentista,
            email_dentista = v_email_dentista,
            id_especialidade = v_id_especialidade
        WHERE id_dentista = v_id_dentista;
        v_mensagem := 'Dentista atualizado com sucesso.';
    
    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_dentista
        WHERE id_dentista = v_id_dentista;
        v_mensagem := 'Dentista deletado com sucesso.';
    
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE ou DELETE.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem);
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_DENTISTA;


BEGIN
    CRUD_DENTISTA(
        v_operacao          => 'INSERT',
        v_id_dentista       => 5454,
        v_nome_dentista     => 'Dr. Carlos Hailton',
        v_senha_dentista    => 'Senha123',
        v_cro               => '12345SP',
        v_telefone_dentista => 11987654321,
        v_email_dentista    => 'carlos.hailton@exemplo.com',
        v_id_especialidade  => 2
    );
END;




