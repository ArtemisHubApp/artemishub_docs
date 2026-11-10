---
origem: "Grupo 11 - Second Challenge - RAG (Relatório de Projeto, Semana 2) · seção Limitações e próximos passos"
codigo: "docs/validation_report.md"
---

# Limitações e próximos passos

| Limitação | Efeito | Próximo passo |
|---|---|---|
| Fontes do mesmo tema disputam o top 5 | MRR por página menor com 20 fontes, sobretudo no holdout | testar um reranker num conjunto de avaliação maior |
| Amostra pequena (16 perguntas por conjunto) | uma pergunta muda o MRR em até 0,06; as 4 tentativas de melhoria podem ter sido revertidas por ruído | ampliar o conjunto, com holdout separado e regra de adoção por intervalo de confiança (em andamento) |
| Validador barra a resposta inteira por um parágrafo sem citação | a pergunta da multa não teve resposta exibida | nova tentativa de geração que devolve ao modelo o motivo exato |
| Validador confere se a fonte citada existe, não se ela sustenta a frase | a citação na página vizinha do DIEESE passou | verificação de sustentação com um LLM avaliador, calibrado contra a conferência manual |
| PDFs com fontes sem mapeamento Unicode (INEP e Diretrizes) | cabeçalhos e alguns trechos ilegíveis | decodificar as Diretrizes em PR próprio, revisando o gabarito afetado |
| Gráficos viram números soltos (DIEESE, p. 13) | o modelo não sabe qual valor é de quem | descrever gráficos a partir da imagem da página, marcando o texto como gerado |
| Embeddings leem até 128 tokens | o final de alguns chunks não entra no vetor | medir quantos chunks passam do limite antes de mudar tamanho ou modelo |

Veja também as [limitações assumidas no PDR](../produto/premissas.md#limitacoes-assumidas) sobre os dados salariais.
