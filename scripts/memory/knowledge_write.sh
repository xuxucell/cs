#!/usr/bin/env bash
set -euo pipefail

# 用法：knowledge_write.sh <type> <slug> <conclusion> [reason] [actions]
# type: lesson|decision|person|project

TYPE="${1:-}"
SLUG="${2:-}"
CONCLUSION="${3:-}"
REASON="${4:-}"
ACTIONS="${5:-}"

[[ -z "$TYPE" || -z "$SLUG" || -z "$CONCLUSION" ]] && {
  echo "Usage: $0 <type> <slug> <conclusion> [reason] [actions]"
  exit 1
}

case "$TYPE" in
  lesson) DIR="lessons" ;;
  decision) DIR="decisions" ;;
  person) DIR="people" ;;
  project) DIR="projects" ;;
  *) echo "Invalid type: $TYPE"; exit 1 ;;
esac

BASE="/root/.openclaw/workspace/memory"
FILE="$BASE/$DIR/${SLUG}.md"
TODAY="$(date -u +%F)"

mkdir -p "$(dirname "$FILE")"

# 先读再写：存在则做去重与冲突检查
if [[ -f "$FILE" ]]; then
  OLD_CONCLUSION="$(awk '/^## 结论/{flag=1;next}/^## /{flag=0}flag' "$FILE" | sed '/^$/d' | tr '\n' ' ' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//')"

  if [[ "$OLD_CONCLUSION" == "$CONCLUSION" ]]; then
    echo "NOOP: same conclusion -> $FILE"
    exit 0
  fi

  STATUS="conflicted"
  CONFIDENCE="medium"
else
  STATUS="active"
  CONFIDENCE="medium"
fi

cat > "$FILE" <<EOF
---
id: ${TYPE}-${SLUG}
type: ${TYPE}
status: ${STATUS}
confidence: ${CONFIDENCE}
last_verified: ${TODAY}
source_refs: []
tags: []
---

## 结论
${CONCLUSION}

## 依据
${REASON}

## 可执行动作
${ACTIONS}
EOF

echo "OK: wrote -> $FILE (status=$STATUS)"
