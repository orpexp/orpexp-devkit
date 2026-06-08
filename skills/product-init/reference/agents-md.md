# AGENTS.md — working context for {{PRODUCT_NAME}}

> **Read this first, every session.** This file is the canonical, tool-agnostic context for anyone —
> **human or AI agent** — working in this repository. It is not Claude-specific; the root `CLAUDE.md`
> simply imports it so Claude Code picks it up automatically.
>
> This `.ai/` folder holds **how to work in this repo**; [`../documents/`](../documents/) holds the
> **content** (the product knowledge base).

---

## 1. What this project is

**{{PRODUCT_NAME}}** — {{ONE_LINE_PITCH}}

**Industry:** {{INDUSTRY}}
**Stage:** {{STAGE}}
**Target user:** {{TARGET_USER}}

For the full picture, read the knowledge base — start at its index,
[`../documents/README.md`](../documents/README.md).

---

## 2. Reading order

Stop once you have enough context for the task at hand:

1. **This file** (`.ai/AGENTS.md`) — how to behave here.
2. [`../documents/README.md`](../documents/README.md) — the knowledge-base index; routes you to the right doc.
3. [`../documents/operations/open-questions.md`](../documents/operations/open-questions.md) — unresolved decisions; surface relevant ones before acting.
4. [`../documents/operations/01-progress.md`](../documents/operations/01-progress.md) — current state.
5. The task-specific doc the index points you to.

The rules behind the layout: [`conventions.md`](conventions.md) (docs system) and
[`platform-layout.md`](platform-layout.md) (code under `platform/`).

---

## 3. Behavioral rules

### Always
- **Respect doc ownership.** Each doc's front-matter has `owner: stakeholder | agent`. Maintain
  `agent`-owned docs freely from the notes; for `stakeholder`-owned docs, *propose* changes rather
  than overwriting.
- **Treat `documents/inputs/` as read-only.** It is the stakeholder's territory — never edit
  `STAKEHOLDER-NOTES.md` or any dropped artifact. You derive *from* it, not *into* it.
- **Mark every gap.** Unknowns become `> [OPEN QUESTION: …]`; chosen defaults become
  `> [ASSUMPTION: …]`. Add real unknowns to
  [`../documents/operations/open-questions.md`](../documents/operations/open-questions.md).
  **Never invent facts.**
- **Keep state current.** When you complete or change something, append a dated line to
  [`../documents/operations/01-progress.md`](../documents/operations/01-progress.md) and bump
  `last_updated` on any doc you edit.
- **Record decisions as ADRs.** A resolved question becomes a new file under
  [`../documents/architecture/decisions/`](../documents/architecture/decisions/) — not a buried
  prose edit.
- **Use glossary terms** ([`../documents/operations/02-glossary.md`](../documents/operations/02-glossary.md))
  consistently; don't introduce synonyms for defined terms.

### Never
- Edit anything under `documents/inputs/`.
- Commit secrets, credentials, or API keys.
- Duplicate a fact across docs — state it once in its owning doc and link to it.
- Make architectural decisions silently — record them as an ADR and, if they affect `platform/`
  code, confirm with the stakeholder first.

---

## 4. Tech stack

> [OPEN QUESTION: tech stack not yet decided — to be determined via `/architect`.
> See [`../documents/architecture/03-tech-stack.md`](../documents/architecture/03-tech-stack.md).]

---

## 5. Updating the spec from new ideas

When the stakeholder adds a requirement to
[`../documents/inputs/STAKEHOLDER-NOTES.md`](../documents/inputs/STAKEHOLDER-NOTES.md):

1. Run `/product-init` (SYNC mode) to propagate it into the derived docs.
2. Use `/product-owner` to review and refine requirements.
3. Use `/user-story` to produce implementation-ready user stories.
4. Use `/architect` to update architecture docs if the new requirement changes the design.

---

## 6. Framework skills available

These Claude Code skills are available for work in this project:

| Stage | Skill | Purpose |
|---|---|---|
| Define | `/product-owner` | Requirements, backlog, acceptance criteria |
| Define | `/user-story` | Write and split user stories |
| Design | `/architect` | Tech stack decisions, system design, ADRs |
| Design | `/designer` | UX/UI review, component specs |
| Design | `/design-review` | Analyze Figma exports and screenshots |
| Build | `/frontend-dev` | React/Next.js components, styling |
| Build | `/backend-dev` | APIs, database, auth, infrastructure |
| Build | `/build-plan` | Step-by-step implementation plans |
| Deliver | `/scrum-master` | Sprint planning, retrospectives, release notes |
