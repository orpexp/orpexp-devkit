# Commands by Development Stage

A quick-access reference for what to run at each stage of product development. Use this as a lookup when you're not sure which skill or prompt to reach for.

---

## Stage 1: Ideation & Discovery

You have a rough idea. You need to validate it and define scope before writing a line of code.

### Skills
```
/product-owner
/user-story
/design-review
```

### Prompts

**Validate the idea:**
```
/product-owner
"Here's my startup idea: [describe it]. What are the core assumptions I need to validate 
before building? What's the riskiest part?"
```

**Define MVP scope:**
```
/product-owner
"I want to build [product]. Given limited resources (2 devs, 8 weeks), 
what should be in the MVP and what should be cut?"
```

**Extract user stories from notes:**
```
/user-story
"Here are my stakeholder notes: [paste notes]
Extract user stories in 'As a [role], I want [goal] so that [value]' format.
Group them by feature area."
```

**Analyze a competitor or reference app (screenshot):**
```
/design-review
[attach screenshot]
"Analyze this competitor's dashboard. What features do they have?
What can I learn from their UX for my own product?"
```

**Analyze a Figma design (exported image):**
```
/design-review
[attach Figma screenshot or exported frame]
"List all UI components visible in this design.
Identify the interactions and state changes I need to implement."
```

---

## Stage 2: Planning & Specification

You know what you're building. Now you need requirements, user stories, and a project plan.

### Skills
```
/product-owner
/user-story
/scrum-master
```

### Prompts

**Write acceptance criteria:**
```
/product-owner
"Feature: User authentication with email and Google OAuth.
Write detailed acceptance criteria for each flow."
```

**Create a product backlog:**
```
/product-owner
"Here are our MVP features: [list].
Create a prioritized product backlog with story points (1, 2, 3, 5, 8)."
```

**Write a feature spec:**
```
/product-owner
"Write a detailed feature specification for [feature name].
Include: overview, user personas, user flows, requirements, out of scope, success metrics."
```

**Sprint planning:**
```
/scrum-master
"We have 2 developers and a 2-week sprint.
Backlog: [list features with story points].
Create a sprint plan that maximizes value delivery."
```

**Define a user story map:**
```
/user-story
"Map out the user journey for our onboarding flow.
Show the backbone (high-level activities) and the tasks under each."
```

---

## Stage 3: Architecture & Design

You have requirements. Now you need a technical plan before building.

### Skills
```
/architect
/designer
/backend-dev (for data modeling)
```

### Prompts

**System architecture:**
```
/architect
"Stack: [your stack]. Feature: [describe it].
Design the system architecture. Include: components, data flow, integration points."
```

**Data model:**
```
/architect
"Design the database schema for [feature].
Show Prisma schema format. Include relationships, indexes, and constraints."
```

**Tech stack decision:**
```
/architect
"We need a background job system. Options: Bull/BullMQ, pg-boss, Inngest.
Compare them for our use case: [describe scale, reliability needs, stack]."
```

**Write an ADR:**
```
/architect
"We decided to [decision]. Write an Architecture Decision Record.
Context: [why we needed to decide]. Alternatives: [what we considered]. Consequences: [tradeoffs]."
```

**Component architecture:**
```
/designer
"Design the component hierarchy for [feature].
We use React with Tailwind. Show: layout components, feature components, shared primitives."
```

**Design system audit:**
```
/designer
[attach screenshot]
"Audit this UI design for consistency issues.
What components should be part of our design system? What's inconsistent?"
```

**API design:**
```
/architect
"Design the REST API for [feature].
Include: endpoint paths, HTTP methods, request/response shapes, auth requirements, error codes."
```

---

## Stage 4: Implementation

You have a plan. Now you build.

### Skills
```
/build-plan
/frontend-dev
/backend-dev
```

### Prompts

**Generate a build plan:**
```
/build-plan
"Feature: [name and brief description]
Stack: [your stack]
Requirements: [paste requirements]
Give me a sequenced implementation plan with numbered steps."
```

**Database migration:**
```
/backend-dev
"Add the following to our Prisma schema: [describe changes].
Generate the schema changes and the migration SQL."
```

**API endpoint:**
```
/backend-dev
"Implement POST /api/[resource] for [feature].
Auth: required (use our Clerk middleware pattern from src/middleware.ts).
Validate input with Zod. Follow the pattern in src/app/api/clients/route.ts."
```

