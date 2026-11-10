---
origem: "Grupo 11 - Second Challenge - RAG (Relatório de Projeto, Semana 2) · seção Avaliação"
codigo: "src/evaluate.py · evaluation/ · docs/validation_report.md"
---

# Avaliação

Com 20 fontes, a página certa aparece entre os 5 primeiros trechos em **93,75%** das perguntas originais e **84,38%** do holdout, **acima da meta de 80%** definida no PDR. A ampliação de 5 para 20 fontes **piorou a posição da página certa no ranking (MRR)**, e essa perda está medida e explicada abaixo.

<div class="art-metrics" markdown>
<div class="art-metric"><strong>93,75%</strong><span>Recall@5, originais (gabarito v2)</span></div>
<div class="art-metric"><strong>84,38%</strong><span>Recall@5, holdout (gabarito v2)</span></div>
<div class="art-metric"><strong>0,734</strong><span>MRR@5, originais (gabarito v2)</span></div>
<div class="art-metric"><strong>≥ 80%</strong><span>meta de Recall@5 no PDR</span></div>
</div>

## Como medimos

São **dois conjuntos de 16 perguntas** com gabarito de documento e página: o **original**, usado no desenvolvimento, e o **holdout**, nunca usado para ajustar nada. As métricas são por página, no top 5 (`python -m src.evaluate`).

## Métricas de recuperação por página (top 5)

| Métrica | 5 fontes | 20 fontes, gabarito v1 | 20 fontes, gabarito v2 |
|---|--:|--:|--:|
| Recall@5, originais | 100% | 87,5% | 93,75% |
| MRR@5, originais | 0,802 | 0,708 | 0,734 |
| Recall@5, holdout | 93,75% | 78,13% | 84,38% |
| MRR@5, holdout | 0,773 | 0,447 | 0,509 |


## Como ler os números

**Gabarito v2**
:   O gabarito original foi escrito para 5 fontes e marcava uma única página como certa. Com as fontes novas, outra página pode responder igualmente bem (por exemplo, a Orientação Técnica SIT 11/2024 na pergunta da multa). Uma revisão com regra fixa, decidida antes de olhar os resultados e aprovada pelo grupo pergunta a pergunta, acrescentou 9 evidências; o v1 continua sendo a comparação oficial.

**Leitura**
:   Cerca de um quarto da queda de MRR nas perguntas originais era da régua (o v2 recupera), e três quartos são perda real de recuperação, porque fontes do mesmo tema disputam o top 5. Quem mais ocupa vagas indevidas é o Guia de Negociação Coletiva, não o INEP, apesar do volume deste.

**Context Precision@5**
:   A avaliação também mede quantos dos 5 trechos vêm de fonte relevante e qual documento mais invade o top 5.

**Fidelidade**
:   Na demonstração, todas as afirmações exibidas foram conferidas manualmente contra os trechos; nenhuma estava sem sustentação, e houve uma citação na página vizinha.

## Para ir mais fundo

<div class="grid cards" markdown>

- :material-alert-circle-outline: **[Limitações e próximos passos](limitacoes.md)**

    O que ainda não funciona bem e o que vem a seguir.

- :material-file-chart-outline: **[Relatório de validação](relatorio-de-validacao.md)**

    A revisão pré-PR completa, com todos os experimentos.

- :material-play-circle-outline: **[Relatório da demonstração](relatorio-da-demonstracao.md)**

    Os trechos e respostas das cinco perguntas.

</div>
