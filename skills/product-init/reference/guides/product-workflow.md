# Product Workflow

The single stage-by-stage guide: what to run at each phase of product development, with prompt
templates and where the outputs live. Tool mechanics are in the
[Claude Code Guide](claude-code-guide.md); the full skill + agent roster lives in your project's
`.ai/playbook.md`.

```
0. INIT            → /product-init                  scaffold the knowledge base from idea notes
1. DEFINE          → /product-owner /user-story     requirements, stories, acceptance criteria
2. BLUEPRINTS      → /archetype /architect          architecture, data model, ADRs — and the
                                                    API-First contract (api-spec.md)
3. BACKEND & INFRA → backend-builder /backend-dev   implement the API per the contract
                     devops-engineer                CI/CD + environments from day one
4. UI/UX DRAFT     → /designer + frontend draft     low-fi working layouts against the REAL API —
                                                    validate flows and the contract, no polish
5. UI/UX DESIGN    → /design-review /designer       the formal, high-quality frontend
                     frontend-builder
6. REVIEW          → test-engineer qa-reviewer      tests, story review, security, drift
                     security-reviewer spec-compliance /code-review
7. SHIP            → devops-engineer (deploy)       deploy, release notes, progress log
                     /scrum-master progress-tracker
```

**Why this order.** Architecture before code; **backend before frontend** — building the UI first
produces a UI-shaped, disorganized backend. The API contract written at Blueprints is the gate:
the backend implements it, and the frontend (first as a draft, then as the formal design) is just
one consumer of it. That's the **API-First** principle — it also keeps the door open for
third-party/B2B integrations and headless use of the product.

Stages are iterative, not strictly linear — this map helps you pick the right tool at the right moment.

---

## Stage 0: Init

**Goal:** turn raw idea notes into a structured, self-describing knowledge base.

```
/product-init
"Here are my idea notes for [product]: [paste raw notes]"
```

Creates `CLAUDE.md`, `.ai/` (agent context, conventions, playbook, these guides), `documents/`
(vision, scope, roadmap, architecture, operations, business), and `platform/` (empty,
structure-documented). `documents/inputs/STAKEHOLDER-NOTES.md` becomes the **only file a
stakeholder hand-edits**; agents derive everything else from it.

Later, when new requirements arrive, add a dated entry to the stakeholder notes and run:
```
/product-init
"I added new requirements. Sync the docs."
```

**Output:** the `documents/` tree, with unknowns flagged in `operations/open-questions.md`.

---

## Stage 1: Define

**Goal:** structured requirements with acceptance criteria.
**Skills:** `/product-owner`, `/user-story`, `/design-review` (for analyzing reference/competitor material)

```
/product-owner
"Read documents/product/01-vision.md and documents/operations/open-questions.md.
Refine the product definition and help me resolve the highest-priority open questions."
```
```
/product-owner
"Given limited resources (2 devs, 8 weeks), what should be in the MVP and what should be cut?"
```
```
/user-story
"Read documents/product/02-scope.md.
Turn the features list into user stories with Given/When/Then acceptance criteria."
```

**Output:** refined `product/01-vision.md` and `02-scope.md`; stories in `product/user-stories.md`;
resolved/remaining items in `operations/open-questions.md`.

---

## Stage 2: Blueprints

**Goal:** the technical blueprints — architecture, data model, tech stack, and the **API contract**
— decided and recorded before any production code.
**Skills:** `/archetype`, `/architect`

Check the team's architecture library first:
```
/archetype
"Read documents/product/. Which architecture archetype fits this product? Apply the one I pick."
```
Applying an archetype pre-fills `architecture/03-tech-stack.md` and `01-overview.md` and seeds ADRs
as **Proposed** — then review them:
```
/architect
"Review the Proposed ADRs in documents/architecture/decisions/. Challenge anything that doesn't
fit our constraints, then mark what we agree on as Accepted."
```
No archetype fits? Design from scratch, then save the result for the next product:
```
/architect
"Read documents/ — especially product/01-vision.md, 02-scope.md, and operations/open-questions.md.
Propose the tech stack and system architecture. Write an ADR per decision."

/archetype
"Extract an archetype from this product's architecture and save it to the framework library."
```

