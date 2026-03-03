#!/usr/bin/env bash
set -euo pipefail

BASE="/root/.openclaw/workspace/memory"
OUT="$BASE/decisions/stale-report-$(date -u +%F).md"
TODAY_SEC=$(date -u +%s)
THRESHOLD_DAYS="${THRESHOLD_DAYS:-30}"

echo "# Stale Report $(date -u +%F)" > "$OUT"
echo >> "$OUT"

scan_dir() {
  local dir="$1"
  for f in "$BASE/$dir"/*.md; do
    [[ -e "$f" ]] || continue
    lv=$(grep -E '^last_verified:' "$f" | head -n1 | awk '{print $2}') || true
    [[ -z "${lv:-}" ]] && continue
    lv_sec=$(date -u -d "$lv" +%s 2>/dev/null || echo 0)
    [[ "$lv_sec" -eq 0 ]] && continue
    age_days=$(( (TODAY_SEC - lv_sec) / 86400 ))
    if (( age_days > THRESHOLD_DAYS )); then
      echo "- [stale] $dir/$(basename "$f") | last_verified=$lv | age=${age_days}d" >> "$OUT"
    fi
  done
}

scan_dir lessons
scan_dir decisions
scan_dir people
scan_dir projects

echo "OK: generated -> $OUT"
