package com.example.demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

@Entity
@Table(name = "c_op_dentista")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Dentista {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "dentista_seq")
    @SequenceGenerator(name = "dentista_seq", sequenceName = "dentista_sequence", allocationSize = 1)
    private Long idDentista;

    @NotBlank(message = "O nome do dentista é obrigatório.")
    private String nomeDentista;

    @NotBlank(message = "A senha do dentista é obrigatória.")
    private String senhaDentista;

    @NotBlank(message = "A especialidade do dentista é obrigatória.")
    private String especialidade;

    @NotBlank(message = "O CRO do dentista é obrigatório.")
    private String cro;

    @ManyToMany
    @JoinTable(
            name = "dentista_plano_de_saude",
            joinColumns = @JoinColumn(name = "dentista_id"),
            inverseJoinColumns = @JoinColumn(name = "plano_id")
    )
    private Set<DentistaPlanoSaude> dentistaPlanosDeSaude;

    // Construtor com ID
    public Dentista(Long idDentista) {
        this.idDentista = idDentista;
    }
}