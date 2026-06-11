# Agents Guide

How to use Claude Code's role-based agent skills effectively. Each agent brings a specialized perspective and vocabulary — knowing when to use which one makes your output dramatically better.

---

## Subagents vs role skills

The framework ships two different things, used differently:

| | Role skills (`/architect`, `/frontend-dev`, …) | Subagents (`agents/`) |
|---|---|---|
| What it does | Changes the **current conversation's** perspective and vocabulary | Spawns a **separate agent** with its own context window and tool permissions |
| Best for | Interactive work: deciding, discussing, iterating with you | Bounded, delegable tasks: "review this", "verify that", "build this whole feature" |
| Context | Shares everything already in your session | Starts fresh — gets only what its prompt and the repo give it |
| How to invoke | Type the slash command | Ask Claude to use it ("have the qa-reviewer check this story") or let Claude delegate proactively |

The plugin's subagents:

| Agent | Purpose | Tools |
|---|---|---|
| `qa-reviewer` | Reviews implemented code against acceptance criteria, conventions, and common defect classes. Reports findings — never edits. | Read-only |
| `spec-compliance` | Detects drift between `documents/` (the spec) and `platform/` (the code): scope, Accepted ADRs, tech stack, and the allowed-imports matrix. | Read-only |
| `security-reviewer` | OWASP Top-10 + threat pass over `platform/`, checked against the product's stated security model. Reports — never fixes. | Read-only |
| `frontend-builder` | Builds complete, polished UI features from a spec or design — typed React, all states handled, strong aesthetic judgment. | Full (edits files) |
| `backend-builder` | Builds complete backend features — API, data model, authz, migrations, tests — honoring Accepted ADRs and platform-layout placement. | Full (edits files) |
| `test-engineer` | Writes automated tests from a story's acceptance criteria, runs them, and reports criteria coverage. Never touches production code. | Test files only |
| `progress-tracker` | Keeps `operations/01-progress.md` and `open-questions.md` truthful after work lands; produces status reports (done/blocked/next vs roadmap). | `documents/operations/` only |
| `devops-engineer` | Builds fast, cached CI/CD pipelines and IaC scaffolding per the decided infrastructure. Plans/synths only — never applies to production. | Full (ops/infra paths) |

Typical flow: delegate to `frontend-builder`/`backend-builder` → `test-engineer` writes the tests → `qa-reviewer` checks the story → `security-reviewer` + `spec-compliance` before a release → `devops-engineer` ships it → `progress-tracker` logs it.

**Roles that deliberately stay skills, not agents:** the *stakeholder* is a human (an agent simulating one would invent requirements — forbidden by the framework's extraction rules); *product owner* and *solutions architect* are decision-heavy, interactive roles that need you in the loop (`/product-owner`, `/architect`, `/archetype` — the architect's delegable review half is already `spec-compliance`); *release manager* is covered by `/scrum-master`.

---

## Why Agents?

When you ask Claude a question without a role, it gives you a generalist answer. When you invoke an agent skill, Claude:
- Adopts domain-specific reasoning and vocabulary
- Prioritizes concerns relevant to that role
- Asks the questions that role would ask
- Formats output the way that role produces it

**Generic:** "How should I structure the database?"
**Architect agent:** Gives you schema options with trade-off analysis, normalization decisions, index recommendations, and migration considerations.

---

## The Agent Roster

### `/product-owner` — Product Owner

**Perspective:** Business value, user needs, scope management, prioritization

**When to use:**
- Turning rough ideas into requirements
- Deciding what to build (and what to cut)
- Writing acceptance criteria
- Backlog grooming and prioritization
- Stakeholder communication

