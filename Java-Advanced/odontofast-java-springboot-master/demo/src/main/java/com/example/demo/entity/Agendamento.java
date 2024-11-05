package com.example.demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "c_op_agendamento")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Agendamento {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "agendamento_seq")
    @SequenceGenerator(name = "agendamento_seq", sequenceName = "seq_agendamento", allocationSize = 1)
    private Long idAgendamento;

    @NotNull(message = "A data agendada é obrigatória.")
    @Temporal(TemporalType.DATE)
    private Date dataAgendada;

    @NotNull(message = "O horário agendado é obrigatório.")
    private String horarioAgendado;

    private String statusTratamento;

    private String descricaoAgendamento;

    @ManyToOne
    @JoinColumn(name = "dentista_id_dentista", nullable = false)
    private Dentista dentista;

    @ManyToOne
    @JoinColumn(name = "usuario_id_usuario", nullable = false)
    private Usuario usuario;

}
