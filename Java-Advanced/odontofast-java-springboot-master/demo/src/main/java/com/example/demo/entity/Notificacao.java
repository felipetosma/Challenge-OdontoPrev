package com.example.demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "c_op_notificacao")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Notificacao {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "notificacao_seq")
    @SequenceGenerator(name = "notificacao_seq", sequenceName = "notificacao_sequence", allocationSize = 1)
    private Long idNotificacao;

    @NotBlank(message = "A mensagem da notificação é obrigatória.")
    private String mensagem;

    @NotBlank(message = "O tipo de notificação é obrigatório.")
    private String tipoNotificacao;

    private Date dataEnvio;

    private Character leitura;

    // Construtor com ID
    public Notificacao(Long idNotificacao) {
        this.idNotificacao = idNotificacao;
    }

}
