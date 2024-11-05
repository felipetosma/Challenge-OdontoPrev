package com.example.demo.service;

import com.example.demo.dto.AgendamentoDTO;
import com.example.demo.entity.Agendamento;
import com.example.demo.entity.Dentista;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.AgendamentoRepository;
import com.example.demo.repository.DentistaRepository;
import com.example.demo.repository.UsuarioRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AgendamentoServiceImpl implements AgendamentoService {

    @Autowired
    private AgendamentoRepository agendamentoRepository;

    @Autowired
    private DentistaRepository dentistaRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    public AgendamentoDTO criarAgendamento(AgendamentoDTO agendamentoDTO) {
        Agendamento agendamento = mapearDTOParaEntidade(agendamentoDTO);
        agendamento = agendamentoRepository.save(agendamento);
        return mapearEntidadeParaDTO(agendamento);
    }

    @Override
    public AgendamentoDTO obterAgendamentoPorId(Long id) {
        Agendamento agendamento = agendamentoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Agendamento não encontrado com ID: " + id));
        return mapearEntidadeParaDTO(agendamento);
    }

    @Override
    public List<AgendamentoDTO> listarAgendamentos() {
        List<Agendamento> agendamentos = agendamentoRepository.findAll();
        return agendamentos.stream()
                .map(this::mapearEntidadeParaDTO)
                .collect(Collectors.toList());
    }

    @Override
    public AgendamentoDTO atualizarAgendamento(Long id, AgendamentoDTO agendamentoDTO) {
        Agendamento agendamento = agendamentoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Agendamento não encontrado com ID: " + id));
        agendamento = mapearDTOParaEntidade(agendamentoDTO, agendamento);
        agendamento = agendamentoRepository.save(agendamento);
        return mapearEntidadeParaDTO(agendamento);
    }

    @Override
    public void excluirAgendamento(Long id) {
        agendamentoRepository.deleteById(id);
    }

    // Método privado para converter entidade em DTO
    private AgendamentoDTO mapearEntidadeParaDTO(Agendamento agendamento) {
        return new AgendamentoDTO(
                agendamento.getIdAgendamento(),
                agendamento.getDataAgendada(),
                agendamento.getHorarioAgendado(),
                agendamento.getStatusTratamento(),
                agendamento.getDescricaoAgendamento(),
                agendamento.getDentista().getIdDentista(),
                agendamento.getUsuario().getIdUsuario()
        );
    }

    // Método privado para mapear DTO para a entidade
    private Agendamento mapearDTOParaEntidade(AgendamentoDTO agendamentoDTO) {

        if (agendamentoDTO.getDentistaId() == null || agendamentoDTO.getUsuarioId() == null) {
            throw new IllegalArgumentException("Os IDs de Dentista e Usuário não podem ser nulos.");
        }

        // Busca as entidades no banco de dados
        Dentista dentista = dentistaRepository.findById(agendamentoDTO.getDentistaId())
                .orElseThrow(() -> new EntityNotFoundException("Dentista não encontrado com ID: " + agendamentoDTO.getDentistaId()));

        Usuario usuario = usuarioRepository.findById(agendamentoDTO.getUsuarioId())
                .orElseThrow(() -> new EntityNotFoundException("Usuário não encontrado com ID: " + agendamentoDTO.getUsuarioId()));

        // Criação do Agendamento
        Agendamento agendamento = new Agendamento();
        agendamento.setDataAgendada(agendamentoDTO.getDataAgendada());
        agendamento.setHorarioAgendado(agendamentoDTO.getHorarioAgendado());
        agendamento.setDescricaoAgendamento(agendamentoDTO.getDescricaoAgendamento());
        agendamento.setDentista(dentista);
        agendamento.setUsuario(usuario);
        agendamento.setStatusTratamento(agendamentoDTO.getStatusTratamento());

        return agendamento;
    }

    // Método privado para mapear DTO para a entidade (atualizando um agendamento existente)
    private Agendamento mapearDTOParaEntidade(AgendamentoDTO agendamentoDTO, Agendamento agendamento) {
        agendamento.setDataAgendada(agendamentoDTO.getDataAgendada());
        agendamento.setHorarioAgendado(agendamentoDTO.getHorarioAgendado());
        agendamento.setDescricaoAgendamento(agendamentoDTO.getDescricaoAgendamento());
        agendamento.setStatusTratamento(agendamentoDTO.getStatusTratamento());

        // Busca as entidades associadas
        Dentista dentista = dentistaRepository.findById(agendamentoDTO.getDentistaId())
                .orElseThrow(() -> new EntityNotFoundException("Dentista não encontrado com ID: " + agendamentoDTO.getDentistaId()));
        Usuario usuario = usuarioRepository.findById(agendamentoDTO.getUsuarioId())
                .orElseThrow(() -> new EntityNotFoundException("Usuário não encontrado com ID: " + agendamentoDTO.getUsuarioId()));

        agendamento.setDentista(dentista);
        agendamento.setUsuario(usuario);

        return agendamento;
    }
}
