---
origem: "Design do histórico de conversas (artemishub_backend#13) e design do frontend mínimo (artemishub_frontend#2)"
---

# ADR-001: stack do projeto

- **Status:** proposto (aguardando aprovação do time)
- **Data:** 26/11/2026
- **Issues:** [artemishub_docs#3](https://github.com/ArtemisHubApp/artemishub_docs/issues/3), [artemishub_backend#13](https://github.com/ArtemisHubApp/artemishub_backend/issues/13), [artemishub_frontend#2](https://github.com/ArtemisHubApp/artemishub_frontend/issues/2)

## Contexto

O RAG e os agentes já usavam Python, uv e LangGraph ([ADR-002](002-framework-multiagente.md)). Faltava decidir onde ficam as contas e o histórico de conversas, como a interface web fala com eles e como guardar dados pessoais num lugar só (RNF-06, RNF-07, RNF-16). O PDR já previa MLflow e DVC para MLOps.

## Decisão

| Camada | Escolha |
|---|---|
| Backend | Python 3.12, FastAPI, SQLAlchemy 2 (async) com asyncpg, Alembic, uv |
| Banco | Postgres 16, só no backend |
| Agentes | serviço separado e sem banco, chamado pelo backend por HTTP com token de serviço |
| Frontend | React 19, Vite, TypeScript e Tailwind 4, com o design system Artemis |
| Sessão | cookie `HttpOnly` e `SameSite=Strict`, com frontend e API no mesmo endereço, sem CORS |
| Testes | pytest com testcontainers (Postgres real); Vitest, Testing Library, axe e Playwright no frontend |
| Arquitetura | camadas hexagonais nos dois lados, conferidas no CI ([ADR-010](010-codigo-limpo-hexagonal.md)) |

## Alternativas

| Alternativa | Por que não |
|---|---|
| Backend importa os agentes como biblioteca | um serviço só, mas o backend herdaria LangGraph, RAG e PyTorch e misturaria banco com IA |
| Supabase (Postgres e login gerenciados) | login pronto, mas dado pessoal em terceiro e uma ferramenta nova para o time |
| Token em `localStorage` | sobrevive à recarga, mas um script malicioso na página poderia roubá-lo |
| Streamlit no lugar do frontend | rápido, mas sem login nem histórico e descartável |

## Consequências

- Dados pessoais ficam num lugar só, e os agentes nunca recebem e-mail nem id da usuária.
- Dois serviços Python e um contrato entre eles (`/v1/responder`, em [artemishub_agents#36](https://github.com/ArtemisHubApp/artemishub_agents/issues/36)).
- O deploy precisa servir frontend e API no mesmo endereço, com HTTPS ([artemishub_backend#6](https://github.com/ArtemisHubApp/artemishub_backend/issues/6)).
- O deploy em nuvem e o ambiente de produção ainda estão em aberto.
- A arquitetura resultante está em [Arquitetura do backend](../arquitetura/backend.md).
