package com.example.demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "c_op_tratamento")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Tratamento {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "tratamento_seq")
    @SequenceGenerator(name = "tratamento_seq", sequenceName = "seq_tratamento", allocationSize = 1)
    private Long idTratamento;

    @NotNull(message = "O tipo de tratamento é obrigatório.")
    private String tipoTratamento;

    @NotNull(message = "A data de início é obrigatória.")
    @Temporal(TemporalType.DATE)
    private Date dtInicio;

    @NotNull(message = "A data de fim é obrigatória.")
    @Temporal(TemporalType.DATE)
    private Date dtFim;

    private String descricao;

    @NotNull(message = "O status do tratamento é obrigatório.")
    private String statusTratamento;

    @ManyToOne
    @JoinColumn(name = "dentista_id_dentista", nullable = false)
    private Dentista dentista;

    @ManyToOne
    @JoinColumn(name = "usuario_id_usuario", nullable = false)
    private Usuario usuario;

}
