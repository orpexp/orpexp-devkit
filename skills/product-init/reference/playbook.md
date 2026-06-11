# {{PRODUCT_NAME}} — Development Playbook

This project was set up with the **orpexp-devkit** Claude Code plugin, which gives your agent a set
of role-based and workflow skills covering the full product lifecycle. If you're reading this, the
plugin is already installed — just run the skill you need inside Claude Code.

> **Ask your agent:** "What skill should I use to [task]?" — it will consult this file and guide you.

---

## Workflow Stages

Backend before frontend; the API-First contract (written at Blueprints) is the gate. Full guide:
[`guides/product-workflow.md`](guides/product-workflow.md).

| Stage | When | Skills & agents |
|---|---|---|
| 0 · Init | New product or new requirement batch | `/product-init` |
| 1 · Define | Requirements, user stories, acceptance criteria | `/product-owner`, `/user-story` |
| 2 · Blueprints | Architecture, data model, tech stack, **API-First contract** | `/archetype`, `/architect` |
| 3 · Backend & Infra | Implement the API per the contract + CI/CD | `/build-plan`, `/backend-dev`, `backend-builder` + `devops-engineer` agents |
| 4 · UI/UX Draft | Low-fi working layouts against the real API — validate flows, no polish | `/designer`, `frontend-builder` agent (draft fidelity) or `/frontend-dev` |
| 5 · UI/UX Design | The formal, high-quality frontend | `/design-review`, `/designer`, `frontend-builder` agent |
| 6 · Review | Tests, code quality, security, spec drift | `/webapp-testing`, `/code-review`, `test-engineer` + `qa-reviewer` + `security-reviewer` + `spec-compliance` agents |
| 7 · Ship | Deployment, release notes, progress log | `/scrum-master`, `/build-plan`, `devops-engineer` + `progress-tracker` agents |

---

## "I need to…" Quick Lookup

| Task | Skill |
|---|---|
| Turn raw notes into a structured project | `/product-init` |
| Write or refine user stories | `/user-story` |
| Apply a known architecture profile from the team library | `/archetype` |
| Decide the tech stack (or design a novel architecture) | `/architect` |
| Save this product's architecture for future products | `/archetype` (EXTRACT) |
| Review a Figma or screenshot for components | `/design-review` |
| Build a UI from a design spec | `/frontend-design` ¹ |
| Plan implementation steps for a feature | `/build-plan` |
| Build a React/Next.js component | `/frontend-dev` |
| Delegate a whole UI feature (built + polished, all states) | `frontend-builder` agent ² |
| Build an API, database model, or auth flow | `/backend-dev` |
| Delegate a whole backend feature (API + data + tests) | `backend-builder` agent ² |
| Write automated tests from a story's acceptance criteria | `test-engineer` agent ² |
| Review code for quality and issues | `/code-review` |
| Check a story's implementation against its acceptance criteria | `qa-reviewer` agent ² |
| Run a security pass before a release | `security-reviewer` agent ² |
| Check the code still matches documents/ (scope, ADRs, imports) | `spec-compliance` agent ² |
| Set up or speed up CI/CD; scaffold infrastructure-as-code | `devops-engineer` agent ² |
| Update the progress log / get a status report | `progress-tracker` agent ² |
| Write automated tests | `/webapp-testing` ¹ |
| Build a new MCP server tool | `/mcp-builder` ¹ |
| Simplify or refactor complex code | `/simplify` ¹ |
| Plan a sprint or write release notes | `/scrum-master` |
| Create a new skill for this framework | `/skill-creator` ¹ |

¹ External skill — install once with `/setup-skills` before first use.
² Subagent (bundled with the plugin) — ask your agent to use it: "have the qa-reviewer check this story".

---

## External Skills (Anthropic Official)

Install all five with one command inside Claude Code:

```
/setup-skills
```

| Skill | When to use |
|---|---|
| `/frontend-design` | Build UI components directly from design specs or mockups |
| `/webapp-testing` | Write and run automated tests for web apps |
| `/mcp-builder` | Scaffold and build MCP server tools |
| `/simplify` | Simplify and refactor complex or tangled code |
| `/skill-creator` | Create a new skill for this framework (guided) |

---

## Common Chains

**New feature — Spec → Build (backend first):**
```
/product-owner    → "Define requirements for [feature]"
/architect        → "Design the system + extend the API contract (api-spec.md)"
/build-plan       → "Generate the implementation plan: data → API → draft UI → formal UI"
backend-builder   → "Implement the API per the contract"
frontend-builder  → "DRAFT screens against the real API" … then "upgrade to the formal design"
```

**New product — Idea → First working version:**
```
/product-init   → paste raw idea notes
/product-owner  → refine requirements
/archetype      → apply an architecture profile from the team library (or skip if nothing fits)
/architect      → review/accept the proposed ADRs + write the API-First contract
/build-plan     → MVP implementation plan (backend & infra before frontend)
```

**Ship a feature:**
```
/webapp-testing → write tests
/code-review    → review branch changes
/scrum-master   → release notes + deployment checklist
```
