---
name: archetype
description: >-
  Manage and apply architecture archetypes — reusable, predefined architecture profiles from the
  team library. Use when the user wants to: pick an architecture or tech stack for a product from
  a known profile ("apply an archetype", "which architecture fits this product?", "use our standard
  SaaS architecture"), list the available archetypes, pre-fill documents/architecture/ from a
  profile, or SAVE a finished product's architecture as a new reusable archetype ("extract an
  archetype from this product", "save this architecture for future products"). Complements
  /architect: the architect designs and decides; this skill reuses and records proven designs.
---

# archetype

An **architecture archetype** is a reusable, predefined architecture profile — topology, tech
stack, `platform/` section mapping, seed ADRs, trade-offs, and scale-out path — that an architect
can apply to a new product instead of designing from scratch, and extract from a finished product
so the next one starts further ahead.

The library lives **in this plugin** (`library/`), so committing a new archetype to the framework
repo distributes it to the whole team on the next `claude plugin update`.

- `reference/archetype-template.md` — the canonical archetype file format
- `library/INDEX.md` — the catalog (read this for LIST/SELECT; not every archetype file)
- `library/*.md` — one file per archetype

This skill operates on the `documents/` knowledge base created by `/product-init`. If the product
has no `documents/architecture/`, run `/product-init` first.

---

## Four modes (detect by intent)

| User intent | Mode |
|---|---|
| "What archetypes do we have?" | **LIST** |
| "Which architecture fits this product?" | **SELECT** |
| "Apply [archetype] to this product" | **APPLY** |
| "Save this architecture as an archetype" | **EXTRACT** |

---

## LIST — show the catalog

Read `library/INDEX.md` and render its table (name, summary, fits-when, status). Don't read every
archetype file. Mention `deprecated` archetypes only if the user asks for the full list.

---

## SELECT — recommend an archetype for this product

1. Read the product context: `documents/product/01-vision.md`, `documents/product/02-scope.md`,
   `documents/operations/open-questions.md` (and `business/01-model.md` if it exists).
2. Read `library/INDEX.md`; open only the 2–4 plausible archetype files.
3. Score each against its `fits_when` / `avoid_when` frontmatter: scale, team size, domain,
   constraints. An `avoid_when` hit disqualifies unless the user overrides.
4. Present the top 2–3 as a comparison table (the `/architect` format: complexity, scalability,
   team fit, cost, recommendation) with **one explicit recommendation and the reasoning**.
5. If nothing fits, say so and recommend `/architect` to design from scratch — then `EXTRACT` the
   result so the gap is filled for next time.

**Never auto-apply.** The user (the architect) picks; only then run APPLY.

---

## APPLY — pre-fill the architecture docs from an archetype

Given a chosen archetype (e.g. `modular-monolith-saas`), read its full file and:

1. **`documents/architecture/03-tech-stack.md`** — write the stack from the archetype's `stack`
   frontmatter + "Stack rationale" section. Add to the doc's front-matter:
   `applied_archetype: <name>@<version>`. Mark any deviation the user requested inline as
   `> [DEVIATION from archetype: ...]`.
2. **`documents/architecture/01-overview.md`** — merge the archetype's "Topology" and
   "platform/ mapping" sections into the doc. **Merge, never clobber**: keep all product-specific
   content already extracted from the notes; the archetype contributes the generic shape.
3. **`documents/architecture/decisions/`** — create one ADR per "ADR seeds" entry, numbered after
   the existing ADRs, with **Status: Proposed**. They become Accepted only when the user confirms
   (decisions stay deliberate — the archetype proposes, the architect disposes).
4. **`documents/operations/open-questions.md`** — add one row per item in the archetype's
   "Confirm per product" checklist that the product's docs don't already answer.
5. **`documents/operations/01-progress.md`** — append a dated line:
   `Applied archetype <name>@<version>; N ADRs proposed.`
6. **`platform/README.md`** — if it still shows the pre-development placeholder, note which
   `platform/` sections this archetype uses (from `platform_sections`).
7. Summarize: what was filled, which ADRs await confirmation, which questions remain. Recommend
   reviewing the Proposed ADRs with `/architect`, then `/build-plan`.

---

## EXTRACT — save a product's architecture as a new archetype

When a product's architecture has proven itself (or simply been finalized):

1. Read the product's `documents/architecture/` — `01-overview.md`, `03-tech-stack.md`, and the
   **Accepted** ADRs.
2. **Generalize**: strip product names and domain specifics; keep the topology, stack choices,
   rationale, and trade-offs. What stays must be reusable by an unrelated product.
3. Generate the archetype file from `reference/archetype-template.md`, with `status: draft`,
   `version: 1`, and the source product's slug in `source_products`.
4. Ask where the local clone of the framework repo is (if not already known). Write the file to
   `skills/archetype/library/<name>.md` there, add a row to `library/INDEX.md`, and add a
   CHANGELOG entry. If no clone is available, output the complete file content for manual placement.
5. Prompt the user to commit and push (or open a PR for team review) — that's what distributes it.
6. Suggest promoting `status: draft → stable` after a second product applies it successfully.

If an archetype already covers this architecture, propose **updating** it (bump `version`, append
to `source_products`) instead of creating a near-duplicate.

---

## Guardrails

- **Read-only toward product intent**: never touch `documents/inputs/`, `product/`, or
  `business/` docs. This skill writes only `architecture/`, `operations/` (progress,
  open-questions), and `platform/README.md`.
- **Proposed, not Accepted**: every ADR seeded by APPLY starts as Proposed. Never mark a decision
  Accepted on the user's behalf.
- **Merge, never clobber** existing architecture content — especially anything extracted from
  stakeholder notes.
- **An archetype is a starting point, not a verdict.** Always surface the "Confirm per product"
  checklist; products differ in the ways that checklist names.
- **Don't fork the library silently**: prefer updating an existing archetype over creating
  near-duplicates; mark superseded ones `deprecated` rather than deleting them.
