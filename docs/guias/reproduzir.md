---
origem: "Grupo 11 - Second Challenge - RAG (Relatório de Projeto, Semana 2) · seção Como reproduzir"
codigo: "github.com/ArtemisHubApp/artemishub_rag"
---

# Como reproduzir

Com **Python 3.11 ou 3.12** e **uv**, os comandos abaixo reconstroem a base, o índice, as métricas e a demonstração. Os embeddings rodam localmente; só a geração precisa de `LLM_API_KEY`, `LLM_BASE_URL` e `LLM_MODEL=gemini-3.5-flash-lite` no arquivo `.env`.

```bash title="Passo a passo"
git clone https://github.com/ArtemisHubApp/artemishub_rag.git && cd artemishub_rag
uv sync --dev && cp .env.example .env
uv run python -m artemis_rag.pipeline
uv run python -m artemis_rag.eda
uv run python -m artemis_rag.evaluate
uv run python -m artemis_rag.demo
```

| Comando | O que faz | Veja |
|---|---|---|
| `artemis_rag.pipeline` | coleta, valida, gera chunks e publica o índice | [Pipeline](../rag/pipeline.md) |
| `artemis_rag.eda` | perfil das fontes e alertas de qualidade | [Pipeline](../rag/pipeline.md) |
| `artemis_rag.evaluate` | métricas de recuperação por página | [Avaliação](../avaliacao/index.md) |
| `artemis_rag.demo` | executa as cinco perguntas da demonstração | [Demonstração](../rag/demonstracao.md) |

!!! info "Integração contínua"
    O CI roda **Ruff** e **pytest** em Python 3.11 e 3.12 a cada push.
