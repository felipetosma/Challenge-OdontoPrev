import os
import pymongo
from pymongo import MongoClient
from bson import ObjectId
from datetime import datetime, timedelta
import json

# Configurações do sistema
NOME_SISTEMA = "Odontofast - Sistema de Acompanhamento de Tratamentos"


# Conectar ao MongoDB
def conectar_mongodb():
    try:
        client = MongoClient('mongodb://localhost:27017/')
        db = client['odontofast']
        # Garantir que as coleções existam
        colecoes = ['usuarios', 'dentistas', 'tratamentos', 'agendamentos']
        for colecao in colecoes:
            if colecao not in db.list_collection_names():
                db.create_collection(colecao)
        return db
    except Exception as e:
        print(f"Erro ao conectar ao MongoDB: {e}")
        print("Verifique se o MongoDB está em execução.")
        return None


# Funções auxiliares
def limpar_tela():
    os.system('cls' if os.name == 'nt' else 'clear')


def formatar_data(data):
    if isinstance(data, datetime):
        return data.strftime("%d/%m/%Y")
    return str(data) if data else "N/A"


def entrada_data():
    while True:
        try:
            data_str = input("Data (DD/MM/AAAA): ")
            return datetime.strptime(data_str, "%d/%m/%Y")
        except ValueError:
            print("Formato de data inválido. Use DD/MM/AAAA.")


def exibir_documento(doc):
    # Converte para JSON formatado para exibição
    return json.dumps(json.loads(json.dumps(doc, default=str)), indent=2)


def confirmar_acao(mensagem="Confirma esta ação?"):
    resposta = input(f"{mensagem} (s/n): ").lower()
    return resposta == 's'


# MENU PRINCIPAL
def menu_principal():
    db = conectar_mongodb()
    if db is None:
        print("Não foi possível conectar ao MongoDB. O programa será encerrado.")
        return

    while True:
        limpar_tela()
        print("=" * 50)
        print(f"{NOME_SISTEMA}")
        print("=" * 50)
        print("1 - Usuários (Pacientes)")
        print("2 - Dentistas")
        print("3 - Tratamentos")
        print("4 - Agendamentos")
        print("0 - Sair")
        print("=" * 50)

        opcao = input("Escolha uma opção: ")

        if opcao == '1':
            menu_usuarios(db)
        elif opcao == '2':
            menu_dentistas(db)
        elif opcao == '3':
            menu_tratamentos(db)
        elif opcao == '4':
            menu_agendamentos(db)
        elif opcao == '0':
            print("Encerrando o sistema...")
            break
        else:
            input("Opção inválida. Pressione ENTER para continuar...")


# MENUS DE GERENCIAMENTO

# 1. USUÁRIOS
def menu_usuarios(db):
    while True:
        limpar_tela()
        print("=" * 50)
        print("GERENCIAMENTO DE USUÁRIOS (PACIENTES)")
        print("=" * 50)
        print("1 - Listar Todos")
        print("2 - Buscar por ID")
        print("3 - Buscar por Email")
        print("4 - Adicionar")
        print("5 - Atualizar")
        print("6 - Excluir")
        print("0 - Voltar")
        print("=" * 50)

        opcao = input("Escolha uma opção: ")

        if opcao == '1':
            listar_usuarios(db)
        elif opcao == '2':
            buscar_usuario_por_id(db)
        elif opcao == '3':
            buscar_usuario_por_email(db)
        elif opcao == '4':
            adicionar_usuario(db)
        elif opcao == '5':
            atualizar_usuario(db)
        elif opcao == '6':
            excluir_usuario(db)
        elif opcao == '0':
            break
        else:
            input("Opção inválida. Pressione ENTER para continuar...")


def listar_usuarios(db):
    limpar_tela()
    print("LISTA DE USUÁRIOS")
    print("=" * 50)

    usuarios = list(db.usuarios.find())
    if not usuarios:
        print("Nenhum usuário cadastrado.")
    else:
        for usuario in usuarios:
            print(f"ID: {usuario['_id']}")
            print(f"Nome: {usuario.get('nome', 'N/A')}")
            print(f"Email: {usuario.get('email', 'N/A')}")
            print(f"Telefone: {usuario.get('telefone', 'N/A')}")
            print("-" * 30)

    input("Pressione ENTER para continuar...")


def buscar_usuario_por_id(db):
    limpar_tela()
    print("BUSCAR USUÁRIO POR ID")
    print("=" * 50)

    id_usuario = input("Digite o ID do usuário: ")
    try:
        usuario = db.usuarios.find_one({"_id": ObjectId(id_usuario)})
        if usuario:
            print("\nUsuário encontrado:")
            print(exibir_documento(usuario))
        else:
            print("Usuário não encontrado.")
    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def buscar_usuario_por_email(db):
    limpar_tela()
    print("BUSCAR USUÁRIO POR EMAIL")
    print("=" * 50)

    email = input("Digite o email do usuário: ")
    usuario = db.usuarios.find_one({"email": email})

    if usuario:
        print("\nUsuário encontrado:")
        print(exibir_documento(usuario))
    else:
        print("Usuário não encontrado.")

    input("\nPressione ENTER para continuar...")


