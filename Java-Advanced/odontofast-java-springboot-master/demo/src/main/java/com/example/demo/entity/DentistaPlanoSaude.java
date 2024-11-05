package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "c_op_dentista_planosaude")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DentistaPlanoSaude {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_dentista", nullable = false)
    private Dentista dentista;

    @ManyToOne
    @JoinColumn(name = "id_plano", nullable = false)
    private PlanoDeSaude planoDeSaude;

}
