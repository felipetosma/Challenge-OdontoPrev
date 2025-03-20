package com.example.odontofast.controller;

import com.example.odontofast.dto.RelatorioAgendamentoDTO;
import com.example.odontofast.dto.RelatorioTratamentoDTO;
import com.example.odontofast.service.RelatorioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/relatorios")
public class RelatorioController {

    @Autowired
    private RelatorioService relatorioService;

    @GetMapping("/tratamentos")
    public String mostrarRelatorioTratamentos(Model model) {
        List<RelatorioTratamentoDTO> tratamentos = relatorioService.listarTratamentos();
        model.addAttribute("tratamentos", tratamentos);
        return "relatorio-tratamentos";
    }

    @GetMapping("/agendamentos")
    public String mostrarRelatorioAgendamentos(Model model) {
        List<RelatorioAgendamentoDTO> agendamentos = relatorioService.listarAgendamentos();
        System.out.println("Agendamentos no controller: " + (agendamentos != null ? agendamentos.size() : "null"));
        model.addAttribute("agendamentos", agendamentos);
        return "relatorio-agendamentos";
    }

    // Novo método para relatórios combinados
    @GetMapping("/combinados")
    public String mostrarRelatoriosCombinados(Model model) {
        List<RelatorioTratamentoDTO> tratamentos = relatorioService.listarTratamentos();
        List<RelatorioAgendamentoDTO> agendamentos = relatorioService.listarAgendamentos();

        model.addAttribute("tratamentos", tratamentos);
        model.addAttribute("agendamentos", agendamentos);

        return "relatorios";
    }
}