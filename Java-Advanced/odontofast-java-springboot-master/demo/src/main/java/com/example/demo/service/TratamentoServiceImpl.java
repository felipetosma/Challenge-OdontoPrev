package com.example.demo.service;

import com.example.demo.dto.TratamentoDTO;
import com.example.demo.entity.Dentista;
import com.example.demo.entity.Tratamento;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.DentistaRepository;
import com.example.demo.repository.TratamentoRepository;
import com.example.demo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TratamentoServiceImpl implements TratamentoService {

    @Autowired
    private TratamentoRepository tratamentoRepository;

    @Autowired
    private DentistaRepository dentistaRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    public TratamentoDTO criarTratamento(TratamentoDTO tratamentoDTO) {
        Tratamento tratamento = mapearDTOParaEntidade(tratamentoDTO, new Tratamento());
        tratamento = tratamentoRepository.save(tratamento);
        return mapearEntidadeParaDTO(tratamento);
    }

    @Override
    public TratamentoDTO obterTratamentoPorId(Long id) {
        Tratamento tratamento = tratamentoRepository.findById(id).orElseThrow();
        return mapearEntidadeParaDTO(tratamento);
    }

    @Override
    public List<TratamentoDTO> listarTratamentos() {
        List<Tratamento> tratamentos = tratamentoRepository.findAll();
        return tratamentos.stream()
                .map(this::mapearEntidadeParaDTO)
                .collect(Collectors.toList());
    }

    @Override
    public TratamentoDTO atualizarTratamento(Long id, TratamentoDTO tratamentoDTO) {
        Tratamento tratamento = tratamentoRepository.findById(id).orElseThrow();
        tratamento = mapearDTOParaEntidade(tratamentoDTO, tratamento);
        tratamento = tratamentoRepository.save(tratamento);
        return mapearEntidadeParaDTO(tratamento);
    }

    @Override
    public void excluirTratamento(Long id) {
        tratamentoRepository.deleteById(id);
    }

    // Método privado para converter entidade em DTO
    private TratamentoDTO mapearEntidadeParaDTO(Tratamento tratamento) {
        return new TratamentoDTO(
                tratamento.getIdTratamento(),
                tratamento.getTipoTratamento(),
                tratamento.getDtInicio(),
                tratamento.getDtFim(),
                tratamento.getDescricao(),
                tratamento.getStatusTratamento(),
                tratamento.getDentista().getIdDentista(),
                tratamento.getUsuario().getIdUsuario()
        );
    }

    // Método privado para mapear DTO para a entidade
    private Tratamento mapearDTOParaEntidade(TratamentoDTO tratamentoDTO, Tratamento tratamento) {
        tratamento.setTipoTratamento(tratamentoDTO.getTipo_tratamento());
        tratamento.setDtInicio(tratamentoDTO.getDt_inicio());
        tratamento.setDtFim(tratamentoDTO.getDt_fim());
        tratamento.setDescricao(tratamentoDTO.getDescricao());
        tratamento.setStatusTratamento(tratamentoDTO.getStatus_tratamento());

        // Buscar o dentista e usuário pelos IDs
        Dentista dentista = dentistaRepository.findById(tratamentoDTO.getDentista_id_dentista())
                .orElseThrow(() -> new RuntimeException("Dentista não encontrado"));
        Usuario usuario = usuarioRepository.findById(tratamentoDTO.getUsuario_id_usuario())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        tratamento.setDentista(dentista);
        tratamento.setUsuario(usuario);

        return tratamento;
    }
}
