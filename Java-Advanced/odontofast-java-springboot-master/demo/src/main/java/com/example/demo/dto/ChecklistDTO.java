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
public class ChecklistDTO extends RepresentationModel<ChecklistDTO>  {

    private Long idChecklist; // ID do Checklist
    private Integer escovacaoDentes; // Escovação dos dentes
    private Integer fioDental; // Uso do fio dental
    private Integer enxaguanteBucal; // Uso de enxaguante bucal
    private Long usuarioIdUsuario; // ID do Usuário associado

}
