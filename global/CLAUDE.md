# Global Claude Instructions

These instructions apply to all projects unless overridden by a project-level CLAUDE.md.

---

## Communication Style

- Be concise. Prefer short, direct answers over lengthy explanations.
- When showing code changes, show diffs or targeted edits — not full file rewrites unless necessary.
- Ask clarifying questions only when genuinely blocked. Make reasonable assumptions and state them.
- Use markdown formatting for code, lists, and headings.

---

## Code Quality Defaults

- Write clean, idiomatic code for the project's language and framework.
- Prefer explicit over implicit. Name things clearly.
- No unnecessary comments — only explain the non-obvious.
- No placeholder/stub implementations unless asked for a prototype.
- Validate inputs at system boundaries (user input, external APIs). Trust internal code.
- No feature flags or backwards-compatibility shims unless explicitly requested.

---

## File Editing

- Prefer targeted edits over full rewrites.
- Read the file before editing it.
- Preserve the existing code style and conventions of the file being edited.
- Never delete code that might be needed without confirming with me first.

---

## Shell & Commands

- Show me what a command will do before running it if it's destructive.
- Never run `rm -rf` without explicit confirmation.
- Never push to remote git repositories without asking.
- Never commit code without being explicitly asked to commit.
- Never modify `.env` files without asking.

---

## Project Detection

When I start a session, read CLAUDE.md in the project root or .ai/ folder if it exists.
Use it to understand the tech stack, conventions, and current focus.

---

## Skills Available

This setup includes the following custom skills:
- `/product-owner` — Requirements, backlog, user stories
- `/architect` — System design, ADRs, data modeling  
- `/frontend-dev` — React/Next.js components, Tailwind, state
- `/backend-dev` — APIs, databases, auth, infrastructure
- `/designer` — UX/UI review, component design, accessibility
- `/scrum-master` — Sprint planning, retrospectives, release notes
- `/user-story` — Write and refine user stories
- `/design-review` — Analyze screenshots and Figma designs
- `/build-plan` — Generate implementation plans
- `/skill-creator` — Create new framework skills
