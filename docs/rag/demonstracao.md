---
origem: "Grupo 11 - Second Challenge - RAG (Relatório de Projeto, Semana 2) · seção As cinco perguntas da demonstração; reports/demo_rag.md"
codigo: "src/demo.py · reports/demo_rag.md"
---

# Demonstração

Cinco perguntas foram executadas de ponta a ponta e conferidas manualmente quanto à **fidelidade**: cada afirmação exibida foi comparada com os trechos recuperados.

<div class="art-metrics" markdown>
<div class="art-metric"><strong>3</strong><span>respondidas com citação</span></div>
<div class="art-metric"><strong>1</strong><span>abstenção correta (fora do tema)</span></div>
<div class="art-metric"><strong>1</strong><span>barrada pelo validador</span></div>
<div class="art-metric"><strong>0</strong><span>informações ausentes dos trechos</span></div>
</div>

## Resultado e conferência manual

| Pergunta | Resultado | Fidelidade (conferência manual) |
|---|---|---|
| Onde faço uma denúncia de desigualdade salarial? | <span class="art-chip art-chip--ok">respondida</span> | sustentada pela Cartilha, p. 6; a base não traz o endereço do canal |
| Quais empresas precisam publicar o relatório? | <span class="art-chip art-chip--ok">respondida</span> | sustentada (veja o [exemplo completo](consulta.md#exemplo-completo)) |
| Qual a multa se a empresa pagar menos a uma mulher na mesma função? | <span class="art-chip art-chip--no">barrada pelo validador</span> | conteúdo correto (10 vezes o novo salário, dobro na reincidência), mas um parágrafo de ressalva sem citação barrou a resposta |
| Quanto as mulheres ganham em média em relação aos homens? | <span class="art-chip art-chip--ok">respondida</span> | valores corretos; um deles citado na página vizinha do DIEESE (p. 12 em vez de p. 13) |
| Qual a previsão do tempo para amanhã? | <span class="art-chip art-chip--warn">abstenção</span> | abstenção correta: fora do tema |

!!! success "Fidelidade"
    Nenhuma resposta exibida trouxe informação ausente dos trechos recuperados.

## Relatório completo

O relatório gerado pela demonstração, com todos os trechos recuperados e as respostas, está em [Relatório da demonstração](../avaliacao/relatorio-da-demonstracao.md) (`reports/demo_rag.md`).

!!! info "O que a demonstração expõe"
    A pergunta da multa não teve resposta exibida e uma citação passou na página vizinha. Ambos são limitações conhecidas, com próximos passos em [Limitações e próximos passos](../avaliacao/limitacoes.md).
