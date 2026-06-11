---
doc: readme
purpose: Index of the knowledge base — every doc, its purpose, and where to look for what
status: living
owner: agent
derived_from: documents/inputs/STAKEHOLDER-NOTES.md
last_updated: {{DATE}}
---

# {{PRODUCT_NAME}} — Knowledge Base Index

> Read this first. Every doc in `documents/` is listed here with its one-line purpose. When a doc
> is added or removed, this index is updated in the same change — it must always list exactly the
> docs that exist.

## Core docs

| Doc | Purpose |
|---|---|
| [`inputs/STAKEHOLDER-NOTES.md`](inputs/STAKEHOLDER-NOTES.md) | ⭐ Stakeholder's raw notes + change log — the single hand-edited source of intent (read-only to agents) |
| [`product/01-vision.md`](product/01-vision.md) | Problem, solution, value proposition, target users, positioning |
| [`product/02-scope.md`](product/02-scope.md) | MVP scope (in/out), phases, feature list |
| [`product/03-roadmap.md`](product/03-roadmap.md) | Milestones, sequencing, dependencies |
| [`architecture/01-overview.md`](architecture/01-overview.md) | System architecture, principles, component map |
| [`architecture/02-data-model.md`](architecture/02-data-model.md) | Entities, schema, data conventions |
| [`architecture/03-tech-stack.md`](architecture/03-tech-stack.md) | Chosen technologies + rationale (decided via `/architect`) |
| [`architecture/decisions/`](architecture/decisions/) | ADRs — one file per significant decision (`NNNN-title.md`) |
| [`operations/01-progress.md`](operations/01-progress.md) | ⭐ Living status board: done / in progress / next, dated log |
| [`operations/open-questions.md`](operations/open-questions.md) | ⭐ Living register of unresolved decisions and assumptions |
| [`operations/02-glossary.md`](operations/02-glossary.md) | Domain terms, proper nouns, acronyms |
| [`business/01-model.md`](business/01-model.md) | Revenue model, pricing, value exchange |
| [`business/02-legal-org.md`](business/02-legal-org.md) | Jurisdiction, company structure, licenses |

## Optional docs

*(Created only when the notes warrant real content. When one is created, move its row into the
table above — or keep a separate table per domain if the list grows.)*

| Doc | Created when the notes cover… |
|---|---|
| `product/backlog.md` | A prioritized list of features/work items beyond the MVP scope |
| `product/user-stories.md` | Stories with acceptance criteria (usually via `/user-story`) |
| `architecture/security.md` | Auth model, threat considerations, compliance needs |
| `architecture/api-spec.md` | External or inter-service API contracts |
| `architecture/infrastructure.md` | Hosting, environments, CI/CD, observability |
| `business/target-market.md` | Market segments, personas, sizing |
| `business/competitive-analysis.md` | Competitors and differentiation |
| `business/financial-model.md` | Costs, projections, unit economics |
| `design/01-brand.md` | Brand identity: voice, colors, typography |
| `design/02-ux.md` | User flows, screens, interaction specs (often via `/design-review`) |
| `design/design-system.md` | Component inventory and design tokens |
| `operations/runbook.md` | Deploy/rollback/incident procedures |
| `operations/onboarding.md` | How a new team member gets productive |

## "I need X → read Y"

| I need… | Read |
|---|---|
| What is this product and why does it exist? | `product/01-vision.md` |
| What are we building (and not building) right now? | `product/02-scope.md` |
| What's the plan / what comes next? | `product/03-roadmap.md`, `operations/01-progress.md` |
| How does the system work? | `architecture/01-overview.md` |
| What technologies do we use and why? | `architecture/03-tech-stack.md`, `architecture/decisions/` |
| What does [term] mean here? | `operations/02-glossary.md` |
| What's still undecided? | `operations/open-questions.md` |
| How do we make money? | `business/01-model.md` |
| What did the stakeholder actually say? | `inputs/STAKEHOLDER-NOTES.md` (read-only) |
