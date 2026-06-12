# Claude Code Framework

A complete Claude Code plugin for software product development teams. Install once and get 14 skills, 8 subagents, workflow guides, and a docs-first project scaffolder for every stage of your product lifecycle.

---

## What's in this repo

| Path | Purpose |
|---|---|
| [`CHANGELOG.md`](CHANGELOG.md) | Version history and release notes |
| [`docs/`](docs/) | Guides: Claude Code reference, workflow, agents, install & maintenance |
| [`.claude-plugin/`](.claude-plugin/) | Plugin manifest — enables `claude plugin install` |
| [`skills/`](skills/) | All 14 bundled skills (loaded automatically via the plugin) |
| [`agents/`](agents/) | 8 bundled subagents — reviewers (qa, spec, security), builders (frontend, backend, devops), test-engineer, progress-tracker |
| [`hooks/`](hooks/) | Guardrail hook: blocks agent writes under `documents/inputs/` (stakeholder-only) |
| [`global/`](global/) | Optional user-level config: `CLAUDE.md`, `settings.json` |

---

## Quick Start

### 1. Install the plugin

```bash
gh auth login                                          # one-time — this repo is private; grant orpexp org access
claude plugin marketplace add orpexp/orpexp-devkit     # one-time — register the plugin source
claude plugin install orpexp-devkit@orpexp             # loads all 14 skills + 8 agents + guardrail hook
```

Verify: open Claude Code and run `/help` — all skills should appear. Full details (prerequisites, fallbacks, team onboarding): [Install & Maintenance](docs/02-install-and-maintenance.md).

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

### 4. Work the stages

```
/product-owner   "Refine requirements and resolve open questions"
/archetype       "Apply an architecture profile from the team library"
/architect       "Accept the ADRs and write the API-First contract"
/build-plan      "Implementation plan: data → API → infra → draft UI → formal UI"
```
Then delegate: `backend-builder` implements the API, `devops-engineer` sets up CI/CD,
`frontend-builder` drafts the UI against the real API and later upgrades it to the formal design.

### 5. Review & Ship

```
test-engineer / qa-reviewer / security-reviewer / spec-compliance   (agents — tests + checks)
/code-review     (built-in — review current branch changes)
/scrum-master    "Plan this sprint" | "Write release notes"
progress-tracker (agent — log progress, status reports)
```

---

## Using the framework: the 8-stage workflow

Every product moves through the same stages. The core strategy: **backend before frontend** —
the API-First contract written at Blueprints is the gate, the backend implements it, and the UI
(draft first, formal design second) is just one consumer of it. This keeps the backend organized
and the product open to third-party/B2B integration from day one.

```
0. INIT            /product-init                    scaffold the knowledge base from idea notes
1. DEFINE          /product-owner /user-story       requirements, stories, acceptance criteria
                   /business-advisor                business model, pricing, idea validation
2. BLUEPRINTS      /archetype /architect            architecture, data model, ADRs + the
                                                    API-First contract (api-spec.md)
3. BACKEND & INFRA backend-builder /backend-dev     implement the API per the contract;
                   devops-engineer                  CI/CD + staging from day one
4. UI/UX DRAFT     /designer + frontend-builder     low-fi working layouts against the REAL API —
                                                    validate flows and the contract, no polish
5. UI/UX DESIGN    /design-review /designer         the formal, high-quality frontend;
                   frontend-builder                 design system in core/ui-components
6. REVIEW          test-engineer qa-reviewer        tests, story review, security, spec drift
                   security-reviewer spec-compliance
7. SHIP            devops-engineer /scrum-master    deploy, release notes, progress log
                   progress-tracker
```

**The handoff rule:** each stage writes its output into `documents/`, and the next stage reads it
from there — never rely on conversation memory between stages.

