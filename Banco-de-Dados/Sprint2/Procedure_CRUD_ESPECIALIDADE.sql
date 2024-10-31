-- CRUD tabela C_OP_ESPECIALIDADE

CREATE OR REPLACE PROCEDURE CRUD_ESPECIALIDADE (
    v_operacao           IN VARCHAR2,
    v_id_especialidade   IN c_op_especialidade.id_especialidade%TYPE,
    v_tipo_especialidade IN c_op_especialidade.tipo_especialidade%TYPE,
    v_descr_especialidade IN c_op_especialidade.descr_especialidade%TYPE
) IS
    v_mensagem VARCHAR2(255);
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_especialidade (
            id_especialidade,
            tipo_especialidade,
            descr_especialidade
        ) VALUES (
            v_id_especialidade,
            v_tipo_especialidade,
            v_descr_especialidade
        );
        v_mensagem := 'Especialidade inserida com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_especialidade
        SET tipo_especialidade = v_tipo_especialidade,
            descr_especialidade = v_descr_especialidade
        WHERE id_especialidade = v_id_especialidade;
        v_mensagem := 'Especialidade atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_especialidade
        WHERE id_especialidade = v_id_especialidade;
        v_mensagem := 'Especialidade deletado com sucesso.';

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE ou DELETE.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem);
    COMMIT; -- Confirma as mudanças

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_ESPECIALIDADE;



BEGIN
    CRUD_ESPECIALIDADE(
        v_operacao           => 'INSERT',           
        v_id_especialidade   => 6,                     
        v_tipo_especialidade => 'Buco-Maxilo', 
        v_descr_especialidade => 'Especialidade focada em cirurgias da face, maxila e mandíbula.' 
    );
END;




