---
origem: "Grupo 11 - Second Challenge - RAG (Relatório de Projeto, Semana 2)"
codigo: "github.com/ArtemisHubApp/artemishub_rag"
---

# Base de conhecimento (RAG)

O RAG Artemis responde perguntas sobre **igualdade salarial, direitos trabalhistas e carreira de mulheres em STEM** a partir de **20 documentos-fonte oficiais**, e toda resposta exibida cita o trecho e a página de onde veio.

A busca é **híbrida** (vetorial e BM25) sobre **1.209 chunks** indexados no ChromaDB, e a geração usa o Gemini com **validação automática das citações**. O código, os dados de avaliação e a documentação estão no repositório [ArtemisHubApp/artemishub_rag](https://github.com/ArtemisHubApp/artemishub_rag).

<div class="art-metrics" markdown>
<div class="art-metric"><strong>20</strong><span>fontes oficiais ativas</span></div>
<div class="art-metric"><strong>245</strong><span>seções (uma por página de PDF ou HTML)</span></div>
<div class="art-metric"><strong>1.209</strong><span>chunks indexados</span></div>
<div class="art-metric"><strong>93,75%</strong><span>Recall@5, perguntas originais (gabarito v2)</span></div>
<div class="art-metric"><strong>84,38%</strong><span>Recall@5, holdout (gabarito v2)</span></div>
</div>

## Da pergunta à resposta citada

```mermaid
flowchart LR
    Q([Pergunta]) --> H[Busca híbrida<br/>vetorial top 20 + BM25 top 20]
    H --> F[Fusão RRF<br/>páginas distintas]
    F --> G[Geração<br/>Gemini · temperatura 0]
    G --> V{Validação<br/>das citações}
    V -->|todo parágrafo cita<br/>fonte recuperada| R([Resposta citada<br/>URL + página])
    V -->|sem evidência| A([Abstenção])
```

Sem evidência, o sistema responde: *"Não encontrei evidência suficiente na base para responder."*

## Artefatos relacionados ao RAG

A tabela abaixo reúne os artefatos do RAG, com links para suas páginas nesta documentação e os arquivos correspondentes no repositório.

| Artefato | Página | No repositório |
|---|---|---|
| Base de conhecimento e fontes documentais | [Fontes](fontes.md) | `config/sources.json`, `docs/base_de_conhecimento.md` |
| Pipeline de ingestão de dados | [Pipeline de ingestão](pipeline.md) | `src/pipeline.py`, `src/ingest.py`, `src/quality.py` |
| Estratégia de chunking | [Chunking](chunking.md) | `src/prepare.py` |
| Estratégia de embeddings | [Embeddings e banco vetorial](embeddings.md) | `src/index.py` |
| Banco vetorial | [Embeddings e banco vetorial](embeddings.md) | `src/index.py`, `.chroma/` (gerado) |
| Consulta com recuperação | [Consulta e resposta](consulta.md) | `src/query.py`, `src/lexical.py` |
| Resposta fundamentada e evidência das fontes | [Consulta e resposta](consulta.md) · [Demonstração](demonstracao.md) | `src/query.py`, `src/demo.py`, `reports/demo_rag.md` (anexo) |
| Diagrama de arquitetura | [Arquitetura do RAG](../arquitetura/rag.md) | `docs/architecture.md` |
| Avaliação da recuperação | [Avaliação](../avaliacao/index.md) | `src/evaluate.py`, `evaluation/`, `docs/validation_report.md` |
