package com.challenge.odonto_prev.repositories;

import com.challenge.odonto_prev.domain.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.Optional;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    Optional<Patient> findByRg(String rg);

    @Procedure(name = "INSERT_PATIENT")
    void INSERT_PATIENT(@Param("p_birth_date") LocalDate birthdate, @Param("p_num_card") Long num_card, @Param("p_name") String name, @Param("p_rg") String rg);
}
