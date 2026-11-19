---
origem: "README.md · pyproject.toml · .github/workflows/ci.yml · src/salarios.py · docs/dicionario_dados_rais.md"
codigo: "github.com/ArtemisHubApp/artemishub_agents"
---

# Reproduzir dados e ferramentas salariais

Este guia descreve o que pode ser reproduzido hoje no `artemishub_agents`: o preparo do dataset RAIS STEM, a geração das tabelas agregadas e a consulta salarial de referência.

> **Limite importante:** o repositório já contém o pipeline de dados e a ferramenta de consulta por medianas/percentis. O grafo multiagente descrito na arquitetura ainda não está implementado no código da branch `main`; portanto, este guia não apresenta um comando para executar uma conversa completa com agentes.

## Pré-requisitos

- Python 3.12 ou 3.13;
- [uv](https://docs.astral.sh/uv/);
- Git;
- acesso ao remote DVC configurado para recuperar o dataset versionado, quando necessário.

## Instalação

```bash
git clone https://github.com/ArtemisHubApp/artemishub_agents.git
cd artemishub_agents
uv sync --locked --dev
```

## Recuperar os dados versionados

Os arquivos Parquet são controlados pelo DVC. Com o remote do projeto configurado:

```bash
dvc pull
```

O dataset nacional processado esperado é `data/processed/rais_stem_2025_brasil.parquet`. As tabelas agregadas usadas pela consulta ficam em `data/agregados/` e são versionadas no Git.

## Gerar as tabelas de consulta

A partir do Parquet:

```bash
uv run python -m src.salarios gerar --ano 2025
```

O comando gera:

- `data/agregados/salarios_rais_2025.csv`: percentis por família da CBO, UF e sexo;
- `data/agregados/ocupacoes_cbo.csv`: catálogo de ocupações CBO e respectivas famílias.

Os recortes com menos de 30 vínculos não são publicados. A tabela também inclui totais nacionais e recortes agregados por sexo.

## Consultar uma ocupação

Por nome de ocupação:

```bash
uv run python -m src.salarios consultar --ocupacao "analista de sistemas" --uf DF --salario 7500
```

Ou diretamente pela família CBO:

```bash
uv run python -m src.salarios consultar --familia 2124 --uf DF --salario 7500
```

A saída JSON inclui a família encontrada, UF solicitada e utilizada, ano, fonte, amostra, P25/P50/P75, mediana de tempo integral quando disponível, diferença bruta entre medianas e avisos de interpretação.

Se o recorte estadual não tiver ao menos 30 vínculos de cada sexo, a ferramenta tenta usar o Brasil e informa essa substituição. Se não houver amostra suficiente nem nacionalmente, retorna `suficiente: false`.

## Pipeline de preparação da RAIS

O pipeline de construção do dataset nacional depende dos microdados regionais e das tabelas oficiais da CBO. O passo a passo, os filtros, o dicionário de colunas e as limitações estão no [dicionário RAIS do repositório](https://github.com/ArtemisHubApp/artemishub_agents/blob/main/docs/dicionario_dados_rais.md).

Em linhas gerais:

1. preparar os seis arquivos regionais da RAIS e as tabelas de ocupação/família da CBO nos diretórios esperados;
2. executar `src.rais_dataset` para cada região;
3. executar `src.rais_brasil` para consolidar o Brasil;
4. executar `src.salarios gerar --ano 2025` para produzir as tabelas de consulta.

Não baixe nem redistribua microdados pessoais fora das condições de uso definidas pelo MTE. Trabalhe com os arquivos e recortes agregados previstos pelo projeto.

## Qualidade e CI

Os comandos locais equivalentes aos checks do GitHub Actions são:

```bash
uv run ruff check .
uv run pytest -q
```

O workflow executa lint com Ruff e testes com pytest em Python 3.12 e 3.13, em pull requests e pushes para `main`.

## O que ainda não é reproduzível neste repositório

- execução do grafo multiagente completo;
- integração operacional do grafo com a API do backend;
- ingestão e interpretação multimodal de currículo;
- treinamento e inferência de um modelo de faixa salarial ajustado por perfil;
- relatório versionado de métricas e equidade do modelo salarial.

Esses itens devem ser documentados quando houver implementação e evidências de execução. A arquitetura proposta e o estado atual estão descritos em [Arquitetura multiagente](../arquitetura/multiagentes.md) e [Modelo salarial](../arquitetura/modelo-salarial.md).
