# Folder Structure — the code workspace (`platform/`)

> Describes how application code is organized. The **docs** layout is in `conventions.md` (its
> sibling in `.ai/`); this file is the **code** layout. In a fresh project the tree below is mostly
> empty (just this spec + a `platform/README.md`); it's filled in when development starts and the
> stack is chosen.

---

## Why code lives under `platform/`

The repo **root stays docs-first**: `README.md`, `CLAUDE.md`, `documents/`, and meta files only.
All application code lives under `platform/`. This keeps the root legible to a stakeholder or a
fresh agent (the *what/why* is right there) and keeps the code as one self-contained, relocatable
unit.

`platform/` is also structured so each top-level section can later be **lifted into its own
repository, owned by a separate team, with zero internal-import changes** — multi-repo readiness
without committing to multi-repo today. This is enforced by two rules:

1. **No cross-section imports** (a `services/` package never imports from `apps/`, etc. — only
   from `core/*` and `data/`).
2. **Ownership via `CODEOWNERS`** at the section boundary.

---

## The layout

```
platform/
├── apps/              # client apps humans use (web, mobile). A fullstack app's own routers and
│                      #   handlers live INSIDE the app that owns them.
├── services/          # deployable units — one per domain. Naming: {compute}-{tech}-{name}
│                      #   e.g. api-lambda-auth, worker-lambda-campaign-fanout. A service's own
│                      #   routers, handlers, and business rules live INSIDE it — they are the
│                      #   edge of a deployable, not a shared building block.
├── core/              # building blocks: imported by apps & services, never deployed on their own
│   ├── contracts/     #   COMPILE-TIME vocabulary — types, schemas (e.g. Zod), interfaces, i18n keys,
│   │                  #     plus tiny dependency-free pure helpers intrinsic to a contract (type
│   │                  #     guards, validators). Organized BY DOMAIN (contracts/auth, …). Depends
│   │                  #     on nothing. Answers "what things ARE".
│   ├── adapters/      #   DOMAIN capability behind a stable interface + a swappable implementation
│   │                  #     (e.g. wallet: mock→Apple/Google; auth: scrypt→argon2). The interface
│   │                  #     lives in contracts/, the implementation here (ports & adapters).
│   ├── server/        #   RUNTIME, domain-agnostic SERVER plumbing used identically by every service
│   │                  #     (http server wrapper, env loader, observability/logging, middleware,
│   │                  #     error helpers, lambda handler). Answers "what server things DO".
│   └── ui-components/ #   RUNTIME, domain-agnostic PRESENTATION shared across apps: design tokens,
│                      #     theme, primitives (Button/Input/Modal), layout. Imported by apps/ only —
│                      #     never by services/. Domain-aware "feature" components live in the app.
├── data/              # database: client, migrations, generated types, test helpers
├── ops/               # preflight scripts, CI notes, dev tooling          [restricted via CODEOWNERS]
└── infra/             # infrastructure-as-code                            [restricted via CODEOWNERS]
```

The line that keeps the three `core/` runtime buckets apart: **`contracts` answers "what things
*are*"; `server` and `ui-components` answer "what things *do*"** (on the backend and in the browser
respectively); `adapters` is the domain-aware capability behind a swappable implementation.

---

## The decision rule (where does a new piece of code go?)

Apply in order:

1. **Does it deploy and run as its own unit?** → `services/` (name it `{compute}-{tech}-{name}`).
   Its routers, handlers, and own business rules live *inside* it.
2. **Is it a client app a human uses?** → `apps/` (its routers/handlers live inside it too).
3. **Otherwise it's an imported building block — pick by tier + axis:**
   - **Compile-time contract** (types, schemas, interfaces — no runtime behavior) → `core/contracts`.
   - **Runtime, domain-agnostic *server* plumbing** (http, env, observability) → `core/server`.
   - **Runtime, domain-agnostic *presentation*** (design tokens, primitives, theme) → `core/ui-components`.
   - **Domain capability with a swappable implementation** → `core/adapters`.
4. **Database?** → `data/`. **Tooling/CI?** → `ops/`. **IaC?** → `infra/`.

The axes that separate the `core/*` buckets:

|                      | Compile-time (contract) | Runtime — server               | Runtime — presentation            |
|----------------------|-------------------------|--------------------------------|-----------------------------------|
| **Domain-agnostic**  | `core/contracts`        | `core/server`                  | `core/ui-components`              |
| **Domain-aware**     | `core/contracts`*       | `core/adapters` / `services`   | feature components (in the app)   |

