---
origem: "Design do artemishub_orchestration (seções 3 e 6.2) · aprovado em 17/11/2026"
---

# ADR-004: AGENTS.md como fonte única de regras para todos os agentes

- **Status:** proposto (aguardando aprovação do time)
- **Data:** 17/11/2026
- **Repo:** [artemishub_orchestration](https://github.com/ArtemisHubApp/artemishub_orchestration)

## Contexto

Cada integrante do grupo usa um agente diferente: **Codex, Gemini, Claude e GPT**. Cada ferramenta lê um arquivo de instruções diferente (`AGENTS.md`, `GEMINI.md`, `CLAUDE.md`), e quem usa o ChatGPT no navegador não tem acesso ao repo. Se cada agente tiver o seu arquivo, as regras divergem em poucas semanas.

## Decisão

- O **`AGENTS.md`** na raiz do orquestrador é a única fonte das regras. Ele traz:
    - o que é o Artemis;
    - o mapa dos repos;
    - a regra de ouro: antes de mexer no repo X, ler o contexto de X;
    - as regras de SDD, de branches e worktrees, de higiene do GitHub e de código limpo;
    - a regra de ADR;
    - kanban, segurança e cuidados com submódulos.
- **`CLAUDE.md`** e **`GEMINI.md`** têm uma única linha, `@AGENTS.md`, que importa o conteúdo. Não há texto duplicado.
- O Codex lê o `AGENTS.md` direto.
- Quem usa GPT pelo navegador anexa o `AGENTS.md` na conversa. O README do orquestrador explica como.
- O `AGENTS.md` tem no máximo 250 linhas, e um teste do orquestrador garante as seções e frases obrigatórias.
- **Nada essencial depende de recurso exclusivo de uma ferramenta.** O hook do Claude Code, que avisa para ler o contexto do submódulo, e o plugin do Superpowers são extras.

## Alternativas

- **Um arquivo por agente**, com o mesmo conteúdo copiado: diverge com o tempo, e cada mudança precisa ser feita quatro vezes.
- **Regras só nos READMEs dos repos:** os agentes não leem o README como instrução, e as regras gerais ficariam espalhadas.

## Consequências

- Mudou uma regra? É um PR no orquestrador e vale para todos os agentes no próximo `sync`.
- Se a versão do Gemini CLI de alguém não aceitar o `@AGENTS.md`, a alternativa é apontar o Gemini direto para o `AGENTS.md` pelo `.gemini/settings.json`. Isso ainda falta testar na máquina de quem usa Gemini.
- Cada repo filho ganha um `AGENTS.md` curto, que diz como rodar e testar aquele repo e manda ler as regras gerais no orquestrador. Isso entra nos PRs de cada repo.
