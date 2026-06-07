---
doc: documents/index
purpose: Knowledge-base index — routes any reader to the right document.
status: living
owner: agent
derived_from: documents/inputs/STAKEHOLDER-NOTES.md
last_updated: {{DATE}}
---

# {{PRODUCT_NAME}} — Knowledge Base

> **Read this first.** This index maps every document in the knowledge base and tells you where to
> look for specific information. The table at the bottom routes any question to the right file.

---

## Map

```
documents/
├── inputs/                         ← stakeholder input — read-only to agents
│   └── STAKEHOLDER-NOTES.md        ← raw notes + change log
├── product/                        ← the WHAT / WHY
│   ├── 01-vision.md                ← problem, solution, value prop, positioning
│   ├── 02-scope.md                 ← MVP scope, phases, feature list
│   └── 03-roadmap.md               ← milestones, sequencing, dependencies
├── architecture/                   ← the HOW
│   ├── 01-overview.md              ← system architecture, component map
│   ├── 02-data-model.md            ← entities, schema
│   ├── 03-tech-stack.md            ← chosen technologies + rationale
│   └── decisions/                  ← ADRs (one file per decision)
├── operations/                     ← the STATE
│   ├── 01-progress.md              ← living status board (append-only log)
│   ├── open-questions.md           ← unresolved decisions (living register)
│   └── 02-glossary.md              ← shared vocabulary
└── business/                       ← money + legal
    ├── 01-model.md                 ← monetization, pricing, business model
    └── 02-legal-org.md             ← company formation, jurisdiction
```

**Optional** (created only when the notes warrant, never empty-scaffolded):
`product/{backlog,user-stories}`, `architecture/{security,api-spec,infrastructure}`,
`business/{target-market,competitive-analysis,financial-model}`,
`design/{01-brand,02-ux,design-system}`, `operations/{runbook,onboarding}`.

---

## Routing table

| I need to know… | Read |
|---|---|
| What this product is and who it's for | `product/01-vision.md` |
| What's in/out of scope for MVP | `product/02-scope.md` |
| What we're building and in what order | `product/03-roadmap.md` |
| How the system is designed | `architecture/01-overview.md` |
| The data model and entities | `architecture/02-data-model.md` |
| What tech stack we chose and why | `architecture/03-tech-stack.md` |
| Why a specific technical decision was made | `architecture/decisions/` |
| What's been built and what's in progress | `operations/01-progress.md` |
| What's still unresolved | `operations/open-questions.md` |
| What a domain term means | `operations/02-glossary.md` |
| The business model and monetization | `business/01-model.md` |
| Legal and company structure | `business/02-legal-org.md` |
| The raw stakeholder notes | `inputs/STAKEHOLDER-NOTES.md` |
