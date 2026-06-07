# {{PRODUCT_NAME}} — platform

All application code lives here. The repo root stays docs-first; this folder is the one
self-contained, relocatable code unit.

> **Status: pre-development.** Only this README exists so far. The tree below is the target layout;
> it gets filled in once development starts and the stack is chosen (see
> [`../documents/architecture/03-tech-stack.md`](../documents/architecture/03-tech-stack.md)).

---

## Target structure

```
platform/
├── apps/              # client apps humans use (web, mobile). Routers/handlers of a fullstack
│                      #   app live inside the app that owns them.
├── services/          # deployable units — one per domain. {compute}-{tech}-{name}
│                      #   e.g. api-lambda-auth, worker-lambda-campaign-fanout. A service's own
│                      #   routers, handlers, and business rules live inside it.
├── core/              # building blocks: imported by apps & services, never deployed alone
│   ├── contracts/     #   compile-time vocabulary: types, schemas, interfaces, i18n keys + tiny
│   │                  #     intrinsic guards. Organized by domain. "What things ARE."
│   ├── adapters/      #   domain capability behind a stable interface + swappable impl (mock→real)
│   ├── server/        #   runtime, domain-agnostic server plumbing: http, env, observability,
│   │                  #     middleware, logging. "What server things DO."
│   └── ui-components/ #   runtime, domain-agnostic presentation: design tokens, primitives, theme.
│                      #     Imported by apps/ only. Feature components live in the app.
├── data/              # database: client, migrations, types, test helpers
├── ops/               # preflight, CI notes, tooling      [restricted via CODEOWNERS]
└── infra/             # infrastructure-as-code            [restricted via CODEOWNERS]
```

---

## The rule for where code goes

*Deploys & runs? → `services/`. Client app? → `apps/`. Imported, never deployed?* then:
compile-time contract → `core/contracts`; runtime server plumbing → `core/server`; runtime
presentation (design system) → `core/ui-components`; domain capability with a swappable impl →
`core/adapters`.

The boundary phrase: **`contracts` says what things *are*; `server` / `ui-components` say what they
*do*.** Routers/handlers and per-service business rules live *inside the deployable* (a `service`
or fullstack `app`), never in `core/`. A capability shared by 2+ services is modeled as ports &
adapters (interface in `core/contracts`, impl in `core/adapters`) — never as a shared domain package.

Full rationale, the two-axis model, the import matrix, naming, and multi-repo extraction:
[`../.ai/platform-layout.md`](../.ai/platform-layout.md).

**Imports use package names, not folder paths** — `core/server` is a browsing aid; you import
`@scope/<pkg>`. **No cross-section imports** (a `services/` package imports only from `core/*` and
`data/`), which is what keeps each section liftable into its own repo later.

---

## Naming convention for services

`{compute}-{tech}-{name}`

| Part | Values | Example |
|---|---|---|
| `compute` | `api`, `worker`, `collector`, `scheduler` | `api` |
| `tech` | `lambda`, `fargate`, `container`, `edge` | `lambda` |
| `name` | domain name (kebab-case) | `auth` |
| **Result** | | `api-lambda-auth` |

---

## Developing locally

> Fill this section in once development starts and the stack is chosen (see
> [`../documents/architecture/03-tech-stack.md`](../documents/architecture/03-tech-stack.md)).

```bash
# install dependencies

# start dev server

# run tests

# build for production
```
