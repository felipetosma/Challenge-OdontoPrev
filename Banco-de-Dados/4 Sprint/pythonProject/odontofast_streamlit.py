import streamlit as st
import pymongo
from pymongo import MongoClient
from bson import ObjectId
from datetime import datetime, timedelta
import json

# Configurações da página
st.set_page_config(
    page_title="Odontofast",
    page_icon="🦷",
    layout="wide"
)


# Conectar ao MongoDB
@st.cache_resource
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
        st.error(f"Erro ao conectar ao MongoDB: {e}")
        st.warning("Verifique se o MongoDB está em execução.")
        return None


# Funções auxiliares
def formatar_data(data):
    if isinstance(data, datetime):
        return data.strftime("%d/%m/%Y")
    return str(data) if data else "N/A"


def formatar_id(id_obj):
    return str(id_obj) if id_obj else "N/A"


# Título principal
st.title("🦷 Odontofast")
st.subheader("Sistema de Acompanhamento de Tratamentos")

# Menu principal
menu = st.sidebar.selectbox(
    "Menu Principal",
    ["Início", "Usuários", "Dentistas", "Tratamentos", "Agendamentos"]
)

# Conexão com o banco de dados
db = conectar_mongodb()

if db is None:
    st.error("Não foi possível conectar ao MongoDB. Verifique se o serviço está em execução.")
    st.stop()

# Página inicial
if menu == "Início":
    st.write("### Bem-vindo ao Sistema Odontofast")
    st.write("Este sistema permite gerenciar:")
    col1, col2 = st.columns(2)

    with col1:
        st.write("- **Usuários/Pacientes**")
        st.write("- **Dentistas**")

    with col2:
        st.write("- **Tratamentos**")
        st.write("- **Agendamentos**")

    st.write("Selecione uma opção no menu lateral para começar.")

    # Estatísticas básicas
    st.subheader("Estatísticas do Sistema")
    col1, col2, col3, col4 = st.columns(4)

    with col1:
        total_usuarios = db.usuarios.count_documents({})
        st.metric("Total de Pacientes", total_usuarios)

    with col2:
        total_dentistas = db.dentistas.count_documents({})
        st.metric("Total de Dentistas", total_dentistas)

    with col3:
        total_tratamentos = db.tratamentos.count_documents({})
        st.metric("Total de Tratamentos", total_tratamentos)

    with col4:
        total_agendamentos = db.agendamentos.count_documents({})
        st.metric("Total de Agendamentos", total_agendamentos)

