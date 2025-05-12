import streamlit as st
import pymongo
from pymongo import MongoClient
from bson import ObjectId
from datetime import datetime, date, timedelta
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
    elif isinstance(data, date):
        return data.strftime("%d/%m/%Y")
    return str(data) if data else "N/A"


def formatar_id(id_obj):
    return str(id_obj) if id_obj else "N/A"


# Título principal
st.title("🦷 Odontofast")
st.subheader("Sistema de Acompanhamento de Tratamentos")

# Menu principal com opção adicional de exportação
menu = st.sidebar.selectbox(
    "Menu Principal",
    ["Início", "1. Usuários", "2. Dentistas", "3. Tratamentos", "4. Agendamentos", "5. Exportar Dados"]
)

# Conexão com o banco de dados
db = conectar_mongodb()

if db is None:
    st.error("Não foi possível conectar ao MongoDB. Verifique se o serviço está em execução.")
    st.stop()

# Página inicial
if menu == "Início":
    st.write("### Bem-vindo ao Sistema Odontofast")
    st.write("Selecione uma opção no menu lateral para gerenciar:")
    st.write("- Usuários/Pacientes")
    st.write("- Dentistas")
    st.write("- Tratamentos")
    st.write("- Agendamentos")
    st.write("- Exportar Dados")

    # Estatísticas básicas
    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.metric("Pacientes", db.usuarios.count_documents({}))
    with col2:
        st.metric("Dentistas", db.dentistas.count_documents({}))
    with col3:
        st.metric("Tratamentos", db.tratamentos.count_documents({}))
    with col4:
        st.metric("Agendamentos", db.agendamentos.count_documents({}))

# 1. GERENCIAMENTO DE USUÁRIOS
elif menu == "1. Usuários":
    st.header("Gerenciamento de Usuários/Pacientes")

    submenu = st.sidebar.radio(
        "Operações",
        ["Listar", "Buscar", "Adicionar", "Atualizar", "Excluir"]
    )

    # LISTAR USUÁRIOS
    if submenu == "Listar":
        st.subheader("Lista de Usuários")
        usuarios = list(db.usuarios.find())

        if not usuarios:
            st.info("Nenhum usuário cadastrado.")
        else:
            for usuario in usuarios:
                with st.expander(f"{usuario.get('nome', 'N/A')} - {usuario.get('email', 'N/A')}"):
                    col1, col2 = st.columns(2)
                    with col1:
                        st.write(f"**ID:** {usuario['_id']}")
                        st.write(f"**Nome:** {usuario.get('nome', 'N/A')}")
                        st.write(f"**Email:** {usuario.get('email', 'N/A')}")
                        st.write(f"**Telefone:** {usuario.get('telefone', 'N/A')}")
                    with col2:
                        st.write(f"**Data de Nascimento:** {formatar_data(usuario.get('data_nascimento', None))}")
                        st.write(f"**Carteira:** {usuario.get('nr_carteira', 'N/A')}")
                        endereco = usuario.get('endereco', {})
                        if endereco:
                            st.write(f"**Endereço:** {endereco.get('cidade', '')}/{endereco.get('estado', '')}")

    # BUSCAR USUÁRIOS
    elif submenu == "Buscar":
        st.subheader("Buscar Usuário")

        opcao_busca = st.radio("Buscar por:", ["ID", "Email"])
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
        else:
            email_busca = st.text_input("Email do Usuário")
            if st.button("Buscar") and email_busca:
                usuario = db.usuarios.find_one({"email": email_busca})
                if usuario:
                    st.success("Usuário encontrado!")
                    st.json(json.loads(json.dumps(usuario, default=str)))
                else:
                    st.error("Usuário não encontrado.")

    # ADICIONAR USUÁRIO
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
                logradouro = st.text_input("Logradouro")
                numero = st.text_input("Número")
                bairro = st.text_input("Bairro")
                cidade = st.text_input("Cidade")
                estado = st.selectbox("Estado",
                                      ["AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG",
                                       "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE",
                                       "TO"])
                cep = st.text_input("CEP")

                alergias = st.text_input("Alergias (separadas por vírgula)")
                convenio_nome = st.text_input("Nome do Convênio")

            if st.form_submit_button("Adicionar Usuário"):
                # Converter date para datetime
                data_nasc_datetime = datetime.combine(data_nasc, datetime.min.time())
                convenio_validade = datetime.now().date() + timedelta(days=365)
                convenio_validade_datetime = datetime.combine(convenio_validade, datetime.min.time())

                novo_usuario = {
                    "nome": nome,
                    "email": email,
                    "senha": senha,
                    "telefone": telefone,
                    "nr_carteira": carteira,
                    "data_nascimento": data_nasc_datetime,
                    "ultimo_acesso": datetime.now(),
                    "endereco": {
                        "logradouro": logradouro,
                        "numero": numero,
                        "bairro": bairro,
                        "cidade": cidade,
                        "estado": estado,
                        "cep": cep
                    },
                    "historico_medico": {
                        "alergias": [a.strip() for a in alergias.split(",") if a.strip()],
                    },
                    "convenio": {
                        "nome": convenio_nome,
                        "validade": convenio_validade_datetime
                    }
                }

                try:
                    resultado = db.usuarios.insert_one(novo_usuario)
                    st.success(f"Usuário adicionado com sucesso! ID: {resultado.inserted_id}")
                except Exception as e:
                    st.error(f"Erro ao adicionar usuário: {str(e)}")

    # ATUALIZAR USUÁRIO
    elif submenu == "Atualizar":
        st.subheader("Atualizar Usuário")

        id_usuario = st.text_input("ID do Usuário")

        if id_usuario:
            try:
                usuario = db.usuarios.find_one({"_id": ObjectId(id_usuario)})
                if usuario:
                    with st.form("form_update_usuario"):
                        nome = st.text_input("Nome", value=usuario.get("nome", ""))
                        email = st.text_input("Email", value=usuario.get("email", ""))
                        telefone = st.text_input("Telefone", value=usuario.get("telefone", ""))

                        if st.form_submit_button("Atualizar Usuário"):
                            updates = {
                                "nome": nome,
                                "email": email,
                                "telefone": telefone
                            }

                            try:
                                resultado = db.usuarios.update_one(
                                    {"_id": ObjectId(id_usuario)},
                                    {"$set": updates}
                                )

                                if resultado.modified_count > 0:
                                    st.success("Usuário atualizado com sucesso!")
                                else:
                                    st.info("Nenhuma alteração realizada.")
                            except Exception as e:
                                st.error(f"Erro ao atualizar: {str(e)}")
                else:
                    st.error("Usuário não encontrado.")
            except Exception as e:
                st.error(f"Erro ao buscar usuário: {str(e)}")

    # EXCLUIR USUÁRIO
    elif submenu == "Excluir":
        st.subheader("Excluir Usuário")

        id_usuario = st.text_input("ID do Usuário")

        if id_usuario:
            try:
                usuario = db.usuarios.find_one({"_id": ObjectId(id_usuario)})
                if usuario:
                    st.write(f"**Nome:** {usuario.get('nome', 'N/A')}")
                    st.write(f"**Email:** {usuario.get('email', 'N/A')}")

                    st.warning("Esta operação não pode ser desfeita!")

                    if st.button("Confirmar Exclusão", type="primary"):
                        resultado = db.usuarios.delete_one({"_id": ObjectId(id_usuario)})
                        if resultado.deleted_count > 0:
                            st.success("Usuário excluído com sucesso!")
                        else:
                            st.error("Erro ao excluir usuário.")
                else:
                    st.error("Usuário não encontrado.")
            except Exception as e:
                st.error(f"Erro: {str(e)}")

