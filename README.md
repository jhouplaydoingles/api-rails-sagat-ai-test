
# 🚀 Guia de Inicialização do Projeto API com Docker

Este guia tem como objetivo auxiliar o usuário a configurar e executar a API de autenticação utilizando Docker.

---

## 📥 Pré-requisitos

- Docker instalado na máquina
- Git instalado
- Acesso aos repositórios:
  - Docker: [https://github.com/jhouplaydoingles/docker-api-auth-test](https://github.com/jhouplaydoingles/docker-api-auth-test)
  - API: [https://github.com/jhouplaydoingles/api-auth-test](https://github.com/jhouplaydoingles/api-auth-test)

---

## 🧰 Passos de Configuração

### 1. Clone os Repositórios

```bash
git clone https://github.com/jhouplaydoingles/docker-api-auth-test
git clone https://github.com/jhouplaydoingles/api-auth-test
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
