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

## Protótipo multiagente

Com Git, Python 3.12 ou superior e uv, clone o repositório dos agentes ao lado do clone do RAG e rode, a partir de `artemishub_agents`:

```bash
uv run python -m src.agentes.demo
uv run python -m src.agentes.chat
```

A demonstração executa uma pergunta de exemplo e mostra as etapas do grafo. O chat aceita perguntas no terminal. Para testar perguntas sobre direitos, prepare o índice do RAG com o comando de pipeline acima. Se o RAG estiver em outro diretório, aponte `ARTEMIS_RAG_DIR` para ele. Configure as variáveis do LLM para usar a síntese gerada pelo modelo. Sem essa configuração, o protótipo usa um rascunho padrão.

Confira a UF e a família ocupacional usadas nas estatísticas salariais e abra as fontes citadas nas respostas sobre direitos. Se o protótipo se abstiver, leia o motivo exibido antes de reformular a pergunta. Veja o [fluxo multiagente](../arquitetura/multiagentes.md) e os [limites dos dados salariais](../arquitetura/consulta-salarial.md#como-interpretar).

!!! info "Integração contínua"
    O CI roda **Ruff** e **pytest** em Python 3.11 e 3.12 a cada push.
