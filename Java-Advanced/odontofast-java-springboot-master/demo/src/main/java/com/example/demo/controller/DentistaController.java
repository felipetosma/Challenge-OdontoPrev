package com.example.demo.controller;

import com.example.demo.dto.DentistaDTO;
import com.example.demo.service.DentistaService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/dentista")
public class DentistaController {

    @Autowired
    private DentistaService dentistaService;

    @PostMapping("/withProcedure")
    public ResponseEntity<String> insertWithProcedure(@RequestBody @Valid DentistaDTO dentistaDTO) {
        dentistaService.insertWithProcedure(dentistaDTO);
        return ResponseEntity.ok("Dentista inserido com sucesso.");
    }

    @PutMapping("/withProcedure")
    public ResponseEntity<String> updateWithProcedure(@RequestBody @Valid DentistaDTO dentistaDTO) {
        dentistaService.updateWithProcedure(dentistaDTO);
        return ResponseEntity.ok("Dentista atualizado com sucesso.");
    }

    @DeleteMapping("/withProcedure")
    public ResponseEntity<String> deleteWithProcedure(@RequestBody @Valid DentistaDTO dentistaDTO) {
        dentistaService.deleteWithProcedure(dentistaDTO);
        return ResponseEntity.ok("Dentista deletado com sucesso.");
    }


}
