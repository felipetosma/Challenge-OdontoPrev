Set SERVEROUTPUT    on;

CREATE OR REPLACE PROCEDURE CRUD_TIPO_PLANO (
    v_operacao       IN VARCHAR2,
    v_id_tipo_plano  IN c_op_tipo_plano.id_tipo_plano%TYPE,
    v_nome_tipo_plano IN c_op_tipo_plano.nome_tipo_plano%TYPE,
    v_descr_tipo_plano IN c_op_tipo_plano.descr_tipo_plano%TYPE
) IS
    v_mensagem VARCHAR2(255);
BEGIN
    IF v_operacao = 'INSERT' THEN
        INSERT INTO c_op_tipo_plano (
            id_tipo_plano,
            nome_tipo_plano,
            descr_tipo_plano
        ) VALUES (
            v_id_tipo_plano,
            v_nome_tipo_plano,
            v_descr_tipo_plano
        );
        v_mensagem := 'Tipo de plano inserido com sucesso.';

    ELSIF v_operacao = 'UPDATE' THEN
        UPDATE c_op_tipo_plano
        SET nome_tipo_plano = v_nome_tipo_plano,
            descr_tipo_plano = v_descr_tipo_plano
        WHERE id_tipo_plano = v_id_tipo_plano;
        v_mensagem := 'Registro atualizado com sucesso.';

    ELSIF v_operacao = 'DELETE' THEN
        DELETE FROM c_op_tipo_plano
        WHERE id_tipo_plano = v_id_tipo_plano;
        v_mensagem := 'Registro deletado com sucesso.';

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE ou DELETE.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_mensagem);
    COMMIT; -- Confirma as mudanças

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
END CRUD_TIPO_PLANO;


BEGIN
    CRUD_TIPO_PLANO(
        v_operacao       => 'INSERT',
        v_id_tipo_plano  => 10,                
        v_nome_tipo_plano => 'Emergencial',  
        v_descr_tipo_plano => 'Para fins de emergencias inesperadas.'
    );
END;