\* domain *types* still live in `core/contracts`; domain *behavior* lives in `adapters`/`services`,
and domain *UI* lives in the app that owns it.

---

## Where server-side logic and routers go

This is the most common point of confusion, so state it explicitly:

- **Transport (routers, controllers, HTTP handlers)** → *inside the deployable that exposes them* —
  a `services/…` unit or a fullstack `apps/` app. They are the edge of a deployable, never hoisted
  into `core/`.
- **Common server utilities / plumbing** (logging, http client, env, middleware, error helpers) →
  `core/server`. This is the home for "shared server utils".
- **Business rules specific to one service** → *inside that service*.
- **A capability two or more services share** (e.g. send-email, wallet) → model it as ports &
  adapters: the interface in `core/contracts`, the implementation in `core/adapters`. Consumers
  depend on the **interface**, so the implementation can change without touching them. (Changing the
  *interface itself* is a deliberate breaking change that ripples to every consumer — keep it stable.)
- **Avoid a shared "domain" package.** Sharing raw business logic across services couples them and
  defeats a clean repo split; share a *capability behind an interface* instead.

---

## Naming notes

- **`{compute}-{tech}-{name}`** for services: reading the name tells you what it is, where it runs,
  and what it does. `compute` ∈ {`api`, `worker`, `collector`, …}; `tech` is the deploy target
  (`lambda`, `fargate`, `container`, …); `name` is the domain.
- **`core/contracts` is organized by domain** (`contracts/auth`, `contracts/billing`), **never by
  runtime audience** — `server-side`/`client-side` subfolders are the wrong axis for a compile-time
  package (and contradict "isomorphic", which means *used by both*).
- **Imports use package names, not folder paths.** Each package's `package.json` `name`
  (e.g. `@scope/http`) is what appears in `import` statements — the folder name (`core/server`) is
  an organizational/browsing aid only.
- **No `utils`/`helpers` junk drawer.** Generic helpers are either types (→ `core/contracts`) or
  runtime helpers (→ `core/server` for the backend, `core/ui-components` for the browser), or they
  earn their own named package. An *isomorphic* runtime helper used by both server and client earns
  its own domain-named package rather than a vague catch-all; only reach for a single `core/common`
  if a genuine catch-all is unavoidable. A role-less catch-all becomes a dumping ground and invites
  circular deps.

---

## Allowed-imports matrix (what keeps sections liftable)

Each section may import only from the sections marked ✓. The rule of thumb: **if section A can
move to its own repo without touching section B's code, they are correctly decoupled.**

| From ↓ may import → | apps | services | core/contracts | core/adapters | core/server | core/ui-components | data | infra | ops |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| **apps**               | ✗ | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✗ |
| **services**           | ✗ | ✗ | ✓ | ✓ | ✓ | ✗ | ✓ | ✗ | ✗ |
| **core/contracts**     | ✗ | ✗ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| **core/adapters**      | ✗ | ✗ | ✓ | ✓ | ✓ | ✗ | ✓ | ✗ | ✗ |
| **core/server**        | ✗ | ✗ | ✓ | ✗ | ✓ | ✗ | ✗ | ✗ | ✗ |
| **core/ui-components** | ✗ | ✗ | ✓ | ✗ | ✗ | ✓ | ✗ | ✗ | ✗ |
| **data**               | ✗ | ✗ | ✓ | ✗ | ✓ | ✗ | ✓ | ✗ | ✗ |
| **infra / ops**        | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | standalone | standalone |

Key invariants: **no cross-section imports** between `apps`/`services` (they compose only via
`core/*` + `data`); **`core/contracts` depends on nothing** (it's the leaf — pure types/schemas);
**`core/ui-components` imports only `core/contracts`** and only `apps` may import it (presentation
never leaks into services); `infra` and `ops` are standalone and never imported by app code.

---

## Split-trigger criteria (when to actually extract a section)

Stay a monorepo until a section meets **two or more** of these — then lift it:

- it has its **own deployment lifecycle**, independent of the rest;
- it gets a **dedicated team** (2+ engineers) who want their own review/CODEOWNERS gate;
- it has a **materially different tech stack or runtime**;
- it **drags CI** — unrelated changes routinely rebuild/retest it.

## Split procedure (lift a section into its own repo)

1. Move the folder out into the new repo. **Keep every package's `package.json` name stable** —
   imports don't change, so dependents keep compiling.
2. Move that section's `CODEOWNERS` line and any section-specific CI.
3. Replace the in-repo dependency with the published package (or an API call) where the boundary
   now crosses a repo.
4. Update `documents/architecture/01-overview.md` to reflect the new topology.