def adicionar_usuario(db):
    limpar_tela()
    print("ADICIONAR NOVO USUÁRIO")
    print("=" * 50)

    try:
        nome = input("Nome: ")
        email = input("Email: ")
        senha = input("Senha: ")
        telefone = input("Telefone: ")
        nr_carteira = input("Número da carteira: ")
        data_nascimento = entrada_data()

        # Endereço
        print("\nENDEREÇO:")
        logradouro = input("Logradouro: ")
        numero = input("Número: ")
        complemento = input("Complemento: ")
        bairro = input("Bairro: ")
        cidade = input("Cidade: ")
        estado = input("Estado (sigla): ")
        cep = input("CEP: ")

        # Histórico médico
        print("\nHISTÓRICO MÉDICO:")
        alergias = input("Alergias (separadas por vírgula): ").split(',')
        doencas = input("Doenças crônicas (separadas por vírgula): ").split(',')
        medicamentos = input("Medicamentos (separados por vírgula): ").split(',')

        # Convênio
        print("\nCONVÊNIO:")
        convenio_nome = input("Nome do convênio: ")
        convenio_numero = input("Número do convênio: ")
        convenio_plano = input("Plano: ")

        novo_usuario = {
            "nome": nome,
            "email": email,
            "senha": senha,
            "telefone": telefone,
            "nr_carteira": nr_carteira,
            "data_nascimento": data_nascimento,
            "ultimo_acesso": datetime.now(),
            "endereco": {
                "logradouro": logradouro,
                "numero": numero,
                "complemento": complemento,
                "bairro": bairro,
                "cidade": cidade,
                "estado": estado,
                "cep": cep
            },
            "historico_medico": {
                "alergias": [a.strip() for a in alergias if a.strip()],
                "doencas_cronicas": [d.strip() for d in doencas if d.strip()],
                "medicamentos": [m.strip() for m in medicamentos if m.strip()]
            },
            "convenio": {
                "nome": convenio_nome,
                "numero": convenio_numero,
                "plano": convenio_plano,
                "validade": datetime.now() + timedelta(days=365)
            }
        }

        resultado = db.usuarios.insert_one(novo_usuario)
        print(f"\nUsuário adicionado com sucesso! ID: {resultado.inserted_id}")

    except Exception as e:
        print(f"Erro ao adicionar usuário: {e}")

    input("\nPressione ENTER para continuar...")


def atualizar_usuario(db):
    limpar_tela()
    print("ATUALIZAR USUÁRIO")
    print("=" * 50)

    id_usuario = input("Digite o ID do usuário: ")

    try:
        usuario = db.usuarios.find_one({"_id": ObjectId(id_usuario)})
        if not usuario:
            print("Usuário não encontrado.")
            input("\nPressione ENTER para continuar...")
            return

        print("\nDados atuais:")
        print(f"Nome: {usuario.get('nome', '')}")
        print(f"Email: {usuario.get('email', '')}")
        print(f"Telefone: {usuario.get('telefone', '')}")

        print("\nDeixe em branco os campos que não deseja alterar.")
        nome = input(f"Nome [{usuario.get('nome', '')}]: ")
        email = input(f"Email [{usuario.get('email', '')}]: ")
        telefone = input(f"Telefone [{usuario.get('telefone', '')}]: ")

        atualizacoes = {}
        if nome: atualizacoes["nome"] = nome
        if email: atualizacoes["email"] = email
        if telefone: atualizacoes["telefone"] = telefone

        if atualizacoes and confirmar_acao("Confirma a atualização?"):
            resultado = db.usuarios.update_one(
                {"_id": ObjectId(id_usuario)},
                {"$set": atualizacoes}
            )

            if resultado.modified_count > 0:
                print("Usuário atualizado com sucesso!")
            else:
                print("Nenhuma alteração realizada.")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def excluir_usuario(db):
    limpar_tela()
    print("EXCLUIR USUÁRIO")
    print("=" * 50)

    id_usuario = input("Digite o ID do usuário: ")

    try:
        usuario = db.usuarios.find_one({"_id": ObjectId(id_usuario)})
        if not usuario:
            print("Usuário não encontrado.")
            input("\nPressione ENTER para continuar...")
            return

        print("\nDados do usuário:")
        print(f"Nome: {usuario.get('nome', 'N/A')}")
        print(f"Email: {usuario.get('email', 'N/A')}")

        if confirmar_acao("Tem certeza que deseja excluir este usuário?"):
            # Verificar se há tratamentos ou agendamentos vinculados
            tratamentos = db.tratamentos.find_one({"id_usuario": ObjectId(id_usuario)})
            agendamentos = db.agendamentos.find_one({"id_usuario": ObjectId(id_usuario)})

            if tratamentos or agendamentos:
                print("Não é possível excluir este usuário pois existem tratamentos ou agendamentos vinculados.")
            else:
                resultado = db.usuarios.delete_one({"_id": ObjectId(id_usuario)})
                if resultado.deleted_count > 0:
                    print("Usuário excluído com sucesso!")
                else:
                    print("Erro ao excluir usuário.")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


# 2. DENTISTAS
def menu_dentistas(db):
    while True:
        limpar_tela()
        print("=" * 50)
        print("GERENCIAMENTO DE DENTISTAS")
        print("=" * 50)
        print("1 - Listar Todos")
        print("2 - Buscar por ID")
        print("3 - Buscar por CRO")
        print("4 - Adicionar")
        print("5 - Atualizar")
        print("6 - Excluir")
        print("0 - Voltar")
        print("=" * 50)

        opcao = input("Escolha uma opção: ")

        if opcao == '1':
            listar_dentistas(db)
        elif opcao == '2':
            buscar_dentista_por_id(db)
        elif opcao == '3':
            buscar_dentista_por_cro(db)
        elif opcao == '4':
            adicionar_dentista(db)
        elif opcao == '5':
            atualizar_dentista(db)
        elif opcao == '6':
            excluir_dentista(db)
        elif opcao == '0':
            break
        else:
            input("Opção inválida. Pressione ENTER para continuar...")


def listar_dentistas(db):
    limpar_tela()
    print("LISTA DE DENTISTAS")
    print("=" * 50)

    dentistas = list(db.dentistas.find())
    if not dentistas:
        print("Nenhum dentista cadastrado.")
    else:
        for dentista in dentistas:
            print(f"ID: {dentista['_id']}")
            print(f"Nome: {dentista.get('nome', 'N/A')}")
            print(f"CRO: {dentista.get('cro', 'N/A')}")
            print(f"Especialidade: {dentista.get('especialidade', 'N/A')}")
            print("-" * 30)

    input("Pressione ENTER para continuar...")


