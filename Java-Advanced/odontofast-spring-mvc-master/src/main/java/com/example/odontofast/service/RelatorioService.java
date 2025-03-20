package com.example.odontofast.service;

import com.example.odontofast.dto.RelatorioAgendamentoDTO;
import com.example.odontofast.dto.RelatorioTratamentoDTO;
import com.example.odontofast.repository.RelatorioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RelatorioService {

    @Autowired
    private RelatorioRepository relatorioRepository;

    public List<RelatorioTratamentoDTO> listarTratamentos() {
        return relatorioRepository.getRelatorioTratamentos();
    }

    public List<RelatorioAgendamentoDTO> listarAgendamentos() {
        return relatorioRepository.getRelatorioAgendamentos();
    }
}