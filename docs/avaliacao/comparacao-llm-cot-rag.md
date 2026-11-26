---
origem: "Relatório da Semana 3 · Comparação entre LLM puro, CoT e RAG"
codigo: "scripts/compare_llm_rag.py · scripts/judge_answers.py"
---

# Comparação entre LLM puro, CoT e RAG

## Introdução

O Artemis usa uma base de conhecimento para responder perguntas sobre direitos trabalhistas e desigualdade salarial com apoio de fontes. Na Semana 3, a equipe comparou três formas de usar o mesmo modelo para investigar se consultar essa base melhorava a qualidade das respostas.

No conjunto de avaliação final, o RAG obteve o maior acerto entre as respostas que emitiu e se absteve corretamente em todos os casos fora do escopo. Também deixou de responder mais perguntas que tinham resposta no gabarito. O CoT obteve a maior pontuação geral da rodada. [Relatório da Semana 3](https://docs.google.com/document/d/1Ol929wW4m7j8q1h-DLWNVaBy6ZZXf3x501Fakrfu0Tw/edit)

## Metodologia

A equipe usou 11 perguntas de desenvolvimento para ajustar os prompts e verificar o funcionamento dos scripts. A avaliação final usou um conjunto reservado, chamado *holdout*, com 60 perguntas que não foram usadas para ajustar o sistema. Dessas, 50 tinham resposta no gabarito e 10 estavam fora do escopo. O holdout reuniu dois subconjuntos, um de 19 perguntas e outro de 41.

### Configuração de cada teste

As três condições receberam as mesmas perguntas, usaram o **Gemini `gemini-3.5-flash-lite`**, temperatura **0** e a mesma frase padrão de abstenção. A diferença entre elas foi o conteúdo enviado junto com a pergunta.

| Condição | Configuração |
|---|---|
| **LLM puro** | O Gemini recebeu a pergunta e respondeu com base no próprio conhecimento, sem trechos da base do Artemis. |
| **LLM com CoT** | O Gemini recebeu a pergunta e uma instrução para raciocinar passo a passo. O script separou o texto de raciocínio da resposta final. Essa condição também foi executada sem trechos da base. |
| **RAG com LLM** | A busca híbrida, que combina busca semântica e BM25, selecionou até cinco trechos. O Gemini recebeu a pergunta e os trechos e foi orientado a citar as fontes. O validador registrou as violações de citação. |
| **Busca isolada** | Em um teste separado, a equipe executou apenas a recuperação híbrida, com trechos de 600 caracteres e avaliação no Top 5. Esse teste mediu a recuperação das evidências esperadas. |

### Como as respostas foram avaliadas

O juiz comparou cada resposta ao gabarito e atribuiu nota **1** para correta, **0,5** para parcialmente correta e **0** para incorreta. Abster-se numa pergunta respondível contou como erro. Abster-se numa pergunta fora do escopo contou como acerto. A equipe também reportou o acerto apenas entre as respostas emitidas, para mostrar como cada condição se saía quando optava por responder.

O juiz previsto era o Gemini `gemini-3.5-flash`. Após o limite da API ser atingido, as notas finais foram atribuídas pelo **Claude Opus 5.5** em sessão, sem identificação da condição. Nos 24 casos avaliados pelos dois modelos, eles concordaram em **20**. As quatro divergências foram entre resposta correta e parcialmente correta. A troca de juiz limita a reprodução da rodada original apenas pelos scripts.

## Resultados

### Comparação no holdout

| Métrica | LLM puro | LLM com CoT | RAG com LLM |
|---|---:|---:|---:|
| Acerto geral | 0,56 | **0,59** | 0,57 |
| Acerto quando responde | 0,67 | 0,63 | **0,79** |
| Respostas classificadas como incorretas | 5 | 6 | **2** |
| Abstenção indevida | 16% | **6%** | 28% |
| Abstenção correta fora do escopo | 90% | 90% | **100% (10 de 10)** |

O RAG se absteve em **14 das 50 perguntas respondíveis**. Em 10 desses 14 casos, a busca havia recuperado o documento esperado. Isso mostra que encontrar o documento certo nem sempre levou o modelo a responder. A pontuação geral deve ser lida junto com a taxa de abstenção para entender esse efeito.

### Recuperação e fidelidade

- **Recuperação.** No teste de busca isolada, o Recall@5 foi **0,875** no holdout v1 e **0,810** no holdout v2. Essa métrica mede a recuperação dos documentos esperados entre os cinco primeiros trechos.
- **Fidelidade.** A avaliação verificou se as afirmações das respostas do RAG eram sustentadas pelos trechos recuperados. Considerando desenvolvimento e holdout juntos, **42 das 43 respostas emitidas** foram totalmente fiéis, com média de **0,988** entre as respostas emitidas. A média de **0,993** sobre as **71 perguntas** inclui as abstenções, que receberam nota 1,0 nesse cálculo.

## Interpretação e limites

A equipe manteve o RAG no Artemis pelo desempenho entre as respostas emitidas e pela abstenção correta nos casos fora do escopo. O acerto geral do RAG ficou próximo ao das outras condições. O principal ponto de melhoria observado foi reduzir as abstenções indevidas sem perder fidelidade às fontes.

Os números correspondem à **rodada histórica da Semana 3**. Os scripts, o gabarito e os resultados consolidados estão documentados. Os registros individuais de respostas e notas ainda precisam ser recuperados para recalcular as métricas daquela execução e conferir a correspondência entre as avaliações de acerto e fidelidade.
