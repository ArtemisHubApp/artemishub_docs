---
origem: "Grupo 11 - Second Challenge - RAG (Relatório de Projeto, Semana 2) · seção Estratégia de embeddings e banco vetorial"
codigo: "src/index.py · src/lexical.py"
---

# Embeddings e banco vetorial

Os vetores são gerados **localmente, sem custo de API**, com o modelo multilíngue `paraphrase-multilingual-MiniLM-L12-v2`, e ficam num **ChromaDB persistente**. Como esse modelo pequeno erra siglas e termos raros (por exemplo, "eSocial" e "CTEM"), a busca combina os vetores com **BM25**.

## Decisões

| Decisão | Escolha | Motivo |
|---|---|---|
| Modelo | `paraphrase-multilingual-MiniLM-L12-v2` | entende português, roda em CPU, gratuito |
| Dimensão | 384 | vetores pequenos, busca rápida |
| Normalização | L2 | permite similaridade de cosseno |
| Banco vetorial | ChromaDB persistente, índice HNSW, cosseno | reaberto do disco sem recalcular nada |
| Versionamento | uma coleção nova por publicação e ponteiro do índice ativo | reconstruir a base não interrompe as consultas |
| Consistência | o índice registra modelo e revisão; a consulta recusa outro modelo | nunca compara vetores de espaços diferentes |
| Reuso | chunk com mesmo identificador e hash reaproveita o vetor | só o que mudou é recalculado |
| Busca léxica | BM25 (k1 = 1,5; b = 0,75) e fusão RRF | recupera termos exatos que o modelo pequeno perde |

## Um limite a registrar

O modelo lê **até 128 tokens**, e um chunk de 600 caracteres em português pode passar disso. Nesse caso, o final do chunk não entra no vetor, embora o texto inteiro continue indo para o LLM. O próximo passo é medir quantos chunks passam do limite antes de mudar tamanho ou modelo (veja [Limitações](../avaliacao/limitacoes.md)).
