# .ai/ — Working Context for {{PRODUCT_NAME}}

This folder tells any agent (or human director) **how to work in this repo**. The knowledge-base
**content** lives in [`../documents/`](../documents/).

Commit this folder to git — it's not an artifact, it's part of the project definition.

## Files

| File | Purpose | Who edits |
|---|---|---|
| [`AGENTS.md`](AGENTS.md) | Canonical working context: behavioral rules, reading order, current focus | Team |
| [`conventions.md`](conventions.md) | The docs-system rules — how `documents/` is organized and maintained | Read-only (framework) |
| [`platform-layout.md`](platform-layout.md) | `platform/` code architecture, import rules, split criteria | Read-only (framework) |

## How Claude Code uses this folder

The root `CLAUDE.md` imports `.ai/AGENTS.md` with `@.ai/AGENTS.md`. Every Claude Code session in
this project loads that context automatically.

Update `AGENTS.md` when:
- The current sprint focus changes
- A tech stack decision is made (update Section 4)
- A new convention is established for this project