**Service layer:**
```
/backend-dev
"Create a [FeatureName]Service class in src/services/.
Methods: [list methods with inputs/outputs].
Use our Prisma client from src/lib/db.ts."
```

**React component:**
```
/frontend-dev
"Build the [ComponentName] component.
Props: [list props and types]
Behavior: [describe interactions and state]
Styling: Tailwind, match the pattern in src/components/[similar component]."
```

**Form implementation:**
```
/frontend-dev
"Create a form for [entity].
Fields: [list fields with types and validation rules]
Use react-hook-form + Zod. Submit via our trpc router at src/server/routers/[router].ts."
```

**Fix a bug:**
```
/backend-dev
"I'm getting this error: [paste error + stack trace]
It happens when [describe scenario].
Relevant file: [file path]"
```

**Performance optimization:**
```
/backend-dev
"This query is slow (500ms+): [paste the Prisma query or SQL]
It runs on every page load. Optimize it. Explain the trade-offs."
```

---

## Stage 5: Testing & Quality

Code is written. Now catch problems before they reach production.

### Skills
```
/webapp-testing
/code-review
```

### Prompts

**Unit tests:**
```
/webapp-testing
"Write unit tests for src/services/InvoiceService.ts.
Cover the main success paths and key error cases.
Use Vitest. Follow patterns in __tests__/services/."
```

**Integration tests:**
```
/webapp-testing
"Write integration tests for the POST /api/invoices endpoint.
Test: successful creation, validation errors, auth rejection, duplicate handling."
```

**Security review:**
```
/code-review
"Review src/app/api/ for security issues.
Specifically check: auth on every protected route, input validation, SQL injection risks,
rate limiting, sensitive data exposure."
```

**Performance review:**
```
/code-review
"Review src/lib/db/queries.ts for performance issues.
Look for: N+1 queries, missing indexes, over-fetching, non-paginated queries."
```

**Accessibility review:**
```
/designer
"Review the InvoiceForm component for accessibility issues.
Check: keyboard navigation, ARIA labels, color contrast, focus management."
```

**Full code review:**
```
/code-review
# Reviews current branch vs main
```

---

## Stage 6: Deployment & Shipping

Code is tested. Time to ship.

### Skills
```
/build-plan
/scrum-master
/backend-dev
```

### Prompts

**Deployment checklist:**
```
/build-plan
"Create a production deployment checklist for [feature].
Stack: [your deployment stack — Vercel, Railway, AWS, etc.]
Include: pre-deploy checks, migration steps, environment variables, rollback plan."
```

**CI/CD pipeline:**
```
/backend-dev
"Write a GitHub Actions workflow for this project.
Runs on: PR opened, push to main.
Steps: typecheck, lint, test, build.
On main merge: deploy to [platform]."
```

**Environment variables audit:**
```
/backend-dev
"Audit our .env.example and list all environment variables needed for production.
Group by: required vs optional, service, and sensitivity level."
```

**Release notes:**
```
/scrum-master
"Write release notes for version [x.y.z].
Features shipped: [list]
Bug fixes: [list]
Breaking changes: [any]
Audience: non-technical customers."
```

**Incident post-mortem:**
```
/scrum-master
"Write a post-mortem for this incident:
What happened: [describe]
Timeline: [sequence of events]
Impact: [users affected, duration]
Root cause: [technical cause]
Action items: [what we're fixing]"
```

**Sprint retrospective:**
```
/scrum-master
"Run a sprint retrospective.
Completed: [list]
Not completed: [list]
Blockers we hit: [list]
Format: What went well / What didn't / What we'll change."
```

---

## Utility Commands (Any Stage)

**Explain unfamiliar code:**
```
"Explain how src/lib/auth.ts works. I'm new to this codebase."
```

**Find where something is implemented:**
```
"Where is the email sending logic in this codebase? Search for it."
```

**Rename / refactor safely:**
```
"Rename the function getUserById to findUserById everywhere in the codebase. 
Show me what would change before making any edits."
```

**Generate documentation:**
```
"Write a README for src/services/PaymentService.ts.
Include: what it does, public methods with params/return types, usage example."
```

**Quick prototype:**
```
/frontend-dev
"Mock up a rough prototype of [feature] with static data.
I just need to see the layout — no real functionality needed yet."
```
