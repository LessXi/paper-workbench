---
description: 工作台总览：台账盘点、卡点诊断、下一步建议
---

# /paper-lab：台账盘点

## 1. 盘点

读 `registry.md`，统计各状态数量（待读/在读/已读/复现中/已复现/复现不可行），列出：

- **待读队列**：按评分降序，标注最该先读的 1-2 篇及理由
- **进行中**：在读/复现中的论文，检查对应目录产物完整度（精读笔记? log.md?），指出卡在哪一步
- **久拖未动**：待读超过一个月的条目，建议处理（升优先/降级/移除）

## 2. 资产盘点

- `refs.bib` 条目数与 `library/` 目录数是否一致（不一致 → 补齐）
- 精读笔记数（library/<论文>/<论文标题>.md）与 registry 已读数是否一致（工作区即 vault，可用 Papers.base 验证）
- `topics/` 下 survey/watch digest 一览

## 3. 建议

综合给出下一步 3 个选项（如：`/paper-read X`、`/paper-reproduce Y` 续作、`/paper-survey Z` 开新线），各配一句理由。

## 4. 追新（可选）

若存在 watch 订阅且用户询问近况，顺手 `check_alerts` 汇报新论文。
