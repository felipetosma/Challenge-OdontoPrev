package com.example.demo.repository;

import com.example.demo.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    @Procedure(name = "CRUD_USUARIO")
    void CRUD_USUARIO(
            @Param("v_operacao") String operacao,
            @Param("v_id_usuario") Long idUsuario,
            @Param("v_nome_usuario") String nomeUsuario,
            @Param("v_senha_usuario") String senhaUsuario,
            @Param("v_email_usuario") String emailUsuario,
            @Param("v_nr_carteira") String nrCarteira,
            @Param("v_telefone_usuario") Long telefoneUsuario
    );
}
