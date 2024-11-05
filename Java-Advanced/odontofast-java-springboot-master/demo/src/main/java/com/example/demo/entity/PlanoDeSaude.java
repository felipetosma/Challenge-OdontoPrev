package com.example.demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

@Entity
@Table(name = "c_op_plano_de_saude")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PlanoDeSaude {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "plano_seq")
    @SequenceGenerator(name = "plano_seq", sequenceName = "seq_plano_de_saude", allocationSize = 1)
    private Long idPlano;

    @NotBlank(message = "O nome do plano de saúde é obrigatório.")
    private String nomePlano;

    private String descricao;

    @OneToMany(mappedBy = "planoDeSaude", cascade = CascadeType.ALL)
    private Set<DentistaPlanoSaude> dentistasPlanosDeSaude;

    // Construtor com ID
    public PlanoDeSaude(Long idPlano) {
        this.idPlano = idPlano;
    }
}
