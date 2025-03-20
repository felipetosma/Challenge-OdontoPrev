package com.example.odontofast.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AgendamentoController {

    @GetMapping("/testes/agendamentos")
    public String mostrarPaginaTeste() {
        return "agendamentos-teste"; // Nome do arquivo HTML
    }
}
