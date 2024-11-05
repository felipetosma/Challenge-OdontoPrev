package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.hateoas.RepresentationModel;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PlanoDeSaudeDTO extends RepresentationModel<PlanoDeSaudeDTO> {

    private Long idPlano;
    private String nomePlano;
    private String descricao;

}
