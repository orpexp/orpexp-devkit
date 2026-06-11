# Archetype file format

Every archetype in `library/` follows this format: YAML frontmatter for machine matching (SELECT
scores against it), prose body for humans and APPLY. Copy this template when extracting a new
archetype.

```markdown
---
archetype: kebab-case-name
title: Human Title
status: draft            # draft → stable after a 2nd product applies it; deprecated when superseded
version: 1               # bump on substantive changes
summary: One sentence — what it is and who it's for.
fits_when:
  scale: "e.g. < 100k users, single region"
  team: "e.g. 1–5 devs"
  domain: ["b2b-saas", "multi-tenant"]          # tags, lowercase
  constraints: ["low ops budget", "fast iteration"]
avoid_when: ["hard real-time", "team > 8"]
stack:                   # per-layer choices; omit layers the archetype doesn't decide
  language: ...
  frontend: ...
  api: ...
  orm: ...
  db: ...
  auth: ...
  jobs: ...
  hosting: ...
platform_sections: ["apps/web", "core/contracts", "core/ui-components", "data"]
                         # which platform-layout.md sections this archetype uses
adr_seeds:               # one kebab-case id per ADR in the "ADR seeds" body section
  - monolith-first
source_products: []      # slugs of products this was extracted from / applied to
last_updated: YYYY-MM-DD
---

## Topology

Mermaid diagram + one-paragraph narrative of the runtime shape. APPLY merges this into the
product's `architecture/01-overview.md`.

## Stack rationale

Per-choice "why", written in the voice of `architecture/03-tech-stack.md` — APPLY copies this in.

## platform/ mapping

Which `platform/` sections are used and what goes where, using `platform-layout.md` vocabulary
(`apps/`, `services/{compute}-{tech}-{name}`, `core/*`, `data/`, `infra/`).

## ADR seeds

One full ADR body per `adr_seeds` id, in the architect skill's ADR format, **Status: Proposed**.
APPLY writes each as `documents/architecture/decisions/NNNN-<id>.md`.

## Trade-offs accepted

What this archetype deliberately gives up, so the team accepts them knowingly.

## Scale-out / exit path

What changes at each scale threshold, and which split triggers (platform-layout.md) signal it's
time to extract a section/service.

## Reference deployment

Environments, CI shape, rough monthly cost ballpark.

## Confirm per product

Checklist of decisions the archetype does NOT make — APPLY copies unanswered items into
`operations/open-questions.md`.
```
