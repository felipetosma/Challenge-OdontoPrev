package com.example.odontofast.service;

import com.example.odontofast.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository repository;

    public void inserirUsuario(int idUsuario, String nomeUsuario, String senhaUsuario, String emailUsuario, String nrCarteira, String telefoneUsuario) {
        repository.inserirUsuario(idUsuario, nomeUsuario, senhaUsuario, emailUsuario, nrCarteira, telefoneUsuario);
    }

    public void atualizarUsuario(int idUsuario, String nomeUsuario, String senhaUsuario, String emailUsuario, String nrCarteira, String telefoneUsuario) {
        repository.atualizarUsuario(idUsuario, nomeUsuario, senhaUsuario, emailUsuario, nrCarteira, telefoneUsuario);
    }

    public void deletarUsuario(int idUsuario) {
        repository.deletarUsuario(idUsuario);
    }
}