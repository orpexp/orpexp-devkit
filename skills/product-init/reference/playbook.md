# {{PRODUCT_NAME}} — Development Playbook

This project was set up with the **orpexp-devkit** Claude Code plugin, which gives your agent a set
of role-based and workflow skills covering the full product lifecycle. If you're reading this, the
plugin is already installed — just run the skill you need inside Claude Code.

> **Ask your agent:** "What skill should I use to [task]?" — it will consult this file and guide you.

---

## Workflow Stages

| Stage | When | Skills |
|---|---|---|
| 0 · Init | New product or new requirement batch | `/product-init` |
| 1 · Define | Requirements, user stories, acceptance criteria | `/product-owner`, `/user-story` |
| 2 · Design | Architecture, UX, tech stack decisions | `/archetype`, `/architect`, `/designer`, `/design-review` |
| 3 · Build | Planning + implementation | `/build-plan`, `/frontend-dev`, `/backend-dev` |
| 4 · Review | Tests, code quality | `/webapp-testing`, `/code-review`, `qa-reviewer` + `spec-compliance` agents |
| 5 · Ship | Sprint planning, release notes, deployment | `/scrum-master`, `/build-plan` |

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
| Review code for quality and issues | `/code-review` |
| Check a story's implementation against its acceptance criteria | `qa-reviewer` agent ² |
| Check the code still matches documents/ (scope, ADRs, imports) | `spec-compliance` agent ² |
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

**New feature — Spec → Build:**
```
/product-owner  → "Define requirements for [feature]"
/architect      → "Design the system"
/build-plan     → "Generate the implementation plan"
/backend-dev    → "Implement the API"
/frontend-dev   → "Build the UI components"
```

**New product — Idea → First working version:**
```
/product-init   → paste raw idea notes
/product-owner  → refine requirements
/archetype      → apply an architecture profile from the team library (or skip if nothing fits)
/architect      → review/accept the proposed ADRs, or design the stack from scratch
/build-plan     → MVP implementation plan
```

**Ship a feature:**
```
/webapp-testing → write tests
/code-review    → review branch changes
/scrum-master   → release notes + deployment checklist
```
