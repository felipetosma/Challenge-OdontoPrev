package com.example.demo.repository;

import com.example.demo.entity.Dentista;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface DentistaRepository extends JpaRepository<Dentista, Long> {

    @Procedure(name = "CRUD_DENTISTA")
    void CRUD_DENTISTA(
            @Param("v_operacao") String operacao,
            @Param("v_id_dentista") Long idDentista,
            @Param("v_nome_dentista") String nomeDentista,
            @Param("v_senha_dentista") String senhaDentista,
            @Param("v_cro") String cro,
            @Param("v_telefone_dentista") Long telefoneDentista,
            @Param("v_email_dentista") String emailDentista,
            @Param("v_id_especialidade") Long idEspecialidade
    );

}