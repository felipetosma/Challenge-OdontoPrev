CREATE OR REPLACE PACKAGE pkg_dental_clinic IS
    -- CRUD Operations for User management
    PROCEDURE crud_usuario(
        v_operacao         IN VARCHAR2,
        v_id_usuario       IN c_op_usuario.id_usuario%TYPE,
        v_nome_usuario     IN c_op_usuario.nome_usuario%TYPE DEFAULT NULL,
        v_senha_usuario    IN c_op_usuario.senha_usuario%TYPE DEFAULT NULL,
        v_email_usuario    IN c_op_usuario.email_usuario%TYPE DEFAULT NULL,
        v_nr_carteira      IN c_op_usuario.nr_carteira%TYPE DEFAULT NULL,
        v_telefone_usuario IN c_op_usuario.telefone_usuario%TYPE DEFAULT NULL
    );
    
    -- CRUD Operations for Dentist management
    PROCEDURE crud_dentista(
        v_operacao          IN VARCHAR2,
        v_id_dentista       IN c_op_dentista.id_dentista%TYPE,
        v_nome_dentista     IN c_op_dentista.nome_dentista%TYPE DEFAULT NULL,
        v_senha_dentista    IN c_op_dentista.senha_dentista%TYPE DEFAULT NULL,
        v_cro               IN c_op_dentista.cro%TYPE DEFAULT NULL,
        v_telefone_dentista IN c_op_dentista.telefone_dentista%TYPE DEFAULT NULL,
        v_email_dentista    IN c_op_dentista.email_dentista%TYPE DEFAULT NULL,
        v_id_especialidade  IN c_op_dentista.id_especialidade%TYPE DEFAULT NULL
    );
    
    -- CRUD Operations for Specialty management
    PROCEDURE crud_especialidade(
        v_operacao           IN VARCHAR2,
        v_id_especialidade   IN c_op_especialidade.id_especialidade%TYPE,
        v_tipo_especialidade IN c_op_especialidade.tipo_especialidade%TYPE DEFAULT NULL,
        v_descr_especialidade IN c_op_especialidade.descr_especialidade%TYPE DEFAULT NULL
    );
    
    -- CRUD Operations for Checklist management
    PROCEDURE crud_checklist(
        v_operacao        IN VARCHAR2,
        v_id_checklist    IN c_op_checklist.id_checklist%TYPE,
        v_nivel           IN c_op_checklist.nivel%TYPE DEFAULT NULL,
        v_escovacao_dentes IN c_op_checklist.escovacao_dentes%TYPE DEFAULT NULL,
        v_fio_dental      IN c_op_checklist.fio_dental%TYPE DEFAULT NULL,
        v_enxaguante_bucal IN c_op_checklist.enxaguante_bucal%TYPE DEFAULT NULL,
        v_id_usuario      IN c_op_usuario.id_usuario%TYPE DEFAULT NULL
    );
    
    -- CRUD Operations for Status management
    PROCEDURE crud_status(
        v_operacao      IN VARCHAR2,
        v_id_status     IN c_op_status.id_status%TYPE,
        v_tipo_status   IN c_op_status.tipo_status%TYPE DEFAULT NULL,
        v_descr_status  IN c_op_status.descr_status%TYPE DEFAULT NULL
    );
    
    -- CRUD Operations for Plan Type management
    PROCEDURE crud_tipo_plano(
        v_operacao       IN VARCHAR2,
        v_id_tipo_plano  IN c_op_tipo_plano.id_tipo_plano%TYPE,
        v_nome_tipo_plano IN c_op_tipo_plano.nome_tipo_plano%TYPE DEFAULT NULL,
        v_descr_tipo_plano IN c_op_tipo_plano.descr_tipo_plano%TYPE DEFAULT NULL
    );
    
    -- CRUD Operations for Health Plan management
    PROCEDURE crud_plano_saude(
        v_operacao        IN VARCHAR2,
        v_id_plano        IN c_op_plano_de_saude.id_plano%TYPE,
        v_nome_plano      IN c_op_plano_de_saude.nome_plano%TYPE DEFAULT NULL,
        v_telefone_plano   IN c_op_plano_de_saude.telefone_plano%TYPE DEFAULT NULL,
        v_email_plano     IN c_op_plano_de_saude.email_plano%TYPE DEFAULT NULL,
        v_id_tipo_plano   IN c_op_plano_de_saude.id_tipo_plano%TYPE DEFAULT NULL
    );
    
    -- CRUD Operations for Notification management
    PROCEDURE crud_notificacao(
        v_operacao        IN VARCHAR2,
        v_id_notificacao   IN c_op_notificacao.id_notificacao%TYPE,
        v_mensagem        IN c_op_notificacao.mensagem%TYPE DEFAULT NULL,
        v_data_envio      IN c_op_notificacao.data_envio%TYPE DEFAULT NULL,
        v_leitura         IN c_op_notificacao.leitura%TYPE DEFAULT NULL
    );
    
    -- CRUD Operations for Treatment management
    PROCEDURE crud_tratamento(
        v_operacao          IN VARCHAR2,
        v_id_tratamento     IN c_op_tratamento.id_tratamento%TYPE,
        v_tipo_tratamento   IN c_op_tratamento.tipo_tratamento%TYPE DEFAULT NULL,
        v_dt_inicio_tratamento IN c_op_tratamento.dt_inicio_tratamento%TYPE DEFAULT NULL,
        v_dt_termino_tratamento IN c_op_tratamento.dt_termino_tratamento%TYPE DEFAULT NULL,
        v_descr_tratamento   IN c_op_tratamento.descr_tratamento%TYPE DEFAULT NULL,
        v_id_dentista       IN c_op_tratamento.id_dentista%TYPE DEFAULT NULL,
        v_id_usuario        IN c_op_tratamento.id_usuario%TYPE DEFAULT NULL,
        v_id_notificacao    IN c_op_tratamento.id_notificacao%TYPE DEFAULT NULL,
        v_id_status         IN c_op_tratamento.id_status%TYPE DEFAULT NULL,
        v_id_plano          IN c_op_tratamento.id_plano%TYPE DEFAULT NULL
    );
    
    -- CRUD Operations for Appointment management
    PROCEDURE crud_agendamento(
        v_operacao        IN VARCHAR2,
        v_id_agendamento   IN c_op_agendamento.id_agendamento%TYPE,
        v_data_agendada    IN c_op_agendamento.data_agendada%TYPE DEFAULT NULL,
        v_horario_agendado IN c_op_agendamento.horario_agendado%TYPE DEFAULT NULL,
        v_id_status        IN c_op_agendamento.id_status%TYPE DEFAULT NULL,
        v_id_tratamento    IN c_op_agendamento.id_tratamento%TYPE DEFAULT NULL
    );
    
    -- Reports
    PROCEDURE prc_relatorio_agendamentos_plano;
    PROCEDURE prc_relatorio_tratamentos_dentista;
    
    -- Functions for reporting
    FUNCTION relatorio_tratamentos RETURN tratamento_usuario_tab;
    FUNCTION gerar_relatorio_agendamentos_dia RETURN tabela_relatorio_agendamentos_dia_extendido PIPELINED;
    
    -- Validation functions
    FUNCTION validar_senha_usuario(
        p_id_usuario       IN C_OP_USUARIO.ID_USUARIO%TYPE,
        p_nome_usuario     IN C_OP_USUARIO.NOME_USUARIO%TYPE,
        p_senha_usuario    IN C_OP_USUARIO.SENHA_USUARIO%TYPE,
        p_email_usuario    IN C_OP_USUARIO.EMAIL_USUARIO%TYPE,
        p_nr_carteira      IN C_OP_USUARIO.NR_CARTEIRA%TYPE,
        p_telefone_usuario IN C_OP_USUARIO.TELEFONE_USUARIO%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION validar_formato_cro(
        p_cro IN C_OP_DENTISTA.CRO%TYPE
    ) RETURN VARCHAR2;
    
END pkg_dental_clinic;
/

CREATE OR REPLACE PACKAGE BODY pkg_dental_clinic IS

    -- CRUD Operations for User management
    PROCEDURE crud_usuario(
        v_operacao         IN VARCHAR2,
        v_id_usuario       IN c_op_usuario.id_usuario%TYPE,
        v_nome_usuario     IN c_op_usuario.nome_usuario%TYPE DEFAULT NULL,
        v_senha_usuario    IN c_op_usuario.senha_usuario%TYPE DEFAULT NULL,
        v_email_usuario    IN c_op_usuario.email_usuario%TYPE DEFAULT NULL,
        v_nr_carteira      IN c_op_usuario.nr_carteira%TYPE DEFAULT NULL,
        v_telefone_usuario IN c_op_usuario.telefone_usuario%TYPE DEFAULT NULL
    ) IS
        v_mensagem VARCHAR2(255);
        v_erro_senha VARCHAR2(200);
        -- Variáveis para o SELECT
        v_result_nome       c_op_usuario.nome_usuario%TYPE;
        v_result_senha      c_op_usuario.senha_usuario%TYPE;
        v_result_email      c_op_usuario.email_usuario%TYPE;
        v_result_carteira   c_op_usuario.nr_carteira%TYPE;
        v_result_telefone   c_op_usuario.telefone_usuario%TYPE;
    BEGIN
        -- Validação da senha para INSERT e UPDATE
        IF v_operacao = 'INSERT' OR v_operacao = 'UPDATE' THEN
            v_erro_senha := validar_senha_usuario(
                p_id_usuario       => v_id_usuario,
                p_nome_usuario     => v_nome_usuario,
                p_senha_usuario    => v_senha_usuario,
                p_email_usuario    => v_email_usuario,
                p_nr_carteira      => v_nr_carteira,
                p_telefone_usuario => v_telefone_usuario
            );

            IF v_erro_senha IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20003, v_erro_senha);
            END IF;
        END IF;

        IF v_operacao = 'INSERT' THEN
            INSERT INTO c_op_usuario (
                id_usuario,
                nome_usuario,
                senha_usuario,
                email_usuario,
                nr_carteira,
                telefone_usuario
            ) VALUES (
                v_id_usuario,
                v_nome_usuario,
                v_senha_usuario,
                v_email_usuario,
                v_nr_carteira,
                v_telefone_usuario
            );
            v_mensagem := 'Usuário inserido com sucesso.';

        ELSIF v_operacao = 'UPDATE' THEN
            UPDATE c_op_usuario
            SET nome_usuario     = v_nome_usuario,
                senha_usuario    = v_senha_usuario,
                email_usuario    = v_email_usuario,
                nr_carteira      = v_nr_carteira,
                telefone_usuario = v_telefone_usuario
            WHERE id_usuario = v_id_usuario;
            v_mensagem := 'Usuário atualizado com sucesso.';

        ELSIF v_operacao = 'DELETE' THEN
            DELETE FROM c_op_usuario
            WHERE id_usuario = v_id_usuario;
            v_mensagem := 'Usuário deletado com sucesso.';

        ELSIF v_operacao = 'SELECT' THEN
            BEGIN
                SELECT nome_usuario, senha_usuario, email_usuario, nr_carteira, telefone_usuario
                INTO v_result_nome, v_result_senha, v_result_email, v_result_carteira, v_result_telefone
                FROM c_op_usuario
                WHERE id_usuario = v_id_usuario;

                DBMS_OUTPUT.PUT_LINE('Nome: ' || v_result_nome);
                DBMS_OUTPUT.PUT_LINE('Senha: ' || v_result_senha);
                DBMS_OUTPUT.PUT_LINE('Email: ' || v_result_email);
                DBMS_OUTPUT.PUT_LINE('Carteira: ' || v_result_carteira);
                DBMS_OUTPUT.PUT_LINE('Telefone: ' || v_result_telefone);

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Usuário não encontrado com o ID especificado.');
            END;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        IF v_operacao != 'SELECT' THEN
            DBMS_OUTPUT.PUT_LINE(v_mensagem);
            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
            ROLLBACK;
    END crud_usuario;
    
    -- CRUD Operations for Dentist management
    PROCEDURE crud_dentista(
        v_operacao          IN VARCHAR2,
        v_id_dentista       IN c_op_dentista.id_dentista%TYPE,
        v_nome_dentista     IN c_op_dentista.nome_dentista%TYPE DEFAULT NULL,
        v_senha_dentista    IN c_op_dentista.senha_dentista%TYPE DEFAULT NULL,
        v_cro               IN c_op_dentista.cro%TYPE DEFAULT NULL,
        v_telefone_dentista IN c_op_dentista.telefone_dentista%TYPE DEFAULT NULL,
        v_email_dentista    IN c_op_dentista.email_dentista%TYPE DEFAULT NULL,
        v_id_especialidade  IN c_op_dentista.id_especialidade%TYPE DEFAULT NULL
    ) IS
        v_erro_cro VARCHAR2(400);
        v_mensagem VARCHAR2(255);

        -- Variáveis para o SELECT
        v_result_nome         c_op_dentista.nome_dentista%TYPE;
        v_result_senha        c_op_dentista.senha_dentista%TYPE;
        v_result_cro          c_op_dentista.cro%TYPE;
        v_result_telefone     c_op_dentista.telefone_dentista%TYPE;
        v_result_email        c_op_dentista.email_dentista%TYPE;
        v_result_especialidade c_op_dentista.id_especialidade%TYPE;
    BEGIN
        -- Validação do CRO para INSERT e UPDATE
        IF v_operacao = 'INSERT' OR v_operacao = 'UPDATE' THEN
            v_erro_cro := validar_formato_cro(v_cro);

            IF v_erro_cro IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20003, v_erro_cro);
            END IF;
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

        ELSIF v_operacao = 'SELECT' THEN
            BEGIN
                SELECT nome_dentista, senha_dentista, cro, telefone_dentista, email_dentista, id_especialidade
                INTO v_result_nome, v_result_senha, v_result_cro, v_result_telefone, v_result_email, v_result_especialidade
                FROM c_op_dentista
                WHERE id_dentista = v_id_dentista;

                DBMS_OUTPUT.PUT_LINE('Nome: ' || v_result_nome);
                DBMS_OUTPUT.PUT_LINE('Senha: ' || v_result_senha);
                DBMS_OUTPUT.PUT_LINE('CRO: ' || v_result_cro);
                DBMS_OUTPUT.PUT_LINE('Telefone: ' || v_result_telefone);
                DBMS_OUTPUT.PUT_LINE('Email: ' || v_result_email);
                DBMS_OUTPUT.PUT_LINE('Especialidade ID: ' || v_result_especialidade);

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Dentista não encontrado com o ID especificado.');
            END;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        IF v_operacao != 'SELECT' THEN
            DBMS_OUTPUT.PUT_LINE(v_mensagem);
            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
            ROLLBACK;
    END crud_dentista;
    
    -- CRUD Operations for Specialty management
    PROCEDURE crud_especialidade(
        v_operacao           IN VARCHAR2,
        v_id_especialidade   IN c_op_especialidade.id_especialidade%TYPE,
        v_tipo_especialidade IN c_op_especialidade.tipo_especialidade%TYPE DEFAULT NULL,
        v_descr_especialidade IN c_op_especialidade.descr_especialidade%TYPE DEFAULT NULL
    ) IS
        v_mensagem VARCHAR2(255);
        -- Variáveis para SELECT
        v_result_tipo      c_op_especialidade.tipo_especialidade%TYPE;
        v_result_descr     c_op_especialidade.descr_especialidade%TYPE;
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
            v_mensagem := 'Especialidade atualizada com sucesso.';

        ELSIF v_operacao = 'DELETE' THEN
            DELETE FROM c_op_especialidade
            WHERE id_especialidade = v_id_especialidade;
            v_mensagem := 'Especialidade deletada com sucesso.';

        ELSIF v_operacao = 'SELECT' THEN
            BEGIN
                SELECT tipo_especialidade, descr_especialidade
                INTO v_result_tipo, v_result_descr
                FROM c_op_especialidade
                WHERE id_especialidade = v_id_especialidade;

                DBMS_OUTPUT.PUT_LINE('Tipo: ' || v_result_tipo);
                DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_result_descr);

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Especialidade não encontrada com o ID especificado.');
            END;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        IF v_operacao != 'SELECT' THEN
            DBMS_OUTPUT.PUT_LINE(v_mensagem);
            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
    END crud_especialidade;
    
    -- CRUD Operations for Checklist management
    PROCEDURE crud_checklist(
        v_operacao        IN VARCHAR2,
        v_id_checklist    IN c_op_checklist.id_checklist%TYPE,
        v_nivel           IN c_op_checklist.nivel%TYPE DEFAULT NULL,
        v_escovacao_dentes IN c_op_checklist.escovacao_dentes%TYPE DEFAULT NULL,
        v_fio_dental      IN c_op_checklist.fio_dental%TYPE DEFAULT NULL,
        v_enxaguante_bucal IN c_op_checklist.enxaguante_bucal%TYPE DEFAULT NULL,
        v_id_usuario      IN c_op_usuario.id_usuario%TYPE DEFAULT NULL
    ) IS
        v_mensagem VARCHAR2(255);
        -- Variáveis para SELECT
        v_result_nivel          c_op_checklist.nivel%TYPE;
        v_result_escovacao      c_op_checklist.escovacao_dentes%TYPE;
        v_result_fio_dental     c_op_checklist.fio_dental%TYPE;
        v_result_enxaguante     c_op_checklist.enxaguante_bucal%TYPE;
    BEGIN
        IF v_operacao = 'INSERT' THEN
            INSERT INTO c_op_checklist (
                id_checklist,
                nivel,
                escovacao_dentes,
                fio_dental,
                enxaguante_bucal,
                id_usuario
            ) VALUES (
                v_id_checklist,
                v_nivel,
                v_escovacao_dentes,
                v_fio_dental,
                v_enxaguante_bucal,
                v_id_usuario
            );
            v_mensagem := 'Checklist inserido com sucesso.';

        ELSIF v_operacao = 'UPDATE' THEN
            UPDATE c_op_checklist
            SET nivel = v_nivel,
                escovacao_dentes = v_escovacao_dentes,
                fio_dental = v_fio_dental,
                enxaguante_bucal = v_enxaguante_bucal
            WHERE id_checklist = v_id_checklist;
            v_mensagem := 'Registro atualizado com sucesso.';

        ELSIF v_operacao = 'DELETE' THEN
            DELETE FROM c_op_checklist
            WHERE id_checklist = v_id_checklist;
            v_mensagem := 'Registro deletado com sucesso.';

        ELSIF v_operacao = 'SELECT' THEN
            BEGIN
                SELECT nivel, escovacao_dentes, fio_dental, enxaguante_bucal
                INTO v_result_nivel, v_result_escovacao, v_result_fio_dental, v_result_enxaguante
                FROM c_op_checklist
                WHERE id_checklist = v_id_checklist;

                DBMS_OUTPUT.PUT_LINE('Nível: ' || v_result_nivel);
                DBMS_OUTPUT.PUT_LINE('Escovação: ' || v_result_escovacao);
                DBMS_OUTPUT.PUT_LINE('Fio Dental: ' || v_result_fio_dental);
                DBMS_OUTPUT.PUT_LINE('Enxaguante Bucal: ' || v_result_enxaguante);

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Checklist não encontrado com o ID especificado.');
            END;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        IF v_operacao != 'SELECT' THEN
            DBMS_OUTPUT.PUT_LINE(v_mensagem);
            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
    END crud_checklist;
    
    -- CRUD Operations for Status management
    PROCEDURE crud_status(
        v_operacao      IN VARCHAR2,
        v_id_status     IN c_op_status.id_status%TYPE,
        v_tipo_status   IN c_op_status.tipo_status%TYPE DEFAULT NULL,
        v_descr_status  IN c_op_status.descr_status%TYPE DEFAULT NULL
    ) IS
        v_mensagem VARCHAR2(255);
        -- Variáveis para SELECT
        v_result_tipo     c_op_status.tipo_status%TYPE;
        v_result_descr    c_op_status.descr_status%TYPE;
    BEGIN
        IF v_operacao = 'INSERT' THEN
            INSERT INTO c_op_status (
                id_status,
                tipo_status,
                descr_status
            ) VALUES (
                v_id_status,
                v_tipo_status,
                v_descr_status
            );
            v_mensagem := 'Status inserido com sucesso.';

        ELSIF v_operacao = 'UPDATE' THEN
            UPDATE c_op_status
            SET tipo_status = v_tipo_status,
                descr_status = v_descr_status
            WHERE id_status = v_id_status;
            v_mensagem := 'Registro atualizado com sucesso.';

        ELSIF v_operacao = 'DELETE' THEN
            DELETE FROM c_op_status
            WHERE id_status = v_id_status;
            v_mensagem := 'Registro deletado com sucesso.';

        ELSIF v_operacao = 'SELECT' THEN
            BEGIN
                SELECT tipo_status, descr_status
                INTO v_result_tipo, v_result_descr
                FROM c_op_status
                WHERE id_status = v_id_status;

                DBMS_OUTPUT.PUT_LINE('Tipo: ' || v_result_tipo);
                DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_result_descr);

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Status não encontrado com o ID especificado.');
            END;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        IF v_operacao != 'SELECT' THEN
            DBMS_OUTPUT.PUT_LINE(v_mensagem);
            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
    END crud_status;
    
    -- CRUD Operations for Plan Type management
    PROCEDURE crud_tipo_plano(
        v_operacao       IN VARCHAR2,
        v_id_tipo_plano  IN c_op_tipo_plano.id_tipo_plano%TYPE,
        v_nome_tipo_plano IN c_op_tipo_plano.nome_tipo_plano%TYPE DEFAULT NULL,
        v_descr_tipo_plano IN c_op_tipo_plano.descr_tipo_plano%TYPE DEFAULT NULL
    ) IS
        v_mensagem VARCHAR2(255);
        -- Variáveis para SELECT
        v_result_nome    c_op_tipo_plano.nome_tipo_plano%TYPE;
        v_result_descr   c_op_tipo_plano.descr_tipo_plano%TYPE;
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

        ELSIF v_operacao = 'SELECT' THEN
            BEGIN
                SELECT nome_tipo_plano, descr_tipo_plano
                INTO v_result_nome, v_result_descr
                FROM c_op_tipo_plano
                WHERE id_tipo_plano = v_id_tipo_plano;

                DBMS_OUTPUT.PUT_LINE('Nome: ' || v_result_nome);
                DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_result_descr);

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Tipo de plano não encontrado com o ID especificado.');
            END;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        IF v_operacao != 'SELECT' THEN
            DBMS_OUTPUT.PUT_LINE(v_mensagem);
            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
    END crud_tipo_plano;
    
    -- CRUD Operations for Health Plan management
    PROCEDURE crud_plano_saude(
        v_operacao        IN VARCHAR2,
        v_id_plano        IN c_op_plano_de_saude.id_plano%TYPE,
        v_nome_plano      IN c_op_plano_de_saude.nome_plano%TYPE DEFAULT NULL,
        v_telefone_plano   IN c_op_plano_de_saude.telefone_plano%TYPE DEFAULT NULL,
        v_email_plano     IN c_op_plano_de_saude.email_plano%TYPE DEFAULT NULL,
        v_id_tipo_plano   IN c_op_plano_de_saude.id_tipo_plano%TYPE DEFAULT NULL
    ) IS
        v_mensagem VARCHAR2(255);
        v_nome c_op_plano_de_saude.nome_plano%TYPE;
        v_telefone c_op_plano_de_saude.telefone_plano%TYPE;
        v_email c_op_plano_de_saude.email_plano%TYPE;
        v_tipo_plano c_op_plano_de_saude.id_tipo_plano%TYPE;
    BEGIN
        IF v_operacao = 'INSERT' THEN
            INSERT INTO c_op_plano_de_saude (
                id_plano,
                nome_plano,
                telefone_plano,
                email_plano,
                id_tipo_plano
            ) VALUES (
                v_id_plano,
                v_nome_plano,
                v_telefone_plano,
                v_email_plano,
                v_id_tipo_plano
            );
            v_mensagem := 'Plano de saúde inserido com sucesso.';

        ELSIF v_operacao = 'UPDATE' THEN
            UPDATE c_op_plano_de_saude
            SET nome_plano = v_nome_plano,
                telefone_plano = v_telefone_plano,
                email_plano = v_email_plano,
                id_tipo_plano = v_id_tipo_plano
            WHERE id_plano = v_id_plano;
            v_mensagem := 'Plano de saúde atualizado com sucesso.';

        ELSIF v_operacao = 'DELETE' THEN
            DELETE FROM c_op_plano_de_saude
            WHERE id_plano = v_id_plano;
            v_mensagem := 'Plano de saúde deletado com sucesso.';

        ELSIF v_operacao = 'SELECT' THEN
            SELECT nome_plano, telefone_plano, email_plano, id_tipo_plano
            INTO v_nome, v_telefone, v_email, v_tipo_plano
            FROM c_op_plano_de_saude
            WHERE id_plano = v_id_plano;

            DBMS_OUTPUT.PUT_LINE('Plano de saúde encontrado:');
            DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_plano);
            DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome);
            DBMS_OUTPUT.PUT_LINE('Telefone: ' || v_telefone);
            DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
            DBMS_OUTPUT.PUT_LINE('Tipo de Plano ID: ' || v_tipo_plano);
            RETURN;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        DBMS_OUTPUT.PUT_LINE(v_mensagem);
        COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum plano de saúde encontrado com o ID: ' || v_id_plano);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
    END crud_plano_saude;
    
    -- CRUD Operations for Notification management
    PROCEDURE crud_notificacao(
        v_operacao        IN VARCHAR2,
        v_id_notificacao   IN c_op_notificacao.id_notificacao%TYPE,
        v_mensagem        IN c_op_notificacao.mensagem%TYPE DEFAULT NULL,
        v_data_envio      IN c_op_notificacao.data_envio%TYPE DEFAULT NULL,
        v_leitura         IN c_op_notificacao.leitura%TYPE DEFAULT NULL
    ) IS
        v_mensagem_resposta VARCHAR2(255);
        v_msg c_op_notificacao.mensagem%TYPE;
        v_data c_op_notificacao.data_envio%TYPE;
        v_leitura_status c_op_notificacao.leitura%TYPE;
    BEGIN
        IF v_operacao = 'INSERT' THEN
            INSERT INTO c_op_notificacao (
                id_notificacao,
                mensagem,
                data_envio,
                leitura
            ) VALUES (
                v_id_notificacao,
                v_mensagem,
                v_data_envio,
                v_leitura
            );
            v_mensagem_resposta := 'Notificação inserida com sucesso.';

        ELSIF v_operacao = 'UPDATE' THEN
            UPDATE c_op_notificacao
            SET mensagem = v_mensagem,
                data_envio = v_data_envio,
                leitura = v_leitura
            WHERE id_notificacao = v_id_notificacao;
            v_mensagem_resposta := 'Notificação atualizada com sucesso.';

        ELSIF v_operacao = 'DELETE' THEN
            DELETE FROM c_op_notificacao
            WHERE id_notificacao = v_id_notificacao;
            v_mensagem_resposta := 'Notificação deletada com sucesso.';

        ELSIF v_operacao = 'SELECT' THEN
            SELECT mensagem, data_envio, leitura
            INTO v_msg, v_data, v_leitura_status
            FROM c_op_notificacao
            WHERE id_notificacao = v_id_notificacao;

            DBMS_OUTPUT.PUT_LINE('Notificação encontrada:');
            DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_notificacao);
            DBMS_OUTPUT.PUT_LINE('Mensagem: ' || v_msg);
            DBMS_OUTPUT.PUT_LINE('Data de Envio: ' || TO_CHAR(v_data, 'DD/MM/YYYY HH24:MI:SS'));
            DBMS_OUTPUT.PUT_LINE('Leitura: ' || v_leitura_status);
            RETURN;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        DBMS_OUTPUT.PUT_LINE(v_mensagem_resposta);
        COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhuma notificação encontrada com o ID: ' || v_id_notificacao);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
    END crud_notificacao;
    
    -- CRUD Operations for Treatment management
    PROCEDURE crud_tratamento(
        v_operacao          IN VARCHAR2,
        v_id_tratamento     IN c_op_tratamento.id_tratamento%TYPE,
        v_tipo_tratamento   IN c_op_tratamento.tipo_tratamento%TYPE DEFAULT NULL,
        v_dt_inicio_tratamento IN c_op_tratamento.dt_inicio_tratamento%TYPE DEFAULT NULL,
        v_dt_termino_tratamento IN c_op_tratamento.dt_termino_tratamento%TYPE DEFAULT NULL,
        v_descr_tratamento   IN c_op_tratamento.descr_tratamento%TYPE DEFAULT NULL,
        v_id_dentista       IN c_op_tratamento.id_dentista%TYPE DEFAULT NULL,
        v_id_usuario        IN c_op_tratamento.id_usuario%TYPE DEFAULT NULL,
        v_id_notificacao    IN c_op_tratamento.id_notificacao%TYPE DEFAULT NULL,
        v_id_status         IN c_op_tratamento.id_status%TYPE DEFAULT NULL,
        v_id_plano          IN c_op_tratamento.id_plano%TYPE DEFAULT NULL
    ) IS
        v_mensagem_resposta VARCHAR2(255);
        v_tipo              c_op_tratamento.tipo_tratamento%TYPE;
        v_data_inicio       c_op_tratamento.dt_inicio_tratamento%TYPE;
        v_data_termino     c_op_tratamento.dt_termino_tratamento%TYPE;
        v_descricao         c_op_tratamento.descr_tratamento%TYPE;
        v_id_dentista_out   c_op_tratamento.id_dentista%TYPE;
        v_id_usuario_out    c_op_tratamento.id_usuario%TYPE;
        v_id_notificacao_out c_op_tratamento.id_notificacao%TYPE;
        v_id_status_out     c_op_tratamento.id_status%TYPE;
        v_id_plano_out      c_op_tratamento.id_plano%TYPE;
    BEGIN
        IF v_operacao = 'INSERT' THEN
            INSERT INTO c_op_tratamento (
                id_tratamento,
                tipo_tratamento,
                dt_inicio_tratamento,
                dt_termino_tratamento,
                descr_tratamento,
                id_dentista,
                id_usuario,
                id_notificacao,
                id_status,
                id_plano
            ) VALUES (
                v_id_tratamento,
                v_tipo_tratamento,
                v_dt_inicio_tratamento,
                v_dt_termino_tratamento,
                v_descr_tratamento,
                v_id_dentista,
                v_id_usuario,
                v_id_notificacao,
                v_id_status,
                v_id_plano
            );
            v_mensagem_resposta := 'Tratamento inserido com sucesso.';

        ELSIF v_operacao = 'UPDATE' THEN
            UPDATE c_op_tratamento
            SET tipo_tratamento = v_tipo_tratamento,
                dt_inicio_tratamento = v_dt_inicio_tratamento,
                dt_termino_tratamento = v_dt_termino_tratamento,
                descr_tratamento = v_descr_tratamento,
                id_dentista = v_id_dentista,
                id_usuario = v_id_usuario,
                id_notificacao = v_id_notificacao,
                id_status = v_id_status,
                id_plano = v_id_plano
            WHERE id_tratamento = v_id_tratamento;
            v_mensagem_resposta := 'Tratamento atualizado com sucesso.';

        ELSIF v_operacao = 'DELETE' THEN
            DELETE FROM c_op_tratamento
            WHERE id_tratamento = v_id_tratamento;
            v_mensagem_resposta := 'Tratamento deletado com sucesso.';

        ELSIF v_operacao = 'SELECT' THEN
            SELECT tipo_tratamento, dt_inicio_tratamento, dt_termino_tratamento, descr_tratamento,
                   id_dentista, id_usuario, id_notificacao, id_status, id_plano
            INTO v_tipo, v_data_inicio, v_data_termino, v_descricao,
                 v_id_dentista_out, v_id_usuario_out, v_id_notificacao_out, v_id_status_out, v_id_plano_out
            FROM c_op_tratamento
            WHERE id_tratamento = v_id_tratamento;

            DBMS_OUTPUT.PUT_LINE('Tratamento encontrado:');
            DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_tratamento);
            DBMS_OUTPUT.PUT_LINE('Tipo de Tratamento: ' || v_tipo);
            DBMS_OUTPUT.PUT_LINE('Data de Início: ' || TO_CHAR(v_data_inicio, 'DD/MM/YYYY'));
            DBMS_OUTPUT.PUT_LINE('Data de Término: ' || TO_CHAR(v_data_termino, 'DD/MM/YYYY'));
            DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_descricao);
            DBMS_OUTPUT.PUT_LINE('ID Dentista: ' || v_id_dentista_out);
            DBMS_OUTPUT.PUT_LINE('ID Usuário: ' || v_id_usuario_out);
            DBMS_OUTPUT.PUT_LINE('ID Notificação: ' || v_id_notificacao_out);
            DBMS_OUTPUT.PUT_LINE('ID Status: ' || v_id_status_out);
            DBMS_OUTPUT.PUT_LINE('ID Plano: ' || v_id_plano_out);
            RETURN;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        DBMS_OUTPUT.PUT_LINE(v_mensagem_resposta);
        COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum tratamento encontrado com o ID: ' || v_id_tratamento);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
    END crud_tratamento;
    
    -- CRUD Operations for Appointment management
    PROCEDURE crud_agendamento(
        v_operacao        IN VARCHAR2,
        v_id_agendamento   IN c_op_agendamento.id_agendamento%TYPE,
        v_data_agendada    IN c_op_agendamento.data_agendada%TYPE DEFAULT NULL,
        v_horario_agendado IN c_op_agendamento.horario_agendado%TYPE DEFAULT NULL,
        v_id_status        IN c_op_agendamento.id_status%TYPE DEFAULT NULL,
        v_id_tratamento    IN c_op_agendamento.id_tratamento%TYPE DEFAULT NULL
    ) IS
        v_mensagem_resposta VARCHAR2(255);
        v_data_agendada_out c_op_agendamento.data_agendada%TYPE;
        v_horario_agendado_out c_op_agendamento.horario_agendado%TYPE;
        v_id_status_out     c_op_agendamento.id_status%TYPE;
        v_id_tratamento_out c_op_agendamento.id_tratamento%TYPE;
    BEGIN
        IF v_operacao = 'INSERT' THEN
            INSERT INTO c_op_agendamento (
                id_agendamento,
                data_agendada,
                horario_agendado,
                id_status,
                id_tratamento
            ) VALUES (
                v_id_agendamento,
                v_data_agendada,
                v_horario_agendado,
                v_id_status,
                v_id_tratamento
            );
            v_mensagem_resposta := 'Agendamento inserido com sucesso.';

        ELSIF v_operacao = 'UPDATE' THEN
            UPDATE c_op_agendamento
            SET data_agendada = v_data_agendada,
                horario_agendado = v_horario_agendado,
                id_status = v_id_status,
                id_tratamento = v_id_tratamento
            WHERE id_agendamento = v_id_agendamento;
            v_mensagem_resposta := 'Agendamento atualizado com sucesso.';

        ELSIF v_operacao = 'DELETE' THEN
            DELETE FROM c_op_agendamento
            WHERE id_agendamento = v_id_agendamento;
            v_mensagem_resposta := 'Agendamento deletado com sucesso.';

        ELSIF v_operacao = 'SELECT' THEN
            SELECT data_agendada, horario_agendado, id_status, id_tratamento
            INTO v_data_agendada_out, v_horario_agendado_out, v_id_status_out, v_id_tratamento_out
            FROM c_op_agendamento
            WHERE id_agendamento = v_id_agendamento;

            DBMS_OUTPUT.PUT_LINE('Agendamento encontrado:');
            DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_agendamento);
            DBMS_OUTPUT.PUT_LINE('Data Agendada: ' || TO_CHAR(v_data_agendada_out, 'DD/MM/YYYY'));
            DBMS_OUTPUT.PUT_LINE('Horário Agendado: ' || TO_CHAR(v_horario_agendado_out, 'HH24:MI:SS'));
            DBMS_OUTPUT.PUT_LINE('ID Status: ' || v_id_status_out);
            DBMS_OUTPUT.PUT_LINE('ID Tratamento: ' || v_id_tratamento_out);
            RETURN;

        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operação inválida. Utilize INSERT, UPDATE, DELETE ou SELECT.');
        END IF;

        DBMS_OUTPUT.PUT_LINE(v_mensagem_resposta);
        COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum agendamento encontrado com o ID: ' || v_id_agendamento);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao realizar a operação: ' || SQLERRM);
    END crud_agendamento;
    
    -- Report of appointments by health plan
    PROCEDURE prc_relatorio_agendamentos_plano IS
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
    
    -- Report of treatments by dentist
    PROCEDURE prc_relatorio_tratamentos_dentista IS
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
    
    -- Function to get treatment report
    FUNCTION relatorio_tratamentos RETURN tratamento_usuario_tab IS
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
    
    -- Function to generate appointment report by day
    FUNCTION gerar_relatorio_agendamentos_dia RETURN tabela_relatorio_agendamentos_dia_extendido PIPELINED IS
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
    
    -- Validation function for user password
    FUNCTION validar_senha_usuario(
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
            v_erro_cro_senhaUsuario := v_erro_cro_senhaUsuario || 'Senha deve conter letras maiúsculas, minúsculas e números. ';
        END IF;
                
        RETURN v_erro_cro_senhaUsuario;
    END validar_senha_usuario;
    
    -- Validation function for dentist CRO
    FUNCTION validar_formato_cro(
        p_cro IN C_OP_DENTISTA.CRO%TYPE
    ) RETURN VARCHAR2 IS
        v_erro_cro VARCHAR2(400);
        v_cro_limpo VARCHAR2(20);
    BEGIN
        v_erro_cro := NULL;
        
        IF p_cro IS NULL OR TRIM(p_cro) = '' THEN
            RETURN 'CRO não pode estar vazio.';
        END IF;
        
        v_cro_limpo := REGEXP_REPLACE(UPPER(TRIM(p_cro)), '[^0-9A-Z]', '');
        
        IF LENGTH(v_cro_limpo) < 4 OR LENGTH(v_cro_limpo) > 8 THEN
            v_erro_cro := v_erro_cro || 'CRO deve ter entre 4 e 8 caracteres. ';
        END IF;
        
        IF NOT REGEXP_LIKE(v_cro_limpo, '^\d+[A-Z]{2}) THEN
            v_erro_cro := v_erro_cro || 'CRO deve conter apenas números seguidos de duas letras para a UF. ';
        END IF;
        
        IF v_erro_cro IS NOT NULL THEN
            RETURN v_erro_cro;
        ELSE
            RETURN NULL;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Erro durante a validação do CRO.';
    END validar_formato_cro;
    
END pkg_dental_clinic;
/