def buscar_dentista_por_id(db):
    limpar_tela()
    print("BUSCAR DENTISTA POR ID")
    print("=" * 50)

    id_dentista = input("Digite o ID do dentista: ")
    try:
        dentista = db.dentistas.find_one({"_id": ObjectId(id_dentista)})
        if dentista:
            print("\nDentista encontrado:")
            print(exibir_documento(dentista))
        else:
            print("Dentista não encontrado.")
    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def buscar_dentista_por_cro(db):
    limpar_tela()
    print("BUSCAR DENTISTA POR CRO")
    print("=" * 50)

    cro = input("Digite o CRO do dentista: ")
    dentista = db.dentistas.find_one({"cro": cro})

    if dentista:
        print("\nDentista encontrado:")
        print(exibir_documento(dentista))
    else:
        print("Dentista não encontrado.")

    input("\nPressione ENTER para continuar...")


def adicionar_dentista(db):
    limpar_tela()
    print("ADICIONAR NOVO DENTISTA")
    print("=" * 50)

    try:
        nome = input("Nome: ")
        cro = input("CRO: ")
        senha = input("Senha: ")
        email = input("Email: ")
        telefone = input("Telefone: ")

        print("\nEspecialidade:")
        print("1 - Clínico Geral")
        print("2 - Ortodontia")
        print("3 - Endodontia")
        print("4 - Periodontia")
        print("5 - Implantodontia")
        print("6 - Outra")
        opcao_esp = input("Escolha uma opção: ")

        especialidades = ["Clínico Geral", "Ortodontia", "Endodontia", "Periodontia", "Implantodontia"]
        if opcao_esp in "12345":
            especialidade = especialidades[int(opcao_esp) - 1]
        else:
            especialidade = input("Digite a especialidade: ")

        print("\nDias de atendimento (s/n):")
        dias = []
        dias_semana = ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
        for dia in dias_semana:
            if input(f"{dia}-feira: ").lower() == 's':
                dias.append(dia)

        horario_inicio = input("Horário de início (HH:MM): ")
        horario_fim = input("Horário de término (HH:MM): ")

        novo_dentista = {
            "nome": nome,
            "cro": cro,
            "senha": senha,
            "email": email,
            "telefone": telefone,
            "data_cadastro": datetime.now(),
            "especialidade": especialidade,
            "dias_atendimento": dias,
            "horario_inicio": horario_inicio,
            "horario_fim": horario_fim
        }

        resultado = db.dentistas.insert_one(novo_dentista)
        print(f"\nDentista adicionado com sucesso! ID: {resultado.inserted_id}")

    except Exception as e:
        print(f"Erro ao adicionar dentista: {e}")

    input("\nPressione ENTER para continuar...")


def atualizar_dentista(db):
    limpar_tela()
    print("ATUALIZAR DENTISTA")
    print("=" * 50)

    id_dentista = input("Digite o ID do dentista: ")

    try:
        dentista = db.dentistas.find_one({"_id": ObjectId(id_dentista)})
        if not dentista:
            print("Dentista não encontrado.")
            input("\nPressione ENTER para continuar...")
            return

        print("\nDados atuais:")
        print(f"Nome: {dentista.get('nome', '')}")
        print(f"Email: {dentista.get('email', '')}")
        print(f"Telefone: {dentista.get('telefone', '')}")
        print(f"Especialidade: {dentista.get('especialidade', '')}")

        print("\nDeixe em branco os campos que não deseja alterar.")
        nome = input(f"Nome [{dentista.get('nome', '')}]: ")
        email = input(f"Email [{dentista.get('email', '')}]: ")
        telefone = input(f"Telefone [{dentista.get('telefone', '')}]: ")
        especialidade = input(f"Especialidade [{dentista.get('especialidade', '')}]: ")

        atualizacoes = {}
        if nome: atualizacoes["nome"] = nome
        if email: atualizacoes["email"] = email
        if telefone: atualizacoes["telefone"] = telefone
        if especialidade: atualizacoes["especialidade"] = especialidade

        if atualizacoes and confirmar_acao("Confirma a atualização?"):
            resultado = db.dentistas.update_one(
                {"_id": ObjectId(id_dentista)},
                {"$set": atualizacoes}
            )

            if resultado.modified_count > 0:
                print("Dentista atualizado com sucesso!")
            else:
                print("Nenhuma alteração realizada.")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def excluir_dentista(db):
    limpar_tela()
    print("EXCLUIR DENTISTA")
    print("=" * 50)

    id_dentista = input("Digite o ID do dentista: ")

    try:
        dentista = db.dentistas.find_one({"_id": ObjectId(id_dentista)})
        if not dentista:
            print("Dentista não encontrado.")
            input("\nPressione ENTER para continuar...")
            return

        print("\nDados do dentista:")
        print(f"Nome: {dentista.get('nome', 'N/A')}")
        print(f"CRO: {dentista.get('cro', 'N/A')}")

        if confirmar_acao("Tem certeza que deseja excluir este dentista?"):
            # Verificar se há tratamentos vinculados
            tratamentos = db.tratamentos.find_one({"id_dentista": ObjectId(id_dentista)})

            if tratamentos:
                print("Não é possível excluir este dentista pois existem tratamentos vinculados.")
            else:
                resultado = db.dentistas.delete_one({"_id": ObjectId(id_dentista)})
                if resultado.deleted_count > 0:
                    print("Dentista excluído com sucesso!")
                else:
                    print("Erro ao excluir dentista.")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