# 2. GERENCIAMENTO DE DENTISTAS
elif menu == "2. Dentistas":
    st.header("Gerenciamento de Dentistas")

    submenu = st.sidebar.radio(
        "Operações",
        ["Listar", "Buscar", "Adicionar", "Atualizar", "Excluir"]
    )

    # LISTAR DENTISTAS
    if submenu == "Listar":
        st.subheader("Lista de Dentistas")
        dentistas = list(db.dentistas.find())

        if not dentistas:
            st.info("Nenhum dentista cadastrado.")
        else:
            for dentista in dentistas:
                with st.expander(f"{dentista.get('nome', 'N/A')} - {dentista.get('cro', 'N/A')}"):
                    col1, col2 = st.columns(2)
                    with col1:
                        st.write(f"**ID:** {dentista['_id']}")
                        st.write(f"**Nome:** {dentista.get('nome', 'N/A')}")
                        st.write(f"**CRO:** {dentista.get('cro', 'N/A')}")
                        st.write(f"**Email:** {dentista.get('email', 'N/A')}")
                    with col2:
                        st.write(f"**Especialidade:** {dentista.get('especialidade', 'N/A')}")
                        st.write(f"**Telefone:** {dentista.get('telefone', 'N/A')}")
                        st.write(f"**Data de Cadastro:** {formatar_data(dentista.get('data_cadastro', None))}")

    # BUSCAR DENTISTAS
    elif submenu == "Buscar":
        st.subheader("Buscar Dentista")

        opcao_busca = st.radio("Buscar por:", ["ID", "CRO"])
        if opcao_busca == "ID":
            id_busca = st.text_input("ID do Dentista")
            if st.button("Buscar") and id_busca:
                try:
                    dentista = db.dentistas.find_one({"_id": ObjectId(id_busca)})
                    if dentista:
                        st.success("Dentista encontrado!")
                        st.json(json.loads(json.dumps(dentista, default=str)))
                    else:
                        st.error("Dentista não encontrado.")
                except Exception as e:
                    st.error(f"Erro: {str(e)}")
        else:
            cro_busca = st.text_input("CRO do Dentista")
            if st.button("Buscar") and cro_busca:
                dentista = db.dentistas.find_one({"cro": cro_busca})
                if dentista:
                    st.success("Dentista encontrado!")
                    st.json(json.loads(json.dumps(dentista, default=str)))
                else:
                    st.error("Dentista não encontrado.")

    # ADICIONAR DENTISTA
    elif submenu == "Adicionar":
        st.subheader("Adicionar Novo Dentista")

        with st.form("form_add_dentista"):
            col1, col2 = st.columns(2)

            with col1:
                nome = st.text_input("Nome")
                cro = st.text_input("CRO")
                senha = st.text_input("Senha", type="password")
                email = st.text_input("Email")

            with col2:
                telefone = st.text_input("Telefone")
                especialidade = st.selectbox("Especialidade",
                                             ["Clínico Geral", "Ortodontia", "Endodontia", "Periodontia",
                                              "Implantodontia", "Outra"])
                dias_atendimento = st.multiselect("Dias de Atendimento",
                                                  ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"])
                horario_inicio = st.time_input("Horário de Início", datetime.strptime("08:00", "%H:%M").time())
                horario_fim = st.time_input("Horário de Término", datetime.strptime("18:00", "%H:%M").time())

            if st.form_submit_button("Adicionar Dentista"):
                novo_dentista = {
                    "nome": nome,
                    "cro": cro,
                    "senha": senha,
                    "email": email,
                    "telefone": telefone,
                    "data_cadastro": datetime.now(),
                    "especialidade": especialidade,
                    "dias_atendimento": dias_atendimento,
                    "horario_inicio": horario_inicio.strftime("%H:%M"),
                    "horario_fim": horario_fim.strftime("%H:%M")
                }

                try:
                    resultado = db.dentistas.insert_one(novo_dentista)
                    st.success(f"Dentista adicionado com sucesso! ID: {resultado.inserted_id}")
                except Exception as e:
                    st.error(f"Erro ao adicionar dentista: {str(e)}")

    # ATUALIZAR DENTISTA
    elif submenu == "Atualizar":
        st.subheader("Atualizar Dentista")

        id_dentista = st.text_input("ID do Dentista")

        if id_dentista:
            try:
                dentista = db.dentistas.find_one({"_id": ObjectId(id_dentista)})
                if dentista:
                    with st.form("form_update_dentista"):
                        nome = st.text_input("Nome", value=dentista.get("nome", ""))
                        email = st.text_input("Email", value=dentista.get("email", ""))
                        telefone = st.text_input("Telefone", value=dentista.get("telefone", ""))
                        especialidade = st.text_input("Especialidade", value=dentista.get("especialidade", ""))

                        if st.form_submit_button("Atualizar Dentista"):
                            updates = {
                                "nome": nome,
                                "email": email,
                                "telefone": telefone,
                                "especialidade": especialidade
                            }

                            try:
                                resultado = db.dentistas.update_one(
                                    {"_id": ObjectId(id_dentista)},
                                    {"$set": updates}
                                )

                                if resultado.modified_count > 0:
                                    st.success("Dentista atualizado com sucesso!")
                                else:
                                    st.info("Nenhuma alteração realizada.")
                            except Exception as e:
                                st.error(f"Erro ao atualizar: {str(e)}")
                else:
                    st.error("Dentista não encontrado.")
            except Exception as e:
                st.error(f"Erro ao buscar dentista: {str(e)}")

    # EXCLUIR DENTISTA
    elif submenu == "Excluir":
        st.subheader("Excluir Dentista")

        id_dentista = st.text_input("ID do Dentista")

        if id_dentista:
            try:
                dentista = db.dentistas.find_one({"_id": ObjectId(id_dentista)})
                if dentista:
                    st.write(f"**Nome:** {dentista.get('nome', 'N/A')}")
                    st.write(f"**CRO:** {dentista.get('cro', 'N/A')}")

                    st.warning("Esta operação não pode ser desfeita!")

                    if st.button("Confirmar Exclusão", type="primary"):
                        resultado = db.dentistas.delete_one({"_id": ObjectId(id_dentista)})
                        if resultado.deleted_count > 0:
                            st.success("Dentista excluído com sucesso!")
                        else:
                            st.error("Erro ao excluir dentista.")
                else:
                    st.error("Dentista não encontrado.")
            except Exception as e:
                st.error(f"Erro: {str(e)}")

# 3. GERENCIAMENTO DE TRATAMENTOS
elif menu == "3. Tratamentos":
    st.header("Gerenciamento de Tratamentos")

    submenu = st.sidebar.radio(
        "Operações",
        ["Listar", "Buscar", "Adicionar", "Atualizar", "Adicionar Procedimento", "Excluir"]
    )

    # LISTAR TRATAMENTOS
    if submenu == "Listar":
        st.subheader("Lista de Tratamentos")
        tratamentos = list(db.tratamentos.find())

        if not tratamentos:
            st.info("Nenhum tratamento cadastrado.")
        else:
            for tratamento in tratamentos:
                with st.expander(
                        f"{tratamento.get('usuario_nome', 'N/A')} - {tratamento.get('tipo_tratamento', 'N/A')}"):
                    col1, col2 = st.columns(2)
                    with col1:
                        st.write(f"**ID:** {tratamento['_id']}")
                        st.write(f"**Paciente:** {tratamento.get('usuario_nome', 'N/A')}")
                        st.write(f"**Tipo:** {tratamento.get('tipo_tratamento', 'N/A')}")
                        st.write(f"**Dentista:** {tratamento.get('dentista_nome', 'N/A')}")
                    with col2:
                        st.write(f"**Início:** {formatar_data(tratamento.get('data_inicio', None))}")
                        st.write(
                            f"**Término Previsto:** {formatar_data(tratamento.get('data_termino_prevista', None))}")
                        st.write(
                            f"**Status:** {'Em andamento' if not tratamento.get('data_termino_efetiva') else 'Concluído'}")
                        st.write(f"**Custo:** R$ {tratamento.get('custo_total', 0):.2f}")

                    # Procedimentos
                    procedimentos = tratamento.get('procedimentos', [])
                    if procedimentos:
                        st.write("**Procedimentos:**")
                        for i, proc in enumerate(procedimentos):
                            st.write(f"- {proc.get('descricao', 'N/A')} ({formatar_data(proc.get('data', None))})")

    # BUSCAR TRATAMENTOS
    elif submenu == "Buscar":
        st.subheader("Buscar Tratamento")

        opcao_busca = st.radio("Buscar por:", ["ID", "Paciente"])
        if opcao_busca == "ID":
            id_busca = st.text_input("ID do Tratamento")
            if st.button("Buscar") and id_busca:
                try:
                    tratamento = db.tratamentos.find_one({"_id": ObjectId(id_busca)})
                    if tratamento:
                        st.success("Tratamento encontrado!")
                        st.json(json.loads(json.dumps(tratamento, default=str)))
                    else:
                        st.error("Tratamento não encontrado.")
                except Exception as e:
                    st.error(f"Erro: {str(e)}")
        else:
            # Lista de pacientes para selecionar
            usuarios = list(db.usuarios.find({}, {"_id": 1, "nome": 1}))
            opcoes_usuarios = ["Selecione um paciente..."] + [f"{u.get('nome', 'N/A')} ({u['_id']})" for u in usuarios]

            paciente_selecionado = st.selectbox("Selecione o Paciente", opcoes_usuarios)

            if paciente_selecionado != "Selecione um paciente..." and st.button("Buscar"):
                id_usuario = paciente_selecionado.split("(")[1].split(")")[0]

                tratamentos = list(db.tratamentos.find({"id_usuario": ObjectId(id_usuario)}))
                if tratamentos:
                    st.success(f"Encontrado(s) {len(tratamentos)} tratamento(s)!")
                    for tratamento in tratamentos:
                        with st.expander(
                                f"{tratamento.get('tipo_tratamento', 'N/A')} - {formatar_data(tratamento.get('data_inicio', None))}"):
                            st.json(json.loads(json.dumps(tratamento, default=str)))
                else:
                    st.error("Nenhum tratamento encontrado para este paciente.")

    # ADICIONAR TRATAMENTO
    elif submenu == "Adicionar":
        st.subheader("Adicionar Novo Tratamento")

        # Buscar usuários e dentistas para selecionar
        usuarios = list(db.usuarios.find({}, {"_id": 1, "nome": 1}))
        dentistas = list(db.dentistas.find({}, {"_id": 1, "nome": 1, "especialidade": 1}))

        if not usuarios:
            st.warning("Não há pacientes cadastrados. Cadastre um paciente primeiro.")
        elif not dentistas:
            st.warning("Não há dentistas cadastrados. Cadastre um dentista primeiro.")
        else:
            opcoes_usuarios = ["Selecione um paciente..."] + [f"{u.get('nome', 'N/A')} ({u['_id']})" for u in usuarios]
            opcoes_dentistas = ["Selecione um dentista..."] + [f"{d.get('nome', 'N/A')} ({d['_id']})" for d in
                                                               dentistas]

            with st.form("form_add_tratamento"):
                usuario_selecionado = st.selectbox("Paciente", opcoes_usuarios)
                dentista_selecionado = st.selectbox("Dentista", opcoes_dentistas)

                col1, col2 = st.columns(2)

                with col1:
                    tipo_tratamento = st.selectbox("Tipo de Tratamento",
                                                   ["Ortodôntico", "Endodôntico", "Restaurador", "Cirúrgico", "Outro"])
                    descricao = st.text_area("Descrição", height=100)
                    data_inicio = st.date_input("Data de Início", datetime.now())
                    data_termino_prevista = st.date_input("Data de Término Prevista",
                                                          datetime.now() + timedelta(days=180))

                with col2:
                    custo_total = st.number_input("Custo Total (R$)", min_value=0.0, step=100.0)
                    forma_pagamento = st.selectbox("Forma de Pagamento", ["À Vista", "Parcelado"])

                    if forma_pagamento == "Parcelado":
                        numero_parcelas = st.number_input("Número de Parcelas", min_value=2, max_value=24, step=1)
                    else:
                        numero_parcelas = 1

                # Primeiro procedimento
                st.subheader("Primeiro Procedimento")
                proc_descricao = st.text_input("Descrição do Procedimento")
                proc_obs = st.text_area("Observações", height=80)

                if st.form_submit_button("Adicionar Tratamento"):
                    if usuario_selecionado != "Selecione um paciente..." and dentista_selecionado != "Selecione um dentista...":
                        try:
                            # Extrair IDs e nomes dos selecionados
                            id_usuario = usuario_selecionado.split("(")[1].split(")")[0]
                            id_dentista = dentista_selecionado.split("(")[1].split(")")[0]
                            nome_usuario = usuario_selecionado.split(" (")[0]
                            nome_dentista = dentista_selecionado.split(" (")[0]

                            # Calcular valor da parcela
                            valor_parcela = custo_total / numero_parcelas if numero_parcelas > 0 else custo_total

                            # Converter datas para datetime
                            data_inicio_dt = datetime.combine(data_inicio, datetime.min.time())
                            data_termino_prevista_dt = datetime.combine(data_termino_prevista, datetime.min.time())

                            novo_tratamento = {
                                "tipo_tratamento": tipo_tratamento,
                                "descricao": descricao,
                                "data_inicio": data_inicio_dt,
                                "data_termino_prevista": data_termino_prevista_dt,
                                "data_termino_efetiva": None,
                                "id_usuario": ObjectId(id_usuario),
                                "usuario_nome": nome_usuario,
                                "id_dentista": ObjectId(id_dentista),
                                "dentista_nome": nome_dentista,
                                "procedimentos": [
                                    {
                                        "data": data_inicio_dt,
                                        "descricao": proc_descricao,
                                        "observacoes": proc_obs
                                    }
                                ],
                                "custo_total": custo_total,
                                "forma_pagamento": {
                                    "metodo": forma_pagamento,
                                    "parcelas": numero_parcelas,
                                    "valor_parcela": valor_parcela
                                }
                            }

                            resultado = db.tratamentos.insert_one(novo_tratamento)
                            st.success(f"Tratamento adicionado com sucesso! ID: {resultado.inserted_id}")
                        except Exception as e:
                            st.error(f"Erro ao adicionar tratamento: {str(e)}")
                    else:
                        st.error("É necessário selecionar um paciente e um dentista.")

    # ATUALIZAR TRATAMENTO
    elif submenu == "Atualizar":
        st.subheader("Atualizar Tratamento")

        id_tratamento = st.text_input("ID do Tratamento")

        if id_tratamento:
            try:
                tratamento = db.tratamentos.find_one({"_id": ObjectId(id_tratamento)})
                if tratamento:
                    st.write(f"**Paciente:** {tratamento.get('usuario_nome', 'N/A')}")
                    st.write(f"**Tipo:** {tratamento.get('tipo_tratamento', 'N/A')}")

                    with st.form("form_update_tratamento"):
                        descricao = st.text_area("Descrição", value=tratamento.get("descricao", ""), height=100)

                        # Extrair datas para exibição correta
                        data_termino_prevista_dt = tratamento.get("data_termino_prevista")
                        if isinstance(data_termino_prevista_dt, datetime):
                            data_termino_prevista_date = data_termino_prevista_dt.date()
                        else:
                            data_termino_prevista_date = datetime.now().date() + timedelta(days=180)

                        col1, col2 = st.columns(2)
                        with col1:
                            data_termino_prevista = st.date_input("Data de Término Prevista",
                                                                  data_termino_prevista_date)

                        with col2:
                            finalizado = st.checkbox("Tratamento Finalizado",
                                                     value=True if tratamento.get("data_termino_efetiva") else False)
                            if finalizado:
                                data_termino_efetiva = st.date_input("Data de Término Efetiva", datetime.now())
                            else:
                                data_termino_efetiva = None

                        if st.form_submit_button("Atualizar Tratamento"):
                            # Converter datas para datetime
                            data_termino_prevista_dt = datetime.combine(data_termino_prevista, datetime.min.time())

                            if finalizado and data_termino_efetiva:
                                data_termino_efetiva_dt = datetime.combine(data_termino_efetiva, datetime.min.time())
                            else:
                                data_termino_efetiva_dt = None

                            updates = {
                                "descricao": descricao,
                                "data_termino_prevista": data_termino_prevista_dt,
                                "data_termino_efetiva": data_termino_efetiva_dt
                            }

                            try:
                                resultado = db.tratamentos.update_one(
                                    {"_id": ObjectId(id_tratamento)},
                                    {"$set": updates}
                                )

                                if resultado.modified_count > 0:
                                    st.success("Tratamento atualizado com sucesso!")
                                else:
                                    st.info("Nenhuma alteração realizada.")
                            except Exception as e:
                                st.error(f"Erro ao atualizar: {str(e)}")
                else:
                    st.error("Tratamento não encontrado.")
            except Exception as e:
                st.error(f"Erro ao buscar tratamento: {str(e)}")

    # ADICIONAR PROCEDIMENTO
    elif submenu == "Adicionar Procedimento":
        st.subheader("Adicionar Procedimento a Tratamento")

        id_tratamento = st.text_input("ID do Tratamento")

        if id_tratamento:
            try:
                tratamento = db.tratamentos.find_one({"_id": ObjectId(id_tratamento)})
                if tratamento:
                    st.write(f"**Paciente:** {tratamento.get('usuario_nome', 'N/A')}")
                    st.write(f"**Tipo:** {tratamento.get('tipo_tratamento', 'N/A')}")

                    # Procedimentos existentes
                    procedimentos = tratamento.get('procedimentos', [])
                    if procedimentos:
                        st.write("**Procedimentos existentes:**")
                        for i, proc in enumerate(procedimentos):
                            st.write(
                                f"{i + 1}. {proc.get('descricao', 'N/A')} ({formatar_data(proc.get('data', None))})")

                    with st.form("form_add_procedimento"):
                        data_proc = st.date_input("Data do Procedimento", datetime.now())
                        descricao_proc = st.text_input("Descrição do Procedimento")
                        observacoes_proc = st.text_area("Observações", height=100)

                        if st.form_submit_button("Adicionar Procedimento"):
                            # Converter data para datetime
                            data_proc_dt = datetime.combine(data_proc, datetime.min.time())

                            novo_procedimento = {
                                "data": data_proc_dt,
                                "descricao": descricao_proc,
                                "observacoes": observacoes_proc
                            }

                            try:
                                resultado = db.tratamentos.update_one(
                                    {"_id": ObjectId(id_tratamento)},
                                    {"$push": {"procedimentos": novo_procedimento}}
                                )

                                if resultado.modified_count > 0:
                                    st.success("Procedimento adicionado com sucesso!")
                                else:
                                    st.error("Erro ao adicionar procedimento.")
                            except Exception as e:
                                st.error(f"Erro: {str(e)}")
                else:
                    st.error("Tratamento não encontrado.")
            except Exception as e:
                st.error(f"Erro ao buscar tratamento: {str(e)}")

    # EXCLUIR TRATAMENTO
    elif submenu == "Excluir":
        st.subheader("Excluir Tratamento")

        id_tratamento = st.text_input("ID do Tratamento")

        if id_tratamento:
            try:
                tratamento = db.tratamentos.find_one({"_id": ObjectId(id_tratamento)})
                if tratamento:
                    st.write(f"**Paciente:** {tratamento.get('usuario_nome', 'N/A')}")
                    st.write(f"**Tipo:** {tratamento.get('tipo_tratamento', 'N/A')}")
                    st.write(f"**Início:** {formatar_data(tratamento.get('data_inicio', None))}")

                    st.warning("Esta operação não pode ser desfeita!")

                    if st.button("Confirmar Exclusão", type="primary"):
                        resultado = db.tratamentos.delete_one({"_id": ObjectId(id_tratamento)})
                        if resultado.deleted_count > 0:
                            st.success("Tratamento excluído com sucesso!")
                        else:
                            st.error("Erro ao excluir tratamento.")
                else:
                    st.error("Tratamento não encontrado.")
            except Exception as e:
                st.error(f"Erro: {str(e)}")

# 4. GERENCIAMENTO DE AGENDAMENTOS
elif menu == "4. Agendamentos":
    st.header("Gerenciamento de Agendamentos")

    submenu = st.sidebar.radio(
        "Operações",
        ["Listar", "Buscar", "Agendar", "Atualizar", "Excluir"]
    )

    # LISTAR AGENDAMENTOS
    if submenu == "Listar":
        st.subheader("Lista de Agendamentos")

        # Adicionar campo de pesquisa por nome
        nome_paciente = st.text_input("Pesquisar paciente pelo nome", "")

        # Manter filtro de data como opção adicional
        usar_filtro_data = st.checkbox("Filtrar também por data")
        if usar_filtro_data:
            filtro_data = st.date_input("Data", datetime.now())
            inicio_dia = datetime.combine(filtro_data, datetime.min.time())
            fim_dia = datetime.combine(filtro_data, datetime.max.time())

        # Construir a consulta
        query = {}

        # Adicionar filtro por nome se fornecido
        if nome_paciente:
            query["usuario_nome"] = {"$regex": nome_paciente, "$options": "i"}  # Case insensitive

        # Adicionar filtro por data se marcado
        if usar_filtro_data:
            query["data_agendada"] = {
                "$gte": inicio_dia,
                "$lte": fim_dia
            }

        # Botão para realizar a busca
        if st.button("Buscar Agendamentos"):
            agendamentos = list(db.agendamentos.find(query).sort("data_agendada", 1))

            if not agendamentos:
                st.info("Nenhum agendamento encontrado com os critérios informados.")
            else:
                st.success(f"Encontrado(s) {len(agendamentos)} agendamento(s).")
                for agendamento in agendamentos:
                    data_hora = agendamento.get('data_agendada')
                    hora = data_hora.strftime("%H:%M") if isinstance(data_hora, datetime) else "N/A"
                    data = data_hora.strftime("%d/%m/%Y") if isinstance(data_hora, datetime) else "N/A"

                    with st.expander(
                            f"[{data} {hora}] {agendamento.get('usuario_nome', 'N/A')} - {agendamento.get('tipo_tratamento', 'N/A')}"):
                        col1, col2 = st.columns(2)
                        with col1:
                            st.write(f"**ID:** {agendamento['_id']}")
                            st.write(f"**Paciente:** {agendamento.get('usuario_nome', 'N/A')}")
                            st.write(f"**Telefone:** {agendamento.get('telefone_usuario', 'N/A')}")
                            st.write(f"**Tipo:** {agendamento.get('tipo_tratamento', 'N/A')}")
                        with col2:
                            st.write(
                                f"**Data/Hora:** {data_hora.strftime('%d/%m/%Y %H:%M') if isinstance(data_hora, datetime) else 'N/A'}")
                            st.write(f"**Duração:** {agendamento.get('duracao_minutos', 'N/A')} minutos")
                            st.write(f"**Sala:** {agendamento.get('sala', 'N/A')}")
                            st.write(f"**Status:** {agendamento.get('status', 'N/A').upper()}")

                        if agendamento.get("observacoes"):
                            st.write(f"**Observações:** {agendamento.get('observacoes', '')}")
        else:
            # Mostrar todos os agendamentos ao carregar a página
            if not nome_paciente and not usar_filtro_data:
                st.info("Digite um nome para pesquisar ou marque a opção de filtrar por data.")

    # BUSCAR AGENDAMENTOS
    elif submenu == "Buscar":
        st.subheader("Buscar Agendamento")

        opcao_busca = st.radio("Buscar por:", ["ID", "Paciente"])
        if opcao_busca == "ID":
            id_busca = st.text_input("ID do Agendamento")
            if st.button("Buscar") and id_busca:
                try:
                    agendamento = db.agendamentos.find_one({"_id": ObjectId(id_busca)})
                    if agendamento:
                        st.success("Agendamento encontrado!")
                        st.json(json.loads(json.dumps(agendamento, default=str)))
                    else:
                        st.error("Agendamento não encontrado.")
                except Exception as e:
                    st.error(f"Erro: {str(e)}")
        else:
            # Lista de pacientes para selecionar
            usuarios = list(db.usuarios.find({}, {"_id": 1, "nome": 1}))
            opcoes_usuarios = ["Selecione um paciente..."] + [f"{u.get('nome', 'N/A')} ({u['_id']})" for u in usuarios]

            paciente_selecionado = st.selectbox("Selecione o Paciente", opcoes_usuarios)

            if paciente_selecionado != "Selecione um paciente..." and st.button("Buscar"):
                id_usuario = paciente_selecionado.split("(")[1].split(")")[0]

                agendamentos = list(db.agendamentos.find({"id_usuario": ObjectId(id_usuario)}).sort("data_agendada", 1))
                if agendamentos:
                    st.success(f"Encontrado(s) {len(agendamentos)} agendamento(s)!")
                    for agendamento in agendamentos:
                        data_hora = agendamento.get('data_agendada')
                        data_str = data_hora.strftime("%d/%m/%Y %H:%M") if isinstance(data_hora, datetime) else "N/A"

                        with st.expander(f"{data_str} - {agendamento.get('tipo_tratamento', 'N/A')}"):
                            st.json(json.loads(json.dumps(agendamento, default=str)))
                else:
                    st.error("Nenhum agendamento encontrado para este paciente.")

    # AGENDAR
    elif submenu == "Agendar":
        st.subheader("Novo Agendamento")

        # Buscar usuários para selecionar
        usuarios = list(db.usuarios.find({}, {"_id": 1, "nome": 1, "telefone": 1}))

        if not usuarios:
            st.warning("Não há pacientes cadastrados. Cadastre um paciente primeiro.")
        else:
            opcoes_usuarios = ["Selecione um paciente..."] + [f"{u.get('nome', 'N/A')} ({u['_id']})" for u in usuarios]

            with st.form("form_add_agendamento"):
                usuario_selecionado = st.selectbox("Paciente", opcoes_usuarios)

                col1, col2 = st.columns(2)

                with col1:
                    data_agendamento = st.date_input("Data", datetime.now())
                    hora_agendamento = st.time_input("Hora", datetime.now().time())
                    duracao = st.number_input("Duração (minutos)", min_value=15, max_value=180, value=30, step=15)

                with col2:
                    tipo_tratamento = st.text_input("Tipo de Consulta/Tratamento")
                    sala = st.selectbox("Sala", ["Consultório 1", "Consultório 2", "Consultório 3", "Sala de Raio-X"])
                    status = st.selectbox("Status", ["Confirmado", "Pendente", "Cancelado"])

                observacoes = st.text_area("Observações", height=100)

                if st.form_submit_button("Agendar"):
                    if usuario_selecionado != "Selecione um paciente...":
                        try:
                            # Extrair ID e informações do usuário
                            id_usuario = usuario_selecionado.split("(")[1].split(")")[0]
                            nome_usuario = usuario_selecionado.split(" (")[0]

                            # Buscar telefone do usuário
                            usuario = db.usuarios.find_one({"_id": ObjectId(id_usuario)})
                            telefone_usuario = usuario.get("telefone", "")

                            # Combinar data e hora
                            data_hora = datetime.combine(data_agendamento, hora_agendamento)

                            novo_agendamento = {
                                "data_agendada": data_hora,
                                "duracao_minutos": duracao,
                                "id_tratamento": None,
                                "tipo_tratamento": tipo_tratamento,
                                "id_usuario": ObjectId(id_usuario),
                                "usuario_nome": nome_usuario,
                                "telefone_usuario": telefone_usuario,
                                "status": status.lower(),
                                "sala": sala,
                                "observacoes": observacoes
                            }

                            resultado = db.agendamentos.insert_one(novo_agendamento)
                            st.success(f"Agendamento realizado com sucesso! ID: {resultado.inserted_id}")
                        except Exception as e:
                            st.error(f"Erro ao agendar: {str(e)}")
                    else:
                        st.error("É necessário selecionar um paciente.")

    # ATUALIZAR AGENDAMENTO
    elif submenu == "Atualizar":
        st.subheader("Atualizar Agendamento")

        id_agendamento = st.text_input("ID do Agendamento")

        if id_agendamento:
            try:
                agendamento = db.agendamentos.find_one({"_id": ObjectId(id_agendamento)})
                if agendamento:
                    data_hora = agendamento.get('data_agendada')

                    st.write(f"**Paciente:** {agendamento.get('usuario_nome', 'N/A')}")

                    with st.form("form_update_agendamento"):
                        col1, col2 = st.columns(2)

                        with col1:
                            data_agendamento = st.date_input(
                                "Data",
                                data_hora.date() if isinstance(data_hora, datetime) else datetime.now().date()
                            )

                            hora_agendamento = st.time_input(
                                "Hora",
                                data_hora.time() if isinstance(data_hora, datetime) else datetime.now().time()
                            )

                            duracao = st.number_input(
                                "Duração (minutos)",
                                min_value=15,
                                max_value=180,
                                value=agendamento.get("duracao_minutos", 30),
                                step=15
                            )

                        with col2:
                            sala = st.selectbox(
                                "Sala",
                                ["Consultório 1", "Consultório 2", "Consultório 3", "Sala de Raio-X"],
                                index=["Consultório 1", "Consultório 2", "Consultório 3", "Sala de Raio-X"].index(
                                    agendamento.get("sala", "Consultório 1"))
                            )

                            status_options = ["Confirmado", "Pendente", "Cancelado", "Concluído"]
                            status_atual = agendamento.get("status", "pendente").capitalize()

                            if status_atual in status_options:
                                status_index = status_options.index(status_atual)
                            else:
                                status_index = 1  # Padrão para "Pendente"

                            status = st.selectbox(
                                "Status",
                                status_options,
                                index=status_index
                            )

                        observacoes = st.text_area(
                            "Observações",
                            value=agendamento.get("observacoes", ""),
                            height=100
                        )

                        if st.form_submit_button("Atualizar Agendamento"):
                            # Combinar data e hora
                            data_hora_nova = datetime.combine(data_agendamento, hora_agendamento)

                            updates = {
                                "data_agendada": data_hora_nova,
                                "duracao_minutos": duracao,
                                "sala": sala,
                                "status": status.lower(),
                                "observacoes": observacoes
                            }

                            try:
                                resultado = db.agendamentos.update_one(
                                    {"_id": ObjectId(id_agendamento)},
                                    {"$set": updates}
                                )

                                if resultado.modified_count > 0:
                                    st.success("Agendamento atualizado com sucesso!")
                                else:
                                    st.info("Nenhuma alteração realizada.")
                            except Exception as e:
                                st.error(f"Erro ao atualizar: {str(e)}")
                else:
                    st.error("Agendamento não encontrado.")
            except Exception as e:
                st.error(f"Erro ao buscar agendamento: {str(e)}")

    # EXCLUIR AGENDAMENTO
    elif submenu == "Excluir":
        st.subheader("Excluir Agendamento")

        id_agendamento = st.text_input("ID do Agendamento")

        if id_agendamento:
            try:
                agendamento = db.agendamentos.find_one({"_id": ObjectId(id_agendamento)})
                if agendamento:
                    data_hora = agendamento.get('data_agendada')
                    data_str = data_hora.strftime("%d/%m/%Y %H:%M") if isinstance(data_hora, datetime) else "N/A"

                    st.write(f"**Paciente:** {agendamento.get('usuario_nome', 'N/A')}")
                    st.write(f"**Data/Hora:** {data_str}")
                    st.write(f"**Tipo:** {agendamento.get('tipo_tratamento', 'N/A')}")

                    st.warning("Esta operação não pode ser desfeita!")

                    if st.button("Confirmar Exclusão", type="primary"):
                        resultado = db.agendamentos.delete_one({"_id": ObjectId(id_agendamento)})
                        if resultado.deleted_count > 0:
                            st.success("Agendamento excluído com sucesso!")
                        else:
                            st.error("Erro ao excluir agendamento.")
                else:
                    st.error("Agendamento não encontrado.")
            except Exception as e:
                st.error(f"Erro: {str(e)}")

# 5. EXPORTAR DADOS
elif menu == "5. Exportar Dados":
    st.header("Exportar Dados")


    def export_collection(collection_name):
        data = list(db[collection_name].find({}))
        # Converter ObjectId para string e tratar datas
        for item in data:
            item['_id'] = str(item['_id'])
            # Converter outros ObjectIds e datas
            for key, value in list(item.items()):
                if isinstance(value, ObjectId):
                    item[key] = str(value)
                elif isinstance(value, datetime):
                    item[key] = value.isoformat()
                elif isinstance(value, dict):
                    # Processar dicionários aninhados
                    for subkey, subvalue in list(value.items()):
                        if isinstance(subvalue, ObjectId):
                            value[subkey] = str(subvalue)
                        elif isinstance(subvalue, datetime):
                            value[subkey] = subvalue.isoformat()

        # Converter para JSON
        json_data = json.dumps(data, default=str, indent=2, ensure_ascii=False)

        # Criar um download button
        st.download_button(
            label=f"Baixar {collection_name}.json",
            data=json_data,
            file_name=f"{collection_name}.json",
            mime="application/json"
        )


    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Exportar Coleções Individuais")
        collection_to_export = st.selectbox(
            "Selecione a coleção para exportar",
            ["usuarios", "dentistas", "tratamentos", "agendamentos"]
        )

        # Mostrar contagem de documentos
        doc_count = db[collection_to_export].count_documents({})
        st.write(f"Esta coleção possui {doc_count} documento(s).")

        if st.button("Exportar Coleção Selecionada", type="primary"):
            with st.spinner(f"Exportando coleção {collection_to_export}..."):
                export_collection(collection_to_export)

    with col2:
        st.subheader("Exportar Banco de Dados Completo")

        # Mostrar estatísticas do banco
        total_docs = sum(
            db[col].count_documents({}) for col in ["usuarios", "dentistas", "tratamentos", "agendamentos"])
        st.write(f"O banco de dados possui {total_docs} documento(s) no total.")

        if st.button("Exportar Todas as Coleções", type="primary"):
            with st.spinner("Exportando o banco de dados completo..."):
                # Preparar dados
                all_data = {}
                for collection in ["usuarios", "dentistas", "tratamentos", "agendamentos"]:
                    data = list(db[collection].find({}))
                    # Converter ObjectId para string e tratar datas
                    for item in data:
                        item['_id'] = str(item['_id'])
                        # Converter outros ObjectIds e datas
                        for key, value in list(item.items()):
                            if isinstance(value, ObjectId):
                                item[key] = str(value)
                            elif isinstance(value, datetime):
                                item[key] = value.isoformat()
                            elif isinstance(value, dict):
                                # Processar dicionários aninhados
                                for subkey, subvalue in list(value.items()):
                                    if isinstance(subvalue, ObjectId):
                                        value[subkey] = str(subvalue)
                                    elif isinstance(subvalue, datetime):
                                        value[subkey] = subvalue.isoformat()

                    all_data[collection] = data

                # Converter para JSON
                json_data = json.dumps(all_data, default=str, indent=2, ensure_ascii=False)

                # Criar um download button
                st.download_button(
                    label="Baixar odontofast_database.json",
                    data=json_data,
                    file_name="odontofast_database.json",
                    mime="application/json"
                )

    # Adicionar instruções
    st.subheader("Instruções")
    st.write("""
    1. Selecione uma coleção específica ou escolha exportar todo o banco de dados
    2. Clique no botão correspondente para iniciar a exportação
    3. Um arquivo JSON será gerado e disponibilizado para download
    4. Você pode usar esse arquivo para backup ou para importar os dados em outro sistema
    """)

    # Mostrar informações sobre o formato
    st.info("""
    **Sobre o formato de exportação:**
    - Os IDs do MongoDB (ObjectId) são convertidos para strings
    - As datas são formatadas em padrão ISO
    - Os caracteres especiais e acentos são preservados
    - A formatação JSON utiliza indentação para melhor legibilidade
    """)