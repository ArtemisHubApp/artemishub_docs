---
origem: "Design do artemishub_orchestration (seção 6.8) · aprovado em 17/11/2026"
---

# ADR-007: docker-compose como ambiente de desenvolvimento

- **Status:** proposto (aguardando aprovação do time)
- **Data:** 17/11/2026
- **Repo:** [artemishub_orchestration](https://github.com/ArtemisHubApp/artemishub_orchestration)

## Contexto

O app completo (frontend, backend e agentes) só fica de pé na semana 6. Hoje o `rag` é uma linha de comando com ChromaDB gravado em disco, e o `agents` são scripts de dados. Para rodar o RAG localmente é preciso instalar Python, uv e PyTorch, o que é difícil para quem usa Windows.

## Decisão

Adiantar o **`docker-compose.yml`** no orquestrador como um **ambiente de desenvolvimento pronto**, e não como o app rodando:

- segue o molde do orquestrador da Kyte: uma imagem genérica (`ghcr.io/astral-sh/uv:python3.12-bookworm-slim`) e a pasta do submódulo montada no container, sem build. Editar o código no computador já vale dentro do container;
- volumes nomeados guardam o ambiente virtual e o cache de modelos do Hugging Face. O `uv sync` e o download do modelo de embeddings acontecem só uma vez;
- `UV_LOCKED=1`: se o `uv.lock` estiver desatualizado, o container **falha de propósito**, em vez de instalar versões diferentes das do CI (ADR-006);
- serviços:
  - `rag` e `agents`, já usáveis;
  - `backend` e `frontend`, desligados (atrás do perfil `app`) até existir código.

Uso, só com o Docker Desktop instalado:

```bash
docker compose run --rm rag uv run python -m src.query "O que diz a Lei 14.611?"
docker compose run --rm agents uv run pytest -q
```

Quem tem `make` pode usar os atalhos (`make rag-query Q="..."`), mas eles são opcionais.

## Alternativas

- **Esperar a semana 6:** cada pessoa continuaria montando o ambiente do seu jeito até lá.
- **Dockerfile por repo com build:** fica mais lento para iterar (cada mudança pede novo build), e o `rag` ainda não tem um serviço para empacotar.

## Consequências

- Quando o `rag` virar um serviço HTTP (para o `agents` consultar o RAG), o serviço `rag` ganha um comando de servidor e uma porta, e o `agents` passa a chamar `http://rag:<porta>`. A estrutura não muda.
- Na semana 6, `backend` e `frontend` saem do perfil `app` e entram `make start/stop/logs`. É nesse momento que se escolhe o destino de deploy.
- O primeiro `docker compose run` demora, porque baixa a imagem, as dependências e o modelo. Os seguintes são rápidos.
