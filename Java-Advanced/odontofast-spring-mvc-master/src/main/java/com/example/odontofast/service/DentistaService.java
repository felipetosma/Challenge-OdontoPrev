package com.example.odontofast.service;

import com.example.odontofast.model.Dentista;
import com.example.odontofast.model.Especialidade;
import com.example.odontofast.repository.DentistaRepository;
import com.example.odontofast.repository.EspecialidadeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class DentistaService {

    private final DentistaRepository dentistaRepository;
    private final EspecialidadeRepository especialidadeRepository;

    public DentistaService(DentistaRepository dentistaRepository, EspecialidadeRepository especialidadeRepository) {
        this.dentistaRepository = dentistaRepository;
        this.especialidadeRepository = especialidadeRepository;
    }

    // Transactional é importante no projeto para que o Spring faça de forma
    // automática o commit no banco de dados
    @Transactional
    public Dentista salvarDentista(Dentista dentista) {
        // Buscar a especialidade pelo ID
        Optional<Especialidade> especialidadeOptional = especialidadeRepository
                .findById(dentista.getEspecialidade().getIdEspecialidade());

        if (especialidadeOptional.isEmpty()) {
            throw new RuntimeException("Especialidade não encontrada!");
        }

        // Associar a especialidade ao dentista
        dentista.setEspecialidade(especialidadeOptional.get());

        // Salvar o dentista no repositório
        return dentistaRepository.save(dentista);
    }

    // Método para autenticar o dentista (login)
    public Optional<Dentista> autenticarDentista(String cro, String senha) {
        return dentistaRepository.findByCroAndSenhaDentista(cro, senha);
    }

    // Método para buscar dentista por id
    public Optional<Dentista> buscarPorId(Long id) {
        return dentistaRepository.findById(id);
    }

    // Método para atualiza dados do dentista
    @Transactional
    public Dentista atualizarDentista(Dentista dentistaAtualizado) {
        Optional<Dentista> dentistaExistente = dentistaRepository.findById(dentistaAtualizado.getIdDentista());

        if (dentistaExistente.isPresent()) {
            Dentista dentista = dentistaExistente.get();
            dentista.setNomeDentista(dentistaAtualizado.getNomeDentista());
            dentista.setCro(dentistaAtualizado.getCro());
            dentista.setTelefoneDentista(dentistaAtualizado.getTelefoneDentista());
            dentista.setEmailDentista(dentistaAtualizado.getEmailDentista());

            return dentistaRepository.save(dentista);
        } else {
            throw new RuntimeException("Dentista não encontrado!");
        }
    }

}
