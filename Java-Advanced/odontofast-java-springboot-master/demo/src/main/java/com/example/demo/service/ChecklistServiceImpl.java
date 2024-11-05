package com.example.demo.service;

import com.example.demo.dto.ChecklistDTO;
import com.example.demo.entity.Checklist;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.ChecklistRepository;
import com.example.demo.repository.UsuarioRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ChecklistServiceImpl implements ChecklistService {

    @Autowired
    private ChecklistRepository checklistRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    public ChecklistDTO criarChecklist(ChecklistDTO checklistDTO) {
        Checklist checklist = mapearDTOParaEntidade(checklistDTO);
        checklist = checklistRepository.save(checklist);
        return mapearEntidadeParaDTO(checklist);
    }

    @Override
    public ChecklistDTO obterChecklistPorId(Long id) {
        Checklist checklist = checklistRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Checklist não encontrado com ID: " + id));
        return mapearEntidadeParaDTO(checklist);
    }

    @Override
    public List<ChecklistDTO> listarChecklists() {
        List<Checklist> checklists = checklistRepository.findAll();
        return checklists.stream()
                .map(this::mapearEntidadeParaDTO)
                .collect(Collectors.toList());
    }

    @Override
    public ChecklistDTO atualizarChecklist(Long id, ChecklistDTO checklistDTO) {
        Checklist checklist = checklistRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Checklist não encontrado com ID: " + id));
        checklist = mapearDTOParaEntidade(checklistDTO, checklist);
        checklist = checklistRepository.save(checklist);
        return mapearEntidadeParaDTO(checklist);
    }

    @Override
    public void excluirChecklist(Long id) {
        checklistRepository.deleteById(id);
    }

    // Método privado para converter entidade em DTO
    private ChecklistDTO mapearEntidadeParaDTO(Checklist checklist) {
        return new ChecklistDTO(
                checklist.getIdChecklist(),
                checklist.getEscovacaoDentes(),
                checklist.getFioDental(),
                checklist.getEnxaguanteBucal(),
                checklist.getUsuario().getIdUsuario()
        );
    }

    // Método privado para mapear DTO para a entidade
    private Checklist mapearDTOParaEntidade(ChecklistDTO checklistDTO) {

        if (checklistDTO.getUsuarioIdUsuario() == null) {
            throw new IllegalArgumentException("O ID do Usuário não pode ser nulo.");
        }

        // Busca a entidade no banco de dados
        Usuario usuario = usuarioRepository.findById(checklistDTO.getUsuarioIdUsuario())
                .orElseThrow(() -> new EntityNotFoundException("Usuário não encontrado com ID: " + checklistDTO.getUsuarioIdUsuario()));

        // Criação do Checklist
        Checklist checklist = new Checklist();
        checklist.setEscovacaoDentes(checklistDTO.getEscovacaoDentes());
        checklist.setFioDental(checklistDTO.getFioDental());
        checklist.setEnxaguanteBucal(checklistDTO.getEnxaguanteBucal());
        checklist.setUsuario(usuario); // Associa o Checklist ao Usuário

        return checklist;
    }

    // Método privado para mapear DTO para a entidade (atualizando um checklist existente)
    private Checklist mapearDTOParaEntidade(ChecklistDTO checklistDTO, Checklist checklist) {
        checklist.setEscovacaoDentes(checklistDTO.getEscovacaoDentes());
        checklist.setFioDental(checklistDTO.getFioDental());
        checklist.setEnxaguanteBucal(checklistDTO.getEnxaguanteBucal());

        // Busca a entidade associada
        Usuario usuario = usuarioRepository.findById(checklistDTO.getUsuarioIdUsuario())
                .orElseThrow(() -> new EntityNotFoundException("Usuário não encontrado com ID: " + checklistDTO.getUsuarioIdUsuario()));

        checklist.setUsuario(usuario);

        return checklist;
    }
}
