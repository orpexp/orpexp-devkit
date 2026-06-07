# Project Workflow: Building a Product with Claude Code

This guide walks through the full lifecycle of a software product — from raw idea to deployed code — using Claude Code at every stage.

---

## The 5-Stage Workflow

```
DEFINE → DESIGN → BUILD → REVIEW → SHIP
```

Each stage has corresponding skills and recommended prompts. You don't always follow them in strict order — real development is iterative — but this map helps you pick the right tool at the right moment.

---

## Stage 1: Define

**Goal:** Turn stakeholder notes or a product idea into structured requirements.

**When to use:** Starting a new feature, product, or when requirements are fuzzy.

**Skills:** `/product-owner`, `/user-story`, `/design-review`

### Workflow

1. Open Claude Code in your project directory
2. Dump your raw notes or idea into the conversation
3. Run `/product-owner` to enter requirements mode
4. Extract user stories, acceptance criteria, and open questions

### Example Session

```
/product-owner

I'm building a freelancer invoicing tool. Here are my rough notes:
- Users should be able to create invoices with line items
- Support multiple currencies
- Send invoices by email as PDF
- Track payment status (sent, viewed, paid, overdue)
- Stripe integration for online payment

Help me turn this into structured requirements.
```

Claude will:
- Identify core user stories
- Flag missing requirements (who are the users? what's the auth model?)
- Suggest an MVP scope
- Write acceptance criteria

Then:
```
/user-story
"Take the invoice creation requirement and write 3 user stories with acceptance criteria."
```

If you have a design mockup or screenshot:
```
/design-review
[attach screenshot or paste Figma link]
"List all the UI components and interactions visible in this design."
```

### Output

By end of Define stage you should have:
- A feature brief (what we're building and why)
- User stories with acceptance criteria
- A list of open questions / assumptions
- A rough component/feature list

Store these in `docs/` or `.ai/` so Claude has them in future sessions.

---

## Stage 2: Design

**Goal:** Decide the architecture, data model, and tech approach before writing production code.

**Skills:** `/architect`, `/designer`

### Workflow

1. Share your requirements and current tech stack
2. Run `/architect` for system design and data modeling
3. Run `/designer` for UI/UX architecture if applicable
4. Document decisions as Architecture Decision Records (ADRs)

### Example Session

```
/architect

Here's my stack: Next.js 14, Prisma, PostgreSQL, Stripe, Resend for email.

Requirements for the invoicing feature:
- Create/edit/delete invoices with line items
- Multiple currencies (store in USD, display in selected currency)
- PDF generation and email delivery
- Payment tracking with Stripe webhooks

Design the data model and system architecture.
```

Claude will propose:
- Prisma schema (Invoice, LineItem, Payment models)
- API route structure
- Stripe webhook flow
- PDF generation approach
- Potential edge cases

For UI architecture:
```
/designer
"Design the component hierarchy for the invoice creation form.
Include the line item table, currency selector, and preview panel."
```

### ADR Pattern

For major decisions, ask Claude to write an Architecture Decision Record:

```
/architect
"We decided to use react-pdf for PDF generation instead of Puppeteer.
Write an ADR documenting this decision with the context, alternatives we considered, and consequences."
```

Save ADRs in `docs/architecture/decisions/`.

### Output

- Data model / schema
- API design
- Component hierarchy
- ADRs for key decisions
- Tech risk list

---

## Stage 3: Build

**Goal:** Write production-quality code, one feature at a time.

**Skills:** `/frontend-dev`, `/backend-dev`, `/build-plan`

### Workflow

1. Run `/build-plan` for a feature to get a sequenced implementation plan
2. Build in the recommended order (usually: data → API → UI)
3. Use `/backend-dev` for server-side work, `/frontend-dev` for client-side
4. Commit working increments frequently

### Start with a build plan

```
/build-plan

Feature: Invoice creation
Stack: Next.js 14, Prisma (PostgreSQL), Stripe, react-pdf, Resend

Requirements:
- Create invoice with 1-N line items
- Currencies: USD, EUR, GBP (store in USD cents)
- Generate PDF, email to client
- Create Stripe payment link

Give me a sequenced implementation plan.
```

Claude returns a numbered task list. Follow it step-by-step.

### Backend implementation

```
/backend-dev

Step 1 from the plan: Create the Prisma schema for Invoice and LineItem.
Current schema is in prisma/schema.prisma.
Add the new models following our existing conventions (uuid IDs, createdAt/updatedAt).
```

After schema: migrations, then API routes.

### Frontend implementation

```
/frontend-dev

Build the InvoiceForm component.
It should have:
- A form with client name, email, currency selector, due date
- A dynamic line items table (add/remove rows, quantity, rate, description)
- A real-time total calculation
- A "Save Draft" and "Send Invoice" button

Use Tailwind for styling. Match the pattern in src/components/forms/ClientForm.tsx.
```

### The build loop

For each implementation step:
1. Ask Claude to implement it
2. Review the diff
3. Run tests / check the browser
4. Fix any issues
5. Commit
6. Move to next step

```
"Tests are failing for the LineItem model. Here's the error: [paste error]"
```

---

## Stage 4: Review

**Goal:** Catch bugs, security issues, and code quality problems before merging.

**Skills:** `/code-review`, `/webapp-testing`

### Code review

```
/code-review

# Or for a GitHub PR:
/code-review ultra 42
```

For a targeted review:
```
"Review src/app/api/invoices/route.ts for security issues.
Focus on authorization — should any user be able to read any invoice?"
```

### Writing tests

```
/webapp-testing

Write integration tests for the invoice creation API endpoint.
The endpoint is POST /api/invoices in src/app/api/invoices/route.ts.
It requires auth via Clerk. Use Vitest and the test patterns in __tests__/api/.
```

### What to look for in reviews

Ask Claude to specifically check:
- **Auth & authorization** — Can users access each other's data?
- **Input validation** — Are all user inputs validated and sanitized?
- **Error handling** — Are errors caught and handled gracefully?
- **Performance** — Any N+1 queries? Missing indexes?
- **Edge cases** — What happens with empty inputs, max values, concurrent requests?

---

## Stage 5: Ship

**Goal:** Deploy safely and communicate the release.

**Skills:** `/scrum-master`, `/build-plan`

### Deployment checklist

```
/build-plan

Create a deployment checklist for the invoice feature going to production.
Stack: Vercel (frontend), Supabase (DB), Stripe (payments).
Include: database migrations, environment variables, Stripe webhook registration.
```

### CI/CD pipeline

```
/backend-dev

Write a GitHub Actions workflow for this project.
Should: run TypeScript checks, Prisma validate, unit tests, build check.
Runs on PR and push to main.
```

### Release notes

```
/scrum-master

Write release notes for the invoice feature sprint.
Completed stories:
- Invoice creation with line items
- PDF generation and email delivery
- Stripe payment link integration
- Payment status tracking
```

### Sprint retrospective

```
/scrum-master

Run a quick retrospective for our last sprint.
We completed: [features]
We left behind: [incomplete items]
Issues we hit: [blockers]

What should we do differently next sprint?
```

---

## Managing Context Across Sessions

For large projects, Claude won't remember what you did in previous sessions unless you provide context. Use these patterns:

### `.ai/CLAUDE.md` — Permanent project context

Keep this file updated as your project evolves:

```markdown
## Current Sprint
Working on: Invoice feature (in progress)
Completed: Client management, Dashboard

## Architecture Decisions
- PDF: react-pdf (see docs/architecture/decisions/002-pdf-library.md)
- Currency: stored in USD cents, converted at display time

## Known Issues
- PDF generation is slow >5 line items — defer to async job later
```

### Session opener

Start each session with:
```
"Continue working on the invoice feature. 
We completed the Prisma schema and API routes.
Next step: InvoiceForm component."
```

### `--continue` flag

Resume the last session (retains conversation history):
```bash
claude --continue
```

---

## Multi-Agent Pattern (Advanced)

For complex features, use multiple agents in sequence:

```
1. /product-owner  → define requirements → save to docs/requirements/invoice.md
2. /architect      → design system → save to docs/architecture/invoice-design.md
3. /build-plan     → create task list → work from the list
4. /backend-dev    → implement API (reference the design doc)
5. /frontend-dev   → implement UI (reference requirements + design)
6. /code-review    → review everything
```

Pass the output of each stage as context to the next:

```
/backend-dev
"See docs/architecture/invoice-design.md for the design.
Implement step 3 from docs/build-plans/invoice.md"
```
