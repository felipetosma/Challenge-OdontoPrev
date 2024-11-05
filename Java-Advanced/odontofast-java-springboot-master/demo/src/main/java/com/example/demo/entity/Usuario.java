package com.example.demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "c_op_usuario")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "usuario_seq")
    @SequenceGenerator(name = "usuario_seq", sequenceName = "usuario_sequence", allocationSize = 1)
    private Long idUsuario;

    @NotBlank(message = "O nome do usuário é obrigatório.")
    private String nomeUsuario;

    @NotBlank(message = "A senha do usuário é obrigatória.")
    private String senhaUsuario;

    @Email(message = "O email deve ser válido.")
    private String emailUsuario;

    @NotBlank(message = "O número da carteira é obrigatório.")
    private String nrCarteira;

    @ManyToOne
    @JoinColumn(name = "dentista_id_dentista", nullable = false)
    private Dentista dentista;

    @ManyToOne
    @JoinColumn(name = "not_id_notificacao", nullable = false)
    private Notificacao notificacao;

    @ManyToOne
    @JoinColumn(name = "plano_id_plano", nullable = false)
    private PlanoDeSaude planoDeSaude;

}