package com.example.demo.service;

import com.example.demo.entity.PlanoDeSaude;
import com.example.demo.repository.PlanoDeSaudeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PlanoDeSaudeServiceImpl implements PlanoDeSaudeService {

    @Autowired
    private PlanoDeSaudeRepository planoDeSaudeRepository;

    @Override
    public PlanoDeSaude criarPlanoDeSaude(PlanoDeSaude planoDeSaude) {
        return planoDeSaudeRepository.save(planoDeSaude);
    }

    @Override
    public PlanoDeSaude obterPlanoDeSaudePorId(Long id) {
        return planoDeSaudeRepository.findById(id).orElse(null);
    }

    @Override
    public List<PlanoDeSaude> listarPlanosDeSaude() {
        return planoDeSaudeRepository.findAll();
    }

    @Override
    public PlanoDeSaude atualizarPlanoDeSaude(Long id, PlanoDeSaude planoDeSaude) {
        planoDeSaude.setIdPlano(id);
        return planoDeSaudeRepository.save(planoDeSaude);
    }

    @Override
    public void excluirPlanoDeSaude(Long id) {
        planoDeSaudeRepository.deleteById(id);
    }
}
