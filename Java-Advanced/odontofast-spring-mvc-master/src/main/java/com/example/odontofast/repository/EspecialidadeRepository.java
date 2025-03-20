package com.example.odontofast.repository;

import com.example.odontofast.model.Especialidade;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EspecialidadeRepository extends JpaRepository<Especialidade, Long> {
    // O método findById já está fornecido pelo JpaRepository
}
