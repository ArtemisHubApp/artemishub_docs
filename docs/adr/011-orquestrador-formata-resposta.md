---
origem: "Protótipo multiagente da semana 4 (artemishub_agents#27) · sugestão do professor em 19/11"
---

# ADR-011: o orquestrador formata a resposta final, sem agente de Comunicação

- **Status:** aceito (sugestão do professor, adotada pela equipe em 19/11/2026)
- **Data:** 19/11/2026
- **Issues:** [artemishub_agents#27](https://github.com/ArtemisHubApp/artemishub_agents/issues/27), [artemishub_agents#32](https://github.com/ArtemisHubApp/artemishub_agents/issues/32), [artemishub_docs#31](https://github.com/ArtemisHubApp/artemishub_docs/issues/31)

## Contexto

O desenho do primeiro protótipo tinha quatro especialistas: Pesquisa (Research), Análise (Analysis), Validação (Validation) e Comunicação (Communication). A Comunicação reescreveria o texto aprovado pela Validação em linguagem simples.

Isso custava uma chamada a mais ao LLM por pergunta. Também criava um risco: qualquer reescrita depois da Validação pode mudar um número ou uma citação já conferidos. O enunciado pede no mínimo dois agentes especializados.

## Decisão

Tirar o agente de Comunicação. O **Orquestrador** monta a resposta final por um template determinístico, sem LLM:

- o texto aprovado pela Validação, sem nenhuma alteração;
- a seção "Limites dos dados", com os avisos da consulta salarial;
- a seção "Fontes", com cada `[FONTE N]` citada (título, artigo, página e URL) e a RAIS.

A linguagem simples e acolhedora passa a ser regra do prompt da Análise, que é a única chamada ao LLM por pergunta (duas, se a Validação reprovar).

O fluxo implementado fica assim: Orquestrador (guardrail e intenção, em código) → Pesquisa ∥ Análise (dados) → Análise (síntese) → Validação → resposta formatada pelo Orquestrador. Ficam três especialistas, acima do mínimo do enunciado.

## Alternativas

- **Manter a Comunicação com LLM:** texto mais adaptado, mas com mais uma chamada (custo e latência; a meta do PDR é de até 10 s) e com o risco de mudar números depois da Validação. Seria preciso validar de novo.
- **Comunicação sem LLM, como agente próprio:** só renomeia o template. Mais um nó sem decisão própria não acrescenta nada.

## Consequências

- Uma chamada ao LLM por pergunta, e números e citações garantidos iguais aos validados.
- O texto final só fica tão simples quanto o prompt da Análise. Se a avaliação com usuárias (semana 7) mostrar que falta clareza, uma reescrita volta a ser opção, desde que validada de novo.
- A issue artemishub_agents#32 foi fechada como "não será feito".

## Fontes

- [Arquitetura multiagente](../arquitetura/multiagentes.md)
- [`docs/multiagentes.md` no artemishub_agents](https://github.com/ArtemisHubApp/artemishub_agents/blob/main/docs/multiagentes.md)
