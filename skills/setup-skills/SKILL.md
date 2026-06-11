---
name: setup-skills
description: >-
  Install Anthropic's official external Claude Code skills. Use when the user wants to: install
  external skills, set up the full skill library, add Anthropic's official skills (frontend-design,
  webapp-testing, mcp-builder, skill-creator, simplify), or complete the framework setup.
  Run once, right after installing the orpexp-devkit plugin.
---

# Setup Skills

You install Anthropic's 5 official external Claude Code skills into `~/.claude/skills/`. These complement the orpexp-devkit skills and cover UI design, testing, MCP server building, and code simplification.

---

## Skills to install

| Skill | Source repo | Purpose |
|---|---|---|
| `frontend-design` | `anthropics/skills` | Build UI from design specs |
| `webapp-testing` | `anthropics/skills` | Write and run web app tests |
| `mcp-builder` | `anthropics/skills` | Build MCP server tools |
| `skill-creator` | `anthropics/skills` | Anthropic's official skill creator |
| `simplify` | `anthropics/claude-code` | Simplify complex code |

---

## Installation steps

### Try the plugin marketplace first (cleanest, no clone needed)

Run these commands and check for errors after each:

```bash
# Skills from anthropics/skills
claude plugin marketplace add anthropics/skills
claude plugin install frontend-design
claude plugin install webapp-testing
claude plugin install mcp-builder
claude plugin install skill-creator

# simplify from anthropics/claude-code
claude plugin marketplace add anthropics/claude-code
claude plugin install simplify
```

If the marketplace commands succeed, you're done — skip the fallback section below.

### Fallback: install via git clone (if marketplace commands fail)

```bash
# From anthropics/skills
gh repo clone anthropics/skills /tmp/anthropic-skills 2>/dev/null || git clone https://github.com/anthropics/skills /tmp/anthropic-skills
cp -r /tmp/anthropic-skills/frontend-design ~/.claude/skills/
cp -r /tmp/anthropic-skills/webapp-testing ~/.claude/skills/
cp -r /tmp/anthropic-skills/mcp-builder ~/.claude/skills/
cp -r /tmp/anthropic-skills/skill-creator ~/.claude/skills/
rm -rf /tmp/anthropic-skills

# simplify from anthropics/claude-code
gh repo clone anthropics/claude-code /tmp/anthropic-claude-code 2>/dev/null || git clone https://github.com/anthropics/claude-code /tmp/anthropic-claude-code
cp -r /tmp/anthropic-claude-code/.claude/skills/simplify ~/.claude/skills/
rm -rf /tmp/anthropic-claude-code
```

---

## After installing

Verify:

```bash
ls ~/.claude/skills/
# Should show: frontend-design  mcp-builder  simplify  skill-creator  webapp-testing
```

Then restart Claude Code and run `/help` — you should see the new skills listed alongside the orpexp-devkit skills.

---

## Guardrails

- If a marketplace command errors with "marketplace file not found" or similar, go straight to the fallback — don't retry the marketplace approach
- If `gh` is not available, use the plain `git clone https://github.com/...` form instead
- Do not install into the project directory — always install into `~/.claude/skills/` (user scope)
- If a skill folder already exists in `~/.claude/skills/`, the `cp -r` will overwrite it — that's fine (it's an update)
- After installation, remind the user to restart Claude Code to pick up the new skills
