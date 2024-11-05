package com.example.demo.controller;

import com.example.demo.dto.PlanoDeSaudeDTO;
import com.example.demo.entity.PlanoDeSaude;
import com.example.demo.service.PlanoDeSaudeService;
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
@RequestMapping("/api/planos")
public class PlanoDeSaudeController {

    @Autowired
    private PlanoDeSaudeService planoDeSaudeService;

    @PostMapping
    public ResponseEntity<EntityModel<PlanoDeSaudeDTO>> criarPlanoSaude(@Valid @RequestBody PlanoDeSaudeDTO planoDeSaudeDTO) {
        PlanoDeSaude novoPlanoDeSaude = planoDeSaudeService.criarPlanoDeSaude(convertToEntity(planoDeSaudeDTO));
        EntityModel<PlanoDeSaudeDTO> resource = EntityModel.of(convertToDTO(novoPlanoDeSaude));

        // Adicionando links
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).obterPlanoDeSaude(novoPlanoDeSaude.getIdPlano())).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).listarPlanosDeSaude()).withRel("listarPlanos"));

        return ResponseEntity.created(URI.create(resource.getRequiredLink("self").getHref())).body(resource);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EntityModel<PlanoDeSaudeDTO>> obterPlanoDeSaude(@PathVariable Long id) {
        PlanoDeSaude planoDeSaude = planoDeSaudeService.obterPlanoDeSaudePorId(id);
        EntityModel<PlanoDeSaudeDTO> resource = EntityModel.of(convertToDTO(planoDeSaude));

        // Adicionando links
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).obterPlanoDeSaude(id)).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).atualizarPlanoDeSaude(id, convertToDTO(planoDeSaude))).withRel("atualizar"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).listarPlanosDeSaude()).withRel("listarPlanos"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).excluirPlanoDeSaude(id)).withRel("excluir"));

        return ResponseEntity.ok(resource);
    }

    @GetMapping
    public ResponseEntity<List<EntityModel<PlanoDeSaudeDTO>>> listarPlanosDeSaude() {
        List<PlanoDeSaude> planosDeSaude = planoDeSaudeService.listarPlanosDeSaude();
        List<EntityModel<PlanoDeSaudeDTO>> planosDTO = planosDeSaude.stream()
                .map(plano -> {
                    EntityModel<PlanoDeSaudeDTO> resource = EntityModel.of(convertToDTO(plano));
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).obterPlanoDeSaude(plano.getIdPlano())).withSelfRel());
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).atualizarPlanoDeSaude(plano.getIdPlano(), convertToDTO(plano))).withRel("atualizar"));
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).excluirPlanoDeSaude(plano.getIdPlano())).withRel("excluir"));
                    return resource;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(planosDTO);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EntityModel<PlanoDeSaudeDTO>> atualizarPlanoDeSaude(@PathVariable Long id, @Valid @RequestBody PlanoDeSaudeDTO planoDeSaudeDTO) {
        PlanoDeSaude planoDeSaudeAtualizado = planoDeSaudeService.atualizarPlanoDeSaude(id, convertToEntity(planoDeSaudeDTO));
        EntityModel<PlanoDeSaudeDTO> resource = EntityModel.of(convertToDTO(planoDeSaudeAtualizado));

        // Adicionando links
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).obterPlanoDeSaude(id)).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).listarPlanosDeSaude()).withRel("listarPlanos"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(PlanoDeSaudeController.class).excluirPlanoDeSaude(id)).withRel("excluir"));

        return ResponseEntity.ok(resource);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluirPlanoDeSaude(@PathVariable Long id) {
        planoDeSaudeService.excluirPlanoDeSaude(id);
        return ResponseEntity.noContent().build();
    }

    private PlanoDeSaudeDTO convertToDTO(PlanoDeSaude planoDeSaude) {
        return new PlanoDeSaudeDTO(planoDeSaude.getIdPlano(), planoDeSaude.getNomePlano(), planoDeSaude.getDescricao());
    }

    private PlanoDeSaude convertToEntity(PlanoDeSaudeDTO planoDeSaudeDTO) {
        return new PlanoDeSaude(planoDeSaudeDTO.getIdPlano(), planoDeSaudeDTO.getNomePlano(), planoDeSaudeDTO.getDescricao(), null);
    }
}
