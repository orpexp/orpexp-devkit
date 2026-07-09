# Project Conventions — the knowledge-base system

> This file is the **manifesto**: it defines how a product workspace is organized so that any human or
> AI agent can find the right information and update it safely. It is copied into every project this
> system creates (at `.ai/conventions.md`) so the project is self-describing even without the
> generating skill present.
>
> **The organizing line:** `.ai/` = *how to work in this repo* (this file, `AGENTS.md`,
> `platform-layout.md`); `documents/` = *the knowledge-base content*.

---

## 1. Core idea: a notes-driven knowledge base

There is exactly **one place a stakeholder edits by hand**: `documents/inputs/` — primarily
`STAKEHOLDER-NOTES.md`, plus any raw files they drop in (PDFs, screenshots, transcripts). Everything
else in `documents/` is **derived** from it by an agent. The stakeholder writes raw idea notes and,
over time, appends new requirements to the change log; an agent extracts those into the structured
docs and keeps them in sync.

```
documents/inputs/  ──(agent extracts; never edits)──▶  product / architecture / operations / business docs
   ▲                                                              │
   └──────────── stakeholder appends new requirements            ├──▶ operations/01-progress.md   (what changed)
                  (and reads the derived docs) ◀─────────────────┘    operations/open-questions.md (what's unresolved)
```

`documents/inputs/` is **read-only to agents**. This keeps human input low-friction and unstructured,
while the derived docs stay structured, deduplicated, and machine-legible, and the agent's own record
of activity lives in the operations docs — never back in the notes. This is not just convention:
the orpexp-devkit plugin ships a `PreToolUse` hook that **blocks** agent file edits under
`documents/inputs/` for everyone with the plugin installed.

---

## 2. The layout

`.ai/` holds the rules; `documents/` holds the content. Each doc has **one job**. Folders group docs
by concern; split a doc into its own file when it grows broad. Shallow folders + a strong index beat
deep nesting.

```
.ai/                                # how to work in this repo (for any agent or human director)
├── AGENTS.md                       #   ⭐ canonical agent context: behavioral rules + reading order
├── conventions.md                  #   this file — the docs system
├── platform-layout.md             #   the platform/ code layout + where new code goes
└── graph/                          #   Graphify knowledge graph (agent tooling — query it, don't grep;
                                    #   built by /repo-graph, path set by GRAPHIFY_OUT; graph.json + report
                                    #   + html committed, cost.json + cache/ git-ignored)

documents/                          # the knowledge base CONTENT
├── README.md                       # INDEX — read first; maps every doc + "I need X → read Y" table
├── inputs/                         # ⭐ stakeholder input (read-only to agents)
│   └── STAKEHOLDER-NOTES.md        #   raw notes + change log. The single hand-edited source of intent.
├── product/                        # the WHAT / WHY
│   ├── 01-vision.md                #   problem, solution, value prop, target users, positioning
│   ├── 02-scope.md                 #   MVP scope (in/out), phases, granular feature list
│   └── 03-roadmap.md               #   sequencing, milestones, work-package breakdown + dependencies
├── architecture/                   # the HOW
│   ├── 01-overview.md              #   system architecture, principles, component map, diagram
│   ├── 02-data-model.md            #   entities, schema, conventions
│   ├── 03-tech-stack.md            #   chosen technologies + rationale
│   └── decisions/                  #   ADRs — one file per significant decision (NNNN-title.md)
├── operations/                     # the STATE + vocabulary
│   ├── 01-progress.md              #   ⭐ living status board: done / in-progress / next + dated log
│   ├── open-questions.md           #   ⭐ living register of unresolved decisions
│   └── 02-glossary.md              #   shared vocabulary
└── business/                       # money + legal
    ├── 01-model.md                 #   monetization, pricing, business model
    └── 02-legal-org.md             #   company formation, jurisdiction, licenses
```

**Optional docs** (created only when the notes warrant — never scaffolded empty):
`product/{backlog,user-stories}`, `architecture/{security,api-spec,infrastructure}`,
`business/{target-market,competitive-analysis,financial-model}`,
`design/{01-brand,02-ux,design-system}`, `operations/{runbook,onboarding}`.

**Numbering** (`01-`, `02-`) gives a stable reading order within a folder and a stable handle agents
can reference ("update `product/02-scope.md`"). Unnumbered docs are the optional/satellite ones.

---

## 3. Machine-readable doc header

Every derived doc starts with YAML front-matter. This is the contract that tells an agent what it
may regenerate vs. hand back to a human:

```yaml
---
doc: product/vision            # stable id = folder/name
purpose: <one line, mirrored in documents/README.md>
status: draft | stable | living
owner: stakeholder | agent     # agent may rewrite "agent"; must PROPOSE changes for "stakeholder"
derived_from: documents/inputs/STAKEHOLDER-NOTES.md
last_updated: YYYY-MM-DD
---
```

- `owner: agent` → the agent maintains it freely from the notes.
- `owner: stakeholder` → human-authored intent; the agent proposes edits, never silently overwrites.
- `status: living` → append history (progress log, open-questions, roadmap), never clobber.
- `status: stable` → changes are deliberate; record the reasoning (often as an ADR).

---

## 4. The notes → docs pipeline

- **`STAKEHOLDER-NOTES.md` structure:** a `## Change log / new requests` section (newest first) on
  top, the raw `## Original idea notes` below. The change log is where the stakeholder drops new
  requirements over time. The agent does not write here.
- **INIT:** scaffold the tree, then extract the notes into each doc. Unknowns become explicit
  `> [OPEN QUESTION: ...]` (and a row in `operations/open-questions.md`); chosen defaults become
  `> [ASSUMPTION: ...]`. **Never invent facts.**
- **SYNC:** read the newest change-log entries, map each to the doc(s) it affects, update
  agent-owned docs, propose changes to stakeholder-owned ones, route unknowns to
  `open-questions.md` and decisions to ADRs, and append a dated line to
  `operations/01-progress.md`.
- **Decisions become ADRs; questions live in one register.** A resolved open question is captured
  as a new `architecture/decisions/NNNN-*.md` and struck from `operations/open-questions.md`.

---

## 5. Entry points & ownership

| File | Audience | Role |
|---|---|---|
| `CLAUDE.md` (root) | AI agents (Claude Code) | Thin root file; auto-loaded by Claude Code; `@`-imports `.ai/AGENTS.md`. Keep it ~3 lines. |
| `.ai/AGENTS.md` | Any agent + humans | Canonical, tool-agnostic working context: behavioral rules, reading order, ownership. |
| `.ai/conventions.md` | Both | The docs-system rules (this file). |
| `.ai/platform-layout.md` | Developers + agents | How application code under `platform/` is organized. |
| `README.md` (root) | Humans | Human onboarding: what the product is, quick links, how to run things. |
| `documents/README.md` | Both | The index/manifest of the knowledge base. |
| `documents/inputs/` | Stakeholder | The only hand-edited source of intent. **Read-only to agents.** |
| `platform/` | Developers | All application code (see `platform-layout.md`). |

**Entry-file pattern:** the root `CLAUDE.md` is a tiny pointer that `@`-imports `.ai/AGENTS.md`;
the substance is tool-agnostic and lives in `.ai/AGENTS.md`. (Claude Code only auto-discovers
`CLAUDE.md` at the root, so the thin root file is required; it imports the canonical context with
zero duplication.)

**Rule for agents:** when you need product context, read `documents/README.md` first, then the
specific doc it points you to. When you change anything, update `last_updated` and (for state)
the progress log. Never write into `documents/inputs/`.
