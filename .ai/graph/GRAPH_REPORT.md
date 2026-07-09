# Graph Report - claude-framework  (2026-07-12)

## Corpus Check
- 65 files · ~42,926 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 598 nodes · 554 edges · 55 communities (50 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a0fce323`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Product Workflow
- Changelog
- modular-monolith-saas.md
- INIT mode — scaffold a new project
- UX/UI Designer Agent
- Backend Developer Agent
- Frontend Developer Agent
- Install & Maintenance Guide
- Claude Code Framework
- Scrum Master Agent
- Software Architect Agent
- Design Review Skill
- Skill Creator
- User Story Skill
- Product Owner Agent
- How to Handle Inputs
- event-driven-microservices.md
- mobile-bff.md
- serverless-event-driven.md
- Claude Code Guide
- Build Plan Skill
- AGENTS.md — working context for {{PRODUCT_NAME}}
- Repo Graph (Graphify)
- marketplace.json
- Global Claude Instructions
- archetype
- Setup Skills
- Infrastructure — {{PRODUCT_NAME}}
- Security — {{PRODUCT_NAME}}
- Target Market — {{PRODUCT_NAME}}
- UX — {{PRODUCT_NAME}}
- devops-engineer.md
- frontend-builder.md
- API Specification — {{PRODUCT_NAME}}
- Financial Model — {{PRODUCT_NAME}}
- Onboarding — {{PRODUCT_NAME}}
- Runbook — {{PRODUCT_NAME}}
- {{PRODUCT_NAME}} — platform
- backend-builder.md
- qa-reviewer.md
- security-reviewer.md
- test-engineer.md
- {{PRODUCT_NAME}} — Knowledge Base Index
- Competitive Analysis — {{PRODUCT_NAME}}
- Brand — {{PRODUCT_NAME}}
- Design System — {{PRODUCT_NAME}}
- Backlog — {{PRODUCT_NAME}}
- User Stories — {{PRODUCT_NAME}}
- progress-tracker.md
- spec-compliance.md
- graph-first.sh
- protect-inputs.sh
- archetype-template.md
- adr-0001.md
- claude-md.md

## God Nodes (most connected - your core abstractions)
1. `Changelog` - 18 edges
2. `Install & Maintenance Guide` - 15 edges
3. `Frontend Developer Agent` - 12 edges
4. `Product Workflow` - 12 edges
5. `Backend Developer Agent` - 11 edges
6. `INIT mode — scaffold a new project` - 11 edges
7. `Claude Code Guide` - 11 edges
8. `Software Architect Agent` - 10 edges
9. `UX/UI Designer Agent` - 10 edges
10. `Scrum Master Agent` - 10 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (55 total, 5 thin omitted)

### Community 0 - "Product Workflow"
Cohesion: 0.04
Nodes (39): Anti-patterns, Chaining roles across a feature, Skills & Agents, Skills vs subagents, The 15 skills, The 8 subagents, Why roles?, 1. Core idea: a notes-driven knowledge base (+31 more)

### Community 1 - "Changelog"
Cohesion: 0.04
Nodes (49): [1.0.0] — 2026-06-07, [1.10.0] — 2026-06-10, [1.11.0] — 2026-06-11, [1.11.1] — 2026-06-11, [1.11.2] — 2026-06-11, [1.12.0] — 2026-07-08, [1.1.0] — 2026-06-07, [1.2.0] — 2026-06-07 (+41 more)

### Community 2 - "modular-monolith-saas.md"
Cohesion: 0.08
Nodes (22): Archetype Library — Index, ADR seeds, Confirm per product, monolith-first, platform/ mapping, postgres-rls-multitenancy, Reference deployment, Scale-out / exit path (+14 more)

### Community 3 - "INIT mode — scaffold a new project"
Cohesion: 0.08
Nodes (24): Agent workflow integration, Extraction rules, Guardrails, INIT mode — scaffold a new project, Phase 1: After INIT — define the product, Phase 2: Blueprints — decide the architecture and the API contract, Phase 3: Backend & Infra — implement the API first, Phase 4: UI/UX — draft first, then formal design (+16 more)

### Community 4 - "UX/UI Designer Agent"
Cohesion: 0.09
Nodes (21): 1. Inventory Components, 2. Identify Interactions, 3. Audit for Issues, Accessibility Standards (WCAG 2.1 AA), Component Specification Format, Design System Hierarchy, Friction Analysis, Guardrails (+13 more)

### Community 5 - "Backend Developer Agent"
Cohesion: 0.10
Nodes (20): API Patterns, Auth & Authorization, Authorization check pattern, Backend Developer Agent, Background Jobs, Before building an API endpoint, confirm:, Database Best Practices, Error Handling (+12 more)

### Community 6 - "Frontend Developer Agent"
Cohesion: 0.10
Nodes (20): Accessibility Checklist, Before building a component, confirm:, Common Patterns, Component design, Component Template (TypeScript + Tailwind), Custom Hook Template, Data fetching, Error boundary (+12 more)

### Community 7 - "Install & Maintenance Guide"
Cohesion: 0.11
Nodes (19): 0. Authenticate with GitHub, 1. Install the plugin, 1b. Install the Graphify CLI (recommended — token-efficient repo search), 2. Apply global CLAUDE.md (optional), 3. Apply recommended settings (optional), 4. Install external skills from Anthropic, 5. Start a new project, Directory reference (+11 more)

### Community 8 - "Claude Code Framework"
Cohesion: 0.11
Nodes (19): 1. Install the plugin, 2. Install external skills (optional), 3. Install the Graphify CLI (recommended — saves tokens), 4. Start a new project, 5. Work the stages, 6. Review & Ship, Agent Skills (Role Personas), Bundled Subagents (+11 more)

### Community 9 - "Scrum Master Agent"
Cohesion: 0.12
Nodes (16): 4Ls Format (Liked / Learned / Lacked / Longed For), Customer-Facing Release Notes, Deployment Checklist Template, Guardrails, Internal / Technical Release Notes, Post-Mortems (Incident Analysis), Release Notes, Retrospectives (+8 more)

### Community 10 - "Software Architect Agent"
Cohesion: 0.13
Nodes (14): API Design Principles, Architecture Archetypes (the team library), Architecture Patterns Reference, Data Modeling Principles, Guardrails, How to Handle Inputs, Prisma Schema Template, Scale Thresholds (Rules of Thumb) (+6 more)

### Community 11 - "Design Review Skill"
Cohesion: 0.13
Nodes (14): Competitor / Reference Analysis, Component Extraction Format, Design Review Skill, Figma-Specific Analysis, Guardrails, How to Process a Design Input, Output Format for Figma / Design Spec Analysis, Red Flags to Raise (+6 more)

### Community 12 - "Skill Creator"
Cohesion: 0.13
Nodes (14): After Creating the Skill, Description Field Best Practices, Example: Creating a "SQL Migration Writer" Skill, Guardrails, Multi-File Skill Structure, Persona vs. Tool Skill, Skill Creator, Skill Design Process (+6 more)

### Community 13 - "User Story Skill"
Cohesion: 0.13
Nodes (14): Acceptance Criteria (BDD Format), Estimation Guidance, Full Story Card Format, Given a rough feature request:, Given an existing story to refine:, Given raw requirements or notes:, Guardrails, Processing Inputs (+6 more)

### Community 14 - "Product Owner Agent"
Cohesion: 0.14
Nodes (13): Common Frameworks, Feature Brief, Guardrails, How to Handle Inputs, Output Formats, PO Mindset: Questions to Always Ask, Product Owner Agent, User Story (+5 more)

### Community 15 - "How to Handle Inputs"
Cohesion: 0.15
Nodes (12): Business Advisor Agent, Guardrails, How to Handle Inputs, When asked about competition/positioning:, When asked about pricing:, When asked for unit economics:, When asked "should I incorporate / go premium / raise":, When asked to design the business model: (+4 more)

### Community 16 - "event-driven-microservices.md"
Cohesion: 0.17
Nodes (11): ADR seeds, Confirm per product, cqrs-lite-read-models, database-per-service, microservices-justified-by-split-triggers, platform/ mapping, Reference deployment, Scale-out / exit path (+3 more)

### Community 17 - "mobile-bff.md"
Cohesion: 0.17
Nodes (11): ADR seeds, bff-owns-api-shape, Confirm per product, expo-react-native, platform/ mapping, Reference deployment, Scale-out / exit path, Stack rationale (+3 more)

### Community 18 - "serverless-event-driven.md"
Cohesion: 0.17
Nodes (11): ADR seeds, Confirm per product, event-driven-serverless-core, eventbridge-domain-events, one-lambda-service-per-domain, platform/ mapping, Reference deployment, Scale-out / exit path (+3 more)

### Community 19 - "Claude Code Guide"
Cohesion: 0.18
Nodes (11): Claude Code Guide, CLAUDE.md — project context, CLI entry points, First run, In-session slash commands, Keyboard shortcuts, MCP servers, Permission modes (+3 more)

### Community 20 - "Build Plan Skill"
Cohesion: 0.22
Nodes (8): Build Plan Skill, Deployment Checklist Mode, Example: Stripe Payment Integration Build Plan, How to Generate a Build Plan, Information to gather first, Migration Plan Mode, Plan Format, Sequencing principles

### Community 21 - "AGENTS.md — working context for {{PRODUCT_NAME}}"
Cohesion: 0.22
Nodes (9): 1. What this project is, 2. Reading order, 3. Behavioral rules, 4. Tech stack & architecture principles, 5. Updating the spec from new ideas, 6. Framework skills & agents, AGENTS.md — working context for {{PRODUCT_NAME}}, Always (+1 more)

### Community 22 - "Repo Graph (Graphify)"
Cohesion: 0.22
Nodes (8): 1. Install the CLI (once per machine), 2. Build the graph (once per repo), 3. Where the generated files go, 4. Query instead of reading (the token saving), 5. Turning it off (when full context is needed), 6. Keeping the graph fresh, Guardrails, Repo Graph (Graphify)

### Community 23 - "marketplace.json"
Cohesion: 0.25
Nodes (7): description, name, owner, email, name, plugins, $schema

### Community 24 - "Global Claude Instructions"
Cohesion: 0.25
Nodes (7): Code Quality Defaults, Communication Style, File Editing, Global Claude Instructions, Project Detection, Shell & Commands, Skills Available

### Community 25 - "archetype"
Cohesion: 0.25
Nodes (7): APPLY — pre-fill the architecture docs from an archetype, archetype, EXTRACT — save a product's architecture as a new archetype, Four modes (detect by intent), Guardrails, LIST — show the catalog, SELECT — recommend an archetype for this product

### Community 26 - "Setup Skills"
Cohesion: 0.25
Nodes (7): After installing, Fallback: install via git clone (if marketplace commands fail), Guardrails, Installation steps, Setup Skills, Skills to install, Try the plugin marketplace first (cleanest, no clone needed)

### Community 27 - "Infrastructure — {{PRODUCT_NAME}}"
Cohesion: 0.29
Nodes (6): CI/CD, Cost ballpark, Environments, Hosting, Infrastructure — {{PRODUCT_NAME}}, Observability

### Community 28 - "Security — {{PRODUCT_NAME}}"
Cohesion: 0.29
Nodes (6): Authentication & authorization, Checklist before launch, Compliance, Data protection, Security — {{PRODUCT_NAME}}, Threat considerations

### Community 29 - "Target Market — {{PRODUCT_NAME}}"
Cohesion: 0.29
Nodes (6): Go-to-market notes, Market sizing, *(Persona name)*, Personas, Segments, Target Market — {{PRODUCT_NAME}}

### Community 30 - "UX — {{PRODUCT_NAME}}"
Cohesion: 0.29
Nodes (6): Accessibility notes, Flow: *(name, e.g. "Sign up → first value")*, Interaction specs, Primary user flows, Screen inventory, UX — {{PRODUCT_NAME}}

### Community 31 - "devops-engineer.md"
Cohesion: 0.33
Nodes (5): Before building, Delivery, Guardrails, IaC standard, Pipeline standard

### Community 32 - "frontend-builder.md"
Cohesion: 0.33
Nodes (5): Aesthetic standard, Before writing code, Delivery, Engineering standard, Guardrails

### Community 33 - "API Specification — {{PRODUCT_NAME}}"
Cohesion: 0.33
Nodes (5): API Specification — {{PRODUCT_NAME}}, Conventions, Endpoints / procedures, External APIs consumed, *(Resource or domain)*

### Community 34 - "Financial Model — {{PRODUCT_NAME}}"
Cohesion: 0.33
Nodes (5): Costs, Financial Model — {{PRODUCT_NAME}}, Revenue, Runway / budget constraints, Unit economics

### Community 35 - "Onboarding — {{PRODUCT_NAME}}"
Cohesion: 0.33
Nodes (5): Access checklist, Day 1 — context, Day 1 — environment, Onboarding — {{PRODUCT_NAME}}, Working agreements

### Community 36 - "Runbook — {{PRODUCT_NAME}}"
Cohesion: 0.33
Nodes (5): Deploy, Incident response, Rollback, Routine maintenance, Runbook — {{PRODUCT_NAME}}

### Community 37 - "{{PRODUCT_NAME}} — platform"
Cohesion: 0.33
Nodes (5): Developing locally, Naming convention for services, {{PRODUCT_NAME}} — platform, Target structure, The rule for where code goes

### Community 38 - "backend-builder.md"
Cohesion: 0.40
Nodes (4): Before writing code, Delivery, Engineering standard, Guardrails

### Community 39 - "qa-reviewer.md"
Cohesion: 0.40
Nodes (4): Guardrails, Inputs to gather first, Output format, Review passes (in order)

### Community 40 - "security-reviewer.md"
Cohesion: 0.40
Nodes (4): Guardrails, Inputs to gather first, Output format, Review passes

### Community 41 - "test-engineer.md"
Cohesion: 0.40
Nodes (4): Before writing tests, Guardrails, Run and report, What to write

### Community 42 - "{{PRODUCT_NAME}} — Knowledge Base Index"
Cohesion: 0.40
Nodes (4): Core docs, "I need X → read Y", Optional docs, {{PRODUCT_NAME}} — Knowledge Base Index

### Community 43 - "Competitive Analysis — {{PRODUCT_NAME}}"
Cohesion: 0.40
Nodes (4): Competitive Analysis — {{PRODUCT_NAME}}, Differentiation, Landscape, Positioning statement

### Community 44 - "Brand — {{PRODUCT_NAME}}"
Cohesion: 0.40
Nodes (4): Assets, Brand — {{PRODUCT_NAME}}, Personality & voice, Visual direction

### Community 45 - "Design System — {{PRODUCT_NAME}}"
Cohesion: 0.40
Nodes (4): Component inventory, Design System — {{PRODUCT_NAME}}, Rules, Tokens

### Community 46 - "Backlog — {{PRODUCT_NAME}}"
Cohesion: 0.40
Nodes (4): Backlog — {{PRODUCT_NAME}}, Icebox, Items, Prioritization

### Community 47 - "User Stories — {{PRODUCT_NAME}}"
Cohesion: 0.40
Nodes (4): Stories, Story map, US-001 — *(short title)*, User Stories — {{PRODUCT_NAME}}

### Community 48 - "progress-tracker.md"
Cohesion: 0.50
Nodes (3): Guardrails, Mode A — SYNC-LITE (after a feature/work session lands), Mode B — STATUS REPORT (on demand, read-only)

### Community 49 - "spec-compliance.md"
Cohesion: 0.50
Nodes (3): Checks to run, Guardrails, Output format

## Knowledge Gaps
- **438 isolated node(s):** `$schema`, `name`, `name`, `email`, `description` (+433 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Changelog` connect `Changelog` to `Product Workflow`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Why does `Install & Maintenance Guide` connect `Install & Maintenance Guide` to `Product Workflow`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **Why does `Claude Code Framework` connect `Claude Code Framework` to `Product Workflow`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **What connects `$schema`, `name`, `name` to the rest of the system?**
  _438 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Product Workflow` be split into smaller, more focused modules?**
  _Cohesion score 0.04336734693877551 - nodes in this community are weakly interconnected._
- **Should `Changelog` be split into smaller, more focused modules?**
  _Cohesion score 0.04081632653061224 - nodes in this community are weakly interconnected._
- **Should `modular-monolith-saas.md` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._