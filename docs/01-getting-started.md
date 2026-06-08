# Getting Started with Claude Code

Claude Code is an AI coding agent that lives in your terminal. It reads your project files, understands your codebase, and takes real actions — writing code, running commands, reading docs — on your behalf.

---

## Core Concepts

### How Claude Code works

Claude Code has access to your filesystem and shell. When you ask it something, it:
1. Reads relevant files to understand context
2. Thinks about the problem (with optional reasoning traces)
3. Takes actions: writes files, runs commands, searches the codebase
4. Reports back what it did and why

It's not just a chatbot — it's an agent that does work.

### CLAUDE.md — Your project context

`CLAUDE.md` is the most important file in this framework. It's automatically loaded by Claude Code when you start a session in that directory.

Use it to tell Claude:
- What the project is and does
- Your tech stack and conventions
- Important files and patterns
- Things Claude should never do (e.g., "never commit to main directly")

```markdown
# Project: PayFlow

## Stack
- Frontend: Next.js 14, TypeScript, Tailwind
- Backend: tRPC, Prisma, PostgreSQL (Supabase)
- Auth: Clerk

## Key conventions
- All server actions go in src/actions/
- Database queries use Prisma via src/lib/db.ts
- Never use `any` in TypeScript

## Do not
- Edit .env.local
- Run database migrations without asking me first
```

### Skills — Role-based agents

Skills are instruction sets that make Claude adopt a specific role and perspective. This framework ships with business and engineering skills:

```
/product-owner   → Requirements and planning mindset
/architect       → System design and trade-off analysis
/frontend-dev    → UI implementation with your stack
/backend-dev     → APIs, data, and infrastructure
/designer        → UX and component design
/scrum-master    → Sprint planning and delivery tracking
```

Invoke a skill at the start of a task to get role-appropriate output.

### Sessions — Persistent conversations

Claude Code maintains conversation history within a session. Use `/compact` when the conversation gets long (reduces context usage). Use `claude --continue` to pick up where you left off.

---

## First Run

### Step 1: Open a project

```bash
cd my-project
claude
```

### Step 2: Initialize project context

If your project doesn't have a `CLAUDE.md` yet:

```
/init
```

Claude will ask about your project and create a starter `CLAUDE.md`. Edit it to add your actual stack and conventions.

Alternatively, run `/product-init` — it generates the full project structure (`.ai/`, `documents/`, `platform/`) from your idea notes without any file copying.

### Step 3: Orient Claude to your codebase

First thing in a new session:

```
"Give me an overview of this codebase. What does it do and how is it structured?"
```

Claude reads your files and gives you a tour. This also loads the right context for the rest of your session.

### Step 4: Run your first skill

```
/product-owner
"I need to build a user notification system. What are the requirements we should define first?"
```

---

## Permission Modes

Claude Code asks for permission before taking certain actions. You can control this:

**Default (most cautious):**
```
claude
```
Asks before reading files, editing, or running any command.

**Accept Edits (recommended for most work):**
```json
// ~/.claude/settings.json
{ "defaultMode": "acceptEdits" }
```
Auto-approves file reads and edits. Still asks before shell commands.

**Auto-approve (for automated pipelines):**
Only use in CI/CD or sandboxed environments:
```json
{ "defaultMode": "bypassPermissions" }
```

---

## What Claude Code Is Good At

- **Exploring unfamiliar codebases** — "Explain how auth works in this project"
- **Implementing features end-to-end** — "Build the user profile page"
- **Debugging with context** — "This function throws a TypeError. Here's the stack trace."
- **Refactoring** — "Extract this logic into a reusable hook"
- **Writing tests** — "Write unit tests for the PaymentService class"
- **Code review** — "What are the issues with this PR diff?"
- **Architecture decisions** — "What's the best way to structure this feature?"
- **Documentation** — "Write a README for this module"

## What It's Not As Good At

- **Decisions that require business context** — Tell it what you want, not just what you have
- **Very large one-shot changes** — Break big features into steps
- **Tasks with no visible output** — Testing UI changes requires you to verify the browser
- **Knowing your preferences** — Tell it explicitly via `CLAUDE.md` or the prompt

---

## Tips for Effective Use

**Be specific about what you want:**
```
❌ "Fix the login"
✓ "The login form submits but the POST /api/auth/login returns 401 even with correct credentials.
   Look at the auth handler in src/app/api/auth/login/route.ts and find what's wrong."
```

**Give context before asking:**
```
"I'm adding a notifications feature. The user model is in prisma/schema.prisma.
Notifications should support email and in-app channels. Now, what data model do I need?"
```

**Use roles for specialized tasks:**
```
/architect
"We have 50k users now and the query in src/lib/listings.ts is too slow. 
What are the options for scaling this?"
```

**Iterate in small steps:**
Instead of "build the entire checkout flow", do:
1. "Define the data model for orders"
2. "Create the API endpoints"
3. "Build the checkout form component"
4. "Connect the form to the API"

**Review before accepting:**
Claude shows you what it's about to do. Read the diff before approving file changes, especially for large edits.
