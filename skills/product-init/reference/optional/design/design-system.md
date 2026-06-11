---
doc: design/design-system
purpose: Design tokens and component inventory shared across the product's UIs
status: living
owner: agent
derived_from: documents/inputs/STAKEHOLDER-NOTES.md
last_updated: {{DATE}}
---

# Design System — {{PRODUCT_NAME}}

> Created when the product has (or needs) reusable UI primitives. The implementation lives in
> `platform/core/ui-components/`; this doc is the spec. Maintain with `/designer` and
> `/frontend-dev`.

## Tokens

| Token | Value | Notes |
|---|---|---|
| `color-primary` | *(from `design/01-brand.md`)* | |
| `font-display` / `font-body` | | |
| `spacing scale` | *(e.g. 4px base)* | |
| `radius` | | |

## Component inventory

| Component | Status | Spec | Implementation |
|---|---|---|---|
| Button | *(spec'd / built)* | *(variants, sizes, states)* | `platform/core/ui-components/...` |
| Input | | | |

## Rules

- Every component defines **all states**: default, hover, focus, disabled, loading, error.
- New shared primitives go in `platform/core/ui-components/`; one-off feature components stay in
  their app (see `.ai/platform-layout.md`).
