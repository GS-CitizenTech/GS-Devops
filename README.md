# Alerta Cidadão — CitizenTech

Sistema de monitoramento e gerenciamento de alertas relacionados a enchentes, desenvolvido em .NET 10, com integração ao banco de dados Oracle e recursos de segurança, confiabilidade e monitoramento.

## Integrantes

- Lucas Rafael Solimene / RM: 565194 / Turma: 2TDSPF
- Samyr Couto Oliveira / RM: 565562 / Turma: 2TDSPF
- Henrique Teixeira Cesar / RM: 563088 / Turma: 2TDSPF

## Sobre o projeto

O **Alerta Cidadão** é uma solução voltada à iniciativa CitizenTech, com o objetivo de apoiar o monitoramento de situações de risco relacionadas a enchentes.

A aplicação disponibiliza uma API REST para gerenciamento de usuários e informações relacionadas aos alertas, incorporando mecanismos para proteger os endpoints, evitar a duplicidade de operações e monitorar a disponibilidade da aplicação e de suas dependências.

## Funcionalidades implementadas

- **Gerenciamento de usuários:** endpoints para operações relacionadas aos usuários.
- **Documentação da API:** documentação interativa utilizando Swagger/OpenAPI.
- **Idempotência:** evita a execução duplicada de operações quando uma requisição é repetida com a mesma chave.
- **Rate Limiting:** controla a quantidade de requisições recebidas e protege a API contra excesso de chamadas.
- **Autenticação JWT:** autenticação baseada em tokens para proteger os endpoints.
- **Autorização por perfil:** controle de acesso conforme o papel do usuário.
- **Health Checks:** monitoramento da disponibilidade da API e da conexão com o Oracle.
- **Testes automatizados:** testes unitários e de integração para validar os principais recursos da aplicação.

## Tecnologias utilizadas

| Tecnologia | Finalidade |
|---|---|
| C# | Linguagem de programação |
| .NET 10 | Plataforma de desenvolvimento |
| ASP.NET Core | Construção da API REST |
| Oracle Database | Banco de dados relacional |
| Entity Framework Core | Persistência e acesso a dados |
| JWT Bearer | Autenticação |
| Swagger / OpenAPI | Documentação e testes da API |
| xUnit | Testes automatizados |
| Git e Azure Repos | Versionamento do projeto |
| Azure Boards | Tarefas ligadas a branches, commits e pull requests |
| Azure DevOps (Pipelines YAML) | CI/CD: build, testes, artefato e deploy |
| Azure Web App (Linux) | Hospedagem da API em nuvem |
| Oracle Database FIAP | Banco de dados em nuvem |

## Arquitetura da solução + Fluxo CI/CD

![Arquitetura e fluxo CI/CD](docs/arquitetura.svg)

1. A tarefa é criada no Azure Boards e vinculada à branch e ao pull request.
2. A equipe trabalha em uma branch de tarefa no Azure Repos e abre um PR para `main`.
3. A branch `main` deve exigir revisor, vínculo com Work Item e revisor padrão; alterações entram por merge do PR.
4. O merge na `main` dispara `azure-pipeline.yml`.
5. **CI:** restore, build .NET 10, testes xUnit, publicação dos resultados e artefato `drop`.
6. **CD:** após CI bem-sucedida, configurações protegidas são aplicadas e o pacote é implantado no Azure App Service.
7. A API acessa o Oracle da FIAP pelo Entity Framework Core e atende via HTTPS/JWT.

O projeto no Azure DevOps deve permanecer privado. Adicione o professor com nível **Basic** na organização e **Project Administrators** no projeto, usando o e-mail informado pela FIAP.

Consulte [o roteiro de apresentação e demonstração](docs/roteiro-apresentacao.md) para a ordem sugerida do vídeo e a lista de verificação da entrega.

## Pipeline CI/CD (Azure DevOps)

| Stage | Task | O que faz |
|---|---|---|
| CI | UseDotNet | Instala o .NET 10 no agente |
| CI | Restore / Build | Restaura pacotes e compila a solução em Release |
| CI | DotNetCoreCLI test | Executa os testes e publica os resultados |
| CI | DotNetCoreCLI publish | Gera o pacote .zip da `AlertaCidadao.API` |
| CI | PublishBuildArtifacts | Publica o artefato `drop` |
| CD | AzureAppServiceSettings | Aplica a connection string do Oracle e a chave JWT no Web App |
| CD | AzureWebApp | Faz o deploy do artefato no Azure Web App (Linux, .NET 10) |

