# Changelog

All notable changes to **orpexp-devkit** are recorded here. Newest first.

---

## [Unreleased]

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
