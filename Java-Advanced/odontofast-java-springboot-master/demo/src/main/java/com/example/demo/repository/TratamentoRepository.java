package com.example.demo.repository;

import com.example.demo.entity.Tratamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TratamentoRepository extends JpaRepository<Tratamento, Long> {
}
