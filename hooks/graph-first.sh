#!/bin/bash
# orpexp-devkit graph-first nudge: when the current project has a Graphify knowledge
# graph, remind the agent to query the graph instead of grepping / reading source
# files one by one — that is what saves tokens.
# Ships with the plugin via hooks/hooks.json (PreToolUse matchers: Bash, Read|Glob|Grep).
#
# The graph's location is configurable via GRAPHIFY_OUT (default "graphify-out"; the
# orpexp product template sets it to ".ai/graph" via .claude/settings.json to keep the
# repo root clean). This hook honors that override for detection, and graphify's own
# CLI honors it for read/write — so the two stay in lockstep wherever the graph lives.
#
# Delegates the actual decision to `graphify hook-guard <search|read>` (the same
# mechanism `graphify claude install` would wire per-project), so nudge wording and
# matching logic always come from the installed graphify version.
#
# ALWAYS fails open: any missing prerequisite exits 0 with no output, so no tool
# call is ever blocked. Turn the nudge OFF when you need full-context reading:
#   touch .graphify-off          # per-project kill switch (delete the file to re-enable)
#   export GRAPHIFY_HOOK_OFF=1   # per-shell/per-session kill switch
kind="$1"

# Kill switches — the "need more context" escape hatch.
[ "${GRAPHIFY_HOOK_OFF:-0}" = "1" ] && exit 0
[ -e ".graphify-off" ] && exit 0

# Only projects that actually built a graph get nudged.
out_dir="${GRAPHIFY_OUT:-graphify-out}"
[ -f "$out_dir/graph.json" ] || exit 0

# Resolve the graphify CLI (hooks often run without the user's full PATH).
graphify_bin=$(command -v graphify 2>/dev/null)
[ -z "$graphify_bin" ] && [ -x "$HOME/.local/bin/graphify" ] && graphify_bin="$HOME/.local/bin/graphify"
[ -z "$graphify_bin" ] && exit 0

"$graphify_bin" hook-guard "$kind" 2>/dev/null || true
exit 0
