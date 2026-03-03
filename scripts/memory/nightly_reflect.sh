#!/usr/bin/env bash
set -euo pipefail

BASE="/root/.openclaw/workspace"
MEM="$BASE/memory"
TODAY="$(date -u +%F)"
LOG="$MEM/${TODAY}.md"
LESSON_OUT="$MEM/lessons/${TODAY}-reflection.md"
DECISION_OUT="$MEM/decisions/${TODAY}-decisions.md"
PEOPLE_OUT="$MEM/people/${TODAY}-people.md"

[ -f "$LOG" ] || { echo "No daily log: $LOG"; exit 0; }

# 抽取要点（保守策略：仅提取日志标题行）
POINTS=$(grep -E '^### ' "$LOG" | sed 's/^### //')
[ -n "${POINTS:-}" ] || POINTS="无可提取标题，建议人工补充。"

cat > "$LESSON_OUT" <<EOF
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
当日日志已完成自动反思草稿生成，可继续二次提炼。

## 依据
${POINTS}

## 可执行动作
1. 从标题中提取可复用方法，沉淀到 lessons/。
2. 对存在冲突的信息标注 status: conflicted。
3. 运行 index_refresh.sh 刷新导航健康度日期。
EOF

cat > "$DECISION_OUT" <<EOF
---
id: decisions-${TODAY}
type: decision
status: active
confidence: medium
last_verified: ${TODAY}
source_refs:
  - ${LOG}
tags:
  - daily
  - decisions
---

## 结论
今日决策草稿已生成（需人工确认是否为最终决策）。

## 依据
${POINTS}

## 可执行动作
1. 将明确决策改写为单独 decision 文件。
2. 不明确项保持草稿，不进入长期结论。
EOF

cat > "$PEOPLE_OUT" <<EOF
---
id: people-${TODAY}
type: person
status: active
confidence: low
last_verified: ${TODAY}
source_refs:
  - ${LOG}
tags:
  - daily
  - people
---

## 结论
今日人物相关信息草稿（低置信度）已生成。

## 依据
${POINTS}

## 可执行动作
1. 将已确认的人物偏好迁移到 people/独立文件。
2. 未确认信息不提升置信度。
EOF

bash "$BASE/scripts/memory/index_refresh.sh" >/dev/null 2>&1 || true

echo "OK: generated -> $LESSON_OUT"
echo "OK: generated -> $DECISION_OUT"
echo "OK: generated -> $PEOPLE_OUT"