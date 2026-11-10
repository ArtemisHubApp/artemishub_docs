# Referências e Glossário

> Parte do [PDR — Documento de Definição de Produto e Requisitos](README.md)

## Referências

- Ministério do Trabalho e Emprego. RAIS – Programa de Disseminação das Estatísticas do Trabalho (PDET). Microdados públicos e não identificados.[pdet.mte.gov.br/rais](http://pdet.mte.gov.br/rais) · arquivos por ano: ftp://ftp.mtps.gov.br/pdet/microdados/RAIS/ · serviço de consulta:[gov.br](https://www.gov.br/pt-br/servicos/solicitar-consulta-as-estatisticas-da-rais-e-do-caged)

- Ministério das Mulheres e MTE. Cartilha Tira-Dúvidas: Lei da Igualdade Salarial e de Critérios Remuneratórios entre Mulheres e Homens.[gov.br/mulheres](https://www.gov.br/mulheres/pt-br/central-de-conteudos/publicacoes/cartilha-tira-duvidas-lei-da-igualdade-salarial-e-de-criterios-remuneratorios-entre-mulheres-e-homens_defeso.pdf/@@display-file/file)

- Fenacon. Empresas têm até 31 de agosto para enviar dados para Relatório de Transparência Salarial, 2026.[fenacon.org.br](https://fenacon.org.br/noticias/empresas-tem-ate-31-de-agosto-para-enviar-dados-para-relatorio-de-transparencia-salarial/)

- Agência Gov / MTE. Dados para o 6º Relatório de Transparência Salarial começam a ser enviados, 03/08/2026.[agenciagov.ebc.com.br](https://agenciagov.ebc.com.br/noticias/202608/empresas-com-100-ou-mais-empregados-devem-atualizar-informacoes-para-o-6o-relatorio-de-transparencia-salarial)

- Brasil. Lei nº 14.611, de 3 de julho de 2023 (Lei da Igualdade Salarial).[planalto.gov.br](https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2023/lei/l14611.htm)

- IJSN. Características do Emprego Formal no Espírito Santo – 2025 (explica os vínculos abandonados).[ijsn.es.gov.br](https://ijsn.es.gov.br/Media/IJSN/PublicacoesAnexos/cadernos/RAIS/Caracter%C3%ADsticas%20do%20Emprego%20Formal%20no%20Esp%C3%ADrito%20Santo%20-%202025.pdf)

- Deutsche Bank Brasil. Nota Explicativa – Relatório de Transparência Salarial, 2º Semestre 2024.[db.com](https://china.db.com/brazil/RSAC/Nota-Explicativa-do-Relatorio-de-Transparencia-Salarial-Deutsche-Bank-Brasil-2-Semestre-2024.pdf)

- RAGAS: Evaluation framework for RAG.[docs.ragas.io](https://docs.ragas.io)

- Brooke, J. SUS: A “quick and dirty” usability scale, 1996; referência da média 68: Sauro, J.[measuringu.com/sus](https://measuringu.com/sus/)

- W3C. Web Content Accessibility Guidelines (WCAG) 2.2.[w3.org/TR/WCAG22](https://www.w3.org/TR/WCAG22/)

- Google. Lighthouse[developer.chrome.com/docs/lighthouse](https://developer.chrome.com/docs/lighthouse) · Deque. axe[deque.com/axe](https://www.deque.com/axe/)

- Fairlearn (métricas de equidade em ML).[fairlearn.org](https://fairlearn.org)

- Kreuzberger, D.; Kühl, N.; Hirschl, S. Machine Learning Operations (MLOps): Overview, Definition, and Architecture. IEEE Access, v. 11, 2023. DOI:[10.1109/ACCESS.2023.3262138](https://doi.org/10.1109/ACCESS.2023.3262138)

- [IBGE Educa — As mulheres do Brasil](https://educa.ibge.gov.br/jovens/materias-especiais/22052-as-mulheres-do-brasil.html)

## Glossário

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

---

[← Voltar ao índice do PDR](README.md)
