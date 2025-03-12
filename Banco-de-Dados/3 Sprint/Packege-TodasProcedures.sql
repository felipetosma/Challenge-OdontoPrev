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
        v_telefone c_op_plano