---
origem: "Design do artemishub_orchestration (seções 6.3 e 6.6) · aprovado em 17/11/2026"
---

# ADR-005: SDD com Superpowers e skills só no orquestrador

- **Status:** proposto (aguardando aprovação do time)
- **Data:** 17/11/2026
- **Repo:** [artemishub_orchestration](https://github.com/ArtemisHubApp/artemishub_orchestration)

## Contexto

O time quer trabalhar com SDD (*spec-driven development*): primeiro se entende e se escreve o que será feito, depois se planeja, se testa e se implementa. Encontramos dois problemas:

- a skill `orchestrator`, copiada no `rag` e no `agents`, encaminha para cinco etapas (`grill`, `spec`, `test-evals`, `build`, `review-commit`) que **nunca foram escritas**, ou seja, o roteador apontava para o nada;
- as skills estavam **copiadas repo a repo**: três pastas no `rag` e uma no `agents`, que chegou num PR de 17/11.

## Decisão

- **Esteira de SDD:** o **Superpowers** (brainstorming → spec → plano → TDD → execução → revisão), que já é usado pelo time e está completo. Por cima dele, uma skill do projeto, **`artemis-sdd`**, com o que é só do Artemis:
  - o tamanho da tarefa (S0 a S3) decide quanto processo ela leva;
  - **toda tarefa tem uma issue associada**;
  - todo trabalho começa numa worktree criada a partir da `staging`;
  - spec e plano ficam no repo do submódulo, em `docs/superpowers/`;
  - **docs sempre atualizadas** no mesmo PR, com ADR quando couber;
  - um checklist de PR.
- **Como cada agente recebe o Superpowers:**
  - **Claude:** pelo plugin oficial (`superpowers@claude-plugins-official`), habilitado no `.claude/settings.json` do orquestrador;
  - **Codex, Gemini e GPT:** por uma cópia única em `.agents/skills/`, com a origem registrada em `skills-lock.json`.
- A **fonte editável** da `artemis-sdd` é `.agents/skills/artemis-sdd/`. O script `scripts/sync_skills.py` gera a cópia em `.claude/skills/`, sem links simbólicos, porque eles quebram no Windows. O CI falha se as duas cópias divergirem.
- **Skills só no orquestrador:** o CI compartilhado (ADR-006) tem o passo `no-local-skills`, que falha se um repo filho tiver `.claude/skills`, `.agents/skills`, `agent/skills` ou `skills-lock.json`. Skill nova entra por PR no orquestrador.
- A `orchestrator` antiga é **aposentada**. A ideia útil dela, classificar a tarefa por tamanho e risco, passou para a `artemis-sdd`.

## Alternativas

- **Escrever as cinco etapas que faltam e manter a `orchestrator`:** ficaria mais sob medida, mas são várias skills para escrever e manter com poucas semanas de roadmap pela frente.
- **Instalar o Superpowers só como plugin:** só o Claude enxergaria. Os outros agentes ficariam sem as regras.

## Consequências

- Os repos `rag` e `agents` recebem um PR que remove as cópias de skills. Depois disso, o CI impede que elas voltem.
- Atualizar o Superpowers é um PR no orquestrador, que troca a cópia e o `skills-lock.json`.
