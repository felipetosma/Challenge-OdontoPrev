package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "c_op_dentista")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Dentista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idDentista;
    private String nomeDentista;
    private String senhaDentista;
    private String cro;
    private Long telefoneDentista;
    private String emailDentista;
    private Long idEspecialidade;
}