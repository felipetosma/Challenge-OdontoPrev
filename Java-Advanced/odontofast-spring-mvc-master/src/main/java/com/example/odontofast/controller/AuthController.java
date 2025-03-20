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
    @PostMapping("/cadastro")
    public String cadastrarDentista(@ModelAttribute DentistaCadastroDTO dentistaCadastroDTO, Model model) {
        try {
            Dentista dentista = new Dentista();
            dentista.setNomeDentista(dentistaCadastroDTO.getNomeDentista());
            dentista.setSenhaDentista(dentistaCadastroDTO.getSenhaDentista());
            dentista.setCro(dentistaCadastroDTO.getCro());
            dentista.setTelefoneDentista(dentistaCadastroDTO.getTelefoneDentista());
            dentista.setEmailDentista(dentistaCadastroDTO.getEmailDentista());

            // Buscar a especialidade no banco com base no ID
            Especialidade especialidade = especialidadeRepository.findById(dentistaCadastroDTO.getEspecialidadeId())
                    .orElseThrow(() -> new RuntimeException("Especialidade não encontrada"));

            dentista.setEspecialidade(especialidade);

            dentistaService.salvarDentista(dentista);

            return "login-dentista"; // Redireciona para a página home após o cadastro
        } catch (Exception e) {
            model.addAttribute("erro", "Erro ao cadastrar dentista.");
            System.out.println("ERRO INTERNO: " + e.getMessage());
            return "cadastro-dentista"; // Retorna para a página de cadastro com mensagem de erro
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

    @PostMapping("/perfil/atualizar")
    public String atualizarPerfil(@ModelAttribute Dentista dentista, HttpSession session) {
        Long dentistaId = (Long) session.getAttribute("dentistaId");

        if (dentistaId == null || !dentistaId.equals(dentista.getIdDentista())) {
            return "redirect:/dentista/login"; // Redireciona se não estiver logado ou tentar alterar outro perfil
        }

        dentistaService.atualizarDentista(dentista);
        return "redirect:/dentista/perfil"; // Redireciona para o perfil atualizado
    }

}