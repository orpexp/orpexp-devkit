---
doc: architecture/infrastructure
purpose: Hosting, environments, CI/CD, and observability for the platform
status: draft
owner: agent
derived_from: documents/inputs/STAKEHOLDER-NOTES.md
last_updated: {{DATE}}
---

# Infrastructure — {{PRODUCT_NAME}}

> Created when hosting/deployment decisions exist or matter. Infrastructure code itself lives in
> `platform/infra/`; this doc records the decisions and topology. Major choices become ADRs.

## Hosting

- **Provider / platform:** *(extract or `> [OPEN QUESTION: ...]`)*
- **Regions:** *(where users are; data-residency constraints from `business/02-legal-org.md`)*

## Environments

| Env | Purpose | URL | Deploys from |
|---|---|---|---|
| `dev` | local development | — | — |
| `staging` | pre-release verification | | `main` |
| `production` | live | | tagged release |

## CI/CD

- **Pipeline:** *(build → test → deploy; where it runs)*
- **Quality gates:** *(tests, lint, type-check — what blocks a deploy)*

## Observability

- **Logs / metrics / alerts:** *(what's collected, where, who is paged)*

## Cost ballpark

*(Monthly estimate per environment — feeds `business/financial-model.md` if it exists.)*
