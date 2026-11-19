---
origem: "Design do artemishub_orchestration (seções 6.2 e 6.11) · aprovado em 17/11/2026"
---

# ADR-009: higiene do GitHub e rastreabilidade

- **Status:** proposto (aguardando aprovação do time)
- **Data:** 17/11/2026
- **Repo:** [artemishub_orchestration](https://github.com/ArtemisHubApp/artemishub_orchestration)

## Contexto

Em 17/11/2026 nenhum repo tinha template de issue ou de PR. Havia **19 branches já mergeadas** que nunca foram apagadas (9 no `rag`, 5 no `agents`, 5 no `docs`), e uma delas tinha nome gerado automaticamente por agente (`claude/optimistic-meitner-8yac2i`). Sem padrão, fica difícil saber por que uma mudança foi feita e onde ela foi discutida.

## Decisão

Regras para pessoas e agentes, escritas no `AGENTS.md` do orquestrador:

1. **Toda tarefa tem uma issue associada.** Não há código, doc ou configuração sem issue no kanban. A branch leva o número da issue (`feat/<nº>-…`) e o PR fecha a issue com `Closes #<nº>`. Se a issue não existir, o agente cria ou pede antes de começar.
2. **Docs sempre atualizadas** quando algo relevante muda (comportamento, comando, configuração, arquitetura, dependência). O README ou o `AGENTS.md` do repo, este site e um ADR, quando couber, são atualizados no mesmo PR. Se a mudança altera algo que **este site (GitHub Pages)** descreve, abre-se também um PR aqui no `artemishub_docs`, e os dois PRs citam um ao outro. O site publica a partir da `main`. Um PR que muda algo relevante sem tocar em doc precisa dizer por quê.
3. **Uma issue, uma branch, um PR.** Branches com nome automático (`claude/…`, `codex/…`) são renomeadas antes do PR.
4. **Commits e títulos de PR no padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/)** (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `ci:` e `release:`), em português depois dos dois-pontos. O CI confere o título do PR.
5. **Merge:** squash nos PRs para `staging`, de modo que o título do PR vira o commit. A release `staging → main` usa merge commit.
6. **PR pequeno:** idealmente menos de cerca de 400 linhas alteradas, sem contar lockfiles e dados. Abra como *draft* enquanto estiver em andamento.
7. **Nunca** dar `push --force` em `staging` ou `main`, nem commitar `.env`, dados pessoais reais ou arquivos grandes fora do DVC.
8. **Depois do merge,** a branch é apagada automaticamente (configuração do repo, que um admin liga em cada um) e a worktree é limpa com `prune` (ADR-008).

**Onde ficam os templates:** num repo `ArtemisHubApp/.github`. É o jeito do próprio GitHub de aplicar os mesmos templates a todos os repos da org, sem copiar arquivo em cada um. Ele terá:

- formulários de issue (feature, bug, tarefa e documentação, com os campos *Semana*, *Critérios de aceite* e *Repo afetado*);
- um template de PR com checklist;
- labels padrão (`semana-N`, `prioridade: …`, `tipo: …`);
- um CODEOWNERS por repo, preenchido pelo time.

## Alternativas

- **Templates copiados em cada repo:** seria a mesma armadilha das skills copiadas (ADR-005).
- **Só combinar no grupo, sem CI:** as regras se perdem na correria das entregas.

## Consequências

- Uma faxina inicial: `python scripts/branches.py` lista as branches mergeadas, e `--delete` apaga, com confirmação, só as que comprovadamente entraram na base.
- O repo `.github` e as labels são o Plano 3 do orquestrador.