**The API-First contract.** Before leaving this stage, write the API contract — it is the gate for
everything that follows:
```
/architect
"Design the API contract for the MVP scope: resources, operations, request/response shapes,
auth model, error codes, versioning. The UI is one consumer; third-party integration is another.
Write it to documents/architecture/api-spec.md; shared types go in platform/core/contracts."
```
Plus data modeling and comparisons as needed:
```
/architect  "Design the data model for [domain]. Include relationships, indexes, constraints."
/architect  "Compare [option A] vs [option B] for [need]. Recommend one for our scale."
```

**Output:** `architecture/01-overview.md`, `02-data-model.md`, `03-tech-stack.md`,
`api-spec.md` (the contract), Accepted ADRs in `architecture/decisions/`.

---

## Stage 3: Backend & Infra

**Goal:** implement the API per the contract, with CI/CD and environments from day one. The
contract is the gate — once it's implemented and stable, frontend work can start against it.
**Agents:** `backend-builder`, `devops-engineer` · **Skill:** `/backend-dev`

Start with the plan, then build backend-first:
```
/build-plan
"Read documents/architecture/ (especially api-spec.md) and documents/product/02-scope.md.
Generate a sequenced implementation plan: data layer → API per the contract → infra."
```
```
"Have the backend-builder implement the [domain] endpoints from documents/architecture/api-spec.md
and the Accepted ADRs."

/backend-dev
"Step 1 from the plan: create the schema for [entities]. Follow the data-model conventions."

"Have the devops-engineer set up CI/CD per documents/architecture/infrastructure.md —
gates on every PR, staging deploys on merge."
```

