---
doc: architecture/security
purpose: Security model — authentication, authorization, data protection, threats, compliance
status: draft
owner: agent
derived_from: documents/inputs/STAKEHOLDER-NOTES.md
last_updated: {{DATE}}
---

# Security — {{PRODUCT_NAME}}

> Created because the notes raise security, privacy, or compliance concerns. Significant choices
> here become ADRs in `architecture/decisions/`.

## Authentication & authorization

- **Auth method:** *(extract or `> [OPEN QUESTION: ...]`)*
- **Roles / permissions model:** *(who can do what)*
- **Multi-tenancy isolation:** *(if applicable — row-level security, schema separation, …)*

## Data protection

- **Sensitive data handled:** *(PII, payment data, health data — extract from notes)*
- **At rest / in transit:** *(encryption expectations)*
- **Retention & deletion:** *(user data deletion, backups)*

## Threat considerations

| Threat | Surface | Mitigation |
|---|---|---|
| *(e.g. account takeover)* | *(login)* | *(rate limiting, MFA, …)* |

## Compliance

*(GDPR, SOC 2, HIPAA, local regulations — only what the notes or jurisdiction imply; flag the rest
as open questions.)*

## Checklist before launch

- [ ] Secrets in a secret manager, never in the repo
- [ ] Input validation at all system boundaries
- [ ] Authz checked on every protected endpoint
- [ ] Dependency / vulnerability scanning in CI
