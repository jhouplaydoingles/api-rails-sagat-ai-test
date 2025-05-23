
# 🚀 Guia de Inicialização do Projeto API com Docker

Este guia tem como objetivo auxiliar o usuário a configurar e executar a API de autenticação utilizando Docker.

---

## 📥 Pré-requisitos

- Docker instalado na máquina
- Git instalado
- Acesso aos repositórios:
  - Docker: [https://github.com/jhouplaydoingles/docker-api-auth-test](https://github.com/jhouplaydoingles/docker-api-auth-test)
  - API: [https://github.com/jhouplaydoingles/api-rails-sagat-ai-test](https://github.com/jhouplaydoingles/api-rails-sagat-ai-test)

---

## 🧰 Passos de Configuração

### 1. Clone os Repositórios

```bash
git clone https://github.com/jhouplaydoingles/docker-api-auth-test
git clone https://github.com/jhouplaydoingles/api-rails-sagat-ai-test
```

### 2. Estrutura do Projeto

Após clonar os repositórios, organize os arquivos da seguinte forma:

```
docker-api-auth-test/
├── app/
│   └── [código da API Rails]
├── docker-compose.yml
├── Dockerfile
├── entrypoint.sh
└── nginx.conf
```

> **Nota:** Crie a pasta `app` dentro do repositório `docker-api-auth-test` e mova todo o conteúdo da API Rails para dentro dela.

---

## ⚙️ Build e Execução

### 3. Build dos Containers

Dentro da pasta `docker-api-auth-test`, execute:

```bash
docker compose build
```

### 4. Subir os Containers

Após a conclusão do build, inicie os containers com:

```bash
docker compose up
```

### 5. Migração do Banco de Dados

Com os containers em execução, aplique as migrações do banco de dados com o comando:

```bash
docker compose exec web rails db:migrate
```

---

## 🔍 Considerações Finais

- Certifique-se de que **nenhum serviço esteja usando a porta 3000** antes de iniciar a API.
- Após isso, a API estará disponível e pronta para uso em:

```
http://localhost:3000
```

---


# 📘 Documentação da API de Autenticação e Transferência Bancária

**Base URL:** `http://localhost:3000/v1`

---

## 🔐 Autenticação de Usuário

### ▶️ Criar Conta

- **URL:** `POST /auth/sign_up`
- **Body (JSON):**
```json
{
  "user": {
    "name": "Maria mandalena",
    "email": "usuario@example.com",
    "password": "1234"
  }
}
```

### 🔑 Login

- **URL:** `PUT /auth/sign_in`
- **Body (JSON):**
```json
{
  "user": {
    "email": "usuario@example.com",
    "password": "1234"
  }
}
```

---

## 👤 Informações do Usuário

- **URL:** `GET /users/infos`
- **Headers:**
  - Authorization: `Bearer <TOKEN_JWT>`

---

## 🏦 Contas Bancárias do Usuário

### 📄 Listar contas para transferências

- **URL:** `GET /users/bank_accounts`
- **Headers:**
  - Authorization: `Bearer <TOKEN_JWT>`

### 📄 Listar contas bancárias do próprio usuário

- **URL:** `GET /users/bank_accounts/my`
- **Headers:**
  - Authorization: `Bearer <TOKEN_JWT>`

---

## 💸 Transferências Bancárias

### 🔁 Efetuar Transferência

- **URL:** `POST /users/bank_account_transfers`
- **Headers:**
  - Authorization: `Bearer <TOKEN_JWT>`
- **Body (JSON):**
```json
{
  "bank_account_transfer": {
    "to_user_bank_account_id": 4,
    "from_user_bank_account_id": 6,
    "transfer_type": 1,
    "amount_to_transfer": 10.0
  },
  "make_success": true
}
```

**Observação:**
- `transfer_type`: `1` = PIX, `2` = TED (uso apenas estético)
- `make_success`: controle de simulação de sucesso no ambiente de testes

---

## 📊 Listagem de Extração de Transferências

### 📥 Endpoint de Extrato

- **URL:** `GET /users/bank_account_transfers/statements`
- **Headers:**
  - Authorization: `Bearer <TOKEN_JWT>`

### 🔍 Parâmetros de Filtro

| Parâmetro         | Tipo     | Descrição |
|------------------|----------|-----------|
| `start_date`     | Date     | Data inicial (formato ISO 8601 ou `YYYY-MM-DD`) |
| `end_date`       | Date     | Data final (default: agora) |
| `min_value`      | Decimal  | Valor mínimo da transferência |
| `max_value`      | Decimal  | Valor máximo da transferência |
| `transfer_type`  | String   | `'sent'` para enviadas, `'received'` para recebidas, omitido para ambas |
| `per_page`       | Integer  | Registros por página (default: 10) |
| `page`           | Integer  | Página atual (default: 1) |

### 🔁 Lógica de Paginação

A resposta inclui metadados úteis para paginação:

- `total_records`: Total de transferências encontradas
- `total_pages`: Total de páginas disponíveis
- `current_page`: Página atual (ajustada para limites válidos)
---

## 🧪 Exemplo de Requisição com Filtros

**GET /users/bank_account_transfers/statements?start_date=2025-05-01&end_date=2025-05-23&min_value=100&transfer_type=sent&page=2&per_page=5**
