# Requisitos Funcionais e Não Funcionais

> Parte do [PDR — Documento de Definição de Produto e Requisitos](README.md) · Semana 1

### 7.1 Metodologia

A elicitação de requisitos foi realizada a partir da análise das respostas de um formulário aplicado ao público-alvo, com o objetivo de identificar suas principais dificuldades, necessidades e expectativas em relação à solução proposta. Os resultados foram considerados em conjunto com o problema definido pela equipe e as funcionalidades priorizadas durante a concepção do projeto.

### 7.2 Requisitos Funcionais

| Código | Requisito | Descrição |
|---|---|---|
| RF-01 | Cadastro e autenticação | O sistema deve permitir que a usuária crie uma conta utilizando e-mail e senha, autentique-se, encerre sua sessão e solicite a redefinição de senha. |
| RF-02 | Gerenciamento do perfil profissional | O sistema deve permitir que a usuária cadastre, consulte e atualize informações sobre formação acadêmica, experiências profissionais, competências, localização, área de atuação e objetivos de carreira. |
| RF-03 | Envio de currículo | O sistema deve permitir que a usuária envie um currículo em formato PDF com texto extraível, para utilização na análise de seu perfil profissional. |
| RF-04 | Identificação de competências com IA | O sistema deve analisar as informações fornecidas no perfil e no currículo para identificar competências técnicas, experiências e conhecimentos profissionais, apresentando as evidências utilizadas para cada identificação. |
| RF-05 | Síntese do perfil profissional | O sistema deve gerar uma síntese das competências e experiências da usuária, destacando seus pontos fortes em relação ao objetivo profissional informado. |
| RF-06 | Consulta de referências salariais | O sistema deve permitir que a usuária consulte informações salariais disponíveis para cargos da área de STEM, considerando cargo, localização e nível de experiência, conforme a cobertura da base de dados. |
| RF-07 | Análise contextualizada de remuneração | O sistema deve comparar a remuneração informada voluntariamente pela usuária com as referências salariais disponíveis para um cargo e recorte compatíveis, indicando as diferenças observadas. |
| RF-08 | Visualização de desigualdades salariais | O sistema deve permitir consultar diferenças salariais agregadas entre mulheres e homens em ocupações STEM, quando existirem dados comparáveis e suficientes, apresentando a fonte e as limitações da comparação. |
| RF-09 | Simulação de negociação salarial com IA | O sistema deve permitir que a usuária pratique uma negociação salarial em uma conversa simulada com IA, considerando cargo, objetivo de negociação e contexto profissional informado. |
| RF-10 | Consulta de oportunidades de desenvolvimento | O sistema deve disponibilizar um catálogo de oportunidades de capacitação e desenvolvimento para mulheres em STEM, incluindo cursos, bolsas, programas de formação, projetos e iniciativas afirmativas. |
| RF-11 | Filtragem de oportunidades | O sistema deve permitir que a usuária filtre oportunidades por área de interesse, tipo, localização, modalidade, requisitos e existência de políticas afirmativas declaradas. |
| RF-12 | Recomendação personalizada de oportunidades | O sistema deve recomendar oportunidades do catálogo considerando competências, interesses, objetivos profissionais e requisitos de participação. |
| RF-13 | Salvamento de oportunidades | O sistema deve permitir que a usuária salve e remova oportunidades de uma lista pessoal para consulta posterior. |
| RF-14 | Identificação de competências a desenvolver | O sistema deve comparar as competências confirmadas no perfil da usuária com os requisitos de seu objetivo profissional, identificando competências relevantes que ainda não foram evidenciadas. |
| RF-15 | Geração de plano de desenvolvimento | O sistema deve gerar um plano de desenvolvimento profissional com objetivos, ações sugeridas e oportunidades relacionadas, considerando o perfil, as competências a desenvolver e a disponibilidade informada pela usuária. |
| RF-16 | Acompanhamento do plano | O sistema deve permitir que a usuária consulte seu plano e atualize o estado das ações como não iniciada, em andamento ou concluída. |
| RF-17 | Atualização das orientações | O sistema deve permitir que a usuária solicite a atualização das recomendações e do plano de desenvolvimento após modificar suas competências, objetivos ou experiências profissionais. |