# 3. TRATAMENTOS
def menu_tratamentos(db):
    while True:
        limpar_tela()
        print("=" * 50)
        print("GERENCIAMENTO DE TRATAMENTOS")
        print("=" * 50)
        print("1 - Listar Todos")
        print("2 - Buscar por ID")
        print("3 - Buscar por Paciente")
        print("4 - Adicionar")
        print("5 - Atualizar")
        print("6 - Adicionar Procedimento")
        print("7 - Excluir")
        print("0 - Voltar")
        print("=" * 50)

        opcao = input("Escolha uma opção: ")

        if opcao == '1':
            listar_tratamentos(db)
        elif opcao == '2':
            buscar_tratamento_por_id(db)
        elif opcao == '3':
            buscar_tratamento_por_paciente(db)
        elif opcao == '4':
            adicionar_tratamento(db)
        elif opcao == '5':
            atualizar_tratamento(db)
        elif opcao == '6':
            adicionar_procedimento(db)
        elif opcao == '7':
            excluir_tratamento(db)
        elif opcao == '0':
            break
        else:
            input("Opção inválida. Pressione ENTER para continuar...")


def listar_tratamentos(db):
    limpar_tela()
    print("LISTA DE TRATAMENTOS")
    print("=" * 50)

    tratamentos = list(db.tratamentos.find())
    if not tratamentos:
        print("Nenhum tratamento cadastrado.")
    else:
        for tratamento in tratamentos:
            print(f"ID: {tratamento['_id']}")
            print(f"Paciente: {tratamento.get('usuario_nome', 'N/A')}")
            print(f"Tipo: {tratamento.get('tipo_tratamento', 'N/A')}")
            print(f"Início: {formatar_data(tratamento.get('data_inicio', None))}")
            print(f"Término Previsto: {formatar_data(tratamento.get('data_termino_prevista', None))}")
            print(f"Status: {'Em andamento' if not tratamento.get('data_termino_efetiva') else 'Concluído'}")
            print("-" * 30)

    input("Pressione ENTER para continuar...")


def buscar_tratamento_por_id(db):
    limpar_tela()
    print("BUSCAR TRATAMENTO POR ID")
    print("=" * 50)

    id_tratamento = input("Digite o ID do tratamento: ")
    try:
        tratamento = db.tratamentos.find_one({"_id": ObjectId(id_tratamento)})
        if tratamento:
            print("\nTratamento encontrado:")
            print(exibir_documento(tratamento))
        else:
            print("Tratamento não encontrado.")
    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def buscar_tratamento_por_paciente(db):
    limpar_tela()
    print("BUSCAR TRATAMENTO POR PACIENTE")
    print("=" * 50)

    # Listar usuários para seleção
    usuarios = list(db.usuarios.find({}, {"_id": 1, "nome": 1}))
    if not usuarios:
        print("Nenhum usuário cadastrado.")
        input("\nPressione ENTER para continuar...")
        return

    print("Usuários cadastrados:")
    for i, usuario in enumerate(usuarios):
        print(f"{i + 1} - {usuario.get('nome', 'N/A')} (ID: {usuario['_id']})")

    try:
        opcao = int(input("\nEscolha um usuário (número): "))
        if opcao < 1 or opcao > len(usuarios):
            print("Opção inválida.")
            input("\nPressione ENTER para continuar...")
            return

        id_usuario = usuarios[opcao - 1]["_id"]

        tratamentos = list(db.tratamentos.find({"id_usuario": id_usuario}))
        if not tratamentos:
            print("Nenhum tratamento encontrado para este paciente.")
        else:
            print(f"\nTratamentos de {usuarios[opcao - 1].get('nome', 'N/A')}:")
            for tratamento in tratamentos:
                print("-" * 30)
                print(f"ID: {tratamento['_id']}")
                print(f"Tipo: {tratamento.get('tipo_tratamento', 'N/A')}")
                print(f"Início: {formatar_data(tratamento.get('data_inicio', None))}")
                print(f"Status: {'Em andamento' if not tratamento.get('data_termino_efetiva') else 'Concluído'}")
    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def adicionar_tratamento(db):
    limpar_tela()
    print("ADICIONAR NOVO TRATAMENTO")
    print("=" * 50)

    # Listar usuários e dentistas para seleção
    usuarios = list(db.usuarios.find({}, {"_id": 1, "nome": 1}))
    dentistas = list(db.dentistas.find({}, {"_id": 1, "nome": 1, "especialidade": 1}))

    if not usuarios:
        print("Nenhum usuário cadastrado. Cadastre um usuário primeiro.")
        input("\nPressione ENTER para continuar...")
        return

    if not dentistas:
        print("Nenhum dentista cadastrado. Cadastre um dentista primeiro.")
        input("\nPressione ENTER para continuar...")
        return

    try:
        # Selecionar usuário
        print("Usuários cadastrados:")
        for i, usuario in enumerate(usuarios):
            print(f"{i + 1} - {usuario.get('nome', 'N/A')}")

        opcao_usuario = int(input("\nEscolha um usuário (número): "))
        if opcao_usuario < 1 or opcao_usuario > len(usuarios):
            print("Opção inválida.")
            input("\nPressione ENTER para continuar...")
            return

        id_usuario = usuarios[opcao_usuario - 1]["_id"]
        nome_usuario = usuarios[opcao_usuario - 1].get("nome", "")

        # Selecionar dentista
        print("\nDentistas cadastrados:")
        for i, dentista in enumerate(dentistas):
            print(f"{i + 1} - {dentista.get('nome', 'N/A')} ({dentista.get('especialidade', 'N/A')})")

        opcao_dentista = int(input("\nEscolha um dentista (número): "))
        if opcao_dentista < 1 or opcao_dentista > len(dentistas):
            print("Opção inválida.")
            input("\nPressione ENTER para continuar...")
            return

        id_dentista = dentistas[opcao_dentista - 1]["_id"]
        nome_dentista = dentistas[opcao_dentista - 1].get("nome", "")

        # Dados do tratamento
        print("\nTipo de tratamento:")
        print("1 - Ortodôntico")
        print("2 - Endodôntico")
        print("3 - Restaurador")
        print("4 - Cirúrgico")
        print("5 - Outro")
        opcao_tipo = input("Escolha uma opção: ")

        tipos = ["Ortodôntico", "Endodôntico", "Restaurador", "Cirúrgico"]
        if opcao_tipo in "1234":
            tipo_tratamento = tipos[int(opcao_tipo) - 1]
        else:
            tipo_tratamento = input("Digite o tipo de tratamento: ")

        descricao = input("Descrição: ")

        print("\nData de início (deixe em branco para hoje):")
        data_inicio_str = input("Data (DD/MM/AAAA): ")
        if data_inicio_str:
            data_inicio = datetime.strptime(data_inicio_str, "%d/%m/%Y")
        else:
            data_inicio = datetime.now()

        print("\nData de término prevista (deixe em branco para 6 meses após início):")
        data_termino_str = input("Data (DD/MM/AAAA): ")
        if data_termino_str:
            data_termino_prevista = datetime.strptime(data_termino_str, "%d/%m/%Y")
        else:
            data_termino_prevista = data_inicio + timedelta(days=180)

        # Informações financeiras
        custo_total = float(input("Custo total (R$): "))

        print("\nForma de pagamento:")
        print("1 - À Vista")
        print("2 - Parcelado")
        opcao_pagamento = input("Escolha uma opção: ")

        if opcao_pagamento == "2":
            metodo_pagamento = "Parcelado"
            num_parcelas = int(input("Número de parcelas: "))
            valor_parcela = custo_total / num_parcelas
        else:
            metodo_pagamento = "À Vista"
            num_parcelas = 1
            valor_parcela = custo_total

        # Primeiro procedimento
        print("\nPrimeiro procedimento:")
        proc_descricao = input("Descrição: ")
        proc_obs = input("Observações: ")

        novo_tratamento = {
            "tipo_tratamento": tipo_tratamento,
            "descricao": descricao,
            "data_inicio": data_inicio,
            "data_termino_prevista": data_termino_prevista,
            "data_termino_efetiva": None,
            "id_usuario": id_usuario,
            "usuario_nome": nome_usuario,
            "id_dentista": id_dentista,
            "dentista_nome": nome_dentista,
            "procedimentos": [
                {
                    "data": data_inicio,
                    "descricao": proc_descricao,
                    "observacoes": proc_obs
                }
            ],
            "custo_total": custo_total,
            "forma_pagamento": {
                "metodo": metodo_pagamento,
                "parcelas": num_parcelas,
                "valor_parcela": valor_parcela,
                "status_pagamento": [
                    {"parcela": 1, "status": "pendente", "data": None}
                ] if metodo_pagamento == "Parcelado" else []
            }
        }

        resultado = db.tratamentos.insert_one(novo_tratamento)
        print(f"\nTratamento adicionado com sucesso! ID: {resultado.inserted_id}")

    except Exception as e:
        print(f"Erro ao adicionar tratamento: {e}")

    input("\nPressione ENTER para continuar...")


