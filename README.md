# Claude Code Framework

A complete Claude Code plugin for software product development teams. Install once and get 13 skills, workflow guides, and a docs-first project scaffolder for every stage of your product lifecycle.

---

## What's in this repo

| Path | Purpose |
|---|---|
| [`CHANGELOG.md`](CHANGELOG.md) | Version history and release notes |
| [`docs/`](docs/) | Guides: Claude Code reference, workflow, agents, install & maintenance |
| [`.claude-plugin/`](.claude-plugin/) | Plugin manifest — enables `claude plugin install` |
| [`skills/`](skills/) | All 13 bundled skills (loaded automatically via the plugin) |
| [`global/`](global/) | Optional user-level config: `CLAUDE.md`, `settings.json` |

---

## Quick Start

### 1. Install the plugin

This repo is **private** — authenticate with GitHub first so Claude Code can access it:

```bash
# One-time GitHub auth (grant orpexp org access when prompted)
gh auth login
```

Then register the marketplace and install. The `marketplace add` step is a one-time setup that tells Claude Code where to find `orpexp-devkit`; without it, `plugin install` wouldn't know which source to pull from.

```bash
# Register the orpexp plugin source (one-time)
claude plugin marketplace add orpexp/orpexp-devkit

# Install the plugin — auto-loads all 13 skills
claude plugin install orpexp-devkit
```

Verify: open Claude Code and run `/help` — all skills should appear in the list.

### 2. Install external skills (optional)

Open Claude Code and run:

```
/setup-skills
```

Installs Anthropic's 5 official skills (`frontend-design`, `webapp-testing`, `mcp-builder`, `skill-creator`, `simplify`). No repo clone needed.

### 3. Start a new project

```bash
mkdir my-product && cd my-product
claude
```

Inside Claude Code, drop your idea notes into the conversation and run:

```
/product-init
"Here are my idea notes: [paste notes]"
```

This generates the full project structure (`CLAUDE.md`, `.ai/`, `documents/`, `platform/`) and extracts your notes into structured knowledge-base documents. No template to copy — the skill builds everything. No stack decisions yet — that comes via `/architect`.

### 4. Define → Design → Build

```
/product-owner   "Refine requirements and resolve open questions"
/archetype       "Apply an architecture profile from the team library"
/architect       "Decide the tech stack and system architecture"
/build-plan      "Generate the implementation plan for MVP"
/frontend-dev    "Build the [component]"
/backend-dev     "Implement the [API endpoint]"
```

### 5. Review & Ship

```
/webapp-testing  "Write tests for [feature]"
/code-review     (built-in — review current branch changes)
/scrum-master    "Plan this sprint" | "Write release notes"
```

---

## The Development Workflow

This framework maps to a repeatable product development cycle:

```
0. INIT        → /product-init    (scaffold knowledge base from idea notes)
1. DEFINE      → /product-owner   (requirements, acceptance criteria)
                 /user-story      (user stories from requirements)
2. DESIGN      → /archetype       (apply/save reusable architecture profiles)
                 /architect       (tech stack decisions, system design, ADRs)
                 /designer        (UI/UX review, Figma analysis)
                 /design-review   (extract components from screenshots)
3. BUILD       → /build-plan      (sequenced implementation plan)
                 /frontend-dev    (React/Next.js/Tailwind)
                 /backend-dev     (API, DB, server logic)
4. DELIVER     → /scrum-master    (sprint planning, retrospectives, release notes)
```

---

## Skills Reference

### Agent Skills (Role Personas)

| Skill | Invocation | Role |
|---|---|---|
| Product Owner | `/product-owner` | Requirements, user stories, backlog |
| Architect | `/architect` | System design, ADRs, tech stack |
| Frontend Dev | `/frontend-dev` | UI components, styling, state management |
| Backend Dev | `/backend-dev` | APIs, databases, auth, infrastructure |
| Designer | `/designer` | UI/UX review, component design |
| Scrum Master | `/scrum-master` | Sprint planning, retrospectives |

### Business Skills

| Skill | Invocation | Use Case |
|---|---|---|
| User Story | `/user-story` | Write and refine user stories from requirements |
| Design Review | `/design-review` | Analyze screenshots, Figma exports, mockups |

### Workflow Skills

| Skill | Invocation | Use Case |
|---|---|---|
| Product Init | `/product-init` | Scaffold a project knowledge base from raw idea notes |
| Archetype | `/archetype` | Apply or save reusable architecture profiles (team library) |
| Build Plan | `/build-plan` | Generate a sequenced implementation plan |
| Setup Skills | `/setup-skills` | Install Anthropic's 5 official external skills |
| Skill Creator | `/skill-creator` | Create new skills for this framework |

