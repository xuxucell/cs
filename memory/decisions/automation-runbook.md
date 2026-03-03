---
id: decision-automation-runbook
type: decision
status: active
confidence: high
last_verified: 2026-03-03
source_refs:
  - scripts/memory/*.sh
tags:
  - automation
  - memory
  - runbook
---

## 结论
记忆系统采用“串行任务链 + 单次自动重试”策略，保证稳定性优先。

## 依据
- 任务依赖明显：反思 → stale 扫描 → 冲突报告 → 周归档/健康评分。
- 定时任务存在偶发失败风险，单次重试可覆盖瞬时异常。

## 可执行动作
1. 所有 cron 任务统一通过 `run_with_retry.sh` 执行。
2. 每日任务按顺序运行，避免并发写冲突。
3. 每周任务与每日任务错峰，避免 I/O 抢占。

## 任务链时间线（Asia/Shanghai）
### 每日
- 23:45 `nightly-memory-reflection`
  - 执行：`nightly_reflect.sh`
  - 产物：lessons/decisions/people 当日草稿
- 23:50 `daily-memory-stale-scan`
  - 执行：`stale_scan.sh`
  - 产物：stale-report
- 23:55 `daily-memory-conflict-report`
  - 执行：`conflict_report.sh`
  - 产物：conflict-report

### 每周（周日）
- 00:00 `weekly-memory-archive`
  - 执行：`weekly_archive.sh`
  - 产物：归档动作日志
- 00:10 `weekly-index-health-score`
  - 执行：`index_health_weekly.sh`
  - 产物：index-health 评分报告

## 失败重试策略（一次重跑）
- 执行器：`scripts/memory/run_with_retry.sh`
- 策略：
  1) 首次执行失败 => 立即重跑一次
  2) 第二次仍失败 => 返回失败并在 cron 回执中报告
- 目的：屏蔽偶发网络/文件锁抖动，不掩盖持续性错误

## 故障处理规则
1. 连续 2 天同一任务失败：暂停该任务并人工排查。
2. 报告文件缺失：优先检查脚本执行权限和路径。
3. 出现 conflicted 增长：先处理冲突，再新增知识沉淀。