def atualizar_tratamento(db):
    limpar_tela()
    print("ATUALIZAR TRATAMENTO")
    print("=" * 50)

    id_tratamento = input("Digite o ID do tratamento: ")

    try:
        tratamento = db.tratamentos.find_one({"_id": ObjectId(id_tratamento)})
        if not tratamento:
            print("Tratamento não encontrado.")
            input("\nPressione ENTER para continuar...")
            return

        print("\nDados atuais:")
        print(f"Paciente: {tratamento.get('usuario_nome', 'N/A')}")
        print(f"Tipo: {tratamento.get('tipo_tratamento', 'N/A')}")
        print(f"Descrição: {tratamento.get('descricao', 'N/A')}")
        print(f"Data início: {formatar_data(tratamento.get('data_inicio', None))}")
        print(f"Data término prevista: {formatar_data(tratamento.get('data_termino_prevista', None))}")
        print(f"Status: {'Em andamento' if not tratamento.get('data_termino_efetiva') else 'Concluído'}")

        print("\nDeixe em branco os campos que não deseja alterar.")
        descricao = input(f"Descrição [{tratamento.get('descricao', '')}]: ")

        print("\nDeseja atualizar a data de término prevista? (s/n)")
        if input().lower() == 's':
            data_termino_str = input("Nova data de término prevista (DD/MM/AAAA): ")
            data_termino_prevista = datetime.strptime(data_termino_str, "%d/%m/%Y")
        else:
            data_termino_prevista = tratamento.get('data_termino_prevista')

        print("\nTratamento finalizado? (s/n)")
        finalizado = input().lower() == 's'

        if finalizado:
            data_termino_efetiva_str = input("Data de término efetiva (DD/MM/AAAA, deixe em branco para hoje): ")
            if data_termino_efetiva_str:
                data_termino_efetiva = datetime.strptime(data_termino_efetiva_str, "%d/%m/%Y")
            else:
                data_termino_efetiva = datetime.now()
        else:
            data_termino_efetiva = None

        atualizacoes = {}
        if descricao: atualizacoes["descricao"] = descricao
        atualizacoes["data_termino_prevista"] = data_termino_prevista
        atualizacoes["data_termino_efetiva"] = data_termino_efetiva

        if confirmar_acao("Confirma a atualização?"):
            resultado = db.tratamentos.update_one(
                {"_id": ObjectId(id_tratamento)},
                {"$set": atualizacoes}
            )

            if resultado.modified_count > 0:
                print("Tratamento atualizado com sucesso!")
            else:
                print("Nenhuma alteração realizada.")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def adicionar_procedimento(db):
    limpar_tela()
    print("ADICIONAR PROCEDIMENTO AO TRATAMENTO")
    print("=" * 50)

    id_tratamento = input("Digite o ID do tratamento: ")

    try:
        tratamento = db.tratamentos.find_one({"_id": ObjectId(id_tratamento)})
        if not tratamento:
            print("Tratamento não encontrado.")
            input("\nPressione ENTER para continuar...")
            return

        if tratamento.get('data_termino_efetiva'):
            print("Este tratamento já foi finalizado. Não é possível adicionar procedimentos.")
            input("\nPressione ENTER para continuar...")
            return

        print("\nDados do tratamento:")
        print(f"Paciente: {tratamento.get('usuario_nome', 'N/A')}")
        print(f"Tipo: {tratamento.get('tipo_tratamento', 'N/A')}")

        # Procedimentos existentes
        print("\nProcedimentos já realizados:")
        procedimentos = tratamento.get('procedimentos', [])
        for i, proc in enumerate(procedimentos):
            print(f"{i + 1}. {proc.get('descricao', 'N/A')} - {formatar_data(proc.get('data', None))}")

        # Novo procedimento
        print("\nNovo procedimento:")
        data_proc_str = input("Data (DD/MM/AAAA, deixe em branco para hoje): ")
        if data_proc_str:
            data_proc = datetime.strptime(data_proc_str, "%d/%m/%Y")
        else:
            data_proc = datetime.now()

        descricao_proc = input("Descrição: ")
        observacoes_proc = input("Observações: ")

        novo_procedimento = {
            "data": data_proc,
            "descricao": descricao_proc,
            "observacoes": observacoes_proc
        }

        if confirmar_acao("Confirma a adição do procedimento?"):
            resultado = db.tratamentos.update_one(
                {"_id": ObjectId(id_tratamento)},
                {"$push": {"procedimentos": novo_procedimento}}
            )

            if resultado.modified_count > 0:
                print("Procedimento adicionado com sucesso!")
            else:
                print("Erro ao adicionar procedimento.")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def excluir_tratamento(db):
    limpar_tela()
    print("EXCLUIR TRATAMENTO")
    print("=" * 50)

    id_tratamento = input("Digite o ID do tratamento: ")

    try:
        tratamento = db.tratamentos.find_one({"_id": ObjectId(id_tratamento)})
        if not tratamento:
            print("Tratamento não encontrado.")
            input("\nPressione ENTER para continuar...")
            return

        print("\nDados do tratamento:")
        print(f"Paciente: {tratamento.get('usuario_nome', 'N/A')}")
        print(f"Tipo: {tratamento.get('tipo_tratamento', 'N/A')}")
        print(f"Início: {formatar_data(tratamento.get('data_inicio', None))}")

        if confirmar_acao("Tem certeza que deseja excluir este tratamento?"):
            # Verificar se há agendamentos vinculados
            agendamentos = db.agendamentos.find_one({"id_tratamento": ObjectId(id_tratamento)})

            if agendamentos:
                print("Não é possível excluir este tratamento pois existem agendamentos vinculados.")
            else:
                resultado = db.tratamentos.delete_one({"_id": ObjectId(id_tratamento)})
                if resultado.deleted_count > 0:
                    print("Tratamento excluído com sucesso!")
                else:
                    print("Erro ao excluir tratamento.")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


