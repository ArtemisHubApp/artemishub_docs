---
origem: "Design do artemishub_orchestration (seção 6.7) · aprovado em 17/11/2026"
---

# ADR-006: uv como gerenciador único e CI reutilizável

- **Status:** proposto (aguardando aprovação do time)
- **Data:** 17/11/2026
- **Repo:** [artemishub_orchestration](https://github.com/ArtemisHubApp/artemishub_orchestration)

## Contexto

Em 17/11/2026 os repos Python estavam assim:

- o **`rag`** tinha quatro fontes de dependências: `pyproject.toml` com `uv.lock`, `requirements.txt`, `requirements-dev.txt` e um `requirements-validation.lock` gerado em Python 3.14, num projeto que pede `<3.13`. O CI rodava `uv sync` **sem `--locked`**, então o `uv.lock` podia ficar desatualizado sem ninguém notar, e o Dockerfile ignorava o lock;
- o **`agents`** acabava de ganhar um CI bom: `uv sync --locked`, ruff e pytest em 3.12 e 3.13;
- o **`backend`** e o **`frontend`** ainda não tinham código.

Com CI copiado em cada repo, cada um vai para um lado.

## Decisão

- O **uv** é o único gerenciador nos repos Python. O **`uv.lock`** é commitado e é a única fonte de versões. Quem precisar de um `requirements.txt` gera com `uv export`.
- O Python base é **3.12** (`.python-version`), e cada repo declara a sua matriz de testes.
- O CI fica **centralizado** num workflow reutilizável do orquestrador, `python-ci.yml`. O repo filho só chama o workflow:

```yaml
on:
  pull_request:
    types: [opened, edited, synchronize, reopened]
  push: { branches: [staging, main] }
permissions: { contents: read, pull-requests: read }
jobs:
  ci:
    uses: ArtemisHubApp/artemishub_orchestration/.github/workflows/python-ci.yml@main
```

O bloco `permissions` é obrigatório: um workflow chamado não pode ter mais permissões que o repo que o chama. O tipo `edited` faz o check do título rodar de novo quando alguém corrige o título do PR.

- Em todo PR e push, o `python-ci.yml` verifica (o título, só em PR):
  1. se o lock está em dia (`uv lock --check`) e instala exatamente o que ele trava (`uv sync --locked`);
  2. ruff (lint e formatação) e import-linter, quando configurado (ADR-010);
  3. pyright, só avisando;
  4. os testes com pytest;
  5. se o título do PR segue Conventional Commits (ADR-009);
  6. que o repo não tenha cópia local de skills (ADR-005);
  7. segredos vazados, com o **gitleaks**.
- O gitleaks roda pela **CLI em container** (`ghcr.io/gitleaks/gitleaks:v8.24.3`), não pela `gitleaks-action`, porque a action exige licença paga em repos de organização.
- Cada repo Python terá um Dependabot (`package-ecosystem: uv`) propondo atualizações de dependências uma vez por semana, com os PRs agrupados.
- **CD:** por enquanto, só o deploy deste site no GitHub Pages. O destino de deploy do app será decidido na semana 6.

## Alternativas

- **Copiar o CI em cada repo:** cada correção precisaria ser feita várias vezes.
- **Manter pip com `requirements.txt`:** sem lock multiplataforma, o "funciona na minha máquina" volta.

## Consequências

- Os repos filhos recebem um PR cada para adotar isto: o `rag` remove os `requirements*`, troca o Dockerfile para `uv sync --frozen` e passa a chamar o workflow central; o `agents` troca o CI próprio pela chamada; os dois ganham o `dependabot.yml`.
- Mudou uma regra de CI? A mudança é feita uma vez no orquestrador e vale para todos.
- O próprio orquestrador também exige `uv.lock` no CI.
