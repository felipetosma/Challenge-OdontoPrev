package com.example.demo.service;

import com.example.demo.dto.TratamentoDTO;
import java.util.List;

public interface TratamentoService {

    TratamentoDTO criarTratamento(TratamentoDTO tratamentoDTO);
    TratamentoDTO obterTratamentoPorId(Long id);
    List<TratamentoDTO> listarTratamentos();
    TratamentoDTO atualizarTratamento(Long id, TratamentoDTO tratamentoDTO);
    void excluirTratamento(Long id);

}
