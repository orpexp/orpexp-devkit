---
doc: operations/runbook
purpose: Operational procedures — deploy, rollback, incidents, routine maintenance
status: living
owner: agent
derived_from: documents/inputs/STAKEHOLDER-NOTES.md
last_updated: {{DATE}}
---

# Runbook — {{PRODUCT_NAME}}

> Created once the product is deployable. Keep procedures executable — exact commands, not prose.
> Infrastructure context lives in `architecture/infrastructure.md`.

## Deploy

```bash
# exact steps/commands per environment
```

**Pre-deploy checklist:**
- [ ] Tests green on the release commit
- [ ] Migrations reviewed (and reversible, or a rollback plan exists)

## Rollback

```bash
# exact steps — write these BEFORE the first production deploy
```

## Incident response

1. **Assess:** *(where to look — dashboards, logs)*
2. **Mitigate:** *(rollback / feature flag / scale up)*
3. **Communicate:** *(who is told, where)*
4. **Post-mortem:** write one with `/scrum-master` for any user-visible incident.

## Routine maintenance

| Task | Frequency | How |
|---|---|---|
| *(e.g. backup verification)* | | |
