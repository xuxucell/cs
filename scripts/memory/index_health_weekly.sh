#!/usr/bin/env bash
set -euo pipefail

BASE="/root/.openclaw/workspace"
MEM="$BASE/memory"
TODAY="$(date -u +%F)"
OUT="$MEM/decisions/index-health-${TODAY}.md"

count_status() {
  local status="$1"
  (grep -R --include='*.md' -h "^status: ${status}" "$MEM"/{lessons,decisions,people,projects} 2>/dev/null || true) | wc -l | tr -d ' '
}

ACTIVE=$(count_status active)
STALE=$(count_status stale)
CONFLICTED=$(count_status conflicted)
DEPRECATED=$(count_status deprecated)
TOTAL=$((ACTIVE + STALE + CONFLICTED + DEPRECATED))

# 简单评分：active+1, stale-1, conflicted-2, deprecated-1
SCORE=$((ACTIVE - STALE - 2*CONFLICTED - DEPRECATED))

cat > "$OUT" <<EOF
# INDEX Health ${TODAY}

- total: ${TOTAL}
- active: ${ACTIVE}
- stale: ${STALE}
- conflicted: ${CONFLICTED}
- deprecated: ${DEPRECATED}
- score: ${SCORE}

## 结论
- score >= 0：知识库可用
- score < 0：需要优先处理 stale/conflicted
EOF

echo "OK: generated -> $OUT"