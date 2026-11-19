---
origem: "Design do artemishub_orchestration (seções 1, 4, 6.1 e 6.5) · aprovado em 17/11/2026"
---

# ADR-003: repo orquestrador com submódulos

- **Status:** proposto (aguardando aprovação do time)
- **Data:** 17/11/2026
- **Repo:** [artemishub_orchestration](https://github.com/ArtemisHubApp/artemishub_orchestration)

## Contexto

O Artemis tem cinco repositórios, e a equipe programa com agentes de IA (vibecoding). Até agora:

- nenhum repo tinha um arquivo de instruções para agentes, então cada sessão de IA começava sem saber o que é o Artemis nem como os repos se ligam;
- as regras de desenvolvimento estavam copiadas dentro de repos de código (três cópias no `rag` e uma no `agents`), e cada repo novo copiava de novo;
- para trabalhar em mais de um repo, cada pessoa clonava e organizava as pastas do seu jeito.

## Decisão

Criar o **`artemishub_orchestration`**, um repositório "guarda-chuva" sem código de aplicação, inspirado no orquestrador do time da Kyte:

- os cinco repos entram como **submódulos**, ou seja, o orquestrador guarda só um ponteiro para cada repo, e o código continua em cada um;
- ele é a **fonte única** das regras para agentes (`AGENTS.md`, ADR-004) e das skills de SDD (ADR-005);
- traz scripts em Python que funcionam igual no Windows, macOS e Linux: `setup.py`, `sync.py`, `status.py`, `worktree.py` e `branches.py`;
- hospeda o CI reutilizável (ADR-006) e o compose de desenvolvimento (ADR-007).

Um clone e um comando deixam tudo pronto:

```bash
git clone --recurse-submodules https://github.com/ArtemisHubApp/artemishub_orchestration.git
python scripts/setup.py
```

## Alternativas

| Abordagem | Ganho | Custo | Decisão |
|---|---|---|---|
| **A. Repo novo com submódulos** | Um clone traz tudo; regras num lugar só | A equipe aprende o básico de submódulo | **Escolhida** |
| B. Transformar o `artemishub_docs` no orquestrador | Reaproveita o repo central | Mistura o site MkDocs com submódulos e código; o CI de docs fica frágil | Descartada |
| C. Só um plugin de skills, sem submódulos | Regras chegam a quem abre qualquer repo sozinho | Some a visão "tudo junto"; cada agente instala de um jeito | Descartada |

## Consequências

- **PR de feature nunca vai para o orquestrador:** vai para o repo do submódulo. O orquestrador só recebe mudanças de regras, scripts, skills e CI.
- O ponteiro gravado para cada submódulo é só informativo, porque os scripts levam cada repo para a branch base (`staging`, ADR-008). Atualizar o ponteiro é um commit `chore: bump submodules` quando alguém quiser.
- Depois de um `sync`, o `git status` do orquestrador mostra os submódulos com "new commits". Não é para commitar isso sem querer.
- O `docker-compose` e o CI ficam centralizados, o que reduz a duplicação entre repos.
