---
name: build-plan
description: >-
  Generate a sequenced implementation plan for a feature or task. Use when the user wants to:
  break down a feature into ordered development steps, get a build sequence before starting
  implementation, create a deployment checklist, plan a migration, or organize complex work
  into a step-by-step roadmap. Produces an actionable numbered plan you can follow task by task.
---

# Build Plan Skill

You generate clear, sequenced implementation plans that a developer can follow step-by-step. Given a feature description and tech stack, you produce an ordered list of tasks from "nothing" to "working, deployed code."

---

## How to Generate a Build Plan

### Information to gather first

Before generating the plan, confirm you have:
1. **Feature name and brief description** — What are we building?
2. **Tech stack** — Framework, database, auth, hosting
3. **Scope** — What's in / what's out for this plan?
4. **Starting point** — Greenfield? Adding to existing system? Migration?
5. **Requirements** — User stories or acceptance criteria if available

If any of these are missing, ask for them before generating the plan.

### Sequencing principles

A good build plan follows this order:
1. **Database / data model** — Schema, migrations
2. **Backend / API** — Service layer, routes, validation
3. **Auth & authorization** — Permissions for the new feature
4. **Background jobs / async** — Queues, webhooks, scheduled tasks
5. **Frontend / UI** — Components, forms, state management
6. **Integration** — Connect frontend to backend
7. **Testing** — Unit tests, integration tests
8. **Deployment** — Migration plan, environment variables, CI/CD
9. **Cleanup** — Remove feature flags, update docs

Build **bottom-up** (data → API → UI) unless the user has a specific reason to do otherwise.

---

## Plan Format

```markdown
# Build Plan: [Feature Name]

**Stack:** [List tech stack]
**Estimated effort:** [S/M/L/XL or story points]

## Prerequisites
- [ ] [Anything that must be in place before starting]

## Steps

### Phase 1: Data Model
- [ ] **Step 1:** [Task description]
  - Files to create/modify: [paths]
  - Notes: [any gotchas or decisions]

- [ ] **Step 2:** [Task description]
  - Files: [paths]

### Phase 2: Backend / API
- [ ] **Step 3:** [Task description]
- [ ] **Step 4:** [Task description]

### Phase 3: Frontend
- [ ] **Step 5:** [Task description]
- [ ] **Step 6:** [Task description]

### Phase 4: Testing
- [ ] **Step 7:** Write unit tests for [service/function]
- [ ] **Step 8:** Write integration tests for [endpoint]
- [ ] **Step 9:** Manual QA checklist

### Phase 5: Deployment
- [ ] **Step 10:** Run migration in staging, verify
- [ ] **Step 11:** Deploy to production
- [ ] **Step 12:** Verify in production

## Rollback Plan
If deployment fails:
- [Step 1: revert steps]
- [Step 2: ...]

## Open Questions
- [Question that needs answering before or during build]
```

---

## Example: Stripe Payment Integration Build Plan

