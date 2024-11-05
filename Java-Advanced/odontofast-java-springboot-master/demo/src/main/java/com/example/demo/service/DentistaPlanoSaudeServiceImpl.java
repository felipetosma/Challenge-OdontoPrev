package com.example.demo.service;

import com.example.demo.dto.DentistaPlanoSaudeDTO;
import com.example.demo.entity.Dentista;
import com.example.demo.entity.PlanoDeSaude;
import com.example.demo.entity.DentistaPlanoSaude;
import com.example.demo.repository.DentistaRepository;
import com.example.demo.repository.PlanoDeSaudeRepository;
import com.example.demo.repository.DentistaPlanoSaudeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DentistaPlanoSaudeServiceImpl implements DentistaPlanoSaudeService {

    @Autowired
    private DentistaPlanoSaudeRepository dentistaPlanoSaudeRepository;

    @Autowired
    private DentistaRepository dentistaRepository;

    @Autowired
    private PlanoDeSaudeRepository planoDeSaudeRepository;

    @Override
    public DentistaPlanoSaude associarDentistaAoPlano(DentistaPlanoSaudeDTO dentistaPlanoSaudeDTO) {
        Dentista dentista = dentistaRepository.findById(dentistaPlanoSaudeDTO.getDentistaId())
                .orElseThrow(() -> new IllegalArgumentException("Dentista não encontrado"));
        PlanoDeSaude planoDeSaude = planoDeSaudeRepository.findById(dentistaPlanoSaudeDTO.getPlanoId())
                .orElseThrow(() -> new IllegalArgumentException("Plano de saúde não encontrado"));

        DentistaPlanoSaude associacao = new DentistaPlanoSaude();
        associacao.setDentista(dentista);
        associacao.setPlanoDeSaude(planoDeSaude);

        return dentistaPlanoSaudeRepository.save(associacao);
    }

    @Override
    public List<DentistaPlanoSaude> listarAssociacoes() {
        return dentistaPlanoSaudeRepository.findAll(); // Retorna todas as associações
    }

    @Override
    public DentistaPlanoSaude obterAssociacaoPorId(Long id) {
        return dentistaPlanoSaudeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Associação não encontrada"));
    }

    @Override
    public DentistaPlanoSaude atualizarAssociacao(Long id, DentistaPlanoSaudeDTO dentistaPlanoSaudeDTO) {
        DentistaPlanoSaude associacaoExistente = dentistaPlanoSaudeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Associação não encontrada"));

        associacaoExistente.setDentista(dentistaRepository.findById(dentistaPlanoSaudeDTO.getDentistaId())
                .orElseThrow(() -> new IllegalArgumentException("Dentista não encontrado")));
        associacaoExistente.setPlanoDeSaude(planoDeSaudeRepository.findById(dentistaPlanoSaudeDTO.getPlanoId())
                .orElseThrow(() -> new IllegalArgumentException("Plano de saúde não encontrado")));

        return dentistaPlanoSaudeRepository.save(associacaoExistente);
    }

    @Override
    public boolean excluirAssociacao(Long id) {
        if (dentistaPlanoSaudeRepository.existsById(id)) {
            dentistaPlanoSaudeRepository.deleteById(id);
            return true; // Excluído com sucesso
        } else {
            return false; // Não encontrado
        }
    }
}
