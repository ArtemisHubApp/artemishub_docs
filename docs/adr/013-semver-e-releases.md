---
origem: "Revisão do versionamento antes da entrega ao professor (27/11/2026) · artemishub_orchestration#30"
---

# ADR-013: releases em SemVer, com nome e notas gerados dos PRs

- **Status:** proposto
- **Data:** 27/11/2026
- **Issues:** [artemishub_orchestration#30](https://github.com/ArtemisHubApp/artemishub_orchestration/issues/30), [artemishub_docs#57](https://github.com/ArtemisHubApp/artemishub_docs/issues/57)

## Contexto

O [ADR-008](008-staging-e-worktrees.md) definiu o fluxo `staging → main`, com um PR `release: <data>` para cada entrega. Faltava dizer o que é uma release no GitHub. Em 27/11, as duas primeiras releases do orquestrador saíram como `v2026.11.27` e `v2026.11.27b`:
- o nome da release era igual à tag;
- as notas não tinham padrão;
- o sufixo `b` não segue nenhuma convenção;
- uma das tags nem apontava para a `main`.

O professor avalia o versionamento dos repositórios, e cada repo fazia (ou não fazia) releases do seu jeito.

## Decisão

Releases em **SemVer** (`vX.Y.Z`), iguais nos 6 repositórios, criadas por um workflow reutilizável do orquestrador (`release-reutilizavel.yml`), que roda quando o PR `release:` é mesclado na `main`.

| Item | Regra |
|---|---|
| **Tag** | `vX.Y.Z`, começando em `v0.1.0` e sempre apontando para a `main`. A `1.0.0` será a versão entregue ao fim do semestre. |
| **Versão** | Calculada a partir dos títulos dos PRs desde a release anterior, em Conventional Commits: `feat!:` ou `BREAKING CHANGE` sobe o major (antes da `1.0.0`, o minor); algum `feat:` sobe o minor; o resto (`fix`, `docs`, `ci`, `chore`, `refactor`, `test`) sobe o patch. |
| **Nome** | `vX.Y.Z · <tema>`, com o tema do título do PR de release (`release: <tema>`). |
| **Notas** | Seções Novidades (`feat`), Correções (`fix`), Documentação (`docs`), CI e manutenção (`ci`, `chore`, `refactor`, `test`) e Outros. Cada linha traz o título, o número do PR e a autora. No fim, o link de comparação com a versão anterior. |

A lógica fica em `scripts/release.py` do orquestrador, com testes. Cada repo filho tem só um `release.yml` pequeno que chama o workflow reutilizável. Notas não se editam à mão: se faltar algo, corrige-se o título do PR, e por isso o título em Conventional Commits passa a importar também para a release.

## Alternativas

- **CalVer (`vAAAA.MM.DD`):** combina com entregas semanais, mas não diz se a release traz algo novo ou só correções, e precisa de um sufixo inventado quando sai mais de uma no mesmo dia. Foi o que se usou em 27/11.
- **Notas automáticas do GitHub (`--generate-notes`):** agrupam só por label, e os nossos PRs não têm label. Sairia uma lista única, sem seções.
- **Release manual pela interface:** foi o que falhou em 27/11 (tag fora da `main`, release não publicada). Agentes na nuvem também não conseguem criar releases diretamente, mas conseguem disparar um workflow.

## Consequências

- Um PR com título fora de Conventional Commits vai para a seção "Outros" e não sobe a versão como deveria.
- As releases de 27/11 do orquestrador foram recriadas como `v0.1.0` e `v0.2.0`.
- Os repos filhos passam a ter releases quando mesclarem o primeiro PR `release:` depois de adotar o workflow.
- O workflow reutilizável é chamado pela `main` do orquestrador (`@main`): uma mudança nele só vale para os outros repos depois de uma release do orquestrador.

## Fontes

- [Semantic Versioning 2.0.0](https://semver.org/lang/pt-BR/)
- [Conventional Commits 1.0.0](https://www.conventionalcommits.org/pt-br/v1.0.0/)
- [ADR-008](008-staging-e-worktrees.md) e [ADR-009](009-higiene-github.md)