The full stage-by-stage guide (with prompts per stage) is
[product-workflow.md](skills/product-init/reference/guides/product-workflow.md) — and it ships
inside every workspace at `.ai/guides/product-workflow.md`, so your teammates always have it at hand.

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
| Business Advisor | `/business-advisor` | Idea validation, business model, pricing, unit economics |
| Design Review | `/design-review` | Analyze screenshots, Figma exports, mockups |

### Workflow Skills

| Skill | Invocation | Use Case |
|---|---|---|
| Product Init | `/product-init` | Scaffold a project knowledge base from raw idea notes |
| Archetype | `/archetype` | Apply or save reusable architecture profiles (team library) |
| Build Plan | `/build-plan` | Generate a sequenced implementation plan |
| Setup Skills | `/setup-skills` | Install Anthropic's 5 official external skills |
| Skill Creator | `/skill-creator` | Create new skills for this framework |

### Bundled Subagents

Separate agents with their own context and tool permissions — ask Claude to use them ("have the qa-reviewer check this story") or let it delegate proactively. See the [Skills & Agents guide](docs/01-skills-and-agents.md).

| Agent | Use Case | Tools |
|---|---|---|
| `qa-reviewer` | Review implemented code against acceptance criteria + conventions | Read-only |
| `spec-compliance` | Detect drift between `documents/` (spec) and `platform/` (code) | Read-only |
| `security-reviewer` | OWASP/threat pass against the product's stated security model | Read-only |
| `frontend-builder` | Build a complete, polished UI feature from a spec or design | Full |
| `backend-builder` | Build a complete backend feature per ADRs + platform-layout | Full |
| `test-engineer` | Write + run tests derived from acceptance criteria | Test files only |
| `progress-tracker` | Progress-log upkeep + status reports (PM tracking) | `documents/operations/` |
| `devops-engineer` | CI/CD pipelines + IaC scaffolding (plan/synth only) | Ops/infra paths |

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
│   ├── playbook.md         ←   skills + workflow quick-reference (which skill for which task)
│   └── guides/             ←   team onboarding: claude-code-guide.md + product-workflow.md
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

Framework guides (this repo):

- [Skills & Agents](docs/01-skills-and-agents.md) — who does what: the full roster, skills vs subagents, chaining patterns
- [Install & Maintenance](docs/02-install-and-maintenance.md) — team onboarding, release process, global config, factory reset

Workspace guides (live in the `product-init` skill and are **copied into every generated workspace at `.ai/guides/`**, so teammates always have them in their product repo):

- [Claude Code Guide](skills/product-init/reference/guides/claude-code-guide.md) — the tool itself: concepts, first run, CLI reference, permissions, CLAUDE.md, MCP
- [Product Workflow](skills/product-init/reference/guides/product-workflow.md) — the 8 stages: what to run at each phase, with prompts and `documents/` outputs

---

## For Teams

This repository is the single source of truth for your team's Claude Code configuration. The plugin installs from GitHub — no file copying needed.

**Keeping up to date:**
When a new version is pushed, teammates run:
```bash
claude plugin marketplace update orpexp          # refresh marketplace metadata (cached)
claude plugin update orpexp-devkit@orpexp        # use the fully-qualified name
```
Then restart Claude Code to apply. Note: the bare name (`claude plugin update orpexp-devkit`)
can return "plugin not found" — always use `orpexp-devkit@orpexp`.

**Adding a new skill for your team:**
1. Create `skills/my-skill/SKILL.md` following the pattern in existing skills
2. Run `/skill-creator` inside Claude Code for guided skill authoring
3. Bump the version in `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
4. Commit and push — teammates pick it up with the update sequence above (full release checklist: [Install & Maintenance](docs/02-install-and-maintenance.md))

**Project-level customization:**
Each project's `CLAUDE.md` at the project root is auto-loaded by Claude Code. Keep all substantive guidance in `.ai/AGENTS.md` and pull it in via `@.ai/AGENTS.md` inside the root `CLAUDE.md` — that is how `.ai/` content reaches Claude.