# 4. AGENDAMENTOS
def menu_agendamentos(db):
    while True:
        limpar_tela()
        print("=" * 50)
        print("GERENCIAMENTO DE AGENDAMENTOS")
        print("=" * 50)
        print("1 - Listar Todos")
        print("2 - Buscar por ID")
        print("3 - Buscar por Data")
        print("4 - Buscar por Paciente")
        print("5 - Adicionar")
        print("6 - Atualizar")
        print("7 - Excluir")
        print("0 - Voltar")
        print("=" * 50)

        opcao = input("Escolha uma opção: ")

        if opcao == '1':
            listar_agendamentos(db)
        elif opcao == '2':
            buscar_agendamento_por_id(db)
        elif opcao == '3':
            buscar_agendamento_por_data(db)
        elif opcao == '4':
            buscar_agendamento_por_paciente(db)
        elif opcao == '5':
            adicionar_agendamento(db)
        elif opcao == '6':
            atualizar_agendamento(db)
        elif opcao == '7':
            excluir_agendamento(db)
        elif opcao == '0':
            break
        else:
            input("Opção inválida. Pressione ENTER para continuar...")


def listar_agendamentos(db):
    limpar_tela()
    print("LISTA DE AGENDAMENTOS")
    print("=" * 50)

    agendamentos = list(db.agendamentos.find().sort("data_agendada", 1))
    if not agendamentos:
        print("Nenhum agendamento cadastrado.")
    else:
        for agendamento in agendamentos:
            data_hora = agendamento.get('data_agendada')
            data_str = data_hora.strftime("%d/%m/%Y %H:%M") if isinstance(data_hora, datetime) else "N/A"

            print(f"ID: {agendamento['_id']}")
            print(f"Data e Hora: {data_str}")
            print(f"Paciente: {agendamento.get('usuario_nome', 'N/A')}")
            print(f"Tipo: {agendamento.get('tipo_tratamento', 'N/A')}")
            print(f"Status: {agendamento.get('status', 'N/A').upper()}")
            print("-" * 30)

    input("Pressione ENTER para continuar...")


