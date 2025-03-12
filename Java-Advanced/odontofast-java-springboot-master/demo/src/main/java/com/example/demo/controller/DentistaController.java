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
}
