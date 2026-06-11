---
doc: architecture/api-spec
purpose: API contracts — external and inter-service endpoints, shapes, and conventions
status: draft
owner: agent
derived_from: documents/inputs/STAKEHOLDER-NOTES.md
last_updated: {{DATE}}
---

# API Specification — {{PRODUCT_NAME}}

> Created when the product exposes or consumes APIs worth specifying. Conventions follow the
> architect skill's API design principles; the chosen style (REST/tRPC/GraphQL) is an ADR.

## Conventions

- **Style:** *(REST / tRPC / GraphQL — see `architecture/03-tech-stack.md`)*
- **Versioning:** *(e.g. path prefix `/api/v1/`)*
- **Auth:** *(how requests are authenticated)*
- **Errors:** `{ "error": { "code": "...", "message": "...", "details": {} } }`
- **Pagination:** *(cursor or page-based, on every list endpoint)*

## Endpoints / procedures

### *(Resource or domain)*

| Operation | Signature | Purpose | Auth |
|---|---|---|---|
| *(e.g. List invoices)* | `GET /api/v1/invoices` | | required |

**Shapes:**

```ts
// request / response types — keep in sync with platform/core/contracts
```

## External APIs consumed

| Provider | Used for | Webhooks? | Docs |
|---|---|---|---|
| *(e.g. Stripe)* | *(payments)* | yes | *(link)* |
