package com.example.odontofast.repository;

import com.example.odontofast.model.Dentista;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DentistaRepository extends JpaRepository<Dentista, Long> {
    //O uso de Optional no Java (e no contexto do Spring Data JPA) serve para representar um valor que pode ou não estar presente.
    //No caso do método findByCroAndSenhaDentista do repositório, ele retorna um Optional<Dentista>,
    //o que indica que o dentista pode não ser encontrado no banco de dados
    Optional<Dentista> findByCroAndSenhaDentista(String cro, String senhaDentista);

}