```markdown
# Build Plan: Stripe Payment Integration

**Stack:** Next.js 14, Prisma/PostgreSQL, Stripe, Resend
**Estimated effort:** L (5-8 days)

## Prerequisites
- [ ] Stripe account created and API keys available
- [ ] Invoice feature complete and deployed

## Steps

### Phase 1: Data Model
- [ ] **Step 1:** Add payment fields to Invoice model in Prisma schema
  - Add: `stripePaymentIntentId`, `paidAt`, `stripeCustomerId`
  - Files: `prisma/schema.prisma`
- [ ] **Step 2:** Create and run migration
  - Command: `npx prisma migrate dev --name add-stripe-payment-fields`

### Phase 2: Backend / API
- [ ] **Step 3:** Create Stripe client utility
  - Files: `src/lib/stripe.ts`
  - Note: Initialize with API key from env, export singleton

- [ ] **Step 4:** Create payment intent endpoint
  - Files: `src/app/api/invoices/[id]/payment-intent/route.ts`
  - Creates Stripe PaymentIntent for invoice amount
  - Returns `clientSecret` for frontend

- [ ] **Step 5:** Create Stripe webhook handler
  - Files: `src/app/api/webhooks/stripe/route.ts`
  - Events: `payment_intent.succeeded`, `payment_intent.payment_failed`
  - Updates invoice status and sends confirmation email
  - Note: Must verify Stripe signature

- [ ] **Step 6:** Add webhook secret to environment
  - Update `.env.example` with `STRIPE_WEBHOOK_SECRET`

### Phase 3: Frontend
- [ ] **Step 7:** Install Stripe.js
  - `npm install @stripe/stripe-js @stripe/react-stripe-js`

- [ ] **Step 8:** Create PaymentForm component
  - Files: `src/components/PaymentForm.tsx`
  - Uses Stripe Elements for card input
  - Shows success/error states

- [ ] **Step 9:** Add payment page for clients
  - Files: `src/app/pay/[invoiceId]/page.tsx`
  - Public route (no auth required)
  - Loads invoice, renders PaymentForm

### Phase 4: Testing
- [ ] **Step 10:** Unit test the webhook handler
  - Mock Stripe events, verify status updates

- [ ] **Step 11:** Integration test payment flow in staging
  - Use Stripe test cards: `4242 4242 4242 4242`
  - Test: successful payment, declined card, webhook delivery

### Phase 5: Deployment
- [ ] **Step 12:** Register webhook endpoint in Stripe dashboard
  - URL: `https://[your-domain]/api/webhooks/stripe`
  - Events: payment_intent.succeeded, payment_intent.payment_failed
- [ ] **Step 13:** Add production env variables in Vercel/host
- [ ] **Step 14:** Run migration in production
- [ ] **Step 15:** Smoke test with real card in production

## Rollback Plan
- Stripe payment link can be disabled in Stripe dashboard
- Webhook can be disabled without reverting code
- No irreversible database changes in this plan

## Open Questions
- [ ] Should payment page be branded with client-facing brand or our brand?
- [ ] Do we need to store payment method for recurring invoices?
```

---

## Deployment Checklist Mode

When invoked with a deployment context:

```markdown
# Deployment Checklist: [Release Name]

## Day Before
- [ ] All PRs merged
- [ ] CI/CD pipeline green
- [ ] Staging deployment tested
- [ ] Database migration tested in staging
- [ ] Team notified of deployment window

## Deploy Day

### Pre-checks
- [ ] Production database backup confirmed (check timestamp)
- [ ] Monitoring dashboards open: [urls]
- [ ] Runbook available: [link]
- [ ] On-call / support aware

### Deployment
- [ ] Run migration: `[command]`
  - Expected duration: [X minutes]
  - Lock impact: [tables affected]
- [ ] Deploy application: [platform steps]
- [ ] Verify health endpoint: `[url]` returns 200
- [ ] Check error rate baseline unchanged

### Post-deploy (first 30 min)
- [ ] Smoke test: [list 3-5 key user flows]
- [ ] Check logs for unexpected errors
- [ ] Verify key metrics: [list metrics to check]
- [ ] Confirm feature flag enabled/disabled as expected

## Rollback Trigger
Roll back if:
- Error rate > [X]% above baseline
- [Key flow] is broken
- Any P1 report within 30 min of deploy

## Rollback Steps
1. [Revert deployment step]
2. [Revert migration if needed — state if this is possible]
3. [Notify stakeholders]
```

---

## Migration Plan Mode

For database migrations with risk:

```markdown
# Migration Plan: [Migration Name]

**Risk level:** [Low / Medium / High]
**Downtime required:** [Yes / No — and why]
**Estimated duration:** [X minutes]

## Pre-migration
- [ ] Backup created and verified
- [ ] Migration tested on production data copy (staging)
- [ ] Rollback script written and tested

## Migration Steps
1. [Step 1]
2. [Step 2]

## Verification
- [ ] Row count matches expected
- [ ] Spot-check [X rows] manually
- [ ] Application working correctly on migrated data

## Rollback
```sql
-- Rollback script
[SQL to revert]
```

---

## Guardrails

- Always sequence database changes before application code changes
- Never include "write all the code" as a single step — break it down
- Flag steps that require coordination (team notifications, database windows, external vendor steps)
- If you don't know the stack, ask before generating — wrong stack assumptions waste time
- Mark steps with explicit file paths so the developer knows exactly where to work
- Flag any step that is risky, irreversible, or requires extra care with ⚠️
