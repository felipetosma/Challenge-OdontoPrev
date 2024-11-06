package com.example.demo.controller;

import com.example.demo.dto.UsuarioDTO;
import com.example.demo.service.UsuarioService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/usuario")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping("/withProcedure")
    public ResponseEntity<String> insertWithProcedure(@RequestBody @Valid UsuarioDTO usuarioDTO) {
        usuarioService.insertWithProcedure(usuarioDTO);
        return ResponseEntity.ok("Usuário inserido com sucesso.");
    }

    @PutMapping("/withProcedure")
    public ResponseEntity<String> updateWithProcedure(@RequestBody @Valid UsuarioDTO usuarioDTO) {
        usuarioService.updateWithProcedure(usuarioDTO);
        return ResponseEntity.ok("Usuário atualizado com sucesso.");
    }

    @DeleteMapping("/withProcedure")
    public ResponseEntity<String> deleteWithProcedure(@RequestBody @Valid UsuarioDTO usuarioDTO) {
        usuarioService.deleteWithProcedure(usuarioDTO);
        return ResponseEntity.ok("Usuário deletado com sucesso.");
    }
}
