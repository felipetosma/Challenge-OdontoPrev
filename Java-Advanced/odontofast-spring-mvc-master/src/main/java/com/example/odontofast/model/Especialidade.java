package com.example.odontofast.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "c_op_especialidade")
public class Especialidade {

    @Id
    private long idEspecialidade;

    private String tipoEspecialidade;

    @Column(name = "descr_especialidade")
    private String descricaoEspecialidade;

    //A anotação @OneToMany(mappedBy = "especialidade") é usada para indicar que uma especialidade pode ter muitos dentistas associados
    @OneToMany(mappedBy = "especialidade")
    //Cria-se uma lista para armazenar todos os dentistas que estão associados a essa especialidade
    //Cada vez que for feita a busca de uma especialidade, pode-se acessar todos os dentistas que estão ligados a ela
    private List<Dentista> dentistas; //Relação de um-para-muitos

    //Getters e Setters
    public long getIdEspecialidade() {
        return idEspecialidade;
    }

    public void setIdEspecialidade(long idEspecialidade) {
        this.idEspecialidade = idEspecialidade;
    }

    public String getTipoEspecialidade() {
        return tipoEspecialidade;
    }

    public void setTipoEspecialidade(String tipoEspecialidade) {
        this.tipoEspecialidade = tipoEspecialidade;
    }

    public String getDescricaoEspecialidade() {
        return descricaoEspecialidade;
    }

    public void setDescricaoEspecialidade(String descricaoEspecialidade) {
        this.descricaoEspecialidade = descricaoEspecialidade;
    }

    public List<Dentista> getDentistas() {
        return dentistas;
    }

    public void setDentistas(List<Dentista> dentistas) {
        this.dentistas = dentistas;
    }
}
