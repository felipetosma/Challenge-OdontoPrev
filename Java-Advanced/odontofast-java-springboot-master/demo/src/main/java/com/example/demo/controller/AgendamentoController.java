package com.example.demo.controller;

import com.example.demo.dto.AgendamentoDTO;
import com.example.demo.service.AgendamentoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.Link;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.*;

@RestController
@RequestMapping("/api/agendamentos")
public class AgendamentoController {

    @Autowired
    private AgendamentoService agendamentoService;

    @PostMapping
    public ResponseEntity<EntityModel<AgendamentoDTO>> criarAgendamento(@Valid @RequestBody AgendamentoDTO agendamentoDTO) {
        AgendamentoDTO novoAgendamento = agendamentoService.criarAgendamento(agendamentoDTO);
        EntityModel<AgendamentoDTO> resource = EntityModel.of(novoAgendamento);
        resource.add(linkTo(methodOn(AgendamentoController.class).obterAgendamento(novoAgendamento.getIdAgendamento())).withSelfRel());
        resource.add(linkTo(methodOn(AgendamentoController.class).listarAgendamentos()).withRel("agendamentos"));
        return ResponseEntity.ok(resource);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EntityModel<AgendamentoDTO>> obterAgendamento(@PathVariable Long id) {
        AgendamentoDTO agendamento = agendamentoService.obterAgendamentoPorId(id);
        EntityModel<AgendamentoDTO> resource = EntityModel.of(agendamento);
        resource.add(linkTo(methodOn(AgendamentoController.class).obterAgendamento(id)).withSelfRel());
        resource.add(linkTo(methodOn(AgendamentoController.class).listarAgendamentos()).withRel("agendamentos"));
        resource.add(linkTo(methodOn(AgendamentoController.class).atualizarAgendamento(id, agendamento)).withRel("atualizar"));
        resource.add(linkTo(methodOn(AgendamentoController.class).excluirAgendamento(id)).withRel("excluir"));
        return ResponseEntity.ok(resource);
    }

    @GetMapping
    public ResponseEntity<List<EntityModel<AgendamentoDTO>>> listarAgendamentos() {
        List<AgendamentoDTO> agendamentos = agendamentoService.listarAgendamentos();
        List<EntityModel<AgendamentoDTO>> resources = agendamentos.stream()
                .map(agendamento -> {
                    EntityModel<AgendamentoDTO> resource = EntityModel.of(agendamento);
                    resource.add(linkTo(methodOn(AgendamentoController.class).obterAgendamento(agendamento.getIdAgendamento())).withSelfRel());
                    resource.add(linkTo(methodOn(AgendamentoController.class).atualizarAgendamento(agendamento.getIdAgendamento(), agendamento)).withRel("atualizar"));
                    resource.add(linkTo(methodOn(AgendamentoController.class).excluirAgendamento(agendamento.getIdAgendamento())).withRel("excluir"));
                    return resource;
                })
                .collect(Collectors.toList());

        Link linkCriar = linkTo(methodOn(AgendamentoController.class).criarAgendamento(null)).withRel("criarAgendamento");
        return ResponseEntity.ok(resources);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EntityModel<AgendamentoDTO>> atualizarAgendamento(@PathVariable Long id, @Valid @RequestBody AgendamentoDTO agendamentoDTO) {
        AgendamentoDTO agendamentoAtualizado = agendamentoService.atualizarAgendamento(id, agendamentoDTO);
        EntityModel<AgendamentoDTO> resource = EntityModel.of(agendamentoAtualizado);
        resource.add(linkTo(methodOn(AgendamentoController.class).obterAgendamento(id)).withSelfRel());
        resource.add(linkTo(methodOn(AgendamentoController.class).listarAgendamentos()).withRel("agendamentos"));
        return ResponseEntity.ok(resource);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluirAgendamento(@PathVariable Long id) {
        agendamentoService.excluirAgendamento(id);
        return ResponseEntity.noContent().build();
    }
}
