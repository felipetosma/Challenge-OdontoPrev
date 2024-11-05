package com.example.demo.controller;

import com.example.demo.dto.DentistaPlanoSaudeDTO;
import com.example.demo.entity.DentistaPlanoSaude;
import com.example.demo.service.DentistaPlanoSaudeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.Link;
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/dentistaplanosaude")
public class DentistaPlanoSaudeController {

    @Autowired
    private DentistaPlanoSaudeService dentistaPlanoSaudeService;

    // Endpoint para listar todas as associações
    @GetMapping
    public ResponseEntity<List<EntityModel<DentistaPlanoSaude>>> listarAssociacoes() {
        List<DentistaPlanoSaude> associacoes = dentistaPlanoSaudeService.listarAssociacoes();
        List<EntityModel<DentistaPlanoSaude>> recursos = associacoes.stream()
                .map(this::toEntityModel)
                .collect(Collectors.toList());
        return ResponseEntity.ok(recursos);
    }

    // Endpoint para obter uma associação específica por ID
    @GetMapping("/{id}")
    public ResponseEntity<EntityModel<DentistaPlanoSaude>> obterAssociacaoPorId(@PathVariable Long id) {
        DentistaPlanoSaude associacao = dentistaPlanoSaudeService.obterAssociacaoPorId(id);
        return associacao != null ? ResponseEntity.ok(toEntityModel(associacao)) : ResponseEntity.notFound().build();
    }

    // Endpoint para criar uma nova associação entre dentista e plano de saúde
    @PostMapping("/associar")
    public ResponseEntity<EntityModel<DentistaPlanoSaude>> associarDentistaAoPlano(@RequestBody DentistaPlanoSaudeDTO dentistaPlanoSaudeDTO) {
        DentistaPlanoSaude associacao = dentistaPlanoSaudeService.associarDentistaAoPlano(dentistaPlanoSaudeDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(toEntityModel(associacao));
    }

    // Endpoint para atualizar uma associação existente
    @PutMapping("/{id}")
    public ResponseEntity<EntityModel<DentistaPlanoSaude>> atualizarAssociacao(@PathVariable Long id, @RequestBody DentistaPlanoSaudeDTO dentistaPlanoSaudeDTO) {
        DentistaPlanoSaude associacaoAtualizada = dentistaPlanoSaudeService.atualizarAssociacao(id, dentistaPlanoSaudeDTO);
        return associacaoAtualizada != null ? ResponseEntity.ok(toEntityModel(associacaoAtualizada)) : ResponseEntity.notFound().build();
    }

    // Endpoint para excluir uma associação entre dentista e plano de saúde
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluirAssociacao(@PathVariable Long id) {
        boolean excluido = dentistaPlanoSaudeService.excluirAssociacao(id);
        return excluido ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }

    // Método para converter entidade em EntityModel com links HATEOAS
    private EntityModel<DentistaPlanoSaude> toEntityModel(DentistaPlanoSaude associacao) {
        EntityModel<DentistaPlanoSaude> entityModel = EntityModel.of(associacao);
        Link selfLink = WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaPlanoSaudeController.class).obterAssociacaoPorId(associacao.getId())).withSelfRel();
        entityModel.add(selfLink);
        return entityModel;
    }
}
