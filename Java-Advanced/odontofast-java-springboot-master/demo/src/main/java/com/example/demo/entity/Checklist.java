package com.example.demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "c_op_checklist")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Checklist {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "checklist_seq")
    @SequenceGenerator(name = "checklist_seq", sequenceName = "seq_checklist", allocationSize = 1)
    private Long idChecklist;

    @NotNull(message = "O campo de escovação é obrigatório.")
    private Integer escovacaoDentes;

    @NotNull(message = "O campo de fio dental é obrigatório.")
    private Integer fioDental;

    @NotNull(message = "O campo de enxaguante bucal é obrigatório.")
    private Integer enxaguanteBucal;

    @ManyToOne
    @JoinColumn(name = "usuario_id_usuario", nullable = false)
    private Usuario usuario; // Associa o Checklist a um Usuário

}
