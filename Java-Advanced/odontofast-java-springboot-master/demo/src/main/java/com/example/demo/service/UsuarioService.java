package com.example.demo.service;

import com.example.demo.dto.UsuarioDTO;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Transactional
    public void insertWithProcedure(UsuarioDTO usuarioDTO) {
        usuarioRepository.CRUD_USUARIO(
                "INSERT",
                usuarioDTO.getIdUsuario(),
                usuarioDTO.getNomeUsuario(),
                usuarioDTO.getSenhaUsuario(),
                usuarioDTO.getEmailUsuario(),
                usuarioDTO.getNrCarteira(),
                usuarioDTO.getTelefoneUsuario()
        );
    }

    @Transactional
    public void updateWithProcedure(UsuarioDTO usuarioDTO) {
        usuarioRepository.CRUD_USUARIO(
                "UPDATE",
                usuarioDTO.getIdUsuario(),
                usuarioDTO.getNomeUsuario(),
                usuarioDTO.getSenhaUsuario(),
                usuarioDTO.getEmailUsuario(),
                usuarioDTO.getNrCarteira(),
                usuarioDTO.getTelefoneUsuario()
        );
    }

    @Transactional
    public void deleteWithProcedure(UsuarioDTO usuarioDTO) {
        usuarioRepository.CRUD_USUARIO(
                "DELETE",
                usuarioDTO.getIdUsuario(),
                null,
                null,
                null,
                null,
                null
        );
    }

}
