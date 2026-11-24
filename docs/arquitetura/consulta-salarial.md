# Consulta salarial da RAIS

O Artemis disponibiliza uma ferramenta para consultar quanto receberam profissionais de uma família ocupacional em um estado, a partir de vínculos formais do setor privado registrados na RAIS 2025. Uma **família ocupacional** agrupa ocupações relacionadas pela Classificação Brasileira de Ocupações (CBO).

## Experimente

Com Git, Python 3.12 ou superior e [uv](https://docs.astral.sh/uv/):

```bash
git clone https://github.com/ArtemisHubApp/artemishub_agents.git
cd artemishub_agents
uv run python -m src.salarios consultar --familia 2124 --uf DF --salario 7500
```

A família 2124 reúne analistas de tecnologia da informação. O parâmetro opcional `--salario` compara o valor informado com as medianas retornadas. Para buscar pelo nome da ocupação, troque `--familia 2124` por `--ocupacao "analista de sistemas"`. A ferramenta lista as correspondências e usa a família da primeira.

A consulta lê tabelas agregadas versionadas no Git. Para entender como os microdados foram filtrados e como reconstruir as tabelas, veja o [dicionário de dados da RAIS](https://github.com/ArtemisHubApp/artemishub_agents/blob/main/docs/dicionario_dados_rais.md).

No exemplo do DF, a mediana é **R$ 7.000,00** para mulheres (4.657 vínculos) e **R$ 8.462,79** para homens (19.410 vínculos). A ferramenta informa uma diferença bruta de **17,3%**, calculada em relação à mediana dos homens.

## Como interpretar

- **P25, P50 e P75** mostram os valores abaixo dos quais estão aproximadamente 25%, 50% e 75% dos vínculos do recorte. P50 é a mediana.
- **Cobertura.** Cada recorte publicado tem pelo menos 30 vínculos. Se a UF não tem recortes para ambos os sexos e há dados nacionais para a família, a ferramenta usa o Brasil e informa a troca. Confira a UF usada e quais grupos aparecem na saída. A diferença entre medianas só é calculada quando ambos os grupos estão disponíveis.
- **Comparação descritiva.** Os valores são remunerações mensais de 2025, em reais nominais, e excluem trabalho autônomo, PJ e serviço público. A diferença bruta compara medianas sem ajustar por jornada, escolaridade ou tempo de casa. Ela descreve o recorte e, por si só, não permite concluir que houve discriminação individual.

O [modelo salarial proposto](modelo-salarial.md) prevê uma estimativa ajustada pelo perfil e ainda está em planejamento.
