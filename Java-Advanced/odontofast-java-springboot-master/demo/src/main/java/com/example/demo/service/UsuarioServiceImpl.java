package com.example.demo.service;

import com.example.demo.entity.Usuario;
import com.example.demo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioServiceImpl implements UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    public Usuario criarUsuario(Usuario usuario) {
        return usuarioRepository.save(usuario);
    }

    @Override
    public Usuario obterUsuarioPorId(Long id) {
        return usuarioRepository.findById(id).orElse(null);
    }

    @Override
    public List<Usuario> listarUsuarios() {
        return usuarioRepository.findAll();
    }

    @Override
    public Usuario atualizarUsuario(Long id, Usuario usuario) {
        usuario.setIdUsuario(id);
        return usuarioRepository.save(usuario);
    }

    @Override
    public void excluirUsuario(Long id) {
        usuarioRepository.deleteById(id);
    }
}
