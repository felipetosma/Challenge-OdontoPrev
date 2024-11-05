package com.example.demo.controller;

import com.example.demo.dto.NotificacaoDTO;
import com.example.demo.entity.Notificacao;
import com.example.demo.service.NotificacaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/notificacoes")
public class NotificacaoController {

    @Autowired
    private NotificacaoService notificacaoService;

    // Endpoint para listar todas as notificações
    @GetMapping
    public ResponseEntity<List<NotificacaoDTO>> listarNotificacoes() {
        List<Notificacao> notificacoes = notificacaoService.listarNotificacoes();
        List<NotificacaoDTO> notificacaoDTOs = notificacoes.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(notificacaoDTOs);
    }

    // Endpoint para obter uma notificação específica por ID
    @GetMapping("/{id}")
    public ResponseEntity<NotificacaoDTO> obterNotificacaoPorId(@PathVariable Long id) {
        Notificacao notificacao = notificacaoService.obterNotificacaoPorId(id);
        if (notificacao != null) {
            NotificacaoDTO dto = convertToDTO(notificacao);
            return ResponseEntity.ok(dto);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Endpoint para criar uma nova notificação
    @PostMapping
    public ResponseEntity<NotificacaoDTO> criarNotificacao(@RequestBody NotificacaoDTO notificacaoDTO) {
        Notificacao notificacao = new Notificacao();
        // Convertendo DTO para entidade
        notificacao.setMensagem(notificacaoDTO.getMensagem());
        notificacao.setTipoNotificacao(notificacaoDTO.getTipoNotificacao());
        notificacao.setDataEnvio(notificacaoDTO.getDataEnvio());
        notificacao.setLeitura(notificacaoDTO.getLeitura());
        Notificacao novaNotificacao = notificacaoService.criarNotificacao(notificacao);
        return ResponseEntity.status(HttpStatus.CREATED).body(convertToDTO(novaNotificacao));
    }

    // Endpoint para atualizar uma notificação existente
    @PutMapping("/{id}")
    public ResponseEntity<NotificacaoDTO> atualizarNotificacao(@PathVariable Long id, @RequestBody NotificacaoDTO notificacaoDTO) {
        Notificacao notificacao = new Notificacao();
        notificacao.setIdNotificacao(id);
        notificacao.setMensagem(notificacaoDTO.getMensagem());
        notificacao.setTipoNotificacao(notificacaoDTO.getTipoNotificacao());
        notificacao.setDataEnvio(notificacaoDTO.getDataEnvio());
        notificacao.setLeitura(notificacaoDTO.getLeitura());

        Notificacao notificacaoAtualizada = notificacaoService.atualizarNotificacao(id, notificacao);
        return notificacaoAtualizada != null ? ResponseEntity.ok(convertToDTO(notificacaoAtualizada)) : ResponseEntity.notFound().build();
    }

    // Endpoint para excluir uma notificação
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluirNotificacao(@PathVariable Long id) {
        notificacaoService.excluirNotificacao(id);
        return ResponseEntity.noContent().build();
    }

    // Método de conversão entre entidade e DTO
    private NotificacaoDTO convertToDTO(Notificacao entity) {
        NotificacaoDTO dto = new NotificacaoDTO(
                entity.getIdNotificacao(),
                entity.getMensagem(),
                entity.getTipoNotificacao(),
                entity.getDataEnvio(),
                entity.getLeitura()
        );

        // Adiciona links HATEOAS
        dto.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(NotificacaoController.class).obterNotificacaoPorId(entity.getIdNotificacao())).withSelfRel());
        dto.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(NotificacaoController.class).listarNotificacoes()).withRel("notificacoes"));
        dto.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(NotificacaoController.class).atualizarNotificacao(entity.getIdNotificacao(), dto)).withRel("atualizar"));
        dto.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(NotificacaoController.class).excluirNotificacao(entity.getIdNotificacao())).withRel("excluir"));

        return dto;
    }
}
