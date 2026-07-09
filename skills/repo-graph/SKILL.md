---
name: repo-graph
description: >-
  Set up and use Graphify — a knowledge graph of the repository that agents query instead of
  grepping/reading files, cutting token usage. Use when the user wants to: install or set up
  graphify, build/rebuild the repo knowledge graph, query the graph ("what connects X to Y?"),
  keep the graph fresh on commits, or turn the graph-first nudge on/off. Run once per repository;
  the plugin's graph-first hook then nudges every agent session toward the graph automatically.
---

# Repo Graph (Graphify)

You set up and operate [Graphify](https://github.com/Graphify-Labs/graphify) for the current
repository. Graphify parses the codebase locally (tree-sitter AST — no LLM calls, no API key)
into a queryable knowledge graph. Once built, agents answer "how does X connect to Y?" with one
scoped `graphify query` instead of reading dozens of files — that is the token saving.

The orpexp-devkit plugin already ships the **graph-first hook** (`hooks/graph-first.sh`): in any
project that has a built graph, it nudges agents toward the graph before search-style tool calls.
Projects without a graph are never nudged. You only need to install the CLI once per machine and
build the graph once per repo.

**Where the graph lives:** `.ai/graph/` — inside the agent-context folder, keeping the repo root
clean (`CLAUDE.md`, `README.md`, `.ai/`, `documents/`, `platform/` only). This is set with the
`GRAPHIFY_OUT` env var, which Graphify honors for **every** command (build, query, path, explain,
report) and which the plugin hook honors for detection — so the CLI and the hook always agree on
the location. In an orpexp project scaffolded by `/product-init`, `.claude/settings.json` already
sets `GRAPHIFY_OUT=.ai/graph`, so you can skip step 2's settings step there.

---

## 1. Install the CLI (once per machine)

```bash
uv tool install graphifyy        # package is graphifyy (double y), command is graphify
# no uv? → pipx install graphifyy   (or: brew install uv, then retry)
graphify install                 # registers the /graphify skill with Claude Code (user scope)
```

- If `graphify` isn't found afterwards: `uv tool update-shell` (or `pipx ensurepath`), then open a new terminal.
- Requires Python 3.10+. No API key is ever needed — never ask the user for one.
- Do **NOT** run `graphify claude install` — that would wire a second, per-project copy of the
  same PreToolUse nudge this plugin already ships. The plugin hook is the single mechanism.

## 2. Point Graphify at `.ai/graph/` (once per repo)

In an orpexp workspace scaffolded by `/product-init`, this is already done — skip to step 3.
Otherwise, tell Graphify (and the plugin hook) to use `.ai/graph/` instead of the root
`graphify-out/`, by adding an `env` block to the project's `.claude/settings.json`:

```json
{
  "env": {
    "GRAPHIFY_OUT": ".ai/graph"
  }
}
```

Merge into any existing `.claude/settings.json` — don't clobber other keys. Claude Code injects
this into the session, so both the agent's `graphify` Bash calls and the graph-first hook resolve
`.ai/graph/`. **Restart Claude Code** after adding it so the session picks it up.

## 3. Build the graph (once per repo)

```bash
GRAPHIFY_OUT=.ai/graph /graphify .    # build — code is AST-extracted locally, free
```

The inline `GRAPHIFY_OUT=` makes the first build land in `.ai/graph/` even before a Claude Code
restart. After the restart (step 2) the env var is ambient and you can just run `/graphify .`.

Then make the output placement correct (below) and commit.

## 4. Where the generated files go

Graphify writes everything under **`.ai/graph/`** (via `GRAPHIFY_OUT`). It is generated agent
tooling — like a lockfile, not knowledge-base content — so it lives in `.ai/` (agent context),
never in the repo root and never in `documents/`.

| File | What | Commit? |
|---|---|---|
| `.ai/graph/graph.json` | the queryable graph | ✅ yes — teammates start with a map |
| `.ai/graph/GRAPH_REPORT.md` | highlights + suggested questions | ✅ yes |
| `.ai/graph/graph.html` | interactive visualization | ✅ yes |
| `.ai/graph/cost.json` | local run stats | ❌ gitignore |
| `.ai/graph/cache/` | extraction cache | ❌ gitignore (optional to commit) |

Add to `.gitignore`:

```gitignore
.ai/graph/cost.json
.ai/graph/cache/
```

Add to `.claudeignore` (protects the prompt cache — graph writes would otherwise invalidate it;
the rest of `.ai/` stays readable):

```
.ai/graph/
```

## 5. Query instead of reading (the token saving)

```bash
graphify query "what connects auth to the database?"   # scoped subgraph for a question
graphify path UserService DatabasePool                  # shortest path between two things
graphify explain RateLimiter                            # one node, with its edges
```

Reach for the graph first for architecture/relationship questions ("what calls X?", "trace the
flow of Y"). Read actual files when you need exact code to edit — the graph tells you *which*
files those are.

## 6. Turning it off (when full context is needed)

Sometimes an agent genuinely needs to read broadly. Kill switches, from narrow to broad:

```bash
touch .graphify-off              # this repo: silence the graph-first nudge (delete to re-enable)
export GRAPHIFY_HOOK_OFF=1       # this shell/session: silence the nudge
graphify uninstall --purge       # remove everything incl. .ai/graph/ (last resort)
```

The nudge is advisory — it never blocks a tool call. Deleting `.ai/graph/graph.json` also
silences it (no graph → no nudge).

## 7. Keeping the graph fresh

- Rebuild through the agent after code changes: `/graphify .` (with `GRAPHIFY_OUT=.ai/graph`
  ambient from `.claude/settings.json`) — AST only, free. `/graphify . --update` re-extracts
  only changed files.
- **Optional git auto-rebuild** (`graphify hook install`): installs a post-commit hook that
  rebuilds on every commit plus a merge driver that prevents `graph.json` conflicts. Caveat: the
  git hook runs **outside** Claude Code, so it does **not** see `.claude/settings.json` and will
  rebuild to the default `graphify-out/` unless `export GRAPHIFY_OUT=.ai/graph` is in your shell
  rc (`~/.zshrc`). If you don't want to touch your shell rc, skip the git hook and rebuild through
  the agent instead. Re-run `graphify hook install` after upgrading graphify (it pins the
  interpreter path). Skip one rebuild with `GRAPHIFY_SKIP_HOOK=1 git commit`.

---

## Guardrails

- Never block on or ask for an API key — code extraction is local and free by design.
- Keep the graph at `.ai/graph/` (set via `GRAPHIFY_OUT`); never let it land in the repo root
  (`graphify-out/`) or in `documents/`. If you see a root `graphify-out/`, the `GRAPHIFY_OUT` env
  var wasn't set — fix `.claude/settings.json` and rebuild.
- Commit `.ai/graph/` (minus cost.json/cache) so teammates inherit the graph instead of rebuilding.
- If `graphify query` errors with a version-mismatch message, run `uv tool upgrade graphifyy` then `graphify install`.
- The graph can be stale right after big refactors — rebuild before trusting it, or verify in the files.
