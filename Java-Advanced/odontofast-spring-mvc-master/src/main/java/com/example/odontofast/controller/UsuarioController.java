package com.example.odontofast.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UsuarioController {

    @GetMapping("/testes/usuarios")
    public String mostrarPaginaTeste() {
        return "usuario-teste"; // Nome do arquivo HTML
    }
}