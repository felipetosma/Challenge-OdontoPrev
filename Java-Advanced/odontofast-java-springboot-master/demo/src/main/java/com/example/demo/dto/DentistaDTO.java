package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DentistaDTO {
    private Long idDentista;
    private String nomeDentista;
    private String senhaDentista;
    private String cro;
    private Long telefoneDentista;
    private String emailDentista;
    private Long idEspecialidade;
}