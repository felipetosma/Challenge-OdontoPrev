package com.example.odontofast.dto;

public class UsuarioDTO {
    private String nomeUsuario;
    private String senhaUsuario;
    private String emailUsuario;
    private String nrCarteira;
    private String telefoneUsuario;

    public UsuarioDTO() {}

    public UsuarioDTO(String nomeUsuario, String senhaUsuario, String emailUsuario,
                      String nrCarteira, String telefoneUsuario) {
        this.nomeUsuario = nomeUsuario;
        this.senhaUsuario = senhaUsuario;
        this.emailUsuario = emailUsuario;
        this.nrCarteira = nrCarteira;
        this.telefoneUsuario = telefoneUsuario;
    }

    // Getters e Setters
    public String getNomeUsuario() { return nomeUsuario; }
    public void setNomeUsuario(String nomeUsuario) { this.nomeUsuario = nomeUsuario; }
    public String getSenhaUsuario() { return senhaUsuario; }
    public void setSenhaUsuario(String senhaUsuario) { this.senhaUsuario = senhaUsuario; }
    public String getEmailUsuario() { return emailUsuario; }
    public void setEmailUsuario(String emailUsuario) { this.emailUsuario = emailUsuario; }
    public String getNrCarteira() { return nrCarteira; }
    public void setNrCarteira(String nrCarteira) { this.nrCarteira = nrCarteira; }
    public String getTelefoneUsuario() { return telefoneUsuario; }
    public void setTelefoneUsuario(String telefoneUsuario) { this.telefoneUsuario = telefoneUsuario; }
}