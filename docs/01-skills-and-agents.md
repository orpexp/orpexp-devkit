# Skills & Agents

Who does what in this framework, and when to use which. Stage-by-stage prompts live in the
[Product Workflow](../skills/product-init/reference/guides/product-workflow.md); each skill documents itself in depth in its own
`skills/<name>/SKILL.md`.

---

## Why roles?

Without a role, Claude gives generalist answers. With one, it adopts that role's reasoning,
priorities, questions, and output formats. *"How should I structure the database?"* gets you
generic advice; `/architect` gets you schema options with trade-off analysis, normalization
decisions, and migration considerations.

---

## Skills vs subagents

| | Role skills (`/architect`, …) | Subagents (`agents/`) |
|---|---|---|
| What it does | Changes the **current conversation's** perspective and vocabulary | Spawns a **separate agent** with its own context window and tool permissions |
| Best for | Interactive work: deciding, discussing, iterating with you | Bounded, delegable tasks: "review this", "verify that", "build this whole feature" |
| Context | Shares everything already in your session | Starts fresh — gets only what its prompt and the repo give it |
| How to invoke | Type the slash command | Ask Claude to use it ("have the qa-reviewer check this story") or let Claude delegate proactively |

**Rule of thumb:** if you want to *think together*, use a skill. If you want *finished work back*,
delegate to an agent.

---

## The 14 skills

| Skill | Stage | One-liner |
|---|---|---|
| `/product-init` | Init | Scaffold + sync the `documents/` knowledge base from stakeholder notes |
| `/product-owner` | Define | Requirements, MVP scoping, prioritization, acceptance criteria |
| `/user-story` | Define | Write, split, and map user stories (INVEST, Given/When/Then) |
| `/business-advisor` | Define | Incubator-style mentor: idea validation, business model, pricing, unit economics |
| `/archetype` | Blueprints | Apply or save reusable architecture profiles from the team library |
| `/architect` | Blueprints | System design, data modeling, ADRs, the API-First contract |
| `/build-plan` | Backend & Infra | Sequenced implementation plans, migration + deployment checklists |
| `/backend-dev` | Backend & Infra | APIs, databases, auth, queues — interactive pairing |
| `/designer` | UI/UX Draft + Design | UX/UI review, flows, design systems, accessibility audits |
| `/frontend-dev` | UI/UX Draft + Design | React/Next.js components, state, styling — interactive pairing |
| `/design-review` | UI/UX Design | Extract components + interactions from screenshots/Figma exports |
| `/scrum-master` | Ship | Sprint planning, retrospectives, release notes, post-mortems |
| `/setup-skills` | Meta | Install Anthropic's 5 external skills (`frontend-design`, `webapp-testing`, `mcp-builder`, `skill-creator`, `simplify`) |
| `/skill-creator` | Meta | Create a new skill for this framework |

Each skill's `SKILL.md` carries its full perspective, workflows, output templates, and guardrails —
that's the source of truth, not this table.

## The 8 subagents

| Agent | Use case | Tools |
|---|---|---|
| `qa-reviewer` | Review implemented code against acceptance criteria + conventions | Read-only |
| `spec-compliance` | Detect drift between `documents/` (spec) and `platform/` (code): scope, Accepted ADRs, allowed-imports matrix | Read-only |
| `security-reviewer` | OWASP/threat pass against the product's stated security model | Read-only |
| `frontend-builder` | Build a complete, polished UI feature from a spec or design | Full |
| `backend-builder` | Build a complete backend feature per ADRs + platform-layout | Full |
| `test-engineer` | Write + run tests derived from acceptance criteria | Test files only |
| `progress-tracker` | Progress-log upkeep + status reports (the PM tracking function) | `documents/operations/` only |
| `devops-engineer` | CI/CD pipelines + IaC scaffolding (plan/synth only, never applies) | Ops/infra paths |

**Roles that deliberately stay skills, not agents:** the *stakeholder* is a human (an agent
simulating one would invent requirements — forbidden by the framework's extraction rules);
*product owner* and *solutions architect* are decision-heavy, interactive roles that need you in
the loop (`/product-owner`, `/architect`, `/archetype` — the architect's delegable review half is
already `spec-compliance`); *release manager* is covered by `/scrum-master`.

---

## Chaining roles across a feature

The power is in the sequence, with handoffs through `documents/` (never conversation memory):

```
/product-owner → requirements        → documents/product/02-scope.md
/user-story    → stories + criteria  → documents/product/user-stories.md
/architect     → design + ADRs       → documents/architecture/
/build-plan    → task sequence
backend-builder + frontend-builder   → platform/ (delegated implementation)
test-engineer  → tests; qa-reviewer + security-reviewer → findings
/scrum-master  → release notes; progress-tracker → progress log
```

Two useful moves inside a chain:
- **Switch perspective mid-conversation** — finish with `/architect`, then `/frontend-dev "given
  that architecture, how should I structure the component tree?"`.
- **Let roles challenge each other** — `/product-owner "the architect proposes a job queue for
  every background task. Is this over-engineering at our scale?"`.

---

## Anti-patterns

- **Don't use roles for trivial tasks** — `/architect` to rename a variable is overkill; roles are
  for decisions and deliverables.
- **Don't chain stages through conversation memory** — write each stage's output to `documents/`
  and have the next stage read it.
- **Don't let a role's perspective override reality** — if the proposal is too complex for your
  team, say so and ask for the simpler version that still solves the core problem.
- **Don't skip Define** — even solo, ten minutes with `/product-owner` before building saves hours
  of rework.
