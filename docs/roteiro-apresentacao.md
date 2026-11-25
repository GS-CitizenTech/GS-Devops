# Roteiro de apresentação e vídeo

Use esta sequência para a gravação narrada e para a apresentação presencial. Grave em uma única tomada, em pelo menos 720p, com a voz clara. Mostre a tela e explique o que está acontecendo.

## 1. Apresente a solução

Explique que o Alerta Cidadão é uma API .NET 10 para cadastrar usuários, pontos de monitoramento, leituras de enchente, alertas e requisições idempotentes. Mostre o README, as camadas da solução e o desenho em `docs/arquitetura.svg`.

## 2. Mostre o Azure DevOps

1. Abra o projeto privado `Sprint 4 – Azure DevOps`.
2. No Boards, abra a tarefa inicial.
3. Mostre a branch de trabalho, o commit de código-fonte, o PR vinculado à tarefa e o revisor.
4. Mostre as políticas da `main`: PR obrigatório, ao menos um revisor e vínculo com Work Item.
5. Conclua mostrando a tarefa e os links para commit, PR e pipeline.

## 3. Mostre a CI e o deploy

1. Abra `azure-pipeline.yml` na raiz e explique o gatilho na `main`.
2. Mostre a execução disparada pelo merge do PR.
3. Na CI, mostre restore, build, os resultados xUnit e o artefato `drop`.
4. Na CD, mostre que o deploy só inicia após a CI terminar com sucesso.
5. No Portal Azure, mostre o Resource Group `rg-sprint4`, o App Service e o plano Linux F1 em Brazil South.
6. Abra o Swagger publicado e mostre a API respondendo.

## 4. Demonstre o CRUD e prove no Oracle

Faça POST, GET, PUT e DELETE usando o Swagger. Depois de cada operação, execute um `SELECT` no SQL Developer e mostre o registro correspondente. O `GET` serve para demonstrar a resposta HTTP; a persistência deve ser comprovada no banco.

Repita para as cinco tabelas:

| Tabela | Chave para filtrar o `SELECT` |
|---|---|
| `USUARIO` | `ID_USUARIO` |
| `PONTO_MONITORAMENTO` | `ID_PONTO` |
| `LEITURA_ENCHENTE` | `ID_LEITURA` |
| `ALERTA` | `ID_ALERTA` |
| `REQUISICAO_IDEMPOTENCIA` | `CHAVE_IDEMPOTENCIA` |

Após o `DELETE`, mostre se a linha foi removida ou desativada logicamente, conforme a regra de cada entidade. Use dados de demonstração, nunca credenciais reais na gravação.

## 5. Encerre

Resuma como Boards, Repos, Pipelines, Azure App Service e Oracle se conectam. Termine mostrando a tarefa concluída e as evidências de commit, PR, testes, artefato e deploy.

## Checklist antes de gravar

- [ ] O projeto está privado e o professor tem acesso Basic na organização e Project Administrators no projeto.
- [ ] O código está no Azure Repos e a `main` exige PR, revisor e Work Item.
- [ ] A tarefa está ligada à branch, ao commit e ao PR.
- [ ] O YAML executa na `main` e faz deploy só depois da CI aprovada.
- [ ] O artefato e os testes aparecem na execução do pipeline.
- [ ] O aplicativo responde na nuvem e o Oracle está acessível.
- [ ] O vídeo mostra CRUD e `SELECT` no banco para cada tabela.
- [ ] A gravação tem narração clara e resolução mínima de 720p.
- [ ] O PDF final contém grupo, RM, nomes completos, link da organização e link do vídeo.
