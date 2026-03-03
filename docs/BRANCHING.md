# Branching Strategy

## 结论
- `main`：唯一开发与自动发布分支（GitHub Actions 已绑定）
- `master`：兼容保留分支，不再直接开发

## 规则
1. 日常提交只进 `main`
2. 需要给旧流程兼容时，再把 `main` 合并到 `master`
3. 不在 `master` 直接改代码
4. 禁止强推、禁止重写历史

## 当前状态
- `main`：最新业务代码（博客+自动发布+cat-photos）
- `master`：历史兼容分支（已合并一次 main）
