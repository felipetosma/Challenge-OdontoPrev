package com.example.demo.service;

import com.example.demo.entity.PlanoDeSaude;
import java.util.List;

public interface PlanoDeSaudeService {

    PlanoDeSaude criarPlanoDeSaude(PlanoDeSaude planoDeSaude);
    PlanoDeSaude obterPlanoDeSaudePorId(Long id);
    List<PlanoDeSaude> listarPlanosDeSaude();
    PlanoDeSaude atualizarPlanoDeSaude(Long id, PlanoDeSaude planoDeSaude);
    void excluirPlanoDeSaude(Long id);

}
