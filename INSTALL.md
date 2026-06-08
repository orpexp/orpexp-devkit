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

## 3. Apply Global CLAUDE.md (Optional)

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

## 4. Apply Recommended Settings (Optional)

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

## 5. Install External Skills from Anthropic

These official skills from Anthropic's GitHub add powerful capabilities. Use the included script to install all five at once:

```bash
bash ~/orpexp-devkit/scripts/install-external-skills.sh
```

This installs: `frontend-design`, `webapp-testing`, `mcp-builder`, `skill-creator` (from `anthropics/skills`) and `simplify` (from `anthropics/claude-code`).

**Requirements:** `git` must be installed. `gh` (GitHub CLI) is used if available; otherwise falls back to plain `git clone`.

**Manual install (if the script doesn't work):**

```bash
# From anthropics/skills
gh repo clone anthropics/skills /tmp/anthropic-skills
cp -r /tmp/anthropic-skills/frontend-design ~/.claude/skills/
cp -r /tmp/anthropic-skills/webapp-testing ~/.claude/skills/
cp -r /tmp/anthropic-skills/mcp-builder ~/.claude/skills/
cp -r /tmp/anthropic-skills/skill-creator ~/.claude/skills/
rm -rf /tmp/anthropic-skills

# simplify — from anthropics/claude-code
gh repo clone anthropics/claude-code /tmp/claude-code-repo
cp -r /tmp/claude-code-repo/.claude/skills/simplify ~/.claude/skills/
rm -rf /tmp/claude-code-repo
```

> **Note:** Verify folder names against the official Anthropic GitHub repos if the install fails — folder paths may change as skills are updated.

---

## 6. Add to a Project

For a new project, use the full project template (preferred):

```bash
cp -r ~/orpexp-devkit/project-template/. ./my-product/
cd my-product
```

Or for an existing project, copy just the `.ai/` context folder and the root pointer:

```bash
cd my-project
cp -r ~/orpexp-devkit/project-template/.ai ./.ai
cp ~/orpexp-devkit/project-template/CLAUDE.md ./CLAUDE.md
```

Customize `.ai/AGENTS.md` with your project details (name, pitch, industry, stage):

```bash
code .ai/AGENTS.md   # or vim, nano, etc.
```

> **Note on CLAUDE.md:** Claude Code auto-loads `CLAUDE.md` at the **project root only**. The root
> `CLAUDE.md` in this framework is a 3-line file that `@`-imports `.ai/AGENTS.md` — keep it as-is.
> Put all substantive guidance in `.ai/AGENTS.md`, not in the root `CLAUDE.md`.

Add both to git so the whole team benefits:

```bash
git add CLAUDE.md .ai/
git commit -m "add AI context and agent configuration"
```

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
