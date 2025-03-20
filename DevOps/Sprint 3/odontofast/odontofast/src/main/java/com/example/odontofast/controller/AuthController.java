package com.example.odontofast.controller;

import com.example.odontofast.dto.DentistaCadastroDTO;
import com.example.odontofast.model.Dentista;
import com.example.odontofast.model.Especialidade;
import com.example.odontofast.repository.EspecialidadeRepository;
import com.example.odontofast.service.DentistaService;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.Optional;

@Controller
@RequestMapping("/dentista")
public class AuthController {

    // Declaração de uma variável final para armazenar a instância do serviço de
    // Dentista.
    // "final" significa que essa variável não poderá ser alterada após a
    // inicialização.
    private final DentistaService dentistaService;
    private final EspecialidadeRepository especialidadeRepository;

    // Construtor para injeção de dependência
    // Esse construtor recebe uma instância de DentistaService e a atribui à
    // variável dentistaService.
    // Isso permite que a injeção de dependência seja feita pelo Spring, sem
    // necessidade de usar @Autowired.
    public AuthController(DentistaService dentistaService, EspecialidadeRepository especialidadeRepository) {
        this.dentistaService = dentistaService;
        this.especialidadeRepository = especialidadeRepository;
    }

    private void adicionarToast(Model model, String mensagem, String tipo) {
        model.addAttribute("paramTxtMensagem", mensagem);
        model.addAttribute("paramTipoMensagem", tipo);
    }

    @GetMapping("/home")
    public String exibirHome(HttpSession session, Model model) {
        Long dentistaId = (Long) session.getAttribute("dentistaId");

        if (dentistaId == null) {
            return "redirect:/dentista/login"; // Redireciona para o login se não houver dentista na sessão
        }

        Optional<Dentista> dentista = dentistaService.buscarPorId(dentistaId);

        if (dentista.isPresent()) {
            model.addAttribute("nomeDentista", dentista.get().getNomeDentista()); // Adiciona o nome do dentista ao
                                                                                  // modelo
        } else {
            return "redirect:/dentista/login"; // Se o dentista não for encontrado, redireciona para o login
        }

        return "home"; // Retorna a página home.html
    }

    @GetMapping("/agendamentos")
    public String exibirAgendamentos(HttpSession session, Model model) {
        Long dentistaId = (Long) session.getAttribute("dentistaId");

        if (dentistaId == null) {
            return "redirect:/dentista/login"; // Redireciona para o login se não houver dentista na sessão
        }

        Optional<Dentista> dentista = dentistaService.buscarPorId(dentistaId);

        if (dentista.isPresent()) {
            model.addAttribute("nomeDentista", dentista.get().getNomeDentista()); // Adiciona o nome do dentista ao
                                                                                  // modelo
        } else {
            return "redirect:/dentista/login"; // Se o dentista não for encontrado, redireciona para o login
        }

        return "agendamentos"; // Retorna a página home.html
    }

    // Exibir a página de cadastro
    @GetMapping("/cadastro")
    public String exibirCadastroDentista() {
        return "cadastro-dentista"; // Retorna a página de cadastro
    }

    // Processar o cadastro do dentista
    // CREATE CADASTRO V1 ---------------
    // @PostMapping("/cadastro")
    // public String cadastrarDentista(@ModelAttribute DentistaCadastroDTO
    // dentistaCadastroDTO, Model model) {
    // try {
    // Dentista dentista = new Dentista();
    // dentista.setNomeDentista(dentistaCadastroDTO.getNomeDentista());
    // dentista.setSenhaDentista(dentistaCadastroDTO.getSenhaDentista());
    // dentista.setCro(dentistaCadastroDTO.getCro());
    // dentista.setTelefoneDentista(dentistaCadastroDTO.getTelefoneDentista());
    // dentista.setEmailDentista(dentistaCadastroDTO.getEmailDentista());

    // // Buscar a especialidade no banco com base no ID
    // Especialidade especialidade =
    // especialidadeRepository.findById(dentistaCadastroDTO.getEspecialidadeId())
    // .orElseThrow(() -> new RuntimeException("Especialidade não encontrada"));

    // dentista.setEspecialidade(especialidade);

