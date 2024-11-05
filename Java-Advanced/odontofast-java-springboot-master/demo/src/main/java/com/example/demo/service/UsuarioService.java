package com.example.demo.service;

import com.example.demo.entity.Usuario;
import java.util.List;

public interface UsuarioService {

    Usuario criarUsuario(Usuario usuario);
    Usuario obterUsuarioPorId(Long id);
    List<Usuario> listarUsuarios();
    Usuario atualizarUsuario(Long id, Usuario usuario);
    void excluirUsuario(Long id);

}