# Gerenciamento de Usuários
elif menu == "Usuários":
    st.header("Gerenciamento de Usuários/Pacientes")

    submenu = st.sidebar.radio(
        "Ações",
        ["Listar Todos", "Buscar", "Adicionar", "Atualizar", "Excluir"]
    )

    if submenu == "Listar Todos":
        st.subheader("Lista de Usuários")
        usuarios = list(db.usuarios.find())

        if not usuarios:
            st.info("Nenhum usuário cadastrado.")
        else:
            for usuario in usuarios:
                with st.expander(f"{usuario.get('nome', 'Usuário')} - {usuario.get('email', 'Sem email')}"):
                    col1, col2 = st.columns(2)

                    with col1:
                        st.write(f"**ID:** {formatar_id(usuario.get('_id'))}")
                        st.write(f"**Nome:** {usuario.get('nome', 'N/A')}")
                        st.write(f"**Email:** {usuario.get('email', 'N/A')}")
                        st.write(f"**Telefone:** {usuario.get('telefone', 'N/A')}")
                        st.write(f"**Nr. Carteira:** {usuario.get('nr_carteira', 'N/A')}")

                    with col2:
                        st.write(f"**Data de Nascimento:** {formatar_data(usuario.get('data_nascimento'))}")

                        endereco = usuario.get('endereco', {})
                        if endereco:
                            st.write("**Endereço:**")
                            st.write(f"{endereco.get('logradouro', '')}, {endereco.get('numero', '')}")
                            st.write(
                                f"{endereco.get('bairro', '')}, {endereco.get('cidade', '')}-{endereco.get('estado', '')}")

    elif submenu == "Buscar":
        st.subheader("Buscar Usuário")

        opcao_busca = st.radio("Buscar por:", ["ID", "Email", "Nome"])

        if opcao_busca == "ID":
            id_busca = st.text_input("ID do Usuário")
            if st.button("Buscar") and id_busca:
                try:
                    usuario = db.usuarios.find_one({"_id": ObjectId(id_busca)})
                    if usuario:
                        st.success("Usuário encontrado!")
                        st.json(json.loads(json.dumps(usuario, default=str)))
                    else:
                        st.error("Usuário não encontrado.")
                except Exception as e:
                    st.error(f"Erro: {str(e)}")

        elif opcao_busca == "Email":
            email_busca = st.text_input("Email do Usuário")
            if st.button("Buscar") and email_busca:
                usuario = db.usuarios.find_one({"email": email_busca})
                if usuario:
                    st.success("Usuário encontrado!")
                    st.json(json.loads(json.dumps(usuario, default=str)))
                else:
                    st.error("Usuário não encontrado.")

        else:  # Nome
            nome_busca = st.text_input("Nome do Usuário")
            if st.button("Buscar") and nome_busca:
                usuarios = list(db.usuarios.find({"nome": {"$regex": nome_busca, "$options": "i"}}))
                if usuarios:
                    st.success(f"Encontrado(s) {len(usuarios)} usuário(s)!")
                    for usuario in usuarios:
                        with st.expander(f"{usuario.get('nome', 'Usuário')} - {usuario.get('email', 'Sem email')}"):
                            st.json(json.loads(json.dumps(usuario, default=str)))
                else:
                    st.error("Nenhum usuário encontrado.")

    elif submenu == "Adicionar":
        st.subheader("Adicionar Novo Usuário")

        with st.form("form_add_usuario"):
            col1, col2 = st.columns(2)

            with col1:
                nome = st.text_input("Nome")
                email = st.text_input("Email")
                senha = st.text_input("Senha", type="password")
                telefone = st.text_input("Telefone")
                carteira = st.text_input("Número da Carteira")
                data_nasc = st.date_input("Data de Nascimento")

            with col2:
                # Endereço
                st.subheader("Endereço")
                logradouro = st.text_input("Logradouro")
                numero = st.text_input("Número")
                complemento = st.text_input("Complemento")
                bairro = st.text_input("Bairro")
                cidade = st.text_input("Cidade")
                estado = st.selectbox("Estado",
                                      ["AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG",
                                       "PA",
                                       "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"])
                cep = st.text_input("CEP")

            # Histórico médico e convênio
            col3, col4 = st.columns(2)

            with col3:
                st.subheader("Informações Médicas")
                alergias = st.text_input("Alergias (separadas por vírgula)")
                doencas = st.text_input("Doenças Crônicas (separadas por vírgula)")
                medicamentos = st.text_input("Medicamentos (separados por vírgula)")

            with col4:
                st.subheader("Convênio")
                convenio_nome = st.text_input("Nome do Convênio")
                convenio_numero = st.text_input("Número do Convênio")
                convenio_plano = st.text_input("Plano")
                convenio_validade = st.date_input("Validade do Convênio", datetime.now() + timedelta(days=365))

            if st.form_submit_button("Adicionar Usuário"):
                novo_usuario = {
                    "nome": nome,
                    "email": email,
                    "senha": senha,
                    "telefone": telefone,
                    "nr_carteira": carteira,
                    "data_nascimento": data_nasc,
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
                        "alergias": [a.strip() for a in alergias.split(",") if a.strip()],
                        "doencas_cronicas": [d.strip() for d in doencas.split(",") if d.strip()],
                        "medicamentos": [m.strip() for m in medicamentos.split(",") if m.strip()]
                    },
                    "convenio": {
                        "nome": convenio_nome,
                        "numero": convenio_numero,
                        "plano": convenio_plano,
                        "validade": convenio_validade
                    }
                }

                try:
                    resultado = db.usuarios.insert_one(novo_usuario)
                    st.success(f"Usuário adicionado com sucesso! ID: {resultado.inserted_id}")
                except Exception as e:
                    st.error(f"Erro ao adicionar usuário: {str(e)}")

    elif submenu == "Atualizar":
        st.subheader("Atualizar Usuário")

        # Buscar usuário para atualizar
        id_usuario = st.text_input("ID do Usuário")

        if id_usuario:
            try:
                usuario = db.usuarios.find_one({"_id": ObjectId(id_usuario)})
                if usuario:
                    st.success("Usuário encontrado. Atualize os campos desejados:")

                    with st.form("form_update_usuario"):
                        nome = st.text_input("Nome", value=usuario.get("nome", ""))
                        email = st.text_input("Email", value=usuario.get("email", ""))
                        telefone = st.text_input("Telefone", value=usuario.get("telefone", ""))

                        if st.form_submit_button("Atualizar Usuário"):
                            updates = {
                                "nome": nome,
                                "email": email,
                                "telefone": telefone,
                            }

                            # Filtrar apenas campos com valores
                            updates_filtered = {k: v for k, v in updates.items() if v}

                            if updates_filtered:
                                try:
                                    # Usar $set para atualizar campos específicos
                                    update_result = db.usuarios.update_one(
                                        {"_id": ObjectId(id_usuario)},
                                        {"$set": updates_filtered}
                                    )

                                    if update_result.modified_count > 0:
                                        st.success("Usuário atualizado com sucesso!")
                                    else:
                                        st.info("Nenhuma alteração realizada.")
                                except Exception as e:
                                    st.error(f"Erro ao atualizar: {str(e)}")
                            else:
                                st.warning("Nenhum campo para atualizar foi fornecido.")
                else:
                    st.error("Usuário não encontrado.")
            except Exception as e:
                st.error(f"Erro ao buscar usuário: {str(e)}")

    elif submenu == "Excluir":
        st.subheader("Excluir Usuário")

        id_usuario = st.text_input("ID do Usuário")

        if id_usuario:
            try:
                usuario = db.usuarios.find_one({"_id": ObjectId(id_usuario)})
                if usuario:
                    st.write(f"**Nome:** {usuario.get('nome', 'N/A')}")
                    st.write(f"**Email:** {usuario.get('email', 'N/A')}")
                    st.write(f"**Telefone:** {usuario.get('telefone', 'N/A')}")

                    st.warning("Esta operação não pode ser desfeita!")

                    if st.button("Confirmar Exclusão", type="primary"):
                        # Verificar se há agendamentos ou tratamentos relacionados
                        agendamentos = db.agendamentos.find_one({"id_usuario": ObjectId(id_usuario)})
                        tratamentos = db.tratamentos.find_one({"id_usuario": ObjectId(id_usuario)})

                        if agendamentos or tratamentos:
                            st.error(
                                "Não é possível excluir este usuário pois existem agendamentos ou tratamentos vinculados.")
                        else:
                            resultado = db.usuarios.delete_one({"_id": ObjectId(id_usuario)})
                            if resultado.deleted_count > 0:
                                st.success("Usuário excluído com sucesso!")
                            else:
                                st.error("Erro ao excluir usuário.")
                else:
                    st.error("Usuário não encontrado.")
            except Exception as e:
                st.error(f"Erro: {str(e)}")