**Deviation rule:** if implementation reveals the contract needs to change, update
`api-spec.md` first (and the ADR if it's a design change) — code never silently diverges from the
contract.

**Output:** working API in `platform/` matching `api-spec.md`; pipeline in `platform/ops|infra/`;
a staging environment the frontend can develop against.

---

## Stage 4: UI/UX Draft

**Goal:** low-fidelity working layouts wired to the **real API** — validate the flows, the scope,
and the contract itself before investing in visual quality. No polish.
**Skill:** `/designer` (flows) · **Agents/skills:** `frontend-builder` or `/frontend-dev` in draft fidelity

```
/designer
"Read documents/product/02-scope.md and user-stories.md.
Map the primary user flows and the screen inventory. Save to documents/design/02-ux.md."
```
```
"Have the frontend-builder build DRAFT screens for the [feature] flow:
structure, navigation, forms, and real data wiring against the staging API only.
Use unstyled/default primitives, skip visual polish, and mark every screen with a DRAFT banner.
Purpose: validate the flow and the API contract."
```

Walk the drafts with the stakeholder; route findings back:
- Flow/scope problems → `/product-owner` (update scope/stories)
- Contract gaps (missing fields, awkward shapes) → update `api-spec.md` + backend (Stage 3 rule)

**Output:** clickable draft screens in `platform/`, validated flows in `design/02-ux.md`, a
confirmed API contract.

---

## Stage 5: UI/UX Design

**Goal:** the formal, high-quality frontend — replacing the draft screens.
**Skills:** `/design-review`, `/designer` · **Agent:** `frontend-builder`

```
/design-review
[attach Figma exports or mockups]
"Extract all components, interactions, and states. Save the specs to documents/design/02-ux.md."

/designer
"Define the design system for this product: tokens, primitives, component inventory.
Save to documents/design/design-system.md."

"Have the frontend-builder upgrade the draft [feature] screens to the formal design:
implement the design-system primitives in platform/core/ui-components, then rebuild the
feature screens with full states, accessibility, and the aesthetic standard. Remove DRAFT banners."
```

**Output:** the production frontend; shared primitives in `core/ui-components`;
`design/design-system.md` as the living spec.

---

## Stage 6: Review

**Goal:** catch bugs, spec drift, and security issues before merging/releasing.
**Agents:** `test-engineer`, `qa-reviewer`, `security-reviewer`, `spec-compliance` · **Skills:** `/code-review`, `/webapp-testing`

```
"Have the test-engineer write tests for story US-003 from its acceptance criteria."
"Have the qa-reviewer check the [feature] implementation against its story."
"Run the security-reviewer on platform/ before we ship the auth changes."
"Run spec-compliance — has the code drifted from documents/ (scope, ADRs, api-spec) since the last release?"
```
```
/code-review              # review current branch changes (or: /code-review ultra <PR#>)
```

**What reviews check:** acceptance-criteria coverage; auth & authorization on every protected path;
input validation; error handling; N+1 queries; edge cases; ADR + api-spec + allowed-imports compliance.

**Output:** findings fixed before merge; tests in the repo asserting the criteria.

---

## Stage 7: Ship

**Goal:** deploy safely, communicate the release, keep the record straight.
**Agents:** `devops-engineer`, `progress-tracker` · **Skills:** `/scrum-master`, `/build-plan`

```
/build-plan
"Create a production deployment checklist for [feature]. Include migrations, env vars, rollback."

"Have the devops-engineer prepare the production deploy per the pipeline — plan output for my review."

/scrum-master
"Write customer-facing release notes for [version]. Features shipped: [list]."

/scrum-master
"Run a retrospective. Completed: [...]. Left behind: [...]. Blockers: [...]."

"Have the progress-tracker log this release and give me a status report against the roadmap."
```

**Output:** production deploy; release notes; updated `operations/01-progress.md`.

---

## Worked example: one feature, end to end

```
1. /product-owner    "Define requirements for invoice creation: line items, multi-currency,
                      PDF email delivery, Stripe payment links."       → product/02-scope.md
2. /user-story       "Write stories with acceptance criteria."         → product/user-stories.md
3. /architect        "Data model + API contract for invoices (CRUD, send, payment webhook).
                      ADR for the PDF library."                        → architecture/, api-spec.md
4. /build-plan       "Sequenced plan: data → API → infra → draft UI → formal UI."
5. backend-builder   "Implement the invoice endpoints per api-spec.md."
6. devops-engineer   "CI gates + staging deploy."
7. frontend-builder  "DRAFT invoice screens against staging — flow validation only."
8.    [stakeholder walks the draft; contract gap found → api-spec.md updated → backend patched]
9. /designer         "Design system tokens + invoice form spec."       → design/
10. frontend-builder "Upgrade draft screens to the formal design."
11. test-engineer    "Tests for the invoice stories." · qa-reviewer "Check against stories."
12. /scrum-master    "Release notes." · progress-tracker "Log the sprint; status vs roadmap."
```

The handoff rule: **each stage writes its output into `documents/`, and the next stage reads it
from there** — never rely on conversation memory between stages.

---

## Managing context across sessions

Claude won't remember previous sessions unless the repo tells it. The framework's files do that job:

- **`.ai/AGENTS.md`** — permanent: behavioral rules, reading order, stack pointers. Keep it current.
- **`documents/operations/01-progress.md`** — current state: what's done / in progress / next.
  The `progress-tracker` agent maintains it; any session can resume from it:
  ```
  "Read documents/operations/01-progress.md and continue from where we left off."
  ```
- **`claude --continue`** — resumes the last conversation when you just stepped away.

---

## Utility prompts (any stage)

```
"Explain how platform/core/adapters/[x] works. I'm new to this codebase."
"Where is the email sending logic? Search for it."
"Rename getUserById to findUserById everywhere. Show me what changes before editing."
/skill-creator "I need a skill for [repeated task]"        # extend the framework itself
```
