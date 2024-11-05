package com.example.demo.service;

import com.example.demo.entity.Notificacao;
import java.util.List;

public interface NotificacaoService {

    Notificacao criarNotificacao(Notificacao notificacao);
    Notificacao obterNotificacaoPorId(Long id);
    List<Notificacao> listarNotificacoes();
    Notificacao atualizarNotificacao(Long id, Notificacao notificacao);
    void excluirNotificacao(Long id);

}
