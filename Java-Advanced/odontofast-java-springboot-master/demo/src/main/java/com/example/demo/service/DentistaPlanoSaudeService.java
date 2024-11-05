package com.example.demo.service;

import com.example.demo.dto.DentistaPlanoSaudeDTO;
import com.example.demo.entity.DentistaPlanoSaude;

import java.util.List;

public interface DentistaPlanoSaudeService {

    DentistaPlanoSaude associarDentistaAoPlano(DentistaPlanoSaudeDTO dentistaPlanoSaudeDTO);
    List<DentistaPlanoSaude> listarAssociacoes();
    DentistaPlanoSaude obterAssociacaoPorId(Long id);
    DentistaPlanoSaude atualizarAssociacao(Long id, DentistaPlanoSaudeDTO dentistaPlanoSaudeDTO);
    boolean excluirAssociacao(Long id);

}
