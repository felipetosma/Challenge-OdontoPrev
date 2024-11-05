package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.hateoas.RepresentationModel;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TratamentoDTO extends RepresentationModel<TratamentoDTO>  {

    private Long id_tratamento;
    private String tipo_tratamento;
    private Date dt_inicio;
    private Date dt_fim;
    private String descricao;
    private String status_tratamento;
    private Long dentista_id_dentista;
    private Long usuario_id_usuario;

}
