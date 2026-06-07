# Quick Start — orpexp-devkit

The fastest way to start building with Claude Code. Install once, use on every product.

---

## 1. Install (one-time, ~2 min)

```bash
git clone git@github.com:orpexp/orpexp-devkit.git ~/claude-framework
claude plugin add ~/claude-framework
bash ~/claude-framework/scripts/install-external-skills.sh
# Manual fallback: cp -r ~/claude-framework/skills/* ~/.claude/skills/
```

Verify: open Claude Code and run `/help` — you should see all skills listed.

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

This creates the full project structure (`documents/`, `.ai/`, `platform/`) and extracts your notes into structured knowledge-base documents. No stack decisions yet — that comes next.

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
| [INSTALL.md](INSTALL.md) | Team onboarding, external skills, factory reset |
| [docs/](docs/) | Deep-dive guides (workflow, agents, architecture) |
