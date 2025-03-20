package com.example.odontofast.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Repository
public class AgendamentoRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void inserirAgendamento(int dentistaId, int usuarioId, Date dataAgendada, String horario, String descricao) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withCatalogName("PKG_AGENDAMENTOS")
                .withProcedureName("INSERIR_AGENDAMENTO");

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("p_dentista_id", dentistaId);
        inParams.put("p_usuario_id", usuarioId);
        inParams.put("p_data_agendada", dataAgendada);
        inParams.put("p_horario_agendado", horario);
        inParams.put("p_descricao", descricao);

        jdbcCall.execute(inParams);
    }

    public void atualizarAgendamento(int idAgendamento, String descricao) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withCatalogName("PKG_AGENDAMENTOS")
                .withProcedureName("ATUALIZAR_AGENDAMENTO");

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("p_id_agendamento", idAgendamento);
        inParams.put("p_descricao", descricao);

        jdbcCall.execute(inParams);
    }

    public void deletarAgendamento(int idAgendamento) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withCatalogName("PKG_AGENDAMENTOS")
                .withProcedureName("DELETAR_AGENDAMENTO");

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("p_id_agendamento", idAgendamento);

        jdbcCall.execute(inParams);
    }
}