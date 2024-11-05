package com.example.demo.service;

import com.example.demo.dto.AgendamentoDTO;
import java.util.List;

public interface AgendamentoService {

    AgendamentoDTO criarAgendamento(AgendamentoDTO agendamentoDTO);
    AgendamentoDTO obterAgendamentoPorId(Long id);
    List<AgendamentoDTO> listarAgendamentos();
    AgendamentoDTO atualizarAgendamento(Long id, AgendamentoDTO agendamentoDTO);
    void excluirAgendamento(Long id);

}
