---
origem: "Grupo 11 - Definição do Projeto (PDR) · docs/01-definicoes no repositório; Grupo 11 - Second Challenge - RAG (Glossário)"
---

# Glossário

!!! tip "Dica"
    Os termos mais usados aparecem com uma explicação ao passar o mouse sobre eles em qualquer página.

## Produto e requisitos

### Conceitos gerais

- Premissa: algo que o grupo assume como verdadeiro para construir a solução, mas que ainda precisa ser confirmado.

- Métrica: um número que mede se algo funciona.

- Meta: o valor da métrica que precisamos atingir.

- Go/no-go: regra definida antes do teste: se a meta for atingida, a parte entra no produto (go); se não, fica de fora (no-go).

- Baseline: a solução mais simples possível, usada como comparação. O modelo de IA só vale a pena se for melhor que ela.

- MVP (Produto Mínimo Viável): a primeira versão do produto, com o mínimo necessário para testar a ideia com usuárias.

- Ponto percentual: diferença entre duas porcentagens. De 8% para 13% são 5 pontos percentuais.

### Dados

- RAIS (Relação Anual de Informações Sociais): base do governo com todos os vínculos de emprego formal do Brasil a cada ano.

- Microdados: dados no nível de cada registro (cada vínculo de emprego), e não em tabelas resumidas.

- Não identificados: sem nome, CPF ou outra informação que revele quem é a pessoa.

- PDET: Programa de Disseminação das Estatísticas do Trabalho, o portal do MTE que publica a RAIS.

- CBO e CNAE: códigos oficiais de ocupação (CBO) e de atividade da empresa (CNAE).

- Relatório de Transparência Salarial: documento semestral, gerado pelo MTE para empresas com 100 ou mais empregados, que mostra diferenças salariais entre mulheres e homens.

- Feature: cada informação que entra no modelo (ocupação, escolaridade, região etc.).

- LGPD: Lei Geral de Proteção de Dados.

- Informalidade: trabalho sem carteira assinada, que não aparece na RAIS.

### Modelo de estimativa salarial

- Regressão: tipo de modelo que prevê um número (aqui, o salário).

- MAE (erro absoluto médio): quanto o modelo erra, em média, em reais.

- MAPE: o mesmo erro, em porcentagem do salário real.

- R²: de 0 a 1, quanto da diferença de salário entre as pessoas o modelo consegue explicar.

- Intervalo / cobertura: o modelo entrega uma faixa salarial; a cobertura é a porcentagem de casos em que o salário real cai dentro dela.

- Equidade (fairness): se o modelo funciona igualmente bem para todos os grupos, sem errar mais para mulheres negras, por exemplo.

- Análise exploratória: primeira análise dos dados para entender distribuições, erros e padrões antes de treinar.

### IA generativa

- LLM: modelo de linguagem de grande porte, como o que está por trás de assistentes de IA.

- RAG: técnica em que o sistema busca documentos confiáveis antes de responder, para basear a resposta neles.

- CoT (Chain of Thought): técnica que faz o modelo raciocinar passo a passo antes de responder.

- Recall@k: porcentagem de perguntas em que o documento certo aparece entre os k primeiros encontrados.

- Fidelidade (faithfulness): se a resposta se baseia nos documentos encontrados ou se o modelo inventou algo.

- Alucinação: quando o modelo inventa uma informação que parece verdadeira.

- RAGAS: ferramenta que mede automaticamente a qualidade de sistemas RAG.

- LLM-as-judge: usar um modelo de linguagem para avaliar as respostas de outro.

- Sistema multiagente: vários agentes de IA, cada um com uma tarefa, trabalhando juntos.

- Injeção de prompt: ataque em que um texto tenta dar ordens escondidas ao modelo, como um currículo com “ignore suas instruções”.

- Multimodalidade: capacidade de entender outros formatos além de texto, como PDF, imagem ou áudio.

### Usuárias e acessibilidade

- SUS (System Usability Scale): questionário padrão de 10 perguntas que gera uma nota de usabilidade de 0 a 100.

- WCAG: padrão internacional de acessibilidade na web; o nível AA é o mais usado como referência.

- ARIA (rótulos ARIA): marcações no código que ajudam leitores de tela a descrever a página para pessoas com deficiência visual.

- Leitor de tela: programa que lê em voz alta o conteúdo da tela.

- Lighthouse e axe: ferramentas gratuitas que analisam uma página e apontam problemas de acessibilidade.

### MLOps

- MLOps: conjunto de práticas para levar modelos de ML para produção de forma organizada, reprodutível e monitorada.

- Reprodutibilidade: conseguir rodar o treino de novo e obter o mesmo resultado.

- Rastreabilidade: saber com quais dados, código e métricas cada modelo foi gerado.

- MLflow: ferramenta que registra experimentos, métricas e versões de modelos.

- DVC: ferramenta que versiona dados, como o Git faz com código.

- Monitoramento: acompanhar se o modelo continua funcionando bem ao longo do tempo.

## Base de conhecimento (RAG)

- **RAG**: técnica em que o sistema busca documentos confiáveis antes de responder, para basear a resposta neles.
- **Chunk**: trecho de texto em que um documento é dividido para ser indexado e recuperado.
- **Embedding**: vetor numérico que representa o significado de um texto; textos parecidos têm vetores próximos.
- **Banco vetorial**: banco de dados que guarda embeddings e encontra os mais próximos de uma pergunta.
- **BM25**: busca por palavras que dá mais peso a termos raros.
- **RRF (Reciprocal Rank Fusion)**: forma de juntar dois rankings, favorecendo o que vai bem nos dois.
- **Recall@5**: porcentagem de perguntas em que a página certa aparece entre os 5 primeiros trechos.
- **MRR@5**: média de 1/posição da primeira página certa no top 5; quanto mais alto, mais cedo ela aparece.
- **Context Precision@5**: fração dos 5 trechos recuperados que vêm de fonte relevante.
- **Gabarito**: documento e página que respondem a cada pergunta de avaliação.
- **Holdout**: conjunto de perguntas guardado só para a medição final, nunca usado para ajustar o sistema.
- **Fidelidade (faithfulness)**: se a resposta se apoia nos trechos recuperados, sem inventar.
- **Abstenção**: quando o sistema responde que não encontrou evidência suficiente, em vez de arriscar uma resposta.
