#!/bin/bash
# Install official Anthropic skills into your Claude global skills directory.
# These are maintained by Anthropic and fetched directly from their GitHub repos.
#
# Usage: bash scripts/install-external-skills.sh
# Override install dir: CLAUDE_SKILLS_DIR=/custom/path bash scripts/install-external-skills.sh
set -e

SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$SKILLS_DIR"

echo "Installing external Anthropic skills to $SKILLS_DIR ..."
echo ""

# ── anthropics/skills ──────────────────────────────────────────────────────────
TMP_SKILLS="/tmp/_anthropic-skills-$$"
echo "Fetching anthropics/skills ..."
if command -v gh &>/dev/null; then
  gh repo clone anthropics/skills "$TMP_SKILLS" -- --depth=1 --quiet
else
  git clone --depth=1 --quiet https://github.com/anthropics/skills "$TMP_SKILLS"
fi

for skill in frontend-design webapp-testing mcp-builder skill-creator; do
  if [ -d "$TMP_SKILLS/$skill" ]; then
    rm -rf "$SKILLS_DIR/$skill"
    cp -r "$TMP_SKILLS/$skill" "$SKILLS_DIR/$skill"
    echo "  ✓ $skill"
  else
    echo "  ✗ $skill — not found in repo (check folder name at github.com/anthropics/skills)"
  fi
done
rm -rf "$TMP_SKILLS"

# ── anthropics/claude-code (simplify) ─────────────────────────────────────────
TMP_CC="/tmp/_anthropic-cc-$$"
echo ""
echo "Fetching anthropics/claude-code (for 'simplify') ..."
if command -v gh &>/dev/null; then
  gh repo clone anthropics/claude-code "$TMP_CC" -- --depth=1 --quiet
else
  git clone --depth=1 --quiet https://github.com/anthropics/claude-code "$TMP_CC"
fi

SIMPLIFY_SRC="$TMP_CC/.claude/skills/simplify"
if [ -d "$SIMPLIFY_SRC" ]; then
  rm -rf "$SKILLS_DIR/simplify"
  cp -r "$SIMPLIFY_SRC" "$SKILLS_DIR/simplify"
  echo "  ✓ simplify"
else
  echo "  ✗ simplify — not found at .claude/skills/simplify (check the repo structure)"
fi
rm -rf "$TMP_CC"

echo ""
echo "Done. Installed skills:"
for skill in frontend-design webapp-testing mcp-builder skill-creator simplify; do
  [ -d "$SKILLS_DIR/$skill" ] && echo "  $skill" || echo "  $skill (missing — see warnings above)"
done
echo ""
echo "Restart Claude Code and run /help to see all skills."
