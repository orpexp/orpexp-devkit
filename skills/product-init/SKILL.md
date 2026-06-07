---
name: product-init
description: >-
  Bootstrap and maintain the documentation knowledge base for a digital product/project from raw
  stakeholder notes. Use when the user wants to: initialize/scaffold a NEW product, project, or
  business from idea notes ("start a new project from these notes", "set up the docs for this idea",
  "initialize a product workspace", "scaffold the spec docs"); OR extract/update requirements and
  specs from those notes ("sync the docs from the notes", "I added a new requirement — update the
  specs", "turn my idea notes into a proper spec"). Turns unstructured stakeholder notes into a
  structured, self-describing documents/ tree (vision, scope, roadmap, architecture, ADRs, progress,
  open-questions, glossary, business/legal) optimized for humans and AI agents.
---

# product-init

Turn a stakeholder's raw idea notes into a clean, self-describing **documentation knowledge base**
for a new digital product — and keep that knowledge base in sync as new requirements arrive.

This skill scaffolds **docs only** (no application code skeleton). It is the generator; each
project it creates is a self-contained instance. The tech stack is a deliberate gap — it is left as
an open question to be decided via `/architect` once the product is defined.

Read `reference/conventions.md` (the full system) and `reference/platform-layout.md` (the code
layout) before scaffolding. They are also copied into every project as `.ai/conventions.md` and
`.ai/platform-layout.md`.

**The shape of a generated project:**
**`.ai/` = how to work in this repo; `documents/` = the knowledge-base content; `platform/` = code.**

---

## Two modes (detect by state)

Decide which mode you're in by checking whether **`documents/inputs/STAKEHOLDER-NOTES.md` already
exists** in the target directory:

- **No `documents/` / no `STAKEHOLDER-NOTES.md` → INIT.** Fresh scaffold.
- **`documents/inputs/STAKEHOLDER-NOTES.md` exists → SYNC.** Propagate new notes into the derived docs.

Always confirm the target directory with the user before writing if it is ambiguous (e.g. they ran
the skill from a non-empty, unrelated repo).

---

## INIT mode — scaffold a new project

### Step 1: Locate the idea source
In priority order: (a) a file path the user gives; (b) text pasted in the conversation; (c) files
already dropped in `documents/inputs/`. If none exists, ask the user for their idea notes — do not
invent a product.

### Step 2: Confirm and orient
Ask the user to confirm:
1. **Product name** + a one-line pitch → derive a kebab-case slug for the workspace
2. **Stage** — Idea / MVP / Beta / Live
3. **Industry / domain** — this shapes vocabulary for the glossary

### Step 3: Scaffold the project structure

Create this tree (empty files where noted, README only for platform):

```
{{PRODUCT_SLUG}}/                       ← project root
├── CLAUDE.md                           ← thin pointer: @.ai/AGENTS.md
├── README.md                           ← human entry point
├── .ai/
│   ├── AGENTS.md                       ← canonical agent context (from template)
│   ├── conventions.md                  ← copied from reference/conventions.md
│   └── platform-layout.md             ← copied from reference/platform-layout.md
├── documents/
│   ├── README.md                       ← knowledge-base index (seed during Step 6)
│   ├── inputs/
│   │   └── STAKEHOLDER-NOTES.md        ← seeded with raw notes (Step 4)
│   ├── product/
│   │   ├── 01-vision.md
│   │   ├── 02-scope.md
│   │   └── 03-roadmap.md
│   ├── architecture/
│   │   ├── 01-overview.md
│   │   ├── 02-data-model.md
│   │   ├── 03-tech-stack.md            ← placeholder; stack decided via /architect
│   │   └── decisions/
│   │       └── 0001-record-architecture-decisions.md
│   ├── operations/
│   │   ├── 01-progress.md
│   │   ├── open-questions.md
│   │   └── 02-glossary.md
│   └── business/
│       ├── 01-model.md
│       └── 02-legal-org.md
└── platform/
    └── README.md                       ← platform structure reference (pre-dev placeholder)
```

### Step 4: Seed `documents/inputs/STAKEHOLDER-NOTES.md`

```markdown
---
doc: inputs/stakeholder-notes
status: living
owner: stakeholder
last_updated: {{DATE}}
---

# Stakeholder Notes — {{PRODUCT_NAME}}

> **Stakeholder:** this is the only file you hand-edit. Drop new ideas, requirements, and pivots
> here under a new `## YYYY-MM-DD — [topic]` heading. An agent will extract and propagate them.
> Never edit the derived docs directly — your notes are the source of truth.

## Change log / new requests

*(newest first — add new entries above this line)*

---

## Original idea notes

{{RAW_IDEA_NOTES}}
```

**From now on `documents/inputs/` is read-only to you.** You derive *from* it, never edit it.

### Step 5: Copy the reference files into `.ai/`

- `reference/conventions.md` → `.ai/conventions.md`
- `reference/platform-layout.md` → `.ai/platform-layout.md`

### Step 6: Populate each core derived doc

Extract from the stakeholder notes. **Never invent facts.** Mark gaps as:
- `> [OPEN QUESTION: ...]` — real unknowns the stakeholder must resolve; also add a row to `operations/open-questions.md`
- `> [ASSUMPTION: ...]` — a reasonable default you chose, flagged for confirmation

**Populate in this order:**

| # | File | Extract |
|---|---|---|
| 1 | `operations/02-glossary.md` | Domain terms, proper nouns, acronyms from the notes |
| 2 | `documents/README.md` | Index + routing table (update as docs are created) |
| 3 | `product/01-vision.md` | Problem, solution, value prop, target users, positioning |
| 4 | `product/02-scope.md` | MVP scope (in/out), phases, feature list |
| 5 | `product/03-roadmap.md` | Milestones, sequencing, dependencies — flag unknowns |
| 6 | `architecture/01-overview.md` | Inferred components, data flow — heavy on open questions |
| 7 | `architecture/02-data-model.md` | Entities derivable from the notes |
| 8 | `architecture/03-tech-stack.md` | Leave as open question → decided via `/architect` |
| 9 | `business/01-model.md` | Revenue model, pricing, value exchange |
| 10 | `business/02-legal-org.md` | Jurisdiction, structure — flag unknowns |
| 11 | `operations/open-questions.md` | All assumptions that need confirmation |
| 12 | `operations/01-progress.md` | Log: "Project initialized from idea notes on {{DATE}}" |

### Step 7: Add optional docs only when warranted

Templates in `optional/` are not scaffolded by default. Copy one into the matching `documents/…`
path only when the notes give it **real content**:

- `product/backlog.md`, `product/user-stories.md`
- `architecture/security.md`, `architecture/api-spec.md`, `architecture/infrastructure.md`
- `business/target-market.md`, `business/competitive-analysis.md`, `business/financial-model.md`
- `design/01-brand.md`, `design/02-ux.md`, `design/design-system.md`
- `operations/runbook.md`, `operations/onboarding.md`

**Never scaffold an empty doc.**

### Step 8: Update `documents/README.md`

Ensure every doc that exists is listed in the index with its one-line purpose. Move any optional
doc you created out of the "Optional" table into the main map.

### Step 9: Initialize the first ADR

Seed `documents/architecture/decisions/0001-record-architecture-decisions.md` and add an ADR for
each *already-decided* technical choice extractable from the notes.

### Step 10: Summarize to the user

Report:
- What was created (file list)
- The top open questions that need answering before the tech stack can be decided
- **Recommended next step**: proceed to `/architect` to decide the tech stack, or `/product-owner`
  to refine requirements first

---

## SYNC mode — propagate new requirements

When the stakeholder adds a new dated entry to `documents/inputs/STAKEHOLDER-NOTES.md`:

1. **Read the new entries** (look for dated headings added since the last `operations/01-progress.md`
   entry). Treat the folder as **read-only**.
2. **Map each new requirement** to the doc(s) it touches using `documents/README.md`.
3. **Respect ownership:** for `owner: agent` docs, edit directly; for `owner: stakeholder` docs,
   *propose* the change to the user rather than overwriting.
4. **For `status: living` docs** (`01-progress.md`, `open-questions.md`, `03-roadmap.md`): append,
   never rewrite past entries.
5. **Route unknowns and decisions.** A new unknown → row in `open-questions.md` + inline
   `> [OPEN QUESTION]`. A resolved decision → new `decisions/NNNN-*.md`; link from affected doc.
6. **Create optional docs** if a new requirement introduces a concern that needs one.
7. **Append a dated line** to `operations/01-progress.md` and bump `last_updated` on every doc
   you edited.
8. **Recommend the right next agent** based on what changed:
   - New requirements → `/product-owner` or `/user-story`
   - Tech/architecture change → `/architect`
   - New UI/UX requirement → `/designer` or `/design-review`
   - Ready to build → `/build-plan`

---

## Extraction rules

- **Never invent facts.** If the notes do not state something, write `> [OPEN QUESTION: ...]` or
  `> [ASSUMPTION: ...]`. Do not silently fill gaps with plausible-sounding content.
- **One fact, one home.** Don't duplicate the same decision across docs. State it once in its
  owning doc and *link* to it from others.
- **`documents/inputs/` is read-only.** Everything else is derived. Never edit the notes.
- **Match the stakeholder's language for content, English for structure.** If the notes are in
  Spanish, author doc *content* in Spanish, but keep file names and section scaffolding in English.
- **Prefer ADRs over prose for decisions.** A resolved question becomes an ADR, not an edit buried
  in a paragraph.

---

## Agent workflow integration

`product-init` creates the structure and seeds the content. The other framework skills fill it in
with depth and precision:

### Phase 1: After INIT — define the product

```
/product-owner
"Read documents/product/01-vision.md and documents/operations/open-questions.md.
Refine the product definition and help me resolve the highest-priority open questions."

/user-story
"Read documents/product/02-scope.md.
Turn the features list into full user stories with acceptance criteria."
```

### Phase 2: Design — decide the architecture

```
/architect
"Read documents/ — especially product/01-vision.md, product/02-scope.md, and
operations/open-questions.md. Propose the tech stack and system architecture.
For each decision, write an ADR in documents/architecture/decisions/."
```

If design assets are available:
```
/design-review
[attach screenshots or Figma exports]
"Extract all UI components and interactions. Save the output to documents/design/02-ux.md."
```

### Phase 3: Build — implement

```
/build-plan
"Read documents/architecture/ and documents/product/02-scope.md.
Generate a sequenced implementation plan for the MVP."

/frontend-dev   # for UI implementation
/backend-dev    # for API and data layer
```

### Phase 4: Deliver

```
/scrum-master
"Read documents/operations/01-progress.md and documents/product/03-roadmap.md.
Plan the first sprint from the build plan."
```

---

## Placeholder vocabulary

| Placeholder | Meaning |
|---|---|
| `{{PRODUCT_NAME}}` | Human product name |
| `{{PRODUCT_SLUG}}` | kebab-case workspace/dir name |
| `{{ONE_LINE_PITCH}}` | One-sentence description |
| `{{RAW_IDEA_NOTES}}` | The stakeholder's raw notes, pasted verbatim |
| `{{DATE}}` | Today, `YYYY-MM-DD` |
| `> [OPEN QUESTION: ...]` | Unknown the stakeholder must resolve |
| `> [ASSUMPTION: ...]` | Agent-chosen default, flagged for confirmation |

---

## What gets scaffolded

```
{{PRODUCT_SLUG}}/
├── CLAUDE.md                               ← @.ai/AGENTS.md (3 lines)
├── README.md                               ← human entry point
├── .ai/
│   ├── AGENTS.md                           ← canonical agent context
│   ├── conventions.md                      ← the docs-system rules
│   └── platform-layout.md                 ← the platform/ code layout
├── documents/
│   ├── README.md                           ← index/manifest + routing table
│   ├── inputs/
│   │   └── STAKEHOLDER-NOTES.md            ← stakeholder's hand-editable source
│   ├── product/{01-vision,02-scope,03-roadmap}.md
│   ├── architecture/{01-overview,02-data-model,03-tech-stack}.md
│   ├── architecture/decisions/0001-record-architecture-decisions.md
│   ├── operations/{01-progress,open-questions,02-glossary}.md
│   └── business/{01-model,02-legal-org}.md
└── platform/
    └── README.md                           ← pre-dev placeholder + structure reference
```

---

## Guardrails

- This skill **writes documentation, not application code**. Do not scaffold `package.json`,
  source files, or any code — that happens after the stack is decided, via `/build-plan` and the
  dev agents.
- Don't overwrite an existing `documents/inputs/STAKEHOLDER-NOTES.md` in INIT mode — if one
  exists, you're in SYNC.
- **Never edit anything under `documents/inputs/`** — it is the stakeholder's read-only territory.
- **Never pre-fill the tech stack.** Leave `documents/architecture/03-tech-stack.md` as open
  questions. The stack is a deliberate decision, not a default.
- Keep `documents/README.md` truthful: it must list exactly the docs that exist.
- When unsure whether a gap is an open question vs. an assumption, prefer `[OPEN QUESTION]`.
