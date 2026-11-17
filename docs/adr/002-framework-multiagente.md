---
origem: "Arquitetura multiagente do Artemis (Challenge 2) · comparação de frameworks"
---

# ADR-002: framework do sistema multiagente

- **Status:** proposto (aguardando aprovação do time)
- **Data:** 17/11/2026
- **Issues:** [artemishub_agents#26](https://github.com/ArtemisHubApp/artemishub_agents/issues/26), [artemishub_agents#7](https://github.com/ArtemisHubApp/artemishub_agents/issues/7)

## Contexto

O PDR pede um fluxo verificável (perfil → estimativa → evidências → orientação, com 90% de conclusão) e que **nenhum agente execute instrução vinda do texto da usuária ou de documentos**. Os dois pedem roteamento em código e estado tipado. Avaliamos Agno (2.x), CrewAI e LangGraph contra os requisitos RF-01 a RF-17 e RNF-11 a RNF-16.

## Decisão

Usar **LangGraph** para orquestrar os agentes, **Langfuse** para observabilidade e **Gemini** pelo endpoint compatível com OpenAI que o projeto já usa (o provedor continua configurável).

- Cada agente é um nó Python testável com pytest, sem LLM nos testes.
- O simulador de negociação (RF-09) será um subgrafo multi-turno com `interrupt` e checkpointer em Postgres.
- Langfuse tem integração nativa (`CallbackHandler`): um trace por pergunta, um span por nó, tool e chamada de LLM.

## Comparação

| Critério | LangGraph | Agno (2.x) | CrewAI |
|---|---|---|---|
| Fluxo determinístico (métrica 10.3: ≥ 90% de conclusão) | **Alto**: grafo explícito com arestas condicionais | Médio: Workflows cobrem passos fixos; Teams roteiam por LLM | Médio: delegação por LLM |
| Isolamento contra injeção | **Alto**: agentes só leem campos tipados; roteamento fora do LLM | Médio: o líder do time repassa texto aos membros | Baixo: agentes delegam tarefas em linguagem natural |
| Langfuse | **Nativo**: `langfuse.langchain.CallbackHandler` | Bom: OpenInference + OTLP | Médio: via OpenInference/OpenLit |
| Conversa multi-turno com pausa (RF-09) | **Alto**: `interrupt` + checkpointer | Alto: sessões prontas | Baixo: pensado para tarefas |
| Memória e persistência (RF-15 a 17) | Médio: checkpointer Postgres; perfil e plano no nosso banco | Alto: storage e memória embutidos | Médio: pouco transparente |
| Velocidade para o MVP | Médio: mais código de grafo | Alto | Alto |
| Testes e encaixe no repo (RNF-10) | **Alto**: nós são funções | Médio: objetos com estado interno | Baixo: depende de prompts de papel |
| Estabilidade da API | **Alto**: 1.x estável | Médio: mudança grande de v1 para v2 | Médio: mudanças frequentes |

## Alternativas

- **Agno:** faria sentido se o prazo de 7 semanas apertar. Sobe um time de agentes com memória, sessões e API (AgentOS) com bem menos código. O custo é menos controle: no modo de time, o líder decide por LLM para quem passar a mensagem, o que dificulta provar a meta de segurança. Se for adotado, usar a documentação 2.x (docs.agno.com), não a v1.
- **CrewAI:** não recomendado. A colaboração por papéis e delegação em linguagem natural é o oposto do isolamento que a meta de segurança exige, e chat multi-turno não é o ponto forte.

## Consequências

- Mais código de grafo para escrever do que com Agno ou CrewAI.
- O roteamento fica auditável e testável sem LLM.
- A arquitetura resultante está em [Arquitetura multiagente](../arquitetura/multiagentes.md).

## Fontes

- [Agno: Langfuse via OpenInference (Team)](https://docs.agno.com/examples/integrations/observability/teams/langfuse-via-openinference-team)
- [Langfuse: integração Agno](https://langfuse.com/docs/integrations/other/agno-agents)
- [Agno: Team Modes na 2.5](https://www.agno.com/blog/community-roundup-february-2026)
- [LangGraph vs CrewAI vs Agno (2026)](https://www.agenticwire.news/article/langgraph-crewai-agno-frameworks)
- [LangGraph vs CrewAI 2026](https://www.kunalganglani.com/blog/langgraph-vs-crewai.md)