### 7.3 Requisitos Não Funcionais

| Código | Requisito | Descrição |
|---|---|---|
| RNF-01 | Desempenho | O sistema deve executar as operações de navegação, consulta e atualização de dados dentro dos limites de tempo de resposta definidos para os cenários de uso e carga previstos. |
| RNF-02 | Disponibilidade | O sistema deve manter um nível de disponibilidade compatível com o período de operação previsto, conforme percentual mínimo e janela de medição estabelecidos antes da implantação. |
| RNF-03 | Usabilidade | A interface deve permitir que usuárias do público-alvo realizem as tarefas principais sem assistência, atingindo a taxa mínima de conclusão definida no protocolo de testes de usabilidade. |
| RNF-04 | Acessibilidade | A interface deve atender aos critérios aplicáveis dos níveis A e AA da WCAG 2.2, incluindo navegação por teclado, compatibilidade com tecnologias assistivas e apresentação adequada do conteúdo. |
| RNF-05 | Compatibilidade | O sistema deve permitir a execução dos fluxos principais nos navegadores e dispositivos definidos na matriz de compatibilidade do projeto, sem perda de funcionalidades essenciais. |
| RNF-06 | Segurança e controle de acesso | O sistema deve proteger os dados das usuárias contra acessos não autorizados, garantindo que somente pessoas autenticadas e autorizadas possam consultar ou modificar informações restritas. |
| RNF-07 | Privacidade e proteção de dados | O tratamento de dados pessoais deve observar os princípios e obrigações aplicáveis da LGPD, incluindo finalidade, necessidade, transparência e medidas de proteção adequadas. |
| RNF-08 | Integridade e recuperação de dados | O sistema deve preservar a consistência das informações armazenadas e permitir sua recuperação após falhas, respeitando os limites de perda de dados e tempo de recuperação definidos para o projeto. |
| RNF-09 | Qualidade das informações externas | Os dados de oportunidades e referências salariais devem possuir origem identificável, período de referência e indicação de atualização, permitindo avaliar sua procedência e atualidade. |
| RNF-10 | Manutenibilidade | O sistema deve permitir alterações em regras de negócio, fontes de dados e componentes de IA sem exigir modificações em funcionalidades não relacionadas, conforme testes de regressão definidos para o projeto. |
| RNF-11 | Qualidade das análises de IA | Os componentes de IA devem atingir os critérios mínimos de qualidade estabelecidos para identificação de competências, recomendações e orientações, conforme métricas e conjuntos de avaliação definidos para cada tarefa. |
| RNF-12 | Fundamentação das respostas | As análises e recomendações da IA devem utilizar informações do perfil da usuária e dados disponíveis nas fontes autorizadas, sem apresentar como fatos informações não sustentadas pelas evidências utilizadas. |
| RNF-13 | Explicabilidade e transparência | As recomendações geradas por IA devem apresentar justificativas compreensíveis, identificando os principais critérios considerados e distinguindo informações verificadas de inferências ou sugestões. |
| RNF-14 | Equidade e mitigação de vieses | Os componentes de IA devem ser avaliados quanto a diferenças injustificadas de desempenho ou tratamento entre grupos relevantes, respeitando critérios de equidade definidos para cada tarefa e evitando o uso de atributos sensíveis para inferir valor profissional individual. |
| RNF-15 | Robustez e tratamento de incertezas | A IA deve reconhecer situações de informação insuficiente, contraditória ou indisponível, evitando apresentar conclusões categóricas e sinalizando as limitações que comprometam a confiabilidade da resposta. |
| RNF-16 | Privacidade no processamento por IA | Os dados pessoais utilizados pelos componentes de IA devem ser limitados às finalidades autorizadas, com controles que impeçam sua divulgação indevida e seu uso para finalidades não previstas. |

---

[← Voltar ao índice do PDR](README.md)
