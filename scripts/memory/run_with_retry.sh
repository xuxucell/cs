#!/usr/bin/env bash
set -euo pipefail

# 用法：run_with_retry.sh "<command>" [label]
CMD="${1:-}"
LABEL="${2:-task}"

[[ -z "$CMD" ]] && { echo "Usage: $0 \"<command>\" [label]"; exit 1; }

echo "[START] $LABEL"
if bash -lc "$CMD"; then
  echo "[OK] $LABEL first run"
  exit 0
fi

echo "[RETRY] $LABEL first run failed, retrying once..."
if bash -lc "$CMD"; then
  echo "[OK] $LABEL second run"
  exit 0
fi

echo "[FAIL] $LABEL failed twice"
exit 1
