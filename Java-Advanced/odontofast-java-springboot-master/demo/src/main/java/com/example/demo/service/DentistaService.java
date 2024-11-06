package com.example.demo.service;

import com.example.demo.dto.DentistaDTO;
import com.example.demo.repository.DentistaRepository;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

@Service
public class DentistaService {

    @Autowired
    private DentistaRepository dentistaRepository;

    @Transactional
    public void insertWithProcedure(DentistaDTO dentistaDTO) {
        dentistaRepository.CRUD_DENTISTA(
                "INSERT",
                dentistaDTO.getIdDentista(),
                dentistaDTO.getNomeDentista(),
                dentistaDTO.getSenhaDentista(),
                dentistaDTO.getCro(),
                dentistaDTO.getTelefoneDentista(),
                dentistaDTO.getEmailDentista(),
                dentistaDTO.getIdEspecialidade()
        );
    }

    @Transactional
    public void updateWithProcedure(DentistaDTO dentistaDTO) {
        dentistaRepository.CRUD_DENTISTA(
                "UPDATE",
                dentistaDTO.getIdDentista(),
                dentistaDTO.getNomeDentista(),
                dentistaDTO.getSenhaDentista(),
                dentistaDTO.getCro(),
                dentistaDTO.getTelefoneDentista(),
                dentistaDTO.getEmailDentista(),
                dentistaDTO.getIdEspecialidade()
        );
    }

    @Transactional
    public void deleteWithProcedure(DentistaDTO dentistaDTO) {
        dentistaRepository.CRUD_DENTISTA(
                "DELETE",
                dentistaDTO.getIdDentista(),
                null,
                null,
                null,
                null,
                null,
                null
        );
    }

}
