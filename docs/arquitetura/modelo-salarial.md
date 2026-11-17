---
origem: "Arquitetura multiagente do Artemis (Challenge 2) · seção Modelo salarial"
codigo: "github.com/ArtemisHubApp/artemishub_agents"
---

# Modelo salarial

Uma referência que não repete a desigualdade.

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

    Números inventados para mostrar o formato da tela Salário. Os valores reais saem do modelo treinado na RAIS.

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

## Preparo da RAIS

1. Filtrar CBOs de STEM e remover vínculos abandonados (dados de 2024 em diante) e jornadas zeradas.
2. Calcular salário por hora e corrigir pelo IPCA para o mês de referência exibido na tela.
3. Treinar f + g com sexo e raça, interações com CBO e UF, e validar por ano (treina em um ano, testa no seguinte).
4. Registrar dados (DVC), parâmetros, métricas por grupo e o grupo de referência no MLflow.
5. Expor como ferramenta `estimar_faixa(cbo, uf, escolaridade, experiencia)`, que devolve as duas faixas, a fonte, o ano da RAIS e os limites. O agente Salarial só explica esses números.

Até o modelo ficar pronto, o agente Salarial usa `src.salarios.consultar` do `artemishub_agents`: medianas, P25 e P75 por família da CBO × UF × sexo da RAIS STEM 2025, com recortes de pelo menos 30 vínculos.

## Referências

- Oaxaca, R. (1973). *Male-Female Wage Differentials in Urban Labor Markets.*
- Blinder, A. (1973). *Wage Discrimination: Reduced Form and Structural Estimates.*
- Romano, Y., Patterson, E. e Candès, E. (2019). *Conformalized Quantile Regression.*
- [Fairlearn](https://fairlearn.org)
