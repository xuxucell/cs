#!/usr/bin/env bash
set -euo pipefail

BASE="/root/.openclaw/workspace"
MEM="$BASE/memory"
TODAY="$(date -u +%F)"
OUT="$MEM/decisions/conflict-report-${TODAY}.md"

{
  echo "# Conflict Report ${TODAY}"
  echo
  echo "以下文件标记为 status: conflicted："
  echo
  grep -R --include='*.md' -n '^status: conflicted' "$MEM"/{lessons,decisions,people,projects} 2>/dev/null | sed 's|/root/.openclaw/workspace/||' || true
} > "$OUT"

echo "OK: generated -> $OUT"