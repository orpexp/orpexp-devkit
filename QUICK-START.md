# Quick Start — orpexp-devkit

The fastest way to start building with Claude Code. Install once, use on every product.

---

## 1. Install (one-time, ~2 min)

> **Private repo:** You need `gh` (GitHub CLI) authenticated with `orpexp` org access before running these commands. See [INSTALL.md](INSTALL.md) § 0 if you haven't done this yet.

```bash
# Register the orpexp plugin source (one-time)
claude plugin marketplace add orpexp/orpexp-devkit

# Install the plugin — auto-loads all skills
claude plugin install orpexp-devkit
```

Then open Claude Code and run:

```
/setup-skills
```

This installs Anthropic's 5 official external skills (`frontend-design`, `webapp-testing`, `mcp-builder`, `skill-creator`, `simplify`). No repo clone needed.

Verify with `/help` — you should see all skills listed.

---

## 2. Start a new product

```bash
mkdir my-product && cd my-product
claude
```

Inside Claude Code, paste your raw idea notes and run:

```
/product-init
"Here are my idea notes: [paste your notes]"
```

This generates the full project structure (`CLAUDE.md`, `.ai/`, `documents/`, `platform/`) and extracts your notes into structured knowledge-base docs. No template to copy — the skill builds everything.

---

## 3. Build it — stage by stage

```
/product-owner  "Refine requirements and resolve open questions"
/architect      "Decide the tech stack and system architecture"
/build-plan     "Generate the implementation plan for MVP"
/frontend-dev   "Build the [component]"
/backend-dev    "Implement the [API endpoint]"
```

---

## 4. Review & ship

```
/webapp-testing  "Write tests for [feature]"
/code-review     (built-in — review current branch changes)
/scrum-master    "Plan this sprint" | "Write release notes"
```

---

## That's it

| Resource | Purpose |
|---|---|
| [CHEATSHEET.md](CHEATSHEET.md) | Full command reference, every stage |
| [INSTALL.md](INSTALL.md) | Team onboarding, global config, factory reset |
| [docs/](docs/) | Deep-dive guides (workflow, agents, architecture) |
