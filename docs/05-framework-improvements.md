# Framework Improvements — review & roadmap

A prioritized review of this framework with concrete, actionable improvements. Each item notes the
**why**, the **what**, and the **effort**. Nothing here is required to use the framework today — it's
a roadmap for making it more robust, more native to Claude Code, and easier to share across a team.

> **Already shipped:**
> - `platform/` structure: `core/ui-components` added, `core/shared` → `core/server`, router placement rules documented. See [`skills/product-init/reference/platform-layout.md`](../skills/product-init/reference/platform-layout.md).
> - **Plugin packaging (item 1 below):** `skills/` is at the repo root; `.claude-plugin/plugin.json` is in place; install with `claude plugin add ~/claude-framework`.

---

## 1. ~~Package the framework as a real Claude Code plugin~~  ·  ✅ *shipped*

**Why.** Distribution today is manual `cp -r global/skills/* ~/.claude/skills/`. That's a one-way
copy with no versioning, no update path, and drift between teammates the moment anyone edits a local
copy. A native **plugin** is the mechanism Claude Code provides for exactly this: versionable,
updatable, and shareable from a single source of truth.

**What.** Convert `global/` into a plugin:

```
claude-framework/
├── .claude-plugin/
│   └── plugin.json          # name, version, description, author
├── skills/                  # the 11 skills (moved from global/skills/)
├── commands/                # optional: slash commands beyond skills
└── agents/                  # optional: subagent definitions (see item 2)
```

- `plugin.json` carries a semver `version`, so teammates can see and pin what they have.
- Optionally publish a **marketplace** (a `marketplace.json` listing this plugin) so installation is
  `/plugin marketplace add <repo>` then `/plugin install claude-framework` — no manual file copying.
- `INSTALL.md` shrinks to "add the marketplace, install the plugin"; the factory-reset section
  becomes "uninstall the plugin".

**Effort.** Medium. Mostly a restructure + a manifest; the skill contents don't change.

**Migration sketch (what moves where).**

| Today | Becomes |
|---|---|
| `global/skills/<name>/SKILL.md` | `skills/<name>/SKILL.md` (unchanged content) |
| `global/CLAUDE.md` | stays a user-level `~/.claude/CLAUDE.md` (plugins don't ship global memory) |
| `global/settings.json` | documented as a recommended merge; see item 3 |
| manual `cp -r` in `INSTALL.md` | `/plugin install` from a marketplace |

---

## 2. Skills vs. subagents — choose deliberately per role

**Why.** Every role in this framework (architect, frontend-dev, …) is modeled as a **skill** invoked
with `/name`. Skills inject instructions into the *current* conversation. Claude Code also has
**subagents**, which run in their **own context window** with their own tool all-list and model, and
can be dispatched in parallel. The two solve different problems, and some of these roles fit
subagents better.

**Rule of thumb.**
- **Skill** — when you want the persona's *guidance applied to the main thread* and to keep the
  conversation's context (e.g. `/user-story`, `/build-plan`, `/design-review`: they shape output you
  read and iterate on directly).
- **Subagent** — when you want *isolated, parallelizable work* that returns a result without
  polluting the main context (e.g. a `architect` exploration, a `code-reviewer` sweep, a
  `backend-dev` that goes off and implements an endpoint while you keep planning).

**What.** Document the distinction in `docs/04-agents-guide.md`, and (optionally) ship the
build-heavy roles (`frontend-dev`, `backend-dev`, plus a `code-reviewer`) as subagents under
`agents/`, keeping the advisory roles as skills. A role can exist as both.

**Effort.** Low to document; medium to also author subagent definitions.

---

## 3. `settings.json` defaults + a guardrail hook

**Why.** The framework's core invariant — *agents never edit `documents/inputs/`* — is currently
enforced only by prose in `AGENTS.md` and `conventions.md`. Prose is ignorable; a **hook** is not.

**What.** Ship a `PreToolUse` hook (matching `Edit`/`Write`) that **blocks any write whose path is
under `documents/inputs/`** and returns a message pointing the agent at the change-log workflow
instead. Pair it with sane `settings.json` defaults already implied by the framework
(`defaultMode: acceptEdits`, high effort).

```jsonc
// .claude/settings.json (project) or plugin-provided
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{ "type": "command",
        "command": "<script that exits non-zero if $FILE_PATH matches documents/inputs/>" }]
    }]
  }
}
```

**Effort.** Low. One small script + a settings block.

---

## 4. Targeted MCP server recommendations

**Why.** The cheatsheet explains MCP generically. The workflow has obvious, high-leverage
integrations that would be worth recommending by name.

**What.** Add a short "recommended MCP servers" table tied to the stages:

| Stage | MCP server | Use |
|---|---|---|
| Design | Figma | Let `/design-review` and `/designer` read frames directly instead of pasted screenshots |
| Build | Postgres / your DB | Let `/backend-dev` and `/architect` inspect the live schema |
| Deliver | GitHub | Let `/scrum-master` and `/code-review` read issues/PRs |

**Effort.** Low. Documentation plus example `claude mcp add` commands.

---

## Suggested order

1. **Plugin packaging** (item 1) — unlocks clean distribution for everything else.
2. **Guardrail hook** (item 3) — small, high-protection, ships naturally inside the plugin.
3. **Skills vs. subagents** (item 2) — refine roles once the plugin shape exists.
4. **MCP recommendations** (item 4) — documentation, do anytime.