# Gerenciamento de Dentistas
elif menu == "Dentistas":
    st.header("Gerenciamento de Dentistas")

    submenu = st.sidebar.radio(
        "Ações",
        ["Listar Todos", "Buscar", "Adicionar", "Atualizar", "Excluir"]
    )

    if submenu == "Listar Todos":
        st.subheader("Lista de Dentistas")
        dentistas = list(db.dentistas.find())

        if not dentistas:
            st.info("Nenhum dentista cadastrado.")
        else:
            for dentista in dentistas:
                with st.expander(f"{dentista.get('nome', 'Dentista')} - {dentista.get('cro', 'Sem CRO')}"):
                    col1, col2 = st.columns(2)

                    with col1:
                        st.write(f"**ID:** {formatar_id(dentista.get('_id'))}")
                        st.write(f"**Nome:** {dentista.get('nome', 'N/A')}")
                        st.write(f"**CRO:** {dentista.get('cro', 'N/A')}")
                        st.write(f"**Email:** {dentista.get('email', 'N/A')}")
                        st.write(f"**Telefone:** {dentista.get('telefone', 'N/A')}")

                    with col2:
                        st.write(f"**Especialidade:** {dentista.get('especialidade', 'N/A')}")
                        st.write(f"**Data de Cadastro:** {formatar_data(dentista.get('data_cadastro'))}")
                        st.write(f"**Dias de Atendimento:** {', '.join(dentista.get('dias_atendimento', []))}")
                        st.write(
                            f"**Horário:** {dentista.get('horario_inicio', '')} - {dentista.get('horario_fim', '')}")

    # Implementar outras opções do submenu para Dentistas...
    # Os códigos para buscar, adicionar, atualizar e excluir dentistas seguiriam o mesmo padrão dos usuários

