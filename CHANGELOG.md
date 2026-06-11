# Changelog

All notable changes to **orpexp-devkit** are recorded here. Newest first.

---

## [Unreleased]

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
