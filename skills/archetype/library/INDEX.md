# Archetype Library — Index

> The catalog. LIST and SELECT read this file first; open an archetype's own file only when it's
> a plausible match. Keep this table in sync with the files in this directory — every archetype
> file gets exactly one row.

| Archetype | Summary | Fits when | Status |
|---|---|---|---|
| [`modular-monolith-saas`](modular-monolith-saas.md) | Single deployable Next.js fullstack app, multi-tenant Postgres — the house default for B2B SaaS | < 100k users · 1–5 devs · CRUD-heavy SaaS · low ops budget | stable |
| [`serverless-event-driven`](serverless-event-driven.md) | Lambda services per domain over EventBridge/SQS — near-zero idle cost | Spiky/async-heavy load · 2–8 devs with AWS experience · integrations & automation | stable |
| [`static-site-serverless`](static-site-serverless.md) | Pre-rendered Astro/Next site + edge functions + headless CMS | Content/marketing products · 1–3 devs · SEO-critical · near-zero ops | stable |
| [`mobile-bff`](mobile-bff.md) | Expo/React Native app + dedicated BFF over shared contracts | Mobile-first · 2–6 devs · push/offline needs · one-language stack | stable |
| [`event-driven-microservices`](event-driven-microservices.md) | Containerized services per domain + broker + CQRS-lite reads | > 100k users · 8+ devs, multi-team · ≥2 split triggers fired — never day one | stable |

**No match?** Design with `/architect`, then run EXTRACT to add the result here as a `draft`
archetype — the library grows from real products.
