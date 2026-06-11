# Install & Maintenance Guide

Team onboarding, global config sync, release process, and factory reset for the orpexp-devkit plugin.

---

## Release process (maintainers only)

Before every push with user-facing changes:
1. Bump `"version"` in `.claude-plugin/plugin.json`
2. Bump `"version"` (and `"description"` if the skill/agent count changed) in `.claude-plugin/marketplace.json`
3. Add a `## [x.y.z] — YYYY-MM-DD` entry to `CHANGELOG.md`

Teammates then pick it up with `claude plugin update orpexp-devkit` inside Claude Code.

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

Install **orpexp-devkit** as a Claude Code plugin — all 13 skills and 8 subagents load automatically:

```bash
# Add the orpexp marketplace (one-time)
claude plugin marketplace add orpexp/orpexp-devkit

# Install the plugin
claude plugin install orpexp-devkit
```

Verify:

```bash
claude plugin list
# Should show: orpexp-devkit at the latest version  ✔ enabled
```

Open Claude Code and run `/help` — you should see all skills listed.

**Manual install (fallback — for IDE extensions or if the plugin command is unavailable):**

```bash
git clone git@github.com:orpexp/orpexp-devkit.git ~/orpexp-devkit
cp -r ~/orpexp-devkit/skills/* ~/.claude/skills/
```

---

## Plugin management

```bash
claude plugin update orpexp-devkit       # update to the latest version
claude plugin uninstall orpexp-devkit    # remove
claude plugin list                       # list installed plugins
claude plugin marketplace list           # list configured marketplaces
```

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
claude plugin update orpexp-devkit

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
claude plugin install orpexp-devkit
```

### Full reset (nuclear option)

```bash
# Back up first — this deletes everything
cp -r ~/.claude ~/.claude.backup.$(date +%Y%m%d)

rm -rf ~/.claude

claude plugin marketplace add orpexp/orpexp-devkit
claude plugin install orpexp-devkit
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
claude plugin install orpexp-devkit

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
