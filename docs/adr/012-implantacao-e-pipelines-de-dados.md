---
origem: "Análise de 5 arquiteturas de implantação (sessão de 26/11/2026) · artemishub_backend#6"
---

# ADR-012: implantação no Azure for Students com dados publicados como artefato

- **Status:** proposto
- **Data:** 26/11/2026
- **Issues:** [artemishub_backend#6](https://github.com/ArtemisHubApp/artemishub_backend/issues/6), [artemishub_rag#25](https://github.com/ArtemisHubApp/artemishub_rag/issues/25), [artemishub_backend#11](https://github.com/ArtemisHubApp/artemishub_backend/issues/11)

## Contexto

A aplicação precisa de uma URL pública para a validação com usuárias e a apresentação (backend#6). Até agora só existe o ambiente de desenvolvimento ([ADR-007](007-compose-de-desenvolvimento.md)).

As restrições são:

- **Orçamento:** os créditos do **Azure for Students** (US$ 100 por 12 meses, sem cartão). Quando o crédito acaba, a assinatura é desativada e tudo para.
- **Stack:** a do [ADR-001](001-stack.md). Frontend e API ficam no mesmo endereço por causa do cookie `SameSite=Strict`, e os agentes ficam num serviço separado, sem banco.
- **RAG:** o RAG atual (ChromaDB em disco, MiniLM em CPU, BM25 + RRF e publicação atômica) foi avaliado e documentado. Trocar de banco vetorial obrigaria a refazer a avaliação.
- **Agendamento:** a equipe quer usar **Airflow** para atualizar as bases do RAG e da RAIS (rag#25, backend#11).
- **App instalável:** a equipe quer um **PWA** para facilitar o uso no celular.
- **Dados versionados:** a RAIS já é versionada com **DVC** no **DagsHub** (artemishub_agents, commit `5a20aab`).
- **Modelo salarial:** pode virar estatística clássica (decomposição de Oaxaca-Blinder, em investigação), além dos agentes com LLM.

As atualizações de dados são raras: a RAIS sai uma vez por ano e as fontes do RAG mudam poucas vezes por mês. Nenhuma delas precisa de um serviço ligado 24 horas.

## Decisão

Separar o sistema em dois planos.

**Plano de serviço (online, no Azure):**

| Componente | Serviço | Observação |
|---|---|---|
| `frontend` | build estático servido pelo `gateway` | PWA em React 19, Vite, TypeScript e Tailwind 4 com `vite-plugin-pwa`. O cliente da API é gerado do `contratos/openapi.json` do backend. |
| `gateway` | Azure Container Apps | Caddy entrega o build do frontend e faz proxy de `/api`. Assim o PWA e a API ficam na mesma origem. |
| `backend` | Azure Container Apps | FastAPI em camadas hexagonais (`adapters` → `application` → `domain`): cadastro, sessão, conta e conversas em `/v1`. Sem ingress público, atrás do gateway. |
| `agents` | Azure Container Apps | LangGraph. O índice do RAG e as tabelas da RAIS **vêm dentro da imagem**, somente leitura. |
| `leitor` | Azure Container Apps (scale-to-zero) | Lê o currículo enviado em PDF ou foto, na CPU, com um modelo aberto escolhido pela Ana Julia. **Isolado: sem saída para a internet e sem acesso ao banco**, porque é quem abre arquivos de terceiros. Recebe os bytes do backend e devolve só o texto. |
| Banco | Postgres Flexible B1ms | contas, conversas e o **texto** do currículo (conferido e mascarado), objetivo e competências confirmadas. Gratuito por 12 meses na assinatura de estudante. Se o checkpointer do LangGraph fica aqui ainda está em aberto ([docs#50](https://github.com/ArtemisHubApp/artemishub_docs/issues/50)) |
| Imagens | Azure Container Registry Basic | ou GHCR, se a equipe preferir custo zero |
| Segredos | segredos do Container Apps | chave do LLM, token do Langfuse, token de leitura do DagsHub e tokens de serviço dos agents e do leitor |

**Currículo sem armazenamento de arquivo.** O PDF ou a foto passam só pela memória do backend e do leitor e **nunca são gravados**: nada de Blob, disco ou log. Só o texto que a usuária confere, sem e-mail, telefone, CPF e CEP, fica no Postgres. Isso dispensa um Blob Storage, a regra de retenção dele e a exclusão em dois lugares. O custo dessa escolha: se o modelo de leitura mudar, a usuária precisa enviar o currículo de novo. Detalhes no [desenho do currículo](https://github.com/ArtemisHubApp/artemishub_backend/blob/claude/pensive-franklin-ggl64a/docs/superpowers/specs/2026-11-26-curriculo-design.md).

**Plano de dados (batch, fora do Azure):**

- **Airflow efêmero:** as DAGs rodam num workflow agendado do GitHub Actions (`airflow dags test`, com minutos gratuitos porque os repositórios são públicos) ou pelo compose de uma integrante. Não há servidor do Airflow ligado nem interface exposta na internet.
- **As DAGs só chamam pacotes Python** que já existem e são testados sem Airflow (`artemis_rag.pipeline`, `src.rais_*`, o módulo do modelo salarial).
- **`dag_rag`** (mensal ou sob demanda): as 10 etapas do pipeline, seguidas da avaliação de recuperação. O índice só é publicado se não piorar.
- **`dag_rais`** (anual): baixa, filtra STEM, agrega e valida a RAIS.
- **`dag_salarial`** (disparada por um Asset quando a `dag_rais` publica): o modelo salarial, por exemplo a decomposição de Oaxaca-Blinder, que gera tabelas agregadas.
- **`dag_oportunidades`** (semanal, se o RF-10 virar coleta): catálogo de oportunidades com data de atualização (RNF-09).
- **Saída das DAGs:** artefatos versionados com **DVC** e enviados ao **DagsHub**. O commit do arquivo `.dvc` é o ponteiro da versão publicada, e o rollback é um `git revert`.
- **Entrega:** o CI faz `dvc pull` com um token de leitura e coloca os artefatos na imagem dos `agents`. Em produção, nada depende do DagsHub estar no ar.

**Ferramenta de cada tipo de rastreamento:**

| Ferramenta | Para quê |
|---|---|
| Langfuse | LLM em execução: traces, prompts versionados, avaliação das respostas ([ADR-002](002-framework-multiagente.md)) |
| MLflow (servidor do DagsHub) | experimentos offline: modelo salarial (especificação, grupo de referência, métricas por grupo) e ajuste do RAG (chunk, k, pesos) |
| DVC + DagsHub | dados brutos, tabelas da RAIS e índices do RAG |

**Plano de saída:** quando o crédito acabar, o plano de serviço migra para provedores com tier gratuito (Cloudflare Pages, Fly.io ou Render, Neon ou Supabase). O plano de dados não muda.

## Alternativas

| Alternativa | Custo estimado (US$/mês) | Por que não |
|---|---|---|
| **VM única com o compose do ADR-007** | 35 a 70 (o crédito dura de 1,5 a 3 meses) | Airflow e torch disputam a RAM. É um ponto único de falha, com backup, TLS e patches manuais. Fica como plano B para o dia da apresentação. |
| **PaaS com Azure AI Search** no lugar do ChromaDB | 6 a 25 | A busca híbrida é nativa, mas joga fora o RAG avaliado e cria lock-in. O tier Free é um por assinatura, e o salto seguinte custa cerca de US$ 74/mês. |
| **AKS com o Helm chart oficial do Airflow** | 95 a 150 (o crédito acaba no primeiro mês) | Resolve uma escala que não temos e exige um SRE que a equipe não tem. |
| **Multiprovedor com tiers gratuitos e pgvector** | 0 a 15 | Sem prazo de crédito, mas com quatro painéis, quatro contratos para a LGPD e regras de tier que mudam. Também obrigaria a refazer a avaliação do RAG. Fica como plano de saída. |
| **Airflow gerenciado** (Astronomer, ou o Airflow do Azure Data Factory) | 300 ou mais, ou serviço em descontinuação | Fora do orçamento. |

Custos estimados com preços de tabela em East US, ainda **sem conferência** na calculadora do Azure. Brazil South costuma custar de 30% a 50% a mais. O LLM (Gemini Flash) custa cerca de US$ 3 a 6 por mês para 1.000 perguntas e é igual em todas as alternativas.

## Consequências

- **Custo estimado:** de US$ 5 a 30 por mês, ou seja, de 4 a 12 meses de crédito. O valor varia com o número de réplicas mínimas dos `agents`.
- **Cold start:** a imagem dos `agents` com torch demora de 20 a 40 s para subir, o que estoura a meta de 10 s do PDR. Mitigações: uma réplica mínima nas janelas de uso e de demonstração, e testar o mesmo modelo em ONNX. O modelo e a revisão precisam ser idênticos, senão o índice recusa a consulta.
- **ChromaDB copiado para o disco do container:** o índice não fica num volume do Azure Files, porque o SQLite tem problemas de lock sobre SMB.
- **Limites do runner:** a `dag_rais` pode passar do disco ou da RAM do runner do GitHub com os microdados completos. Nesse caso, ela roda pelo compose local ou numa VM ligada só durante a execução.
- **PWA:** o service worker guarda só o shell e os assets, nunca respostas da `/api` (LGPD). No iOS, push só funciona com o PWA instalado.
- **Plano de dados sem interface sempre no ar:** para mostrar a interface do Airflow na apresentação, ela é aberta localmente pelo compose.

**Riscos que exigem ação:**

1. **Fim do crédito:** configurar alertas no Azure Budgets em 50%, 80% e 100% e marcar a data de migração.
2. **Dependência de uma pessoa:** a assinatura do Azure e o remote do DagsHub (`CamilaSilvaC/artemishub-rais-dvc`) são contas pessoais. Migrar o DagsHub para uma organização e documentar o acesso das quatro integrantes.
3. **Região e LGPD:** a assinatura de estudante pode restringir regiões. Se os dados ficarem fora do Brasil, isso entra no aviso de privacidade (art. 33).
4. **Tier gratuito do Gemini:** os termos permitem uso dos dados para melhorar o produto, o que conflita com o RNF-16 quando há currículo. Usar o tier pago (ou o Vertex AI) com dados reais.
5. **Langfuse:** mascarar dados pessoais antes do trace e definir a retenção.
6. **Pico de LLM na apresentação:** preparar cache das perguntas da demonstração ou cota maior.

**Issues abertas na revisão de arquitetura deste ADR:** [docs#50](https://github.com/ArtemisHubApp/artemishub_docs/issues/50) (fronteira de dados dos agents), [docs#51](https://github.com/ArtemisHubApp/artemishub_docs/issues/51) (ADR de LGPD), [docs#52](https://github.com/ArtemisHubApp/artemishub_docs/issues/52) (matriz de navegadores), [backend#27](https://github.com/ArtemisHubApp/artemishub_backend/issues/27) (latência, timeout e streaming), [backend#28](https://github.com/ArtemisHubApp/artemishub_backend/issues/28) (id de correlação), [backend#29](https://github.com/ArtemisHubApp/artemishub_backend/issues/29) (cota de perguntas), [backend#30](https://github.com/ArtemisHubApp/artemishub_backend/issues/30) (cabeçalhos de segurança) e [agents#64](https://github.com/ArtemisHubApp/artemishub_agents/issues/64) (schema das tabelas da RAIS). O checklist do deploy está num comentário da [backend#6](https://github.com/ArtemisHubApp/artemishub_backend/issues/6).

**Para aceitar este ADR, a equipe confirma:**

- se o modelo salarial será Oaxaca-Blinder ou outro (afeta a `dag_salarial` e o uso do MLflow);
- onde ficam os arquivos das DAGs: numa pasta `dags/` de cada repositório, ou num repositório próprio;
- os preços na calculadora do Azure e a região permitida pela assinatura de estudante.

## Fontes

- [Implantação e pipelines de dados](../arquitetura/implantacao.md)
- [Pipeline de ingestão do RAG](../rag/pipeline.md) e [Embeddings e banco vetorial](../rag/embeddings.md)
- [Modelo salarial](../arquitetura/modelo-salarial.md)
- [Plano de CI/CD do artemishub_agents](https://github.com/ArtemisHubApp/artemishub_agents/blob/main/docs/superpowers/plans/2026-11-17-cicd-pipeline.md) (decisão pelo DagsHub)
