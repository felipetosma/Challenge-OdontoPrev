package com.example.demo.service;

import com.example.demo.entity.Notificacao;
import com.example.demo.repository.NotificacaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificacaoServiceImpl implements NotificacaoService {

    @Autowired
    private NotificacaoRepository notificacaoRepository;

    @Override
    public Notificacao criarNotificacao(Notificacao notificacao) {
        return notificacaoRepository.save(notificacao);
    }

    @Override
    public Notificacao obterNotificacaoPorId(Long id) {
        return notificacaoRepository.findById(id).orElse(null);
    }

    @Override
    public List<Notificacao> listarNotificacoes() {
        return notificacaoRepository.findAll();
    }

    @Override
    public Notificacao atualizarNotificacao(Long id, Notificacao notificacao) {
        notificacao.setIdNotificacao(id);
        return notificacaoRepository.save(notificacao);
    }

    @Override
    public void excluirNotificacao(Long id) {
        notificacaoRepository.deleteById(id);
    }
}
