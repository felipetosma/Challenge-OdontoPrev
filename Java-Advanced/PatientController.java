package com.challenge.odonto_prev.controllers;

import com.challenge.odonto_prev.domain.dto.PatientDTO;
import com.challenge.odonto_prev.services.PatientService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequestMapping("/patients")
public class PatientController {

    @Autowired
    private PatientService patientService;

    @PostMapping
    public ResponseEntity<PatientDTO> insert(@RequestBody @Valid PatientDTO patientDTO) {
        PatientDTO patient = patientService.insert(patientDTO);
        patient.add(linkTo(methodOn(PatientController.class).findAll()).withRel("find all"));
        return ResponseEntity.ok(patient);
    }

    @PostMapping("/withProcedure")
    public ResponseEntity insertWithProcedure(@RequestBody @Valid PatientDTO patientDTO) {
        this.patientService.insertWithProcedure(patientDTO);
        return ResponseEntity.ok("FOI");
    }

    @GetMapping
    public ResponseEntity<List<PatientDTO>> findAll() {
        List<PatientDTO> patients = patientService.findAll();
        patients.forEach(patient -> patient.add(linkTo(methodOn(PatientController.class).insert(new PatientDTO())).withRel("Insert")));
        return ResponseEntity.ok(patients);
    }

    @GetMapping("/{rg}")
    public ResponseEntity<PatientDTO> findByRg(@PathVariable String rg) {
        PatientDTO patient = patientService.findByRg(rg);
        patient.add(linkTo(methodOn(PatientController.class).findAll()).withRel("find all"));
        patient.add(linkTo(methodOn(PatientController.class).insert(new PatientDTO())).withRel("Insert"));
        return ResponseEntity.ok(patient);
    }


}
