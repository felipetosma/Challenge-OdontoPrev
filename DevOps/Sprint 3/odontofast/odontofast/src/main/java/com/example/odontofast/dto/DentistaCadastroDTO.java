package com.example.odontofast.dto;

public class DentistaCadastroDTO {

    private String nomeDentista;
    private String senhaDentista;
    private String cro;
    private Long telefoneDentista;
    private String emailDentista;
    private Long especialidadeId;

    // Getters e setters

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

    public Long getTelefoneDentista() {
        return telefoneDentista;
    }

    public void setTelefoneDentista(Long telefoneDentista) {
        this.telefoneDentista = telefoneDentista;
    }

    public String getEmailDentista() {
        return emailDentista;
    }

    public void setEmailDentista(String emailDentista) {
        this.emailDentista = emailDentista;
    }

    public Long getEspecialidadeId() {
        return especialidadeId;
    }

    public void setEspecialidadeId(Long especialidadeId) {
        this.especialidadeId = especialidadeId;
    }

}