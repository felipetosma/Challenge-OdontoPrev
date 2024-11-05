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
public class DentistaDTO extends RepresentationModel<DentistaDTO> {

    private Long idDentista;
    private String nomeDentista;
    private String senhaDentista;
    private String especialidade;
    private String cro;

}
