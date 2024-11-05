package com.example.demo.controller;

import com.example.demo.dto.DentistaDTO;
import com.example.demo.entity.Dentista;
import com.example.demo.service.DentistaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.Link;
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/dentistas")
public class DentistaController {

    @Autowired
    private DentistaService dentistaService;

    @PostMapping
    public ResponseEntity<EntityModel<DentistaDTO>> criarDentista(@Valid @RequestBody DentistaDTO dentistaDTO) {
        try {
            Dentista novoDentista = dentistaService.criarDentista(convertToEntity(dentistaDTO));
            EntityModel<DentistaDTO> resource = EntityModel.of(convertToDTO(novoDentista));

            // Adicionando links ao DTO
            resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).obterDentista(novoDentista.getIdDentista())).withSelfRel());
            resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).atualizarDentista(novoDentista.getIdDentista(), dentistaDTO)).withRel("atualizar"));
            resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).listarDentistas()).withRel("listarDentistas"));

            return ResponseEntity.status(HttpStatus.CREATED).body(resource);
        } catch (Exception e) {
            // Log da exceção para análise
            System.err.println("Erro ao criar dentista: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null); // Retorna null em caso de erro
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<EntityModel<DentistaDTO>> obterDentista(@PathVariable Long id) {
        Optional<Dentista> dentistaOptional = dentistaService.obterDentistaPorId(id);
        return dentistaOptional.map(dentista -> {
            EntityModel<DentistaDTO> resource = EntityModel.of(convertToDTO(dentista));

            // Adicionando links ao DTO
            resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).obterDentista(id)).withSelfRel());
            resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).atualizarDentista(id, convertToDTO(dentista))).withRel("atualizar"));
            resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).excluirDentista(id)).withRel("excluir"));
            resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).listarDentistas()).withRel("listarDentistas"));

            return ResponseEntity.ok(resource);
        }).orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public ResponseEntity<List<EntityModel<DentistaDTO>>> listarDentistas() {
        List<Dentista> dentistas = dentistaService.listarDentistas();
        List<EntityModel<DentistaDTO>> dentistaDTOs = dentistas.stream()
                .map(dentista -> {
                    EntityModel<DentistaDTO> resource = EntityModel.of(convertToDTO(dentista));
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).obterDentista(dentista.getIdDentista())).withSelfRel());
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).atualizarDentista(dentista.getIdDentista(), convertToDTO(dentista))).withRel("atualizar"));
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).excluirDentista(dentista.getIdDentista())).withRel("excluir"));
                    return resource;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(dentistaDTOs);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EntityModel<DentistaDTO>> atualizarDentista(@PathVariable Long id, @Valid @RequestBody DentistaDTO dentistaDTO) {
        Dentista dentistaAtualizado = dentistaService.atualizarDentista(id, convertToEntity(dentistaDTO));
        EntityModel<DentistaDTO> resource = EntityModel.of(convertToDTO(dentistaAtualizado));

        // Adicionando links ao DTO
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).obterDentista(id)).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).excluirDentista(id)).withRel("excluir"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(DentistaController.class).listarDentistas()).withRel("listarDentistas"));

        return ResponseEntity.ok(resource);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluirDentista(@PathVariable Long id) {
        dentistaService.excluirDentista(id);
        return ResponseEntity.noContent().build();
    }

    // Métodos de conversão entre DTO e Entidade
    private Dentista convertToEntity(DentistaDTO dto) {
        return new Dentista(
                dto.getIdDentista(),
                dto.getNomeDentista(),
                dto.getSenhaDentista(),
                dto.getEspecialidade(),
                dto.getCro(),
                null
        );
    }

    private DentistaDTO convertToDTO(Dentista entity) {
        return new DentistaDTO(
                entity.getIdDentista(),
                entity.getNomeDentista(),
                entity.getSenhaDentista(),
                entity.getEspecialidade(),
                entity.getCro()
        );
    }
}
