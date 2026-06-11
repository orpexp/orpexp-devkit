# Product Workflow

The single stage-by-stage guide: what to run at each phase of product development, with prompt
templates and where the outputs live. Tool mechanics are in the
[Claude Code Guide](01-claude-code-guide.md); the full roster with when-to-use-which is in
[Skills & Agents](03-skills-and-agents.md).

```
0. INIT    → /product-init                 scaffold the knowledge base from idea notes
1. DEFINE  → /product-owner /user-story    requirements, stories, acceptance criteria
2. DESIGN  → /archetype /architect         architecture + tech stack (library or from scratch)
             /designer /design-review      UX, component specs
3. BUILD   → /build-plan                   sequenced plan
             /frontend-dev /backend-dev    interactive implementation
             frontend-builder backend-builder    delegated implementation (agents)
4. REVIEW  → test-engineer qa-reviewer     tests + story review (agents)
             security-reviewer spec-compliance   security + drift checks (agents)
             /code-review /webapp-testing
5. SHIP    → devops-engineer (agent)       CI/CD + deploy
             /scrum-master                 sprint planning, release notes
             progress-tracker (agent)      progress log + status reports
```

Stages are iterative, not strictly linear — this map helps you pick the right tool at the right moment.

---

## Stage 0: Init

**Goal:** turn raw idea notes into a structured, self-describing knowledge base.

```
/product-init
"Here are my idea notes for [product]: [paste raw notes]"
```

Creates `CLAUDE.md`, `.ai/` (agent context + conventions + playbook), `documents/` (vision, scope,
roadmap, architecture, operations, business), and `platform/` (empty, structure-documented).
`documents/inputs/STAKEHOLDER-NOTES.md` becomes the **only file a stakeholder hand-edits**; agents
derive everything else from it.

Later, when new requirements arrive, add a dated entry to the stakeholder notes and run:
```
/product-init
"I added new requirements. Sync the docs."
```

**Output:** the `documents/` tree, with unknowns flagged in `operations/open-questions.md`.

---

## Stage 1: Define

**Goal:** structured requirements with acceptance criteria.
**Skills:** `/product-owner`, `/user-story`, `/design-review` (if you have reference designs)

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
```
/design-review
[attach screenshot or Figma export]
"List all UI components and interactions visible in this design."
```

**Output:** refined `product/01-vision.md` and `02-scope.md`; stories in `product/user-stories.md`;
resolved/remaining items in `operations/open-questions.md`.

---

## Stage 2: Design

**Goal:** decide the architecture, tech stack, and UX before writing production code.
**Skills:** `/archetype`, `/architect`, `/designer`

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
For data modeling, comparisons, and UX:
```
/architect  "Design the data model for [domain]. Include relationships, indexes, constraints."
/architect  "Compare [option A] vs [option B] for [need]. Recommend one for our scale."
/designer   "Design the component hierarchy for [feature]. Show layout, feature, and shared primitives."
```

**Output:** `architecture/01-overview.md`, `02-data-model.md`, `03-tech-stack.md`, Accepted ADRs in
`architecture/decisions/`, UX specs in `design/02-ux.md`.

---

## Stage 3: Build

**Goal:** production-quality code, one sequenced step at a time.
**Skills:** `/build-plan`, `/frontend-dev`, `/backend-dev` · **Agents:** `frontend-builder`, `backend-builder`

Always start with the plan:
```
/build-plan
"Read documents/architecture/ and documents/product/02-scope.md.
Generate a sequenced implementation plan for the MVP."
```
Then implement — interactively with the dev skills:
```
/backend-dev
"Step 1 from the plan: create the schema for [entities].
Follow our existing conventions in platform/data/."

/frontend-dev
"Build the [Component]. Props: [...]. Behavior: [...].
Match the pattern in platform/core/ui-components/."
```
…or delegate whole features to the builder agents:
```
"Have the backend-builder implement the [feature] API from the build plan and the Accepted ADRs."
"Have the frontend-builder build the [feature] page from documents/design/02-ux.md."
```

**The build loop:** implement → review the diff → run tests / check the browser → commit → next step.

**Output:** working increments in `platform/`, committed frequently.

---

## Stage 4: Review

**Goal:** catch bugs, spec drift, and security issues before merging.
**Agents:** `test-engineer`, `qa-reviewer`, `security-reviewer`, `spec-compliance` · **Skills:** `/code-review`, `/webapp-testing`

```
"Have the test-engineer write tests for story US-003 from its acceptance criteria."
"Have the qa-reviewer check the [feature] implementation against its story."
"Run the security-reviewer on platform/ before we ship the auth changes."
"Run spec-compliance — has the code drifted from documents/ since the last release?"
```
```
/code-review              # review current branch changes (or: /code-review ultra <PR#>)
```

**What reviews check:** acceptance criteria coverage; auth & authorization on every protected path;
input validation; error handling; N+1 queries; edge cases; ADR + allowed-imports compliance.

**Output:** findings to fix before merge; tests in the repo asserting the criteria.

---

## Stage 5: Ship

**Goal:** deploy safely, communicate the release, keep the record straight.
**Agents:** `devops-engineer`, `progress-tracker` · **Skills:** `/scrum-master`, `/build-plan`

```
"Have the devops-engineer set up CI/CD per documents/architecture/infrastructure.md."

/build-plan
"Create a production deployment checklist for [feature]. Include migrations, env vars, rollback."

/scrum-master
"Write customer-facing release notes for [version]. Features shipped: [list]."

/scrum-master
"Run a retrospective. Completed: [...]. Left behind: [...]. Blockers: [...]."

"Have the progress-tracker log this release and give me a status report against the roadmap."
```

**Output:** pipeline in `platform/ops|infra/`; release notes; updated `operations/01-progress.md`.

---

## Worked example: one feature, end to end

```
1. /product-owner   "Define requirements for invoice creation: line items, multi-currency,
                     PDF email delivery, Stripe payment links."        → product/02-scope.md
2. /user-story      "Write stories with acceptance criteria for invoice creation."
                                                                       → product/user-stories.md
3. /architect       "Design data model + webhook flow for invoices. ADR for the PDF library."
                                                                       → architecture/, ADRs
4. /build-plan      "Sequenced plan for invoice creation."             → numbered task list
5. /backend-dev     "Step 1: Invoice + LineItem schema per the data model."
6. /frontend-dev    "Build InvoiceForm: dynamic line-item table, currency selector, live total."
7. test-engineer    "Write tests for the invoice stories."
8. qa-reviewer      "Check the implementation against the stories."
9. /scrum-master    "Release notes for the invoicing sprint."
10. progress-tracker "Log the sprint; status report vs roadmap."
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
