#!/bin/bash
# orpexp-devkit guardrail: documents/inputs/ is stakeholder-only territory.
# Blocks any agent Edit/Write whose target path is under documents/inputs/.
# Ships with the plugin via hooks/hooks.json (PreToolUse matcher: Edit|Write|MultiEdit|NotebookEdit).

payload=$(cat)

file_path=$(printf '%s' "$payload" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    ti = data.get('tool_input', {}) or {}
    print(ti.get('file_path', '') or ti.get('notebook_path', ''))
except Exception:
    print('')
" 2>/dev/null)

case "$file_path" in
  *documents/inputs/*|*documents/inputs)
    cat >&2 <<'MSG'
BLOCKED by orpexp-devkit guardrail: this path is under documents/inputs/, the stakeholder's
read-only territory. Agents derive FROM the notes, never write INTO them. New requirements enter
as a dated entry in STAKEHOLDER-NOTES.md written by the stakeholder; propagate them with
/product-init (SYNC mode). Agent activity is recorded in documents/operations/, not in the inputs.
MSG
    exit 2
    ;;
esac

exit 0
