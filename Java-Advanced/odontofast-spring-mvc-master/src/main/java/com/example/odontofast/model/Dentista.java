package com.example.odontofast.model;

import jakarta.persistence.*;

@Entity
@Table(name = "c_op_dentista")
public class Dentista {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "dentista_seq")
    @SequenceGenerator(name = "dentista_seq", sequenceName = "c_op_dentista_seq", allocationSize = 1)
    private Long idDentista;

    private String nomeDentista;

    private String senhaDentista;

    private String cro;

    private long telefoneDentista;

    private String emailDentista;

    // A anotação @ManyToOne é usada para indicar que muitos dentistas podem ter a
    // mesma especialidade
    @ManyToOne
    @JoinColumn(name = "id_especialidade")
    private Especialidade especialidade;

    // Getters e Setters
    public Long getIdDentista() {
        return idDentista;
    }

    public void setIdDentista(Long idDentista) {
        this.idDentista = idDentista;
    }

    public String getNomeDentista() {
        return nomeDentista;
    }

    public void setNomeDentista(String nomeDentista) {
        this.nomeDentista = nomeDentista;
    }

    public String getSenhaDentista() {
        return senhaDentista;
    }

    public void setSenhaDentista(String senhaDentista) {
        this.senhaDentista = senhaDentista;
    }

    public String getCro() {
        return cro;
    }

    public void setCro(String cro) {
        this.cro = cro;
    }

    public long getTelefoneDentista() {
        return telefoneDentista;
    }

    public void setTelefoneDentista(long telefoneDentista) {
        this.telefoneDentista = telefoneDentista;
    }

    public String getEmailDentista() {
        return emailDentista;
    }

    public void setEmailDentista(String emailDentista) {
        this.emailDentista = emailDentista;
    }

    public Especialidade getEspecialidade() {
        return especialidade;
    }

    public void setEspecialidade(Especialidade especialidade) {
        this.especialidade = especialidade;
    }
}
