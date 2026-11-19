---
origem: "Arquitetura multiagente do Artemis (Challenge 2, semana 4) · ADR-002"
codigo: "github.com/ArtemisHubApp/artemishub_agents"
---

# Arquitetura multiagente

Esta página descreve a **arquitetura-alvo** proposta no ADR-002, não um sistema multiagente já executável.

!!! warning "Estado da implementação em 19/11/2026"
    A branch main de `artemishub_agents` contém o dataset RAIS STEM 2025, tabelas agregadas, ferramenta de consulta salarial, configuração com uv/Ruff/pytest e workflow de CI. Não foi localizado o pacote de agentes/grafo nem um executor de demonstração correspondente. Assim, Guardrail, Supervisor, Research, Analysis, Validation e Communication permanecem como desenho/escopo até que código, testes e execução reproduzível sejam incorporados.

    O ADR-002 registra a escolha técnica de LangGraph e Langfuse, mas ainda aparece como **proposto** e aguardando aprovação. Não tratar a decisão como formalmente concluída antes dessa aprovação.

A arquitetura proposta prevê integração com `artemishub_rag`, dados da RAIS, backend/frontend e observabilidade via Langfuse. O fluxo ponta a ponta ainda precisa ser comprovado nos repositórios.

!!! info "O que entra na demonstração de 20/11"
    Guardrail, Supervisor, **Salarial** (Analysis), **Direitos** (Research), **Validação** (Validation) e **Comunicação** (Communication). Perfil, Oportunidades, Plano e Negociação entram nas próximas semanas.

## Diagrama da arquitetura-alvo

```mermaid
flowchart TB
    U([Usuária]) --> FE[artemishub_frontend<br/>React · Oráculo e telas]
    FE -- HTTPS · JWT --> BE[artemishub_backend<br/>FastAPI · abre o trace]

    subgraph GRAFO["artemishub_agents · LangGraph"]
        G[Guardrail de entrada<br/>injeção · PII · escopo] --> S[Supervisor<br/>intenção em JSON<br/>rota em código]
        S --> SAL[Salarial<br/>Analysis]
        S --> DIR[Direitos<br/>Research]
        SAL --> VAL[Validação<br/>Validation]
        DIR --> VAL
        VAL -- ok --> COM[Comunicação<br/>Communication]
        VAL -. falhou: refaz 1x .-> S
    end

    BE --> G
    COM -- resposta via SSE --> BE
    SAL --> RAIS[(RAIS STEM 2025<br/>medianas)]
    DIR --> RAG[(artemishub_rag<br/>Chroma + BM25)]
    GRAFO --> LLM[(Gemini<br/>API compatível OpenAI)]
    GRAFO -. traces .-> LF[[Langfuse]]
```

O diagrama é uma referência de integração, não um diagrama de componentes atualmente executáveis. A consulta salarial que pode ser executada hoje está descrita em [Modelo salarial](modelo-salarial.md) e [Guia de reprodução dos agentes](../guias/reproduzir-agentes.md).

## Responsabilidades dos agentes

| Agente | Requisitos | Tela | Ferramentas | Usa LLM para |
|---|---|---|---|---|
| **Guardrail** · 20/11 | RNF-07, RNF-16, métrica de segurança | todas | regras + classificador pequeno | classificar injeção e escopo |
| **Supervisor / Oráculo** · 20/11 | RNF-15 | Oráculo | nenhuma | extrair a intenção em JSON; a rota é um `if` |
| Perfil | RF-02 a RF-05 | Dashboard | parser de CV, perfil | extrair competências com trecho de evidência |
| **Salarial** (Analysis Agent) · 20/11 | RF-06 a RF-08 | Salário | `src.salarios.consultar` (medianas da RAIS 2025); modelo salarial depois | explicar a faixa; nunca calcular números |
| **Direitos** (Research Agent) · 20/11 | RNF-12, RNF-13 | Oráculo | RAG atual (`Retriever`) | responder com citações validadas |
| Oportunidades | RF-10 a RF-13 | Network, Guild | catálogo e filtros | justificar a compatibilidade |
| Plano de carreira | RF-14 a RF-17 | Dashboard | perfil, catálogo, plano | propor ações a partir das lacunas |
| Negociação | RF-09 | Salário | faixa do agente Salarial | fazer o papel do recrutador e dar feedback |
| **Validação** (Validation Agent) · 20/11 | RNF-12 a RNF-15 | todas | validação de citações e juiz do `artemishub_rag` | checar se a resposta segue as evidências; reprovar e devolver 1x |
| **Comunicação** (Communication Agent) · 20/11 | RNF-13, métrica 10.5 | todas | nenhuma | reescrever em linguagem simples sem perder citações |

## Fluxo multiagente pretendido: "Estou ganhando o justo?"

Os quatro papéis do enunciado (Research, Analysis, Validation e Communication) colaboram numa pergunta. Nesta versão o cargo, a UF e o salário vêm da própria pergunta; o agente Perfil entra depois.

