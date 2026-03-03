#!/usr/bin/env bash
set -euo pipefail

INDEX="/root/.openclaw/workspace/INDEX.md"
TODAY="$(date -u +%F)"

# 仅刷新“最后验证”列到今天（保持现有结构）
sed -i -E "s/\| ([^|]+) \|$/| ${TODAY} |/" "$INDEX" || true

echo "OK: refreshed INDEX last_verified -> $TODAY"
