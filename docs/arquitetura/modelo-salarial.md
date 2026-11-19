---
origem: "Arquitetura multiagente do Artemis (Challenge 2) · seção Modelo salarial"
codigo: "github.com/ArtemisHubApp/artemishub_agents"
---

# Modelo salarial

Uma referência que não repete a desigualdade.

!!! success "Implementado: consulta descritiva"
    O repositório `artemishub_agents` contém o dataset RAIS STEM 2025 processado (2.478.804 vínculos) e a ferramenta `src.salarios`, que gera e consulta P25/P50/P75 por família CBO × UF × sexo. Os recortes exigem ao menos 30 vínculos. A consulta calcula a diferença bruta entre medianas e compara, opcionalmente, um salário informado.

!!! warning "Ainda não comprovado: modelo preditivo"
    A regressão por quantis, faixa de referência contrafactual, calibração conformal, registro de experimentos no MLflow e avaliação de equidade descritos nesta página são **proposta de arquitetura**, não resultados implementados e medidos na branch `main` consultada em 19/11/2026. Não foi localizado modelo treinado nem relatório com MAE/MAPE/R², cobertura ou métricas de equidade. Os critérios abaixo são metas a validar, não resultados atingidos.

A estimativa vem de uma regressão clássica treinada na RAIS. O problema é que o salário histórico já carrega a diferença de gênero e raça. Um modelo treinado nele, do jeito que ele é, aprende a pagar menos às mulheres. Tirar sexo e raça das variáveis não resolve: a diferença continua chegando ao modelo pela ocupação, pelo setor e pela jornada, só que sem aparecer.

A proposta é incluir sexo e raça no treino para separar o efeito deles do efeito do perfil, e fixá-los num grupo de referência na hora de prever. É a lógica da decomposição de Oaxaca-Blinder, usada na economia do trabalho para medir diferença salarial.

```text
log(salário_hora) = f(CBO, UF, escolaridade, tempo_emprego, setor, porte) + g(sexo, raça | perfil) + ε

faixa_mercado    = quantis de f + g(sexo e raça reais)    → o que mulheres com esse perfil recebem hoje
faixa_referência = quantis de f + g(grupo de referência)  → o que o mercado paga ao grupo de referência com o mesmo perfil
diferença        = faixa_referência − faixa_mercado       → diferença por CBO e UF, não só a média nacional
```

!!! example "Exemplo ilustrativo · Product Designer · SP · R$ mil por mês (base 40 h)"
    | Faixa | P25 | P50 | P75 |
    |---|---|---|---|
    | Mercado atual | 7,2 | 8,4 | 9,8 |
    | Referência sem a diferença | 8,3 | 9,6 | 11,2 |

    Salário informado: **8,3**, ou seja, **14% abaixo** da mediana de referência.

    Números fictícios para ilustrar a proposta. Não são previsões nem resultados de um modelo treinado.

## Decisões

<div class="grid cards" markdown>

-   **Sexo e raça da usuária não mudam a estimativa**

    Na previsão, os dois ficam fixos no grupo de referência para todas. Eles servem só para retirar o efeito da discriminação, nunca para dizer quanto ela vale, como pede o RNF-14.

-   **Salário por hora, não por mês**

    Mais mulheres têm jornada parcial. Sem dividir pelas horas contratadas, o modelo confunde "trabalha menos horas" com "ganha menos pela mesma função". A tela converte de volta para 40 h.

-   **Faixa calibrada, não número único**

    Regressão por quantis (LightGBM, P25/P50/P75) e conformal prediction para garantir a cobertura de 80% do PDR. Calibrando separado por sexo × raça, a cobertura fica igual entre os grupos, o que atende a meta de no máximo 5 pontos percentuais de diferença no erro.

-   **Avaliar no modo factual**

    MAE, MAPE, cobertura e equidade do erro são medidos prevendo com o sexo e a raça verdadeiros, contra o baseline de mediana por CBO e UF. A faixa de referência é derivada e "erra para cima" com mulheres de propósito, então não entra nessas métricas.

-   **Grupo de referência é decisão do grupo**

    Fixar só o sexo deixa a diferença por raça na conta, e as mulheres negras têm a maior diferença. As opções são homens de todas as raças ou homens brancos. A escolha deve ser registrada no PDR.

-   **A referência é um piso**

    Parte da desigualdade fica "explicada" pelo próprio perfil, porque mulheres são enquadradas em CBOs e níveis mais baixos para o mesmo trabalho. A tela deve dizer que a diferença mostrada é conservadora (RNF-13 e RNF-15).

</div>

!!! warning "Pendente"
    O grupo de referência (homens de todas as raças ou homens brancos) ainda não foi escolhido.

## Proposta de preparo e treinamento da RAIS

1. Filtrar CBOs de STEM e remover vínculos abandonados (dados de 2024 em diante) e jornadas zeradas.
2. Calcular salário por hora e corrigir pelo IPCA para o mês de referência exibido na tela.
3. Treinar f + g com sexo e raça, interações com CBO e UF, e validar por ano (treina em um ano, testa no seguinte).
4. Registrar dados (DVC), parâmetros, métricas por grupo e o grupo de referência no MLflow.
5. Expor como ferramenta `estimar_faixa(cbo, uf, escolaridade, experiencia)`, que devolve as duas faixas, a fonte, o ano da RAIS e os limites. O agente Salarial só explica esses números.

**Implementado hoje:** `src.salarios` consulta tabelas agregadas de remuneração mensal da RAIS 2025, por família CBO × UF × sexo. A tabela publica P25, P50 e P75, n de vínculos e mediana para jornada de pelo menos 40 horas quando há amostra suficiente. Recortes com menos de 30 vínculos são descartados; se o recorte estadual não tiver mulheres e homens suficientes, a ferramenta tenta o Brasil e informa essa substituição. A diferença entre medianas é bruta e não controla escolaridade, tempo de emprego, porte ou jornada.

Para reproduzir: `uv run python -m src.salarios gerar --ano 2025` e `uv run python -m src.salarios consultar --ocupacao "analista de sistemas" --uf DF --salario 7500`. Veja o [guia de reprodução](../guias/reproduzir-agentes.md) e o [dicionário RAIS](https://github.com/ArtemisHubApp/artemishub_agents/blob/main/docs/dicionario_dados_rais.md).

## Referências

- Oaxaca, R. (1973). *Male-Female Wage Differentials in Urban Labor Markets.*
- Blinder, A. (1973). *Wage Discrimination: Reduced Form and Structural Estimates.*
- Romano, Y., Patterson, E. e Candès, E. (2019). *Conformalized Quantile Regression.*
- [Fairlearn](https://fairlearn.org)
