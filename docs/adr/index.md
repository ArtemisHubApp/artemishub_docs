# Decisões de arquitetura (ADRs)

Cada decisão de arquitetura relevante é registrada aqui, com contexto, alternativas e consequências.

Para um ADR novo, copie o formato do [ADR-002](002-framework-multiagente.md) e use o próximo número livre, com 3 dígitos. Toda decisão que muda arquitetura, stack ou processo gera um ADR no mesmo PR da mudança (regra do `AGENTS.md` do [orquestrador](https://github.com/ArtemisHubApp/artemishub_orchestration)).

| ADR | Decisão | Status |
|---|---|---|
| [ADR-001](001-stack.md) | Stack: FastAPI e Postgres no backend, React no frontend, agentes como serviço separado | proposto |
| [ADR-002](002-framework-multiagente.md) | LangGraph + Langfuse para o sistema multiagente | proposto |
| [ADR-003](003-repo-orquestrador.md) | Repo orquestrador com submódulos | proposto |
| [ADR-004](004-agents-md-fonte-unica.md) | `AGENTS.md` como fonte única de regras para todos os agentes de IA | proposto |
| [ADR-005](005-sdd-superpowers.md) | SDD com Superpowers + `artemis-sdd`; skills só no orquestrador | proposto |
| [ADR-006](006-uv-e-ci-reutilizavel.md) | uv + `uv.lock` como única fonte de versões e CI reutilizável | proposto |
| [ADR-007](007-compose-de-desenvolvimento.md) | docker-compose como ambiente de desenvolvimento | proposto |
| [ADR-008](008-staging-e-worktrees.md) | Fluxo `staging → main` com worktrees | proposto |
| [ADR-009](009-higiene-github.md) | Higiene do GitHub: issue por tarefa, Conventional Commits, PR pequeno | proposto |
| [ADR-010](010-codigo-limpo-hexagonal.md) | Código limpo e clean architecture (hexagonal) com checagem no CI | proposto |
| [ADR-011](011-orquestrador-formata-resposta.md) | O orquestrador formata a resposta final, sem agente de Comunicação | aceito |
| [ADR-012](012-implantacao-e-pipelines-de-dados.md) | Implantação no Azure for Students com dados publicados como artefato (Airflow efêmero, DVC no DagsHub) | proposto |
