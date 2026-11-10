# Métricas de Sucesso

> Parte do [PDR — Documento de Definição de Produto e Requisitos](README.md)

As métricas estão divididas pelos componentes da solução. Os critérios de go/no-go são definidos antes do treino e dos testes, para que a decisão de manter ou descartar cada parte seja objetiva. As metas são propostas e podem ser revistas após a análise exploratória dos dados.

### Modelo de estimativa salarial

| Métrica | O que mede | Meta proposta (go/no-go) |
|---|---|---|
| MAE e MAPE | erro médio da estimativa, em reais e em porcentagem | reduzir o erro em pelo menos 15% em relação ao baseline (mediana salarial por ocupação e UF) |
| R² | quanto da variação salarial o modelo explica | a definir após a análise exploratória |
| Cobertura do intervalo | se o salário real cai dentro da faixa estimada | pelo menos 80% dos casos de teste |
| Equidade do erro | se o modelo erra mais para algum grupo | diferença de erro relativo entre grupos de sexo e raça/cor de no máximo 5 pontos percentuais [12] |

### Base de conhecimento e respostas (RAG x LLM x CoT)

| Métrica | O que mede | Meta proposta |
|---|---|---|
| Recall@k | se o documento certo está entre os k primeiros recuperados | pelo menos 80% com k = 5 |
| Fidelidade (faithfulness) | se a resposta se apoia nos documentos recuperados, sem inventar | pelo menos 0,8 (RAGAS [8] ou LLM-as-judge) |
| Acerto em perguntas com gabarito | qualidade da resposta final | RAG supera o LLM sem base de conhecimento na avaliação comparativa |

### Sistema multiagente e aplicação

| Métrica | O que mede | Meta proposta |
|---|---|---|
| Taxa de conclusão de tarefas | se o fluxo completo funciona (perfil → estimativa → evidências → orientação) | pelo menos 90% dos cenários de teste |
| Tempo de resposta | experiência de uso | até 10 segundos por interação completa |
| Segurança | resistência a injeção de prompt entre agentes e via conteúdo enviado pela usuária | nenhum agente executando instrução vinda de texto da usuária ou de documentos nos testes |

### Impacto para as usuárias

| Métrica | O que mede | Meta proposta |
|---|---|---|
| Confiança para negociar | autoavaliação de 1 a 5 antes e depois de usar o protótipo | aumento médio de pelo menos 1 ponto |
| Utilidade percebida | se a usuária entendeu melhor o próprio valor no mercado | pelo menos 70% respondendo "concordo" ou "concordo totalmente" |
| Usabilidade (SUS) | facilidade de uso, inclusive sem tutorial | nota de pelo menos 70 (a média de referência é 68 [9]) |

### Acessibilidade e inclusão

| Métrica | O que mede | Meta proposta |
|---|---|---|
| Conformidade WCAG | contraste, rótulos ARIA, navegação por teclado e leitor de tela [10] | nível AA; nota de acessibilidade de pelo menos 90 no Lighthouse e nenhum erro crítico no axe [11] |
| Linguagem simples | se os textos são compreensíveis para diferentes níveis de escolaridade | validação com pelo menos uma usuária de baixa escolaridade ou baixa familiaridade digital |
| Acesso multiplataforma | uso em celular e computador | funcionamento em navegadores móveis e desktop |

### MLOps

| Métrica | O que mede | Meta proposta |
|---|---|---|
| Reprodutibilidade | se o treino gera o mesmo resultado com os mesmos dados e código | 100% dos experimentos registrados no MLflow e dados versionados com DVC |
| Rastreabilidade | se cada modelo em uso tem dados, código e métricas associados | todo modelo publicado tem registro completo |
| Monitoramento | se o modelo continua adequado quando sair uma nova RAIS | rotina de reavaliação definida e documentada |

---

[← Voltar ao índice do PDR](README.md)
