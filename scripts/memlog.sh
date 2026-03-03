#!/usr/bin/env bash
set -euo pipefail

TITLE="${1:-Untitled}"
BODY="${2:-}"
DATE_UTC="$(date -u +%F)"
TIME_UTC="$(date -u +%H:%M)"
FILE="/root/.openclaw/workspace/memory/${DATE_UTC}.md"

mkdir -p "$(dirname "$FILE")"
[ -f "$FILE" ] || echo "# ${DATE_UTC}" > "$FILE"

{
  echo
  echo "### ${TIME_UTC} — ${TITLE}"
  [ -n "$BODY" ] && echo "$BODY"
} >> "$FILE"

echo "OK: appended -> $FILE"
