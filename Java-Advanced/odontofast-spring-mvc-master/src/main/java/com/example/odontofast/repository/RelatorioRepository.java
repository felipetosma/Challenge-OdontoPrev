package com.example.odontofast.repository;

import com.example.odontofast.dto.RelatorioAgendamentoDTO;
import com.example.odontofast.dto.RelatorioTratamentoDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

import static org.hibernate.dialect.OracleTypes.CURSOR;

@Repository
public class RelatorioRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<RelatorioAgendamentoDTO> getRelatorioAgendamentos() {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("prc_relatorio_agendamentos_plano")
                .declareParameters(
                        new SqlOutParameter("p_cursor", CURSOR,
                                (rs, rowNum) -> new RelatorioAgendamentoDTO(
                                        rs.getString("nome_plano"),
                                        rs.getString("nome_tipo_plano"),
                                        rs.getInt("total_agendamentos"),
                                        rs.getString("nome_dentista"),
                                        rs.getString("categoria_volume")
                                ))
                );

        Map<String, Object> result = jdbcCall.execute();
        return (List<RelatorioAgendamentoDTO>) result.get("p_cursor");
    }

    // Mantém o método para tratamentos (ajustado da mesma forma, se necessário)
    public List<RelatorioTratamentoDTO> getRelatorioTratamentos() {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("prc_relatorio_tratamentos_dentista")
                .declareParameters(
                        new SqlOutParameter("p_cursor", CURSOR,
                                (rs, rowNum) -> new RelatorioTratamentoDTO(
                                        rs.getString("nome_dentista"),
                                        rs.getString("tipo_especialidade"),
                                        rs.getInt("total_tratamentos"),
                                        rs.getDouble("media_dias_tratamento"),
                                        rs.getString("nome_plano"),
                                        rs.getString("status_especialidade")
                                ))
                );

        Map<String, Object> result = jdbcCall.execute();
        return (List<RelatorioTratamentoDTO>) result.get("p_cursor");
    }
}