---
origem: "Cronograma Artemis Hub (semanas 4 a 7) · inspeção dos repositórios em 19/11/2026"
---

# Roadmap

Este roadmap distingue **implementação comprovada**, **arquitetura documentada** e **trabalho planejado**. A data individual de uma atividade não deve ser confundida com a data do milestone semanal.

## Situação por frente

| Frente | Evidência observada | Estado em 19/11/2026 |
|---|---|---|
| Base de conhecimento RAG | Pipeline, ChromaDB, busca híbrida, avaliação de recuperação e testes em `artemishub_rag` | Implementado e avaliado |
| Comparação LLM × LLM+CoT × RAG | Script reproduzível e testes; relatório consolidado ainda não publicado no Pages | Experimento a consolidar |
| Dataset RAIS STEM 2025 | Pipeline regional/nacional, Parquet versionado por DVC e dicionário de dados | Implementado |
| Consulta salarial descritiva | Tabelas agregadas e `src.salarios` com P25/P50/P75, corte mínimo de 30 vínculos e avisos | Implementado |
| Modelo preditivo e equidade | Issues e arquitetura proposta; sem modelo treinado ou relatório de métricas verificados na `main` | Planejado |
| Arquitetura multiagente | ADR e desenho de nós/fluxo; código do grafo não localizado na `main` consultada | Arquitetura proposta; implementação pendente |
| Multimodalidade (CV, imagens e áudio) | Atividades e especificações no cronograma; fluxo integrado não comprovado | Em desenvolvimento |
| Backend e frontend integrados | Repositórios separados e issues de integração; fluxo ponta a ponta não verificado | Integração pendente de evidência |
| Testes, refinamento e entrega | Atividades previstas até 11/12/2026 | Planejado |

## Datas individuais do cronograma

As datas abaixo vêm do campo `data` de cada atividade, não do encerramento de cada semana.

| Atividades | Data |
|---|---|
| 1–11 | 17/11/2026 |
| 12–22 | 19/11/2026 |
| 23–28 | 20/11/2026 |
| 29–31 | 24/11/2026 |
| 32–36 | 26/11/2026 |
| 37–38 | 27/11/2026 |
| 39–42 | 01/12/2026 |
| 43–45 | 03/12/2026 |
| 46–47 | 04/12/2026 |
| 48–50 | 08/12/2026 |
| 51–53 | 10/12/2026 |
| 54 | 11/12/2026 |

## Marcos semanais

| Semana | Entrega prevista | Data do marco |
|---|---|---|
| 4 | Primeiro Protótipo Multiagente | 20/11/2026 |
| 5 | Multimodalidade | 27/11/2026 |
| 6 | Integração completa | 04/12/2026 |
| 7 | Testes e refinamento | 11/12/2026 |

## O que ainda precisa ser documentado

- Resultados consolidados da comparação LLM puro × CoT × RAG, separados por desenvolvimento e holdout, com modelo, abstenções, erros técnicos e rubrica de fidelidade.
- Implementação real do grafo multiagente, contratos dos nós, testes por agente e execução reproduzível da demonstração.
- Modelo salarial treinado: baseline, divisão temporal, métricas MAE/MAPE/R², cobertura e métricas por grupos; registrar também a escolha do grupo de referência.
- Avaliação de equidade e limitações estatísticas do modelo salarial.
- Contratos de API, autenticação, persistência, streaming e integração frontend/backend/agentes.
- Fluxos multimodais individualizados: extração de currículo, interpretação de gráficos/imagens, áudio e medidas de privacidade.
- Testes ponta a ponta, resultados de validação com usuárias, limitações conhecidas, implantação e roteiro de demonstração.

## Repositórios

- [Documentação e GitHub Pages](https://github.com/ArtemisHubApp/artemishub_docs)
- [Agentes, RAIS e ferramentas de dados](https://github.com/ArtemisHubApp/artemishub_agents)
- [Base de conhecimento RAG](https://github.com/ArtemisHubApp/artemishub_rag)
- [Backend](https://github.com/ArtemisHubApp/artemishub_backend)
- [Frontend](https://github.com/ArtemisHubApp/artemishub_frontend)