    // dentistaService.salvarDentista(dentista);

    // return "login-dentista"; // Redireciona para a página home após o cadastro
    // } catch (Exception e) {
    // model.addAttribute("erro", "Erro ao cadastrar dentista.");
    // System.out.println("ERRO INTERNO: " + e.getMessage());
    // return "cadastro-dentista"; // Retorna para a página de cadastro com mensagem
    // de erro
    // }
    // }

    // CREATE CADASTRO V2 ---------------
    // @PostMapping("/cadastro")
    // public String cadastrarDentista(@ModelAttribute DentistaCadastroDTO
    // dentistaCadastroDTO, Model model) {
    // try {
    // // Criação do objeto Dentista a partir do DTO
    // Dentista dentista = new Dentista();
    // dentista.setNomeDentista(dentistaCadastroDTO.getNomeDentista());
    // dentista.setSenhaDentista(dentistaCadastroDTO.getSenhaDentista());
    // dentista.setCro(dentistaCadastroDTO.getCro());
    // dentista.setTelefoneDentista(dentistaCadastroDTO.getTelefoneDentista());
    // dentista.setEmailDentista(dentistaCadastroDTO.getEmailDentista());

    // // Descomente quando o banco voltar:
    // Especialidade especialidade =
    // especialidadeRepository.findById(dentistaCadastroDTO.getEspecialidadeId())
    // .orElseThrow(() -> new RuntimeException("Especialidade não encontrada"));

    // dentista.setEspecialidade(especialidade);

    // dentistaService.salvarDentista(dentista);

    // // Configura os parâmetros de sucesso para o toast na página de login
    // model.addAttribute("paramTxtMensagem", "Cadastro realizado com sucesso!");
    // model.addAttribute("paramTipoMensagem", "text-bg-success");
    // return "login-dentista"; // Redireciona para a página de login
    // } catch (Exception e) {
    // // Em caso de erro, mantém os dados do formulário e adiciona mensagem de erro
    // model.addAttribute("dentistaCadastroDTO", dentistaCadastroDTO); // Mantém os
    // dados preenchidos
    // model.addAttribute("paramTxtMensagem", "Erro ao cadastrar dentista");
    // model.addAttribute("paramTipoMensagem", "text-bg-danger");
    // return "cadastro-dentista"; // Retorna para a página de cadastro com toast
    // }
    // }

    @PostMapping("/cadastro")
    public String cadastrarDentista(@ModelAttribute DentistaCadastroDTO dentistaCadastroDTO, Model model) {
        try {
            Dentista dentista = new Dentista();
            dentista.setNomeDentista(dentistaCadastroDTO.getNomeDentista());
            dentista.setSenhaDentista(dentistaCadastroDTO.getSenhaDentista());
            dentista.setCro(dentistaCadastroDTO.getCro());
            dentista.setTelefoneDentista(dentistaCadastroDTO.getTelefoneDentista());
            dentista.setEmailDentista(dentistaCadastroDTO.getEmailDentista());
            Especialidade especialidade = especialidadeRepository.findById(dentistaCadastroDTO.getEspecialidadeId())
                    .orElseThrow(() -> new RuntimeException("Especialidade não encontrada"));
            System.out.println("Dentista cadastrado (mock): " + dentista.getNomeDentista());
            dentista.setEspecialidade(especialidade);
            dentistaService.salvarDentista(dentista);
            adicionarToast(model, "Cadastro realizado com sucesso!", "text-bg-success");
            return "login-dentista";
        } catch (Exception e) {
            adicionarToast(model, "Erro ao cadastrar dentista", "text-bg-danger");
            model.addAttribute("dentistaCadastroDTO", dentistaCadastroDTO);
            return "cadastro-dentista";
        }
    }

    // Tela de login de dentista
    @GetMapping("/login")
    public String exibirLoginDentista() {
        return "login-dentista"; // A view será a página login.html
    }

