package com.example.odontofast.dto;

public class RelatorioAgendamentoDTO {
    private String nomePlano;
    private String tipoPlano;
    private int totalAgendamentos;
    private String nomeDentista;
    private String categoriaVolume;

    public RelatorioAgendamentoDTO() {}

    public RelatorioAgendamentoDTO(String nomePlano, String tipoPlano, int totalAgendamentos,
                                   String nomeDentista, String categoriaVolume) {
        this.nomePlano = nomePlano;
        this.tipoPlano = tipoPlano;
        this.totalAgendamentos = totalAgendamentos;
        this.nomeDentista = nomeDentista;
        this.categoriaVolume = categoriaVolume;
    }

    // Getters e Setters
    public String getNomePlano() { return nomePlano; }
    public void setNomePlano(String nomePlano) { this.nomePlano = nomePlano; }
    public String getTipoPlano() { return tipoPlano; }
    public void setTipoPlano(String tipoPlano) { this.tipoPlano = tipoPlano; }
    public int getTotalAgendamentos() { return totalAgendamentos; }
    public void setTotalAgendamentos(int totalAgendamentos) { this.totalAgendamentos = totalAgendamentos; }
    public String getNomeDentista() { return nomeDentista; }
    public void setNomeDentista(String nomeDentista) { this.nomeDentista = nomeDentista; }
    public String getCategoriaVolume() { return categoriaVolume; }
    public void setCategoriaVolume(String categoriaVolume) { this.categoriaVolume = categoriaVolume; }
}