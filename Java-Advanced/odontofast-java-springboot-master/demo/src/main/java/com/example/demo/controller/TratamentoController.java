package com.example.demo.controller;

import com.example.demo.dto.TratamentoDTO;
import com.example.demo.service.TratamentoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.Link;
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.net.URI;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/tratamentos")
public class TratamentoController {

    @Autowired
    private TratamentoService tratamentoService;

    @PostMapping
    public ResponseEntity<EntityModel<TratamentoDTO>> criarTratamento(@Valid @RequestBody TratamentoDTO tratamentoDTO) {
        TratamentoDTO novoTratamento = tratamentoService.criarTratamento(tratamentoDTO);
        EntityModel<TratamentoDTO> resource = EntityModel.of(novoTratamento);

        // Adicionando links
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).obterTratamento(novoTratamento.getId_tratamento())).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).listarTratamentos()).withRel("listarTratamentos"));

        return ResponseEntity.created(URI.create(resource.getRequiredLink("self").getHref())).body(resource);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EntityModel<TratamentoDTO>> obterTratamento(@PathVariable Long id) {
        TratamentoDTO tratamento = tratamentoService.obterTratamentoPorId(id);
        EntityModel<TratamentoDTO> resource = EntityModel.of(tratamento);

        // Adicionando links
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).obterTratamento(id)).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).atualizarTratamento(id, tratamento)).withRel("atualizar"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).excluirTratamento(id)).withRel("excluir"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).listarTratamentos()).withRel("listarTratamentos"));

        return ResponseEntity.ok(resource);
    }

    @GetMapping
    public ResponseEntity<List<EntityModel<TratamentoDTO>>> listarTratamentos() {
        List<TratamentoDTO> tratamentos = tratamentoService.listarTratamentos();
        List<EntityModel<TratamentoDTO>> tratamentosDTO = tratamentos.stream()
                .map(tratamento -> {
                    EntityModel<TratamentoDTO> resource = EntityModel.of(tratamento);
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).obterTratamento(tratamento.getId_tratamento())).withSelfRel());
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).atualizarTratamento(tratamento.getId_tratamento(), tratamento)).withRel("atualizar"));
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).excluirTratamento(tratamento.getId_tratamento())).withRel("excluir"));
                    return resource;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(tratamentosDTO);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EntityModel<TratamentoDTO>> atualizarTratamento(@PathVariable Long id, @Valid @RequestBody TratamentoDTO tratamentoDTO) {
        TratamentoDTO tratamentoAtualizado = tratamentoService.atualizarTratamento(id, tratamentoDTO);
        EntityModel<TratamentoDTO> resource = EntityModel.of(tratamentoAtualizado);

        // Adicionando links
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).obterTratamento(id)).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).listarTratamentos()).withRel("listarTratamentos"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(TratamentoController.class).excluirTratamento(id)).withRel("excluir"));

        return ResponseEntity.ok(resource);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluirTratamento(@PathVariable Long id) {
        tratamentoService.excluirTratamento(id);
        return ResponseEntity.noContent().build();
    }
}
