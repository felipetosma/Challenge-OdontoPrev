package com.example.demo.controller;

import com.example.demo.dto.ChecklistDTO;
import com.example.demo.service.ChecklistService;
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
@RequestMapping("/api/checklists")
public class ChecklistController {

    @Autowired
    private ChecklistService checklistService;

    @PostMapping
    public ResponseEntity<EntityModel<ChecklistDTO>> criarChecklist(@Valid @RequestBody ChecklistDTO checklistDTO) {
        ChecklistDTO novoChecklist = checklistService.criarChecklist(checklistDTO);
        EntityModel<ChecklistDTO> resource = EntityModel.of(novoChecklist);

        // Adicionando links ao DTO
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).obterChecklist(novoChecklist.getIdChecklist())).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).atualizarChecklist(novoChecklist.getIdChecklist(), novoChecklist)).withRel("atualizar"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).listarChecklists()).withRel("listarChecklists"));

        return ResponseEntity.created(URI.create(resource.getRequiredLink("self").getHref())).body(resource);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EntityModel<ChecklistDTO>> obterChecklist(@PathVariable Long id) {
        ChecklistDTO checklist = checklistService.obterChecklistPorId(id);
        EntityModel<ChecklistDTO> resource = EntityModel.of(checklist);

        // Adicionando links ao DTO
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).obterChecklist(id)).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).atualizarChecklist(id, checklist)).withRel("atualizar"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).excluirChecklist(id)).withRel("excluir"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).listarChecklists()).withRel("listarChecklists"));

        return ResponseEntity.ok(resource);
    }

    @GetMapping
    public ResponseEntity<List<EntityModel<ChecklistDTO>>> listarChecklists() {
        List<ChecklistDTO> checklists = checklistService.listarChecklists();
        List<EntityModel<ChecklistDTO>> checklistsDTO = checklists.stream()
                .map(checklist -> {
                    EntityModel<ChecklistDTO> resource = EntityModel.of(checklist);
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).obterChecklist(checklist.getIdChecklist())).withSelfRel());
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).atualizarChecklist(checklist.getIdChecklist(), checklist)).withRel("atualizar"));
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).excluirChecklist(checklist.getIdChecklist())).withRel("excluir"));
                    return resource;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(checklistsDTO);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EntityModel<ChecklistDTO>> atualizarChecklist(@PathVariable Long id, @Valid @RequestBody ChecklistDTO checklistDTO) {
        ChecklistDTO checklistAtualizado = checklistService.atualizarChecklist(id, checklistDTO);
        EntityModel<ChecklistDTO> resource = EntityModel.of(checklistAtualizado);

        // Adicionando links ao DTO
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).obterChecklist(id)).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).atualizarChecklist(id, checklistAtualizado)).withRel("atualizar"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).excluirChecklist(id)).withRel("excluir"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(ChecklistController.class).listarChecklists()).withRel("listarChecklists"));

        return ResponseEntity.ok(resource);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluirChecklist(@PathVariable Long id) {
        checklistService.excluirChecklist(id);
        return ResponseEntity.noContent().build();
    }
}