    // Endpoint de login (o formulário será enviado via POST)
    @PostMapping("/login")
    public String loginDentista(@RequestParam String cro, @RequestParam String senha, Model model,
            HttpSession session) {
        Optional<Dentista> dentista = dentistaService.autenticarDentista(cro, senha);

        if (dentista.isPresent()) {
            session.setAttribute("dentistaId", dentista.get().getIdDentista()); // Armazena o ID na sessão
            return "redirect:/dentista/home"; // Redireciona para evitar reenvio do formulário
        } else {
            model.addAttribute("erro", "Credenciais inválidas!");
            return "login-dentista";
        }
    }

    // @GetMapping("/perfil")
    // public String exibirPerfil() {
    // return "perfil"; // A view será a página login.html
    // }

    @GetMapping("/perfil")
    public String exibirPerfil(HttpSession session, Model model) {
        Long dentistaId = (Long) session.getAttribute("dentistaId"); // Recupera o ID da sessão

        if (dentistaId == null) {
            return "redirect:/dentista/login"; // Redireciona se não estiver logado
        }

        Optional<Dentista> dentista = dentistaService.buscarPorId(dentistaId);

        if (dentista.isPresent()) {
            model.addAttribute("dentista", dentista.get());
            return "perfil"; // Retorna a página perfil.html
        } else {
            return "redirect:/dentista/home"; // Se não encontrar, redireciona para home
        }
    }

    // UPDATE PERFIL V1 ---------------
    // @PostMapping("/perfil/atualizar")
    // public String atualizarPerfil(@ModelAttribute Dentista dentista, HttpSession
    // session) {
    // Long dentistaId = (Long) session.getAttribute("dentistaId");

    // if (dentistaId == null || !dentistaId.equals(dentista.getIdDentista())) {
    // return "redirect:/dentista/login"; // Redireciona se não estiver logado ou
    // tentar alterar outro perfil
    // }

    // dentistaService.atualizarDentista(dentista);
    // return "redirect:/dentista/perfil"; // Redireciona para o perfil atualizado
    // }

    // UPDATE PERFIL V2 ---------------
    // @PostMapping("/perfil/atualizar")
    // public String atualizarPerfil(@ModelAttribute Dentista dentista, HttpSession
    // session, Model model) {
    // Long dentistaId = (Long) session.getAttribute("dentistaId");

    // // Verifica se o dentista está logado e se o ID corresponde
    // if (dentistaId == null || !dentistaId.equals(dentista.getIdDentista())) {
    // model.addAttribute("paramTxtMensagem", "Acesso negado. Faça login
    // novamente.");
    // model.addAttribute("paramTipoMensagem", "text-bg-danger");
    // return "perfil"; // Retorna para a página com mensagem de erro
    // }

    // try {
    // // Simulação de atualização (substitui dentistaService.atualizarDentista)
    // System.out.println("Dentista atualizado (mock): " +
    // dentista.getNomeDentista());
    // dentistaService.atualizarDentista(dentista);

    // // Configura os parâmetros de sucesso
    // model.addAttribute("paramTxtMensagem", "Perfil atualizado com sucesso!");
    // model.addAttribute("paramTipoMensagem", "text-bg-success");
    // } catch (Exception e) {
    // // Simulação de erro
    // model.addAttribute("paramTxtMensagem", "Erro ao atualizar o perfil.");
    // model.addAttribute("paramTipoMensagem", "text-bg-danger");
    // }

    // // Re-adiciona o objeto dentista ao model para manter o formulário preenchido
    // model.addAttribute("dentista", dentista);
    // return "perfil"; // Retorna para a mesma página com o toast
    // }

    @PostMapping("/perfil/atualizar")
    public String atualizarPerfil(@ModelAttribute Dentista dentista, HttpSession session, Model model) {
        Long dentistaId = (Long) session.getAttribute("dentistaId");
        if (dentistaId == null || !dentistaId.equals(dentista.getIdDentista())) {
            adicionarToast(model, "Acesso negado. Faça login novamente.", "text-bg-danger");
            return "perfil";
        }
        try {
            System.out.println("Dentista atualizado (mock): " + dentista.getNomeDentista());
            dentistaService.atualizarDentista(dentista);
            adicionarToast(model, "Perfil atualizado com sucesso!", "text-bg-success");
        } catch (Exception e) {
            adicionarToast(model, "Erro ao atualizar o perfil.", "text-bg-danger");
        }
        model.addAttribute("dentista", dentista);
        return "perfil";
    }

}