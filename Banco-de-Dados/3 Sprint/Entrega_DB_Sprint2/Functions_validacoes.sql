--  Fun��es de Valida��o de Entrada de Dados

-- 1 Validar formato da senha, apenas com letras e numeros e a quantidade de caracteres
CREATE OR REPLACE FUNCTION validar_senha_usuario(
    p_id_usuario       IN C_OP_USUARIO.ID_USUARIO%TYPE,
    p_nome_usuario     IN C_OP_USUARIO.NOME_USUARIO%TYPE,
    p_senha_usuario    IN C_OP_USUARIO.SENHA_USUARIO%TYPE,
    p_email_usuario    IN C_OP_USUARIO.EMAIL_USUARIO%TYPE,
    p_nr_carteira      IN C_OP_USUARIO.NR_CARTEIRA%TYPE,
    p_telefone_usuario IN C_OP_USUARIO.TELEFONE_USUARIO%TYPE
) RETURN VARCHAR2 IS
    v_erro_cro_senhaUsuario VARCHAR2(200);
BEGIN
    v_erro_cro_senhaUsuario := NULL;
    
    IF LENGTH(p_senha_usuario) > 20 THEN
        v_erro_cro_senhaUsuario := v_erro_cro_senhaUsuario || 'Senha deve ter 20 caracteres ou menos.';
    ELSIF NOT REGEXP_LIKE(p_senha_usuario, '[A-Z]') OR 
          NOT REGEXP_LIKE(p_senha_usuario, '[a-z]') OR 
          NOT REGEXP_LIKE(p_senha_usuario, '[0-9]') THEN
        v_erro_cro_senhaUsuario := v_erro_cro_senhaUsuario || 'Senha deve conter letras mai�sculas, min�sculas e n�meros. ';
    END IF;
            
    RETURN v_erro_cro_senhaUsuario;
END;

------------------------------------------------------------------------------------------------------------------------------

-- 2 Validar formato do CRO do dentista, apenas com numeros e duas letras no final

CREATE OR REPLACE FUNCTION validar_formato_cro(
    p_cro IN C_OP_DENTISTA.CRO%TYPE
) RETURN VARCHAR2 IS
    v_erro_cro VARCHAR2(400);
    v_cro_limpo VARCHAR2(20);
BEGIN
    v_erro_cro := NULL;
    
    IF p_cro IS NULL OR TRIM(p_cro) = '' THEN
        RETURN 'CRO n�o pode estar vazio.';
    END IF;
    
    v_cro_limpo := REGEXP_REPLACE(UPPER(TRIM(p_cro)), '[^0-9A-Z]', '');
    
    IF LENGTH(v_cro_limpo) < 4 OR LENGTH(v_cro_limpo) > 8 THEN
        v_erro_cro := v_erro_cro || 'CRO deve ter entre 4 e 8 caracteres. ';
    END IF;
    
    IF NOT REGEXP_LIKE(v_cro_limpo, '^\d+[A-Z]{2}$') THEN
        v_erro_cro := v_erro_cro || 'CRO deve conter apenas n�meros seguidos de duas letras para a UF. ';
    END IF;
    
    IF v_erro_cro IS NOT NULL THEN
        RETURN v_erro_cro;
    ELSE
        RETURN NULL;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Erro durante a valida��o do CRO.';
END;
