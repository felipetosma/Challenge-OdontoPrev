package com.example.odontofast.controller;

import com.example.odontofast.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.sql.SQLException;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioRestController {

    @Autowired
    private UsuarioService service;

    @PostMapping("/inserir")
    public ResponseEntity<String> inserirUsuario(
            @RequestParam("idUsuario") int idUsuario,
            @RequestParam("nomeUsuario") String nomeUsuario,
            @RequestParam("senhaUsuario") String senhaUsuario,
            @RequestParam("emailUsuario") String emailUsuario,
            @RequestParam("nrCarteira") String nrCarteira,
            @RequestParam("telefoneUsuario") String telefoneUsuario) {

        try {
            service.inserirUsuario(idUsuario, nomeUsuario, senhaUsuario, emailUsuario, nrCarteira, telefoneUsuario);
            return ResponseEntity.ok("Inserção concluída: " + nomeUsuario);
        } catch (Exception e) {
            // Extrair a mensagem real de erro do Oracle (pode estar encapsulada)
            String mensagemErro = extrairMensagemErro(e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Erro ao inserir: " + mensagemErro);
        }
    }

    @PostMapping("/atualizar")
    public ResponseEntity<String> atualizarUsuario(
            @RequestParam("idUsuario") int idUsuario,
            @RequestParam("nomeUsuario") String nomeUsuario,
            @RequestParam("senhaUsuario") String senhaUsuario,
            @RequestParam("emailUsuario") String emailUsuario,
            @RequestParam("nrCarteira") String nrCarteira,
            @RequestParam("telefoneUsuario") String telefoneUsuario) {

        try {
            service.atualizarUsuario(idUsuario, nomeUsuario, senhaUsuario, emailUsuario, nrCarteira, telefoneUsuario);
            return ResponseEntity.ok("Atualização concluída: ID " + idUsuario);
        } catch (Exception e) {
            String mensagemErro = extrairMensagemErro(e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Erro ao atualizar: " + mensagemErro);
        }
    }

    @PostMapping("/deletar")
    public ResponseEntity<String> deletarUsuario(
            @RequestParam("idUsuario") int idUsuario) {

        try {
            service.deletarUsuario(idUsuario);
            return ResponseEntity.ok("Exclusão concluída: ID " + idUsuario);
        } catch (Exception e) {
            String mensagemErro = extrairMensagemErro(e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Erro ao deletar: " + mensagemErro);
        }
    }

    /**
     * Método auxiliar para extrair a mensagem de erro da hierarquia de exceções
     */
    private String extrairMensagemErro(Exception e) {
        Throwable causa = e;

        // Procurar por SQLExceptions ou mensagens Oracle ORA-XXXXX
        while (causa != null) {
            // Se for SQLException, pode conter a mensagem de erro do Oracle
            if (causa instanceof SQLException) {
                SQLException sqlEx = (SQLException) causa;

                // Verifica se é erro de aplicação Oracle (ORA-20001 a ORA-20999)
                if (sqlEx.getErrorCode() >= 20000 && sqlEx.getErrorCode() <= 20999) {
                    String mensagem = sqlEx.getMessage();

                    // Extrai a mensagem após "ORA-XXXXX: "
                    int index = mensagem.indexOf(':');
                    if (index > 0 && index < mensagem.length() - 1) {
                        return mensagem.substring(index + 1).trim();
                    }

                    return mensagem;
                }
            }

            // Verifica se a mensagem contém erro ORA-XXXXX
            String mensagem = causa.getMessage();
            if (mensagem != null && mensagem.contains("ORA-")) {
                int indexInicio = mensagem.indexOf("ORA-");
                int indexFim = mensagem.indexOf(':', indexInicio);

                if (indexFim > indexInicio) {
                    return mensagem.substring(indexFim + 1).trim();
                }
            }

            causa = causa.getCause();
        }

        // Se não encontrar uma mensagem específica, retorna a mensagem original
        return e.getMessage();
    }
}