**Variáveis protegidas:** o variable group `sprint4-secrets` (Pipelines > Library) guarda `ORACLE_CONNECTION_STRING` e `JWT_SIGNING_KEY` como secretas. Nenhuma senha ou chave fica no repositório.

**Aplicação publicada:** [Alerta Cidadão no Azure](https://app-alertacidadao-rm563088-ckgwcwdhgubua2aa.brazilsouth-01.azurewebsites.net) · Swagger em `/swagger` · Health check em `/health/ready`. O plano existente está em `rg-sprint4`, região Brazil South, SKU gratuito F1.

### Conferência de persistência no banco

```sql
SELECT * FROM USUARIO;
SELECT * FROM PONTO_MONITORAMENTO;
SELECT * FROM LEITURA_ENCHENTE;
SELECT * FROM ALERTA;
SELECT * FROM REQUISICAO_IDEMPOTENCIA;
```

Na gravação, mostre cada POST, GET, PUT e DELETE pelo Swagger e comprove no SQL Developer a persistência de cada uma das cinco tabelas. Para registros com exclusão lógica, confirme a coluna `ATIVO`/`STATUS` depois do DELETE. O GET demonstra a resposta da API; o `SELECT` no Oracle é a evidência de persistência pedida pela entrega.

## Arquitetura do projeto

A solução utiliza uma organização em camadas para separar as responsabilidades da aplicação.

```text
GS-.NET/
│
├── src/
│   ├── AlertaCidadao.API/
│   │   ├── Authentication/
│   │   ├── Endpoints/
│   │   ├── Extensions/
│   │   ├── Filters/
│   │   └── HealthChecks/
│   │
│   ├── AlertaCidadao.Application/
│   │
│   ├── AlertaCidadao.Domain/
│   │
│   └── AlertaCidadao.Infrastructure/
│
├── test/
│   └── AlertaCidadao.UnitTests/
│
├── docs/
│   ├── arquitetura.svg
│   ├── diagram.mmd
│   └── HealthChecks.md
│
├── scripts/
│   ├── provision-azure.sh
│   └── script-bd.sql
├── azure-pipeline.yml
├── azure-pipelines.yml
└── AlertaCidadao.sln
```

### Responsabilidades das camadas

- **API:** disponibiliza os endpoints HTTP, autenticação, autorização, filtros e configurações da aplicação.
- **Application:** concentra os serviços e as regras de aplicação.
- **Domain:** contém as entidades e regras centrais do domínio.
- **Infrastructure:** implementa os recursos de infraestrutura, incluindo persistência e acesso ao Oracle.
- **UnitTests:** contém os testes automatizados da solução.

## Pré-requisitos

Antes de executar o projeto, é necessário ter instalado:

- [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0)
- Azure CLI, autenticado na assinatura que contém os recursos
- [Oracle Database](https://www.oracle.com/database/)
- [Git](https://git-scm.com/)
- Visual Studio ou Visual Studio Code (opcional)

## Configuração do projeto

As configurações sensíveis devem ser armazenadas utilizando o **.NET User Secrets**, evitando a inclusão de senhas, chaves JWT e credenciais no repositório.

Acesse a pasta da API:

```powershell
cd src/AlertaCidadao.API
```

Inicialize o User Secrets, caso ainda não esteja configurado:

```powershell
dotnet user-secrets init
```

Configure a conexão com o Oracle:

```powershell
dotnet user-secrets set "ConnectionStrings:Oracle" "SUA_CONNECTION_STRING"
```

Configure os parâmetros de autenticação JWT:

```powershell
dotnet user-secrets set "Jwt:Issuer" "AlertaCidadao.API"
dotnet user-secrets set "Jwt:Audience" "AlertaCidadao.Client"
dotnet user-secrets set "Jwt:SigningKey" "SUA_CHAVE_SECRETA"
dotnet user-secrets set "Jwt:ExpirationMinutes" "60"
```

> Utilize os mesmos valores de Issuer, Audience e demais configurações esperados pela aplicação. A chave JWT deve ser forte e mantida em segredo.

## Como executar a aplicação

Na raiz do repositório, restaure as dependências:

```powershell
dotnet restore .\AlertaCidadao.sln
```

Compile a solução:

```powershell
dotnet build .\AlertaCidadao.sln
```

Execute a API:

```powershell
dotnet run --project .\src\AlertaCidadao.API
```

A aplicação estará disponível em:

```text
http://localhost:5075
```

## Provisionar a infraestrutura

O script usa Azure CLI, cria apenas recursos ausentes e reutiliza por padrão os nomes e a região da implantação atual. O plano padrão é F1. Antes de executar, autentique-se com `az login` e selecione a assinatura correta com `az account set --subscription <ID-ou-nome>`.

```bash
bash scripts/provision-azure.sh
```

É possível informar `RESOURCE_GROUP`, `LOCATION`, `PLAN_NAME`, `PLAN_SKU` e `WEB_APP_NAME` como variáveis de ambiente. Alterar `PLAN_SKU` para uma opção paga pode gerar cobrança. O script não configura segredos; isso é feito pela Library do Azure Pipelines.

O DDL está em `scripts/script-bd.sql`. Ele cria as cinco tabelas usadas pela aplicação: `USUARIO`, `PONTO_MONITORAMENTO`, `LEITURA_ENCHENTE`, `ALERTA` e `REQUISICAO_IDEMPOTENCIA`.

## Documentação da API

Com a aplicação em execução, acesse a interface Swagger:

```text
http://localhost:5075/swagger
```

O Swagger permite visualizar os endpoints, consultar os parâmetros das requisições e realizar testes diretamente pelo navegador.

Para acessar endpoints protegidos, utilize o mecanismo **Authorize** do Swagger e informe um token JWT válido.

## Recursos de segurança e confiabilidade

### Idempotência

A API utiliza chaves de idempotência para impedir que uma mesma operação seja executada repetidamente quando uma requisição é reenviada.

Comportamentos implementados:

- Uma repetição com a mesma chave e os mesmos dados retorna a resposta original.
- A mesma chave utilizada com dados diferentes retorna HTTP 409 (Conflict).
- Requisições sem chave continuam seguindo o fluxo normal.
- Chaves inválidas são rejeitadas.
- O mecanismo trata requisições concorrentes conforme a implementação de persistência da aplicação.

### Rate Limiting

Foram implementadas políticas de limitação de requisições para controlar o volume de chamadas à API.

O mecanismo contempla:

- Política global.
- Política específica para login.
- Política específica para cadastro.
- Resposta HTTP 429 (Too Many Requests) quando o limite é excedido.
- Cabeçalho `Retry-After` para informar o intervalo de espera.

### Autenticação e autorização JWT

A API utiliza JWT Bearer para autenticar os usuários.

O mecanismo contempla:

- Geração e validação de tokens.
- Validação de emissor e audiência.
- Validação da assinatura do token.
- Controle de expiração.
- Autorização baseada em perfil de acesso.

Respostas esperadas para situações de acesso:

| Situação | HTTP |
|---|---:|
| Token ausente ou inválido | 401 |
| Usuário sem permissão | 403 |
| Acesso autorizado | 200 |

### Health Checks

A aplicação disponibiliza endpoints para monitorar sua disponibilidade e a conexão com o banco de dados.

| Endpoint | Finalidade |
|---|---|
| `/health/live` | Verifica se a aplicação está em execução. |
| `/health/ready` | Verifica se a aplicação está pronta para atender requisições, considerando a dependência Oracle. |
| `/health` | Apresenta o estado geral da aplicação e suas verificações. |

Os endpoints retornam informações estruturadas em JSON e utilizam HTTP 503 quando uma verificação de disponibilidade falha.

## Testes automatizados

A solução possui testes automatizados utilizando xUnit.

Para executar todos os testes:

```powershell
dotnet test .\AlertaCidadao.sln --configuration Release
```

Para executar com informações detalhadas:

```powershell
dotnet test .\AlertaCidadao.sln --configuration Release --logger "console;verbosity=normal"
```

### Cobertura dos testes implementados

Os testes contemplam:

- Autenticação JWT.
- Autorização por perfil.
- Validação de tokens.
- Comportamento de idempotência.
- Reutilização de chaves com dados diferentes.
- Validação de chaves inválidas.
- Limitação de requisições.
- Respostas HTTP 429 e cabeçalho `Retry-After`.
- Health Checks da API.
- Disponibilidade e indisponibilidade da conexão com o Oracle.

**Resultado da execução da suíte:** 34 testes aprovados e 0 falhas.