**What it produces:**
- User stories (As a… / I want… / So that…)
- Acceptance criteria (Given/When/Then)
- Feature specifications
- Prioritized backlogs
- MoSCoW analysis (Must/Should/Could/Won't)

**Example invocations:**
```
/product-owner
"We're adding a notification feature. Define the requirements for MVP."

/product-owner
"The stakeholder wants real-time chat AND offline sync AND AI summaries in the next sprint.
Help me push back and scope this realistically."

/product-owner
"Write acceptance criteria for user authentication with Google OAuth."
```

---

### `/architect` — Software Architect

**Perspective:** System design, scalability, maintainability, technical trade-offs

**When to use:**
- Designing new systems or features from scratch
- Choosing between technical approaches
- Documenting Architecture Decision Records (ADRs)
- Reviewing for scalability and structural issues
- Data modeling

**What it produces:**
- System diagrams (described in text/Mermaid)
- Data models (Prisma, SQL schema)
- ADRs
- API designs
- Trade-off comparisons
- Risk assessments

**Example invocations:**
```
/architect
"Design the data model for a multi-tenant SaaS where each organization has their own data."

/architect
"We're at 100k users. Our single Postgres instance is starting to show strain.
What are our scaling options and what should we do first?"

/architect
"Compare serverless functions vs. always-on containers for our background jobs."
```

---

### `/frontend-dev` — Frontend Developer

**Perspective:** User experience, component design, state management, performance, accessibility

**When to use:**
- Building React/Vue/Svelte components
- Implementing designs from specs or mockups
- State management decisions
- Frontend performance optimization
- Form handling, validation, UX flows

**What it produces:**
- React components (TypeScript)
- Hooks and utilities
- Form implementations
- State management code
- CSS/Tailwind styling
- Performance optimizations

**Example invocations:**
```
/frontend-dev
"Build a DataTable component that supports sorting, filtering, and pagination.
Use our Tailwind conventions from src/styles/."

/frontend-dev
"The invoice form has poor UX when adding/removing line items.
How should I redesign the interaction? Then implement it."

/frontend-dev
"Optimize the dashboard page — it's slow to load. Profile it and fix the bottlenecks."
```

---

### `/backend-dev` — Backend Developer

**Perspective:** Data integrity, security, performance, API design, infrastructure

**When to use:**
- Building APIs and server logic
- Database queries and migrations
- Authentication and authorization
- Background jobs, queues, webhooks
- Infrastructure and deployment

**What it produces:**
- API endpoints (REST, tRPC, GraphQL)
- Prisma schemas and migrations
- Service layer code
- Auth middleware
- Webhook handlers
- CI/CD configs

**Example invocations:**
```
/backend-dev
"Implement the Stripe webhook handler for payment.succeeded events.
It should update the invoice status and send a confirmation email."

/backend-dev
"Our user query is doing a full table scan. Show me the slow query, add indexes,
and rewrite it to be efficient."

/backend-dev
"Set up a queue for sending emails so we don't block the request.
We're on Railway. What's the simplest approach that works at our scale?"
```

---

### `/designer` — UX/UI Designer

**Perspective:** User experience, visual hierarchy, accessibility, design systems, component design

**When to use:**
- Reviewing UI designs or screenshots
- Defining component design systems
- Accessibility audits
- UX flow analysis
- Analyzing competitor or reference designs

**What it produces:**
- Component specifications
- Design system documentation
- UX recommendations
- Accessibility issues list
- Figma analysis / screenshot breakdown

**Example invocations:**
```
/designer
[attach screenshot]
"Analyze this design for the invoice creation flow.
List every component, identify inconsistencies, and flag accessibility issues."

/designer
"We keep building one-off UI components. How should we structure our design system?
What are the core primitives we need to establish first?"

/designer
"The user drop-off rate on our onboarding flow is 60% at step 3.
Here's what step 3 looks like: [screenshot]. What's wrong and how do we fix it?"
```

---

### `/scrum-master` — Scrum Master

**Perspective:** Team delivery, process improvement, sprint management, blockers

**When to use:**
- Sprint planning and backlog ordering
- Retrospectives
- Tracking velocity and progress
- Writing release notes
- Post-mortems and incident analysis
- Team communication

**What it produces:**
- Sprint plans with task assignments
- Retrospective formats and summaries
- Release notes (technical and customer-facing)
- Incident post-mortems
- Velocity analysis

**Example invocations:**
```
/scrum-master
"Plan our next 2-week sprint. Team: 3 devs (2 full-stack, 1 frontend).
Backlog: [paste stories with points]. Our velocity is 22 points/sprint."

/scrum-master
"We shipped late on the payment feature by 3 weeks. Run a root cause analysis
and help me write an action plan for the retrospective."

/scrum-master
"Write customer-facing release notes for our v2.0 launch.
Key features: [list]. Keep it non-technical and highlight the value."
```

---

## Chaining Agents for Complex Tasks

The real power comes from chaining agents across a feature lifecycle:

### Example: Building a Notifications Feature

```
Step 1 — /product-owner
"Define requirements for in-app and email notifications.
User context: multi-tenant SaaS, 5 notification types, user preferences."

[Copy requirements to .ai/features/notifications-requirements.md]

Step 2 — /architect
"See .ai/features/notifications-requirements.md.
Design the system: data model, delivery flow, preferences storage."

[Copy design to .ai/features/notifications-design.md]

Step 3 — /build-plan
"See .ai/features/notifications-requirements.md and notifications-design.md.
Create a sequenced implementation plan."

Step 4 — /backend-dev
"Implement step 1-4 from the build plan.
Reference: .ai/features/notifications-design.md"

Step 5 — /frontend-dev
"Implement steps 5-8 from the build plan (UI components).
Reference: .ai/features/notifications-requirements.md for the UX specs."

Step 6 — /code-review
"Review the full notifications implementation for security and quality issues."

Step 7 — /scrum-master
"Write release notes and a deployment checklist for the notifications feature."
```

---

## Tips for Working with Agents

**Give agents enough context:**
Agents work best when they know your stack, constraints, and goals. Keep `.ai/AGENTS.md` updated with:
- Tech stack
- Current sprint / feature focus
- Key conventions

**Switch agents mid-conversation when perspective shifts:**
```
[In a conversation that started with /architect]
"Thanks — now let me hand this to the frontend side.

/frontend-dev
Given that architecture, how should I structure the React component tree?"
```

**Use agents to challenge each other:**
```
/product-owner
"The architect proposed adding a job queue for every background task.
From a product perspective, is this over-engineering for our current scale?"
```

**Ask agents to produce handoff artifacts:**
```
/architect
"Produce a one-page design brief that the frontend dev can use to implement
this feature without needing to re-understand the architecture decisions."
```

---

## Agent Anti-Patterns

**Don't use agents for trivial tasks:**
Invoking `/architect` to rename a variable or `/scrum-master` to write a one-liner commit message is overkill. Use agents for decisions and deliverables, not one-off tasks.

**Don't chain too many agents in one session without saving context:**
After each agent stage, save the output to a file in `.ai/` or `docs/`. The next agent can read it. Don't rely on Claude's conversation memory for handoffs between long stages.

**Don't let the agent's perspective override reality:**
If `/architect` suggests a solution that's too complex for your team, push back:
```
"That architecture is more complexity than we can handle with 2 devs.
What's the simpler version that still solves the core problem?"
```

**Don't skip the product owner stage:**
Building without defined requirements is the fastest way to build the wrong thing. Even if you're a solo developer, 10 minutes with `/product-owner` before building saves hours of rework.
