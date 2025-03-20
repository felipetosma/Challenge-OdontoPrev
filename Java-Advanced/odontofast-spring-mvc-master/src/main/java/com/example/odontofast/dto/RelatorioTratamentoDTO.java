package com.example.odontofast.dto;

public class RelatorioTratamentoDTO {
    private String nomeDentista;
    private String tipoEspecialidade;
    private int totalTratamentos;
    private double mediaDiasTratamento;
    private String nomePlano;
    private String statusEspecialidade;

    public RelatorioTratamentoDTO() {}

    public RelatorioTratamentoDTO(String nomeDentista, String tipoEspecialidade, int totalTratamentos,
                                  double mediaDiasTratamento, String nomePlano, String statusEspecialidade) {
        this.nomeDentista = nomeDentista;
        this.tipoEspecialidade = tipoEspecialidade;
        this.totalTratamentos = totalTratamentos;
        this.mediaDiasTratamento = mediaDiasTratamento;
        this.nomePlano = nomePlano;
        this.statusEspecialidade = statusEspecialidade;
    }

    // Getters e Setters
    public String getNomeDentista() { return nomeDentista; }
    public void setNomeDentista(String nomeDentista) { this.nomeDentista = nomeDentista; }
    public String getTipoEspecialidade() { return tipoEspecialidade; }
    public void setTipoEspecialidade(String tipoEspecialidade) { this.tipoEspecialidade = tipoEspecialidade; }
    public int getTotalTratamentos() { return totalTratamentos; }
    public void setTotalTratamentos(int totalTratamentos) { this.totalTratamentos = totalTratamentos; }
    public double getMediaDiasTratamento() { return mediaDiasTratamento; }
    public void setMediaDiasTratamento(double mediaDiasTratamento) { this.mediaDiasTratamento = mediaDiasTratamento; }
    public String getNomePlano() { return nomePlano; }
    public void setNomePlano(String nomePlano) { this.nomePlano = nomePlano; }
    public String getStatusEspecialidade() { return statusEspecialidade; }
    public void setStatusEspecialidade(String statusEspecialidade) { this.statusEspecialidade = statusEspecialidade; }
}