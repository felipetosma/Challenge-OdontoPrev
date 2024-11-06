package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UsuarioDTO {
    private Long idUsuario;
    private String nomeUsuario;
    private String senhaUsuario;
    private String emailUsuario;
    private String nrCarteira;
    private Long telefoneUsuario;
}
