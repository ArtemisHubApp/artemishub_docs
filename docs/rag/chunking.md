---
origem: "Grupo 11 - Second Challenge - RAG (Relatório de Projeto, Semana 2) · seção Estratégia de chunking"
codigo: "src/prepare.py"
---

# Chunking

Cada página é dividida em chunks de **até 600 caracteres com 100 de sobreposição**, cortando de preferência num ponto final ou quebra de linha. Nenhum chunk mistura páginas ou fontes, então **toda citação aponta para uma página exata**.

<div class="art-metrics" markdown>
<div class="art-metric"><strong>600</strong><span>caracteres por chunk (máximo)</span></div>
<div class="art-metric"><strong>100</strong><span>caracteres de sobreposição</span></div>
<div class="art-metric"><strong>70% → 100%</strong><span>Recall@5 por página na base inicial de 5 fontes</span></div>
</div>

## Decisões

**Por que 600/100**
:   Com a base inicial de 5 fontes, chunks de 1.200 caracteres deixavam páginas certas da cartilha nas posições 13 e 23 do ranking. Com 600/100 e busca híbrida, o Recall@5 por página foi de 70% para 100% naquela base.

**Sobreposição**
:   Os 100 caracteres finais se repetem no início do chunk seguinte, para não perder frases na fronteira.

**Determinismo**
:   O identificador de cada chunk é o hash de (documento, página, posição, texto), então a mesma base gera sempre os mesmos identificadores.

**Metadados**
:   Título, órgão, URL, página e hash acompanham cada chunk e voltam junto com o resultado da busca.

## Alternativas testadas e revertidas

O grupo testou **quatro alternativas**: remover ruído, extrair tabelas, contexto no embedding e limite de chunks por documento. Cada uma foi medida contra a base nas 16 perguntas originais e **revertida porque piorou a recuperação por página**. Os números estão no [Relatório de validação](../avaliacao/relatorio-de-validacao.md).

!!! warning "Ressalva registrada"
    Com apenas 16 perguntas por conjunto, as 4 tentativas de melhoria podem ter sido revertidas por ruído. Veja [Limitações e próximos passos](../avaliacao/limitacoes.md).
