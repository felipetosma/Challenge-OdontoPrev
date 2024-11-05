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
public class DentistaPlanoSaudeDTO extends RepresentationModel<DentistaPlanoSaudeDTO> {
    private Long planoId;
    private Long dentistaId;
}
