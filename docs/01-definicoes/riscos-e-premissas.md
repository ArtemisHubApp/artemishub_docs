# Riscos e Premissas

> Parte do [PDR — Documento de Definição de Produto e Requisitos](README.md) · Semana 1

## 8. Riscos


| # | Risco | Descrição |
|---|---|---|
| R1 | Complexidade de uso | Risco de instabilidades, falhas técnicas ou complexidade na navegação desestimularem a usuária a continuar utilizando o software, resultando no abandono da plataforma ou no preenchimento inadequado de dados, o que compromete a qualidade e a eficácia das análises do sistema. |
| R2 | Baixa adoção ou hesitação das usuárias | Possibilidade de as usuárias hesitarem em compartilhar informações reais de carreira, conquistas e dados de remuneração por receio quanto à privacidade ou falta de confiança no sistema. |
| R3 | Imprecisão nos dados do mercado | Risco de as simulações e recomendações salariais se tornarem obsoletas ou desalinhadas com as realidades locais e regionais das áreas de STEM. |
| R4 | Viés de gênero nos modelos de IA | Risco de os algoritmos e modelos de linguagem reproduzirem e perpetuarem vieses históricos de gênero presentes nas bases de dados de treinamento do mercado de trabalho. |

## 9. Premissas

As premissas são o que o grupo assume como verdadeiro para construir a solução. Cada uma precisa ser confirmada ao longo do projeto; se alguma se mostrar falsa, a solução deve ser revista.

### 9.1 Sobre o problema e o público

| # | Premissa | Como vamos validar |
|---|---|---|
| P1 | Mulheres recebem menos que homens em funções equivalentes, e a diferença é maior para mulheres negras e em algumas regiões. O 3º Relatório de Transparência Salarial mostrou que, em média, mulheres recebiam 20,9% a menos que homens em empresas com 100 ou mais empregados | dados da RAIS e Relatórios de Transparência Salarial |
| P2 | Muitas mulheres não sabem quanto vale seu perfil no mercado e se sentem inseguras para negociar salário | entrevistas e questionário com o público-alvo |
| P3 | Informação confiável sobre salário, aliada a apoio e comunidade, aumenta a confiança da mulher para negociar e se candidatar | questionário antes e depois do uso do protótipo |
| P4 | A sensação de não pertencimento contribui para a saída de mulheres de áreas como tecnologia, e redes de apoio ajudam a reduzir isso | entrevistas e revisão de literatura sobre evasão feminina em STEM |
| P5 | O público-alvo tem acesso a celular ou computador com internet, mesmo que limitada | perguntas sobre acesso no questionário |

### 9.2 Sobre os dados

| # | Premissa | Risco se for falsa |
|---|---|---|
| P6 | Os microdados públicos e não identificados da RAIS Vínculos, publicados pelo MTE no portal PDET, têm volume e variáveis suficientes (ocupação, setor, região, escolaridade, tempo de emprego, sexo, raça/cor e remuneração) para treinar o modelo de estimativa salarial | o modelo não generaliza e precisa de outra fonte |
| P7 | Os Relatórios de Transparência Salarial, gerados pelo MTE por CNPJ e publicados pelas empresas com 100 ou mais empregados, podem ser lidos e usados como base de evidência sobre disparidade por empresa | o alerta sobre empresas fica limitado ou sem fonte oficial |
| P8 | Os dados usados são anônimos e públicos, então o projeto não depende de dados pessoais sensíveis para treinar o modelo | é necessário revisar a conformidade com a LGPD |

### 9.3 Sobre a solução técnica

| # | Premissa |
|---|---|
| P9 | Um modelo de regressão consegue estimar uma faixa salarial de referência a partir de experiência, competências, ocupação e região |
| P10 | Respostas baseadas em RAG (legislação, guias de negociação e de direitos) são mais confiáveis que as de um LLM sem base de conhecimento |
| P11 | Um sistema multiagente consegue dividir as tarefas da plataforma: estimar o salário, analisar o perfil, buscar evidências e simular uma negociação |
| P12 | O perfil da usuária pode ser montado por formulário (MVP) e, como evolução, por leitura de currículo ou integração com LinkedIn/Lattes (multimodalidade) |

### 9.4 Sobre ética e limites

| # | Premissa |
|---|---|
| P13 | A plataforma informa e apoia a decisão, mas não promete salário nem substitui orientação jurídica ou psicológica profissional |
| P14 | O alerta sobre empresas é baseado apenas em dados oficiais; relatos individuais de discriminação são encaminhados aos canais oficiais (MTE e MPT) previstos na Lei 14.611/2023 [5], e não publicados na plataforma |
| P15 | Como os salários históricos já carregam a desigualdade, um modelo treinado com eles pode reproduzi-la. Por isso, a equidade é medida como critério de sucesso, e não só a precisão |

### 9.5 Limitações assumidas

- A RAIS cobre apenas o emprego formal, então mulheres na informalidade não estão representadas no modelo [1].

- Desde os dados de 2024, a RAIS inclui "vínculos abandonados", que precisam ser retirados das análises [6].

- Empresas contestam a metodologia dos Relatórios de Transparência Salarial, que compara funcionárias de cargos e níveis diferentes [7]. Os dados dos relatórios serão apresentados como indicativos, e não como prova de discriminação.

- O protótipo será validado com um grupo pequeno de usuárias dentro das 7 semanas do desafio, sem uso em larga escala.

---

[← Voltar ao índice do PDR](README.md)
