package com.example.odontofast.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
public class UsuarioRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void inserirUsuario(int idUsuario, String nomeUsuario, String senhaUsuario, String emailUsuario, String nrCarteira, String telefoneUsuario) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withCatalogName("PKG_ALLPCDR_ODONTOFAST")
                .withProcedureName("CRUD_USUARIO");

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("v_operacao", "INSERT");
        inParams.put("v_id_usuario", idUsuario);
        inParams.put("v_nome_usuario", nomeUsuario);
        inParams.put("v_senha_usuario", senhaUsuario);
        inParams.put("v_email_usuario", emailUsuario);
        inParams.put("v_nr_carteira", nrCarteira);
        inParams.put("v_telefone_usuario", telefoneUsuario);

        jdbcCall.execute(inParams);
    }

    public void atualizarUsuario(int idUsuario, String nomeUsuario, String senhaUsuario, String emailUsuario, String nrCarteira, String telefoneUsuario) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withCatalogName("PKG_ALLPCDR_ODONTOFAST")
                .withProcedureName("CRUD_USUARIO");

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("v_operacao", "UPDATE");
        inParams.put("v_id_usuario", idUsuario);
        inParams.put("v_nome_usuario", nomeUsuario);
        inParams.put("v_senha_usuario", senhaUsuario);
        inParams.put("v_email_usuario", emailUsuario);
        inParams.put("v_nr_carteira", nrCarteira);
        inParams.put("v_telefone_usuario", telefoneUsuario);

        jdbcCall.execute(inParams);
    }

    public void deletarUsuario(int idUsuario) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withCatalogName("PKG_ALLPCDR_ODONTOFAST")
                .withProcedureName("CRUD_USUARIO");

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("v_operacao", "DELETE");
        inParams.put("v_id_usuario", idUsuario);
        inParams.put("v_nome_usuario", null);
        inParams.put("v_senha_usuario", null);
        inParams.put("v_email_usuario", null);
        inParams.put("v_nr_carteira", null);
        inParams.put("v_telefone_usuario", null);

        jdbcCall.execute(inParams);
    }
}