### From the Anthropic Skills Library

Install with `/setup-skills`:

| Skill | Source | Use Case |
|---|---|---|
| `frontend-design` | anthropics/skills | Build UI from design specs |
| `webapp-testing` | anthropics/skills | Write and run web app tests |
| `mcp-builder` | anthropics/skills | Build MCP server tools |
| `skill-creator` | anthropics/skills | Official Anthropic skill creator |
| `simplify` | anthropics/claude-code | Simplify complex code |

---

## Project Structure

Every project is generated by `/product-init` from your idea notes. It follows a docs-first, multi-repo-ready layout:

```
my-product/
├── CLAUDE.md               ← thin pointer: @.ai/AGENTS.md (auto-loaded by Claude Code)
├── README.md               ← human entry point
├── .ai/                    ← how to work in this repo
│   ├── AGENTS.md           ←   canonical agent context (behavioral rules, reading order)
│   ├── conventions.md      ←   the documents/ system rules
│   ├── platform-layout.md ←   the platform/ code architecture + import rules
│   └── playbook.md         ←   skills + workflow quick-reference (which skill for which task)
├── documents/              ← the knowledge base CONTENT (vision, scope, architecture, etc.)
│   ├── README.md           ←   index: "I need X → read Y" routing table
│   ├── inputs/             ←   ⭐ stakeholder input — READ-ONLY to agents
│   │   └── STAKEHOLDER-NOTES.md
│   ├── product/            ←   vision, scope, roadmap
│   ├── architecture/       ←   overview, data model, tech stack, ADRs
│   ├── operations/         ←   progress log, open questions, glossary
│   └── business/           ←   business model, legal/org
└── platform/               ← all application code (multi-repo-ready)
    ├── apps/               ←   client apps humans use (web, mobile)
    ├── services/           ←   deployable units: {compute}-{tech}-{name}
    ├── core/
    │   ├── contracts/      ←   compile-time vocabulary: types, schemas, interfaces (by domain)
    │   ├── adapters/       ←   domain capabilities with swappable implementations
    │   ├── server/         ←   runtime domain-agnostic server plumbing (http, env, logging)
    │   └── ui-components/  ←   runtime domain-agnostic presentation (design system, primitives)
    ├── data/               ←   database: migrations, client, types
    ├── ops/                ←   CI/CD, tooling [CODEOWNERS restricted]
    └── infra/              ←   infrastructure-as-code [CODEOWNERS restricted]
```

**Key principles:**
- Root stays clean: only `CLAUDE.md`, `README.md`, `.ai/`, `documents/`, `platform/`
- Stack is never pre-decided — `/architect` decides it after requirements are defined
- `platform/` sections can be lifted into independent repos with zero import changes
- `documents/inputs/` is the only file a stakeholder hand-edits — everything else is agent-derived

---

## Guides

- [Claude Code Guide](docs/00-claude-code-guide.md) — CLI commands, keyboard shortcuts, permission modes, tips
- [Getting Started](docs/01-getting-started.md) — Setup, first run, core concepts
- [Project Workflow](docs/02-project-workflow.md) — End-to-end product development with Claude Code
- [Commands by Stage](docs/03-commands-by-stage.md) — What to run at each phase
- [Agents Guide](docs/04-agents-guide.md) — How to use role-based agents effectively
- [Framework Improvements](docs/05-framework-improvements.md) — Review & roadmap for evolving this framework
- [Install & Maintenance](docs/06-install-and-maintenance.md) — Team onboarding, global config, factory reset

---

## For Teams

This repository is the single source of truth for your team's Claude Code configuration. The plugin installs from GitHub — no file copying needed.

**Keeping up to date:**
When a new version is pushed, teammates run one command inside Claude Code:
```
claude plugin update orpexp-devkit
```
Changes take effect immediately — no restart needed.

**Adding a new skill for your team:**
1. Create `skills/my-skill/SKILL.md` following the pattern in existing skills
2. Run `/skill-creator` inside Claude Code for guided skill authoring
3. Bump the version in `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
4. Commit and push — teammates pick it up with `claude plugin update orpexp-devkit`

**Project-level customization:**
Each project's `CLAUDE.md` at the project root is auto-loaded by Claude Code. Keep all substantive guidance in `.ai/AGENTS.md` and pull it in via `@.ai/AGENTS.md` inside the root `CLAUDE.md` — that is how `.ai/` content reaches Claude.
