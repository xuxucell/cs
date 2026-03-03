#!/usr/bin/env bash
set -euo pipefail

BASE="/root/.openclaw/workspace"
MEM="$BASE/memory"
TODAY="$(date -u +%F)"
LOG="$MEM/${TODAY}.md"
OUT="$MEM/lessons/${TODAY}-reflection.md"

[ -f "$LOG" ] || { echo "No daily log: $LOG"; exit 0; }

cat > "$OUT" <<EOF
---
id: reflection-${TODAY}
type: lesson
status: active
confidence: medium
last_verified: ${TODAY}
source_refs:
  - ${LOG}
tags:
  - reflection
  - daily
---

## 结论
基于当日日志生成初步反思草稿，待人工或代理二次确认。

## 依据
- 来源：${LOG}

## 可执行动作
1. 检查是否有可沉淀到 decisions/ 与 people/ 的事实。
2. 标注冲突项为 status: conflicted，禁止静默覆盖。
3. 更新 INDEX.md 的最后验证日期。
EOF

echo "OK: generated -> $OUT"