def buscar_agendamento_por_id(db):
    limpar_tela()
    print("BUSCAR AGENDAMENTO POR ID")
    print("=" * 50)

    id_agendamento = input("Digite o ID do agendamento: ")
    try:
        agendamento = db.agendamentos.find_one({"_id": ObjectId(id_agendamento)})
        if agendamento:
            print("\nAgendamento encontrado:")
            print(exibir_documento(agendamento))
        else:
            print("Agendamento não encontrado.")
    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def buscar_agendamento_por_data(db):
    limpar_tela()
    print("BUSCAR AGENDAMENTO POR DATA")
    print("=" * 50)

    data_str = input("Digite a data (DD/MM/AAAA): ")
    try:
        data = datetime.strptime(data_str, "%d/%m/%Y")

        # Buscar agendamentos para a data informada
        inicio_dia = datetime.combine(data.date(), datetime.min.time())
        fim_dia = datetime.combine(data.date(), datetime.max.time())

        agendamentos = list(db.agendamentos.find({
            "data_agendada": {
                "$gte": inicio_dia,
                "$lte": fim_dia
            }
        }).sort("data_agendada", 1))

        if not agendamentos:
            print(f"Nenhum agendamento encontrado para {data_str}.")
        else:
            print(f"\nAgendamentos para {data_str}:")
            for agendamento in agendamentos:
                hora = agendamento.get('data_agendada').strftime("%H:%M") if isinstance(
                    agendamento.get('data_agendada'), datetime) else "N/A"

                print("-" * 30)
                print(f"ID: {agendamento['_id']}")
                print(f"Horário: {hora}")
                print(f"Paciente: {agendamento.get('usuario_nome', 'N/A')}")
                print(f"Tipo: {agendamento.get('tipo_tratamento', 'N/A')}")
                print(f"Status: {agendamento.get('status', 'N/A').upper()}")
    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def buscar_agendamento_por_paciente(db):
    limpar_tela()
    print("BUSCAR AGENDAMENTO POR PACIENTE")
    print("=" * 50)

    # Listar usuários para seleção
    usuarios = list(db.usuarios.find({}, {"_id": 1, "nome": 1}))
    if not usuarios:
        print("Nenhum usuário cadastrado.")
        input("\nPressione ENTER para continuar...")
        return

    print("Usuários cadastrados:")
    for i, usuario in enumerate(usuarios):
        print(f"{i + 1} - {usuario.get('nome', 'N/A')}")

    try:
        opcao = int(input("\nEscolha um usuário (número): "))
        if opcao < 1 or opcao > len(usuarios):
            print("Opção inválida.")
            input("\nPressione ENTER para continuar...")
            return

        id_usuario = usuarios[opcao - 1]["_id"]

        agendamentos = list(db.agendamentos.find({"id_usuario": id_usuario}).sort("data_agendada", 1))
        if not agendamentos:
            print("Nenhum agendamento encontrado para este paciente.")
        else:
            print(f"\nAgendamentos de {usuarios[opcao - 1].get('nome', 'N/A')}:")
            for agendamento in agendamentos:
                data_hora = agendamento.get('data_agendada')
                data_str = data_hora.strftime("%d/%m/%Y %H:%M") if isinstance(data_hora, datetime) else "N/A"

                print("-" * 30)
                print(f"ID: {agendamento['_id']}")
                print(f"Data e Hora: {data_str}")
                print(f"Tipo: {agendamento.get('tipo_tratamento', 'N/A')}")
                print(f"Status: {agendamento.get('status', 'N/A').upper()}")
    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def adicionar_agendamento(db):
    limpar_tela()
    print("ADICIONAR NOVO AGENDAMENTO")
    print("=" * 50)

    # Listar usuários para seleção
    usuarios = list(db.usuarios.find({}, {"_id": 1, "nome": 1, "telefone": 1}))
    if not usuarios:
        print("Nenhum usuário cadastrado. Cadastre um usuário primeiro.")
        input("\nPressione ENTER para continuar...")
        return

    try:
        # Selecionar usuário
        print("Usuários cadastrados:")
        for i, usuario in enumerate(usuarios):
            print(f"{i + 1} - {usuario.get('nome', 'N/A')}")

        opcao_usuario = int(input("\nEscolha um usuário (número): "))
        if opcao_usuario < 1 or opcao_usuario > len(usuarios):
            print("Opção inválida.")
            input("\nPressione ENTER para continuar...")
            return

        id_usuario = usuarios[opcao_usuario - 1]["_id"]
        nome_usuario = usuarios[opcao_usuario - 1].get("nome", "")
        telefone_usuario = usuarios[opcao_usuario - 1].get("telefone", "")

        # Data e hora do agendamento
        data_str = input("Data do agendamento (DD/MM/AAAA): ")
        hora_str = input("Hora do agendamento (HH:MM): ")

        data = datetime.strptime(data_str, "%d/%m/%Y")
        hora = datetime.strptime(hora_str, "%H:%M").time()
        data_hora = datetime.combine(data.date(), hora)

        # Duração e sala
        duracao = int(input("Duração (minutos): "))

        print("\nSalas disponíveis:")
        print("1 - Consultório 1")
        print("2 - Consultório 2")
        print("3 - Consultório 3")
        print("4 - Sala de Raio-X")
        opcao_sala = input("Escolha uma sala (número): ")

        salas = ["Consultório 1", "Consultório 2", "Consultório 3", "Sala de Raio-X"]
        if opcao_sala in "1234":
            sala = salas[int(opcao_sala) - 1]
        else:
            sala = "Consultório 1"

        # Verificar se deseja vincular a um tratamento existente
        vincular_tratamento = input("\nVincular a um tratamento existente? (s/n): ").lower() == 's'

        id_tratamento = None
        tipo_tratamento = ""

        if vincular_tratamento:
            # Buscar tratamentos do usuário
            tratamentos = list(db.tratamentos.find({
                "id_usuario": id_usuario,
                "data_termino_efetiva": None  # Apenas tratamentos em andamento
            }))

            if not tratamentos:
                print("Este paciente não possui tratamentos em andamento.")
                vincular_tratamento = False
            else:
                print("\nTratamentos disponíveis:")
                for i, tratamento in enumerate(tratamentos):
                    print(f"{i + 1} - {tratamento.get('tipo_tratamento', 'N/A')}")

                opcao_tratamento = int(input("\nEscolha um tratamento (número): "))
                if opcao_tratamento < 1 or opcao_tratamento > len(tratamentos):
                    print("Opção inválida.")
                    vincular_tratamento = False
                else:
                    id_tratamento = tratamentos[opcao_tratamento - 1]["_id"]
                    tipo_tratamento = tratamentos[opcao_tratamento - 1].get("tipo_tratamento", "")

        if not vincular_tratamento:
            tipo_tratamento = input("Tipo de consulta/tratamento: ")

        # Status e observações
        print("\nStatus do agendamento:")
        print("1 - Confirmado")
        print("2 - Pendente")
        print("3 - Cancelado")
        opcao_status = input("Escolha uma opção: ")

        status_opcoes = ["confirmado", "pendente", "cancelado"]
        if opcao_status in "123":
            status = status_opcoes[int(opcao_status) - 1]
        else:
            status = "pendente"

        observacoes = input("Observações: ")

        novo_agendamento = {
            "data_agendada": data_hora,
            "duracao_minutos": duracao,
            "id_tratamento": id_tratamento,
            "tipo_tratamento": tipo_tratamento,
            "id_usuario": id_usuario,
            "usuario_nome": nome_usuario,
            "telefone_usuario": telefone_usuario,
            "status": status,
            "sala": sala,
            "observacoes": observacoes
        }

        if confirmar_acao("Confirma o agendamento?"):
            resultado = db.agendamentos.insert_one(novo_agendamento)
            print(f"\nAgendamento realizado com sucesso! ID: {resultado.inserted_id}")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro ao adicionar agendamento: {e}")

    input("\nPressione ENTER para continuar...")


