# Claude Code Guide

Reference for Claude Code commands, shortcuts, and workflows across every stage of product development.

---

## CLI Entry Points

```bash
# Start interactive session in current directory
claude

# One-shot prompt (no interactive session)
claude -p "explain the auth flow in this repo"

# Continue the most recent conversation
claude --continue

# Resume a specific past session
claude --resume

# Start with a specific model
claude --model claude-opus-4-8

# Run with increased permissions (careful)
claude --dangerously-skip-permissions

# Print version
claude --version
```

---

## In-Session Slash Commands

### Navigation & Session

| Command | What it does |
|---|---|
| `/help` | Show all available commands and skills |
| `/clear` | Clear conversation history, start fresh |
| `/compact` | Summarize the conversation to free context |
| `/exit` or `Ctrl+C` | Exit Claude Code |
| `/status` | Show current model, memory usage, active MCP servers |

### Memory & Context

| Command | What it does |
|---|---|
| `/memory` | View and edit Claude's persistent memory |
| `/init` | Initialize CLAUDE.md in the current directory |

### Config & Settings

| Command | What it does |
|---|---|
| `/settings` | Open settings editor |
| `/model` | Switch the active model |
| `/mcp` | List active MCP servers and their tools |

### Code Review

| Command | What it does |
|---|---|
| `/code-review` | Review current branch changes |
| `/code-review ultra` | Multi-agent deep code review (billed) |
| `/code-review ultra <PR#>` | Review a GitHub PR |

---

## Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl+C` | Cancel current generation |
| `Ctrl+L` | Clear screen |
| `Up arrow` | Cycle through prompt history |
| `Shift+Enter` | Add newline in prompt |
| `Tab` | Autocomplete file paths and skill names |

---

## Permission Modes

Claude Code has three permission tiers. Set in `settings.json` or per-session:

| Mode | Behavior |
|---|---|
| `default` | Asks before reading files, editing, or running commands |
| `acceptEdits` | Auto-approves file reads and edits; asks before shell commands |
| `bypassPermissions` | Auto-approves everything (use only in safe environments) |

```json
// settings.json
{ "defaultMode": "acceptEdits" }
```

---

## Stage 0: Initialize (New Project or Product)

```
/product-init         → Scaffold the knowledge base from raw idea notes (INIT or SYNC)
```

**Common prompts:**
```
"Here are my idea notes for [product]: [paste raw notes]"
"I added new requirements. Sync the docs."
```

**What it creates:**
```
my-product/
├── CLAUDE.md + README.md          ← root entry points
├── .ai/                           ← agent working context
└── documents/                     ← knowledge base (vision, scope, architecture, ops, business)
    └── inputs/STAKEHOLDER-NOTES.md ← your only hand-edited file
```

After INIT, the recommended next steps are surfaced automatically. Usually:
1. `/product-owner` to refine requirements
2. `/architect` to decide the tech stack

---

## Stage 1: Define (Product Requirements)

```
/product-owner        → Act as Product Owner: requirements, backlog, acceptance criteria
/user-story           → Write or refine user stories from notes or a description
/design-review        → Analyze a screenshot or Figma export for UX requirements
```

**Common prompts:**
```
"Here are my stakeholder notes. Write user stories for the MVP."
"Review this Figma screenshot and list the components I need to build."
"Create acceptance criteria for the login feature."
"What's the priority order for these features?"
```

---

## Stage 2: Design (Architecture & UX)

```
/architect            → Act as Software Architect: system design, tech stack, ADRs
/designer             → Act as UX Designer: component design, design system, accessibility
```

**Common prompts:**
```
"Design the data model for a multi-tenant SaaS app."
"What's the best architecture for this feature? Give me 3 options."
"Write an ADR for our decision to use PostgreSQL over MongoDB."
"How should I structure the folder hierarchy for this Next.js app?"
```

---

## Stage 3: Build (Development)

```
/frontend-dev         → Act as Frontend Developer: React, Next.js, Tailwind, state
/backend-dev          → Act as Backend Developer: APIs, databases, auth, queues
/build-plan           → Generate a step-by-step implementation plan for a feature
```

