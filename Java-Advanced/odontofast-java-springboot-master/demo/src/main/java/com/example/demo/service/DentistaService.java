package com.example.demo.service;

import com.example.demo.entity.Dentista;
import java.util.List;
import java.util.Optional;

public interface DentistaService {

    Dentista criarDentista(Dentista dentista);
    Optional<Dentista> obterDentistaPorId(Long id);
    List<Dentista> listarDentistas();
    Dentista atualizarDentista(Long id, Dentista dentista);
    void excluirDentista(Long id);

}
