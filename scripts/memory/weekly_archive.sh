#!/usr/bin/env bash
set -euo pipefail

BASE="/root/.openclaw/workspace"
MEM="$BASE/memory"
ARC="$MEM/.archive"
KEEP_DAYS="${KEEP_DAYS:-30}"
TODAY="$(date -u +%F)"

mkdir -p "$ARC"
shopt -s nullglob
for f in "$MEM"/20??-??-??.md; do
  name="$(basename "$f")"
  # 跳过今天
  [ "$name" = "${TODAY}.md" ] && continue

  # 文件老于 KEEP_DAYS 才归档
  if find "$f" -mtime +"$KEEP_DAYS" | grep -q .; then
    # 被 lessons/decisions/people/projects 引用则跳过
    if grep -R "${name%.md}" "$MEM"/{lessons,decisions,people,projects} >/dev/null 2>&1; then
      echo "SKIP referenced: $name"
      continue
    fi
    mv "$f" "$ARC/$name"
    echo "ARCHIVED: $name"
  fi
done
