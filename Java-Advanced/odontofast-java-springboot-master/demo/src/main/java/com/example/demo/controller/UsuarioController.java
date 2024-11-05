package com.example.demo.controller;

import com.example.demo.dto.UsuarioDTO;
import com.example.demo.entity.Dentista;
import com.example.demo.entity.Notificacao;
import com.example.demo.entity.PlanoDeSaude;
import com.example.demo.entity.Usuario;
import com.example.demo.service.UsuarioService;
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
@RequestMapping("/api/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping
    public ResponseEntity<EntityModel<UsuarioDTO>> criarUsuario(@Valid @RequestBody UsuarioDTO usuarioDTO) {
        Usuario usuario = converterDtoParaEntidade(usuarioDTO);
        Usuario novoUsuario = usuarioService.criarUsuario(usuario);
        UsuarioDTO novoUsuarioDTO = converterEntidadeParaDto(novoUsuario);

        // Adicionando links ao DTO
        EntityModel<UsuarioDTO> resource = EntityModel.of(novoUsuarioDTO);
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).obterUsuario(novoUsuarioDTO.getIdUsuario())).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).atualizarUsuario(novoUsuarioDTO.getIdUsuario(), novoUsuarioDTO)).withRel("atualizar"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).excluirUsuario(novoUsuarioDTO.getIdUsuario())).withRel("excluir"));

        return ResponseEntity.created(URI.create(resource.getRequiredLink("self").getHref())).body(resource);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EntityModel<UsuarioDTO>> obterUsuario(@PathVariable Long id) {
        Usuario usuario = usuarioService.obterUsuarioPorId(id);
        UsuarioDTO usuarioDTO = converterEntidadeParaDto(usuario);

        // Adicionando links ao DTO
        EntityModel<UsuarioDTO> resource = EntityModel.of(usuarioDTO);

        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).obterUsuario(id)).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).atualizarUsuario(id, usuarioDTO)).withRel("atualizar"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).excluirUsuario(id)).withRel("excluir"));

        return ResponseEntity.ok(resource);
    }

    @GetMapping
    public ResponseEntity<List<EntityModel<UsuarioDTO>>> listarUsuarios() {
        List<Usuario> usuarios = usuarioService.listarUsuarios();
        List<EntityModel<UsuarioDTO>> usuariosDTO = usuarios.stream()
                .map(usuario -> {
                    UsuarioDTO dto = converterEntidadeParaDto(usuario);
                    EntityModel<UsuarioDTO> resource = EntityModel.of(dto);
                    Link selfLink = WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).obterUsuario(dto.getIdUsuario())).withSelfRel();
                    resource.add(selfLink);
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).atualizarUsuario(dto.getIdUsuario(), dto)).withRel("atualizar"));
                    resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).excluirUsuario(dto.getIdUsuario())).withRel("excluir"));
                    return resource;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(usuariosDTO);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EntityModel<UsuarioDTO>> atualizarUsuario(@PathVariable Long id, @Valid @RequestBody UsuarioDTO usuarioDTO) {
        Usuario usuario = converterDtoParaEntidade(usuarioDTO);
        Usuario usuarioAtualizado = usuarioService.atualizarUsuario(id, usuario);
        UsuarioDTO usuarioAtualizadoDTO = converterEntidadeParaDto(usuarioAtualizado);

        // Adicionando links ao DTO
        EntityModel<UsuarioDTO> resource = EntityModel.of(usuarioAtualizadoDTO);

        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).obterUsuario(id)).withSelfRel());
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).atualizarUsuario(id, usuarioAtualizadoDTO)).withRel("atualizar"));
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).excluirUsuario(id)).withRel("excluir"));

        return ResponseEntity.ok(resource);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<EntityModel<Void>> excluirUsuario(@PathVariable Long id) {
        usuarioService.excluirUsuario(id);

        // Retornar um link para criar um novo usuário, por exemplo
        EntityModel<Void> resource = EntityModel.of(null);
        resource.add(WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(UsuarioController.class).listarUsuarios()).withRel("listarUsuarios"));

        return ResponseEntity.noContent().location(URI.create(resource.getRequiredLink("listarUsuarios").getHref())).build();
    }

    // Conversão de DTO para Entidade
    private Usuario converterDtoParaEntidade(UsuarioDTO usuarioDTO) {
        Usuario usuario = new Usuario();
        usuario.setIdUsuario(usuarioDTO.getIdUsuario());
        usuario.setNomeUsuario(usuarioDTO.getNomeUsuario());
        usuario.setSenhaUsuario(usuarioDTO.getSenhaUsuario());
        usuario.setEmailUsuario(usuarioDTO.getEmailUsuario());
        usuario.setNrCarteira(usuarioDTO.getNrCarteira());

        if (usuarioDTO.getDentistaIdDentista() != null) {
            usuario.setDentista(new Dentista(usuarioDTO.getDentistaIdDentista()));
        }
        if (usuarioDTO.getPlanoIdPlano() != null) {
            usuario.setPlanoDeSaude(new PlanoDeSaude(usuarioDTO.getPlanoIdPlano()));
        }
        if (usuarioDTO.getNotIdNotificacao() != null) {
            usuario.setNotificacao(new Notificacao(usuarioDTO.getNotIdNotificacao()));
        }

        return usuario;
    }

    // Conversão de Entidade para DTO
    private UsuarioDTO converterEntidadeParaDto(Usuario usuario) {
        UsuarioDTO usuarioDTO = new UsuarioDTO();
        usuarioDTO.setIdUsuario(usuario.getIdUsuario());
        usuarioDTO.setNomeUsuario(usuario.getNomeUsuario());
        usuarioDTO.setSenhaUsuario(usuario.getSenhaUsuario());
        usuarioDTO.setEmailUsuario(usuario.getEmailUsuario());
        usuarioDTO.setNrCarteira(usuario.getNrCarteira());

        if (usuario.getDentista() != null) {
            usuarioDTO.setDentistaIdDentista(usuario.getDentista().getIdDentista());
        }
        if (usuario.getPlanoDeSaude() != null) {
            usuarioDTO.setPlanoIdPlano(usuario.getPlanoDeSaude().getIdPlano());
        }
        if (usuario.getNotificacao() != null) {
            usuarioDTO.setNotIdNotificacao(usuario.getNotificacao().getIdNotificacao());
        }

        return usuarioDTO;
    }
}
