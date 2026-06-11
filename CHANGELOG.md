# Changelog

All notable changes to **orpexp-devkit** are recorded here. Newest first.

---

## [Unreleased]

- Backlog: `PreToolUse` guardrail hook blocking writes under `documents/inputs/` (the framework's read-only invariant is currently prose-only); `skills/business-advisor` persona skill
- Backlog: skill descriptions gain sequence hints ("usually follows /product-init, precedes /architect")

---

## [1.9.0] — 2026-06-10

### Changed
- `docs/` consolidated from 7 guides (~1,950 lines) to 4 (~1,000 lines), each with one job — applying the framework's own "one fact, one home" rule to its docs:
  - `docs/01-claude-code-guide.md` — the tool itself (merges old 00 + 01): concepts, first run, CLI/commands/shortcuts reference, permission modes (once), CLAUDE.md thin-pointer convention (the contradictory "fat CLAUDE.md" examples removed), MCP setup + recommended-servers table
  - `docs/02-product-workflow.md` — THE stage-by-stage guide (merges old 02 + 03): goal, skills + agents, prompts, and `documents/` outputs per stage; conventions-aligned (`.ai/AGENTS.md`, `documents/architecture/decisions/`); includes `/archetype` and all 8 subagents
  - `docs/03-skills-and-agents.md` — who does what (slims old 04): skills-vs-subagents, compact 13-skill + 8-agent rosters, chaining, anti-patterns; the ~200-line per-skill sections removed (each SKILL.md is the source of truth)
  - `docs/04-install-and-maintenance.md` — old 06 corrected: "11 skills" → 13 skills + 8 agents, hardcoded "v1.0.0" removed, directory reference includes `.ai/playbook.md`
- `README.md` — Guides section lists the 4 new files; Quick Start install shrunk to the 3 commands + link to the full guide

### Removed
- `docs/05-framework-improvements.md` — items 1 (plugin packaging) and 2 (subagents) shipped; item 3 (inputs/ guardrail hook) moved to the Unreleased backlog above; item 4 (MCP recommendations) implemented as the table in `docs/01-claude-code-guide.md`

---

## [1.8.0] — 2026-06-10

### Added
- `agents/` grows from 3 to 8 subagents:
  - `security-reviewer` — read-only OWASP Top-10 + threat pass over `platform/`, checked against the product's stated security model (`architecture/security.md`, Accepted ADRs); severity-ranked findings with exploit paths
  - `backend-builder` — full-tools counterpart to `frontend-builder`: complete backend features (API, data model, authz, reversible migrations, tests) honoring Accepted ADRs and platform-layout placement
  - `test-engineer` — derives automated tests from acceptance criteria, runs them, reports criteria coverage; never modifies production code (a failing test that catches a real bug is reported, not "fixed")
  - `progress-tracker` — the PM-tracking function: SYNC-LITE bookkeeping (progress log, open-questions strikes) after work lands + on-demand status reports vs roadmap milestones; writes only under `documents/operations/`
  - `devops-engineer` — fast, cached CI/CD pipelines and IaC scaffolding per `architecture/infrastructure.md` / the applied archetype; plan/synth only, never applies to live environments

### Changed
- `docs/04-agents-guide.md` — roster table covers all 8 agents; new "Roles that deliberately stay skills" note (stakeholder/product-owner, solutions architect, release manager — and why)
- `skills/product-init/reference/playbook.md` — Build/Review/Ship stages and quick lookup include the new agents
- `README.md` — repo table and Bundled Subagents table updated to 8
- `.claude-plugin/plugin.json` + `marketplace.json` — version 1.8.0; description "3 subagents" → "8 subagents"
- Backlog note: the planned `skills/devops` persona skill is superseded by the `devops-engineer` agent

---

## [1.7.0] — 2026-06-10

### Added
- `agents/` — the plugin now ships 3 subagents (separate context + scoped tools, complementing the role skills):
  - `qa-reviewer` — reviews implemented code against acceptance criteria, `.ai/` conventions, and common defect classes; read-only by design (reports, never fixes)
  - `spec-compliance` — detects drift between `documents/` (the spec) and `platform/` (the code): scope coverage, Accepted-ADR compliance, tech-stack drift, and a mechanical check of imports against the platform-layout allowed-imports matrix; read-only
  - `frontend-builder` — builds complete UI features from a spec or design: typed React, every state handled, accessibility, plus an explicit aesthetic standard (hierarchy, spacing rhythm, deliberate color, distinctive-not-generic); full tools

### Changed
- `docs/04-agents-guide.md` — new "Subagents vs role skills" section explaining when to use which, with the subagent roster
- `skills/product-init/reference/playbook.md` — Review stage and quick lookup now include the subagents
- `README.md` — `agents/` in the repo table + Bundled Subagents reference
- `.claude-plugin/plugin.json` + `marketplace.json` — version 1.7.0; description mentions subagents; keywords gain `agents`, `architecture-archetypes`

---

## [1.6.0] — 2026-06-10

### Added
- `skills/archetype/` — new `/archetype` skill: a team library of reusable **architecture archetypes** with four modes — LIST (catalog), SELECT (score profiles against the product's docs and recommend), APPLY (pre-fill `architecture/03-tech-stack.md` + `01-overview.md`, seed Proposed ADRs, add confirm-checklist items to open-questions), and EXTRACT (generalize a finished product's architecture into a new library entry, distributed to the team via plugin update)
- `skills/archetype/reference/archetype-template.md` — canonical archetype file format (frontmatter: `fits_when`/`avoid_when`/`stack`/`platform_sections`/`adr_seeds`; body: topology, rationale, ADR seeds, trade-offs, exit path, confirm-per-product checklist)
- `skills/archetype/library/` — 5 starter archetypes + `INDEX.md` catalog: `modular-monolith-saas` (house default), `serverless-event-driven`, `static-site-serverless`, `mobile-bff`, `event-driven-microservices` (explicitly gated on platform-layout split triggers)

### Changed
- `skills/architect/SKILL.md` — new "Architecture Archetypes" section: check the library before designing from scratch; extract novel architectures after finalizing
- `skills/product-init/SKILL.md` — "never pre-fill the tech stack" guardrail now carves out explicit `/archetype` APPLY; Step 10 and Phase 2 workflow mention `/archetype`
- `skills/product-init/reference/playbook.md` — `/archetype` added to Design stage, quick lookup, and the Idea → MVP chain
- `README.md`, `docs/03-commands-by-stage.md`, `global/CLAUDE.md` — `/archetype` added; skill count 12 → 13

---

## [1.5.0] — 2026-06-10

### Added
- `skills/product-init/reference/optional/` — 13 fill-in-the-blank templates for the optional docs, mirroring `documents/` paths: `product/{backlog,user-stories}`, `architecture/{security,api-spec,infrastructure}`, `business/{target-market,competitive-analysis,financial-model}`, `design/{01-brand,02-ux,design-system}`, `operations/{runbook,onboarding}`. Each carries the standard YAML front-matter and extraction hints
- `skills/product-init/reference/documents-readme.md` — template for `documents/README.md` (core docs table, optional docs table, "I need X → read Y" routing)
- `skills/product-init/reference/adr-0001.md` — template for the seed ADR (record-architecture-decisions)
- `skills/product-init/reference/claude-md.md` — the root `CLAUDE.md` pointer file, extracted from inline SKILL.md content

### Changed
- `skills/product-init/SKILL.md` — Steps 5/6/7/9 now point at the new reference templates; reading list updated

---

## [1.4.1] — 2026-06-10

### Fixed
- `CHANGELOG.md` — added the missing `[1.4.0]` entry (manifests were bumped to 1.4.0 without a changelog entry)
- `global/CLAUDE.md` — skills list now includes all 12 skills (`/product-init` and `/setup-skills` were missing)
- `skills/product-init/SKILL.md` — Step 7 no longer references a nonexistent `optional/` templates directory; optional docs are authored on demand following `.ai/conventions.md`
- `docs/04-agents-guide.md` — context tip pointed to `.ai/CLAUDE.md`; corrected to `.ai/AGENTS.md` (the framework's canonical context file)

---

## [1.4.0] — 2026-06-07

### Changed
- Root cleanup: merged `QUICK-START.md` into `README.md`; moved `CHEATSHEET.md` → `docs/00-claude-code-guide.md`; moved `INSTALL.md` → `docs/06-install-and-maintenance.md`. Root now contains only `README.md`, `CHANGELOG.md`, and code directories
- `.claude-plugin/plugin.json` — version 1.2.0 → 1.4.0; `.claude-plugin/marketplace.json` — version 1.0.0 → 1.4.0, "11 skills" → "12 skills" (marketplace.json is what `claude plugin update` reads)
- `README.md` — "For Teams" gains a "Keeping up to date" block (`claude plugin update orpexp-devkit`) and a version-bump step in the new-skill flow
- `docs/06-install-and-maintenance.md` — added Release process section

---

## [1.3.0] — 2026-06-07

### Added
- `skills/product-init/reference/playbook.md` — new template; every project scaffolded by `/product-init` now gets `.ai/playbook.md`, a skills + workflow quick-reference covering all bundled and Anthropic external skills, with plugin context preamble

### Changed
- `skills/product-init/SKILL.md` — reads and generates `.ai/playbook.md`; both tree diagrams updated
- `skills/product-init/reference/agents-md.md` — Reading order now points to `playbook.md`
- `.claude-plugin/plugin.json` — version corrected to 1.2.0; skill count corrected to 12
- `README.md` — Project Structure `.ai/` block updated to include `playbook.md`

---

## [1.2.0] — 2026-06-07

### Added
- `skills/setup-skills/SKILL.md` — new `/setup-skills` skill installs Anthropic's 5 external skills (marketplace-first, git-clone fallback); replaces the bash script
- `skills/product-init/reference/agents-md.md` — AGENTS.md template; makes `/product-init` fully self-contained
- `skills/product-init/reference/platform-readme.md` — platform/README.md template; makes `/product-init` fully self-contained

### Changed
- `skills/product-init/SKILL.md` — Step 5 now has explicit content for all generated files (CLAUDE.md, .ai/AGENTS.md, platform/README.md); reads two new reference templates
- `INSTALL.md` — cloning the repo is now documented as optional; §4 and §5 rewritten to use `/setup-skills` and `/product-init`; "When do you need to clone?" section added
- `QUICK-START.md` — no clone in Step 1; `/setup-skills` replaces the bash script line
- `README.md` — removed `project-template/` and `scripts/` from repo table; added `/setup-skills` to Skills Reference; updated description and project structure note

### Removed
- `project-template/` — redundant; `/product-init` generates the full structure from its reference files
- `scripts/install-external-skills.sh` and `scripts/` — replaced by `/setup-skills` skill

---

## [1.1.0] — 2026-06-07

### Added
- `.claude-plugin/plugin.json` — plugin manifest; install with `claude plugin add ~/claude-framework`
- `QUICK-START.md` — plug-and-play 5-minute onboarding guide
- `CHANGELOG.md` — this file

### Changed
- Skills moved from `global/skills/` to `skills/` (repo root) for plugin structure
- `INSTALL.md` — plugin install is now the primary method; manual `cp -r` kept as fallback; added Plugin Management section
- `global/` now contains only user-level config (`CLAUDE.md`, `settings.json`)

---

## [1.0.0] — 2026-06-07

### Skills (11 bundled)

| Skill | Stage | Purpose |
|---|---|---|
| `/product-init` | Init | Scaffold knowledge base from raw idea notes |
| `/product-owner` | Define | Requirements, backlog, acceptance criteria |
| `/user-story` | Define | Write and split user stories |
| `/architect` | Design | Tech stack decisions, system design, ADRs |
| `/designer` | Design | UX/UI review, component specs |
| `/design-review` | Design | Analyze Figma exports and screenshots |
| `/build-plan` | Build | Step-by-step implementation plans |
| `/frontend-dev` | Build | React/Next.js components, styling |
| `/backend-dev` | Build | APIs, database, auth, infrastructure |
| `/scrum-master` | Deliver | Sprint planning, retrospectives, release notes |
| `/skill-creator` | Meta | Create new skills for this framework |

External skills (installed separately via `scripts/install-external-skills.sh`): `frontend-design`, `webapp-testing`, `mcp-builder`, `skill-creator` (Anthropic), `simplify`.

### Project template

Docs-first, multi-repo-ready layout scaffolded by `/product-init`:

```
my-product/
├── CLAUDE.md               ← thin pointer: @.ai/AGENTS.md
├── README.md
├── .ai/
│   ├── AGENTS.md           ← canonical agent context
│   ├── conventions.md      ← documents/ system rules
│   └── platform-layout.md ← platform/ architecture + import rules
├── documents/              ← knowledge base (vision, scope, architecture, ops, business)
│   └── inputs/             ← stakeholder-only; read-only to agents
└── platform/               ← all application code
    ├── apps/
    ├── services/
    ├── core/
    │   ├── contracts/      ← compile-time vocabulary (what things ARE)
    │   ├── adapters/       ← ports & adapters (swappable implementations)
    │   ├── server/         ← runtime server plumbing (what server things DO)
    │   └── ui-components/  ← runtime presentation (design system, primitives)
    ├── data/
    ├── ops/                ← [CODEOWNERS restricted]
    └── infra/              ← [CODEOWNERS restricted]
```

### Key architecture decisions

- `platform/` is multi-repo-ready: each top-level section can be lifted into its own repo with zero import changes
- Stack is never pre-decided — `/architect` decides after requirements are defined
- `documents/inputs/` is the only file a stakeholder hand-edits; everything else is agent-derived
- `core/contracts` = compile-time vocabulary; `core/server` / `core/ui-components` = runtime plumbing
- Shared capabilities use ports & adapters (interface in `core/contracts`, impl in `core/adapters`) — no raw shared domain logic

### Supporting files

- `QUICK-START.md` — plug-and-play 5-minute setup guide
- `CHEATSHEET.md` — full command reference by development stage
- `INSTALL.md` — team onboarding, external skills, factory reset
- `scripts/install-external-skills.sh` — one-command installer for Anthropic's official skills
- `docs/` — 5 deep-dive guides
- `global/` — files to sync into `~/.claude/` (skills, CLAUDE.md, settings.json)