**Common prompts:**
```
"Implement the user authentication flow with JWT and refresh tokens."
"Build this component based on the Figma spec I described."
"Create a REST API endpoint for paginated user listings."
"Write a migration to add a 'status' column to the orders table."
/build-plan "Payment integration with Stripe"
```

---

## Stage 4: Review & Test

```
/webapp-testing    → Write and run web app tests
/code-review       → Review current branch changes
```

**Common prompts:**
```
"Write unit tests for the OrderService class."
"What edge cases am I missing in this validation logic?"
"Review this PR diff and flag any security issues."
"What would break if I change this function signature?"
```

### External Skills (from Anthropic — install once)

These are official skills maintained by Anthropic, not bundled in this framework.
Install them all at once — no clone needed:

```
/setup-skills
```

| Skill | Source | When to use |
|---|---|---|
| `/frontend-design` | `anthropics/skills` | Build UI components directly from design specs |
| `/webapp-testing` | `anthropics/skills` | Write and run automated tests for web apps |
| `/mcp-builder` | `anthropics/skills` | Scaffold and build MCP server tools |
| `/skill-creator` | `anthropics/skills` | Anthropic's official guided skill creator |
| `/simplify` | `anthropics/claude-code` | Simplify and refactor complex code |

---

## Stage 5: Ship

```
/scrum-master         → Sprint planning, retrospectives, velocity tracking
/build-plan           → Deployment checklist, CI/CD steps
```

**Common prompts:**
```
"Create a deployment checklist for our v1.0 release."
"Write a GitHub Actions workflow for CI/CD on this stack."
"Help me draft the release notes for this sprint."
"What tasks need to be done before we can go to production?"
```

---

## Meta / Framework

```
/skill-creator        → Create a new skill for this framework
```

**Common prompts:**
```
/skill-creator "I need a skill for writing SQL migrations"
"Update this skill to also handle TypeScript types"
```

---

## CLAUDE.md Quick Reference

`CLAUDE.md` files give Claude persistent project context. They're loaded automatically when Claude starts in that directory.

**Where to put them:**
```
~/.claude/CLAUDE.md        ← Global (applies everywhere)
~/my-project/CLAUDE.md     ← Project root (auto-loaded by Claude Code)
```

> The project-root `CLAUDE.md` in this framework is a 3-line file that `@`-imports `.ai/AGENTS.md`.
> That is how `.ai/` content reaches Claude — not via a second `CLAUDE.md` inside `.ai/`.
> Keep substantive guidance in `.ai/AGENTS.md`; keep the root `CLAUDE.md` as a thin pointer.

**What to put in them:**
```markdown
# Project: MyApp

## Tech Stack
- Frontend: Next.js 14, TypeScript, Tailwind CSS
- Backend: Node.js, Express, PostgreSQL
- Auth: NextAuth with JWT

## Conventions
- Use kebab-case for file names
- Prefer functional components with hooks
- All API endpoints are prefixed /api/v1

## Important Files
- src/lib/auth.ts — authentication utilities
- src/db/schema.ts — Prisma schema
```

---

## MCP Servers (Model Context Protocol)

MCP servers add tools to Claude Code (databases, APIs, file systems, etc.).

```bash
# Add an MCP server to your config
claude mcp add <name> <command> [args...]

# List configured MCP servers
claude mcp list

# Remove an MCP server
claude mcp remove <name>
```

```json
// In settings.json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "your-token" }
    }
  }
}
```

---

## Tips & Patterns

**Give Claude your full context upfront:**
```
"I'm building a SaaS project management tool. Stack: Next.js, Prisma, PostgreSQL, Stripe.
Right now I need to implement..."
```

**Reference files explicitly:**
```
"Look at src/lib/auth.ts and explain the token refresh logic"
```

**Use roles to get role-specific thinking:**
```
/architect
"What are the tradeoffs between a monolith and microservices for our current scale?"
```

**Chain skills in a workflow:**
```
1. /product-owner — "Define the requirements for the notifications feature"
2. /architect     — "Design the system for those requirements"
3. /build-plan    — "Create the implementation plan"
4. /backend-dev   — "Implement the API endpoints"
5. /frontend-dev  — "Build the notification UI components"
```