def atualizar_agendamento(db):
    limpar_tela()
    print("ATUALIZAR AGENDAMENTO")
    print("=" * 50)

    id_agendamento = input("Digite o ID do agendamento: ")

    try:
        agendamento = db.agendamentos.find_one({"_id": ObjectId(id_agendamento)})
        if not agendamento:
            print("Agendamento não encontrado.")
            input("\nPressione ENTER para continuar...")
            return

        data_hora = agendamento.get('data_agendada')
        data_str = data_hora.strftime("%d/%m/%Y") if isinstance(data_hora, datetime) else "N/A"
        hora_str = data_hora.strftime("%H:%M") if isinstance(data_hora, datetime) else "N/A"

        print("\nDados atuais:")
        print(f"Paciente: {agendamento.get('usuario_nome', 'N/A')}")
        print(f"Data: {data_str}")
        print(f"Hora: {hora_str}")
        print(f"Tipo: {agendamento.get('tipo_tratamento', 'N/A')}")
        print(f"Status: {agendamento.get('status', 'N/A').upper()}")

        print("\nDeseja alterar a data e hora? (s/n)")
        if input().lower() == 's':
            nova_data_str = input(f"Nova data (DD/MM/AAAA) [{data_str}]: ")
            nova_hora_str = input(f"Nova hora (HH:MM) [{hora_str}]: ")

            if nova_data_str and nova_hora_str:
                nova_data = datetime.strptime(nova_data_str, "%d/%m/%Y")
                nova_hora = datetime.strptime(nova_hora_str, "%H:%M").time()
                data_hora = datetime.combine(nova_data.date(), nova_hora)
            elif nova_data_str:
                nova_data = datetime.strptime(nova_data_str, "%d/%m/%Y")
                data_hora = datetime.combine(nova_data.date(), data_hora.time())
            elif nova_hora_str:
                nova_hora = datetime.strptime(nova_hora_str, "%H:%M").time()
                data_hora = datetime.combine(data_hora.date(), nova_hora)

        duracao = input(f"Duração (minutos) [{agendamento.get('duracao_minutos', '')}]: ")
        if not duracao:
            duracao = agendamento.get('duracao_minutos')
        else:
            duracao = int(duracao)

        print("\nStatus do agendamento:")
        print("1 - Confirmado")
        print("2 - Pendente")
        print("3 - Cancelado")
        print("4 - Concluído")
        opcao_status = input(f"Escolha uma opção [{agendamento.get('status', 'pendente')}]: ")

        status_opcoes = ["confirmado", "pendente", "cancelado", "concluído"]
        if opcao_status in "1234":
            status = status_opcoes[int(opcao_status) - 1]
        else:
            status = agendamento.get('status', 'pendente')

        observacoes = input(f"Observações [{agendamento.get('observacoes', '')}]: ")
        if not observacoes:
            observacoes = agendamento.get('observacoes', '')

        atualizacoes = {
            "data_agendada": data_hora,
            "duracao_minutos": duracao,
            "status": status,
            "observacoes": observacoes
        }

        if confirmar_acao("Confirma a atualização?"):
            resultado = db.agendamentos.update_one(
                {"_id": ObjectId(id_agendamento)},
                {"$set": atualizacoes}
            )

            if resultado.modified_count > 0:
                print("Agendamento atualizado com sucesso!")
            else:
                print("Nenhuma alteração realizada.")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


def excluir_agendamento(db):
    limpar_tela()
    print("EXCLUIR AGENDAMENTO")
    print("=" * 50)

    id_agendamento = input("Digite o ID do agendamento: ")

    try:
        agendamento = db.agendamentos.find_one({"_id": ObjectId(id_agendamento)})
        if not agendamento:
            print("Agendamento não encontrado.")
            input("\nPressione ENTER para continuar...")
            return

        data_hora = agendamento.get('data_agendada')
        data_str = data_hora.strftime("%d/%m/%Y %H:%M") if isinstance(data_hora, datetime) else "N/A"

        print("\nDados do agendamento:")
        print(f"Paciente: {agendamento.get('usuario_nome', 'N/A')}")
        print(f"Data e Hora: {data_str}")
        print(f"Tipo: {agendamento.get('tipo_tratamento', 'N/A')}")

        if confirmar_acao("Tem certeza que deseja excluir este agendamento?"):
            resultado = db.agendamentos.delete_one({"_id": ObjectId(id_agendamento)})
            if resultado.deleted_count > 0:
                print("Agendamento excluído com sucesso!")
            else:
                print("Erro ao excluir agendamento.")
        else:
            print("Operação cancelada.")

    except Exception as e:
        print(f"Erro: {e}")

    input("\nPressione ENTER para continuar...")


# Iniciar o sistema
if __name__ == "__main__":
    menu_principal()