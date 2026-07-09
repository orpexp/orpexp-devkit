# Install & Maintenance Guide

Team onboarding, global config sync, release process, and factory reset for the orpexp-devkit plugin.

---

## Release process (maintainers only)

For every release with user-facing changes:
1. Bump `"version"` in `.claude-plugin/plugin.json`
2. Bump `"version"` (and `"description"` if the skill/agent count changed) in `.claude-plugin/marketplace.json`
3. Add a `## [x.y.z] — YYYY-MM-DD` entry to `CHANGELOG.md`
4. Commit and **push** — the plugin sources from GitHub `main`, so unpushed releases reach no one (including your own machine)
5. Verify by running the team update sequence yourself:
   ```bash
   claude plugin marketplace update orpexp
   claude plugin update orpexp-devkit@orpexp
   claude plugin list        # must show the new version, Status: ✔ enabled
   ```

Gotcha: never add a `"hooks"` entry in `plugin.json` pointing at `hooks/hooks.json` — that path is
auto-discovered, and declaring it double-registers the hooks and the plugin fails to load.

---

## Prerequisites

- Claude Code CLI installed: `npm install -g @anthropic-ai/claude-code`
  (or the direct installer — see the [official Claude Code docs](https://docs.anthropic.com/en/docs/claude-code))
- Verify: `claude --version`
- GitHub CLI (`gh`) with access to the `orpexp` org — required because this is a **private** repository

---

## 0. Authenticate with GitHub

```bash
# Install gh if you don't have it
brew install gh

# Authenticate — follow the browser prompt and grant orpexp org access
gh auth login
```

Verify access:

```bash
gh repo view orpexp/orpexp-devkit --json visibility --jq '.visibility'
# Should return: PRIVATE
```

---

## 1. Install the plugin

Install **orpexp-devkit** as a Claude Code plugin — all 15 skills, 8 subagents, and both
hooks (the `documents/inputs/` guardrail and the graph-first nudge) load automatically:

```bash
# Add the orpexp marketplace (one-time)
claude plugin marketplace add orpexp/orpexp-devkit

# Install the plugin (fully-qualified name: plugin@marketplace)
claude plugin install orpexp-devkit@orpexp
```

Verify:

```bash
claude plugin list
# Should show: orpexp-devkit at the latest version  ✔ enabled
```

Open Claude Code and run `/help` — you should see all skills listed.

### 1b. Install the Graphify CLI (recommended — token-efficient repo search)

The plugin ships a **graph-first hook** that, in any repo with a committed knowledge graph,
nudges agents to query the graph instead of grepping/reading files — a large token saving. The
hook needs the [Graphify](https://github.com/Graphify-Labs/graphify) CLI on your machine
(one-time, needs Python 3.10+ — no API key ever):

```bash
uv tool install graphifyy        # package is graphifyy (double y), command is graphify
graphify install                 # register the /graphify skill with Claude Code
```

No `uv`? Run `brew install uv` first (or `pipx install graphifyy`). If `graphify` isn't found
afterwards: `uv tool update-shell`, then open a new terminal.

The graph lives at **`.ai/graph/`** (agent tooling — kept out of the repo root). Its location is
set by `GRAPHIFY_OUT` in the project's `.claude/settings.json`, which `/product-init` pre-wires
into every new project (`{ "env": { "GRAPHIFY_OUT": ".ai/graph" } }`); Graphify's CLI and the
plugin hook both honor it, so they always agree on where the graph is.

That's all: repos that already have a committed `.ai/graph/` (this framework repo does) work
immediately. To build a graph for a new repo, or to **turn the nudge off** when an agent needs
full context (`touch .graphify-off`), see the `/repo-graph` skill.

> Do **not** run `graphify claude install` — the plugin already ships that hook; running it would
> register a duplicate nudge.

**Manual install (fallback — for IDE extensions or if the plugin command is unavailable):**

```bash
git clone git@github.com:orpexp/orpexp-devkit.git ~/orpexp-devkit
cp -r ~/orpexp-devkit/skills/* ~/.claude/skills/
```

---

## Plugin management

```bash
claude plugin marketplace update orpexp           # refresh marketplace metadata (do this first — it's cached)
claude plugin update orpexp-devkit@orpexp         # update to the latest version
claude plugin uninstall orpexp-devkit@orpexp      # remove
claude plugin list                                # list installed plugins + load status
claude plugin marketplace list                    # list configured marketplaces
```

> Use the fully-qualified name `orpexp-devkit@orpexp` — the bare name can return "plugin not found".
> After an update, restart Claude Code to apply.

---

## When do you need to clone the repo?

**Cloning is optional.** The plugin install, project scaffolding (`/product-init`), and external
skills (`/setup-skills`) all work without it.

You only need a clone to:
- Copy `global/CLAUDE.md` into `~/.claude/CLAUDE.md` (global Claude instructions)
- Copy or review `global/settings.json` (recommended settings)
- Contribute skills, agents, or **architecture archetypes** back to the framework
  (`/archetype` EXTRACT writes into your local clone)

```bash
git clone git@github.com:orpexp/orpexp-devkit.git ~/orpexp-devkit
```

---

## 2. Apply global CLAUDE.md (optional)

`global/CLAUDE.md` sets default behavior for all your projects. Review, then copy:

```bash
cat ~/orpexp-devkit/global/CLAUDE.md
cp ~/orpexp-devkit/global/CLAUDE.md ~/.claude/CLAUDE.md
```

If you already have a `~/.claude/CLAUDE.md`, merge manually rather than overwriting.

## 3. Apply recommended settings (optional)

```bash
cat ~/orpexp-devkit/global/settings.json     # review
cat ~/.claude/settings.json                  # compare with yours
cp ~/orpexp-devkit/global/settings.json ~/.claude/settings.json   # or merge manually
```

## 4. Install external skills from Anthropic

Five official Anthropic skills (UI design, testing, MCP building, simplification). No clone needed:

```
Open Claude Code and run:  /setup-skills
```

The skill tries the plugin marketplace first and falls back to `git clone` automatically.

## 5. Start a new project

No template to copy — `/product-init` generates everything from your idea notes:

```bash
mkdir my-product && cd my-product
claude
```

```
/product-init
"Here are my idea notes: [paste notes]"
```

This scaffolds the complete tree (`CLAUDE.md`, `.ai/`, `documents/`, `platform/`) and extracts your
notes into structured knowledge-base docs. For an **existing project**, run `/product-init` from
inside it — it adds `.ai/` and `documents/` without touching existing files.

---

## Syncing updates from the framework repo

```bash
claude plugin marketplace update orpexp
claude plugin update orpexp-devkit@orpexp

# If you keep a clone (for global config or contributing):
git -C ~/orpexp-devkit pull
```

---

## Factory reset: clean up global Claude settings

Use when `~/.claude/` has grown messy with old skills, stale sessions, or unwanted config.

### What to keep vs. delete

| Path | Keep? | Notes |
|---|---|---|
| `~/.claude/settings.json` | Review | Edit rather than delete |
| `~/.claude/CLAUDE.md` | Review | May have useful customizations |
| `~/.claude/skills/` | Selective | Delete skills you don't use |
| `~/.claude/sessions/` | Delete | Old session history |
| `~/.claude/plans/` | Delete | Old plan files |
| `~/.claude/cache/` | Delete | Safe to clear |
| `~/.claude/debug/` | Delete | Debug logs |
| `~/.claude/projects/` | Careful | Contains project memory; review first |

### Partial reset (recommended)

```bash
# Back up everything first
cp -r ~/.claude ~/.claude.backup.$(date +%Y%m%d)

# Remove stale sessions and cache
rm -rf ~/.claude/sessions/* ~/.claude/plans/* ~/.claude/cache/* ~/.claude/debug/*

# Clean specific skills you no longer need
ls ~/.claude/skills/
rm -rf ~/.claude/skills/old-skill-name

# Reinstall the plugin
claude plugin marketplace add orpexp/orpexp-devkit
claude plugin install orpexp-devkit@orpexp
```

### Full reset (nuclear option)

```bash
# Back up first — this deletes everything
cp -r ~/.claude ~/.claude.backup.$(date +%Y%m%d)

rm -rf ~/.claude

claude plugin marketplace add orpexp/orpexp-devkit
claude plugin install orpexp-devkit@orpexp
cp ~/orpexp-devkit/global/settings.json ~/.claude/settings.json
cp ~/orpexp-devkit/global/CLAUDE.md ~/.claude/CLAUDE.md
```

> After a full reset you'll need to re-authenticate: run `claude` and follow the login prompt, then
> re-add any external skills (`/setup-skills`) and API keys.

---

## Team onboarding script

New hires run this once:

```bash
#!/bin/bash
# orpexp-devkit Setup
set -e

echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "Authenticating with GitHub (grant orpexp org access when prompted)..."
gh auth login

echo "Adding orpexp marketplace..."
claude plugin marketplace add orpexp/orpexp-devkit

echo "Installing orpexp-devkit plugin..."
claude plugin install orpexp-devkit@orpexp

# Optional: clone for global config and contributing
# git clone git@github.com:orpexp/orpexp-devkit.git ~/orpexp-devkit
# cp ~/orpexp-devkit/global/settings.json ~/.claude/settings.json
# cp ~/orpexp-devkit/global/CLAUDE.md ~/.claude/CLAUDE.md

echo "Done! Run 'claude' to start, then /help to see all skills."
```

---

## Directory reference

```
~/.claude/                   ← Global Claude config directory
├── settings.json            ← Global settings (permissions, model, etc.)
├── CLAUDE.md                ← Global instructions for Claude (applies everywhere)
├── skills/                  ← Manually installed skills (plugin skills load via the plugin)
├── sessions/                ← Conversation history
├── plans/                   ← Saved plans
├── projects/                ← Project-level memory (auto-managed)
└── cache/                   ← API response cache

my-project/                  ← A project generated by /product-init
├── CLAUDE.md                ← Auto-loaded by Claude Code; thin @-import of .ai/AGENTS.md
├── README.md                ← Human entry point
├── .ai/                     ← How to work in this repo (committed to git)
│   ├── AGENTS.md            ← Canonical agent context (behavioral rules, reading order)
│   ├── conventions.md       ← The documents/ knowledge-base rules
│   ├── platform-layout.md  ← The platform/ code architecture and import rules
│   └── playbook.md          ← Skills + agents quick-reference for this project
├── documents/               ← Knowledge base (vision, scope, architecture, operations, business)
└── platform/                ← All application code
```
