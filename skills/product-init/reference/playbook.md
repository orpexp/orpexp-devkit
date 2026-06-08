# {{PRODUCT_NAME}} — Development Playbook

Quick reference: which Claude Code skill to use at each stage of development.
Use this when you or a teammate asks "what should I run for X?"

---

## Workflow Stages

| Stage | When | Skills |
|---|---|---|
| 0 · Init | New product or new requirement batch | `/product-init` |
| 1 · Define | Requirements, user stories, acceptance criteria | `/product-owner`, `/user-story` |
| 2 · Design | Architecture, UX, tech stack decisions | `/architect`, `/designer`, `/design-review` |
| 3 · Build | Planning + implementation | `/build-plan`, `/frontend-dev`, `/backend-dev` |
| 4 · Review | Tests, code quality | `/webapp-testing`, `/code-review` |
| 5 · Ship | Sprint planning, release notes, deployment | `/scrum-master`, `/build-plan` |

---

## "I need to…" Quick Lookup

| Task | Skill |
|---|---|
| Turn raw notes into a structured project | `/product-init` |
| Write or refine user stories | `/user-story` |
| Decide the tech stack | `/architect` |
| Review a Figma or screenshot for components | `/design-review` |
| Build a UI from a design spec | `/frontend-design` ¹ |
| Plan implementation steps for a feature | `/build-plan` |
| Build a React/Next.js component | `/frontend-dev` |
| Build an API, database model, or auth flow | `/backend-dev` |
| Review code for quality and issues | `/code-review` |
| Write automated tests | `/webapp-testing` ¹ |
| Build a new MCP server tool | `/mcp-builder` ¹ |
| Simplify or refactor complex code | `/simplify` ¹ |
| Plan a sprint or write release notes | `/scrum-master` |
| Create a new skill for this framework | `/skill-creator` ¹ |

¹ External skill — install once with `/setup-skills` before first use.

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
/architect      → decide tech stack
/build-plan     → MVP implementation plan
```

**Ship a feature:**
```
/webapp-testing → write tests
/code-review    → review branch changes
/scrum-master   → release notes + deployment checklist
```
