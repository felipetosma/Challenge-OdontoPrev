package com.challenge.odonto_prev.services;

import com.challenge.odonto_prev.domain.Patient;
import com.challenge.odonto_prev.domain.dto.PatientDTO;
import com.challenge.odonto_prev.repositories.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    @Transactional
    public PatientDTO insert(PatientDTO patientDTO) {
        Patient patient = new Patient(patientDTO);
        patient.setCreatedAt(LocalDate.now());
        patient = patientRepository.save(patient);
        return new PatientDTO(patient);
    }

    @Transactional
    public void insertWithProcedure(PatientDTO patientDTO) {
        this.patientRepository.INSERT_PATIENT(patientDTO.getBirthDate(), patientDTO.getNumCard(), patientDTO.getName(), patientDTO.getRg());
    }

    public List<PatientDTO> findAll() {
        return patientRepository.findAll().stream().map(PatientDTO::new).toList();
    }

    public PatientDTO findById(Long id) {
        return new PatientDTO(patientRepository.findById(id).orElseThrow(() -> new NoSuchElementException("Paciente não encontrado !!")));
    }

    public PatientDTO findByRg(String rg) {
        return new PatientDTO(patientRepository.findByRg(rg).orElseThrow(() -> new NoSuchElementException("Paciente não encontrado !!")));
    }
}
