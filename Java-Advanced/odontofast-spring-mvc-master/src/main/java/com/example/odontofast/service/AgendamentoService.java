package com.example.odontofast.service;

import com.example.odontofast.repository.AgendamentoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class AgendamentoService {

    @Autowired
    private AgendamentoRepository repository;

    public void inserirAgendamento(int dentistaId, int usuarioId, Date dataAgendada, String horario, String descricao) {
        repository.inserirAgendamento(dentistaId, usuarioId, dataAgendada, horario, descricao);
    }

    public void atualizarAgendamento(int idAgendamento, String descricao) {
        repository.atualizarAgendamento(idAgendamento, descricao);
    }

    public void deletarAgendamento(int idAgendamento) {
        repository.deletarAgendamento(idAgendamento);
    }
}
