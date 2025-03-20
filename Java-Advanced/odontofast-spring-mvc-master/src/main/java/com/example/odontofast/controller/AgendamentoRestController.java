package com.example.odontofast.controller;

import com.example.odontofast.service.AgendamentoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/api/agendamentos")
public class AgendamentoRestController {

    @Autowired
    private AgendamentoService service;

    @PostMapping("/inserir")
    public ResponseEntity<String> inserirAgendamento(
            @RequestParam("dentistaId") int dentistaId,
            @RequestParam("usuarioId") int usuarioId,
            @RequestParam("dataAgendada") @DateTimeFormat(pattern = "yyyy-MM-dd") Date dataAgendada,
            @RequestParam("horario") String horario,
            @RequestParam("descricao") String descricao) {
        try {
            service.inserirAgendamento(dentistaId, usuarioId, dataAgendada, horario, descricao);
            return ResponseEntity.ok("Inserção concluída: " + descricao);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Erro ao inserir: " + e.getMessage());
        }
    }

    @PostMapping("/atualizar")
    public ResponseEntity<String> atualizarAgendamento(
            @RequestParam("idAgendamento") int idAgendamento,
            @RequestParam("descricao") String descricao) {
        try {
            service.atualizarAgendamento(idAgendamento, descricao);
            return ResponseEntity.ok("Atualização concluída: ID " + idAgendamento);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Erro ao atualizar: " + e.getMessage());
        }
    }

    @PostMapping("/deletar")
    public ResponseEntity<String> deletarAgendamento(
            @RequestParam("idAgendamento") int idAgendamento) {
        try {
            service.deletarAgendamento(idAgendamento);
            return ResponseEntity.ok("Exclusão concluída: ID " + idAgendamento);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Erro ao deletar: " + e.getMessage());
        }
    }
}