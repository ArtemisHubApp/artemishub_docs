---
origem: "scripts/compare_llm_rag.py · scripts/judge_answers.py · issue #8 de artemishub_rag"
codigo: "github.com/ArtemisHubApp/artemishub_rag"
---

# Comparação: LLM, LLM + CoT e RAG

O repositório `artemishub_rag` contém um experimento reproduzível para comparar três condições de resposta à mesma pergunta: LLM sem documentos, LLM com solicitação de raciocínio passo a passo (CoT) e LLM com contexto recuperado pelo RAG.

> **Status da documentação:** o script e os testes automatizados estão versionados. Os resultados consolidados da execução e a análise comparativa ainda precisam ser publicados nesta documentação. A existência do script, por si só, não comprova que o RAG superou as outras condições.

## Condições comparadas

| Condição | Contexto enviado ao modelo | O que permite observar |
|---|---|---|
| `llm_puro` | Pergunta, sem documentos | Resposta baseada no conhecimento geral do modelo |
| `llm_cot` | Pergunta e instrução para raciocinar passo a passo | Efeito da instrução de raciocínio sem evidências externas |
| `rag` | Pergunta e os cinco trechos recuperados | Resposta fundamentada na base, com validação de citações |

O mesmo modelo configurado no ambiente é usado nas três condições. A comparação registra o identificador do modelo e a data da execução.

## Conjuntos de perguntas

O script lê dois conjuntos versionados:

- **Desenvolvimento:** perguntas marcadas como `evaluation_group: "development"` em `evaluation/questions.jsonl`.
- **Holdout:** perguntas de `evaluation/questions_holdout.jsonl`, reservadas para avaliação final e que não devem ser usadas para ajustar a recuperação ou os prompts.

O parâmetro `--conjunto todos` executa os dois conjuntos. O holdout deve permanecer separado durante qualquer ciclo de experimentação.

## Execução

No repositório `artemishub_rag`, instale as dependências, configure o provedor de LLM no `.env` e gere o índice seguindo o [guia de reprodução](../guias/reproduzir.md). Use saídas distintas para obter um resumo por conjunto, pois o juiz agrega as notas por condição dentro de cada arquivo.

```bash
uv run python -m scripts.compare_llm_rag --conjunto desenvolvimento --saida reports/respostas-desenvolvimento.jsonl
uv run python -m scripts.compare_llm_rag --conjunto holdout --saida reports/respostas-holdout.jsonl
uv run python -m scripts.judge_answers --respostas reports/respostas-desenvolvimento.jsonl --saida reports/notas-desenvolvimento.jsonl
uv run python -m scripts.judge_answers --respostas reports/respostas-holdout.jsonl --saida reports/notas-holdout.jsonl
```

Para uma execução reduzida de teste:

```bash
uv run python -m scripts.compare_llm_rag --conjunto desenvolvimento --limite 3 --saida reports/respostas-teste.jsonl
```

É possível selecionar condições específicas com `--condicoes llm_puro rag` e definir outro arquivo de saída com `--saida caminho/arquivo.jsonl`.

## Dados registrados

O resultado padrão é `reports/respostas_comparacao.jsonl`. Cada linha registra:

- id da pergunta e conjunto de avaliação;
- condição comparada;
- pergunta e resposta;
- raciocínio separado, quando a condição é CoT;
- indicação de abstenção e erro;
- modelo e data;
- trechos recuperados pelo RAG, com identificador, documento, página e texto.

A execução grava linha a linha e pode ser retomada: respostas já concluídas são ignoradas, enquanto falhas temporárias de rede podem ser refeitas. Ao final, o arquivo é compactado para manter a resposta mais recente de cada pergunta e condição.

Se o validador de citações rejeitar uma resposta RAG, o texto bruto e o motivo da rejeição são preservados para análise; isso não deve ser contabilizado como uma resposta validada.

## O que o juiz mede

O juiz compara cada resposta com o gabarito versionado e registra nota, veredito e justificativa. As abstenções são classificadas conforme o comportamento esperado da pergunta. Defina `JUDGE_MODEL` no ambiente para usar um juiz diferente do modelo avaliado. Se a variável estiver ausente, o script usa `LLM_MODEL`.

| Métrica do resumo | Interpretação |
|---|---|
| `acuracia` | Média da nota do conteúdo bruto nas perguntas respondíveis com nota |
| `acuracia_com_validador` | Mesma média, atribuindo zero às respostas bloqueadas por citação |
| `abstencao_indevida` | Proporção de abstenções nas perguntas respondíveis com nota |
| `abstencao_correta` | Proporção de abstenções nas perguntas fora de escopo com nota |
| `citacao_invalida` | Proporção de respostas barradas por citação entre as linhas com nota |

Falhas técnicas sem nota ficam no JSONL, fora do resumo. Conte essas falhas ao informar a cobertura do experimento. O juiz mede acerto frente ao gabarito. A fidelidade aos trechos recuperados exige conferência das afirmações e de suas fontes.

## Como analisar e publicar os resultados

A publicação final deve conter, no mínimo:

1. versão e identificador exato do modelo utilizado;
2. quantidade de perguntas respondidas em cada conjunto e condição;
3. taxa de abstenção e taxa de erros técnicos, separadas;
4. avaliação de acerto/fidelidade com rubrica comum às três condições;
5. análise de respostas sem evidência, números incorretos e citações inválidas;
6. resultados separados para desenvolvimento e holdout;
7. limitações do tamanho dos conjuntos e da variabilidade do modelo.

**Não misture falha técnica, abstenção e resposta incorreta.** Uma resposta bloqueada pelo validador é diferente de uma resposta que afirma algo falso. Da mesma forma, o fato de o RAG recuperar trechos relevantes (Recall@5) não prova, sozinho, que a resposta gerada é correta ou melhor.

## Referências de implementação

- Script: [`scripts/compare_llm_rag.py`](https://github.com/ArtemisHubApp/artemishub_rag/blob/main/scripts/compare_llm_rag.py)
- Juiz: [`scripts/judge_answers.py`](https://github.com/ArtemisHubApp/artemishub_rag/blob/main/scripts/judge_answers.py)
- Testes: [`tests/test_compare_llm_rag.py`](https://github.com/ArtemisHubApp/artemishub_rag/blob/main/tests/test_compare_llm_rag.py)
- Perguntas de desenvolvimento: [`evaluation/questions.jsonl`](https://github.com/ArtemisHubApp/artemishub_rag/blob/main/evaluation/questions.jsonl)
- Holdout: [`evaluation/questions_holdout.jsonl`](https://github.com/ArtemisHubApp/artemishub_rag/blob/main/evaluation/questions_holdout.jsonl)
- Repositório: [`artemishub_rag`](https://github.com/ArtemisHubApp/artemishub_rag)