```mermaid
sequenceDiagram
    autonumber
    participant U as Usuária (Oráculo)
    participant G as Guardrail
    participant S as Supervisor
    participant SA as Salarial (Analysis)
    participant D as Direitos (Research)
    participant V as Validação
    participant C as Comunicação
    U->>G: "Sou analista de sistemas em SP e ganho R$ 7.500. Está justo?"
    G->>S: texto limpo + flags
    S->>S: intenção = comparar_salario, extrai cargo, UF e salário
    par em paralelo
        S->>SA: consultar(família CBO 2124, SP, 7500)
        SA-->>S: mediana, P25–P75 e diferença bruta M/H (RAIS 2025)
    and
        S->>D: buscar("igualdade salarial mesma função")
        D-->>S: trechos com citação (Lei 14.611, CLT art. 461)
    end
    S->>V: achados + números + citações
    alt reprovado
        V-->>S: falta fonte ou aviso de diferença bruta, refaz 1x
    end
    V->>C: rascunho aprovado
    C-->>U: posição frente à mediana, limites dos dados, direitos e próximo passo
```

### Como os agentes colaboram

1. **Guardrail** limpa o texto, marca PII e recusa pedidos fora de escopo ou com tentativa de injeção.
2. **Supervisor** devolve só um JSON de intenção, validado por schema. Uma função Python escolhe os agentes.
3. **Salarial** e **Direitos** rodam em paralelo (`Send()`). Cada um escreve só no seu campo do estado: números com fonte, e trechos com citação.
4. **Validação** confere se toda afirmação tem fonte e se as limitações aparecem (emprego formal, diferença bruta). Se reprovar, devolve uma vez; na segunda falha, o sistema se abstém.
5. **Comunicação** separa fato verificado de sugestão, usa linguagem simples e lista as fontes no fim.

## Segurança: nenhum agente obedece texto externo

<div class="grid cards" markdown>

-   **Roteamento em código**

    O LLM do supervisor só devolve um JSON de intenção validado por schema. Quem escolhe o próximo nó é uma função Python.

-   **Conteúdo como dado**

    CV, documentos do RAG e mensagens vão em campos delimitados e marcados como não confiáveis, como o prompt atual do RAG já faz.

-   **Agentes não conversam entre si**

    Cada agente escreve só no seu campo do estado. Nenhum agente recebe a saída livre de outro como instrução.

-   **Tools sem efeito colateral**

    No MVP as ferramentas só leem. Salvar oportunidade ou atualizar plano passa pela API com confirmação da usuária.

</div>

## Observabilidade com Langfuse

| Recurso | Uso no Artemis |
|---|---|
| Traces | 1 trace por pergunta, 1 span por nó, tool e chamada de LLM |
| Sessões | `session = thread_id`, `user = id pseudonimizado` |
| Prompts versionados | um prompt por agente, rótulo `production` |
| Scores | faithfulness (LLM juiz), citação válida (regra), feedback da usuária |
| Datasets | `evaluation/*.jsonl` + cenários de injeção, rodados no CI |
| Latência e custo | alerta se p95 > 10 s (meta do PDR 10.3) |
| Equidade | scores por recorte agregado (RNF-14) |
| Privacidade | `mask()` remove PII antes de enviar (RNF-16) |

```python
from langfuse import get_client
from langfuse.langchain import CallbackHandler
from langgraph.graph import StateGraph, START, END

graph = StateGraph(ArtemisState)
graph.add_node("guardrail", guardrail_node)
graph.add_node("supervisor", supervisor_node)
graph.add_node("salarial", salary_agent)      # chama a consulta salarial via porta
graph.add_node("direitos", rights_agent)      # chama src.query.Retriever
graph.add_node("validacao", validation_node)
graph.add_node("comunicacao", communication_node)
graph.add_edge(START, "guardrail")
graph.add_conditional_edges("guardrail", block_or_continue)
graph.add_conditional_edges("supervisor", route_by_intent)  # Send() para cada agente
app = graph.compile(checkpointer=postgres_saver)

langfuse = get_client()   # LANGFUSE_PUBLIC_KEY / SECRET_KEY / HOST no .env
handler = CallbackHandler()

result = app.invoke(
    {"message": texto},
    config={
        "callbacks": [handler],
        "configurable": {"thread_id": conversa_id},
        "metadata": {"langfuse_session_id": conversa_id,
                     "langfuse_user_id": user_hash,
                     "langfuse_tags": ["oraculo", "mvp"]},
    },
)
```

O nó de Direitos reaproveita o `Retriever` e a validação de citações de `src/query.py` sem mudar o RAG.

## Próximas etapas de implementação

1. Implementar o grafo e os nós com testes isolados.
2. Integrar a ferramenta salarial existente e o Retriever do RAG por contratos explícitos.
3. Criar executor de demonstração e registrar uma execução real com entradas, saídas, citações e limitações.
4. Instrumentar o grafo com Langfuse e validar mascaramento de dados pessoais.
5. Expor a orquestração como API e validar o contrato com backend/frontend.
6. Atualizar o status desta página somente após existir código, testes e demonstração reproduzível.
