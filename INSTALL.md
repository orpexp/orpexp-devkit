# Installation Guide

How to install the Claude Code Framework globally, sync it to a project, and reset your Claude config when needed.

---

## Prerequisites

- Claude Code CLI installed: `npm install -g @anthropic-ai/claude-code`
- Or via direct installer — see the [official Claude Code docs](https://docs.anthropic.com/en/docs/claude-code)
- Verify: `claude --version`
- GitHub CLI (`gh`) with access to the `orpexp` org — required because this is a **private** repository

---

## 0. Authenticate with GitHub

This repo is private. You must authenticate with the GitHub CLI before installing the plugin:

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

## 1. Install the Plugin

Install **orpexp-devkit** as a Claude Code plugin — all 11 skills load automatically:

```bash
# Add the orpexp marketplace (one-time)
claude plugin marketplace add orpexp/orpexp-devkit

# Install the plugin
claude plugin install orpexp-devkit
```

Verify:

```bash
claude plugin list
# Should show: orpexp-devkit v1.0.0  ✔ enabled
```

Open Claude Code and run `/help` — you should see all skills listed.

**Manual install (fallback — for IDE extensions or if the plugin command is unavailable):**

```bash
git clone git@github.com:orpexp/orpexp-devkit.git ~/orpexp-devkit
cp -r ~/orpexp-devkit/skills/* ~/.claude/skills/
```

---

## Plugin Management

```bash
# Update to the latest version
claude plugin update orpexp-devkit

# Remove / uninstall the plugin
claude plugin uninstall orpexp-devkit

# List all installed plugins
claude plugin list

# List configured marketplaces
claude plugin marketplace list
```

---

## When do you need to clone the repo?

**Cloning is optional.** The plugin install, project scaffolding (`/product-init`), and external skills (`/setup-skills`) all work without it.

You only need to clone if you want to:
- Copy `global/CLAUDE.md` into `~/.claude/CLAUDE.md` (global Claude instructions)
- Copy or review `global/settings.json` (recommended settings)
- Contribute new skills or edits back to the framework

```bash
# Only when needed for one of the above:
git clone git@github.com:orpexp/orpexp-devkit.git ~/orpexp-devkit
```

---

## 2. Apply Global CLAUDE.md (Optional)

The `global/CLAUDE.md` file sets default behavior for all your projects. Review it before applying:

```bash
cat ~/orpexp-devkit/global/CLAUDE.md
```

If it matches your preferences, copy it:

```bash
cp ~/orpexp-devkit/global/CLAUDE.md ~/.claude/CLAUDE.md
```

If you already have a `~/.claude/CLAUDE.md`, merge manually rather than overwriting.

---

## 3. Apply Recommended Settings (Optional)

Review and merge `global/settings.json`:

```bash
cat ~/orpexp-devkit/global/settings.json
```

Your current settings:

```bash
cat ~/.claude/settings.json
```

Merge manually or overwrite:

```bash
cp ~/orpexp-devkit/global/settings.json ~/.claude/settings.json
```

---

## 4. Install External Skills from Anthropic

These 5 official Anthropic skills add UI design, testing, MCP server building, and code simplification. No clone needed — the `/setup-skills` skill handles everything:

```
Open Claude Code and run:  /setup-skills
```

The skill tries the plugin marketplace first and falls back to `git clone` automatically. It installs: `frontend-design`, `webapp-testing`, `mcp-builder`, `skill-creator`, and `simplify`.

---

## 5. Start a New Project

No template to copy — `/product-init` generates the full project structure from your idea notes:

```bash
mkdir my-product && cd my-product
claude
```

Inside Claude Code:

```
/product-init
"Here are my idea notes: [paste notes]"
```

This scaffolds the complete tree (`CLAUDE.md`, `.ai/`, `documents/`, `platform/`) and extracts your notes into structured knowledge-base docs. Everything is generated — no repo clone required.

For an **existing project**, run `/product-init` from inside it — the skill detects that `documents/inputs/STAKEHOLDER-NOTES.md` doesn't exist and runs in INIT mode, adding `.ai/` and `documents/` without touching existing files.

---

## Syncing Updates from the Framework Repo

When the framework gets updates (new skills, improved guides), pull and reinstall:

```bash
git -C ~/orpexp-devkit pull
claude plugin update orpexp-devkit

# Manual fallback: cp -r ~/orpexp-devkit/skills/* ~/.claude/skills/
```

---

## Factory Reset: Clean Up Global Claude Settings

Use this when your `~/.claude/` directory has grown messy with old skills, stale sessions, or unwanted config.

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
rm -rf ~/.claude/sessions/*
rm -rf ~/.claude/plans/*
rm -rf ~/.claude/cache/*
rm -rf ~/.claude/debug/*

# Clean specific skills you no longer need
ls ~/.claude/skills/
rm -rf ~/.claude/skills/old-skill-name

# Reinstall the plugin
claude plugin marketplace add orpexp/orpexp-devkit
claude plugin install orpexp-devkit
cp ~/orpexp-devkit/global/settings.json ~/.claude/settings.json
cp ~/orpexp-devkit/global/CLAUDE.md ~/.claude/CLAUDE.md
```

### Full reset (nuclear option)

```bash
# Back up first — this deletes everything
cp -r ~/.claude ~/.claude.backup.$(date +%Y%m%d)

# Nuke the directory
rm -rf ~/.claude

# Reinstall from framework
claude plugin marketplace add orpexp/orpexp-devkit
claude plugin install orpexp-devkit
cp ~/orpexp-devkit/global/settings.json ~/.claude/settings.json
cp ~/orpexp-devkit/global/CLAUDE.md ~/.claude/CLAUDE.md

echo "Reset complete. Re-add any external skills and API keys."
```

> After a full reset you'll need to re-authenticate: `claude` and follow the login prompt.

---

## Team Onboarding Script

Add this to your team's onboarding docs. New hires run it once:

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

# Optional: clone for global config and project template
# git clone git@github.com:orpexp/orpexp-devkit.git ~/orpexp-devkit
# cp ~/orpexp-devkit/global/settings.json ~/.claude/settings.json
# cp ~/orpexp-devkit/global/CLAUDE.md ~/.claude/CLAUDE.md

echo "Done! Run 'claude' to start, then /help to see all skills."
```

---

## Directory Reference

```
~/.claude/                   ← Global Claude config directory
├── settings.json            ← Global settings (permissions, model, etc.)
├── CLAUDE.md                ← Global instructions for Claude (applies everywhere)
├── skills/                  ← All installed skills
│   ├── product-owner/
│   │   └── SKILL.md
│   └── ...
├── sessions/                ← Conversation history
├── plans/                   ← Saved plans
├── projects/                ← Project-level memory (auto-managed)
└── cache/                   ← API response cache

my-project/                  ← Your project root
├── CLAUDE.md                ← Auto-loaded by Claude Code; thin @-import of .ai/AGENTS.md
├── README.md                ← Human entry point
├── .ai/                     ← How to work in this repo (committed to git)
│   ├── AGENTS.md            ← Canonical agent context (behavioral rules, reading order)
│   ├── conventions.md       ← The documents/ knowledge-base rules
│   └── platform-layout.md  ← The platform/ code architecture and import rules
├── documents/               ← Knowledge base (vision, scope, architecture, operations)
└── platform/                ← All application code
```