# Gerenciamento de Tratamentos
elif menu == "Tratamentos":
    st.header("Gerenciamento de Tratamentos")

    submenu = st.sidebar.radio(
        "Ações",
        ["Listar Todos", "Buscar", "Adicionar", "Atualizar", "Adicionar Procedimento", "Excluir"]
    )

    if submenu == "Listar Todos":
        st.subheader("Lista de Tratamentos")
        tratamentos = list(db.tratamentos.find())

        if not tratamentos:
            st.info("Nenhum tratamento cadastrado.")
        else:
            for tratamento in tratamentos:
                with st.expander(
                        f"{tratamento.get('usuario_nome', 'Paciente')} - {tratamento.get('tipo_tratamento', 'Tratamento')}"):
                    col1, col2 = st.columns(2)

                    with col1:
                        st.write(f"**ID:** {formatar_id(tratamento.get('_id'))}")
                        st.write(f"**Tipo:** {tratamento.get('tipo_tratamento', 'N/A')}")
                        st.write(f"**Paciente:** {tratamento.get('usuario_nome', 'N/A')}")
                        st.write(f"**Dentista:** {tratamento.get('dentista_nome', 'N/A')}")
                        st.write(f"**Custo:** R$ {tratamento.get('custo_total', 0):.2f}")

                    with col2:
                        st.write(f"**Início:** {formatar_data(tratamento.get('data_inicio'))}")
                        st.write(f"**Término Previsto:** {formatar_data(tratamento.get('data_termino_prevista'))}")
                        st.write(
                            f"**Término Efetivo:** {formatar_data(tratamento.get('data_termino_efetiva')) or 'Em andamento'}")

                    # Procedimentos
                    procedimentos = tratamento.get('procedimentos', [])
                    if procedimentos:
                        st.subheader("Procedimentos")
                        for i, proc in enumerate(procedimentos):
                            st.write(f"{i + 1}. **{proc.get('descricao', 'N/A')}** - {formatar_data(proc.get('data'))}")
                            st.write(f"   Observações: {proc.get('observacoes', 'N/A')}")

    # Implementar outras opções do submenu para Tratamentos...

# Gerenciamento de Agendamentos
elif menu == "Agendamentos":
    st.header("Gerenciamento de Agendamentos")

    submenu = st.sidebar.radio(
        "Ações",
        ["Listar Todos", "Buscar", "Agendar", "Atualizar", "Excluir"]
    )

    if submenu == "Listar Todos":
        st.subheader("Lista de Agendamentos")

        # Filtro por data
        filtro_data = st.date_input("Filtrar por data", datetime.now())

        # Consulta com filtro de data
        inicio_dia = datetime.combine(filtro_data, datetime.min.time())
        fim_dia = datetime.combine(filtro_data, datetime.max.time())

        agendamentos = list(db.agendamentos.find({
            "data_agendada": {
                "$gte": inicio_dia,
                "$lte": fim_dia
            }
        }).sort("data_agendada", 1))

        if not agendamentos:
            st.info(f"Nenhum agendamento para o dia {filtro_data.strftime('%d/%m/%Y')}.")
        else:
            for agendamento in agendamentos:
                status_color = {
                    "confirmado": "green",
                    "pendente": "orange",
                    "cancelado": "red",
                    "concluído": "blue"
                }.get(agendamento.get("status", "").lower(), "black")

                horario = agendamento.get("data_agendada").strftime("%H:%M") if isinstance(
                    agendamento.get("data_agendada"), datetime) else "Horário não definido"

                with st.expander(
                        f"[{horario}] {agendamento.get('usuario_nome', 'Paciente')} - {agendamento.get('tipo_tratamento', 'Consulta')}"):
                    col1, col2 = st.columns(2)

                    with col1:
                        st.write(f"**ID:** {formatar_id(agendamento.get('_id'))}")
                        st.write(f"**Paciente:** {agendamento.get('usuario_nome', 'N/A')}")
                        st.write(f"**Telefone:** {agendamento.get('telefone_usuario', 'N/A')}")
                        st.write(f"**Tipo:** {agendamento.get('tipo_tratamento', 'N/A')}")

                    with col2:
                        st.write(
                            f"**Horário:** {agendamento.get('data_agendada').strftime('%d/%m/%Y %H:%M') if isinstance(agendamento.get('data_agendada'), datetime) else 'N/A'}")
                        st.write(f"**Duração:** {agendamento.get('duracao_minutos', 'N/A')} minutos")
                        st.write(f"**Sala:** {agendamento.get('sala', 'N/A')}")
                        st.markdown(
                            f"**Status:** <span style='color:{status_color};font-weight:bold;'>{agendamento.get('status', 'N/A').upper()}</span>",
                            unsafe_allow_html=True)

                    if agendamento.get("observacoes"):
                        st.write(f"**Observações:** {agendamento.get('observacoes', '')}")

    # Implementar outras opções do submenu para Agendamentos...